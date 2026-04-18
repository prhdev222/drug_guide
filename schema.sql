-- =============================================================
-- NLEM Drug Guide — Turso (libSQL) Schema
-- รัน: turso db shell <db-name> < schema.sql
-- =============================================================

CREATE TABLE IF NOT EXISTS categories (
  id        TEXT PRIMARY KEY,           -- 'ก','ข','ค','ง','จ1','จ2'
  name_th   TEXT NOT NULL,
  name_en   TEXT NOT NULL,
  description TEXT,
  rights    TEXT,                       -- 'UC,SSO,CSMBS' comma-separated
  doc_level TEXT CHECK(doc_level IN ('none','partial','required')),
  color     TEXT,                       -- CSS color key: teal,blue,purple,amber,green,coral
  level_desc TEXT,
  active    INTEGER DEFAULT 1
);

CREATE TABLE IF NOT EXISTS drugs (
  id               INTEGER PRIMARY KEY AUTOINCREMENT,
  category_id      TEXT NOT NULL REFERENCES categories(id),
  name_en          TEXT NOT NULL,
  name_th          TEXT,
  drug_group       TEXT,
  notes            TEXT,
  doc_url          TEXT,
  -- v2: Formulary & Approval
  formulary_status TEXT NOT NULL DEFAULT 'in_stock', -- 'in_stock'|'non_formulary'|'special_order'
  approval_doc_url TEXT,   -- link แบบฟอร์มขออนุมัติ รพ.สงฆ์
  approval_criteria TEXT,  -- เกณฑ์/เงื่อนไขการอนุมัติ
  fda_reg_no       TEXT,   -- เลขทะเบียน อย.
  active           INTEGER DEFAULT 1,
  sort_order       INTEGER DEFAULT 0
);

CREATE TABLE IF NOT EXISTS links (
  id          INTEGER PRIMARY KEY AUTOINCREMENT,
  category_id TEXT REFERENCES categories(id),  -- NULL = ลิงก์ทั่วไป
  title       TEXT NOT NULL,
  url         TEXT NOT NULL,
  description TEXT,
  active      INTEGER DEFAULT 1,
  sort_order  INTEGER DEFAULT 0
);

-- approval_forms: แบบฟอร์มอนุมัติรายยา แยกตามสิทธิ (สำหรับการขยายในอนาคต)
CREATE TABLE IF NOT EXISTS approval_forms (
  id          INTEGER PRIMARY KEY AUTOINCREMENT,
  drug_id     INTEGER NOT NULL REFERENCES drugs(id),
  rights      TEXT NOT NULL DEFAULT 'ALL',         -- 'UC'|'SSO'|'CSMBS'|'ALL'
  form_type   TEXT NOT NULL DEFAULT 'prh_approval', -- 'prh_approval'|'nhso_prior_auth'|'exceptional_drug'
  title       TEXT NOT NULL,
  url         TEXT,
  criteria    TEXT,
  notes       TEXT,
  active      INTEGER DEFAULT 1,
  sort_order  INTEGER DEFAULT 0
);

