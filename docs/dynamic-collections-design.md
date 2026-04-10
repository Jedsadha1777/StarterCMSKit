# Dynamic Collections Design

## Overview

ระบบให้ Admin สร้าง "ตาราง" แบบ dynamic ได้เอง คล้าย Wix Collections / Airtable
โดยไม่ต้องสร้าง table จริงใน database — ใช้ JSON column เก็บข้อมูลแทน

### สถาปัตยกรรมที่เลือก: **JSON Hybrid (EAV + JSON)**

| แนวทาง | ข้อดี | ข้อเสีย | เลือก? |
|---------|------|---------|--------|
| Dynamic DDL (CREATE TABLE จริง) | query เร็ว | อันตราย, migration ยาก | ❌ |
| Full EAV (Entity-Attribute-Value) | ยืดหยุ่นสุด | query ซับซ้อน, JOIN เยอะ | ❌ |
| **JSON Hybrid** | สมดุล, query ง่าย, index ได้ | JSON ใน MariaDB เป็น LONGTEXT | ✅ |

### เหตุผล

- Stack ปัจจุบัน: Flask + SQLAlchemy 2.0 + MariaDB 12.0.2
- MariaDB รองรับ JSON column, `JSON_VALUE()`, `->`, `->>`
- Single-tenant — ไม่ต้อง partition data
- ต่อยอด pattern เดิมได้ (public_id UUID, admin FK, soft delete, Alembic migration)

---

## Database Schema

### 1. collections

ตารางที่ admin สร้างขึ้น เช่น "สินค้า", "พนักงาน", "คำสั่งซื้อ"

```sql
CREATE TABLE collections (
    id              INT             PRIMARY KEY AUTO_INCREMENT,
    public_id       VARCHAR(50)     NOT NULL UNIQUE,
    name            VARCHAR(100)    NOT NULL,
    slug            VARCHAR(100)    NOT NULL UNIQUE,
    description     TEXT            NULL,
    admin_id        INT             NOT NULL,
    is_deleted      BOOLEAN         NOT NULL DEFAULT FALSE,
    created_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    FOREIGN KEY (admin_id) REFERENCES admins(id)
);
```

### 2. collection_fields

คำจำกัดความของแต่ละ field ใน collection

```sql
CREATE TABLE collection_fields (
    id              INT             PRIMARY KEY AUTO_INCREMENT,
    collection_id   INT             NOT NULL,
    field_name      VARCHAR(100)    NOT NULL,
    field_key       VARCHAR(100)    NOT NULL,
    field_type      VARCHAR(50)     NOT NULL,
    is_required     BOOLEAN         NOT NULL DEFAULT FALSE,
    is_searchable   BOOLEAN         NOT NULL DEFAULT FALSE,
    is_hidden       BOOLEAN         NOT NULL DEFAULT FALSE,
    is_unique       BOOLEAN         NOT NULL DEFAULT FALSE,
    default_value   TEXT            NULL,
    options         JSON            NULL,
    sort_order      INT             NOT NULL DEFAULT 0,
    created_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    FOREIGN KEY (collection_id) REFERENCES collections(id) ON DELETE CASCADE,
    UNIQUE KEY uq_collection_field (collection_id, field_key)
);
```

#### field_type ที่รองรับ

| field_type   | เก็บใน JSON เป็น | ตัวอย่าง |
|-------------|------------------|---------|
| `text`       | string           | "iPhone 16" |
| `textarea`   | string           | "รายละเอียดยาวๆ..." |
| `number`     | number           | 35000.50 |
| `date`       | string (ISO)     | "2026-12-31" |
| `datetime`   | string (ISO)     | "2026-12-31T23:59:59" |
| `boolean`    | boolean          | true |
| `select`     | string           | "อาหาร" |
| `multiselect`| array of string  | ["แดง", "น้ำเงิน"] |
| `image`      | string (URL)     | "/uploads/water.jpg" |
| `file`       | string (URL)     | "/uploads/doc.pdf" |
| `url`        | string           | "https://example.com" |
| `email`      | string           | "test@mail.com" |
| `relation`   | string (UUID)    | "uuid-of-related-row" |

#### options JSON ตาม field_type

