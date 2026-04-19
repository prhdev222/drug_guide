#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
นำเข้ารายการยา NLEM ทั้งชุดจาก media.xlsx (แบบ สธ. / NLEM Excel) เข้า Turso

โครงสร้างไฟล์ที่รองรับ (sheet แรก):
  M = บัญชีย่อยเดิม (ก ข ค ง จ(1) จ(2) …)
  J = generic_name, K = dosage, L = strength_salt
  A,C,E,G = ลำดับกลุ่มยา, O,P,Q,R = เงื่อนไข/คำเตือน/หมายเหตุ

การใช้งาน:
  python scripts/import-nlem-from-xlsx.py --dry-run
  python scripts/import-nlem-from-xlsx.py --sql-out data/nlem-national-import.sql
  python scripts/import-nlem-from-xlsx.py --execute-turso   # ต้องมี TURSO_URL + TURSO_AUTH_TOKEN

ค่าเริ่มต้น:
  --replace-nlem  ลบยาเดิมที่ listing_scope=nlem ในบัญชี ก–จ₂ ก่อน insert (ไม่แตะหมวด NON)

หมายเหตุ:
  - แถวที่ M = \"เพิ่ม\" จะข้าม (มักเป็นหมวดเปลี่ยนแปลงเฉพาะรุ่น Excel)
  - แถว ก,ข จะแทรก 2 แถว (ทั้ง ก และ ข) เพื่อให้กรองตามการ์ดได้
