import { turso, json, err, cors } from '../_utils/db.js';

/**
 * GET /api/drugs
 *   ?category=ง          → กรองตามบัญชี
 *   ?group=ยามะเร็ง      → กรองตามกลุ่มยา
 *   ?q=imatinib          → ค้นหาชื่อยา
 *   ?nlem_list_type=R2 → บัญชีย่อย NLEM (b|ex|s|R1|R2)
 *   ?all=1               → รวมที่ active=0 (admin เท่านั้น)
 */
export async function onRequest({ request, env }) {
  const pre = cors(request);
  if (pre) return pre;

  try {
    const url = new URL(request.url);
    const category = url.searchParams.get('category');
    const group    = url.searchParams.get('group');
    const q        = url.searchParams.get('q');
    const scope    = url.searchParams.get('listing_scope'); // nlem | non_nlem
    const nlemLt   = url.searchParams.get('nlem_list_type');

    let sql  = 'SELECT * FROM drugs WHERE active = 1';
    const args = [];

    if (category) { sql += ' AND category_id = ?'; args.push(category); }
    if (group)    { sql += ' AND drug_group = ?';   args.push(group); }
    if (nlemLt)    { sql += ' AND nlem_list_type_id = ?'; args.push(nlemLt); }
    if (scope === 'nlem' || scope === 'non_nlem') {
      sql += ' AND listing_scope = ?';
      args.push(scope);
    }
    if (q)        { sql += ' AND (name_en LIKE ? OR name_th LIKE ?)';
                    args.push(`%${q}%`, `%${q}%`); }

    sql += ' ORDER BY category_id, sort_order, name_en';

    const rows = await turso(env, sql, args);
    return json(rows);
  } catch (e) {
    return err(e.message, 500);
  }
}
