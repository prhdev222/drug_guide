# NLEM Drug Guide — โรงพยาบาลสงฆ์

ระบบค้นหาบัญชียาหลักแห่งชาติ พร้อม Admin Panel สำหรับจัดการข้อมูล

## Stack

- **Frontend**: Cloudflare Pages (static HTML/JS)
- **API**: Cloudflare Pages Functions (ESM)
- **Database**: Turso (libSQL)
- **Auth**: API Key (X-Admin-Key header)

## โครงสร้างโฟลเดอร์

```
nlem-drug-guide/
├── public/
│   ├── index.html          ← หน้าค้นหายา (สาธารณะ)
│   └── admin.html          ← Admin CRUD panel
├── functions/
│   ├── _utils/
│   │   └── db.js           ← Turso HTTP helper
│   └── api/
│       ├── categories.js   GET /api/categories
│       ├── drugs.js        GET /api/drugs
│       ├── links.js        GET /api/links
│       └── admin/
│           ├── _middleware.js   ← ตรวจ API Key
│           ├── categories.js    GET+PUT /api/admin/categories
│           ├── drugs.js         GET+POST+PUT+DELETE /api/admin/drugs
│           └── links.js         GET+POST+PUT+DELETE /api/admin/links
├── schema.sql              ← Schema + Seed data
├── .env.example
└── README.md
```

## Setup ทีละขั้น

### 1. สร้าง Turso Database

```bash
# ติดตั้ง Turso CLI (ถ้ายังไม่มี)
curl -sSfL https://get.tur.so/install.sh | bash

# Login
turso auth login

# สร้าง database
turso db create nlem-drug-guide

# Get URL + Token
turso db show nlem-drug-guide --url
turso db tokens create nlem-drug-guide

# รัน schema (seed data รวมอยู่ด้วย)
turso db shell nlem-drug-guide < schema.sql
```

### 2. Push ขึ้น GitHub

```bash
cd nlem-drug-guide
git init
git add .
git commit -m "initial: NLEM drug guide with Turso + CF Pages"
git remote add origin https://github.com/prhdev222/nlem-drug-guide.git
git push -u origin main
```

### 3. Deploy บน Cloudflare Pages

1. Cloudflare Dashboard → Pages → Create a project → Connect to Git
2. เลือก repo `prhdev222/nlem-drug-guide`
3. Build settings:
   - Framework preset: **None**
   - Build command: *(เว้นว่าง)*
   - Output directory: **public**
4. Environment Variables (Settings → Environment Variables):

```
TURSO_URL        = libsql://nlem-drug-guide-xxx.turso.io
TURSO_AUTH_TOKEN = eyJ...
ADMIN_API_KEY    = your-secret-key
```

5. Save & Deploy

### 4. ทดสอบ

```bash
# Public endpoints
curl https://your-site.pages.dev/api/categories
curl https://your-site.pages.dev/api/drugs?category=ง

# Admin endpoint
curl -H "X-Admin-Key: your-secret-key" \
     https://your-site.pages.dev/api/admin/drugs

# เพิ่มยาใหม่
curl -X POST \
     -H "X-Admin-Key: your-secret-key" \
     -H "Content-Type: application/json" \
     -d '{"category_id":"ก","name_en":"Metoprolol","name_th":"เมโทโพรลอล","drug_group":"ยาความดัน/หัวใจ"}' \
     https://your-site.pages.dev/api/admin/drugs
```

## API Reference

### Public

| Method | Path | Params |
|--------|------|--------|
| GET | `/api/categories` | — |
| GET | `/api/drugs` | `category`, `group`, `q` |
| GET | `/api/links` | `category` |

### Admin (ต้องส่ง `X-Admin-Key` header)

| Method | Path | Body / Params |
|--------|------|---------------|
| GET | `/api/admin/drugs` | `?category=` |
| POST | `/api/admin/drugs` | `{category_id, name_en, name_th, drug_group, notes, sort_order}` |
| PUT | `/api/admin/drugs` | `?id=123` + body |
| DELETE | `/api/admin/drugs` | `?id=123` (soft delete) |
| GET | `/api/admin/links` | — |
| POST | `/api/admin/links` | `{category_id, title, url, description, sort_order}` |
| PUT | `/api/admin/links` | `?id=123` + body |
| DELETE | `/api/admin/links` | `?id=123` |
| GET | `/api/admin/categories` | — |
| PUT | `/api/admin/categories` | `?id=ง` + body |

## หมายเหตุ

- ยาที่ถูกลบเป็น soft delete (`active = 0`) ยังอยู่ใน DB
- Admin สามารถเปิด/ปิดรายการได้ไม่ต้องลบจริง
- `category_id` ใน `links` เป็น NULL ได้ = ลิงก์ทั่วไปแสดงทุกบัญชี
