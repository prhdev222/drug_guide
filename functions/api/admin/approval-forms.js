import { turso, json, err } from '../../_utils/db.js';

/** GET /api/admin/approval-forms?drug_id=123 */
export async function onRequestGet({ request, env }) {
  try {
    const drug_id = new URL(request.url).searchParams.get('drug_id');
    let sql = 'SELECT af.*, d.name_en, d.name_th FROM approval_forms af JOIN drugs d ON af.drug_id = d.id';
    const args = [];
    if (drug_id) { sql += ' WHERE af.drug_id = ?'; args.push(parseInt(drug_id)); }
    sql += ' ORDER BY af.drug_id, af.sort_order';
    const rows = await turso(env, sql, args);
    return json(rows);
  } catch (e) {
    return err(e.message, 500);
  }
}

/** POST /api/admin/approval-forms */
export async function onRequestPost({ request, env }) {
  try {
    const {
      drug_id, rights = 'ALL', form_type = 'prh_approval',
      title, url, criteria, notes, sort_order = 0,
    } = await request.json();
    if (!drug_id) return err('drug_id is required');
    if (!title)   return err('title is required');
    const rows = await turso(env,
      `INSERT INTO approval_forms (drug_id, rights, form_type, title, url, criteria, notes, sort_order)
       VALUES (?,?,?,?,?,?,?,?) RETURNING *`,
      [drug_id, rights, form_type, title, url ?? null, criteria ?? null, notes ?? null, sort_order]
    );
    return json(rows[0], 201);
  } catch (e) {
    return err(e.message, 500);
  }
}

/** PUT /api/admin/approval-forms?id=123 */
export async function onRequestPut({ request, env }) {
  try {
    const id = new URL(request.url).searchParams.get('id');
    if (!id) return err('id required');
    const { rights, form_type, title, url, criteria, notes, active, sort_order } = await request.json();
    const rows = await turso(env,
      `UPDATE approval_forms SET
        rights     = COALESCE(?, rights),
        form_type  = COALESCE(?, form_type),
        title      = COALESCE(?, title),
        url        = ?,
        criteria   = COALESCE(?, criteria),
        notes      = COALESCE(?, notes),
        active     = COALESCE(?, active),
        sort_order = COALESCE(?, sort_order)
       WHERE id = ? RETURNING *`,
      [
        rights     ?? null, form_type  ?? null, title      ?? null,
        url        ?? null, criteria   ?? null, notes      ?? null,
        active     ?? null, sort_order ?? null,
        parseInt(id),
      ]
    );
    if (!rows.length) return err('Not found', 404);
    return json(rows[0]);
  } catch (e) {
    return err(e.message, 500);
  }
}

/** DELETE /api/admin/approval-forms?id=123 */
export async function onRequestDelete({ request, env }) {
  try {
    const id = new URL(request.url).searchParams.get('id');
    if (!id) return err('id required');
    await turso(env, 'DELETE FROM approval_forms WHERE id = ?', [parseInt(id)]);
    return json({ ok: true });
  } catch (e) {
    return err(e.message, 500);
  }
}
