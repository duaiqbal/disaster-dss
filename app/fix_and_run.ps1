# ============================================================
# Disaster DSS — Complete Fix & Rebuild Script
# ============================================================

Write-Host "=== Step 1: Setting up environment ===" -ForegroundColor Cyan
$env:JAVA_HOME = "C:\Program Files\Android\Android Studio\jbr"
$env:Path += ";D:\Android\Sdk\platform-tools"

Write-Host "=== Step 2: Navigating to project ===" -ForegroundColor Cyan
Set-Location "C:\Users\Computer Arena\disaster_dss\app"

Write-Host "=== Step 3: Stopping any stuck Gradle daemons ===" -ForegroundColor Cyan
Set-Location "android"
& .\gradlew --stop
Set-Location ".."

Write-Host "=== Step 4: Cleaning old build files ===" -ForegroundColor Cyan
flutter clean

Write-Host "=== Step 5: Uninstalling old app from emulator (removes stale database) ===" -ForegroundColor Cyan
$uninstallResult = adb uninstall com.example.disaster_dss
Write-Host "Uninstall result: $uninstallResult" -ForegroundColor Yellow

Write-Host "=== Step 6: Getting fresh dependencies ===" -ForegroundColor Cyan
flutter pub get

Write-Host "=== Step 7: Verifying database assets are in place ===" -ForegroundColor Cyan
$knowledgeExists = Test-Path "assets\offline_package\knowledge.sqlite"
$hazardExists = Test-Path "assets\offline_package\hazard_grid.sqlite"
Write-Host "knowledge.sqlite present: $knowledgeExists" -ForegroundColor Yellow
Write-Host "hazard_grid.sqlite present: $hazardExists" -ForegroundColor Yellow

if (-not $knowledgeExists -or -not $hazardExists) {
    Write-Host "ERROR: Database assets missing! Stopping here." -ForegroundColor Red
    Write-Host "Run this first from the project root:" -ForegroundColor Red
    Write-Host "  Copy-Item -Force offline_package\knowledge.sqlite app\assets\offline_package\knowledge.sqlite" -ForegroundColor Red
    exit
}

Write-Host "=== Step 8: Building and running (this takes several minutes) ===" -ForegroundColor Cyan
Write-Host "Watch for 'flood' query test after the app opens." -ForegroundColor Green
flutter run