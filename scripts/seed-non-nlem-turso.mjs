#!/usr/bin/env node
/**
 * ดัน category NON + ตัวอย่างยา non-NLEM เข้า Turso (HTTP pipeline — ไม่ต้องใช้ Turso SQL console)
 *
 * PowerShell:
 *   $env:TURSO_URL="libsql://your-db.turso.io"
 *   $env:TURSO_AUTH_TOKEN="..."
 *   node scripts/seed-non-nlem-turso.mjs
 *
 * หรือใส่คีย์ในไฟล์ .env (ไม่ขึ้น git) ที่โฟลเดอร์โปรเจกต์ แล้วรันสคริปต์เดียวกัน
 */

import { readFileSync, existsSync } from 'node:fs';
import { fileURLToPath } from 'node:url';
import { dirname, join } from 'node:path';

const __dirname = dirname(fileURLToPath(import.meta.url));
const root = join(__dirname, '..');

if (existsSync(join(root, '.env'))) {
  const raw = readFileSync(join(root, '.env'), 'utf8');
  for (const line of raw.split('\n')) {
    const t = line.trim();
    if (!t || t.startsWith('#')) continue;
    const eq = t.indexOf('=');
    if (eq === -1) continue;
    const k = t.slice(0, eq).trim();
    let v = t.slice(eq + 1).trim();
    if ((v.startsWith('"') && v.endsWith('"')) || (v.startsWith("'") && v.endsWith("'")))
      v = v.slice(1, -1);
    if (k && !process.env[k]) process.env[k] = v;
  }
}

const TURSO_URL = process.env.TURSO_URL;
const TURSO_TOKEN = process.env.TURSO_AUTH_TOKEN;

if (!TURSO_URL || !TURSO_TOKEN) {
  console.error('❌ ตั้งค่า TURSO_URL และ TURSO_AUTH_TOKEN (หรือไฟล์ .env ที่โฟลเดอร์โปรเจกต์)');
  process.exit(1);
}

const base = TURSO_URL.replace('libsql://', 'https://').replace('wss://', 'https://');

/** Turso `/v2/pipeline` ต้องการ args แบบ typed — เหมือน `functions/_utils/db.js` (ส่งค่าดิบแล้ว INSERT อาจไม่เข้าจริง) */
function encodeArg(v) {
  if (v === null || v === undefined) return { type: 'null' };
  if (typeof v === 'number' && Number.isInteger(v)) return { type: 'integer', value: String(v) };
  if (typeof v === 'number') return { type: 'float', value: String(v) };
  return { type: 'text', value: String(v) };
}

function stmtPayload(sql, args = []) {
  if (!args.length) return { sql };
  return { sql, args: args.map(encodeArg) };
}

/** แปลงผล SELECT จาก pipeline → array of objects */
function rowsFromResult(result) {
  const rr = result?.response?.result;
  if (!rr?.cols || !rr?.rows) return [];
  const names = rr.cols.map((c) => c.name);
  return rr.rows.map((row) =>
    Object.fromEntries(
      names.map((name, i) => {
        const cell = row[i];
        if (!cell || cell.type === 'null') return [name, null];
        if (cell.type === 'integer') return [name, parseInt(cell.value, 10)];
        if (cell.type === 'float') return [name, parseFloat(cell.value)];
        return [name, cell.value];
      }),
    ),
  );
}

async function exec(sql, args = []) {
  const res = await fetch(`${base}/v2/pipeline`, {
    method: 'POST',
    headers: {
      Authorization: `Bearer ${TURSO_TOKEN}`,
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      requests: [
        { type: 'execute', stmt: stmtPayload(sql, args) },
        { type: 'close' },
      ],
    }),
  });
  const text = await res.text();
  let data;
  try {
    data = JSON.parse(text);
  } catch {
    throw new Error(`Turso HTTP ${res.status}: ไม่ใช่ JSON — ${text.slice(0, 200)}`);
  }
  if (!res.ok) {
    throw new Error(`Turso HTTP ${res.status}: ${text.slice(0, 500)}`);
  }
  const result = data.results?.[0];
  if (result?.type === 'error') throw new Error(result.error.message);
  return result;
}

async function queryAll(sql, args = []) {
  const r = await exec(sql, args);
  return rowsFromResult(r);
}

async function tryAlter(sql) {
  try {
    await exec(sql);
    return true;
  } catch (e) {
    if (/duplicate column|already exists/i.test(String(e.message))) return false;
    throw e;
  }
}

let host = '';
try {
  host = new URL(base).hostname;
} catch {
  host = '(parse URL ไม่ได้)';
}
console.log('🔌 เชื่อมต่อ Turso …');
console.log(`   เป้าหมาย: ${host}`);
console.log('   (ต้องตรงกับ TURSO_URL ใน Cloudflare Pages — ถ้าคนละ database เว็บจะไม่เห็นข้อมูลที่ seed)');