```jsonc
// text
{"max_length": 200, "placeholder": "กรอกชื่อสินค้า"}

// number
{"min": 0, "max": 999999, "decimal_places": 2}

// select / multiselect
{"choices": ["แดง", "เขียว", "น้ำเงิน"]}

// image / file
{"max_size_mb": 5, "allowed_types": ["jpg", "png", "webp"]}

// relation (many_to_one)
{"related_collection_id": 3, "relation_type": "many_to_one"}

// relation (many_to_many)
{"related_collection_id": 5, "relation_type": "many_to_many"}
```

### 3. collection_rows

ข้อมูลจริงของแต่ละ row โดยเก็บค่าทั้งหมดใน JSON column `data`

```sql
CREATE TABLE collection_rows (
    id              INT             PRIMARY KEY AUTO_INCREMENT,
    public_id       VARCHAR(50)     NOT NULL UNIQUE,
    collection_id   INT             NOT NULL,
    data            JSON            NOT NULL,
    created_by      INT             NULL,
    is_deleted      BOOLEAN         NOT NULL DEFAULT FALSE,
    created_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    FOREIGN KEY (collection_id) REFERENCES collections(id) ON DELETE CASCADE,
    INDEX idx_collection_deleted (collection_id, is_deleted),

    -- MariaDB เก็บ JSON เป็น LONGTEXT ดังนั้นต้อง validate เอง
    CONSTRAINT chk_data_json CHECK (JSON_VALID(data))
);
```

### 4. collection_relations

สำหรับ Many-to-Many relation เท่านั้น (Many-to-One เก็บ UUID ใน JSON ได้เลย)

```sql
CREATE TABLE collection_relations (
    id              INT             PRIMARY KEY AUTO_INCREMENT,
    field_id        INT             NOT NULL,
    source_row_id   INT             NOT NULL,
    target_row_id   INT             NOT NULL,
    created_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (field_id)      REFERENCES collection_fields(id) ON DELETE CASCADE,
    FOREIGN KEY (source_row_id) REFERENCES collection_rows(id)   ON DELETE CASCADE,
    FOREIGN KEY (target_row_id) REFERENCES collection_rows(id)   ON DELETE CASCADE,

    UNIQUE KEY uq_relation (field_id, source_row_id, target_row_id),
    INDEX idx_target (target_row_id)    -- สำหรับ reverse lookup
);
```

---

## Indexing Strategy

เมื่อ admin ตั้ง `is_searchable = true` บน field ระบบจะสร้าง Virtual Generated Column + Index อัตโนมัติ

### กลยุทธ์ index ตาม field_type

| field_type | Generated Column Type | Index Type | หมายเหตุ |
|------------|----------------------|------------|---------|
| `number` | `DECIMAL(10,2)` | B-Tree INDEX | — |
| `date` | `DATE` | B-Tree INDEX | — |
| `datetime` | `DATETIME` | B-Tree INDEX | — |
| `boolean` | `TINYINT` | B-Tree INDEX | — |
| `text` | `VARCHAR(191)` | B-Tree INDEX | ตัดที่ 191 ตัว (utf8mb4 safe) |
| `email` | `VARCHAR(191)` | B-Tree INDEX | ตัดที่ 191 ตัว |
| `url` | `VARCHAR(191)` | B-Tree INDEX | ตัดที่ 191 ตัว |
| `select` | `VARCHAR(100)` | B-Tree INDEX | — |
| `textarea` | `TEXT` | FULLTEXT INDEX | สำหรับค้นหาข้อความยาว |
| `relation` | `VARCHAR(50)` | B-Tree INDEX | เก็บ UUID |
| `image` / `file` | — | ไม่สร้าง index | ไม่มีประโยชน์ในการค้นหา |

### ตัวอย่าง SQL ที่ระบบ generate

```sql
-- field: "name" (text, is_searchable=true)
ALTER TABLE collection_rows
ADD COLUMN _idx_name VARCHAR(191) AS (LEFT(JSON_VALUE(data, '$.name'), 191)) VIRTUAL,
ADD INDEX idx_coll1_name (_idx_name);

-- field: "price" (number, is_searchable=true)
ALTER TABLE collection_rows
ADD COLUMN _idx_price DECIMAL(10,2) AS (JSON_VALUE(data, '$.price')) VIRTUAL,
ADD INDEX idx_coll1_price (_idx_price);

-- field: "description" (textarea, is_searchable=true)
ALTER TABLE collection_rows
ADD COLUMN _ft_description TEXT AS (JSON_VALUE(data, '$.description')) VIRTUAL;
ALTER TABLE collection_rows ADD FULLTEXT INDEX ft_coll1_description (_ft_description);

-- field: "expired_at" (date, is_searchable=true)
ALTER TABLE collection_rows
ADD COLUMN _idx_expired_at DATE AS (JSON_VALUE(data, '$.expired_at')) VIRTUAL,
ADD INDEX idx_coll1_expired_at (_idx_expired_at);
```

