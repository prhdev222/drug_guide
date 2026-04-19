-- Patch: Missing drugs from NLEM 2569 Excel
-- Generated from media.xlsx — fixes 38 missing drug names (seed bug: 'เพิ่ม' skipped)

INSERT OR IGNORE INTO drugs (category_id, name_en, drug_group, notes, formulary_status, listing_scope, nn_civil_servant, nn_doc_required, nn_ocpa, active, sort_order, nlem_list_type_id)
VALUES ('จ2', 'Vedolizumab — sterile pwdr, เฉพาะ 300 mg', '1. Gastro-intestinal system · 1.5 Drugs used in chronic bowel disorders', 'เงื่อนไข: 1. ใช้สำหรับผู้ป่วย Crohn''s disease (CD) ในผู้ใหญ่ที่ไม่ตอบสนองต่อยาหรือมีผลไม่พึงประสงค์ที่เกิดจากยา infliximab โดยมีแนวทางกำกับการใช้ยาเป็นไปตามรายละเอียดในภาคผนวก 3  2. ใช้สำหรับผู้ป่วย ulcerative colitis (UC) ในผู้ใหญ่ที่ไม่ตอบสนองต่อยาหรือมีผลไม่พึงประสงค์ที่เกิดจากยา infliximab โดยมีแนวทางกำกับการใช้ยาเป็นไปตามรายละเอียดในภาคผนวก 3', 'non_formulary', 'nlem', 0, 0, 0, 1, 9001, 'R2');

