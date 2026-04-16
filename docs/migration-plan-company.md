# Migration Plan: Company-based Multi-tenancy

## Overview

เปลี่ยนจากระบบเดิมที่ Admin ผูก Package โดยตรง → เป็นระบบ Company แบบ hierarchical
โดย **ไม่ต้องส่ง `company_id` ใน request body** — ใช้ Active Company จาก UI dropdown + header แทน

```
Company (id=1, parent_id=0)          ← Root company (platform owner)
  └── Admin (role=admin)             ← เดิมคือ super_admin
                                        สามารถสลับ company ผ่าน dropdown ได้

Company (parent_id=1)                ← Tenant company
  ├── package_id → packages          ← สิทธิ์ตาม package
  ├── Admin (role=admin/editor)      ← เห็นแค่ company ตัวเอง
  ├── User
  ├── Customer
  ├── InspectionItem
  └── ImportHistory
```

---

## Active Company (UI Dropdown)

### หลักการ

ไม่ต้องส่ง `company_id` ใน request body ของทุก API
แต่ระบุ company ที่กำลังใช้งานผ่าน **header `X-Company-Id`** ที่ frontend ส่งมาทุก request

### UI — dropdown มุมขวาบน (ข้าง profile)

```
┌──────────────────────────────────────────────────────┐
│  Header                                              │
│                        [▾ Company A]  👤 Profile      │
│                                                      │
│  กรณี root admin (company.parent_id == 0):           │
│  → dropdown แสดง company ลูกทั้งหมด (parent_id > 0)  │
│  → เลือกแล้ว frontend เก็บ active_company_id         │
│                                                      │
│  กรณี tenant admin:                                  │
│  → แสดงชื่อ company ตัวเอง (ไม่มี dropdown)           │
│  → ส่ง company_id ของตัวเองเสมอ                      │
└──────────────────────────────────────────────────────┘
```

### Flow

1. **Login** → backend return `companies` list ที่ admin เข้าถึงได้
   - root admin: return company ลูกทั้งหมด
   - tenant admin: return แค่ company ตัวเอง
2. **Frontend เก็บ `active_company_id`** → ส่งเป็น header `X-Company-Id` ทุก request
3. **Backend middleware** → อ่าน header แล้ว set `g.active_company`
4. **ทุก CRUD route** → ใช้ `g.active_company.id` อัตโนมัติ ไม่ต้องแก้ request body

### Backend Middleware

```python
@app.before_request
def set_active_company():
    if not hasattr(g, 'current_admin') or not g.current_admin:
        return

    admin = g.current_admin
    company_id = request.headers.get('X-Company-Id', type=int)

    if admin.company.parent_id == 0:
        # root admin — ใช้ company ที่เลือกจาก dropdown
        if company_id:
            company = Company.query.filter_by(id=company_id).first()
            if company and company.parent_id == admin.company.id:
                g.active_company = company
                return
        # ไม่ได้เลือก หรือ company_id ไม่ถูกต้อง
        g.active_company = None
    else:
        # tenant admin — ใช้ company ตัวเองเสมอ (ignore header)
        g.active_company = admin.company
```

### ตัวอย่าง API (ไม่ต้องเปลี่ยน request body)

```
# สร้าง customer — ไม่ต้องส่ง company_id
POST /api/admin/customers
Headers: X-Company-Id: 2
Body: { "customer_id": "C001", "name": "ลูกค้า A" }

# backend:
customer.company_id = g.active_company.id   ← อัตโนมัติ

# list customer — filter ตาม active company
GET /api/admin/customers
Headers: X-Company-Id: 2

# backend:
Customer.query.filter_by(company_id=g.active_company.id)
```

---

## สิ่งที่เปลี่ยน

| เดิม | ใหม่ |
|------|------|
| `admins.package_id` → packages | ลบออก — ใช้ `company.package_id` แทน |
| `AdminRole`: super_admin / admin / editor | **admin / editor** เท่านั้น |
| เช็ค super_admin ด้วย `self.role == SUPER_ADMIN` | เช็คด้วย `self.company.parent_id == 0` |
| ข้อมูลไม่มี scope | ทุก table มี `company_id` เพื่อแยกข้อมูลตาม company |
| API ต้องส่ง company_id ใน body | ใช้ header `X-Company-Id` + middleware อัตโนมัติ |

---

## Migration Steps

### Step 1: สร้างตาราง `companies`

