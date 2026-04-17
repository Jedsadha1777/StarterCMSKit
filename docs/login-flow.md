# Login Flow — Admin Dashboard

## 1. เข้าหน้า /login

### Router guard (`router.js:47-65`)

```
beforeEach:
  hasToken = localStorage.getItem('access_token')
  /login มี meta.guest = true
  → ถ้า hasToken มีค่า → redirect /  (เข้า /login ไม่ได้ ต้อง logout ก่อน)
  → ถ้า hasToken เป็น null → next()  (เข้า /login ได้)
```

### App.vue template (`App.vue:3,71-73`)

```
<template v-if="isAuthenticated">   ← isAuthenticated เป็น ref, ตอนนี้ false
  app-bar + sidebar                  ← ไม่แสดง
</template>
<v-main>
  <router-view />                    ← แสดง Login.vue
</v-main>
```

---

## 2. User กรอก email + password แล้วกด Login

### Login.vue (`Login.vue:56-72`)

```
handleLogin():
  loading = true

  1. POST /login
     api.login(email, password)                               ← api.js:139
     → api.post('/login', { email, password })
     → request interceptor (api.js:34-39):
         token = localStorage.getItem('access_token')          ← null (ยังไม่ login)
         → ไม่ใส่ Authorization header

  2. Backend รับ request
     → ดู section 3

  3. ได้ response { access_token, refresh_token, admin, session, companies }

  4. localStorage.setItem('access_token', data.access_token)   ← line 61
  5. localStorage.setItem('refresh_token', data.refresh_token)  ← line 62

  6. saveAdmin(data.admin)                                      ← line 63
     → useAdmin.js:38 save(data):
         loop Object.keys(data):
           ถ้า data[key] !== undefined && !== null → admin[key] = data[key]
           (set name, email, role, company_name, is_super_admin, permissions, limits ฯลฯ)
         localStorage.setItem('admin', JSON.stringify({...}))
         window.dispatchEvent(new Event('storage-updated'))
         → useAdmin.js:95 listener: loadFromStorage() รัน
           อ่าน localStorage → set ค่าเดิมกลับ (ซ้ำแต่ไม่เสีย)

  7. saveCompanies(data.companies || [])                        ← line 64
     → useAdmin.js:57 saveCompanies(list):
         companies.value = list
         localStorage.setItem('companies', JSON.stringify(list))
         ถ้ามี companies แต่ไม่มี activeCompanyId → setActiveCompany(list[0].id)
           → localStorage.setItem('active_company_id', id)
           → window.dispatchEvent(new Event('company-changed'))

  8. window.dispatchEvent(new Event('auth-login'))              ← line 65
     → App.vue:108 listener: syncAuth() รัน
       isAuthenticated.value = !!(localStorage.getItem('access_token') && localStorage.getItem('refresh_token'))
       → tokens มีแล้ว (step 4-5) → isAuthenticated = true

     → App.vue:224 watch(isAuthenticated) fire (async, ระหว่าง await ข้างล่าง):
       v = true → connectSSE() + loadSettings() + syncAdminInfo()

  9. await loadSettings()                                       ← line 66
     → useSiteSettings.js:15 loadSettings():
         api.getSettings() → request interceptor ใส่ Authorization (token มีแล้ว)
         → backend ตรวจ session → ผ่าน → return settings
         Object.assign(settings, data)
         → applyTitle() → document.title = settings.site_title
         → applyFavicon() → set <link rel="icon">
         → applyPrimaryColor() → set vuetify theme

     ระหว่าง await นี้ Vue microtask ประมวลผล:
       → watch(isAuthenticated) callback fire:
         - connectSSE(): ดู section 5
         - loadSettings(): เรียกซ้ำ (ไม่เสีย)
         - syncAdminInfo(): api.getProfile() → save(data) → อัพเดท admin reactive

 10. router.push('/')                                           ← line 67
     → router guard:
         hasToken = localStorage.getItem('access_token') → มีค่า
         / มี meta.requiresAuth = true → hasToken มี → next()
     → afterEach: document.title = "Dashboard | {site_title}"

 11. App.vue template re-render:
     isAuthenticated = true → app-bar + sidebar แสดง
     adminName = admin.name (จาก step 6)
     navItems ถูก filter ด้วย can():
       can() อ่าน admin.is_super_admin + admin.permissions (จาก step 6)
       → super admin: ทุกเมนูแสดง
       → tenant admin: เฉพาะเมนูที่มี permission
```

---

## 3. Backend รับ POST /login

### routes_auth.py:98-185

