import { turso, json, err, cors } from '../_utils/db.js';

/** GET /api/nlem-list-types — บัญชีย่อย NLEM (b / ex / s / R1 / R2) */
export async function onRequest({ request, env }) {
  const pre = cors(request);
  if (pre) return pre;

  try {
    const rows = await turso(
      env,
      'SELECT * FROM nlem_list_types WHERE active = 1 ORDER BY sort_order, id'
    );
    return json(rows);
  } catch (e) {
    return err(e.message, 500);
  }
}
