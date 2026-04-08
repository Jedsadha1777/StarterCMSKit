# Auth & Session — Lite Edition

เวอร์ชันย่อของ `auth-session-design.md` — แก้น้อยที่สุด ได้ผลมากที่สุด ไม่ใช้ Redis

---

## แนวคิด

ใช้ `session_version` (INT) เพิ่ม 1 column ในตาราง `admins` แทนการสร้างตาราง session ใหม่

```
Login   → version++  → ฝังลง JWT
Logout  → version++  → JWT เก่าใช้ไม่ได้ทันที
ถูกเตะ  → version++  → JWT เก่าใช้ไม่ได้ทันที
```

ไม่ต้องมี blacklist table, session table, SSE, grace period, token family

---

## เทียบกับ Full Edition

| | Lite (เอกสารนี้) | Full (auth-session-design.md) |
|---|---|---|
| แก้ DB | เพิ่ม 1 column | สร้าง 3 ตารางใหม่ |
| ตาราง session | ไม่มี | admin_sessions + user_sessions |
| Blacklist table | ลบได้ | ลบได้ |
| 1 admin : 1 session | ได้ | ได้ |
| รู้ว่าโดนเตะ | ตอนเรียก API ครั้งถัดไป | SSE realtime |
| Grace period | ไม่มี (ตัดทันที) | 30 วินาที |
| Reuse detection | ไม่มี (พึ่ง token หมดอายุ) | token family |
| รู้ว่าใครออนไลน์ | ไม่ได้ | ได้ |
| รู้ IP ที่ login | ไม่ได้ | ได้ |
| Offline sync | ไม่มี | version-based |
| เหมาะกับ | ≤ 10 admins, MVP | Production, หลาย admin |

---

## Schema Change

```sql
ALTER TABLE admins ADD COLUMN session_version INT NOT NULL DEFAULT 0;
```

เท่านี้ ไม่ต้องสร้างตารางใหม่

---

## Token Specification

### Access Token (JWT)

```json
{
  "sub": "1",
  "user_type": "admin",
  "sv": 5,
  "iat": 1712563200,
  "exp": 1712564100
}
```

| Field | คำอธิบาย |
|---|---|
| `sub` | admin_id หรือ user_id |
| `user_type` | `admin` หรือ `user` |
| `sv` | session_version ณ ตอน login — ใช้เทียบกับ DB |
| Lifetime | 15 นาที |

### Refresh Token (JWT)

ยังเป็น JWT เหมือนเดิม แต่มี `sv` เพิ่ม — ถ้า version ไม่ตรงก็ refresh ไม่ได้

---

## Flows

### 1. Login — Single Session Enforcement

```
Client                              Server
  │                                    │
  ├─ POST /admin-api/login ──────────►│
  │  {email, password}                 │
  │                                    ├─ Validate credentials
  │                                    ├─ admin.session_version += 1
  │                                    ├─ db.commit()
  │                                    ├─ JWT claims = {sv: admin.session_version}
  │                                    │
  │◄── 200 ──────────────────────────┤
  │  {access_token, refresh_token, admin}
  │

ผลลัพธ์:
  Admin A login  → session_version = 5 → JWT {sv: 5}
  Admin B login  → session_version = 6 → JWT {sv: 6}
  Admin A เรียก API → JWT {sv: 5} ≠ DB {sv: 6} → 401
```

### 2. Request Validation

```
Client                              Server
  │                                    │
  ├─ GET /admin-api/articles ────────►│
  │  Authorization: Bearer <JWT>       │
  │                                    ├─ Decode JWT → sub, user_type, sv
  │                                    │
  │                                    ├─ user_type != 'admin' → 403
  │                                    │
  │                                    ├─ Check version_cache (in-memory, TTL=10s)
  │                                    │  ├─ HIT  → เทียบ sv กับ cached version
  │                                    │  └─ MISS → query DB:
  │                                    │           SELECT session_version FROM admins WHERE id=?
  │                                    │           cache ผลลัพธ์ TTL=10s
  │                                    │
  │                                    ├─ JWT sv == DB session_version → ✅ handler
  │                                    ├─ JWT sv != DB session_version → ❌ 401
  │                                    │  {
  │                                    │    "code": "SESSION_REPLACED",
  │                                    │    "message": "บัญชีนี้ถูกเข้าสู่ระบบจากอุปกรณ์อื่น"
  │                                    │  }
```

### 3. Logout

