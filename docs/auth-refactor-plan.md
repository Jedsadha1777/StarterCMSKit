# Auth Refactor Plan — Dashboard (v4)

## หลักการ

- Backend DB (`admin_sessions`) คือ source of truth
- Token อยู่ใน localStorage
- Token rotation: refresh สำเร็จ → ต้อง save ทั้ง access_token + refresh_token ใหม่ทุกครั้ง
- ใช้ refresh_token เก่าซ้ำ → TOKEN_REUSE_DETECTED → revoke ทั้ง family

---

## Frontend

### เก็บ token

- `localStorage.access_token`
- `localStorage.refresh_token`

### Login

```
POST /login → save access_token + refresh_token → redirect /
```

### Request interceptor

อ่าน token จาก `localStorage` ทุก request (ไม่ cache ใน memory)

### Response 401 handling

| code | ความหมาย | action |
|------|----------|--------|
| `SESSION_REPLACED` | session ถูกแทนที่ | clear + redirect login |
| `SESSION_REVOKED` | session ถูก revoke ถาวร | clear + redirect login |
| `TOKEN_REUSE_DETECTED` | refresh token ถูกใช้ซ้ำ | clear + redirect login |
| `SESSION_NOT_FOUND` | session ไม่มีใน DB | clear + redirect login |
| `INVALID_TOKEN` | JWT invalid / admin not found | clear + redirect login |
| `INVALID_CREDENTIALS` | รหัสผิด (เช่น change-password) | reject ให้ caller แสดง error — ไม่ clear ไม่ refresh |
| ไม่มี code (JWT expired) | access token หมดอายุปกติ | เทียบ token → retry หรือ refresh |

แบ่ง 3 กลุ่ม:
- **Session dead** (5 codes ด้านบน) → clear + redirect login ทันที
- **Business error** (INVALID_CREDENTIALS) → reject ให้ caller จัดการ ไม่แตะ token
- **JWT expired** (ไม่มี code) → เทียบ token + retry หรือ refresh

### Refresh flow

```
1. ได้ 401 ไม่มี code + token เหมือน localStorage → refresh
2. Request อื่นใน tab เดียวกัน → isRefreshing = true → เข้า queue รอ
3. POST /refresh { refresh_token } + Authorization: Bearer <expired_access_token>
4. สำเร็จ → save access_token + refresh_token ใหม่ทั้งคู่ลง localStorage
5. process queue → retry
6. fail → clear + redirect login
```

### Multi-tab + token rotation

```
Tab B ได้ 401 ไม่มี code:
  token ที่ส่ง ≠ localStorage → retry (ไม่ refresh)
  token ที่ส่ง = localStorage → refresh
```

Known trade-off: ถ้า Tab A + Tab B refresh พร้อมกัน (ทั้งคู่เช็ค localStorage ได้ token เดียวกันก่อน refresh) → Tab ที่เขียน localStorage ทีหลังชนะ → Tab ที่เขียนก่อนอาจมี refresh_token ไม่ตรง DB → refresh ถัดไป fail → redirect login — ไม่ใช่ security issue แค่ UX ที่หายาก

### storage event listener

```javascript
window.addEventListener('storage', (event) => {
  if ((event.key === 'access_token' || event.key === 'refresh_token') && !event.newValue) {
    router.push('/login')
  }
})
```

detect token ถูกลบ → redirect login

### SSE

- `session_replaced` → clearAuthStorage → แสดง modal → redirect /login
- `security_alert` → clearAuthStorage → redirect /login

### Polling

ลบออก

### Router guard

```
if (!localStorage.getItem('access_token')) → redirect /login
```

### Logout

```
POST /logout → clearAuthStorage → redirect /login
```

---

## สิ่งที่ลบ

- auth-changed event → แทนด้วย auth-cleared + auth-login
- syncAuthState() → แทนด้วย syncAuth (listen auth-cleared, auth-login, storage)
- Polling

## สิ่งที่เก็บ

- SSE
- storage event listener (detect token ถูกลบ)
- isRefreshing + failedQueue
- clearAuthStorage

---

## Backend

### แก้แล้ว

- `/refresh` — reject grace_period session (`session.status == 'grace_period'` → 401 SESSION_REPLACED ก่อน `is_valid()`) ป้องกัน UNIQUE constraint violation โดยไม่เตะ device ที่ login ล่าสุด
- `/refresh` — rate limit `RATE_LIMIT_REFRESH` (10 per minute)

---

## Flow ทุก scenario

### เปิดหลาย tab เครื่องเดียวกัน
```
ทุก tab อ่าน token จาก localStorage ทุก request → share session → ทำงานได้
```

### Tab A refresh → Tab B ส่ง token เก่า
```
Tab B ได้ 401 → token ≠ localStorage → retry ด้วย token ใหม่ → สำเร็จ
```

### เครื่อง 2 login → เครื่อง 1 ถูกเตะ
```
เครื่อง 1 SSE tab: session_replaced → clearAuthStorage → modal → redirect login
เครื่อง 1 tab อื่น: storage event (token ถูกลบ) → redirect login
```

### Login ซ้ำ
```
มี token → router guard redirect / → ต้อง logout ก่อน
```

### Logout
```
clearAuthStorage → redirect login → storage event → tab อื่น redirect login
```

### Security alert
```
SSE tab: clearAuthStorage → redirect login → storage event → tab อื่น redirect login
```
