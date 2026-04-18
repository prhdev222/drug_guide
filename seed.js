/**
 * seed.js — โหลด schema.sql เข้า Turso ผ่าน HTTP API
 * รัน: node seed.js
 */
import { readFileSync } from 'node:fs';

const TURSO_URL    = process.env.TURSO_URL;
const TURSO_TOKEN  = process.env.TURSO_AUTH_TOKEN;

if (!TURSO_URL || !TURSO_TOKEN) {
  console.error('❌ กรุณาตั้งค่า TURSO_URL และ TURSO_AUTH_TOKEN ใน environment');
  process.exit(1);
}

const base = TURSO_URL.replace('libsql://', 'https://').replace('wss://', 'https://');

async function exec(sql) {
  const res = await fetch(`${base}/v2/pipeline`, {
    method: 'POST',
    headers: {
      Authorization: `Bearer ${TURSO_TOKEN}`,
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      requests: [
        { type: 'execute', stmt: { sql, args: [] } },
        { type: 'close' },
      ],
    }),
  });
  const data = await res.json();
  const result = data.results?.[0];
  if (result?.type === 'error') throw new Error(result.error.message);
  return result;
}

// อ่าน schema.sql และแยก statements
const raw = readFileSync('./schema.sql', 'utf8');
const statements = raw
  .split(';')
  .map(s => s.replace(/--[^\n]*/g, '').trim())
  .filter(s => s.length > 0);

console.log(`📦 พบ ${statements.length} SQL statements`);

let ok = 0, fail = 0;
for (const stmt of statements) {
  try {
    await exec(stmt);
    process.stdout.write('.');
    ok++;
  } catch (e) {
    console.error(`\n❌ ${e.message}`);
    console.error(`   SQL: ${stmt.slice(0, 80)}...`);
    fail++;
  }
}

console.log(`\n✅ สำเร็จ ${ok} / ${statements.length} statements (ล้มเหลว ${fail})`);
