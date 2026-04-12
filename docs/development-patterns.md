# Development Patterns

กฎและ pattern ที่ใช้ในโปรเจกต์นี้ เพื่อให้โค้ดสอดคล้องกันทั้ง backend และ frontend

---

## 1. Backend — Model

**ไฟล์:** `backendAPI/models/<entity>.py`

### Field Naming Convention

| ประเภท | Pattern | ตัวอย่าง |
|--------|---------|----------|
| Primary key | `id` (Integer, auto increment) | ใช้ภายใน ไม่ expose ให้ API |
| Public ID | `public_id` (String UUID) | ใช้ใน API แทน `id` จริง |
| Timestamp สร้าง | `created_at` (DateTime) | |
| Timestamp แก้ไข | `updated_at` (DateTime) | |
| Foreign key | `<entity>_id` | `admin_id`, `created_by`, `package_id` |
| Boolean | `is_<state>` | `is_deleted`, `is_used` |
| Status/Role | `status`, `role` (String หรือ Enum) | |

### DateTime — Naive UTC เสมอ

```python
from datetime import datetime, timezone

# ✅ ถูก
created_at = db.Column(db.DateTime, default=lambda: datetime.now(timezone.utc).replace(tzinfo=None))
updated_at = db.Column(db.DateTime,
    default=lambda: datetime.now(timezone.utc).replace(tzinfo=None),
    onupdate=lambda: datetime.now(timezone.utc).replace(tzinfo=None))

# ❌ ผิด — ห้ามเก็บ timezone-aware datetime
created_at = db.Column(db.DateTime, default=lambda: datetime.now(timezone.utc))
```

### to_dict()

- return `'id': self.public_id` เสมอ — ไม่ expose internal `id`
- DateTime ใช้ `.isoformat()` พร้อม null check
- FK relation ให้ return `public_id` ของ relation ไม่ใช่ internal id

```python
def to_dict(self):
    return {
        'id': self.public_id,                    # ← public_id เสมอ
        'created_at': self.created_at.isoformat() if self.created_at else None,
        'author_id': self.admin_author.public_id if self.admin_author else None,
    }
```

### ลงทะเบียน Model

เมื่อสร้าง model ใหม่ต้องแก้ 2 ไฟล์:

1. `models/__init__.py` — เพิ่ม import และ `__all__`
2. `app.py` — เพิ่ม import ใน `create_app()` (บรรทัด `from models import ...`)

---

## 2. Backend — Routes

**ไฟล์:** `backendAPI/admin_api/routes_<entity>.py`

### Import Pattern

```python
from flask import request, jsonify
from flask_jwt_extended import jwt_required
from admin_api import admin_bp
from extensions import db
from models import MyModel                    # ← import เฉพาะ model ที่ใช้จริง
from decorators import admin_required
from utils import paginate_query, apply_filters, apply_sorting, ...  # ← ใช้ utility ที่มี
from datetime import datetime                 # ← import ปกติ ห้ามใช้ __import__()
```

**กฎสำคัญ:**
- import เฉพาะ model ที่ใช้จริงในไฟล์ — ไม่ import เผื่อ
- ห้ามใช้ `__import__()` — ใช้ `from ... import ...` เสมอ

### Decorator Stack

ทุก admin endpoint ต้องใส่ครบ 3 ชั้น ตามลำดับนี้:

```python
@admin_bp.route('/entities', methods=['GET'])
@jwt_required()
@admin_required
def get_entities(admin):         # ← admin inject จาก @admin_required
    ...
```

### Permission Check

| Action | Check ที่ route | หมายเหตุ |
|--------|----------------|----------|
| GET list | ไม่ check | sidebar/router จัดการแล้ว |
| GET single | ไม่ check | |
| POST create | `admin.has_permission('resource', 'create')` | |
| PUT update | `admin.has_permission('resource', 'edit')` | |
| DELETE | `admin.has_permission('resource', 'delete')` | |

