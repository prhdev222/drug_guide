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

async function exec(sql, args = []) {
  const res = await fetch(`${base}/v2/pipeline`, {
    method: 'POST',
    headers: {
      Authorization: `Bearer ${TURSO_TOKEN}`,
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      requests: [
        { type: 'execute', stmt: args.length ? { sql, args } : { sql } },
        { type: 'close' },
      ],
    }),
  });
  const data = await res.json();
  const result = data.results?.[0];
  if (result?.type === 'error') throw new Error(result.error.message);
  return result;
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

console.log('🔌 เชื่อมต่อ Turso …');

for (const sql of [
  `ALTER TABLE drugs ADD COLUMN listing_scope TEXT NOT NULL DEFAULT 'nlem'`,
  `ALTER TABLE drugs ADD COLUMN nn_civil_servant INTEGER NOT NULL DEFAULT 0`,
  `ALTER TABLE drugs ADD COLUMN nn_doc_required INTEGER NOT NULL DEFAULT 0`,
  `ALTER TABLE drugs ADD COLUMN nn_ocpa INTEGER NOT NULL DEFAULT 0`,
]) {
  await tryAlter(sql);
}

await exec(`
INSERT OR IGNORE INTO categories VALUES (
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

console.log('\n✅ เสร็จแล้ว — เปิดหน้าแรก / Admin ควรเห็นยาตัวอย่างในหมวด NON');
