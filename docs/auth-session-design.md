# Auth & Session Design

## Overview

ระบบ authentication แบ่งเป็น 2 ส่วนที่ออกแบบต่างกันตามลักษณะการใช้งาน:

| | Admin API | User API |
|---|---|---|
| ใช้กับ | Dashboard (Vue) | Mobile App (Flutter) |
| Session | **1 admin : 1 session** (Whitelist) | Multi-device ได้ |
| Refresh token | Opaque, rotate | Opaque, rotate + reuse detection |
| Notification | SSE realtime | - |
| Offline | ไม่ต้อง | Local DB + delta sync |
| Blacklist table | ไม่ใช้ (ลบได้) | ไม่ใช้ (ลบได้) |

---

## Database Schema

### admin_sessions

```sql
CREATE TABLE admin_sessions (
    id                      VARCHAR(36)  PRIMARY KEY,
    admin_id                INT          NOT NULL,
    refresh_token_hash      VARCHAR(255) NOT NULL,
    token_family            VARCHAR(36)  NOT NULL,
    is_used                 BOOLEAN      DEFAULT 0,
    used_at                 DATETIME     NULL,
    status                  ENUM('active','grace_period','revoked') DEFAULT 'active',
    grace_until             DATETIME     NULL,
    replaced_by_session_id  VARCHAR(36)  NULL,
    ip_address              VARCHAR(45),
    user_agent              VARCHAR(255),
    created_at              DATETIME     DEFAULT CURRENT_TIMESTAMP,
    last_active_at          DATETIME     DEFAULT CURRENT_TIMESTAMP,

    -- MySQL Generated Column: enforce 1 active session per admin
    -- NULL เมื่อไม่ active → UNIQUE ยอมให้ NULL ซ้ำได้
    active_admin_id         INT AS (CASE WHEN status = 'active' THEN admin_id ELSE NULL END) STORED,

    FOREIGN KEY (admin_id) REFERENCES admins(id),
    FOREIGN KEY (replaced_by_session_id) REFERENCES admin_sessions(id),
    UNIQUE INDEX idx_one_active_per_admin (active_admin_id),
    INDEX idx_admin_status (admin_id, status),
    INDEX idx_family (token_family)
);
```

**Design decisions:**

- `admin_id` ไม่ UNIQUE เพราะช่วง grace period จะมี 2 row ชั่วคราว (1 active + 1 grace_period)
- `active_admin_id` (Generated Column) บังคับที่ระดับ DB ว่ามี status='active' ได้เพียง 1 row ต่อ admin — MySQL UNIQUE index ยอมให้ NULL ซ้ำได้ ดังนั้น row ที่ status ≠ 'active' จะเป็น NULL และไม่ขัด constraint
- `replaced_by_session_id` ให้ Admin A (คนเก่า) query row ตัวเองครั้งเดียวก็รู้ว่าโดนเตะโดย session ไหน แล้ว JOIN ไปอ่าน IP/เวลาของ session ใหม่ได้เลย

### user_sessions

```sql
CREATE TABLE user_sessions (
    id                   VARCHAR(36)  PRIMARY KEY,
    user_id              INT          NOT NULL,
    refresh_token_hash   VARCHAR(255) NOT NULL,
    token_family         VARCHAR(36)  NOT NULL,
    is_used              BOOLEAN      DEFAULT 0,
    used_at              DATETIME     NULL,
    ip_address           VARCHAR(45),
    user_agent           VARCHAR(255),
    created_at           DATETIME     DEFAULT CURRENT_TIMESTAMP,
    expires_at           DATETIME     NOT NULL,
    last_active_at       DATETIME     DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (user_id) REFERENCES users(id),
    INDEX idx_user (user_id),
    INDEX idx_family (token_family)
);
```

### user_sync_cursors

```sql
CREATE TABLE user_sync_cursors (
    user_id      INT          NOT NULL,
    device_id    VARCHAR(36)  NOT NULL,
    last_sync_at DATETIME     NOT NULL,

    PRIMARY KEY (user_id, device_id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);
```

### articles (เพิ่ม version)

```sql
ALTER TABLE articles ADD COLUMN version INT NOT NULL DEFAULT 1;
```

ใช้สำหรับ Optimistic Locking ตอน offline sync — client ส่ง version มาด้วย server เทียบกับ version ปัจจุบันเพื่อตรวจจับ conflict

---

## Token Specification

### Access Token (JWT)

ใช้สำหรับทั้ง Admin และ User API

```json
{
  "sub": "1",
  "user_type": "admin",
  "session_id": "ses_xxx-xxx-xxx",
  "iat": 1712563200,
  "exp": 1712564100
}
```

