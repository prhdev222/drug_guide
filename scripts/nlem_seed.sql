-- =============================================================
-- NLEM Drug Guide — nlem_drugs table
-- บัญชียาหลักแห่งชาติ พ.ศ. 2569 (ประกาศราชกิจจาฯ 30 มี.ค. 2569)
-- Source: media.xlsx (NLEM_excel_Mar_2569)
-- Total: 1,360 รายการ
-- =============================================================

CREATE TABLE IF NOT EXISTS nlem_subcategories (
  id          TEXT PRIMARY KEY,  -- b, ex, s, R1, R2
  name_th     TEXT NOT NULL,
  name_en     TEXT NOT NULL,
  description TEXT
);

INSERT OR IGNORE INTO nlem_subcategories VALUES
  ('b',  'บัญชีพื้นฐาน', 'Basic', 'ยาพื้นฐานที่จำเป็น ใช้ได้ทั่วไป'),
  ('ex', 'บัญชีเฉพาะ', 'Exclusive', 'ยาเฉพาะกลุ่มโรค มีเงื่อนไขการใช้'),
  ('s',  'บัญชีพิเศษ', 'Special', 'ยาพิเศษ มีข้อกำหนดเพิ่มเติม'),
  ('R1', 'บัญชีจำกัด 1', 'Restricted 1', 'ยาจำกัดการใช้ระดับ 1'),
  ('R2', 'บัญชีจำกัด 2', 'Restricted 2', 'ยาจำกัดการใช้ระดับ 2 — ต้องขออนุมัติ');

CREATE TABLE IF NOT EXISTS nlem_drugs (
  id               INTEGER PRIMARY KEY AUTOINCREMENT,
  group_name       TEXT NOT NULL,        -- pharmacological group (BNF-style)
  subgroup1        TEXT,
  subgroup2        TEXT,
  subgroup3        TEXT,
  no               INTEGER,              -- ลำดับภายในกลุ่ม
  generic_name     TEXT NOT NULL,
  dosage           TEXT,                 -- dosage form
  strength_salt    TEXT,
  subcategory_old  TEXT,                 -- บัญชีย่อยเดิม (ก/ข/ค/ง/จ1/จ2)
  subcategory_new  TEXT REFERENCES nlem_subcategories(id),  -- b/ex/s/R1/R2
  conditions       TEXT,                 -- เงื่อนไข
  warnings         TEXT,                 -- คำเตือน/ข้อควรระวัง
  notes            TEXT,                 -- หมายเหตุ
  other_info       TEXT,                 -- อื่นๆ
  gazette_date     TEXT,                 -- ประกาศราชกิจจาฯ
  change_code      TEXT,                 -- SAME/A/C1/C2/C5/C6...
  change_detail    TEXT
);

CREATE INDEX IF NOT EXISTS idx_nlem_generic ON nlem_drugs(generic_name);
CREATE INDEX IF NOT EXISTS idx_nlem_group   ON nlem_drugs(group_name);
CREATE INDEX IF NOT EXISTS idx_nlem_subcat  ON nlem_drugs(subcategory_new);

-- =============================================================
-- SEED: nlem_drugs (1,360 รายการ)
-- รันคำสั่งนี้กับ Turso:
--   turso db shell <db-name> < scripts/nlem_seed.sql
-- =============================================================
