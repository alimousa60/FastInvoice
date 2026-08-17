# setup_android_sdk.ps1
# Run this script in PowerShell as Administrator

Write-Host "=== Setting up Android SDK for APK building ===" -ForegroundColor Green

$ErrorActionPreference = "Stop"

# Create SDK directory
$sdkDir = "C:\Android\Sdk"
New-Item -ItemType Directory -Force -Path $sdkDir | Out-Null

# Download cmdline-tools
Write-Host "`n[1/4] Downloading Android cmdline-tools..." -ForegroundColor Yellow
$zipUrl = "https://dl.google.com/android/repository/commandlinetools-win-11076708_latest.zip"
$zipPath = "$env:TEMP\cmdline-tools.zip"

Remove-Item $zipPath -Force -ErrorAction SilentlyContinue
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Invoke-WebRequest -Uri $zipUrl -OutFile $zipPath -UseBasicParsing
Write-Host "Downloaded: $((Get-Item $zipPath).Length / 1MB) MB"

# Extract
Write-Host "`n[2/4] Extracting..." -ForegroundColor Yellow
Expand-Archive -Path $zipPath -DestinationPath "$sdkDir\cmdline-tools-temp" -Force
New-Item -ItemType Directory -Force -Path "$sdkDir\cmdline-tools\latest" | Out-Null
Move-Item "$sdkDir\cmdline-tools-temp\cmdline-tools\*" "$sdkDir\cmdline-tools\latest\" -Force
Remove-Item -Recurse -Force "$sdkDir\cmdline-tools-temp" -ErrorAction SilentlyContinue

# Set JAVA_HOME
Write-Host "`n[3/4] Setting environment variables..." -ForegroundColor Yellow
$javaPath = "C:\Program Files\Microsoft\jdk-17.0.20-hotspot"
if (Test-Path $javaPath) {
    $env:JAVA_HOME = $javaPath
    [System.Environment]::SetEnvironmentVariable("JAVA_HOME", $javaPath, "User")
    Write-Host "JAVA_HOME = $javaPath"
}

# Accept licenses & install SDK components
Write-Host "`n[4/4] Installing SDK components (this may take a while)..." -ForegroundColor Yellow

$sdkmanager = "$sdkDir\cmdline-tools\latest\bin\sdkmanager.bat"
if (!(Test-Path $sdkmanager)) {
    Write-Host "ERROR: sdkmanager.bat not found at $sdkmanager" -ForegroundColor Red
    exit 1
}

# Accept all licenses
echo y | & $sdkmanager --licenses

# Install required components
& $sdkmanager "platform-tools" "platforms;android-34" "build-tools;34.0.0"

Write-Host "`n=== SDK Setup Complete! ===" -ForegroundColor Green
Write-Host "Now run: flutter doctor -v" -ForegroundColor Cyan
