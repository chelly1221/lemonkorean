# Quick Start: Single Domain Migration

**Target:** `lemon.3chan.kr` (replacing `3chan.kr:3001`, `3chan.kr:3002`, etc.)

---

## 1. Pre-Deployment (DO THIS FIRST)

### DNS Configuration
```bash
# Add DNS A record in your DNS provider:
Type: A
Name: lemon
Value: <your-server-public-ip>
TTL: 3600

# Verify DNS (may take 1-24 hours):
dig lemon.3chan.kr
```

### Nginx Proxy Manager Setup
Access NPM at `http://<npm-ip>:81`

**Add Proxy Host:**
- Domains: `lemon.3chan.kr`, `www.lemon.3chan.kr`
- Scheme: `http`
- Forward: `<docker-host-ip>:8080`
- SSL: Request new cert (Let's Encrypt)
- Enable: Force SSL, HTTP/2, HSTS

---

## 2. Build Flutter Web

```bash
cd /home/sanchan/lemonkorean/mobile/lemon_korean
flutter clean
flutter build web --release
cd ../..
```

---

## 3. Deploy Backend

```bash
cd /home/sanchan/lemonkorean

# Stop current services
docker compose -f docker-compose.prod.yml down

# Start with new config
docker compose -f docker-compose.prod.yml up -d

# Wait for health checks (60 seconds)
sleep 60

# Verify all services healthy
docker compose -f docker-compose.prod.yml ps
```

---

## 4. Test Internal Nginx (Port 8080)

```bash
# Health check
curl -H "Host: lemon.3chan.kr" http://localhost:8080/health

# API endpoints
curl -H "Host: lemon.3chan.kr" http://localhost:8080/api/auth/health
curl -H "Host: lemon.3chan.kr" http://localhost:8080/api/content/health

# Web app
curl -I -H "Host: lemon.3chan.kr" http://localhost:8080/app/
```

**All should return 200 OK**

---

## 5. Test via NPM (After DNS propagates)

```bash
BASE=https://lemon.3chan.kr

# Health checks
curl $BASE/health
curl $BASE/api/auth/health
curl $BASE/api/content/health

# Content API
curl $BASE/api/content/lessons

# Web app
curl -I $BASE/app/
```

**Browser Test:**
1. Open: `https://lemon.3chan.kr/app/`
2. Check DevTools Console (F12) - no CORS errors
3. Test login and navigation
4. Verify API calls use `https://lemon.3chan.kr/api/*`

---

## 6. Success Criteria

✅ DNS resolves `lemon.3chan.kr`
✅ NPM SSL certificate valid
✅ All services healthy
✅ Web app loads
✅ No CORS errors
✅ API calls work

---

## Rollback (If Needed)

```bash
cd /home/sanchan/lemonkorean

# Revert code
git checkout docker-compose.prod.yml nginx/nginx.conf mobile/lemon_korean/.env.production mobile/lemon_korean/lib/core/constants/api_constants.dart services/progress/config/cors.go services/media/config/cors.go .env.example

# Restart
docker compose -f docker-compose.prod.yml down
docker compose -f docker-compose.prod.yml up -d

# Delete NPM proxy host for lemon.3chan.kr
```

---

## Files Modified (7)

1. `docker-compose.prod.yml` - Ports 8080/8443, web volume
2. `mobile/lemon_korean/lib/core/constants/api_constants.dart` - Remove ports
3. `mobile/lemon_korean/.env.production` - New domain
4. `.env.example` - CORS origins
5. `services/progress/config/cors.go` - New domain
6. `services/media/config/cors.go` - New domain
7. `nginx/nginx.conf` - server_name directive

---

## Common Issues

**502 Bad Gateway:** Check NPM forward IP is correct (not 127.0.0.1)
**CORS errors:** Verify NODE_ENV=production in Go services
**Old URLs:** Rebuild Flutter web + hard refresh browser
**DNS not resolving:** Wait or add to `/etc/hosts`

---

**Full Documentation:** See `MIGRATION_TO_SINGLE_DOMAIN.md`