```
login():
  1. validate email + password (line 102-107)
     → ผิด: return 401 { code: 'INVALID_CREDENTIALS' }
       → frontend interceptor: NO_REFRESH_CODES → reject
       → Login.vue catch: แสดง error message
     → ถูก: ดำเนินการต่อ

  2. หา old active sessions (line 112-115)
     AdminSession.query.filter_by(admin_id, status='active').with_for_update()
     → row lock ป้องกัน concurrent login

  3. mark old sessions → grace_period (line 119-127)
     for old in old_sessions:
       old.status = 'grace_period'
       old.grace_until = now + GRACE_SECONDS (30s)
       session_cache.invalidate(old.id)
     db.session.flush()
     → active_admin_id generated column = NULL → UNIQUE slot ว่าง

  4. สร้าง session ใหม่ (line 132-134)
     raw_refresh = AdminSession.generate_refresh_token()  → 'rt_' + 64 chars
     new_session = _create_session():
       id = uuid4
       refresh_token_hash = sha256(raw_refresh)
       token_family = uuid4 (ใหม่ ไม่ใช่ family เดิม)
       status = 'active'
     db.session.flush()

  5. อัพเดท old sessions (line 137-138)
     old.replaced_by_session_id = new_session.id

  6. cleanup expired grace sessions (line 141-149)

  7. db.session.commit()

  8. SSE แจ้ง old session (line 153-163)
     sse_manager.send(old_session_id, 'session_replaced', {...})
     → เครื่องเก่าที่ต่อ SSE อยู่จะได้รับ event

  9. สร้าง access_token (line 165)
     JWT claims: { user_type: 'admin', session_id: new_session.id }
     identity: admin.public_id

 10. return response (line 172-185)
     {
       access_token,
       refresh_token: raw_refresh (ยังไม่ hash),
       admin: AdminResponseSchema + permissions + limits,
       session: { id, ip_address, created_at, last_active_at },
       companies: [{ id, name }],
       replaced_session: { ip, last_active_at } (ถ้ามี)
     }
```

---

## 4. เครื่องเก่าถูกเตะ (ถ้ามี session เดิม)

```
เครื่องเก่า SSE tab:
  1. EventSource รับ 'session_replaced' event
  2. App.vue:186-195:
     disconnectSSE()
     clearAuthStorage():
       → ลบ 5 keys จาก localStorage
       → fire 'auth-cleared'
       → syncAuth() → isAuthenticated = false → sidebar หาย
       → useAdmin reset() → admin state ว่าง
     แสดง SessionReplacedModal (countdown 30s)

เครื่องเก่า tab อื่น (ไม่มี SSE):
  1. storage event จาก tab ที่ clearAuthStorage
  2. App.vue:109-113:
     syncAuth() → isAuthenticated = false
     router.push('/login')
  3. useAdmin.js:97-99:
     event.key === 'admin' && !event.newValue → reset()

เครื่องเก่า tab ที่ไม่มี SSE + ไม่มี storage event (request ถัดไป):
  1. API call → request interceptor ใส่ token เก่า
  2. backend: admin_required decorator (decorators.py:82-113)
     → _validate_admin_session():
       session status = grace_period
       → ถ้า grace ยังไม่หมด: request ผ่าน (ใช้งานได้อีก 30s)
       → ถ้า grace หมดแล้ว: status → revoked, return SESSION_REPLACED
  3. frontend ได้ 401 SESSION_REPLACED
     → interceptor: SESSION_DEAD_CODES → clearAuthStorage → redirect /login
```

---

## 5. SSE Connection (หลัง login สำเร็จ)

### App.vue:175-203

```
connectSSE():
  1. disconnectSSE() — ปิด connection เก่า (ถ้ามี)
  2. token = localStorage.getItem('access_token')
     → ถ้าไม่มี token → return (ไม่ต่อ)
  3. POST /session/ticket (ใช้ axios ตรง ไม่ผ่าน api instance)
     → backend (routes_auth.py:358-377):
       admin_required ตรวจ session
       สร้าง ticket = secrets.token_urlsafe(32)
       เก็บใน _sse_tickets (in-memory, TTL 30s)
       return { ticket }
  4. new EventSource(/session/stream?ticket=...)
     → backend (routes_auth.py:380-413):
       pop ticket จาก _sse_tickets (ใช้ได้ครั้งเดียว)
       ตรวจ expiry
       sse_manager.connect(session_id) → สร้าง queue
       yield events จาก queue / heartbeat ทุก 25s

  5. listen 'session_replaced' → clearAuthStorage + แสดง modal
  6. listen 'security_alert' → clearAuthStorage + redirect /login
  7. onerror → disconnectSSE + scheduleReconnect
     → retry สูงสุด SSE_MAX_RETRIES (10) ครั้ง ห่าง SSE_RECONNECT_DELAY (3s)
     → ตรวจ isAuthenticated.value ก่อน reconnect
```

