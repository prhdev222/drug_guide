import { turso, json, err } from '../../_utils/db.js';

/** POST /api/admin/drugs — เพิ่มยาใหม่ */
export async function onRequestPost({ request, env }) {
  try {
    const { category_id, name_en, name_th, drug_group, notes, sort_order = 0, doc_url } =
      await request.json();

    if (!category_id) return err('category_id is required');
    if (!name_en)     return err('name_en is required');

    const rows = await turso(env,
      `INSERT INTO drugs (category_id, name_en, name_th, drug_group, notes, sort_order, doc_url)
       VALUES (?,?,?,?,?,?,?) RETURNING *`,
      [category_id, name_en, name_th ?? null, drug_group ?? null, notes ?? null, sort_order, doc_url ?? null]
    );
    return json(rows[0], 201);
  } catch (e) {
    return err(e.message, 500);
  }
}

/** PUT /api/admin/drugs?id=123 — แก้ไขยา */
export async function onRequestPut({ request, env }) {
  try {
    const id   = new URL(request.url).searchParams.get('id');
    if (!id)   return err('id query param required');

    const body = await request.json();
    const { name_en, name_th, drug_group, notes, active, sort_order, doc_url } = body;

    const rows = await turso(env,
      `UPDATE drugs SET
         name_en    = COALESCE(?, name_en),
         name_th    = COALESCE(?, name_th),
         drug_group = COALESCE(?, drug_group),
         notes      = COALESCE(?, notes),
         active     = COALESCE(?, active),
         sort_order = COALESCE(?, sort_order),
         doc_url    = ?
       WHERE id = ? RETURNING *`,
      [
        name_en    ?? null,
        name_th    ?? null,
        drug_group ?? null,
        notes      ?? null,
        active     ?? null,
        sort_order ?? null,
        doc_url    ?? null,
        parseInt(id),
      ]
    );
    if (!rows.length) return err('Drug not found', 404);
    return json(rows[0]);
  } catch (e) {
    return err(e.message, 500);
  }
}

/** DELETE /api/admin/drugs?id=123 — soft delete (active = 0) */
export async function onRequestDelete({ request, env }) {
  try {
    const id = new URL(request.url).searchParams.get('id');
    if (!id) return err('id query param required');

    await turso(env, 'UPDATE drugs SET active = 0 WHERE id = ?', [parseInt(id)]);
    return json({ ok: true, id: parseInt(id) });
  } catch (e) {
    return err(e.message, 500);
  }
}

/** GET /api/admin/drugs — รายการทั้งหมด รวม inactive (สำหรับ admin) */
export async function onRequestGet({ request, env }) {
  try {
    const url      = new URL(request.url);
    const category = url.searchParams.get('category');

    let sql = 'SELECT * FROM drugs';
    const args = [];
    if (category) { sql += ' WHERE category_id = ?'; args.push(category); }
    sql += ' ORDER BY category_id, sort_order, name_en';

    const rows = await turso(env, sql, args);
    return json(rows);
  } catch (e) {
    return err(e.message, 500);
  }
}