-- =============================================================
-- SEED: Categories
-- =============================================================
INSERT OR IGNORE INTO categories VALUES
  ('ก','บัญชี ก','Essential Medicines',
   'ยาจำเป็นพื้นฐาน ใช้ได้ทุกระดับสถานพยาบาล ตั้งแต่คลินิกถึงโรงพยาบาลระดับตติยภูมิ',
   'UC,SSO,CSMBS','none','teal','ทุกระดับ (รพสต. ถึง รพ.ตติยภูมิ)',1),
  ('ข','บัญชี ข','Secondary Care Medicines',
   'ยาสำหรับโรงพยาบาลชุมชน (รพช.) และโรงพยาบาลทั่วไป (รพท.) โดยแพทย์ทั่วไปหรือแพทย์เฉพาะทาง',
   'UC,SSO,CSMBS','partial','blue','รพช. / รพท.',1),
  ('ค','บัญชี ค','Tertiary/Specialty Medicines',
   'ยาสำหรับ รพ.ระดับตติยภูมิ / รพ.เฉพาะทาง โดยแพทย์เฉพาะทาง บางรายการต้องขออนุมัติ',
   'UC,CSMBS','partial','purple','รพ.ตติยภูมิ / รพ.เฉพาะทาง',1),
  ('ง','บัญชี ง','Special Indication Medicines',
   'ยาราคาแพงหรือมีข้อบ่งชี้เฉพาะ ต้องขออนุมัติล่วงหน้า (Prior Authorization) ทุกสิทธิ',
   'UC,CSMBS','required','amber','รพ.ระดับสูงที่ได้รับอนุญาต (ต้องขออนุมัติก่อน)',1),
  ('จ1','บัญชี จ1','Herbal Medicines',
   'ยาสมุนไพรที่ผ่านการรับรอง มีหลักฐานประสิทธิภาพและความปลอดภัยรองรับ',
   'UC,CSMBS','none','green','ตามที่แต่ละรายการกำหนด',1),
  ('จ2','บัญชี จ2','Special Program Medicines',
   'ยาภายใต้โครงการพิเศษ สปสช. ต้องลงทะเบียนเข้าร่วมโครงการก่อนรับยา',
   'UC','required','coral','เฉพาะ รพ.ที่ได้รับอนุมัติจาก สปสช.',1);

