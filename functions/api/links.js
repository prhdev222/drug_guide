import { turso, json, err, cors } from '../_utils/db.js';

/**
 * GET /api/links
 *   ?category=ง   → ลิงก์ของบัญชี ง + ลิงก์ทั่วไป (category_id IS NULL)
 *   (ไม่ส่ง param)  → ลิงก์ทั้งหมด
 */
export async function onRequest({ request, env }) {
  const pre = cors(request);
  if (pre) return pre;

  try {
    const url      = new URL(request.url);
    const category = url.searchParams.get('category');

    let sql, args = [];
    if (category) {
      sql  = `SELECT * FROM links WHERE active = 1
              AND (category_id = ? OR category_id IS NULL)
              ORDER BY sort_order, title`;
      args = [category];
    } else {
      sql = 'SELECT * FROM links WHERE active = 1 ORDER BY sort_order, title';
    }

    const rows = await turso(env, sql, args);
    return json(rows);
  } catch (e) {
    return err(e.message, 500);
  }
}