### ข้อจำกัด VARCHAR(191) ใน MariaDB/MySQL utf8mb4

- InnoDB max key length = 767 bytes (default) หรือ 3072 bytes (innodb_large_prefix)
- utf8mb4 = 4 bytes/char → 767 / 4 = **191 ตัวอักษร** (safe default)
- ข้อความเกิน 191 ตัวจะถูกตัด — ยังค้นหาได้แต่เป็น prefix match

---

## Data Flow

### Admin สร้าง Collection ใหม่

```
1. POST /admin-api/collections
   body: { name: "สินค้า", slug: "products", description: "..." }
   → INSERT INTO collections

2. POST /admin-api/collections/:id/fields
   body: { field_name: "ชื่อ", field_key: "name", field_type: "text", is_searchable: true }
   → INSERT INTO collection_fields
   → ถ้า is_searchable → ALTER TABLE เพิ่ม generated column + index

3. POST /admin-api/collections/:id/rows
   body: { data: { "name": "iPhone", "price": 35000 } }
   → Validate data ตาม field definitions (type, required, unique)
   → INSERT INTO collection_rows
   → ถ้ามี many_to_many relation → INSERT INTO collection_relations
```

### User/Public อ่านข้อมูล

```
4. GET /admin-api/collections/:slug/rows?search=iPhone&sort=price&order=desc
   → SELECT จาก collection_rows
   → ใช้ generated column ในการ WHERE / ORDER BY (ถ้ามี index)
   → JOIN collection_relations (ถ้ามี many_to_many)
   → Paginate ด้วย utils.py ที่มีอยู่
```

### Trash & Permanent Delete

```
ลบ (Soft delete):
5. DELETE /admin-api/collections/:id/rows/:row_id
   → is_deleted = True
   → row หายจาก list ปกติ แต่ยังอยู่ใน DB

ดูถังขยะ:
6. GET /admin-api/collections/:id/trash
   → SELECT WHERE is_deleted = True

กู้คืน:
7. POST /admin-api/collections/:id/trash/:row_id/restore
   → is_deleted = False
   → row กลับมาแสดงใน list ปกติ

ลบถาวร (Hard delete):
8. DELETE /admin-api/collections/:id/trash/:row_id
   → DELETE FROM collection_rows (ลบจริงจาก DB)
   → DELETE FROM collection_relations ที่เกี่ยวข้อง (CASCADE)
   → ข้อมูลหายถาวร กู้คืนไม่ได้

ล้างถังขยะทั้งหมด:
9. DELETE /admin-api/collections/:id/trash
   → DELETE FROM collection_rows WHERE collection_id = :id AND is_deleted = True
   → ลบจริงทุก row ในถังขยะของ collection นั้น
```

---

## ตัวอย่างข้อมูล

### สร้าง Collection "สินค้า"

**collections:**

| id | public_id | name | slug | admin_id |
|----|-----------|------|------|----------|
| 1 | uuid-aaa | สินค้า | products | 1 |

**collection_fields:**

| id | collection_id | field_name | field_key | field_type | is_required | is_searchable | options |
|----|--------------|-----------|-----------|------------|-------------|---------------|---------|
| 1 | 1 | ชื่อสินค้า | name | text | true | true | `{"max_length": 200}` |
| 2 | 1 | ราคา | price | number | true | true | `{"min": 0, "decimal_places": 2}` |
| 3 | 1 | หมวดหมู่ | category | select | false | true | `{"choices": ["อาหาร","เครื่องดื่ม","ของใช้"]}` |
| 4 | 1 | รูปภาพ | image | image | false | false | `{"max_size_mb": 5}` |
| 5 | 1 | แท็ก | tags | relation | false | false | `{"related_collection_id": 2, "relation_type": "many_to_many"}` |

**collection_rows:**

| id | public_id | collection_id | data |
|----|-----------|---------------|------|
| 1 | uuid-r01 | 1 | `{"name": "น้ำดื่ม", "price": 7.00, "category": "เครื่องดื่ม", "image": "/uploads/water.jpg"}` |
| 2 | uuid-r02 | 1 | `{"name": "ข้าวกล่อง", "price": 45.00, "category": "อาหาร", "image": "/uploads/rice.jpg"}` |