for (const sql of [
  `ALTER TABLE drugs ADD COLUMN listing_scope TEXT NOT NULL DEFAULT 'nlem'`,
  `ALTER TABLE drugs ADD COLUMN nn_civil_servant INTEGER NOT NULL DEFAULT 0`,
  `ALTER TABLE drugs ADD COLUMN nn_doc_required INTEGER NOT NULL DEFAULT 0`,
  `ALTER TABLE drugs ADD COLUMN nn_ocpa INTEGER NOT NULL DEFAULT 0`,
  `ALTER TABLE categories ADD COLUMN doc_url TEXT`,
]) {
  await tryAlter(sql);
}

/** ระบุชื่อคอลัมน์ — Turso บางชุดมี categories.doc_url (ลิงก์ระดับหมวด) เพิ่มจาก migration */
await exec(`
INSERT OR IGNORE INTO categories (
  id, name_th, name_en, description,
  rights, doc_level, color, level_desc, active
) VALUES (
  'NON','นอกบัญชียาหลักแห่งชาติ','Non-NLEM / Hospital list',
  'ยาไม่อยู่ในบัญชียาหลักแห่งชาติ — ระเบียบขึ้นกับโรงพยาบาลและสิทธิการรักษา',
  'UC,SSO,CSMBS','none','slate','ตามนโยบาย รพ.',1
)`);
console.log('✓ หมวด NON (ถ้ายังไม่มี)');

/** INSERT … SELECT … WHERE NOT EXISTS — รันซ้ำได้ ไม่สร้างแถวซ้ำ */
const rows = [
  {
    name_en: 'Nintedanib',
    name_th: 'นินเทดานิบ',
    drug_group: 'ยาปอด / IPF — ตัวอย่าง',
    sort_order: 1,
    nn_c: 0, nn_d: 1, nn_o: 1,
    notes: 'ตัวอย่างในระบบ: มักมีทั้งเอกสารประกอบและแนวทางลงทะเบียน OCPA (ขึ้นกับนโยบาย รพ.)',
    formulary_status: 'non_formulary',
    approval_criteria: 'ตัวอย่างเกณฑ์ — ปรับตามจริงของหน่วยบริการ',
  },
  {
    name_en: 'Colistin',
    name_th: 'โคลิสติน',
    drug_group: 'ยาต้านเชื้อ — ตัวอย่าง',
    sort_order: 2,
    nn_c: 1, nn_d: 1, nn_o: 0,
    notes: 'ตัวอย่าง: เน้นสิทธิข้าราชการและเอกสารตามระเบียบ รพ.',
    formulary_status: 'in_stock',
    approval_criteria: null,
  },
  {
    name_en: 'Insulin degludec',
    name_th: 'อินซูลิน เดอกลูเดค',
    drug_group: 'ยาเบาหวาน — ตัวอย่าง',
    sort_order: 3,
    nn_c: 0, nn_d: 0, nn_o: 0,
    notes: 'ตัวอย่าง: บันทึกในฟอร์มูลารีโดยไม่ติ๊กเกณฑ์พิเศษด้านบน',
    formulary_status: 'in_stock',
    approval_criteria: null,
  },
  {
    name_en: 'Fam-trastuzumab deruxtecan',
    name_th: 'แฟม-ทราสทูซูแมบ เดอรักซ์เทแคน',
    drug_group: 'ยามะเร็ง HER2 — ตัวอย่าง',
    sort_order: 4,
    nn_c: 0, nn_d: 1, nn_o: 1,
    notes: 'ตัวอย่าง: สถานะสั่งฉุกเฉิน + เกณฑ์เอกสาร/OCPA',
    formulary_status: 'special_order',
    approval_criteria: 'ตัวอย่าง — ตรวจสอบคำสั่งใช้ยาและแบบฟอร์มตามหน่วยบริการ',
  },
  {
    name_en: 'Apixaban',
    name_th: 'อะพิซาบัน',
    drug_group: 'ยาต้านเกล็ดเลือด — ตัวอย่าง',
    sort_order: 5,
    nn_c: 1, nn_d: 1, nn_o: 0,
    notes: 'ตัวอย่าง: มักขอเอกสารประกอบตามเกณฑ์ รพ. / สิทธิข้าราชการ',
    formulary_status: 'non_formulary',
    approval_criteria: 'ตัวอย่างเกณฑ์ — ตรวจสอบในหน่วยบริการ',
  },
  {
    name_en: 'Levothyroxine sodium',
    name_th: 'เลโวไทรอกซีน',
    drug_group: 'ฮอร์โมนไทรอยด์ — ตัวอย่าง',
    sort_order: 6,
    nn_c: 0, nn_d: 0, nn_o: 0,
    notes: 'ตัวอย่าง: ฟอร์มูลารีทั่วไปนอกบัญชียาหลัก',
    formulary_status: 'in_stock',
    approval_criteria: null,
  },
  {
    name_en: 'Empagliflozin',
    name_th: 'เอมพากลิฟลอซิน',
    drug_group: 'ยาเบาหวาน SGLT2 — ตัวอย่าง',
    sort_order: 7,
    nn_c: 0, nn_d: 0, nn_o: 0,
    notes: 'ตัวอย่าง: ตามบันทึกฟอร์มูลารีโรงพยาบาล',
    formulary_status: 'in_stock',
    approval_criteria: null,
  },
  {
    name_en: 'Oseltamivir',
    name_th: 'โอเซลทามิเวียร์',
    drug_group: 'ยาต้านไข้หวัดใหญ่ — ตัวอย่าง',
    sort_order: 8,
    nn_c: 0, nn_d: 1, nn_o: 0,
    notes: 'ตัวอย่าง: ช่วงระบาดมักมีเกณฑ์เบิกจ่าย/เอกสาร',
    formulary_status: 'special_order',
    approval_criteria: 'ตัวอย่าง — ตามประกาศ/นโยบาย รพ.',
  },
  {
    name_en: 'Denosumab',
    name_th: 'ดีโนซูแมบ',
    drug_group: 'กระดูก/มะเร็ง — ตัวอย่าง',
    sort_order: 9,
    nn_c: 0, nn_d: 1, nn_o: 1,
    notes: 'ตัวอย่าง: ยาเฉพาะทาง มักต้องขออนุมัติและเกณฑ์ OCPA ในบางกรณี',
    formulary_status: 'non_formulary',
    approval_criteria: 'ตัวอย่างเกณฑ์ — ปรับตามคู่มือหน่วยบริการ',
  },
  {
    name_en: 'Rituximab',
    name_th: 'ริทูซิแมบ',
    drug_group: 'มะเร็ง/ภูมิคุ้มกัน — ตัวอย่าง',
    sort_order: 10,
    nn_c: 0, nn_d: 1, nn_o: 0,
    notes: 'ตัวอย่าง: ยาเฉพาะทางมักมีกระบวนการอนุมัติและเอกสาร',
    formulary_status: 'special_order',
    approval_criteria: 'ตัวอย่าง — ตาม protocol หน่วยบริการ',
  },
  {
    name_en: 'Dapagliflozin',
    name_th: 'ดาปากลิฟลอซิน',
    drug_group: 'ยาเบาหวาน SGLT2 — ตัวอย่าง',
    sort_order: 11,
    nn_c: 0, nn_d: 0, nn_o: 0,
    notes: 'ตัวอย่าง: ฟอร์มูลารีโรงพยาบาล (นอกบัญชียาหลัก)',
    formulary_status: 'in_stock',
    approval_criteria: null,
  },
  {
    name_en: 'Pirfenidone',
    name_th: 'พิร์เฟนิโดน',
    drug_group: 'ยาปอด / IPF — ตัวอย่าง',
    sort_order: 12,
    nn_c: 0, nn_d: 1, nn_o: 1,
    notes: 'ตัวอย่าง: คู่ทางเลือกกับนินเทดานิบสำหรับ IPF ตามนโยบาย รพ.',
    formulary_status: 'non_formulary',
    approval_criteria: 'ตัวอย่างเกณฑ์ — ตรวจสอบเกณฑ์เบิกจ่ายในหน่วยบริการ',
  },
];

