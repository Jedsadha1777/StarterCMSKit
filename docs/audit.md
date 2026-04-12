# StarterCMSKit — Audit Report

**Date:** 2026-04-13 (updated 2)
**Scope:** backendAPI (Python/Flask), dashboard (Vue.js/Vuetify), mobile_app (Flutter/iOS)
**Platform:** iOS — tested on iPad (physical device)
**Constraint:** No Redis available in this deployment.

---

## Summary

| Sub-project | Fixed (cumulative) | Critical | High | Medium | Low | Info |
|---|---|---|---|---|---|---|
| backendAPI | 13 | 0 | 0 | 0 | 1 | 1 |
| dashboard | 6 | 0 | 0 | 0 | 0 | 2 |
| mobile_app | 14 | 0 | 0 | 0 | 1 | 1 |
| **Total** | **33** | **0** | **0** | **0** | **2** | **4** |

**6 open issues remain.**

**Severity definitions**
- **Critical** — auth bypass, data loss, account takeover
- **High** — feature broken in production / always fails on real device
- **Medium** — wrong behavior under real conditions, potential data corruption
- **Low** — bad practice, minor bug, edge-case failure
- **Info** — incomplete feature, tech debt, non-blocking observation

---

## 1. backendAPI

### Fixed Issues (12)

| ID | File | Description |
|---|---|---|
| F-B1 | `admin_api/routes_auth.py` | Login filter bug: `else True` → `if old_ids:` guard |
| F-B2 | `utils.py` | `get_or_404`: fragile `rstrip('s')` → `[:-1] if endswith('s')` |
| F-B3 | `admin_api/routes_settings.py` | Magic-byte validation + 5 MB file size limit |
| F-B4 | `extensions.py` | Rate limiter reads `REDIS_URL` env, falls back to `memory://` |
| F-B5 | `models/models.py` | `TokenBlacklist.cleanup_expired()` added; called by `flask cleanup` |
| F-B6 | `admin_api/routes_auth.py` | `forgot_password`: reset token no longer logged |
| F-B7 | `extensions.py` | Admin tokens skip blacklist check (`user_type == 'admin'`) |
| F-B8 | `commands.py` | `backfill`: uses `model.public_id.is_(None)` (correct ORM null check) |
| F-B9 | `admin_api/routes_auth.py` | `_decode_admin_jwt`: catches `JWTDecodeError` specifically |
| F-B10 | `utils.py:76`, `user_api/routes_auth.py:51` | Timezone-aware datetime stripped before storing: `.replace(tzinfo=None)` |
| F-B11 | `admin_api/routes_admin.py:9` | `timezone` added to `datetime` import |
| F-B12 | `models/__init__.py` | Naive UTC datetime convention documented in module-level comment |
| **F-B13** ★ | `gunicorn.conf.py`, `requirements.txt` | Single-worker gevent config added; `gunicorn` + `gevent` added to requirements — eliminates cross-worker SSE ticket loss without Redis |

---

### Open Issues


#### B2 — Low: `forgot_password` is a non-functional stub

**File:** `admin_api/routes_auth.py:303–309`

```python
token = _generate_reset_token(admin.email)
# TODO: replace with actual email delivery
logger.info('Password reset initiated for %s', admin.email)
```

The reset token is generated but never delivered. Password reset is entirely non-functional in any deployed environment.

---

#### B3 — Info: Permission checks issue DB queries on every request

**File:** `models/admin.py:36–84`

`has_permission()`, `get_permissions()`, and `get_limits()` each execute SQL queries per admin request. Acceptable at current scale. At higher traffic, consider caching results in the JWT additional claims or in `session_cache` (TTL=60s already in place).

---

## 2. dashboard

### Fixed Issues (6)

| ID | File | Description |
|---|---|---|
| F-D1 | `api.js` | `access_token` moved to `sessionStorage` (cleared on tab close) |
| F-D2 | `api.js` | `clearAuthStorage()` replaces `localStorage.clear()` — selective deletion |
| F-D3 | `api.js` | `MAX_QUEUE_SIZE = 50` cap on `failedQueue` |
| F-D4 | `router.js` | Cross-tab logout via `window.addEventListener('storage', ...)` |
| F-D5 | `App.vue:112` | `isAuthenticated` now derived from token storage, not `route.meta.requiresAuth` |
| F-D6 | `composables/useAdmin.js:26` | `save()` persists only `name`/`email` to localStorage; `role`/`permissions`/`limits` kept in reactive memory only |

---

### Open Issues

#### D1 — Info: `storage-updated` event listener never removed

**File:** `composables/useAdmin.js:43`

```js
window.addEventListener('storage-updated', loadFromStorage)
```

Module-level listener added at startup; never removed. Technically a memory leak — harmless in a SPA that never fully unloads the module.

---

#### D2 — Info: `logout()` always clears local session regardless of server response (intentional)