| Field | คำอธิบาย |
|---|---|
| `sub` | admin_id หรือ user_id |
| `user_type` | `admin` หรือ `user` |
| `session_id` | FK ไปที่ admin_sessions.id หรือ user_sessions.id |
| Lifetime | 15 นาที |

### Refresh Token (Opaque)

ไม่ใช่ JWT — เป็น random string เก็บ hash ไว้ใน DB

| | Admin | User |
|---|---|---|
| Format | `rt_` + 48 chars (url-safe base64) | เหมือนกัน |
| Lifetime | 7 วัน | 90 วัน |
| Storage (server) | hash ใน admin_sessions | hash ใน user_sessions |
| Storage (client) | localStorage | Flutter secure_storage |
| Rotation | ทุกครั้งที่ refresh | ทุกครั้งที่ refresh |

---

## Security: JWT Cross-Type Validation

ป้องกัน User ทั่วไปเอา JWT ของตัวเองไปเรียก Admin API หรือกลับกัน

**ทุก request ต้องเช็ค 2 ชั้น:**

```
ชั้น 1: JWT claims — user_type ต้องตรงกับ endpoint
  @admin_required → user_type == 'admin'
  @user_required  → user_type == 'user'

ชั้น 2: Session table — session_id ต้องมีอยู่ในตารางที่ถูกต้อง
  admin endpoint → query admin_sessions (ไม่ใช่ user_sessions)
  user endpoint  → query user_sessions (ไม่ใช่ admin_sessions)
```

**กรณีโจมตี:**

```
Hacker มี user JWT {sub: "5", user_type: "user", session_id: "ses_user_xxx"}
พยายามเรียก GET /admin-api/articles

ชั้น 1: user_type == 'user' ≠ 'admin' → ❌ 403 ทันที (ไม่ถึง DB)
```

```
Hacker แก้ JWT (ถ้ารู้ secret) ใส่ user_type: "admin"
แต่ session_id ยังเป็นของ user_sessions

ชั้น 2: query admin_sessions WHERE id = 'ses_user_xxx' → ไม่เจอ → ❌ 401
```

---

## Admin API Flows

### 1. Login — Single Session Enforcement

```
Client                              Server
  │                                    │
  ├─ POST /admin-api/login ──────────►│
  │  {email, password}                 │
  │                                    ├─ Validate credentials
  │                                    ├─ BEGIN TRANSACTION
  │                                    ├─ SELECT * FROM admin_sessions
  │                                    │  WHERE admin_id=? AND status='active'
  │                                    │  FOR UPDATE                    ← lock row
  │                                    │
  │                                    │  (ถ้ามี session เก่า)
  │                                    ├─ UPDATE old → status='grace_period'
  │                                    │                grace_until=NOW()+30s
  │                                    │                replaced_by_session_id=new.id
  │                                    ├─ INSERT new session status='active'
  │                                    │  (active_admin_id generated column บังคับ unique)
  │                                    ├─ COMMIT
  │                                    │
  │                                    ├─ SSE → notify old session
  │                                    │        event: session_replaced
  │                                    │
  │◄── 200 ──────────────────────────┤
  │  {                                 │
  │    access_token,                   │
  │    refresh_token,                  │
  │    admin: {id, email},             │
  │    session: {id, ip, created_at},  │
  │    replaced_session: {             │  ← null ถ้าไม่มี session เก่า
  │      ip_address,                   │
  │      last_active_at                │
  │    }                               │
  │  }                                 │
```

### 2. Request Validation — Cache + Grace Period

```
Client                              Server
  │                                    │
  ├─ GET /admin-api/articles ────────►│
  │  Authorization: Bearer <JWT>       │
  │                                    ├─ Decode JWT → session_id, user_type
  │                                    │
  │                                    ├─ user_type != 'admin' → 403 (ไม่ query DB)
  │                                    │
  │                                    ├─ Check session_cache (in-memory, TTL=10s)
  │                                    │  ├─ HIT (valid)  → skip DB query ──────► handler
  │                                    │  ├─ HIT (invalid)→ 401 immediately
  │                                    │  └─ MISS → query DB:
  │                                    │
  │                                    ├─ SELECT * FROM admin_sessions WHERE id=?
  │                                    │  ├─ status='active'       → cache(valid) → handler
  │                                    │  ├─ status='grace_period'
  │                                    │  │  └─ grace_until > NOW  → handler (ไม่ cache)
  │                                    │  │  └─ grace_until <= NOW → UPDATE revoked → 401
  │                                    │  ├─ status='revoked'      → cache(invalid) → 401
  │                                    │  └─ not found             → cache(invalid) → 401
```

