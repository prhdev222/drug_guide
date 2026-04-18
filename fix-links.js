/**
 * fix-links.js — แก้ไข URL ลิงก์ที่ไม่ถูกต้องใน Turso
 */
const BASE = 'http://127.0.0.1:8788';
const KEY  = 'drug222';

const UPDATES = [
  // NLEM — เว็บเก่าปิดแล้ว ใช้ระบบใหม่ของ อย. แทน
  { id: 1, url: 'https://ndp.fda.moph.go.th/nlem/dashboard',
    title: 'บัญชียาหลักแห่งชาติ (NLEM) — กองนโยบายแห่งชาติด้านยา',
    description: 'ระบบติดตามบัญชียาหลักแห่งชาติ ครบทุกบัญชี' },
  // FDA Drug DB — redirect ไป /home
  { id: 2, url: 'https://drug.fda.moph.go.th/home',
    description: 'ค้นหาทะเบียนยา ชื่อสามัญ และข้อมูลยาทุกชนิด' },
  // SSO
  { id: 3, url: 'https://www.sso.go.th/wpr/main.jsp' },
  // NHSO บัญชี ง — page เก่าใช้ไม่ได้
  { id: 4, url: 'https://www.nhso.go.th/th/',
    description: 'สิทธิประโยชน์ยาบัตรทอง เกณฑ์การใช้ยาบัญชี ง' },
  // CGD — ไม่เปลี่ยน
  // NHSO จ2 — มีระบบเฉพาะ
  { id: 6, url: 'https://drug.nhso.go.th/drugserver/',
    title: 'สปสช. — ระบบยาโครงการพิเศษ (บัญชี จ2)',
    description: 'ระบบยา ARV, DAA ตับอักเสบ C, วัณโรค และโครงการอื่น' },
  // NHSO ค — main page
  { id: 7, url: 'https://www.nhso.go.th/th/',
    description: 'เกณฑ์และแนวปฏิบัติสำหรับยาบัญชี ค' },
];

for (const u of UPDATES) {
  const body = {};
  if (u.url)         body.url         = u.url;
  if (u.title)       body.title       = u.title;
  if (u.description) body.description = u.description;

  const res = await fetch(`${BASE}/api/admin/links?id=${u.id}`, {
    method: 'PUT',
    headers: { 'X-Admin-Key': KEY, 'Content-Type': 'application/json' },
    body: JSON.stringify(body),
  });
  const data = await res.json();
  console.log(`id=${u.id} → ${res.ok ? '✅' : '❌'} ${JSON.stringify(data)}`);
}
console.log('เสร็จแล้ว');