for (const r of rows) {
  const sql = `
INSERT INTO drugs (
  category_id, name_en, name_th, drug_group, sort_order,
  listing_scope, nn_civil_servant, nn_doc_required, nn_ocpa,
  notes, formulary_status, approval_criteria
)
SELECT 'NON', ?, ?, ?, ?, 'non_nlem', ?, ?, ?, ?, ?, ?
WHERE NOT EXISTS (
  SELECT 1 FROM drugs WHERE category_id = 'NON' AND name_en = ?
)`;
  await exec(sql, [
    r.name_en,
    r.name_th,
    r.drug_group,
    r.sort_order,
    r.nn_c,
    r.nn_d,
    r.nn_o,
    r.notes,
    r.formulary_status,
    r.approval_criteria,
    r.name_en,
  ]);
  console.log(`✓ ${r.name_en}`);
}

try {
  const cnt = await queryAll(`SELECT COUNT(*) AS n FROM drugs WHERE category_id = 'NON'`);
  const n = cnt[0]?.n ?? '?';
  console.log(`\n📊 ตรวจใน DB นี้: drugs หมวด NON = ${n} แถว`);
  const cats = await queryAll(`SELECT id FROM categories WHERE id = 'NON'`);
  console.log(`   หมวด NON ใน categories: ${cats.length ? 'มี' : 'ไม่มี'} (ควรมี)`);
} catch (e) {
  console.warn('\n⚠️ ตรวจจำนวนหลัง seed ไม่ได้:', e.message);
}

console.log('\n✅ เสร็จแล้ว — เปิดหน้าแรก / Admin ควรเห็นยาตัวอย่างในหมวด NON');
