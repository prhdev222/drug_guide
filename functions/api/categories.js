import { turso, json, err, cors } from '../_utils/db.js';

export async function onRequest({ request, env }) {
  const pre = cors(request);
  if (pre) return pre;

  try {
    const rows = await turso(env,
      'SELECT * FROM categories WHERE active = 1 ORDER BY id'
    );
    return json(rows);
  } catch (e) {
    return err(e.message, 500);
  }
}