```python
# ✅ ถูก — check ที่ create/edit/delete
if not admin.has_permission('customers', 'create'):
    return jsonify({'message': 'Permission denied'}), 403

# ❌ ผิด — ไม่ต้อง check ที่ GET list
if not admin.has_permission('customers', 'view'):  # ไม่จำเป็น
```

### CRUD Pattern

```python
# GET list — ใช้ apply_filters + apply_sorting + paginate_query + format_paginated
result = paginate_query(query, default_per_page=10)
return format_paginated('entities', result)

# POST create — validate → check unique → create → commit
err = validate_required(data, ['field1', 'field2'])
if err: return err

# GET single — ใช้ get_or_404
entity, err = get_or_404(Model, public_id)
if err: return err

# PUT update — get_or_404 → update fields → commit
# DELETE — get_or_404 → db.session.delete() หรือ soft delete
```

### Fuzzy Search (OR)

สำหรับค้นหาจากหลาย field พร้อมกัน ใช้ `search_logic='OR'` จาก frontend:

```python
filters = {
    'customer_id': {'type': 'fuzzy'},
    'name': {'type': 'fuzzy'},
}
query = apply_filters(query, Model, filters, search_logic='AND')
# frontend ส่ง ?customer_id=xxx&name=xxx&search_logic=OR
```

### Filter Types ที่มี

| Type | ใช้กับ | ตัวอย่าง |
|------|--------|----------|
| `fuzzy` | ค้นหา LIKE %value% | `'name': {'type': 'fuzzy'}` |
| `exact` | ค่าตรง = | `'status': {'type': 'exact'}` |
| `range` | min/max | `'created_at': {'type': 'range', 'cast': lambda x: datetime.fromisoformat(x)}` |
| `relation` | ค้นจาก table อื่น | `'author_email': {'type': 'relation', 'model': Admin, 'field': 'email'}` |
| `array` | หลายค่า comma-separated | `'tags': {'type': 'array'}` |
| `bool` | true/false | `'is_active': {'type': 'bool'}` |
| `enum` | ค่าที่กำหนด | `'status': {'type': 'enum', 'values': ['draft', 'published']}` |

### Validation

ใช้ utility functions จาก `utils.py` เสมอ — ไม่สร้าง validation function ใน route file:

```python
# ✅ ถูก — ใช้จาก utils.py
from utils import validate_required, validate_password, validate_alphanumeric

err = validate_required(data, ['name', 'email'])
if err: return err

# ❌ ผิด — สร้าง function เฉพาะใน route
def _validate_my_field(value):
    ...
```

ถ้าต้องการ validation ใหม่ → เพิ่มใน `utils.py` เป็น function กลาง

### ลงทะเบียน Route

เมื่อสร้าง routes ใหม่ต้องแก้ 1 ไฟล์:

- `admin_api/__init__.py` — เพิ่ม `from admin_api import routes_<entity>`

---

## 3. Backend — Migration

**ไฟล์:** `backendAPI/migrations/versions/<revision_id>_<description>.py`

### Revision Chain

migration ต่อกันเป็น chain ผ่าน `down_revision`:

```python
revision = 'l2g3h4i5j6k7'
down_revision = 'k1f2g3h4i5j6'   # ← ชี้ไป revision ก่อนหน้า
```

### แยก schema กับ seed

- สร้างตาราง → migration ไฟล์แรก
- seed ข้อมูล (permissions, limits) → migration ไฟล์แยก

### RBAC — เพิ่ม resource ใหม่

เมื่อเพิ่ม entity ใหม่ต้อง seed ลง 2 ตาราง:

1. `package_role_permissions` — กำหนด permission ต่อ role
2. `package_limits` — กำหนด limit (-1 = unlimited)

```
admin  → view, create, edit, delete (ครบ CRUD)
editor → view, create, edit          (ไม่มี delete)
super_admin → ไม่ต้อง seed (bypass ทั้งหมดใน code)
```

---

## 4. Frontend — API Service

**ไฟล์:** `dashboard/src/api.js`

### Naming Convention