```sql
CREATE TABLE companies (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    public_id   VARCHAR(36) UNIQUE NOT NULL,
    name        VARCHAR(200) NOT NULL,
    parent_id   INT NOT NULL DEFAULT 0,
    package_id  INT NULL,
    created_at  DATETIME,
    updated_at  DATETIME,
    FOREIGN KEY (package_id) REFERENCES packages(id) ON DELETE SET NULL
);
```

**Seed ข้อมูล:**
- สร้าง root company: `INSERT INTO companies (public_id, name, parent_id, package_id) VALUES (UUID(), 'Platform', 0, NULL)`
- สร้าง default tenant company: `INSERT INTO companies (public_id, name, parent_id, package_id) VALUES (UUID(), 'Default Company', 1, 1)`
  - `package_id=1` คือ default package ที่มีอยู่แล้ว

### Step 2: เพิ่ม `company_id` ให้ `admins`

```sql
ALTER TABLE admins ADD COLUMN company_id INT NULL;
ALTER TABLE admins ADD FOREIGN KEY (company_id) REFERENCES companies(id) ON DELETE SET NULL;
```

**Migrate ข้อมูลเดิม:**
```sql
-- super_admin → root company (id=1)
UPDATE admins SET company_id = 1 WHERE role = 'super_admin';

-- admin/editor → default tenant company (id=2)
UPDATE admins SET company_id = 2 WHERE role != 'super_admin';

-- super_admin → เปลี่ยนเป็น admin (เพราะ role จะถูกตัดสินจาก company.parent_id แทน)
UPDATE admins SET role = 'admin' WHERE role = 'super_admin';
```

### Step 3: เพิ่ม `company_id` ให้ `users`

```sql
ALTER TABLE users ADD COLUMN company_id INT NULL;
ALTER TABLE users ADD FOREIGN KEY (company_id) REFERENCES companies(id) ON DELETE SET NULL;

-- ย้าย user ทั้งหมดไป default tenant company
UPDATE users SET company_id = 2;
```

### Step 4: เพิ่ม `company_id` ให้ data tables

เพิ่ม `company_id` ให้ตารางที่ต้อง scope ตาม company:

**customers:**
```sql
ALTER TABLE customers ADD COLUMN company_id INT NULL;
ALTER TABLE customers ADD FOREIGN KEY (company_id) REFERENCES companies(id) ON DELETE CASCADE;
UPDATE customers SET company_id = 2;
```

**inspection_items:**
```sql
ALTER TABLE inspection_items ADD COLUMN company_id INT NULL;
ALTER TABLE inspection_items ADD FOREIGN KEY (company_id) REFERENCES companies(id) ON DELETE CASCADE;
UPDATE inspection_items SET company_id = 2;
```

**import_histories:**
```sql
ALTER TABLE import_histories ADD COLUMN company_id INT NULL;
ALTER TABLE import_histories ADD FOREIGN KEY (company_id) REFERENCES companies(id) ON DELETE CASCADE;
UPDATE import_histories SET company_id = 2;
```

**articles:**
```sql
ALTER TABLE articles ADD COLUMN company_id INT NULL;
ALTER TABLE articles ADD FOREIGN KEY (company_id) REFERENCES companies(id) ON DELETE CASCADE;
UPDATE articles SET company_id = 2;
```

### Step 5: ลบ `admins.package_id` และ `AdminRole.SUPER_ADMIN`

```sql
ALTER TABLE admins DROP FOREIGN KEY admins_ibfk_1;  -- FK ชื่ออาจต่างกัน
ALTER TABLE admins DROP COLUMN package_id;
```

- ลบ `SUPER_ADMIN` ออกจาก `AdminRole` enum
- อัปเดต `PackageRolePermission.role` enum ให้ไม่มี `super_admin`

### Step 6: อัปเดต `summary` triggers

- เพิ่ม summary row count แยกตาม company (หรือคงเป็น global ไว้ก่อน)

---

## Model Changes

### ใหม่: `models/company.py`

```python
class Company(db.Model):
    __tablename__ = 'companies'

    id         = Column(Integer, primary_key=True)
    public_id  = Column(String(36), unique=True, nullable=False, default=uuid4)
    name       = Column(String(200), nullable=False)
    parent_id  = Column(Integer, nullable=False, default=0)
    package_id = Column(Integer, ForeignKey('packages.id', ondelete='SET NULL'), nullable=True)
    created_at = Column(DateTime)
    updated_at = Column(DateTime)

    package = relationship('Package', backref='companies')
    admins  = relationship('Admin', backref='company')
    users   = relationship('User', backref='company')

    @property
    def is_root(self):
        return self.parent_id == 0
```

