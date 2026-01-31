# Migration to Single Domain Architecture (lemon.3chan.kr)

## Overview

This document tracks the migration from multi-port direct access (`3chan.kr:3001`, `3chan.kr:3002`, etc.) to a unified single domain architecture using `lemon.3chan.kr` with Nginx Proxy Manager (NPM).

**Migration Date:** 2026-01-31
**Status:** ✅ Code Changes Complete - Ready for Deployment

---

## Architecture Change

### Before (Multi-Port Direct Access)
```
Internet → Individual Services
         3chan.kr:3001 (auth)
         3chan.kr:3002 (content)
         3chan.kr:3003 (progress)
         3chan.kr:3004 (media)
         etc.
```

**Problems:**
- Flutter app bypassed Nginx API Gateway
- CORS issues from port-specific URLs
- No unified SSL/TLS termination
- Inconsistent domain naming

### After (Single Domain with NPM)
```
Internet → NPM (80/443) → Internal Nginx (8080) → Microservices
         lemon.3chan.kr      nginx:8080              auth:3001, content:3002, etc.
```

**Benefits:**
- All requests go through Nginx API Gateway
- Single SSL certificate for lemon.3chan.kr
- Consistent CORS origin
- Proper rate limiting and caching
- Clean, professional architecture

---

## Files Modified (7 total)

### 1. docker-compose.prod.yml
**Changes:**
- Nginx ports: `80:80` → `8080:80`, `443:443` → `8443:443`
- Added web app volume: `./mobile/lemon_korean/build/web:/var/www/lemon_korean_web:ro`

**Reason:** Avoid port conflicts with NPM (which runs on 80/443)

### 2. mobile/lemon_korean/lib/core/constants/api_constants.dart
**Changes:**
- Removed hardcoded service ports (3001-3006)
- Changed `baseUrl` from `http://3chan.kr` to `https://lemon.3chan.kr`
- Updated all endpoint URLs to use Nginx gateway paths

**Before:**
```dart
static const String baseUrl = 'http://3chan.kr';
static const int authServicePort = 3001;
static const String authBaseUrl = '$baseUrl:$authServicePort/api/auth';
```

**After:**
```dart
static const String baseUrl = 'https://lemon.3chan.kr';
static const String authBaseUrl = '$baseUrl/api/auth';
```

### 3. mobile/lemon_korean/.env.production
**Changes:**
- Updated all URLs from `3chan.kr` to `lemon.3chan.kr`
- Removed port-specific URLs

**Before:**
```env
BASE_URL=https://3chan.kr
ADMIN_URL=https://3chan.kr:3006
```

**After:**
```env
BASE_URL=https://lemon.3chan.kr
ADMIN_URL=https://lemon.3chan.kr/api/admin
```

### 4. services/progress/config/cors.go
**Changes:**
- Production allowed origins: `https://3chan.kr` → `https://lemon.3chan.kr`
- Added `https://www.lemon.3chan.kr`
- Updated development origins

### 5. services/media/config/cors.go
**Changes:**
- Same as progress service (consistent CORS configuration)

### 6. .env.example
**Changes:**
- Updated `API_BASE_URL` to `https://lemon.3chan.kr`
- Updated `CORS_ALLOWED_ORIGINS` to include new domain

### 7. nginx/nginx.conf
**Changes:**
- Added explicit `server_name` directives to both HTTP and HTTPS server blocks
- Changed from `server_name _;` to `server_name lemon.3chan.kr www.lemon.3chan.kr;`

**Reason:** Ensures Nginx responds correctly to requests for the new domain

---

## Deployment Steps

### Phase 1: DNS Configuration (BEFORE deployment)

**Action Required:** Add DNS A record

In your DNS provider (Cloudflare, Route53, etc.):
```
Type: A
Name: lemon
Value: <your-server-public-ip>
TTL: 3600 (1 hour)
```

**Verification:**
```bash
# Wait for DNS propagation (1-24 hours, usually <1 hour)
dig lemon.3chan.kr

# Temporary testing (add to /etc/hosts):
echo "<server-ip> lemon.3chan.kr" | sudo tee -a /etc/hosts
```

### Phase 2: Nginx Proxy Manager Configuration (BEFORE deployment)

**Action Required:** Configure NPM Proxy Host

Access NPM at `http://<npm-server-ip>:81`

**Settings:**

**Proxy Hosts → Add Proxy Host:**

