## Cara Membuka dan Menggunakan Report


Sistem CI/CD pipeline ini menghasilkan berbagai jenis report yang dapat diunduh dan dilihat setelah workflow selesai dijalankan.

## Jenis Report yang Tersedia

### 1. **Test Coverage Report**
- **File**: `coverage-report.zip`
- **Berisi**: HTML coverage report, lcov files
- **Cara Buka**: 
  1. Download artifact `coverage-report`
  2. Extract file ZIP
  3. Buka `index.html` di browser
  4. Lihat coverage percentage per file/function

### 2. **API Test Results**
- **File**: `api-test-results.zip`
- **Berisi**: Jest test results, JSON reports
- **Cara Buka**:
  1. Download artifact `api-test-results`
  2. Extract file ZIP
  3. Buka `test-results.json` dengan text editor
  4. Atau lihat `test-report.html` di browser

### 3. **UI Test Results (Playwright)**
- **File**: `ui-test-results.zip`
- **Berisi**: Playwright HTML report, screenshots, videos
- **Cara Buka**:
  1. Download artifact `ui-test-results`
  2. Extract file ZIP
  3. Buka `playwright-report/index.html` di browser
  4. Lihat test results per browser
  5. Klik pada failed tests untuk melihat screenshots/videos

### 4. **Performance Test Results**
- **File**: `performance-results.zip`
- **Berisi**: k6 performance metrics, HTML report
- **Cara Buka**:
  1. Download artifact `performance-results`
  2. Extract file ZIP
  3. Buka `performance-report.html` di browser
  4. Lihat response times, throughput, error rates

### 5. **Security Scan Results**
- **File**: `security-scan-results.zip`
- **Berisi**: Docker security scan results
- **Cara Buka**:
  1. Download artifact `security-scan-results`
  2. Extract file ZIP
  3. Buka `security-report.json` dengan text editor
  4. Lihat vulnerabilities dan recommendations

 
 ## Cara Mengakses Reports

### **Step 1: Buka GitHub Actions**
1. Buka repository: https://github.com/azizahlatifah1636/automation-repo
2. Klik tab **"Actions"**
3. Pilih workflow run yang ingin dilihat

### **Step 2: Download Artifacts**
1. Scroll ke bawah pada workflow run page
2. Lihat section **"Artifacts"**
3. Klik nama artifact yang ingin didownload
4. File akan terdownload sebagai ZIP

### **Step 3: Extract dan Buka**
1. Extract file ZIP yang didownload
2. Buka file sesuai petunjuk di atas
3. Untuk HTML reports, buka dengan browser modern (Chrome, Firefox, Safari)

Viewing Reports

### **Browser Requirements**
- Chrome/Chromium 70+
- Firefox 65+
- Safari 12+
- Edge 79+

**HTML Reports Features**
- **Interactive**: Klik untuk expand/collapse sections
- **Filterable**: Filter by status, browser, test type
- **Searchable**: Search specific tests atau files
- **Responsive**: Mobile-friendly viewing

Troubleshooting

### **Report Tidak Bisa Dibuka**
1. **Pastikan file sudah di-extract** dari ZIP
2. **Coba browser lain** jika ada masalah JavaScript
3. **Disable ad-blockers** yang mungkin memblokir local files
4. **Buka dengan web server** untuk advanced features:
   ```bash
   # Contoh dengan Python
   cd path/to/extracted/report
   python -m http.server 8000
   # Buka http://localhost:8000
   ```

### **File Tidak Ter-generate**
1. **Cek workflow logs** untuk error messages
2. **Pastikan tests berjalan** tanpa critical failures
3. **Cek artifact retention** (default 90 days)

Links 

- **Repository**: https://github.com/azizahlatifah1636/automation-repo
- **Actions**: https://github.com/azizahlatifah1636/automation-repo/actions
- **Issues**: https://github.com/azizahlatifah1636/automation-repo/issues



---

**Untuk melihat hasil testing terbaru:**
1. Go to [Actions tab](https://github.com/azizahlatifah1636/automation-repo/actions)
2. Click latest workflow run
3. Download "ui-test-results" artifact
4. Extract dan buka `playwright-report/index.html`
5. Enjoy comprehensive test reports! 🎉