### แก้: `models/admin.py`

```python
class AdminRole(str, enum.Enum):
    ADMIN  = 'admin'
    EDITOR = 'editor'
    # ลบ SUPER_ADMIN

class Admin(...):
    # ลบ  package_id
    # เพิ่ม company_id
    company_id = Column(Integer, ForeignKey('companies.id'), nullable=True)

    @property
    def is_super_admin(self):
        # เปลี่ยนจากเช็ค role → เช็ค company
        return self.company and self.company.parent_id == 0

    def has_permission(self, resource, action):
        if self.is_super_admin:
            return True
        package_id = self.company.package_id if self.company else None
        # ... ใช้ package_id จาก company แทน
```

### แก้: `models/user.py`

```python
class User(...):
    company_id = Column(Integer, ForeignKey('companies.id'), nullable=True)
```

### แก้: data models (customer, inspection_item, import_history, article)

เพิ่ม `company_id` column ทุกตาราง

---

## API Changes

### Middleware (ใหม่): Active Company

- เพิ่ม `before_request` middleware อ่าน `X-Company-Id` header
- set `g.active_company` ให้ทุก request ใช้
- root admin: validate ว่า company_id เป็น child ของ root
- tenant admin: ใช้ company ตัวเองเสมอ (ignore header)

### admin_api/routes_auth.py

- **Login response** เพิ่ม:
  ```json
  {
    "token": "...",
    "admin": { ... },
    "companies": [
      { "id": "uuid", "name": "Company A" },
      { "id": "uuid", "name": "Company B" }
    ]
  }
  ```
  - root admin: return company ลูกทั้งหมด
  - tenant admin: return แค่ company ตัวเอง

### admin_api/routes_admin.py
- CRUD admin: scope ตาม `g.active_company`
- สร้าง admin ใหม่: ผูกกับ `g.active_company` อัตโนมัติ

### admin_api/routes_customer.py, routes_inspection_item.py
- List: `filter_by(company_id=g.active_company.id)`
- Create: `obj.company_id = g.active_company.id` อัตโนมัติ
- Update/Delete: validate ว่า obj อยู่ใน active company

### admin_api/routes_user.py
- CRUD user: scope ตาม `g.active_company`

### admin_api/routes_summary.py
- Summary count: filter ตาม `g.active_company.id`

### เพิ่มใหม่: admin_api/routes_company.py
- **GET /companies** — super_admin: list ทุก company, admin: เฉพาะ company ตัวเอง
- **GET /companies/accessible** — return companies สำหรับ dropdown (login ก็ใช้ได้)
- **POST /companies** — super_admin เท่านั้น: สร้าง tenant company ใหม่
- **PUT /companies/:id** — super_admin: แก้ชื่อ, เปลี่ยน package
- **DELETE /companies/:id** — super_admin: ลบ tenant company

---

## App User (Mobile/Frontend) Changes

### หลักการ

App user **ไม่ต้องเลือก company** — รู้จาก `user.company_id` ที่ถูก set ตอน admin สร้าง user

### Flow

1. **Admin สร้าง user** (ผ่าน dashboard) → `user.company_id = g.active_company.id` อัตโนมัติ
2. **User login** → backend รู้ company จาก `user.company_id` โดยตรง
3. **ทุก API ของ user** → filter ตาม `user.company_id` ไม่ต้องส่ง header

### Login Response (เพิ่ม company info)

```json
{
    "access_token": "...",
    "refresh_token": "...",
    "user": {
        "id": "uuid",
        "name": "John",
        "email": "john@example.com",
        "company": {
            "id": "uuid",
            "name": "Company A"
        }
    }
}
```

### Profile Response (เพิ่ม company name)

```json
GET /api/user/profile

{
    "id": "uuid",
    "name": "John",
    "email": "john@example.com",
    "company_name": "Company A"
}
```

### Sync API (filter ตาม company)

```python
# เดิม: ดึง articles ทั้งหมด
articles = Article.query.filter(Article.updated_at > since) ...

# ใหม่: filter ตาม user.company_id
articles = Article.query.filter(
    Article.updated_at > since,
    Article.company_id == user.company_id
) ...
```

### สรุป user_api ที่ต้องแก้

