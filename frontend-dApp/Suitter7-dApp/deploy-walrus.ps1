#!/usr/bin/env pwsh
# Walrus Deployment Script for Suitter dApp

$ErrorActionPreference = "Stop"

Write-Host "🚀 Deploying Suitter to Walrus Sites..." -ForegroundColor Cyan

# Build the project
Write-Host "`n📦 Building project..." -ForegroundColor Yellow
npm run build

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Build failed!" -ForegroundColor Red
    exit 1
}

# Copy routing config to dist
Write-Host "`n📋 Copying Walrus config..." -ForegroundColor Yellow
Copy-Item walrus-site.yaml dist/

# Navigate to dist folder
Set-Location dist

# Check if SUITTER_SITE_ID environment variable exists
if ($env:SUITTER_SITE_ID) {
    Write-Host "`n🔄 Updating existing site: $env:SUITTER_SITE_ID" -ForegroundColor Green
    site-builder update --epochs 100 . $env:SUITTER_SITE_ID
} else {
    Write-Host "`n🆕 Publishing new site..." -ForegroundColor Green
    Write-Host "⚠️  This will create a NEW site. After deployment, save the Site Object ID!" -ForegroundColor Yellow
    Write-Host "    Then run: `$env:SUITTER_SITE_ID='0x...' (Windows)" -ForegroundColor Yellow
    Write-Host ""
    site-builder publish --epochs 100 .
}

# Return to project root
Set-Location ..

Write-Host "`n✅ Deployment complete!" -ForegroundColor Green
Write-Host "📝 Don't forget to save the Site Object ID if this was a new deployment!" -ForegroundColor Yellow
