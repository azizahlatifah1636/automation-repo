# Pipeline Automation Repository

Repository ini berisi konfigurasi GitHub Actions untuk automation testing API dan Web UI.

## Struktur Project

```text
pipeline-automation/
├── .github/
│   └── workflows/
│       └── main.yml           # Konfigurasi GitHub Actions utama
├── api/                       # API automation tests
│   ├── package.json
│   ├── src/
│   ├── tests/
│   └── Dockerfile
├── web-ui/                    # Web UI automation tests
│   ├── package.json
│   ├── src/
│   ├── tests/
│   └── Dockerfile
├── performance-tests/         # Performance testing dengan k6
├── smoke-tests/              # Smoke tests untuk deployment
└── README.md
```

## GitHub Actions Pipeline

Pipeline ini akan dijalankan pada kondisi berikut:

- **Push** ke branch `main` atau `develop`
- **Pull Request** yang di-merge ke branch `main`

### Jobs yang Dijalankan

1. **API Tests** - Testing API dengan berbagai versi Node.js
2. **Web UI Tests** - Testing UI dengan berbagai browser (Chrome, Firefox)
3. **Docker Build** - Build dan security scan Docker images
4. **Performance Tests** - Load testing menggunakan k6
5. **Deploy Staging** - Deployment ke staging environment (hanya main branch)
6. **Generate Report** - Generate consolidated test report

### Artifacts yang Dihasilkan

Pipeline akan menghasilkan artifacts berikut:

- **API Test Results** - Coverage reports, unit & integration test results
- **Web UI Test Results** - Playwright reports, screenshots, coverage
- **Security Scan Results** - Trivy security scan reports
- **Performance Test Results** - k6 performance test results
- **Consolidated Test Report** - Merged report dari semua testing

### Environment Variables

```yaml
NODE_ENV: test
API_BASE_URL: http://localhost:3000
WEB_UI_BASE_URL: http://localhost:8080
DATABASE_URL: postgresql://test:test@localhost:5432/testdb
```

## Setup Local Development

1. Clone repository
2. Install dependencies untuk API dan Web UI
3. Configure environment variables
4. Run tests locally sebelum push

## 🧪 Menjalankan Testing di Local

### Prerequisites

Pastikan Anda sudah menginstall:
- **Node.js** (versi 18.x atau 20.x)
- **Docker** (untuk container testing)
- **k6** (untuk performance testing)
- **Git**

### 1. Setup Project

```powershell
# Clone repository
git clone <repository-url>
cd pipeline-automation

# Setup dasar
.\setup-simple.ps1

# Install dependencies untuk semua project
.\install-deps.ps1
# atau manual:
cd api
npm install
cd ..\web-ui
npm install
cd ..\smoke-tests
npm install
cd ..
```

### 2. Setup Environment Variables

Buat file `.env` di root directory:

```bash
# API Configuration
API_PORT=3000
API_BASE_URL=http://localhost:3000
NODE_ENV=development

# Web UI Configuration
WEB_UI_PORT=8080
WEB_UI_BASE_URL=http://localhost:8080

# Database (jika diperlukan)
DATABASE_URL=postgresql://test:test@localhost:5432/testdb

# Testing
TEST_TIMEOUT=30000
HEADLESS_BROWSER=false
```

### 3. Menjalankan API Tests

```bash
# Masuk ke folder API
cd api

# Jalankan unit tests
npm run test:unit

# Jalankan integration tests
npm run test:integration

# Jalankan semua tests dengan coverage
npm run test:coverage

# Jalankan linting
npm run lint
```

### 4. Menjalankan Web UI Tests

```bash
# Masuk ke folder Web UI
cd web-ui

# Install Playwright browsers (hanya sekali)
npx playwright install

# Jalankan unit tests
npm run test:unit

# Jalankan E2E tests
npm run test:e2e

# Jalankan E2E tests untuk browser specific
npm run test:e2e:chrome
npm run test:e2e:firefox

# Jalankan visual testing
npm run test:visual

# Jalankan linting
npm run lint
```

### 5. Menjalankan Performance Tests

```bash
# Install k6 (Windows)
winget install k6

# Atau download dari https://k6.io/docs/getting-started/installation/

# Start API server terlebih dahulu
cd api && npm start

# Jalankan performance tests (di terminal baru)
cd performance-tests
k6 run api-load-test.js

# Dengan custom configuration
k6 run --vus 20 --duration 5m api-load-test.js
```

### 6. Menjalankan Docker Tests

```bash
# Build Docker images
docker build -t pipeline-automation-api ./api
docker build -t pipeline-automation-web ./web-ui

# Run containers
docker run -p 3000:3000 pipeline-automation-api
docker run -p 8080:8080 pipeline-automation-web

# Run dengan docker-compose (jika ada)
docker-compose up -d
```

### 7. Menggunakan VS Code Tasks

Buka Command Palette (`Ctrl+Shift+P`) dan pilih:

- **Tasks: Run Task** → **Install Dependencies**
- **Tasks: Run Task** → **Run API Tests**
- **Tasks: Run Task** → **Run Web UI Tests**
- **Tasks: Run Task** → **Start API Server**
- **Tasks: Run Task** → **Start Web UI**
- **Tasks: Run Task** → **Run Performance Tests**

### 8. Continuous Testing (Watch Mode)

```bash
# API - Watch mode untuk development
cd api && npm run test:watch

# Web UI - Watch mode
cd web-ui && npm run test:watch

# Playwright UI mode untuk debugging
cd web-ui && npx playwright test --ui
```

### 9. Debug Testing

**Debugging Playwright Tests:**
```bash
# Jalankan dengan browser visible
cd web-ui
npx playwright test --headed

# Debug mode dengan step-by-step
npx playwright test --debug

# Generate test code
npx playwright codegen localhost:8080
```

**Debugging API Tests:**
```bash
# Jalankan dengan debug output
cd api
npm run test -- --verbose

# Jalankan specific test file
npm run test -- tests/unit/user.test.js
```

### 10. Troubleshooting

**Common Issues:**

1. **Port sudah digunakan:**
   ```bash
   # Check port usage
   netstat -ano | findstr :3000
   # Kill process jika diperlukan
   taskkill /PID <process_id> /F
   ```

2. **Playwright browser issues:**
   ```bash
   # Reinstall browsers
   npx playwright install --force
   ```

3. **Node modules issues:**
   ```bash
   # Clean install
   rm -rf node_modules package-lock.json
   npm install
   ```

4. **Docker issues:**
   ```bash
   # Clean Docker cache
   docker system prune -a
   ```

### 11. Quick Test Commands

Untuk testing cepat, gunakan script berikut di root directory:

```bash
# Test semua
npm run test:all

# Test API only
npm run test:api

# Test Web UI only
npm run test:web

# Test performance only
npm run test:performance

# Lint semua project
npm run lint:all
```
