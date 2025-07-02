# GitHub Actions Setup Guide

## Langkah-langkah untuk Mengaktifkan Pipeline

### 1. Repository Setup

1. **Clone atau fork repository ini ke GitHub account Anda**
2. **Pastikan repository memiliki struktur folder yang benar:**
   ```
   pipeline-automation/
   ├── .github/workflows/
   ├── api/
   ├── web-ui/
   ├── performance-tests/
   └── smoke-tests/
   ```

### 2. Secrets Configuration

Tambahkan secrets berikut di GitHub repository settings:

```
Repository Settings → Secrets and Variables → Actions
```

**Required Secrets:**
- `DOCKER_USERNAME` - Docker Hub username
- `DOCKER_PASSWORD` - Docker Hub password/token
- `STAGING_URL` - URL staging environment
- `PRODUCTION_URL` - URL production environment
- `SLACK_WEBHOOK_URL` - (Optional) Untuk notifikasi Slack

### 3. Environment Setup

Buat environments di repository settings:

1. **staging** - Untuk automatic deployment dari main branch
2. **production** - Untuk manual deployment dengan approval

```
Repository Settings → Environments
```

### 4. Branch Protection

Setup branch protection rules untuk `main` branch:

```
Repository Settings → Branches → Add rule
```

**Recommended Settings:**
- ✅ Require pull request reviews before merging
- ✅ Require status checks to pass before merging
- ✅ Require branches to be up to date before merging
- ✅ Include administrators

### 5. Actions Permissions

Pastikan GitHub Actions memiliki permissions yang diperlukan:

```
Repository Settings → Actions → General
```

**Required Permissions:**
- ✅ Allow all actions and reusable workflows
- ✅ Read and write permissions
- ✅ Allow GitHub Actions to create and approve pull requests

## Trigger Conditions

Pipeline akan berjalan pada kondisi berikut:

### Automatic Triggers
- **Push ke `main` branch** → Full pipeline + deployment ke staging
- **Push ke `develop` branch** → Full pipeline (tanpa deployment)
- **Pull Request ke `main`** → Full pipeline + PR comment dengan hasil

### Manual Triggers
- **Production Deployment** → Manual workflow dengan approval
- **Security Scan** → Daily scheduled atau manual trigger

## Monitoring dan Troubleshooting

### 1. Melihat Status Pipeline
- Buka tab **Actions** di repository GitHub
- Pilih workflow run yang ingin dilihat
- Review logs untuk setiap job

### 2. Download Artifacts
- Pada halaman workflow run, scroll ke bawah
- Klik pada artifact yang ingin didownload
- Extract dan review hasil testing

### 3. Common Issues

**Pipeline Gagal pada API Tests:**
```bash
# Check package.json scripts
cd api
npm run test
```

**Pipeline Gagal pada Web UI Tests:**
```bash
# Check Playwright installation
cd web-ui
npx playwright install
npm run test:e2e
```

**Docker Build Gagal:**
```bash
# Test docker build locally
docker build -t test-api ./api
docker build -t test-web ./web-ui
```

### 4. Debug Mode

Untuk troubleshooting, tambahkan step debug:

```yaml
- name: Debug Information
  run: |
    echo "Runner OS: ${{ runner.os }}"
    echo "GitHub Event: ${{ github.event_name }}"
    echo "Branch: ${{ github.ref }}"
    env
```

## Customization

### Menambah Browser Testing
Edit `web-ui-tests` job di `main.yml`:

```yaml
strategy:
  matrix:
    browser: [chrome, firefox, safari, edge]
```

### Menambah Node.js Versions
Edit matrix di jobs yang diperlukan:

```yaml
strategy:
  matrix:
    node-version: [16.x, 18.x, 20.x]
```

### Menambah Environment
1. Buat environment baru di GitHub settings
2. Tambahkan job deployment baru di workflow
3. Configure secrets untuk environment tersebut

## Best Practices

1. **Commit Messages** - Gunakan conventional commits
2. **PR Reviews** - Selalu review PR sebelum merge
3. **Testing** - Run tests locally sebelum push
4. **Security** - Regular security scanning
5. **Documentation** - Update docs saat ada perubahan

## Support

Jika mengalami issues:
1. Check workflow logs di GitHub Actions
2. Review documentation ini
3. Test commands locally terlebih dahulu
4. Contact QA team untuk bantuan lebih lanjut