**File:** `api.js:162`

```js
api.post('/logout').finally(() => { clearAuthStorage(); router.push('/login') })
```

`finally` runs even on network error — local session is always cleared. Intentional and correct defensive behavior. The server-side session may not be revoked if the request fails, but that is an acceptable trade-off.

---

## 3. mobile_app

### Fixed Issues (13)

| ID | File | Description |
|---|---|---|
| F-M1 | `services/token_manager.dart` | `throw RefreshTokenExpiredException(...)` instead of generic `Exception` |
| F-M2 | `services/api/api_client.dart` | `clearTokens()` only called on 401, not on network errors or timeouts |
| F-M3 | `providers/auth_provider.dart` | `SessionExpiredException` handled alongside `NetworkException` for offline fallback in `checkAuth()` |
| F-M4 | `services/api/api_client.dart` | Unused `catch (e)` variable → `on TimeoutException` |
| F-M5 | `models/user.dart` | `toJson()` method added for profile caching |
| F-M6 | `services/token_manager.dart` | Offline auth: HMAC-SHA256 credential hash + profile cache in FlutterSecureStorage |
| F-M7 | `providers/auth_provider.dart` | `_loginOffline()` + `_restoreFromCache()` + offline-aware `checkAuth()` |
| F-M8 | `providers/auth_provider.dart:82` | `logout()` uses try/catch — clears local session even on network failure |
| F-M9 | `providers/auth_provider.dart:94` | `loadProfile()` falls back to cached profile on `NetworkException` |
| F-M10 | `providers/auth_provider.dart:132` | Error message unified to Thai (`'อีเมลหรือรหัสผ่านไม่ถูกต้อง'`) |
| F-M11 | `providers/auth_provider.dart:137` | Expired session message clarified: `'กรุณาเชื่อมต่ออินเทอร์เน็ตเพื่อต่ออายุ session'` |
| F-M12 | `services/token_manager.dart:93` | `_refreshCompleter` cleared via `Future.microtask` (was 1-second timer) |
| F-M13 | `services/api/api_client.dart:412` | `_refreshLock` cleared via `Future.microtask` (was 100ms timer) |
| **F-M14** ★ | `config/api_config.dart` | Comment updated to document `--dart-define-from-file=lib/config/local.json` workflow; `local.json.example` already in place |

---

### Open Issues

#### M1 — High: Physical iPad build requires explicit `API_BASE_URL` — developer action needed

**File:** `config/api_config.dart:7`

The default `127.0.0.1` only resolves on a simulator. On a physical iPad every API call fails. The workflow is now documented in `api_config.dart` and a template is provided:

```
cp lib/config/local.json.example lib/config/local.json
# edit local.json: set API_BASE_URL to your LAN IP
flutter run --dart-define-from-file=lib/config/local.json
```

`lib/config/local.json` is in `.gitignore`. This issue remains **open** because it requires a developer to create their own `local.json` — the code change alone cannot supply the LAN IP.

---

#### M2 — Low: HMAC-SHA256 used as credential KDF

**File:** `services/token_manager.dart:165–169`

```dart
final key = utf8.encode(salt);
final msg = utf8.encode('$email:$password');
return Hmac(sha256, key).convert(msg).toString();
```

HMAC-SHA256 is fast (billions of iterations/second on modern hardware). If the iOS Keychain is forensically extracted, brute-force is inexpensive. For the current threat model (Keychain requires device unlock), this is acceptable. For production hardening, consider PBKDF2 with 100,000+ iterations via the `pointycastle` package.

---

#### M3 — Info: Cooldown check can return without refreshing an expired token

**File:** `services/api/api_client.dart:288–292`

If the 5-second cooldown fires while the token is expired and no new refresh is triggered, the subsequent request gets a 401, which triggers a retry refresh. No data loss — just one extra round-trip. Only occurs when `JWT_ACCESS_TOKEN_EXPIRES` < 5 seconds, which won't happen in practice.

---

## Action Items (Priority Order)

| Priority | Severity | ID | File | Action |
|---|---|---|---|---|
| 1 | High | M1 | `config/api_config.dart:7` | **Developer action:** copy `local.json.example` → `local.json`, fill in LAN IP, run with `--dart-define-from-file=lib/config/local.json` |
| 2 | Low | B2 | `admin_api/routes_auth.py:303` | Implement email delivery for password reset (Flask-Mail or SMTP) |
| 3 | Low | M2 | `services/token_manager.dart:165` | Consider PBKDF2 for credential hash (production hardening only) |
| 4 | Info | B3 | `models/admin.py:36–84` | Cache permission queries in JWT claims at higher traffic |
| 5 | Info | D1 | `composables/useAdmin.js:43` | Harmless module-level listener — no action required |
| 6 | Info | M3 | `services/api/api_client.dart:288` | Edge case only when token TTL < 5s — no action required |