ทุก entity ใช้ 5 methods ตาม pattern เดียวกัน:

```javascript
getEntities(params = {})         // GET    /entities
getEntity(id)                    // GET    /entities/:id
createEntity(data)               // POST   /entities
updateEntity(id, data)           // PUT    /entities/:id
deleteEntity(id)                 // DELETE /entities/:id
```

---

## 5. Frontend — Views

### List Page

**ไฟล์:** `dashboard/src/views/<Entities>.vue`

ใช้ components: `ListPage` + `DataTable` + composable `useDataTable`

```javascript
// columns definition
const columns = [
  { key: 'field', label: 'Label', sortable: true, width: '160px' },
  { key: 'created_at', label: 'Created', sortable: true, width: '140px', nowrap: true },
]

// load function
const params = { page: dt.page.value, per_page: dt.perPage() }
params.sort_by = dt.sortParam.value
const { data } = await api.getEntities(params)
dt.items.value = data.entities       // ← key ตรงกับ format_paginated ใน backend
dt.total.value = data.total
dt.totalPages.value = data.pages
```

**Fuzzy search จากหลาย field:**

```javascript
if (search.value) {
  params.field1 = search.value
  params.field2 = search.value
  params.search_logic = 'OR'
}
```

**DateTime column ต้อง format:**

```html
<template #cell-created_at="{ item }">{{ formatDate(item.created_at) }}</template>
```

### Form Page

**ไฟล์:** `dashboard/src/views/<Entity>Form.vue`

- ถ้า form มี fields เหมือน `ResourceForm` (name, email, password) → ใช้ `ResourceForm` component
- ถ้า form มี fields ต่างจากนั้น → สร้าง custom form ใช้ `FormPage` component ตรง

```javascript
const isEdit = computed(() => !!route.params.id)

// onMounted → load data ถ้า edit mode
// handleSubmit → create หรือ update ตาม isEdit
// router.push(backTo) เมื่อสำเร็จ
```

---

## 6. Frontend — Router & Menu

### Router

**ไฟล์:** `dashboard/src/router.js`

ทุก entity มี 3 routes:

```javascript
{ path: '/entities',          name: 'Entities',    component: Entities,    meta: { requiresAuth: true, requires: 'entities.view' } },
{ path: '/entities/new',      name: 'EntityNew',   component: EntityForm,  meta: { requiresAuth: true, requires: 'entities.create' } },
{ path: '/entities/:id/edit', name: 'EntityEdit',  component: EntityForm,  meta: { requiresAuth: true, requires: 'entities.edit' } },
```

- `meta.requires` ใช้ format `resource.action` ตรงกับ `package_role_permissions`
- import component ที่ด้านบนไฟล์ ไม่ใช้ lazy import

### Sidebar Menu

**ไฟล์:** `dashboard/src/App.vue`

```javascript
const allNavItems = [
  { to: '/entities', icon: 'mdi-xxx', title: 'Entities', match: '/entities', requires: 'entities.view' },
]
```

- `requires` ควบคุมการแสดงเมนูตาม permission
- `match` ใช้สำหรับ highlight active state (`route.path.startsWith(item.match)`)
- Dashboard (`/`) ไม่มี `requires` — แสดงเสมอ

---

## 7. Export / Import Excel

### Export Pattern

**Endpoint:** `GET /admin-api/<entities>/export`
**Permission:** ใช้ `<entity>.view` (ดูได้ = export ได้)

- ไม่ expose `public_id` (UUID) ใน Excel — ใช้ field ID ที่ user กรอกเองแทน
- ใช้ `openpyxl` สร้าง workbook → `send_file(BytesIO, ...)`
- column ที่เป็น reference (เช่น created_by) ให้ export เป็นชื่อ ไม่ใช่ ID

### Import Pattern — 2 Step (Preview → Confirm)

| Step | Endpoint | หน้าที่ |
|------|----------|---------|
| 1 | `POST /<entities>/import/preview` | อ่าน Excel → validate → return preview (ไม่ save) |
| 2 | `POST /<entities>/import/confirm` | save เฉพาะ row ที่ user เลือก + เก็บไฟล์ลง history |

