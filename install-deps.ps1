# Setup All Dependencies
# PowerShell version of setup:all

Write-Host "Installing dependencies for all projects..." -ForegroundColor Green

Write-Host "`nInstalling API dependencies..." -ForegroundColor Yellow
Push-Location "api"
npm install
if ($LASTEXITCODE -ne 0) {
    Write-Host "Failed to install API dependencies" -ForegroundColor Red
    Pop-Location
    exit 1
}
Pop-Location
Write-Host "API dependencies installed" -ForegroundColor Green

Write-Host "`nInstalling Web UI dependencies..." -ForegroundColor Yellow
Push-Location "web-ui"
npm install
if ($LASTEXITCODE -ne 0) {
    Write-Host "Failed to install Web UI dependencies" -ForegroundColor Red
    Pop-Location
    exit 1
}
Pop-Location
Write-Host "Web UI dependencies installed" -ForegroundColor Green

Write-Host "`nInstalling Smoke Tests dependencies..." -ForegroundColor Yellow
Push-Location "smoke-tests"
npm install
if ($LASTEXITCODE -ne 0) {
    Write-Host "Failed to install Smoke Tests dependencies" -ForegroundColor Red
    Pop-Location
    exit 1
}
Pop-Location
Write-Host "Smoke Tests dependencies installed" -ForegroundColor Green

Write-Host "`nAll dependencies installed successfully!" -ForegroundColor Green