### 3. Refresh Token — Rotation

```
Client                              Server
  │                                    │
  ├─ POST /admin-api/refresh ────────►│
  │  {refresh_token}                   │
  │  Authorization: Bearer <JWT>       │
  │                                    ├─ Decode JWT → session_id, user_type
  │                                    ├─ user_type != 'admin' → 403
  │                                    ├─ BEGIN TRANSACTION
  │                                    ├─ SELECT * FROM admin_sessions
  │                                    │  WHERE id=? FOR UPDATE
  │                                    │
  │                                    ├─ verify hash(refresh_token) == stored hash
  │                                    │  └─ ไม่ตรง → 401 INVALID_TOKEN
  │                                    │
  │                                    ├─ Check is_used (→ ดูหัวข้อ Reuse Detection)
  │                                    │
  │                                    ├─ Normal rotation:
  │                                    │  UPDATE old → is_used=true, used_at=NOW, status='revoked'
  │                                    │  INSERT new → same token_family, new refresh_token_hash
  │                                    ├─ COMMIT
  │                                    │
  │◄── 200 ──────────────────────────┤
  │  {                                 │
  │    access_token (new),             │
  │    refresh_token (new),            │
  │    session: {id, last_active_at}   │
  │  }                                 │
```

### 4. Reuse Detection

```
ตอน refresh: server เจอว่า is_used = true

├─ (NOW - used_at) <= 30 วินาที?
│  └─ YES: Network retry
│     ส่ง token ชุดใหม่ที่สร้างไว้แล้วกลับไป (same family, is_used=false)
│     ← ป้องกัน response หายเพราะ network ไม่เสถียร
│
│  └─ NO: Token theft detected
│     UPDATE admin_sessions SET status='revoked' WHERE token_family=?
│     ← revoke ทั้ง family
│     SSE → event: security_alert
│     ← 401 TOKEN_REUSE_DETECTED

Response (theft):
{
  "code": "TOKEN_REUSE_DETECTED",
  "message": "ตรวจพบการใช้ Token ซ้ำ Session ถูกยกเลิกทั้งหมด"
}
```

### 5. SSE — Realtime Notification

```
Dashboard เปิด:
  EventSource → GET /admin-api/session/stream
  Server: sse_manager.connect(session_id) → เก็บ Queue ใน memory

Event types:
  ┌─────────────────────┬──────────────────────────────────────┐
  │ event               │ เมื่อไหร่                              │
  ├─────────────────────┼──────────────────────────────────────┤
  │ session_replaced    │ มีคนอื่น login ด้วย admin เดียวกัน        │
  │ security_alert      │ Token reuse detected                 │
  │ heartbeat (comment) │ ทุก 30 วินาที (keep-alive)              │
  └─────────────────────┴──────────────────────────────────────┘

session_replaced payload:
{
  "code": "SESSION_REPLACED",
  "message": "บัญชีนี้ถูกเข้าสู่ระบบจากอุปกรณ์อื่น",
  "replaced_by": {
    "session_id": "ses_bbb-4f2a-8c1d",
    "ip_address": "203.150.xxx.xxx",
    "at": "2026-04-08T10:00:00Z"
  },
  "grace_seconds": 30
}

Routing:
  Single process  → In-memory dict {session_id: Queue}
  Multi process   → Redis Pub/Sub channel session:{session_id}
```

### 6. Session Replace — Race Condition Protection

```
กรณี Admin A ทำงานอยู่ + Admin B login พร้อมกัน:

T+0.0s  Admin A: POST /admin-api/articles (ลบบทความ)
        Middleware: session ses_aaa status='active' ✓ → เข้า handler

T+0.1s  Admin B: POST /admin-api/login
        BEGIN
          SELECT ... WHERE admin_id=1 AND status='active' FOR UPDATE
          UPDATE ses_aaa → status='grace_period'
                           grace_until=T+30s
                           replaced_by_session_id='ses_bbb'
          INSERT ses_bbb → status='active'
          (active_admin_id unique constraint ป้องกัน 2 active ซ้อนกัน)
        COMMIT
        SSE → แจ้ง ses_aaa

T+0.2s  Admin A handler: db.commit() → ✅ สำเร็จ
        (session เป็น grace_period แต่ handler เข้ามาก่อนแล้ว)

T+2.0s  Admin A: ได้รับ SSE → แสดง popup + countdown 28 วินาที

T+30s   Admin A: กดปุ่มอื่น → grace_until < NOW → 401 SESSION_REPLACED

---

กรณี 2 คน login admin เดียวกันพร้อมกัน:

T+0.0s  Admin B: SELECT ... FOR UPDATE → ได้ lock
T+0.0s  Admin C: SELECT ... FOR UPDATE → blocked (รอ lock)
T+0.1s  Admin B: INSERT ses_bbb → COMMIT → ปล่อย lock
T+0.1s  Admin C: ได้ lock → เห็น ses_bbb active → grace_period → INSERT ses_ccc
        ผลลัพธ์: ses_ccc active (ถูกต้อง)

หาก FOR UPDATE พลาด (edge case):
        active_admin_id UNIQUE constraint จะ reject INSERT ที่ 2 → rollback → retry
```