INSERT OR IGNORE INTO drugs (category_id, name_en, drug_group, notes, formulary_status, listing_scope, nn_civil_servant, nn_doc_required, nn_ocpa, active, sort_order, nlem_list_type_id)
VALUES ('ง', 'Apixaban — tab, เฉพาะ 2.5 และ 5 mg', '2. Cardiovascular system · 2.8 Anticoagulants', 'เงื่อนไข: ใช้สำหรับผู้ป่วย non-valvular atrial fibrillation ที่ใช้ warfarin อยู่ และเกิดข้อใดข้อหนึ่งต่อไปนี้ 
1. มีประวัติการเกิด major bleeding ในระหว่างที่มีค่า INR 2-3 และไม่สามารถรักษาต้นเหตุการเกิดเลือดออกเพื่อป้องกันการเกิดซ้ำได้
2. มีประวัติการเกิด thromboembolic events ในระหว่างที่มีค่า INR 2-3
3. ไม่สามารถปรับขนาดยา warfarin ให้อยู่ใน therapeutic range (INR 2-3) ได้ภายใน 12 เดือน และมี time in therapeutic range (TTR) < 50%
4. มีภาวะหลอดเลือดหัวใจตีบ แบบ acute coronary syndrome หรือ chronic coronary disease และเข้ารับการรักษาด้วย percutaneous coronary intervention (PCI) โดยมีระยะเวลาการใช้ไม่เกิน 1 ปี
5. ใช้ในกรณีผู้ป่วยที่จำเป็นต้องใช้ยาอื่นที่เกิด major drug interaction กับ warfarin ซึ่งเป็นการใช้ยาในระยะยาวโดยไม่อาจหลีกเลี่ยงหรือเปลี่ยนเป็นยาอื่นได้
หมายเหตุ: ยา apixaban รูปแบบ tab ขนาด 2.5 mg มีราคาที่ต่อรองได้เม็ดละไม่เกิน 3 บาท (ราคารวมภาษีมูลค่าเพิ่ม) และ ขนาด 5 mg มีราคาที่ต่อรองได้เม็ดละไม่เกิน 5 บาท (ราคารวมภาษีมูลค่าเพิ่ม) กำหนดยืนราคา 730 วัน นับจากวันที่ ประกาศมีผลบังคับใช้', 'non_formulary', 'nlem', 0, 0, 0, 1, 9001, 'ex');

INSERT OR IGNORE INTO drugs (category_id, name_en, drug_group, notes, formulary_status, listing_scope, nn_civil_servant, nn_doc_required, nn_ocpa, active, sort_order, nlem_list_type_id)
VALUES ('จ1', 'Emicizumab — sterile sol', '2. Cardiovascular system · 2.11 Hemostatics', 'เงื่อนไข: ใช้สำหรับโครงการยาอีมิซิซูแมบในการป้องกันอาการเลือดออกในผู้ป่วยฮีโมฟีเลีย เอ ที่ไม่มีและมีสารต้าน ของคณะแพทยศาสตร์โรงพยาบาลรามาธิบดี มหาวิทยาลัยมหิดลและสำนักงานหลักประกันสุขภาพแห่งชาติ', 'non_formulary', 'nlem', 0, 0, 0, 1, 9001, 'R1');

INSERT OR IGNORE INTO drugs (category_id, name_en, drug_group, notes, formulary_status, listing_scope, nn_civil_servant, nn_doc_required, nn_ocpa, active, sort_order, nlem_list_type_id)
VALUES ('จ2', '4-Factor prothrombin complex concentrate (Coagulation factors II, VII, IX, X) — sterile pwdr, เฉพาะ 500 และ 600 IU', '2. Cardiovascular system · 2.11 Hemostatics', 'เงื่อนไข: 1. ใช้สำหรับรักษาภาวะเลือดออกรุนแรง ในผู้ป่วยที่ได้รับยาต้านการแข็งตัวของเลือดชนิด warfarin โดยมีแนวทางกำกับการใช้ยาเป็นไปตามรายละเอียดในภาคผนวก 3
  2. ใช้สำหรับรักษาภาวะเลือดออกรุนแรง ในผู้ป่วยที่ได้รับยาต้านการแข็งตัวของเลือดชนิด anti-Xa โดยมีแนวทางกำกับการใช้ยาเป็นไปตามรายละเอียดในภาคผนวก 3
หมายเหตุ: ยา 4-Factor prothrombin complex concentrate รูปแบบ sterile pwdr ขนาด 500 IU มีราคาที่ต่อรองได้ ไวแอลละ 4,920 บาท และขนาด 600 IU มีราคาที่ต่อรองได้ไวแอลละ 5,904 บาท กำหนดยืนราคา 730 วัน', 'non_formulary', 'nlem', 0, 0, 0, 1, 9002, 'R2');

INSERT OR IGNORE INTO drugs (category_id, name_en, drug_group, notes, formulary_status, listing_scope, nn_civil_servant, nn_doc_required, nn_ocpa, active, sort_order, nlem_list_type_id)
VALUES ('ข', 'Diltiazem hydrochloride — sterile pwdr', '2. Cardiovascular system · 2.3 Anti-arrhythmic drugs', NULL, 'non_formulary', 'nlem', 0, 0, 0, 1, 9001, 'b');

INSERT OR IGNORE INTO drugs (category_id, name_en, drug_group, notes, formulary_status, listing_scope, nn_civil_servant, nn_doc_required, nn_ocpa, active, sort_order, nlem_list_type_id)
VALUES ('ข', 'Atorvastatin — tab, เฉพาะ 40 mg', '2. Cardiovascular system · 2.12 Lipid-regulating drugs', 'เงื่อนไข: Atorvastatin 40 mg เป็น high intensity statin ที่มีข้อบ่งใช้ในกรณีต่อไปนี้ 
1. ผู้ป่วยที่ใช้ยา simvastatin ในขนาด 40 mg ติดต่อกัน 3-6 เดือน แล้วยังไม่สามารถควบคุมระดับ LDL-C ได้ถึงค่าเป้าหมาย
2. Familial hypercholesterolemia (เป้าหมาย LDL-C <100 มก./ดล.)
3. ผู้ป่วยที่กำลังเกิด acute vascular events เช่น acute coronary syndrome
4. ผู้ป่วยโรคสมองขาดเลือดที่มีระดับ LDL-C ≥ 100 มก/ดล. (เป้าหมาย LDL-C <70 มก./ดล.)
5. ผู้ป่วยที่ไม่สามารถใช้ simvastatin ได้ เนื่องจากผลข้างเคียง', 'non_formulary', 'nlem', 0, 0, 0, 1, 9001, 'b');

INSERT OR IGNORE INTO drugs (category_id, name_en, drug_group, notes, formulary_status, listing_scope, nn_civil_servant, nn_doc_required, nn_ocpa, active, sort_order, nlem_list_type_id)
VALUES ('ข', 'Quetiapine fumarate — tab', '4. Central nervous system · 4.2 Drugs used in psychoses and related disorders · 4.2.1 Antipsychotic drugs', NULL, 'non_formulary', 'nlem', 0, 0, 0, 1, 9001, 'ex');

INSERT OR IGNORE INTO drugs (category_id, name_en, drug_group, notes, formulary_status, listing_scope, nn_civil_servant, nn_doc_required, nn_ocpa, active, sort_order, nlem_list_type_id)
VALUES ('จ1', 'Paliperidone palmitate — inj, ชนิดออกฤทธิ์นาน', '4. Central nervous system · 4.2 Drugs used in psychoses and related disorders · 4.2.1 Antipsychotic drugs', 'เงื่อนไข: ใช้สำหรับโครงการศึกษาประสิทธิผลการใช้ยาฉีดต้านโรคจิตชนิดออกฤทธิ์เนิ่นกลุ่มใหม่ ในผู้ป่วยจิตเวชและยาเสพติด กลุ่มที่มีความเสี่ยงสูงต่อการก่อความรุนแรง (SMI-V) ของกรมสุขภาพจิต', 'non_formulary', 'nlem', 0, 0, 0, 1, 9002, 'R1');

INSERT OR IGNORE INTO drugs (category_id, name_en, drug_group, notes, formulary_status, listing_scope, nn_civil_servant, nn_doc_required, nn_ocpa, active, sort_order, nlem_list_type_id)
VALUES ('ง', 'Escitalopram oxalate — tab, เฉพาะ 10, 20 mg', '4. Central nervous system · 4.3 Antidepressant drugs', 'เงื่อนไข: ใช้เป็น antidepressant ที่เป็นยาหลัก ในการรักษา treatment-resistant depression (TRD)', 'non_formulary', 'nlem', 0, 0, 0, 1, 9002, 'ex');

INSERT OR IGNORE INTO drugs (category_id, name_en, drug_group, notes, formulary_status, listing_scope, nn_civil_servant, nn_doc_required, nn_ocpa, active, sort_order, nlem_list_type_id)
VALUES ('ง', 'Sulbactam sodium — sterile pwdr, เฉพาะ 2 g', '5. Infections · 5.1 Antibacterial drugs · 5.1.7 Some other antibacterials', 'เงื่อนไข: ใช้ร่วมกับยาต้านจุลชีพอื่นในการรักษาการติดเชื้อ Acinetobacter baumannii ที่ดื้อต่อยาหลายขนาน', 'non_formulary', 'nlem', 0, 0, 0, 1, 9003, 'ex');

INSERT OR IGNORE INTO drugs (category_id, name_en, drug_group, notes, formulary_status, listing_scope, nn_civil_servant, nn_doc_required, nn_ocpa, active, sort_order, nlem_list_type_id)
VALUES ('ง', 'Vancomycin hydrochloride — cap', '5. Infections · 5.1 Antibacterial drugs · 5.1.7 Some other antibacterials', NULL, 'non_formulary', 'nlem', 0, 0, 0, 1, 9003, 'ex');

INSERT OR IGNORE INTO drugs (category_id, name_en, drug_group, notes, formulary_status, listing_scope, nn_civil_servant, nn_doc_required, nn_ocpa, active, sort_order, nlem_list_type_id)
VALUES ('จ2', 'Linezolid — tab', '5. Infections · 5.1 Antibacterial drugs · 5.1.7 Some other antibacterials', 'เงื่อนไข: 1. ใช้สำหรับโรคติดเชื้อ MRSA 2. ใช้สำหรับโรคติดเชื้อ VRE 3. ใช้สำหรับการรักษาโรคติดเชื้อ Mycobacterium abscessus', 'non_formulary', 'nlem', 0, 0, 0, 1, 9003, 'R2');

INSERT OR IGNORE INTO drugs (category_id, name_en, drug_group, notes, formulary_status, listing_scope, nn_civil_servant, nn_doc_required, nn_ocpa, active, sort_order, nlem_list_type_id)
VALUES ('จ2', 'Linezolid — sterile sol', '5. Infections · 5.1 Antibacterial drugs · 5.1.7 Some other antibacterials', 'เงื่อนไข: ใช้สำหรับรักษาโรคติดเชื้อ VRE ที่ไม่สามารถใช้ยา linezolid แบบรับประทานได้', 'non_formulary', 'nlem', 0, 0, 0, 1, 9004, 'R2');

INSERT OR IGNORE INTO drugs (category_id, name_en, drug_group, notes, formulary_status, listing_scope, nn_civil_servant, nn_doc_required, nn_ocpa, active, sort_order, nlem_list_type_id)
VALUES ('ง', 'Bedaquiline fumarate — tab', '5. Infections · 5.1 Antibacterial drugs · 5.1.9 Antimycobacterial drugs', 'เงื่อนไข: ใช้รักษา MDR-TB, pre-XDR-TB, XDR-TB', 'non_formulary', 'nlem', 0, 0, 0, 1, 9004, 'ex');

INSERT OR IGNORE INTO drugs (category_id, name_en, drug_group, notes, formulary_status, listing_scope, nn_civil_servant, nn_doc_required, nn_ocpa, active, sort_order, nlem_list_type_id)
VALUES ('ง', 'Clofazimine — cap', '5. Infections · 5.1 Antibacterial drugs · 5.1.9 Antimycobacterial drugs', 'เงื่อนไข: 1. ใช้รักษา MDR-TB, pre-XDR-TB, XDR-TB 2. ใช้ในการรักษาโรคติดเชื้อ NTM', 'non_formulary', 'nlem', 0, 0, 0, 1, 9005, 'ex');

INSERT OR IGNORE INTO drugs (category_id, name_en, drug_group, notes, formulary_status, listing_scope, nn_civil_servant, nn_doc_required, nn_ocpa, active, sort_order, nlem_list_type_id)
VALUES ('ง', 'Delamanid — tab', '5. Infections · 5.1 Antibacterial drugs · 5.1.9 Antimycobacterial drugs', 'เงื่อนไข: ใช้รักษา MDR-TB, pre-XDR-TB, XDR-TB', 'non_formulary', 'nlem', 0, 0, 0, 1, 9006, 'ex');

INSERT OR IGNORE INTO drugs (category_id, name_en, drug_group, notes, formulary_status, listing_scope, nn_civil_servant, nn_doc_required, nn_ocpa, active, sort_order, nlem_list_type_id)
VALUES ('ง', 'Linezolid — tab', '5. Infections · 5.1 Antibacterial drugs · 5.1.9 Antimycobacterial drugs', 'เงื่อนไข: ใช้รักษา MDR-TB, pre-XDR-TB, XDR-TB หมายเหตุ: จัดเป็นบัญชี R2 สำหรับ MRSA, VRE, M.abscessus ดูรายละเอียดใน 5.1.7', 'non_formulary', 'nlem', 0, 0, 0, 1, 9007, 'ex');

INSERT OR IGNORE INTO drugs (category_id, name_en, drug_group, notes, formulary_status, listing_scope, nn_civil_servant, nn_doc_required, nn_ocpa, active, sort_order, nlem_list_type_id)
VALUES ('ง', 'Moxifloxacin hydrochloride — tab', '5. Infections · 5.1 Antibacterial drugs · 5.1.9 Antimycobacterial drugs', 'เงื่อนไข: 1. ใช้รักษา MDR-TB, pre-XDR-TB, XDR-TB 2. ใช้ในการรักษาโรคติดเชื้อ NTM', 'non_formulary', 'nlem', 0, 0, 0, 1, 9008, 'ex');

INSERT OR IGNORE INTO drugs (category_id, name_en, drug_group, notes, formulary_status, listing_scope, nn_civil_servant, nn_doc_required, nn_ocpa, active, sort_order, nlem_list_type_id)
VALUES ('ง', 'Pretomanid — tab, เฉพาะ 200 mg', '5. Infections · 5.1 Antibacterial drugs · 5.1.9 Antimycobacterial drugs', 'เงื่อนไข: ใช้รักษา MDR-TB, pre-XDR-TB โดยให้ใช้เป็นองค์ประกอบของสูตรยาที่มี bedaquiline + linezolid', 'non_formulary', 'nlem', 0, 0, 0, 1, 9009, 'ex');

INSERT OR IGNORE INTO drugs (category_id, name_en, drug_group, notes, formulary_status, listing_scope, nn_civil_servant, nn_doc_required, nn_ocpa, active, sort_order, nlem_list_type_id)
VALUES ('ง', 'Protionamide — tab', '5. Infections · 5.1 Antibacterial drugs · 5.1.9 Antimycobacterial drugs', 'เงื่อนไข: ใช้รักษา MDR-TB, pre-XDR-TB, XDR-TB', 'non_formulary', 'nlem', 0, 0, 0, 1, 9010, 'ex');

INSERT OR IGNORE INTO drugs (category_id, name_en, drug_group, notes, formulary_status, listing_scope, nn_civil_servant, nn_doc_required, nn_ocpa, active, sort_order, nlem_list_type_id)
VALUES ('ก', 'Clofazimine — cap', '5. Infections · 5.1 Antibacterial drugs · 5.1.10 Antileprotic drugs', 'หมายเหตุ: จัดเป็นบัญชี ex เมื่อใช้รักษา MDR-TB, pre-XDR-TB, XDR-TB, NTM ดูข้อ 5.1.9', 'non_formulary', 'nlem', 0, 0, 0, 1, 9001, 'b');

INSERT OR IGNORE INTO drugs (category_id, name_en, drug_group, notes, formulary_status, listing_scope, nn_civil_servant, nn_doc_required, nn_ocpa, active, sort_order, nlem_list_type_id)
VALUES ('จ2', 'Valganciclovir hydrochloride — tab, เฉพาะ 450 mg', '5. Infections · 5.3 Antiviral drugs · 5.3.1 Non-antiretrovirals', 'เงื่อนไข: ใช้สำหรับการรักษา cytomegalovirus disease หมายเหตุ: มีราคาต่ำสุดที่ต่อรองได้เม็ดละ 513.64 บาท (รวม VAT) กำหนดยืนราคา 730 วัน', 'non_formulary', 'nlem', 0, 0, 0, 1, 9005, 'R2');

INSERT OR IGNORE INTO drugs (category_id, name_en, drug_group, notes, formulary_status, listing_scope, nn_civil_servant, nn_doc_required, nn_ocpa, active, sort_order, nlem_list_type_id)
VALUES ('ข', 'Nitrofural (Nitrofurazone) — oint (hosp)', '5. Infections · 5.6 Antiseptics', NULL, 'non_formulary', 'nlem', 0, 0, 0, 1, 9002, 'b');

INSERT OR IGNORE INTO drugs (category_id, name_en, drug_group, notes, formulary_status, listing_scope, nn_civil_servant, nn_doc_required, nn_ocpa, active, sort_order, nlem_list_type_id)
VALUES ('ข', 'Iodine + Potassium iodide (Tincture of Iodine) — sol (hosp)', '5. Infections · 5.6 Antiseptics', NULL, 'non_formulary', 'nlem', 0, 0, 0, 1, 9003, 'b');

INSERT OR IGNORE INTO drugs (category_id, name_en, drug_group, notes, formulary_status, listing_scope, nn_civil_servant, nn_doc_required, nn_ocpa, active, sort_order, nlem_list_type_id)
VALUES ('ข', 'Estradiol hemihydrate — vaginal gel (hosp)', '6. Endocrine system · 6.4 Sex hormones · 6.4.1 Female sex hormones', NULL, 'non_formulary', 'nlem', 0, 0, 0, 1, 9004, 'b');

INSERT OR IGNORE INTO drugs (category_id, name_en, drug_group, notes, formulary_status, listing_scope, nn_civil_servant, nn_doc_required, nn_ocpa, active, sort_order, nlem_list_type_id)
VALUES ('ง', 'Alendronate sodium — tab, เฉพาะ 70 mg', '6. Endocrine system · 6.6 Drugs affecting bone metabolism', 'เงื่อนไข: ใช้กับผู้ป่วยโรคกระดูกพรุนเป็นระยะเวลาไม่เกิน 5 ปี เมื่อมีเงื่อนไขข้อใดข้อหนึ่ง ได้แก่ มีประวัติกระดูกหัก หรือค่า BMD T-score ที่กระดูกสันหลังหรือสะโพก ≤ -2.5 หรือมีความเสี่ยงต่อการเกิดกระดูกสะโพกหักในช่วงเวลา 10 ปี ≥ 3% (FRAX ไทย)', 'non_formulary', 'nlem', 0, 0, 0, 1, 9011, 'ex');

INSERT OR IGNORE INTO drugs (category_id, name_en, drug_group, notes, formulary_status, listing_scope, nn_civil_servant, nn_doc_required, nn_ocpa, active, sort_order, nlem_list_type_id)
VALUES ('จ2', 'Bendamustine hydrochloride — sterile pwdr, เฉพาะ 25 และ 100 mg', '8. Malignant disease and immunosuppression · 8.1 Cytotoxic drugs · 8.1.1 Alkylating drugs', 'เงื่อนไข: ใช้สำหรับผู้ป่วย SLL/CLL และ B-cell lymphoma ที่มีการดำเนินโรคช้า ได้แก่ follicular, mantle cell, lymphoplasmacytic lymphoma หมายเหตุ: 25mg ≤749 บาท/ไวแอล, 100mg ≤2,996 บาท/ไวแอล (รวม VAT) ยืนราคา 730 วัน', 'non_formulary', 'nlem', 0, 0, 0, 1, 9006, 'R2');

INSERT OR IGNORE INTO drugs (category_id, name_en, drug_group, notes, formulary_status, listing_scope, nn_civil_servant, nn_doc_required, nn_ocpa, active, sort_order, nlem_list_type_id)
VALUES ('ง', 'Capecitabine — tab', '8. Malignant disease and immunosuppression · 8.1 Cytotoxic drugs · 8.1.3 Antimetabolites', 'เงื่อนไข: 1. ใช้สำหรับ advanced breast cancer (second/third-line) 2. ใช้ร่วมกับรังสีรักษาในมะเร็งลำไส้ใหญ่ 3. ใช้เป็น adjuvant ในมะเร็งลำไส้ใหญ่ stage II-III 4. ใช้ร่วมกับ oxaliplatin ใน advanced CRC 5. ใช้ใน adjuvant ในมะเร็งกระเพาะอาหาร 6. ใช้ใน triple-negative breast cancer หลัง neoadjuvant', 'non_formulary', 'nlem', 0, 0, 0, 1, 9012, 'ex');

INSERT OR IGNORE INTO drugs (category_id, name_en, drug_group, notes, formulary_status, listing_scope, nn_civil_servant, nn_doc_required, nn_ocpa, active, sort_order, nlem_list_type_id)
VALUES ('ง', 'Interferon alfa-2b (Interferon alpha-2b) — sterile pwdr', '8. Malignant disease and immunosuppression · 8.1 Cytotoxic drugs · 8.1.5 Other antineoplastic drugs', 'เงื่อนไข: 1. ใช้สำหรับหญิงตั้งครรภ์ที่มีโรค polycythemia vera หรือ essential thrombocythemia 2. ใช้โดยแพทย์สาขาโลหิตวิทยาและอายุรศาสตร์โรคเลือด', 'non_formulary', 'nlem', 0, 0, 0, 1, 9013, 'ex');

INSERT OR IGNORE INTO drugs (category_id, name_en, drug_group, notes, formulary_status, listing_scope, nn_civil_servant, nn_doc_required, nn_ocpa, active, sort_order, nlem_list_type_id)
VALUES ('ง', 'Isotretinoin (13-cis Retinoic acid) — cap', '8. Malignant disease and immunosuppression · 8.1 Cytotoxic drugs · 8.1.5 Other antineoplastic drugs', 'เงื่อนไข: ใช้สำหรับ high-risk neuroblastoma ในผู้ป่วยเด็ก', 'non_formulary', 'nlem', 0, 0, 0, 1, 9014, 'ex');

INSERT OR IGNORE INTO drugs (category_id, name_en, drug_group, notes, formulary_status, listing_scope, nn_civil_servant, nn_doc_required, nn_ocpa, active, sort_order, nlem_list_type_id)
VALUES ('จ2', 'Thalidomide — cap', '8. Malignant disease and immunosuppression · 8.1 Cytotoxic drugs · 8.1.5 Other antineoplastic drugs', 'เงื่อนไข: ใช้สำหรับผู้ป่วย multiple myeloma ที่เป็น transplant candidate', 'non_formulary', 'nlem', 0, 0, 0, 1, 9007, 'R2');

INSERT OR IGNORE INTO drugs (category_id, name_en, drug_group, notes, formulary_status, listing_scope, nn_civil_servant, nn_doc_required, nn_ocpa, active, sort_order, nlem_list_type_id)
VALUES ('ง', 'Basiliximab — sterile pwdr', '8. Malignant disease and immunosuppression · 8.2 Drugs affecting the immune response', 'เงื่อนไข: 1. ใช้รักษาระยะ induction ในผู้ป่วยปลูกถ่ายไตที่มีความเสี่ยงต่ำขึ้นไป 2. ใช้รักษาระยะ induction ในผู้ป่วยปลูกถ่ายตับที่มีปัญหาไตร่วมด้วย 3. ใช้รักษาระยะ induction ในผู้ป่วยปลูกถ่ายหัวใจ', 'non_formulary', 'nlem', 0, 0, 0, 1, 9015, 'ex');

INSERT OR IGNORE INTO drugs (category_id, name_en, drug_group, notes, formulary_status, listing_scope, nn_civil_servant, nn_doc_required, nn_ocpa, active, sort_order, nlem_list_type_id)
VALUES ('จ2', 'Lenalidomide — cap', '8. Malignant disease and immunosuppression · 8.2 Drugs affecting the immune response', 'เงื่อนไข: ใช้สำหรับผู้ป่วย MDS เฉพาะชนิด 5q- syndrome', 'non_formulary', 'nlem', 0, 0, 0, 1, 9008, 'R2');

INSERT OR IGNORE INTO drugs (category_id, name_en, drug_group, notes, formulary_status, listing_scope, nn_civil_servant, nn_doc_required, nn_ocpa, active, sort_order, nlem_list_type_id)
VALUES ('ข', 'Vitamin D3 (Cholecalciferol) — oral sol', '9. Nutrition and blood · 9.3 Vitamins', 'เงื่อนไข: 1. ใช้ป้องกันและรักษาภาวะการขาดวิตามินดีในทารกแรกเกิดก่อนกำหนด ผู้ป่วยภาวะน้ำดีคั่ง 2. ใช้รักษาภาวะการขาดวิตามินดีในทารกและเด็กเล็ก', 'non_formulary', 'nlem', 0, 0, 0, 1, 9005, 'b');

INSERT OR IGNORE INTO drugs (category_id, name_en, drug_group, notes, formulary_status, listing_scope, nn_civil_servant, nn_doc_required, nn_ocpa, active, sort_order, nlem_list_type_id)
VALUES ('ง', 'Vitamin D3 (Cholecalciferol) — tab', '9. Nutrition and blood · 9.3 Vitamins', 'เงื่อนไข: ใช้รักษาภาวะการขาดวิตามินดีในผู้ป่วยภาวะน้ำดีคั่ง ที่ได้รับ vitamin D2 แล้วไม่ได้ผล', 'non_formulary', 'nlem', 0, 0, 0, 1, 9016, 'ex');

INSERT OR IGNORE INTO drugs (category_id, name_en, drug_group, notes, formulary_status, listing_scope, nn_civil_servant, nn_doc_required, nn_ocpa, active, sort_order, nlem_list_type_id)
VALUES ('ข', 'Alfacalcidol (1 alpha-hydroxyvitamin D3) — cap', '9. Nutrition and blood · 9.3 Vitamins', 'เงื่อนไข: 1. ใช้กับผู้ป่วย CKD stage 4 ที่มีภาวะ secondary hyperparathyroidism 2. ใช้กับผู้ป่วย CKD stage 5 (ESRD) ที่มีภาวะ secondary hyperparathyroidism หมายเหตุ: ราคาที่ต่อรองได้ไม่เกิน 5 บาทต่อ 1 mcg (รวม VAT) ยืนราคา 730 วัน', 'non_formulary', 'nlem', 0, 0, 0, 1, 9006, 'b');

INSERT OR IGNORE INTO drugs (category_id, name_en, drug_group, notes, formulary_status, listing_scope, nn_civil_servant, nn_doc_required, nn_ocpa, active, sort_order, nlem_list_type_id)
VALUES ('ค', 'Alfacalcidol (1 alpha-hydroxyvitamin D3) — cap', '9. Nutrition and blood · 9.3 Vitamins', 'เงื่อนไข: 1. ใช้กับผู้ป่วยที่มีภาวะขาดฮอร์โมนพาราไทรอยด์ (primary hypoparathyroidism) 2. ใช้กับผู้ป่วยที่มีภาวะแคลเซียมในเลือดต่ำชนิดเฉียบพลันรุนแรง หมายเหตุ: ราคาที่ต่อรองได้ไม่เกิน 5 บาทต่อ 1 mcg (รวม VAT)', 'non_formulary', 'nlem', 0, 0, 0, 1, 9001, 's');

INSERT OR IGNORE INTO drugs (category_id, name_en, drug_group, notes, formulary_status, listing_scope, nn_civil_servant, nn_doc_required, nn_ocpa, active, sort_order, nlem_list_type_id)
VALUES ('ง', 'Alfacalcidol (1 alpha-hydroxyvitamin D3) — cap', '9. Nutrition and blood · 9.3 Vitamins', 'เงื่อนไข: 1. ใช้ในผู้ป่วย hypophosphatemic rickets/osteomalacia 2. ใช้ใน pseudohypoparathyroidism 3. ใช้ใน VDDR type I หรือ type II หมายเหตุ: ราคาที่ต่อรองได้ไม่เกิน 5 บาทต่อ 1 mcg (รวม VAT)', 'non_formulary', 'nlem', 0, 0, 0, 1, 9017, 'ex');

INSERT OR IGNORE INTO drugs (category_id, name_en, drug_group, notes, formulary_status, listing_scope, nn_civil_servant, nn_doc_required, nn_ocpa, active, sort_order, nlem_list_type_id)
VALUES ('จ2', 'Sapropterin (BH4) — oral form', '9. Nutrition and blood · 9.7 Metabolic disorders', 'เงื่อนไข: 1. ใช้เพื่อ BH4 loading test สำหรับวินิจฉัย BH4 deficiencies 2. ใช้สำหรับโรค BH4 deficiencies 3. ใช้สำหรับ PKU ที่มีระดับ phenylalanine >360 µmol/L 4. สั่งจ่ายโดยแพทย์อนุสาขาเวชพันธุศาสตร์เท่านั้น อื่นๆ: ยากำพร้า', 'non_formulary', 'nlem', 0, 0, 0, 1, 9009, 'R2');

INSERT OR IGNORE INTO drugs (category_id, name_en, drug_group, notes, formulary_status, listing_scope, nn_civil_servant, nn_doc_required, nn_ocpa, active, sort_order, nlem_list_type_id)
VALUES ('จ2', 'Secukinumab — sterile pwdr, เฉพาะ 150 mg', '10. Musculoskeletal and joint diseases · 10.1 Drugs used in rheumatic diseases and gout · 10.1.2 Disease-modifying antirheumatic drugs (DMARDs)', 'เงื่อนไข: 1. ใช้สำหรับ Juvenile Psoriatic Arthritis 2. ใช้สำหรับ enthesitis-related arthritis (ERA) ในเด็ก', 'non_formulary', 'nlem', 0, 0, 0, 1, 9010, 'R2');

INSERT OR IGNORE INTO drugs (category_id, name_en, drug_group, notes, formulary_status, listing_scope, nn_civil_servant, nn_doc_required, nn_ocpa, active, sort_order, nlem_list_type_id)
VALUES ('จ2', 'Secukinumab — sterile sol, pre-filled pen เฉพาะ 150 mg/ml', '10. Musculoskeletal and joint diseases · 10.1 Drugs used in rheumatic diseases and gout · 10.1.2 Disease-modifying antirheumatic drugs (DMARDs)', 'เงื่อนไข: 1. ใช้สำหรับ Juvenile Psoriatic Arthritis 2. ใช้สำหรับ ERA ในเด็ก', 'non_formulary', 'nlem', 0, 0, 0, 1, 9011, 'R2');

INSERT OR IGNORE INTO drugs (category_id, name_en, drug_group, notes, formulary_status, listing_scope, nn_civil_servant, nn_doc_required, nn_ocpa, active, sort_order, nlem_list_type_id)
VALUES ('ค', 'Amikacin — eye drop (hosp), เฉพาะ 20 mg/mL', '11. Eye · 11.1 Anti-infective eye preparations · 11.1.1 Antibacterials and eye wash solution', 'เงื่อนไข: ใช้สำหรับรักษากระจกตา ผนังลูกตาและลูกตาติดเชื้อแบคทีเรียแกรมลบ', 'non_formulary', 'nlem', 0, 0, 0, 1, 9002, 's');

INSERT OR IGNORE INTO drugs (category_id, name_en, drug_group, notes, formulary_status, listing_scope, nn_civil_servant, nn_doc_required, nn_ocpa, active, sort_order, nlem_list_type_id)
VALUES ('ค', 'Cefazolin — eye drop (hosp), เฉพาะ 50 mg/mL', '11. Eye · 11.1 Anti-infective eye preparations · 11.1.1 Antibacterials and eye wash solution', 'เงื่อนไข: ใช้สำหรับรักษากระจกตา ผนังลูกตา ลูกตา ติดเชื้อแบคทีเรียแกรมบวก', 'non_formulary', 'nlem', 0, 0, 0, 1, 9003, 's');

INSERT OR IGNORE INTO drugs (category_id, name_en, drug_group, notes, formulary_status, listing_scope, nn_civil_servant, nn_doc_required, nn_ocpa, active, sort_order, nlem_list_type_id)
VALUES ('ค', 'Vancomycin — eye drop (hosp), เฉพาะ 50 mg/mL', '11. Eye · 11.1 Anti-infective eye preparations · 11.1.1 Antibacterials and eye wash solution', 'เงื่อนไข: ใช้สำหรับรักษากระจกตาติดเชื้อและลูกตาติดเชื้อแบคทีเรียแกรมบวกที่รุนแรงหรือเชื้อ MRSA', 'non_formulary', 'nlem', 0, 0, 0, 1, 9004, 's');

INSERT OR IGNORE INTO drugs (category_id, name_en, drug_group, notes, formulary_status, listing_scope, nn_civil_servant, nn_doc_required, nn_ocpa, active, sort_order, nlem_list_type_id)
VALUES ('ค', 'Imipenem + Cilastatin — eye drop (hosp), เฉพาะ 5 mg/mL', '11. Eye · 11.1 Anti-infective eye preparations · 11.1.1 Antibacterials and eye wash solution', 'เงื่อนไข: ใช้สำหรับรักษาแผลกระจกตาติดเชื้อแบคทีเรียแกรมลบหรือสงสัยเชื้อในกลุ่ม mycobacteria', 'non_formulary', 'nlem', 0, 0, 0, 1, 9005, 's');

INSERT OR IGNORE INTO drugs (category_id, name_en, drug_group, notes, formulary_status, listing_scope, nn_civil_servant, nn_doc_required, nn_ocpa, active, sort_order, nlem_list_type_id)
VALUES ('ง', 'Vancomycin — eye drop (hosp), เฉพาะ 14 mg/mL', '11. Eye · 11.1 Anti-infective eye preparations · 11.1.1 Antibacterials and eye wash solution', 'เงื่อนไข: ใช้สำหรับป้องกันตาติดเชื้อในผู้ป่วยที่ได้รับการผ่าตัดใส่กระจกตาเทียม (Boston keratoprothesis)', 'non_formulary', 'nlem', 0, 0, 0, 1, 9018, 'ex');

INSERT OR IGNORE INTO drugs (category_id, name_en, drug_group, notes, formulary_status, listing_scope, nn_civil_servant, nn_doc_required, nn_ocpa, active, sort_order, nlem_list_type_id)
VALUES ('ค', 'Medroxyprogesterone — eye drop (hosp), เฉพาะ 1%', '11. Eye · 11.2 Corticosteroids and other anti-inflammatory preparations', 'เงื่อนไข: 1. ใช้เป็นยาเสริมร่วมกับยากดภูมิคุ้มกันในการยับยั้ง collagenase ใน PUK 2. ใช้ลดการทำลาย collagen ใน chemical ocular burn', 'non_formulary', 'nlem', 0, 0, 0, 1, 9006, 's');

INSERT OR IGNORE INTO drugs (category_id, name_en, drug_group, notes, formulary_status, listing_scope, nn_civil_servant, nn_doc_required, nn_ocpa, active, sort_order, nlem_list_type_id)
VALUES ('ข', 'Fomepizole — sterile sol', '16. Drugs used in poisoning and toxicology · 16.5 Methanol poisoning', 'เงื่อนไข: ใช้บำบัดพิษจาก methanol, ethylene glycol และ diethylene glycol ในกรณีที่ไม่สามารถใช้ ethanol ได้ อื่นๆ: ยากำพร้า', 'non_formulary', 'nlem', 0, 0, 0, 1, 9007, 'b');

INSERT OR IGNORE INTO drugs (category_id, name_en, drug_group, notes, formulary_status, listing_scope, nn_civil_servant, nn_doc_required, nn_ocpa, active, sort_order, nlem_list_type_id)
VALUES ('ข', 'Bentonite — susp (hosp)', '16. Drugs used in poisoning and toxicology · 16.10 Drugs used for absorption inhibition and elimination of toxin', NULL, 'non_formulary', 'nlem', 0, 0, 0, 1, 9008, 'b');
