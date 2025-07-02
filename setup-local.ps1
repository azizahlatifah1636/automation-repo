# Pipeline Automation Local Setup Script
# Run this script as: .\setup-local.ps1

Write-Host "🚀 Setting up Pipeline Automation for local development..." -ForegroundColor Green

# Check prerequisites
Write-Host "`n📋 Checking prerequisites..." -ForegroundColor Yellow

# Check Node.js
try {
    $nodeVersion = node --version
    Write-Host "✅ Node.js found: $nodeVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Node.js not found. Please install Node.js 18.x or 20.x" -ForegroundColor Red
    exit 1
}

# Check Docker
try {
    $dockerVersion = docker --version
    Write-Host "✅ Docker found: $dockerVersion" -ForegroundColor Green
} catch {
    Write-Host "⚠️  Docker not found. Docker is optional but recommended" -ForegroundColor Yellow
}

# Check npm
try {
    $npmVersion = npm --version
    Write-Host "✅ npm found: $npmVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ npm not found" -ForegroundColor Red
    exit 1
}

# Setup environment file
Write-Host "`n🔧 Setting up environment variables..." -ForegroundColor Yellow
if (!(Test-Path ".env")) {
    Copy-Item ".env.example" ".env"
    Write-Host "✅ Created .env file from template" -ForegroundColor Green
} else {
    Write-Host "✅ .env file already exists" -ForegroundColor Green
}

# Install dependencies
Write-Host "`n📦 Installing dependencies..." -ForegroundColor Yellow

# Root dependencies
Write-Host "Installing root dependencies..."
npm install

# API dependencies
Write-Host "Installing API dependencies..."
Push-Location "api"
npm install
Pop-Location

# Web UI dependencies
Write-Host "Installing Web UI dependencies..."
Push-Location "web-ui"
npm install
Pop-Location

# Smoke tests dependencies
Write-Host "Installing smoke tests dependencies..."
Push-Location "smoke-tests"
npm install
Pop-Location

Write-Host "✅ All dependencies installed successfully!" -ForegroundColor Green

# Install Playwright browsers
Write-Host "`n🎭 Installing Playwright browsers..." -ForegroundColor Yellow
Push-Location "web-ui"
try {
    npx playwright install
    Write-Host "✅ Playwright browsers installed" -ForegroundColor Green
} catch {
    Write-Host "⚠️  Failed to install Playwright browsers. You can install them later with:" -ForegroundColor Yellow
    Write-Host "   cd web-ui" -ForegroundColor Cyan
    Write-Host "   npx playwright install" -ForegroundColor Cyan
}
Pop-Location

# Check k6 installation
Write-Host "`n⚡ Checking k6 for performance testing..." -ForegroundColor Yellow
try {
    $k6Version = k6 version
    Write-Host "✅ k6 found: $k6Version" -ForegroundColor Green
} catch {
    Write-Host "⚠️  k6 not found. Install it for performance testing:" -ForegroundColor Yellow
    Write-Host "   Windows: winget install k6" -ForegroundColor Cyan
    Write-Host "   Or download from: https://k6.io/docs/getting-started/installation/" -ForegroundColor Cyan
}

# Check available ports
Write-Host "`n🔍 Checking port availability..." -ForegroundColor Yellow
$port3000 = Get-NetTCPConnection -LocalPort 3000 -ErrorAction SilentlyContinue
$port8080 = Get-NetTCPConnection -LocalPort 8080 -ErrorAction SilentlyContinue

if ($port3000) {
    Write-Host "⚠️  Port 3000 is in use. You may need to stop the service using it." -ForegroundColor Yellow
} else {
    Write-Host "✅ Port 3000 is available for API" -ForegroundColor Green
}

if ($port8080) {
    Write-Host "⚠️  Port 8080 is in use. You may need to stop the service using it." -ForegroundColor Yellow
} else {
    Write-Host "✅ Port 8080 is available for Web UI" -ForegroundColor Green
}

# Create VS Code workspace settings
Write-Host "`n🔧 Setting up VS Code workspace..." -ForegroundColor Yellow
$vscodeSettingsDir = ".vscode"
if (!(Test-Path $vscodeSettingsDir)) {
    New-Item -ItemType Directory -Path $vscodeSettingsDir -Force | Out-Null
}

$settings = @{
    "files.exclude" = @{
        "**/node_modules" = $true
        "**/coverage" = $true
        "**/test-results" = $true
        "**/.env" = $true
    }
    "search.exclude" = @{
        "**/node_modules" = $true
        "**/coverage" = $true
    }
    "typescript.preferences.includePackageJsonAutoImports" = "on"
    "editor.codeActionsOnSave" = @{
        "source.fixAll.eslint" = $true
    }
} | ConvertTo-Json -Depth 3

Set-Content -Path "$vscodeSettingsDir/settings.json" -Value $settings
Write-Host "✅ VS Code settings configured" -ForegroundColor Green

Write-Host "`n🎉 Setup completed successfully!" -ForegroundColor Green
Write-Host "`n📖 Next steps:" -ForegroundColor Cyan
Write-Host "1. Run tests:" -ForegroundColor White
Write-Host "   npm run test:all              # Run all tests" -ForegroundColor Gray
Write-Host "   npm run test:api              # Run API tests only" -ForegroundColor Gray
Write-Host "   npm run test:web              # Run Web UI tests only" -ForegroundColor Gray
Write-Host ""
Write-Host "2. Start services:" -ForegroundColor White
Write-Host "   npm run start:api             # Start API server" -ForegroundColor Gray
Write-Host "   npm run start:web             # Start Web UI" -ForegroundColor Gray
Write-Host "   npm run start:all             # Start both services" -ForegroundColor Gray
Write-Host ""
Write-Host "3. Docker (optional):" -ForegroundColor White
Write-Host "   docker-compose up -d          # Start all services with Docker" -ForegroundColor Gray
Write-Host ""
Write-Host "4. VS Code:" -ForegroundColor White
Write-Host "   code .                        # Open in VS Code" -ForegroundColor Gray
Write-Host "   Ctrl+Shift+P → Tasks: Run Task # Run predefined tasks" -ForegroundColor Gray

Write-Host "`n🔗 Useful URLs (after starting services):" -ForegroundColor Cyan
Write-Host "   API: http://localhost:3000" -ForegroundColor Blue
Write-Host "   Web UI: http://localhost:8080" -ForegroundColor Blue
Write-Host "   Playwright UI:" -ForegroundColor Blue
Write-Host "     cd web-ui" -ForegroundColor Gray
Write-Host "     npx playwright test --ui" -ForegroundColor Gray