-- =============================================================
-- SEED: Drugs
-- =============================================================
INSERT OR IGNORE INTO drugs (category_id, name_en, name_th, drug_group, sort_order) VALUES
  -- บัญชี ก
  ('ก','Paracetamol','พาราเซตามอล','ยาแก้ปวด/ลดไข้',1),
  ('ก','Amoxicillin','อะม็อกซีซิลลิน','ยาต้านเชื้อ',2),
  ('ก','Metformin','เมตฟอร์มิน','ยาเบาหวาน',3),
  ('ก','Amlodipine','แอมโลดิพีน','ยาความดัน',4),
  ('ก','Atenolol','อะทีโนลอล','ยาความดัน/หัวใจ',5),
  ('ก','Omeprazole','โอเมพราโซล','ยากระเพาะ',6),
  ('ก','Simvastatin','ซิมวาสตาติน','ยาไขมัน',7),
  ('ก','Furosemide','ฟูโรซีไมด์','ยาขับปัสสาวะ',8),
  ('ก','ORS','สารละลายเกลือแร่','ยาทั่วไป',9),
  ('ก','Co-trimoxazole','โคไตรม็อกซาโซล','ยาต้านเชื้อ',10),
  ('ก','Diazepam','ไดอาซีแพม','ยาระงับประสาท',11),
  ('ก','Dexamethasone','เดกซาเมทาโซน','ยาสเตียรอยด์',12),
  ('ก','Enalapril','อีนาลาพริล','ยาความดัน / ACEI',13),
  ('ก','Aspirin (low dose)','แอสไพริน (ขนาดต่ำ)','ยาต้านเกล็ดเลือด',14),
  -- บัญชี ข
  ('ข','Ceftriaxone',NULL,'ยาต้านเชื้อ / Cephalosporin 3rd',1),
  ('ข','Vancomycin',NULL,'ยาต้านเชื้อ / Glycopeptide',2),
  ('ข','Meropenem',NULL,'ยาต้านเชื้อ / Carbapenem',3),
  ('ข','Piperacillin/Tazobactam',NULL,'ยาต้านเชื้อ',4),
  ('ข','Fluconazole',NULL,'ยาต้านรา',5),
  ('ข','Insulin (human)',NULL,'ยาเบาหวาน',6),
  ('ข','Warfarin','วาร์ฟาริน','ยาต้านการแข็งตัวของเลือด',7),
  ('ข','Enoxaparin','เอนอกซาพาริน','LMWH / ยาต้านการแข็งตัว',8),
  ('ข','Morphine','มอร์ฟีน','ยาแก้ปวด Opioid',9),
  ('ข','Phenytoin',NULL,'ยากันชัก',10),
  ('ข','Prednisolone','เพรดนิโซโลน','ยาสเตียรอยด์',11),
  ('ข','Methotrexate (low dose)',NULL,'ยา DMARDs',12),
  ('ข','Amikacin',NULL,'ยาต้านเชื้อ / Aminoglycoside',13),
  -- บัญชี ค
  ('ค','Imatinib','อิมาทินิบ','ยามะเร็ง / TKI',1),
  ('ค','Dasatinib',NULL,'ยามะเร็ง / TKI',2),
  ('ค','Nilotinib',NULL,'ยามะเร็ง / TKI',3),
  ('ค','Rituximab',NULL,'ยาชีววัตถุ / Anti-CD20',4),
  ('ค','Tacrolimus','ทาโครลิมัส','ยากดภูมิคุ้มกัน',5),
  ('ค','Cyclosporine',NULL,'ยากดภูมิคุ้มกัน',6),
  ('ค','Mycophenolate',NULL,'ยากดภูมิคุ้มกัน',7),
  ('ค','Erlotinib',NULL,'ยามะเร็ง / EGFR TKI',8),
  ('ค','Amphotericin B',NULL,'ยาต้านรา',9),
  ('ค','G-CSF (Filgrastim)',NULL,'ยากระตุ้นไขกระดูก',10),
  ('ค','Clozapine','โคลซาพีน','ยาจิตเวช',11),
  ('ค','Azathioprine',NULL,'ยากดภูมิคุ้มกัน',12),
  -- บัญชี ง
  ('ง','Trastuzumab','ทราสทูซูแมบ','ยาชีววัตถุ / HER2+',1),
  ('ง','Pertuzumab',NULL,'ยาชีววัตถุ / HER2+',2),
  ('ง','Bevacizumab',NULL,'ยาชีววัตถุ / Anti-VEGF',3),
  ('ง','Nivolumab',NULL,'Immunotherapy / PD-1',4),
  ('ง','Pembrolizumab',NULL,'Immunotherapy / PD-1',5),
  ('ง','Lenalidomide',NULL,'ยามะเร็ง / Myeloma',6),
  ('ง','Bortezomib',NULL,'ยามะเร็ง / Proteasome inhibitor',7),
  ('ง','Ibrutinib',NULL,'ยามะเร็ง / BTK inhibitor',8),
  ('ง','Venetoclax',NULL,'ยามะเร็ง / BCL-2 inhibitor',9),
  ('ง','Eculizumab',NULL,'โรคหายาก / PNH',10),
  ('ง','Factor VIII (recombinant)',NULL,'โรคเลือด / Hemophilia A',11),
  ('ง','Factor IX (recombinant)',NULL,'โรคเลือด / Hemophilia B',12),
  ('ง','Emicizumab',NULL,'โรคเลือด / Hemophilia A',13),
  ('ง','Deferasirox','ดีเฟอราซิร็อกซ์','ยาขับเหล็ก / Thalassemia',14),
  ('ง','Deferoxamine','ดีเฟอรอกซามีน','ยาขับเหล็ก / Thalassemia',15),
  ('ง','Agalsidase alfa',NULL,'โรคหายาก / Fabry',16),
  ('ง','Laronidase',NULL,'โรคหายาก / MPS I',17),
  -- บัญชี จ1
  ('จ1','Andrographis paniculata','ฟ้าทะลายโจร','สมุนไพร',1),
  ('จ1','Curcuma longa','ขมิ้นชัน','สมุนไพร',2),
  ('จ1','Centella asiatica','บัวบก','สมุนไพร',3),
  ('จ1','Zingiber cassumunar','ไพล','สมุนไพร',4),
  ('จ1','Kaempferia parviflora','กระชายดำ','สมุนไพร',5),
  ('จ1','Zingiber officinale','ขิง','สมุนไพร',6),
  ('จ1','Allium sativum','กระเทียม','สมุนไพร',7),
  ('จ1','Cassia alata','ชุมเห็ดเทศ','สมุนไพร',8),
  ('จ1','Orthosiphon aristatus','หญ้าหนวดแมว','สมุนไพร',9),
  ('จ1','Momordica charantia','มะระขี้นก','สมุนไพร',10),
  -- บัญชี จ2
  ('จ2','Sofosbuvir/Velpatasvir',NULL,'DAA / ตับอักเสบ C',1),
  ('จ2','Sofosbuvir/Ledipasvir',NULL,'DAA / ตับอักเสบ C',2),
  ('จ2','Glecaprevir/Pibrentasvir',NULL,'DAA / ตับอักเสบ C',3),
  ('จ2','TDF/3TC/DTG (TLD)',NULL,'ARV / HIV',4),
  ('จ2','Dolutegravir',NULL,'ARV / HIV / Integrase inhibitor',5),
  ('จ2','Lopinavir/Ritonavir',NULL,'ARV / HIV / PI',6),
  ('จ2','Darunavir/Cobicistat',NULL,'ARV / HIV / PI',7),
  ('จ2','Bedaquiline',NULL,'MDR-TB',8),
  ('จ2','Delamanid',NULL,'MDR-TB',9),
  ('จ2','Rifampicin+INH+PZA+EMB',NULL,'วัณโรค (standard 4-drug regimen)',10);

