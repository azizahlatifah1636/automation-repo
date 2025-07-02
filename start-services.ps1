# Start Services Script
# Run as: .\start-services.ps1 -Service api|web|all

param(
    [string]$Service = "all"
)

Write-Host "Starting services..." -ForegroundColor Green

switch ($Service.ToLower()) {
    "api" {
        Write-Host "Starting API server..." -ForegroundColor Yellow
        Push-Location "api"
        npm start
        Pop-Location
    }
    
    "web" {
        Write-Host "Starting Web UI..." -ForegroundColor Yellow
        Push-Location "web-ui"
        npm start
        Pop-Location
    }
    
    "all" {
        Write-Host "Starting all services..." -ForegroundColor Yellow
        
        # Check if concurrently is available
        try {
            npx concurrently --version | Out-Null
            Write-Host "Using concurrently to start services..." -ForegroundColor Cyan
            npx concurrently "cd api && npm start" "cd web-ui && npm start"
        } catch {
            Write-Host "Concurrently not available. Starting services manually..." -ForegroundColor Yellow
            Write-Host "Starting API server in background..." -ForegroundColor Cyan
            
            # Start API in background
            $apiJob = Start-Job -ScriptBlock {
                Set-Location $args[0]
                Set-Location "api"
                npm start
            } -ArgumentList (Get-Location).Path
            
            Start-Sleep 5
            
            Write-Host "Starting Web UI..." -ForegroundColor Cyan
            Push-Location "web-ui"
            npm start
            Pop-Location
            
            # Clean up background job
            Remove-Job $apiJob -Force
        }
    }
    
    default {
        Write-Host "Unknown service: $Service" -ForegroundColor Red
        Write-Host "Available services: api, web, all" -ForegroundColor Yellow
        exit 1
    }
}

Write-Host "`nServices started!" -ForegroundColor Green
Write-Host "URLs:" -ForegroundColor Cyan
Write-Host "   API: http://localhost:3000" -ForegroundColor Blue
Write-Host "   Web UI: http://localhost:8080" -ForegroundColor Blue
