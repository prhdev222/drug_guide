import { turso, json, err } from '../../_utils/db.js';

/** POST /api/admin/links — เพิ่มลิงก์ใหม่ */
export async function onRequestPost({ request, env }) {
  try {
    const { category_id, title, url, description, sort_order = 0 } =
      await request.json();

    if (!title) return err('title is required');
    if (!url)   return err('url is required');

    const rows = await turso(env,
      `INSERT INTO links (category_id, title, url, description, sort_order)
       VALUES (?,?,?,?,?) RETURNING *`,
      [category_id ?? null, title, url, description ?? null, sort_order]
    );
    return json(rows[0], 201);
  } catch (e) {
    return err(e.message, 500);
  }
}

/** PUT /api/admin/links?id=123 — แก้ไขลิงก์ */
export async function onRequestPut({ request, env }) {
  try {
    const id = new URL(request.url).searchParams.get('id');
    if (!id)  return err('id query param required');

    const { category_id, title, url, description, active, sort_order } =
      await request.json();

    const rows = await turso(env,
      `UPDATE links SET
         category_id = COALESCE(?, category_id),
         title       = COALESCE(?, title),
         url         = COALESCE(?, url),
         description = COALESCE(?, description),
         active      = COALESCE(?, active),
         sort_order  = COALESCE(?, sort_order)
       WHERE id = ? RETURNING *`,
      [
        category_id ?? null,
        title       ?? null,
        url         ?? null,
        description ?? null,
        active      ?? null,
        sort_order  ?? null,
        parseInt(id),
      ]
    );
    if (!rows.length) return err('Link not found', 404);
    return json(rows[0]);
  } catch (e) {
    return err(e.message, 500);
  }
}

/** DELETE /api/admin/links?id=123 — soft delete */
export async function onRequestDelete({ request, env }) {
  try {
    const id = new URL(request.url).searchParams.get('id');
    if (!id) return err('id query param required');

    await turso(env, 'UPDATE links SET active = 0 WHERE id = ?', [parseInt(id)]);
    return json({ ok: true, id: parseInt(id) });
  } catch (e) {
    return err(e.message, 500);
  }
}

/** GET /api/admin/links — รายการทั้งหมด รวม inactive */
export async function onRequestGet({ env }) {
  try {
    const rows = await turso(env,
      'SELECT * FROM links ORDER BY sort_order, title'
    );
    return json(rows);
  } catch (e) {
    return err(e.message, 500);
  }
}
