/**
 * functions/api/admin/_middleware.js
 * ตรวจสอบ X-Admin-Key header ก่อนทุก request ในโฟลเดอร์ admin/
 */
export async function onRequest(context) {
  // Allow CORS preflight
  if (context.request.method === 'OPTIONS') {
    return new Response(null, {
      headers: {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'GET,POST,PUT,DELETE,OPTIONS',
        'Access-Control-Allow-Headers': 'Content-Type,X-Admin-Key',
      },
    });
  }

  const key = context.request.headers.get('X-Admin-Key');
  if (!key || key !== context.env.ADMIN_API_KEY) {
    return new Response(JSON.stringify({ error: 'Unauthorized' }), {
      status: 401,
      headers: { 'Content-Type': 'application/json' },
    });
  }

  return context.next();
}
