import { turso, json, err } from '../../_utils/db.js';

/** POST /api/admin/drugs — เพิ่มยาใหม่ */
export async function onRequestPost({ request, env }) {
  try {
    const body = await request.json();
    const {
      category_id, name_en, name_th, drug_group, rights, notes, doc_url,
      formulary_status = 'non_formulary', approval_doc_url, approval_criteria, fda_reg_no,
      listing_scope = 'nlem',
      nn_civil_servant = 0, nn_doc_required = 0, nn_ocpa = 0,
      nlem_list_type_id,
    } = body;
    let { sort_order } = body;

    if (!name_en) return err('name_en is required');

    const scope = listing_scope === 'non_nlem' ? 'non_nlem' : 'nlem';
    const catId = scope === 'non_nlem' ? 'NON' : category_id;
    if (!catId) return err('category_id is required');

    if (sort_order === undefined || sort_order === null) {
      const maxRows = await turso(env,
        'SELECT COALESCE(MAX(sort_order), 0) + 1 AS n FROM drugs WHERE category_id = ?',
        [catId]
      );
      sort_order = maxRows[0]?.n ?? 1;
    } else {
      sort_order = parseInt(sort_order, 10);
      if (!Number.isFinite(sort_order)) sort_order = 0;
    }

    const rows = await turso(env,
      `INSERT INTO drugs
        (category_id, name_en, name_th, drug_group, rights, notes, sort_order, doc_url,
         formulary_status, approval_doc_url, approval_criteria, fda_reg_no,
         listing_scope, nn_civil_servant, nn_doc_required, nn_ocpa,
         nlem_list_type_id)
       VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?) RETURNING *`,
      [
        catId,
        name_en,
        name_th          ?? null,
        drug_group       ?? null,
        rights           ?? null,
        notes            ?? null,
        sort_order,
        doc_url          ?? null,
        formulary_status,
        approval_doc_url ?? null,
        approval_criteria ?? null,
        fda_reg_no       ?? null,
        scope,
        scope === 'non_nlem' ? (nn_civil_servant ? 1 : 0) : 0,
        scope === 'non_nlem' ? (nn_doc_required ? 1 : 0) : 0,
        scope === 'non_nlem' ? (nn_ocpa ? 1 : 0) : 0,
        scope === 'non_nlem' ? null : (nlem_list_type_id || null),
      ]
    );
    return json(rows[0], 201);
  } catch (e) {
    return err(e.message, 500);
  }
}

/** PUT /api/admin/drugs?id=123 — แก้ไขยา */
export async function onRequestPut({ request, env }) {
  try {
    const id = new URL(request.url).searchParams.get('id');
    if (!id) return err('id query param required');

    const body = await request.json();
    const {
      category_id, name_en, name_th, drug_group, rights, notes, active, sort_order, doc_url,
      formulary_status, approval_doc_url, approval_criteria, fda_reg_no,
      listing_scope, nn_civil_servant, nn_doc_required, nn_ocpa,
      nlem_list_type_id,
    } = body;

    const hasScope = Object.prototype.hasOwnProperty.call(body, 'listing_scope');
    let scopeDb = null;
    let catDb = category_id ?? null;
    let nnC = null;
    let nnD = null;
    let nnO = null;
    if (hasScope) {
      scopeDb = listing_scope === 'non_nlem' ? 'non_nlem' : 'nlem';
      const isNn = scopeDb === 'non_nlem';
      catDb = isNn ? 'NON' : (category_id ?? null);
      nnC = isNn ? (nn_civil_servant ? 1 : 0) : 0;
      nnD = isNn ? (nn_doc_required ? 1 : 0) : 0;
      nnO = isNn ? (nn_ocpa ? 1 : 0) : 0;
    }

    let nlemLtBind;
    if (Object.prototype.hasOwnProperty.call(body, 'nlem_list_type_id')) {
      nlemLtBind = body.nlem_list_type_id || null;
    } else {
      const prev = await turso(env, 'SELECT nlem_list_type_id FROM drugs WHERE id = ?', [
        parseInt(id),
      ]);
      nlemLtBind = prev[0]?.nlem_list_type_id ?? null;
    }

    const rows = await turso(env,
      `UPDATE drugs SET
         category_id       = COALESCE(?, category_id),
         name_en           = COALESCE(?, name_en),
         name_th           = COALESCE(?, name_th),
         drug_group        = COALESCE(?, drug_group),
         rights            = ?,
         notes             = COALESCE(?, notes),
         active            = COALESCE(?, active),
         sort_order        = COALESCE(?, sort_order),
         doc_url           = ?,
         formulary_status  = COALESCE(?, formulary_status),
         approval_doc_url  = ?,
         approval_criteria = ?,
         fda_reg_no        = ?,
         listing_scope     = COALESCE(?, listing_scope),
         nn_civil_servant  = COALESCE(?, nn_civil_servant),
         nn_doc_required   = COALESCE(?, nn_doc_required),
         nn_ocpa           = COALESCE(?, nn_ocpa),
         nlem_list_type_id = ?
       WHERE id = ? RETURNING *`,
      [
        catDb,
        name_en ?? null,
        name_th ?? null,
        drug_group ?? null,
        rights ?? null,
        notes ?? null,
        active ?? null,
        sort_order ?? null,
        doc_url ?? null,
        formulary_status ?? null,
        approval_doc_url ?? null,
        approval_criteria ?? null,
        fda_reg_no ?? null,
        scopeDb,
        nnC,
        nnD,
        nnO,
        nlemLtBind,
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

/** GET /api/admin/drugs — รายการทั้งหมด รวม inactive */
export async function onRequestGet({ request, env }) {
  try {
    const url      = new URL(request.url);
    const category = url.searchParams.get('category');
    const formulary = url.searchParams.get('formulary');

    let sql = 'SELECT * FROM drugs WHERE 1=1';
    const args = [];
    if (category)  { sql += ' AND category_id = ?';      args.push(category); }
    if (formulary) { sql += ' AND formulary_status = ?';  args.push(formulary); }
    sql += ' ORDER BY category_id, sort_order, name_en';

    const rows = await turso(env, sql, args);
    return json(rows);
  } catch (e) {
    return err(e.message, 500);
  }
}
