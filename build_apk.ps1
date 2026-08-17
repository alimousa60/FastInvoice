$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
$env:JAVA_HOME = "C:\Program Files\Android\Android Studio\jbr"
Set-Location "C:\Users\PC3\Desktop\invoice-flutter"
Write-Host "Building APK..."
flutter build apk --release --no-tree-shake-icons 2>&1 | Tee-Object -FilePath "C:\Users\PC3\Desktop\invoice-flutter\build_log.txt"
if ($LASTEXITCODE -eq 0) {
    Write-Host "BUILD SUCCESS!"
    Get-ChildItem "build\app\outputs\flutter-apk\*.apk" | ForEach-Object { Write-Host "APK: $($_.FullName) ($([math]::Round($_.Length/1MB,1)) MB)" }
} else {
    Write-Host "BUILD FAILED with exit code $LASTEXITCODE"
}
