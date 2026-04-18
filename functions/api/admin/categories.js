import { turso, json, err } from '../../_utils/db.js';

/** GET /api/admin/categories — รายการทั้งหมด รวม inactive */
export async function onRequestGet({ env }) {
  try {
    const rows = await turso(env, 'SELECT * FROM categories ORDER BY id');
    return json(rows);
  } catch (e) {
    return err(e.message, 500);
  }
}

/** PUT /api/admin/categories?id=ง — แก้ไข metadata ของบัญชี */
export async function onRequestPut({ request, env }) {
  try {
    const id = new URL(request.url).searchParams.get('id');
    if (!id) return err('id query param required');

    const { name_th, name_en, description, rights, doc_level, color, level_desc, active, doc_url } =
      await request.json();

    const rows = await turso(env,
      `UPDATE categories SET
         name_th    = COALESCE(?, name_th),
         name_en    = COALESCE(?, name_en),
         description= COALESCE(?, description),
         rights     = COALESCE(?, rights),
         doc_level  = COALESCE(?, doc_level),
         color      = COALESCE(?, color),
         level_desc = COALESCE(?, level_desc),
         active     = COALESCE(?, active),
         doc_url    = ?
       WHERE id = ? RETURNING *`,
      [
        name_th     ?? null,
        name_en     ?? null,
        description ?? null,
        rights      ?? null,
        doc_level   ?? null,
        color       ?? null,
        level_desc  ?? null,
        active      ?? null,
        doc_url     ?? null,
        id,
      ]
    );
    if (!rows.length) return err('Category not found', 404);
    return json(rows[0]);
  } catch (e) {
    return err(e.message, 500);
  }
}