| Route | เปลี่ยน |
|-------|--------|
| `user_api/routes_auth.py` — login | response เพิ่ม `company` info |
| `user_api/routes_auth.py` — profile | response เพิ่ม `company_name` |
| `user_api/routes_sync.py` — sync | filter `Article.company_id == user.company_id` |

---

## Dashboard UI Changes

### Company Dropdown (มุมขวาบน ข้าง profile)

**ตำแหน่ง:** ข้าง `<a href="/profile">` ในส่วน header

```html
<!-- root admin: dropdown เลือก company -->
<select v-model="activeCompanyId" @change="switchCompany">
  <option v-for="c in companies" :value="c.id">{{ c.name }}</option>
</select>

<!-- tenant admin: แสดงชื่อ company เฉยๆ -->
<span>{{ company.name }}</span>
```

**Frontend logic:**
- Login สำเร็จ → เก็บ `companies` list จาก response
- เลือก company → เก็บ `activeCompanyId` ใน localStorage/store
- ทุก API call → ส่ง header `X-Company-Id: <activeCompanyId>`
- เปลี่ยน company → refresh data ในหน้าปัจจุบัน

---

## Flask-Migrate Commands (ลำดับการรัน)

```bash
# 1. สร้างตาราง companies + seed root & default tenant
flask db migrate -m "Create companies table"
# (แก้ไฟล์ migration เพิ่ม seed data ก่อน upgrade)
flask db upgrade

# 2. เพิ่ม company_id ให้ admins, users, data tables + migrate ข้อมูล
flask db migrate -m "Add company_id to admins users and data tables"
# (แก้ไฟล์ migration เพิ่ม UPDATE statements)
flask db upgrade

# 3. ลบ admins.package_id + อัปเดต AdminRole enum
flask db migrate -m "Remove package_id from admins and super_admin role"
flask db upgrade
```

---

## Checklist

### Models
- [ ] สร้าง `models/company.py`
- [ ] แก้ `models/admin.py` — เพิ่ม company_id, ลบ package_id, ลบ SUPER_ADMIN, แก้ permission logic
- [ ] แก้ `models/user.py` — เพิ่ม company_id
- [ ] แก้ `models/customer.py` — เพิ่ม company_id
- [ ] แก้ `models/inspection_item.py` — เพิ่ม company_id
- [ ] แก้ `models/import_history.py` — เพิ่ม company_id
- [ ] แก้ `models/article.py` — เพิ่ม company_id
- [ ] แก้ `models/__init__.py` — export Company

### Migrations
- [ ] สร้าง migration step 1 (companies table + seed)
- [ ] สร้าง migration step 2 (company_id columns + data migration)
- [ ] สร้าง migration step 3 (drop package_id + enum cleanup)

### Backend API
- [ ] เพิ่ม Active Company middleware (`before_request` + `g.active_company`)
- [ ] สร้าง `admin_api/routes_company.py` — CRUD company + accessible endpoint
- [ ] แก้ `admin_api/routes_auth.py` — login return companies list
- [ ] แก้ `admin_api/routes_admin.py` — scope by active company
- [ ] แก้ `admin_api/routes_customer.py` — filter by active company
- [ ] แก้ `admin_api/routes_inspection_item.py` — filter by active company
- [ ] แก้ `admin_api/routes_user.py` — scope by active company
- [ ] แก้ `admin_api/routes_summary.py` — count by active company
- [ ] แก้ `decorators.py` — ถ้ามี permission check ต้องอัปเดต

### User API (App)
- [ ] แก้ `user_api/routes_auth.py` — login response เพิ่ม company info
- [ ] แก้ `user_api/routes_auth.py` — profile response เพิ่ม company_name
- [ ] แก้ `user_api/routes_sync.py` — sync filter `Article.company_id == user.company_id`
- [ ] แก้ `models/user.py` — `to_dict()` เพิ่ม company_name

### Dashboard UI
- [ ] เพิ่ม company dropdown ที่ header (มุมขวาบน ข้าง profile)
- [ ] Frontend: เก็บ `activeCompanyId` ใน store
- [ ] Frontend: ส่ง `X-Company-Id` header ทุก API call
- [ ] Frontend: เปลี่ยน company → refresh data

### อื่นๆ
- [ ] อัปเดต summary triggers (ถ้าต้อง scope ตาม company)
- [ ] ทดสอบ: สร้าง company, ผูก package, สร้าง admin/user, CRUD data scoped by company
- [ ] ทดสอบ: root admin สลับ company ผ่าน dropdown แล้วข้อมูลเปลี่ยนตาม
