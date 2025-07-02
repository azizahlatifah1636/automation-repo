# 🧪 Local Testing Guide

Panduan lengkap untuk menjalankan testing di local environment.

## 🚀 Quick Start

### 1. Setup Awal (One-time)
```powershell
# Clone dan setup project
git clone <repository-url>
cd pipeline-automation

# Jalankan setup script
.\setup-local.ps1
```

### 2. Testing Cepat
```powershell
# Test semua
.\test-quick.ps1

# Test specific type
.\test-quick.ps1 -Type api
.\test-quick.ps1 -Type web
.\test-quick.ps1 -Type e2e
.\test-quick.ps1 -Type performance

# Test dengan options
.\test-quick.ps1 -Type api -Coverage
.\test-quick.ps1 -Type web -Watch
.\test-quick.ps1 -Type e2e -Verbose
```

## 📋 Testing Commands

### API Testing
```bash
cd api

# Unit tests
npm run test:unit

# Integration tests
npm run test:integration

# All tests dengan coverage
npm run test:coverage

# Watch mode untuk development
npm run test -- --watch

# Test specific file
npm run test -- tests/unit/api.test.js

# Verbose output
npm run test -- --verbose
```

### Web UI Testing
```bash
cd web-ui

# Unit tests (React Testing Library)
npm run test:unit

# E2E tests (Playwright)
npm run test:e2e

# Test dengan specific browser
npm run test:e2e:chrome
npm run test:e2e:firefox

# Playwright dengan UI mode (untuk debugging)
npx playwright test --ui

# Playwright dengan browser visible
npx playwright test --headed

# Generate test code
npx playwright codegen localhost:8080
```

### Performance Testing
```bash
cd performance-tests

# Basic load test
k6 run api-load-test.js

# Custom configuration
k6 run --vus 20 --duration 10m api-load-test.js

# With output to file
k6 run --out json=results.json api-load-test.js
```

## 🔧 Development Workflow

### Start Services
```bash
# Start API only
npm run start:api

# Start Web UI only
npm run start:web

# Start both services
npm run start:all

# Using Docker
docker-compose up -d
```

### Testing dalam Development
```bash
# Watch mode untuk API tests
cd api && npm run test -- --watch

# Watch mode untuk Web UI tests
cd web-ui && npm run test -- --watch

# Playwright UI mode untuk E2E debugging
cd web-ui && npx playwright test --ui
```

## 🐛 Debugging Tests

### API Tests Debugging
```bash
# Dengan debug output
cd api
DEBUG=* npm test

# Dengan Jest debug
node --inspect-brk node_modules/.bin/jest --runInBand

# Test specific dengan verbose
npm test -- --testNamePattern="should create user" --verbose
```

### Web UI Tests Debugging
```bash
# React tests dengan debugging
cd web-ui
npm test -- --no-watch --verbose

# Playwright debugging
npx playwright test --debug

# Playwright dengan pause untuk manual debugging
npx playwright test --pause
```

### Common Issues

1. **Port sudah digunakan:**
   ```powershell
   # Check ports
   netstat -ano | findstr :3000
   netstat -ano | findstr :8080
   
   # Kill process (ganti PID dengan actual PID)
   taskkill /PID <PID> /F
   ```

2. **Node modules issues:**
   ```bash
   # Clean install
   npm run clean:install
   
   # Or manual
   rm -rf node_modules package-lock.json
   npm install
   ```

3. **Playwright browser issues:**
   ```bash
   cd web-ui
   npx playwright install --force
   ```

4. **Permission issues (Windows):**
   ```powershell
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
   ```

## 📊 Test Reports

### Lokasi Reports
- **API Coverage**: `./api/coverage/lcov-report/index.html`
- **Web UI Coverage**: `./web-ui/coverage/lcov-report/index.html`
- **Playwright Report**: `./web-ui/playwright-report/index.html`
- **Performance Results**: `./performance-tests/results.json`

### Membuka Reports
```bash
# API coverage report
start ./api/coverage/lcov-report/index.html

# Web UI coverage report
start ./web-ui/coverage/lcov-report/index.html

# Playwright report
start ./web-ui/playwright-report/index.html
```

## 🔄 VS Code Integration

### Tasks (Ctrl+Shift+P → Tasks: Run Task)
- Install Dependencies
- Run API Tests
- Run Web UI Tests
- Start API Server
- Start Web UI
- Run Performance Tests
- Lint All Projects

### Extensions yang Direkomendasikan
- Jest (untuk API tests)
- Playwright Test for VSCode (untuk E2E tests)
- ESLint
- Prettier

## 🌐 Browser Testing

### Supported Browsers
- **Chromium** (default)
- **Firefox**
- **WebKit** (Safari)
- **Mobile Chrome**
- **Mobile Safari**

### Browser-specific Testing
```bash
cd web-ui

# Test hanya di Chrome
npx playwright test --project=chromium

# Test di semua desktop browsers
npx playwright test --project=chromium --project=firefox --project=webkit

# Test mobile only
npx playwright test --project="Mobile Chrome" --project="Mobile Safari"
```

## 📈 Performance Monitoring

### k6 Metrics
- **http_req_duration**: Response time
- **http_req_failed**: Error rate
- **iterations**: Total requests
- **vus**: Virtual users

### Custom Monitoring
```javascript
// Tambahkan di k6 script
import { Trend } from 'k6/metrics';
let customTrend = new Trend('custom_metric');

export default function() {
    let start = Date.now();
    // Your test code
    customTrend.add(Date.now() - start);
}
```

## 🔍 Troubleshooting Checklist

- [ ] Node.js version 18.x atau 20.x installed
- [ ] npm dependencies installed untuk semua projects
- [ ] Environment variables configured (.env file)
- [ ] Ports 3000 dan 8080 available
- [ ] Playwright browsers installed
- [ ] k6 installed (untuk performance tests)
- [ ] Services running (untuk integration tests)

## 📞 Support

Jika mengalami issues:
1. Check console/terminal output untuk error messages
2. Verify semua dependencies ter-install dengan benar
3. Check port availability
4. Run tests step by step untuk isolate issues
5. Check file README.md dan docs/ untuk additional info