**Permission:** ต้องมีทั้ง `<entity>.create` + `<entity>.edit` (เพราะทำทั้ง insert และ update)

**Preview logic:**
1. อ่าน header row → map column
2. validate ทุก row (required, format)
3. เทียบกับ DB → กำหนด status:
   - `new` — ไม่มีใน DB → จะ insert
   - `replace` — มีอยู่แล้ว → จะ update (return ค่าเดิมใน `existing`)
   - `error` — validation ไม่ผ่าน (return `errors[]`)

**Frontend preview table:**
- แต่ละ row มี checkbox — user เลือกได้ว่าจะ import row ไหน
- `new` / `replace` → checkbox เปิด default
- `error` → checkbox disabled
- `replace` → แสดงค่าเดิม strikethrough เทียบค่าใหม่

**Confirm:** ส่งเฉพาะ row ที่เลือก + ไฟล์ Excel เดิม (เก็บลง history)

### Import History

**Model:** `ImportHistory` — เก็บ original_filename, stored_filename, imported_by, created_at
**ไฟล์เก็บที่:** `static/imports/` (ตาม pattern ที่ settings upload ใช้ `static/`)

| Method | Endpoint | หน้าที่ |
|--------|----------|---------|
| `GET` | `/<entities>/import/history` | ดูรายการ import (paginated) |
| `GET` | `/<entities>/import/history/<id>/download` | ดาวน์โหลดไฟล์ Excel เดิม |
| `DELETE` | `/<entities>/import/history/<id>` | ลบ record + ไฟล์ |

### Frontend Components

| Component | ใช้ทำอะไร |
|-----------|----------|
| `ImportPreviewDialog.vue` | แสดงตาราง preview + checkbox + confirm |
| `ImportHistoryDialog.vue` | แสดงรายการ import history + download/delete |

ทั้งสอง component วางไว้ใน `components/` เป็น dialog reusable

---

## 8. Checklist — เพิ่ม Entity ใหม่

เวลาเพิ่ม resource ใหม่ ทำตาม checklist นี้:

### Backend (6 ขั้นตอน)

- [ ] สร้าง `models/<entity>.py` — ตาม field naming convention
- [ ] แก้ `models/__init__.py` — เพิ่ม import + `__all__`
- [ ] แก้ `app.py` — เพิ่ม import ใน `create_app()`
- [ ] สร้าง migration — สร้างตาราง
- [ ] สร้าง migration — seed permissions (admin CRUD, editor view/create/edit)
- [ ] สร้าง `admin_api/routes_<entity>.py` — CRUD + filters
- [ ] แก้ `admin_api/__init__.py` — เพิ่ม import routes

### Frontend (4 ขั้นตอน)

- [ ] แก้ `api.js` — เพิ่ม 5 methods (get list, get one, create, update, delete)
- [ ] สร้าง `views/<Entities>.vue` — list page
- [ ] สร้าง `views/<Entity>Form.vue` — form page
- [ ] แก้ `router.js` — เพิ่ม 3 routes + import
- [ ] แก้ `App.vue` — เพิ่มใน `allNavItems`

### Export / Import (ถ้าต้องการ)

- [ ] เพิ่ม `openpyxl` ใน `requirements.txt` (ถ้ายังไม่มี)
- [ ] สร้าง `ImportHistory` model + migration (ถ้ายังไม่มี)
- [ ] เพิ่ม export/import/history endpoints ใน routes
- [ ] เพิ่ม API methods ใน `api.js`
- [ ] สร้าง `ImportPreviewDialog.vue` + `ImportHistoryDialog.vue` (หรือ reuse ที่มี)
- [ ] เพิ่มปุ่ม Export / Import / History ใน list page

### Validation

- [ ] validation ใหม่ → เพิ่มใน `utils.py` ไม่ใช่ใน route file
- [ ] frontend validation → ใช้ `:rules` ของ Vuetify