### 7. Session Cache

```
In-memory cache ลด DB query:

  Request เข้ามา
  ├─ Cache HIT (valid)    → 0 DB query    ~0ms
  ├─ Cache HIT (invalid)  → 0 DB query    ~0ms    → 401
  └─ Cache MISS           → 1 DB query    ~0.1ms  (PK lookup)
     └─ cache ผลลัพธ์ ไว้ TTL=10 วินาที

  ตอน replace session:
  └─ session_cache.invalidate(old_session_id)
     → ครั้งถัดไปเป็น MISS → query DB → เห็น grace_period/revoked

  TTL trade-off:
  ┌─────────┬─────────────┬────────────────────────┐
  │ TTL     │ ลด DB query │ ช้าสุดที่รู้ว่าโดนเตะ      │
  ├─────────┼─────────────┼────────────────────────┤
  │ 1 วินาที  │ ~50%        │ 1 วินาที                   │
  │ 10 วินาที │ ~90%        │ 10 วินาที (+ grace 30s)    │
  │ 30 วินาที │ ~95%        │ ไม่แนะนำ                  │
  └─────────┴─────────────┴────────────────────────┘
  เลือก 10 วินาที — grace period 30s ครอบคลุมอยู่แล้ว
```

---

## User API Flows

### 1. Login — Multi-Device

```
Client                              Server
  │                                    │
  ├─ POST /user-api/login ───────────►│
  │  {email, password}                 │
  │                                    ├─ Validate credentials
  │                                    ├─ user_type check ไม่จำเป็นตอน login
  │                                    │  (ยังไม่มี JWT — เป็นการสร้าง JWT)
  │                                    ├─ INSERT user_sessions (ไม่ลบ session เก่า)
  │                                    │
  │◄── 200 ──────────────────────────┤
  │  {                                 │
  │    access_token,                   │
  │    refresh_token,                  │
  │    user: {id, email},              │
  │    session: {                      │
  │      id,                           │
  │      token_family,                 │
  │      expires_at                    │
  │    }                               │
  │  }                                 │
```

### 2. Refresh Token — Rotation + Reuse Detection

```
เหมือน Admin แต่:
- user_type check: ต้องเป็น 'user' ไม่ใช่ 'admin'
- session query: user_sessions ไม่ใช่ admin_sessions
- ไม่มี single session enforcement
- Reuse detected → revoke เฉพาะ token_family นั้น (ไม่ใช่ทุก session ของ user)

Response (theft):
{
  "code": "TOKEN_REUSE_DETECTED",
  "message": "ตรวจพบความผิดปกติ กรุณาเข้าสู่ระบบใหม่",
  "action": "logout"
}
```

### 3. Offline Sync — Version-Based Conflict Resolution

```
App เปิดขึ้นมา
├─ มี network?
│  ├─ YES → refresh token → GET /user-api/sync?since=<last_sync_at>
│  └─ NO  → ใช้ข้อมูลจาก local SQLite

Sync response:
{
  "sync": {
    "server_time": "2026-04-08T12:30:00Z",
    "since": "2026-04-08T10:00:00Z",
    "changes": {
      "articles": {
        "upserted": [
          {"id": 5, "title": "...", "content": "...", "version": 3, "updated_at": "..."},
          {"id": 8, "title": "...", "content": "...", "version": 1, "updated_at": "..."}
        ],
        "deleted": [3, 7]
      }
    },
    "has_more": false
  }
}
```

**Sync push — client ส่ง version กลับมาด้วย:**

```
Request:
{
  "device_id": "dev_abc123",
  "changes": [
    {
      "action": "create",
      "table": "articles",
      "temp_id": "local_1",
      "data": {"title": "Offline Draft", "content": "..."}
    },
    {
      "action": "update",
      "table": "articles",
      "id": 5,
      "version": 2,
      "data": {"title": "Edited Offline"}
    }
  ]
}
```

**Conflict detection flow:**