```
Client                              Server
  │                                    │
  ├─ POST /admin-api/logout ─────────►│
  │                                    ├─ Decode JWT → sub, sv
  │                                    ├─ admin.session_version += 1
  │                                    ├─ db.commit()
  │                                    ├─ version_cache.invalidate(admin_id)
  │                                    │
  │◄── 200 ──────────────────────────┤
  │  {"message": "Logged out"}         │

ผลลัพธ์:
  Token เก่า (sv=5) ใช้ไม่ได้ทันที เพราะ DB version เป็น 6 แล้ว
  ไม่ต้องเก็บ token ลง blacklist
```

### 4. Refresh

```
Client                              Server
  │                                    │
  ├─ POST /admin-api/refresh ────────►│
  │  Authorization: Bearer <refresh>   │
  │                                    ├─ Decode refresh JWT → sub, sv
  │                                    ├─ user_type != 'admin' → 403
  │                                    ├─ SELECT session_version FROM admins WHERE id=?
  │                                    ├─ sv != session_version → 401 SESSION_REPLACED
  │                                    ├─ สร้าง access_token + refresh_token ใหม่
  │                                    │  (sv เท่าเดิม ไม่ increment)
  │                                    │
  │◄── 200 ──────────────────────────┤
  │  {access_token, refresh_token}     │
```

---

## Version Cache (In-Memory)

```
version_cache = {admin_id: (session_version, expire_time)}

ลด DB query:
  ├─ Cache HIT      → 0 query    ~0ms
  └─ Cache MISS     → 1 query    ~0.1ms
     └─ cache ไว้ TTL=10 วินาที

Invalidate เมื่อ:
  ├─ login   → version_cache.invalidate(admin_id)
  └─ logout  → version_cache.invalidate(admin_id)

Worst case: โดนเตะแล้วยังใช้ได้อีก 10 วินาที (ก่อน cache expire)
  → ยอมรับได้ เพราะ access token เองก็อยู่ได้ 15 นาทีอยู่แล้ว
```

---

## User API — ไม่เปลี่ยน

User API ใช้ระบบเดิม (JWT + blacklist) เพราะ:
- User login ได้หลายเครื่อง → ไม่ต้อง single session
- Mobile app ที่ net ไม่เสถียร → blacklist + rotating refresh token เพียงพอ
- ถ้าต้องการ offline sync ในอนาคต → ค่อย upgrade ไป Full Edition

---

## Error Response

```json
{
  "code": "ERROR_CODE",
  "message": "Human readable message"
}
```

| Code | HTTP | คำอธิบาย |
|---|---|---|
| `SESSION_REPLACED` | 401 | session_version ไม่ตรง (ถูก login ทับ หรือ logout แล้ว) |
| `WRONG_USER_TYPE` | 403 | JWT user_type ไม่ตรงกับ endpoint |
| `INVALID_TOKEN` | 401 | Token ไม่ถูกต้อง |

---

## สิ่งที่ต้องแก้ (สรุป)

```
แก้ DB:
  └─ ALTER TABLE admins ADD COLUMN session_version INT NOT NULL DEFAULT 0

แก้ Backend:
  ├─ admin login   → session_version += 1, ฝัง sv ลง JWT
  ├─ admin logout  → session_version += 1 (แทน blacklist)
  ├─ admin refresh → เช็ค sv ก่อน ไม่ตรง = 401
  ├─ decorators    → เพิ่มเช็ค sv + user_type + in-memory cache
  └─ extensions    → admin ไม่ใช้ blacklist แล้ว (user ยังใช้)

แก้ Frontend:
  └─ Dashboard interceptor: เจอ code=SESSION_REPLACED → แสดง alert → redirect login

ไม่ต้องแก้:
  └─ User API ทั้งหมด (ใช้ระบบเดิม)
```

---

## Upgrade Path

เมื่อพร้อม สามารถ upgrade ไป Full Edition ได้ทีละส่วน:

```
Phase 1 (เอกสารนี้):
  session_version + in-memory cache
  → ได้ single session, ลบ admin blacklist

Phase 2:
  เพิ่ม admin_sessions table
  → ได้ IP tracking, รู้ว่าใครออนไลน์

Phase 3:
  เพิ่ม SSE + grace period
  → ได้ realtime notification, in-flight request protection

Phase 4:
  เพิ่ม user_sessions + reuse detection + offline sync
  → ได้ระบบเต็มรูปแบบ
```