-- =============================================================
-- SEED: Links
-- =============================================================
INSERT OR IGNORE INTO links (category_id, title, url, description, sort_order) VALUES
  (NULL,'บัญชียาหลักแห่งชาติ (NLEM) — กระทรวงสาธารณสุข',
   'http://nlem.hss.moph.go.th',
   'รายการยาครบถ้วน แยกตามบัญชี พร้อมเกณฑ์การใช้',1),
  (NULL,'ฐานข้อมูลยา — สำนักงาน อย.',
   'https://drug.fda.moph.go.th',
   'ค้นหาทะเบียนยา ชื่อสามัญ และข้อมูลยาทุกชนิด',2),
  (NULL,'สำนักงานประกันสังคม (SSO)',
   'https://www.sso.go.th',
   'สิทธิประโยชน์และยาสำหรับผู้ประกันตน',3),
  ('ง','สปสช. — เกณฑ์การใช้ยาบัญชี ง',
   'https://www.nhso.go.th/page/drug_criteria',
   'แบบฟอร์มขออนุมัติยาสิทธิบัตรทอง (แบบ สปสช. 05)',4),
  ('ง','กรมบัญชีกลาง — สิทธิข้าราชการ',
   'https://www.cgd.go.th',
   'ระเบียบค่ารักษาพยาบาล แบบ สบจ.ก กรมบัญชีกลาง',5),
  ('จ2','สปสช. — ยาโครงการพิเศษ (บัญชี จ2)',
   'https://www.nhso.go.th/page/special_drugs',
   'ยา ARV, DAA ตับอักเสบ C, วัณโรค และโครงการอื่น',6),
  ('ค','สปสช. — ยาบัญชี ค เกณฑ์การใช้',
   'https://www.nhso.go.th',
   'เกณฑ์และแนวปฏิบัติสำหรับยาบัญชี ค',7);

-- =============================================================
-- MIGRATION v2 (รันเฉพาะ database ที่มีอยู่แล้ว)
-- ถ้าสร้าง database ใหม่จาก schema.sql นี้ ไม่ต้องรัน
-- =============================================================
-- ALTER TABLE drugs ADD COLUMN doc_url TEXT;
-- ALTER TABLE drugs ADD COLUMN formulary_status TEXT NOT NULL DEFAULT 'in_stock';
-- ALTER TABLE drugs ADD COLUMN approval_doc_url TEXT;
-- ALTER TABLE drugs ADD COLUMN approval_criteria TEXT;
-- ALTER TABLE drugs ADD COLUMN fda_reg_no TEXT;
-- CREATE TABLE IF NOT EXISTS approval_forms (
--   id INTEGER PRIMARY KEY AUTOINCREMENT,
--   drug_id INTEGER NOT NULL REFERENCES drugs(id),
--   rights TEXT NOT NULL DEFAULT 'ALL',
--   form_type TEXT NOT NULL DEFAULT 'prh_approval',
--   title TEXT NOT NULL,
--   url TEXT,
--   criteria TEXT,
--   notes TEXT,
--   active INTEGER DEFAULT 1,
--   sort_order INTEGER DEFAULT 0
-- );