```
Client ส่ง: UPDATE article id=5, version=2
Server:     SELECT version FROM articles WHERE id=5 → version=3

├─ client version (2) < server version (3)
│  → ⚠️ CONFLICT: มีคนแก้ไปแล้วตอนที่ client offline
│
│  Resolution options:
│  ├─ server_wins  → ส่ง server data กลับให้ client อัพเดท local DB
│  ├─ client_wins  → overwrite server (ต้อง flag ชัดเจน)
│  └─ manual       → ส่งทั้ง 2 version ให้ user เลือก
│
├─ client version (2) == server version (2)
│  → ✅ NO CONFLICT: อัพเดทได้เลย
│  → UPDATE articles SET ..., version=version+1 WHERE id=5 AND version=2
│  → (ถ้า affected rows = 0 → race condition → retry)
```

**Push response:**

```json
{
  "results": [
    {"temp_id": "local_1", "status": "created", "server_id": 15, "version": 1},
    {
      "id": 5,
      "status": "conflict",
      "resolution": "server_wins",
      "client_version": 2,
      "server_version": 3,
      "server_data": {
        "title": "Someone Else Edited",
        "content": "...",
        "version": 3,
        "updated_at": "2026-04-08T12:25:00Z"
      }
    }
  ],
  "sync_cursor": "2026-04-08T12:30:00Z"
}
```

---

## Error Response Format

ทุก error ใช้ format เดียวกัน:

```json
{
  "code": "ERROR_CODE",
  "message": "Human readable message"
}
```

| Code | HTTP | คำอธิบาย |
|---|---|---|
| `SESSION_NOT_FOUND` | 401 | Session ไม่มีใน DB |
| `SESSION_REPLACED` | 401 | ถูก login จากที่อื่น (admin only) |
| `SESSION_REVOKED` | 401 | Session ถูกยกเลิก |
| `TOKEN_REUSE_DETECTED` | 401 | Refresh token ถูกใช้ซ้ำ (possible theft) |
| `REFRESH_EXPIRED` | 401 | Refresh token หมดอายุ |
| `INVALID_TOKEN` | 401 | Token ไม่ถูกต้อง |
| `WRONG_USER_TYPE` | 403 | JWT user_type ไม่ตรงกับ endpoint |
| `SYNC_CONFLICT` | 409 | Version conflict ตอน sync push |

---

## Architecture Components

```
┌─────────────────────────────────────────────────────────┐
│                      Flask App                          │
│                                                         │
│  ┌─────────────┐  ┌──────────────┐  ┌───────────────┐  │
│  │ JWT Decode  │→ │ user_type    │→ │ Session Cache │  │
│  │ (per req)   │  │ guard (403)  │  │ (TTL=10s)     │  │
│  └─────────────┘  └──────────────┘  └───────┬───────┘  │
│                                             │           │
│                                     cache miss ↓        │
│                                     ┌───────────────┐   │
│                                     │  DB (MySQL)   │   │
│                                     │  PK lookup    │   │
│  ┌─────────────┐  ┌──────────────┐  └───────────────┘   │
│  │  Decorator   │  │ SSE Manager  │←── login replace    │
│  │ @admin_req  │  │ (in-memory)  │                      │
│  │ @user_req   │  └──────┬───────┘                      │
│  └─────────────┘         │ EventSource                  │
└──────────────────────────┼──────────────────────────────┘
                           ↓
                    ┌─────────────┐
                    │  Dashboard  │
                    │  (Vue SSE)  │
                    └─────────────┘
```

### Single Process (dev/small scale)

```
Session Cache  → Python dict + TTL
SSE Registry   → Python dict {session_id: Queue}
```

### Multi Process (gunicorn / production)

```
Session Cache  → Redis GET/SET + TTL
SSE Registry   → Redis Pub/Sub channel session:{session_id}
```

---

## Cleanup Strategy

```sql
-- Cron job หรือ Flask CLI command ทุก 1 ชั่วโมง

-- Admin: ลบ session ที่ revoked แล้ว > 7 วัน
DELETE FROM admin_sessions
WHERE status = 'revoked' AND created_at < NOW() - INTERVAL 7 DAY;

-- Admin: ลบ grace_period ที่หมดเวลาแล้ว
UPDATE admin_sessions SET status = 'revoked'
WHERE status = 'grace_period' AND grace_until < NOW();

-- User: ลบ session ที่หมดอายุแล้ว > 7 วัน
DELETE FROM user_sessions
WHERE expires_at < NOW() - INTERVAL 7 DAY;

-- เก่า: token_blacklist table สามารถ DROP ได้หลัง migrate เสร็จ
```