**Details Tab:**
- Domain Names: `lemon.3chan.kr`, `www.lemon.3chan.kr`
- Scheme: `http`
- Forward Hostname/IP: `<docker-host-ip>` (IP where docker-compose runs)
- Forward Port: `8080`
- Cache Assets: ✅ Enabled
- Block Common Exploits: ✅ Enabled
- Websockets Support: ✅ Enabled

**SSL Tab:**
- SSL Certificate: Request a new SSL Certificate (Let's Encrypt)
- Force SSL: ✅ Enabled
- HTTP/2 Support: ✅ Enabled
- HSTS Enabled: ✅ Enabled
- Email: `your-email@example.com`

**Advanced Tab (Optional):**
```nginx
# Custom Nginx configuration (if needed)
proxy_set_header X-Forwarded-Host $host;
proxy_set_header X-Forwarded-Server $host;
proxy_set_header X-Real-IP $remote_addr;
```

### Phase 3: Build Flutter Web App (if api_constants.dart changed)

```bash
cd /home/sanchan/lemonkorean/mobile/lemon_korean

# Clean previous build
flutter clean

# Build for web (production mode)
flutter build web --release

# Verify build output
ls -lh build/web/

# Return to project root
cd ../..
```

**Expected output:** `build/web/` directory with ~15-20MB of files

### Phase 4: Deploy Backend Services

```bash
cd /home/sanchan/lemonkorean

# Stop current production containers
docker compose -f docker-compose.prod.yml down

# Start with new configuration
docker compose -f docker-compose.prod.yml up -d

# Wait for all services to be healthy (30-60 seconds)
sleep 60

# Verify all services are running
docker compose -f docker-compose.prod.yml ps

# Check service health
docker compose -f docker-compose.prod.yml logs nginx | tail -20
docker compose -f docker-compose.prod.yml logs auth-service | tail -20
docker compose -f docker-compose.prod.yml logs content-service | tail -20
```

**Expected:** All services show status `Up (healthy)`

### Phase 5: Test Internal Nginx (BEFORE NPM)

```bash
# Test health endpoint
curl -H "Host: lemon.3chan.kr" http://localhost:8080/health

# Expected: {"status":"ok","service":"api-gateway","timestamp":"..."}

# Test API endpoints
curl -H "Host: lemon.3chan.kr" http://localhost:8080/api/auth/health
curl -H "Host: lemon.3chan.kr" http://localhost:8080/api/content/health
curl -H "Host: lemon.3chan.kr" http://localhost:8080/api/progress/health

# Test web app
curl -I -H "Host: lemon.3chan.kr" http://localhost:8080/app/

# Expected: 200 OK with Content-Type: text/html
```

**If any test fails:** Check `docker compose logs <service-name>`

---

## Verification (After NPM is configured)

### Test 1: Basic Connectivity

```bash
BASE=https://lemon.3chan.kr

# Health checks (all should return 200 OK)
curl $BASE/health
curl $BASE/api/auth/health
curl $BASE/api/content/health
curl $BASE/api/progress/health
curl $BASE/media/health
```

### Test 2: API Functionality

```bash
BASE=https://lemon.3chan.kr

# Test content API (should return JSON array)
curl $BASE/api/content/lessons

# Test media service (should return image or 404)
curl -I $BASE/media/images/test.jpg

# Test admin API (should require authentication)
curl $BASE/api/admin/dashboard
```

### Test 3: Web App

**Browser Test:**
1. Open browser: `https://lemon.3chan.kr/app/`
2. Open DevTools (F12) → Console
3. Verify no CORS errors
4. Check Network tab: All API calls should use `https://lemon.3chan.kr/api/*`
5. Test login and navigation
6. Verify localStorage persists after refresh

**Expected:**
- App loads successfully
- No CORS errors in console
- API calls use single domain (no port numbers)
- Settings persist after page reload

### Test 4: CORS Verification

```bash
# Test CORS preflight request
curl -X OPTIONS https://lemon.3chan.kr/api/content/lessons \
  -H "Origin: https://lemon.3chan.kr" \
  -H "Access-Control-Request-Method: GET" \
  -v

# Should return:
# Access-Control-Allow-Origin: https://lemon.3chan.kr
# Access-Control-Allow-Methods: GET, POST, PUT, DELETE, PATCH, OPTIONS
```

### Test 5: SSL Certificate

```bash
# Check certificate details
curl -vI https://lemon.3chan.kr 2>&1 | grep -i "subject:"

# Expected: subject: CN=lemon.3chan.kr

# Verify HSTS header
curl -I https://lemon.3chan.kr | grep -i strict

# Expected: Strict-Transport-Security: max-age=31536000; includeSubDomains

# Test SSL Labs (for production)
# Visit: https://www.ssllabs.com/ssltest/analyze.html?d=lemon.3chan.kr
# Target: A or A+ rating
```

### Test 6: Rate Limiting

```bash
# Test rate limiting (should get 429 after 100 requests)
for i in {1..105}; do
  curl -s -o /dev/null -w "%{http_code}\n" https://lemon.3chan.kr/api/content/lessons
done

# Expected: First 100 return 200, next 5 return 429
```

---

## Rollback Procedure

If critical issues occur after deployment:

### Step 1: Revert Code Changes
```bash
cd /home/sanchan/lemonkorean

# Revert all code changes
git checkout docker-compose.prod.yml
git checkout nginx/nginx.conf
git checkout mobile/lemon_korean/.env.production
git checkout mobile/lemon_korean/lib/core/constants/api_constants.dart
git checkout services/progress/config/cors.go
git checkout services/media/config/cors.go
git checkout .env.example
```

### Step 2: Restart Services
```bash
# Stop services
docker compose -f docker-compose.prod.yml down

# Restart with old configuration
docker compose -f docker-compose.prod.yml up -d
```

### Step 3: NPM Configuration
In Nginx Proxy Manager:
- Delete `lemon.3chan.kr` proxy host
- Keep DNS record (can be used for future retry)

### Step 4: Rebuild Flutter App (if needed)
```bash
cd mobile/lemon_korean
flutter clean
flutter build web --release
cd ../..
docker compose -f docker-compose.prod.yml restart nginx
```

---

## Common Issues & Solutions

### Issue 1: DNS not resolving
**Symptom:** `dig lemon.3chan.kr` returns no A record

**Solution:**
- Wait 1-24 hours for DNS propagation
- Check DNS provider for typos in record
- Temporary fix: Add to `/etc/hosts`

```bash
echo "<server-ip> lemon.3chan.kr" | sudo tee -a /etc/hosts
```

### Issue 2: CORS errors in browser
**Symptom:** Browser console shows "blocked by CORS policy"

**Solution:**
```bash
# 1. Check Nginx CORS headers
curl -I https://lemon.3chan.kr/api/content/lessons

# 2. Verify Go services CORS config
docker compose logs progress-service | grep CORS
docker compose logs media-service | grep CORS

# 3. Check NODE_ENV is set to production
docker compose exec progress-service printenv NODE_ENV
docker compose exec media-service printenv NODE_ENV

# 4. Temporary fix: Add old domain to CORS
# Edit services/progress/config/cors.go and services/media/config/cors.go
# Add "https://3chan.kr" to AllowedOrigins temporarily
```

### Issue 3: SSL certificate invalid
**Symptom:** Browser shows "Your connection is not private"

**Solution:**
- Verify NPM SSL certificate includes `lemon.3chan.kr` in SANs
- Re-request certificate in NPM if needed
- Check certificate details:

```bash
openssl s_client -connect lemon.3chan.kr:443 -servername lemon.3chan.kr
```

### Issue 4: Web app makes requests to old URLs
**Symptom:** Network tab shows `http://3chan.kr:3002`

**Solution:**
```bash
# 1. Verify api_constants.dart was rebuilt
cat mobile/lemon_korean/lib/core/constants/api_constants.dart | grep baseUrl

# 2. Rebuild Flutter web
cd mobile/lemon_korean
flutter clean
flutter build web --release
cd ../..

# 3. Restart Nginx to load new files
docker compose -f docker-compose.prod.yml restart nginx

# 4. Hard refresh browser (Ctrl+Shift+R)
# 5. Clear browser cache if needed
```

### Issue 5: NPM shows "Bad Gateway"
**Symptom:** 502 Bad Gateway error when accessing `https://lemon.3chan.kr`

**Solution:**
```bash
# 1. Check internal Nginx is running on port 8080
docker compose ps nginx

# 2. Test internal Nginx directly
curl -H "Host: lemon.3chan.kr" http://localhost:8080/health

# 3. Verify NPM forward settings
# - Forward Hostname: correct IP (not 127.0.0.1 or localhost)
# - Forward Port: 8080 (not 80)

# 4. Check NPM can reach docker host
# From NPM container:
telnet <docker-host-ip> 8080
```

### Issue 6: Services not healthy
**Symptom:** `docker compose ps` shows services as unhealthy

**Solution:**
```bash
# 1. Check individual service logs
docker compose logs auth-service
docker compose logs content-service
docker compose logs progress-service

# 2. Check database connections
docker compose logs postgres
docker compose logs mongo
docker compose logs redis

# 3. Verify environment variables
docker compose exec auth-service printenv | grep -i db
docker compose exec content-service printenv | grep -i mongo

# 4. Restart unhealthy services
docker compose restart <service-name>
```

---

## Success Criteria

After migration, verify ALL of the following:

- [ ] DNS resolves `lemon.3chan.kr` to correct IP
- [ ] NPM proxy host configured and SSL certificate issued
- [ ] All 6 microservices show `Up (healthy)` status
- [ ] `/health` endpoint returns 200 OK
- [ ] All `/api/auth/`, `/api/content/`, `/api/progress/`, `/media/` endpoints accessible
- [ ] Web app loads at `https://lemon.3chan.kr/app/`
- [ ] No CORS errors in browser console
- [ ] API calls in Network tab use `https://lemon.3chan.kr/api/*` (no port numbers)
- [ ] SSL certificate valid (A or A+ on SSL Labs)
- [ ] HSTS header present in responses
- [ ] Rate limiting works (429 after threshold)
- [ ] Login and core app functionality works
- [ ] Settings persist after browser refresh
- [ ] No direct port access attempts (3001-3006) from client

---

## Post-Migration Tasks

### 1. Update Documentation
- [ ] Update DEPLOYMENT.md with new domain
- [ ] Update README.md examples
- [ ] Update API documentation
- [ ] Update CLAUDE.md with new architecture

### 2. Monitor for 24 Hours
```bash
# Check Nginx access logs
docker compose logs -f nginx | grep -i error

# Monitor service health
watch -n 30 'docker compose ps'

# Check CORS errors
docker compose logs progress-service | grep -i cors
docker compose logs media-service | grep -i cors
```

### 3. Update Mobile App (Future)
- Rebuild mobile app with updated `api_constants.dart`
- Test on physical devices
- Update app store listings (if applicable)

### 4. SSL Certificate Renewal
NPM handles automatic renewal via Let's Encrypt. Verify:
```bash
# Check certificate expiry
openssl s_client -connect lemon.3chan.kr:443 -servername lemon.3chan.kr 2>/dev/null | openssl x509 -noout -dates

# Expected: expires in ~90 days
```

### 5. Performance Baseline
After 1 week, establish baseline metrics:
```bash
# Run optimization script
./scripts/optimization/optimize-nginx.sh --stats

# Expected: Cache hit rate >70%
```

---

## Migration Checklist

**Pre-Deployment:**
- [x] Code changes completed in all 7 files
- [ ] DNS A record created for `lemon.3chan.kr`
- [ ] NPM proxy host configured
- [ ] SSL certificate issued by Let's Encrypt
- [ ] Flutter web app rebuilt

**Deployment:**
- [ ] Production services stopped
- [ ] New docker-compose.prod.yml deployed
- [ ] Services restarted and healthy
- [ ] Internal Nginx tested (port 8080)

**Post-Deployment:**
- [ ] All success criteria verified
- [ ] CORS working correctly
- [ ] SSL certificate valid
- [ ] Web app functional
- [ ] API endpoints accessible
- [ ] No critical errors in logs

**Documentation:**
- [ ] DEPLOYMENT.md updated
- [ ] README.md updated
- [ ] CLAUDE.md updated
- [ ] This migration document marked complete

---

## Contact & Support

**Migration Date:** 2026-01-31
**Implemented By:** Claude Sonnet 4.5
**Status:** ✅ Code Changes Complete

For issues or questions, refer to:
- `/DEPLOYMENT.md` - General deployment guide
- `/CLAUDE.md` - Full project documentation
- Nginx logs: `docker compose logs nginx`
- Service logs: `docker compose logs <service-name>`

---

## Notes

- All code changes are backward-compatible with development environment
- Development mode still uses `http://localhost` or local IPs
- Production-only changes: CORS origins, base URLs, Nginx ports
- No database migrations required
- No data loss risk during migration
- Rollback is quick and safe (git checkout + restart)

**Next Steps:** Follow Phase 2 and Phase 3 of deployment procedure above.
