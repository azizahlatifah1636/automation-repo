# Simple Setup Script for Pipeline Automation
Write-Host "Pipeline Automation Setup" -ForegroundColor Green

# Check Node.js
Write-Host "`nChecking Node.js..." -ForegroundColor Yellow
try {
    $nodeVersion = & node --version
    Write-Host "Node.js: $nodeVersion" -ForegroundColor Green
} catch {
    Write-Host "Node.js not found" -ForegroundColor Red
    exit 1
}

# Setup .env file
Write-Host "`nSetting up environment..." -ForegroundColor Yellow
if (-not (Test-Path ".env")) {
    Copy-Item ".env.example" ".env"
    Write-Host "Created .env file" -ForegroundColor Green
} else {
    Write-Host ".env file exists" -ForegroundColor Green
}

# Install root dependencies
Write-Host "`nInstalling root dependencies..." -ForegroundColor Yellow
npm install
Write-Host "Root dependencies installed" -ForegroundColor Green

Write-Host "`nBasic setup completed!" -ForegroundColor Green
Write-Host "`nNext steps:" -ForegroundColor Cyan
Write-Host "1. Install project dependencies: .\install-deps.ps1" -ForegroundColor White
Write-Host "2. Run tests: .\test-quick.ps1" -ForegroundColor White
Write-Host "3. Start services: .\start-services.ps1" -ForegroundColor White