---

## 6. ทุก API request หลัง login

```
request interceptor (api.js:34-39):
  อ่าน localStorage.getItem('access_token') ทุกครั้ง (ไม่ cache)
  → ใส่ Authorization: Bearer {token}
  อ่าน localStorage.getItem('active_company_id')
  → ใส่ X-Company-Id header

backend:
  @jwt_required() → ตรวจ JWT signature + expiry
  @admin_required (decorators.py:82-113):
    ตรวจ user_type == 'admin'
    ตรวจ session_id จาก JWT claims
    _validate_admin_session():
      cache hit → return cached data (TTL 60s)
      cache miss → query DB:
        session not found → SESSION_NOT_FOUND
        session revoked → SESSION_REVOKED
        session grace_period:
          grace ยังไม่หมด → ผ่าน (ไม่ cache)
          grace หมด → revoke + SESSION_REPLACED
        session active → update last_active_at + cache + ผ่าน
    set g.active_company จาก X-Company-Id header

response 401 interceptor (api.js:55-132):
  มี code ใน SESSION_DEAD_CODES → clearAuthStorage + redirect /login
  มี code ใน NO_REFRESH_CODES → reject (ไม่ refresh ไม่ clear)
  ไม่มี code (JWT expired):
    token ที่ส่ง ≠ localStorage → retry ด้วย token ใหม่
    token ที่ส่ง = localStorage → refresh:
      POST /refresh { refresh_token } + Bearer expired_access_token
      สำเร็จ → save ทั้ง access_token + refresh_token → retry request เดิม
      fail → clearAuthStorage + redirect /login
```

---

## 7. Logout

```
User กด Log out → App.vue:166 doLogout() → api.logout()
  → api.js:140: api.post('/logout').finally(() => { clearAuthStorage(); router.push('/login') })

backend (routes_auth.py:286-300):
  @jwt_required + @admin_required ตรวจ session
  session.status = 'revoked'
  session_cache.invalidate(session_id)
  return 200

frontend .finally():
  clearAuthStorage():
    ลบ 5 keys จาก localStorage
    fire 'auth-cleared':
      → syncAuth → isAuthenticated = false
      → useAdmin reset() → admin state ว่าง
      → watch(isAuthenticated) → disconnectSSE()
  router.push('/login')

tab อื่น:
  storage event → syncAuth → isAuthenticated = false → redirect /login
  storage event key=admin → useAdmin reset()
```

---

## 8. Password Change → Force Logout ทุก Session

```
Profile.vue:155 → api.changePassword(old, new)

backend (routes_auth.py:469-494):
  ตรวจ old password → ผิด: 401 { code: 'INVALID_CREDENTIALS' }
  set new password
  revoke ALL active/grace_period sessions:
    for s in all_sessions:
      s.status = 'revoked'
      session_cache.invalidate(s.id)
      sse_manager.send(s.id, 'security_alert', { code: 'PASSWORD_CHANGED' })
  return 200

SSE tab (ทุกเครื่อง รวมเครื่องที่เปลี่ยน password):
  security_alert → clearAuthStorage → redirect /login
  → tab อื่น: storage event → redirect /login

เครื่องที่เปลี่ยน password:
  200 response กลับมา → แสดง "Password changed"
  SSE security_alert อาจมาก่อนหรือหลัง 200 → clearAuthStorage → redirect /login
  → request ถัดไป (ถ้ามี): 401 SESSION_REVOKED → clearAuthStorage → redirect /login
```

---

## สรุป event chain

```
Login:   setItem tokens → saveAdmin → saveCompanies → fire 'auth-login' → syncAuth → isAuthenticated=true → connectSSE + loadSettings + syncAdminInfo

Logout:  POST /logout → clearAuthStorage → removeItem x5 → fire 'auth-cleared' → syncAuth → isAuthenticated=false → disconnectSSE + reset()

ถูกเตะ:  SSE session_replaced → clearAuthStorage → isAuthenticated=false → แสดง modal → redirect /login

Security: SSE security_alert → clearAuthStorage → isAuthenticated=false → redirect /login

Cross-tab: storage event (token ถูกลบ) → syncAuth → isAuthenticated=false → redirect /login
```
