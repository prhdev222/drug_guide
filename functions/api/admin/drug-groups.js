import { turso, json, err } from '../../_utils/db.js';

/** GET — รายการทั้งหมด รวม inactive */
export async function onRequestGet({ env }) {
  try {
    const rows = await turso(env,
      'SELECT * FROM drug_groups ORDER BY sort_order, name'
    );
    return json(rows);
  } catch (e) {
    return err(e.message, 500);
  }
}

/** POST — เพิ่มกลุ่มยาใหม่ */
export async function onRequestPost({ request, env }) {
  try {
    const { name, sort_order = 0 } = await request.json();
    if (!name) return err('name is required');
    const rows = await turso(env,
      'INSERT INTO drug_groups (name, sort_order) VALUES (?, ?) RETURNING *',
      [name.trim(), sort_order]
    );
    return json(rows[0], 201);
  } catch (e) {
    if (e.message.includes('UNIQUE')) return err('ชื่อกลุ่มยานี้มีอยู่แล้ว', 409);
    return err(e.message, 500);
  }
}

/** PUT ?id=123 — แก้ไข */
export async function onRequestPut({ request, env }) {
  try {
    const id = new URL(request.url).searchParams.get('id');
    if (!id) return err('id required');
    const { name, sort_order, active } = await request.json();
    const rows = await turso(env,
      `UPDATE drug_groups SET
         name       = COALESCE(?, name),
         sort_order = COALESCE(?, sort_order),
         active     = COALESCE(?, active)
       WHERE id = ? RETURNING *`,
      [name ?? null, sort_order ?? null, active ?? null, parseInt(id)]
    );
    if (!rows.length) return err('Not found', 404);
    return json(rows[0]);
  } catch (e) {
    if (e.message.includes('UNIQUE')) return err('ชื่อกลุ่มยานี้มีอยู่แล้ว', 409);
    return err(e.message, 500);
  }
}

/** DELETE ?id=123 — soft delete */
export async function onRequestDelete({ request, env }) {
  try {
    const id = new URL(request.url).searchParams.get('id');
    if (!id) return err('id required');
    await turso(env, 'UPDATE drug_groups SET active = 0 WHERE id = ?', [parseInt(id)]);
    return json({ ok: true });
  } catch (e) {
    return err(e.message, 500);
  }
}