"""

from __future__ import annotations

import argparse
import json
import os
import re
import sys
import urllib.error
import urllib.request
import zipfile
import xml.etree.ElementTree as ET

NS = {"main": "http://schemas.openxmlformats.org/spreadsheetml/2006/main"}


def load_shared_strings(z: zipfile.ZipFile) -> list[str]:
    root = ET.fromstring(z.read("xl/sharedStrings.xml"))
    return ["".join(si.itertext()) for si in root.findall(".//main:si", NS)]


def cell_text(c: ET.Element, strings: list[str]) -> str:
    v_el = c.find("main:v", NS)
    if v_el is None or v_el.text is None:
        return ""
    if c.attrib.get("t") == "s":
        return strings[int(v_el.text)]
    return v_el.text


def parse_sheet1_rows(z: zipfile.ZipFile, strings: list[str]) -> list[dict[str, str]]:
    sh = ET.fromstring(z.read("xl/worksheets/sheet1.xml"))
    rows_out: list[dict[str, str]] = []
    for row in sh.findall(".//main:sheetData/main:row", NS):
        row_dict: dict[str, str] = {}
        for c in row.findall("main:c", NS):
            ref = c.attrib["r"]
            col = re.match(r"^([A-Z]+)", ref).group(1)
            row_dict[col] = cell_text(c, strings)
        rows_out.append(row_dict)
    return rows_out


def map_account(raw: str) -> list[str] | None:
    """คืนรายการ category_id (ก ข ค ง จ1 จ2)"""
    if not raw:
        return None
    s = raw.strip()
    if not s or s == "-":
        return None
    if s == "เพิ่ม":
        return None
    if s == "ก":
        return ["ก"]
    if s == "ข":
        return ["ข"]
    if s == "ค":
        return ["ค"]
    if s == "ง":
        return ["ง"]
    if s in ("จ(1)", "จ1"):
        return ["จ1"]
    if s in ("จ(2)", "จ2"):
        return ["จ2"]
    if s == "ก, ข":
        return ["ก", "ข"]
    return None


def build_name_en(row: dict[str, str]) -> str | None:
    base = (row.get("J") or "").strip()
    if not base:
        return None
    extras: list[str] = []
    k = (row.get("K") or "").strip()
    ell = (row.get("L") or "").strip()
    if k and k != "-":
        extras.append(k)
    if ell and ell != "-":
        extras.append(ell)
    if extras:
        base = base + " — " + " · ".join(extras)
    return base


def build_drug_group(row: dict[str, str]) -> str | None:
    parts = []
    for key in ("A", "C", "E", "G"):
        v = (row.get(key) or "").strip()
        if v and v != "-":
            parts.append(v)
    return " · ".join(parts) if parts else None


def build_notes(row: dict[str, str]) -> str | None:
    chunks = []
    for lab, key in (
        ("เงื่อนไข", "O"),
        ("คำเตือน", "P"),
        ("หมายเหตุ", "Q"),
        ("อื่นๆ", "R"),
    ):
        v = (row.get(key) or "").strip()
        if v and v != "-":
            chunks.append(f"{lab}: {v}")
    return "\n".join(chunks) if chunks else None


def sql_escape(s: str) -> str:
    return s.replace("'", "''")


def encode_pipeline_args(values: list) -> list[dict]:
    out = []
    for v in values:
        if v is None:
            out.append({"type": "null"})
        elif isinstance(v, bool):
            out.append({"type": "integer", "value": "1" if v else "0"})
        elif isinstance(v, int):
            out.append({"type": "integer", "value": str(v)})
        elif isinstance(v, float):
            out.append({"type": "float", "value": repr(v)})
        else:
            out.append({"type": "text", "value": str(v)})
    return out


def turso_execute(base: str, token: str, sql: str, args: list | None = None) -> None:
    url = base.rstrip("/") + "/v2/pipeline"
    stmt = {"sql": sql}
    if args:
        stmt["args"] = encode_pipeline_args(args)
    body = json.dumps(
        {"requests": [{"type": "execute", "stmt": stmt}, {"type": "close"}]}
    ).encode("utf-8")
    req = urllib.request.Request(
        url,
        data=body,
        headers={
            "Authorization": f"Bearer {token}",
            "Content-Type": "application/json",
        },
        method="POST",
    )
    with urllib.request.urlopen(req, timeout=120) as resp:
        status = resp.status
        raw = resp.read().decode("utf-8")
    data = json.loads(raw)
    if status != 200:
        raise RuntimeError(raw[:500])
    r0 = data.get("results", [{}])[0]
    if r0.get("type") == "error":
        raise RuntimeError(r0.get("error", {}).get("message", str(r0)))


def main() -> int:
    ap = argparse.ArgumentParser(description="Import NLEM Excel → Turso / SQL")
    ap.add_argument(
        "--xlsx",
        default="media.xlsx",
        help="path to media.xlsx (project root)",
    )
    ap.add_argument("--dry-run", action="store_true", help="แสดงจำนวนแถวและตัวอย่างเท่านั้น")
    ap.add_argument("--sql-out", help="เขียนไฟล์ SQL (SQLite/Turso)")
    ap.add_argument(
        "--execute-turso",
        action="store_true",
        help="รันเข้า Turso ผ่าน HTTP (ต้องมี TURSO_URL, TURSO_AUTH_TOKEN)",
    )
    ap.add_argument(
        "--replace-nlem",
        action="store_true",
        default=True,
        help="ลบยา NLEM เดิมในบัญชี ก–จ₂ ก่อน insert (ค่าเริ่มต้น: เปิด)",
    )
    ap.add_argument(
        "--no-replace-nlem",
        action="store_false",
        dest="replace_nlem",
        help="ไม่ลบของเดิม (อาจซ้ำชื่อถ้ารันซ้ำ)",
    )
    args = ap.parse_args()

    root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    xlsx_path = args.xlsx if os.path.isabs(args.xlsx) else os.path.join(root, args.xlsx)
    if not os.path.isfile(xlsx_path):
        print(f"❌ ไม่พบไฟล์: {xlsx_path}", file=sys.stderr)
        return 1

    with zipfile.ZipFile(xlsx_path, "r") as z:
        strings = load_shared_strings(z)
        rows = parse_sheet1_rows(z, strings)

    if len(rows) < 2:
        print("❌ ไม่มีข้อมูลใน sheet", file=sys.stderr)
        return 1

    header = rows[0]
    data_rows = rows[1:]

    prepared: list[tuple[str, str, str | None, str | None, int]] = []
    skipped = {"no_cat": 0, "no_name": 0, "skip_tag": 0}

    sort_by_cat: dict[str, int] = {}

    for row in data_rows:
        cats = map_account(row.get("M", ""))
        if cats is None:
            skipped["no_cat"] += 1
            continue
        name_en = build_name_en(row)
        if not name_en:
            skipped["no_name"] += 1
            continue
        dg = build_drug_group(row)
        notes = build_notes(row)
        for cid in cats:
            sort_by_cat[cid] = sort_by_cat.get(cid, 0) + 1
            so = sort_by_cat[cid]
            prepared.append((cid, name_en, dg, notes, so))

    print(f"📋 จาก Excel: {len(data_rows)} แถวข้อมูล → {len(prepared)} แถวยา (หลังแตก ก,ข)")
    print(f"   ข้ามไม่มีบัญชี: {skipped['no_cat']} · ไม่มีชื่อยา: {skipped['no_name']}")

    if args.dry_run:
        by_c = {}
        for cid, *_ in prepared:
            by_c[cid] = by_c.get(cid, 0) + 1
        for k in sorted(by_c.keys()):
            print(f"   · {k}: {by_c[k]} รายการ")
        print("\nตัวอย่าง 3 แถวแรก:")
        for row in prepared[:3]:
            print("  ", row)
        return 0

    sql_lines: list[str] = [
        "-- Generated by scripts/import-nlem-from-xlsx.py",
        "BEGIN TRANSACTION;",
    ]

    if args.replace_nlem:
        sql_lines.append(
            """DELETE FROM drugs WHERE listing_scope = 'nlem'
  AND category_id IN ('ก','ข','ค','ง','จ1','จ2');"""
        )

    insert_sql = """INSERT INTO drugs (
  category_id, name_en, name_th, drug_group, rights, notes,
  formulary_status, listing_scope,
  nn_civil_servant, nn_doc_required, nn_ocpa,
  active, sort_order
) VALUES (
  ?, ?, NULL, ?, NULL, ?,
  'non_formulary', 'nlem',
  0, 0, 0,
  1, ?
);"""

    for cid, name_en, dg, notes, so in prepared:
        # SQL file: use quoted literals
        def lit(x: str | None):
            if x is None:
                return "NULL"
            return "'" + sql_escape(x) + "'"

        sql_lines.append(
            f"""INSERT INTO drugs (
  category_id, name_en, name_th, drug_group, rights, notes,
  formulary_status, listing_scope,
  nn_civil_servant, nn_doc_required, nn_ocpa,
  active, sort_order
) VALUES (
  '{sql_escape(cid)}', '{sql_escape(name_en)}', NULL, {lit(dg)}, NULL, {lit(notes)},
  'non_formulary', 'nlem',
  0, 0, 0,
  1, {so}
);"""
        )

    sql_lines.append("COMMIT;")
    full_sql = "\n".join(sql_lines)

    if args.sql_out:
        out_path = args.sql_out if os.path.isabs(args.sql_out) else os.path.join(root, args.sql_out)
        os.makedirs(os.path.dirname(out_path) or ".", exist_ok=True)
        with open(out_path, "w", encoding="utf-8") as f:
            f.write(full_sql)
        print(f"✅ เขียน SQL: {out_path} ({len(full_sql)//1024} KB โดยประมาณ)")

    if args.execute_turso:
        url = os.environ.get("TURSO_URL", "").strip()
        tok = os.environ.get("TURSO_AUTH_TOKEN", "").strip()
        if not url or not tok:
            print("❌ ตั้งค่า TURSO_URL และ TURSO_AUTH_TOKEN", file=sys.stderr)
            return 1
        base = url.replace("libsql://", "https://").replace("wss://", "https://")
        print(f"🔌 เชื่อมต่อ Turso … {base.split('//')[1].split('/')[0]}")

        def run_sql(sql: str, params: list | None = None):
            turso_execute(base, tok, sql, params)

        if args.replace_nlem:
            run_sql(
                """DELETE FROM drugs WHERE listing_scope = 'nlem'
  AND category_id IN ('ก','ข','ค','ง','จ1','จ2');"""
            )

        for cid, name_en, dg, notes, so in prepared:
            run_sql(
                insert_sql,
                [cid, name_en, dg, notes, so],
            )
        print(f"✅ Execute แล้ว {len(prepared)} แถว")

    if not args.sql_out and not args.execute_turso:
        print("💡 ระบุ --sql-out หรือ --execute-turso (หรือ --dry-run)")
        return 0

    return 0


if __name__ == "__main__":
    sys.stdout.reconfigure(encoding="utf-8") if hasattr(sys.stdout, "reconfigure") else None
    raise SystemExit(main())