**collection_relations** (บทความ uuid-r01 มี 2 แท็ก):

| id | field_id | source_row_id | target_row_id |
|----|----------|--------------|---------------|
| 1 | 5 | 1 | 10 |
| 2 | 5 | 1 | 11 |

---

## แผนการดำเนินงาน

### Phase 1: Database & Models

- [ ] สร้าง SQLAlchemy models (4 ไฟล์)
  - `models/collection.py` — Collection model
  - `models/collection_field.py` — CollectionField model
  - `models/collection_row.py` — CollectionRow model
  - `models/collection_relation.py` — CollectionRelation model
- [ ] สร้าง Alembic migration
- [ ] ทดสอบ migration กับ MariaDB 12.0.2

### Phase 2: Validation & Indexing Service

- [ ] สร้าง `services/collection_service.py`
  - Validate row data ตาม field definitions (type check, required, unique)
  - จัดการ generated column + index เมื่อ `is_searchable` เปลี่ยน
  - จัดการ relation (many_to_one ใน JSON, many_to_many ใน table)
- [ ] สร้าง field type validators แยกตาม type

### Phase 3: Admin API Endpoints

- [ ] `POST   /admin-api/collections` — สร้าง collection
- [ ] `GET    /admin-api/collections` — list collections
- [ ] `GET    /admin-api/collections/:id` — ดู collection + fields
- [ ] `PUT    /admin-api/collections/:id` — แก้ไข collection
- [ ] `DELETE /admin-api/collections/:id` — soft delete

- [ ] `POST   /admin-api/collections/:id/fields` — เพิ่ม field
- [ ] `PUT    /admin-api/collections/:id/fields/:field_id` — แก้ field
- [ ] `DELETE /admin-api/collections/:id/fields/:field_id` — ลบ field

- [ ] `POST   /admin-api/collections/:id/rows` — เพิ่ม row
- [ ] `GET    /admin-api/collections/:id/rows` — list rows (filter, sort, paginate)
- [ ] `GET    /admin-api/collections/:id/rows/:row_id` — ดู row
- [ ] `PUT    /admin-api/collections/:id/rows/:row_id` — แก้ row
- [ ] `DELETE /admin-api/collections/:id/rows/:row_id` — soft delete row (ย้ายไปถังขยะ)

- [ ] `GET    /admin-api/collections/:id/trash` — ดู rows ในถังขยะ
- [ ] `POST   /admin-api/collections/:id/trash/:row_id/restore` — กู้คืน row
- [ ] `DELETE /admin-api/collections/:id/trash/:row_id` — ลบถาวร (hard delete)
- [ ] `DELETE /admin-api/collections/:id/trash` — ล้างถังขยะทั้งหมด

### Phase 4: Dashboard UI (Vue)

- [ ] หน้า Collections list
- [ ] หน้าสร้าง/แก้ไข Collection + กำหนด fields
- [ ] หน้า Collection rows (ตาราง data + filter/sort)
- [ ] หน้า Trash (ถังขยะ) — ดู, กู้คืน, ลบถาวร, ล้างทั้งหมด
- [ ] Form สร้าง/แก้ไข row (dynamic form ตาม field definitions)
- [ ] Relation picker component (many_to_one dropdown, many_to_many multi-select)

### Phase 5: User/Public API (ถ้าต้องการ)

- [ ] `GET /user-api/collections/:slug/rows` — public read-only API
- [ ] Rate limiting + permission control

---

## ข้อควรระวัง

1. **SQL Injection** — ห้ามใช้ string concatenation สร้าง ALTER TABLE ต้องใช้ parameterized หรือ whitelist field_key pattern (`^[a-z][a-z0-9_]*$`)
2. **field_key validation** — บังคับ lowercase alphanumeric + underscore เท่านั้น เพื่อใช้เป็น JSON key และ generated column name ได้ปลอดภัย
3. **Generated column limit** — MariaDB มี limit จำนวน virtual column ต่อ table (~1017) ไม่น่าถึง แต่ควร limit `is_searchable` fields ต่อ collection (แนะนำ max 10)
4. **Migration rollback** — เมื่อลบ field ที่ `is_searchable` ต้อง DROP generated column + index ด้วย
5. **Data consistency** — เมื่อแก้ field_type ที่มี data อยู่แล้ว ต้อง validate/migrate data เดิมด้วย
