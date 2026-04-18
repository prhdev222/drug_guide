/**
 * _utils/db.js — Turso HTTP API helper
 * ใช้ร่วมกันทุก Function โดย import { turso, json, err }
 */

/**
 * Execute a SQL statement against Turso via HTTP API v2
 * @param {Object} env  - Cloudflare env (TURSO_URL, TURSO_AUTH_TOKEN)
 * @param {string} sql  - SQL statement (? for placeholders)
 * @param {Array}  args - positional args matching ?
 * @returns {Array} rows as plain objects
 */
export async function turso(env, sql, args = []) {
  const base = env.TURSO_URL
    .replace('libsql://', 'https://')
    .replace('wss://', 'https://');

  const res = await fetch(`${base}/v2/pipeline`, {
    method: 'POST',
    headers: {
      Authorization: `Bearer ${env.TURSO_AUTH_TOKEN}`,
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      requests: [
        {
          type: 'execute',
          stmt: {
            sql,
            args: args.map(v => {
              if (v === null || v === undefined) return { type: 'null' };
              if (typeof v === 'number' && Number.isInteger(v)) return { type: 'integer', value: String(v) };
              if (typeof v === 'number') return { type: 'float', value: String(v) };
              return { type: 'text', value: String(v) };
            }),
          },
        },
        { type: 'close' },
      ],
    }),
  });

  if (!res.ok) {
    const text = await res.text();
    throw new Error(`Turso HTTP ${res.status}: ${text}`);
  }

  const data = await res.json();
  const result = data.results[0];
  if (result.type === 'error') throw new Error(result.error.message);

  return toRows(result.response.result);
}

/** Convert Turso result cols+rows into array of plain objects */
function toRows({ cols, rows }) {
  const names = cols.map(c => c.name);
  return rows.map(row =>
    Object.fromEntries(
      names.map((name, i) => {
        const cell = row[i];
        if (!cell || cell.type === 'null') return [name, null];
        if (cell.type === 'integer') return [name, parseInt(cell.value, 10)];
        if (cell.type === 'float') return [name, parseFloat(cell.value)];
        return [name, cell.value];
      })
    )
  );
}

/** JSON response helper */
export function json(data, status = 200) {
  return new Response(JSON.stringify(data), {
    status,
    headers: {
      'Content-Type': 'application/json',
      'Access-Control-Allow-Origin': '*',
    },
  });
}

/** Error response helper */
export function err(message, status = 400) {
  return json({ error: message }, status);
}

/** CORS preflight handler — ใส่ที่ส่วนบนของทุก Function */
export function cors(request) {
  if (request.method === 'OPTIONS') {
    return new Response(null, {
      headers: {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'GET,POST,PUT,DELETE,OPTIONS',
        'Access-Control-Allow-Headers': 'Content-Type,X-Admin-Key',
      },
    });
  }
  return null;
}
