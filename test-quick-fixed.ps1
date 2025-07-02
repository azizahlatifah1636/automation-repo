# Quick Test Script
# Run this script as: .\test-quick.ps1

param(
    [string]$Type = "all",
    [switch]$Watch = $false,
    [switch]$Coverage = $false,
    [switch]$Verbose = $false
)

Write-Host "Running tests..." -ForegroundColor Green

switch ($Type.ToLower()) {
    "api" {
        Write-Host "Running API tests..." -ForegroundColor Yellow
        Push-Location "api"
        if ($Watch) {
            npm run test:watch
        } elseif ($Coverage) {
            npm run test:coverage
        } else {
            if ($Verbose) { npm run test -- --verbose } else { npm test }
        }
        Pop-Location
    }
    
    "web" {
        Write-Host "Running Web UI tests..." -ForegroundColor Yellow
        Push-Location "web-ui"
        if ($Watch) {
            npm run test:watch
        } elseif ($Coverage) {
            npm run test -- --coverage --watchAll=false
        } else {
            if ($Verbose) { npm test -- --verbose --watchAll=false } else { npm test -- --watchAll=false }
        }
        Pop-Location
    }
    
    "e2e" {
        Write-Host "Running E2E tests..." -ForegroundColor Yellow
        Push-Location "web-ui"
        if ($Verbose) {
            npx playwright test --headed
        } else {
            npx playwright test
        }
        Pop-Location
    }
    
    "performance" {
        Write-Host "Running performance tests..." -ForegroundColor Yellow
        Push-Location "performance-tests"
        k6 run api-load-test.js
        Pop-Location
    }
    
    "lint" {
        Write-Host "Running linting..." -ForegroundColor Yellow
        npm run lint:all
    }
    
    "all" {
        Write-Host "Running all tests..." -ForegroundColor Yellow
        
        # API Tests
        Write-Host "`n1/4 API Tests..." -ForegroundColor Cyan
        Push-Location "api"
        npm test
        Pop-Location
        
        # Web UI Tests
        Write-Host "`n2/4 Web UI Tests..." -ForegroundColor Cyan
        Push-Location "web-ui"
        npm test -- --watchAll=false
        Pop-Location
        
        # E2E Tests
        Write-Host "`n3/4 E2E Tests..." -ForegroundColor Cyan
        Push-Location "web-ui"
        npx playwright test
        Pop-Location
        
        # Linting
        Write-Host "`n4/4 Linting..." -ForegroundColor Cyan
        npm run lint:all
        
        Write-Host "`nAll tests completed!" -ForegroundColor Green
    }
    
    default {
        Write-Host "Unknown test type: $Type" -ForegroundColor Red
        Write-Host "Available types: api, web, e2e, performance, lint, all" -ForegroundColor Yellow
        exit 1
    }
}

Write-Host "`nTest summary available in:" -ForegroundColor Cyan
Write-Host "   API: ./api/coverage/" -ForegroundColor Gray
Write-Host "   Web UI: ./web-ui/coverage/" -ForegroundColor Gray
Write-Host "   E2E: ./web-ui/playwright-report/" -ForegroundColor Gray
