@echo off
set PATH=D:\flutter_windows_3.44.0-stable\flutter\bin;%PATH%
set JAVA_HOME=C:\Program Files\Android\Android Studio\jbr
cd /d C:\Users\PC3\Desktop\invoice-flutter
flutter pub get
flutter build apk --release --no-tree-shake-icons
echo EXIT_CODE=%ERRORLEVEL% > build_result.txt
if %ERRORLEVEL% EQU 0 (
    echo SUCCESS >> build_result.txt
) else (
    echo FAILED >> build_result.txt
)
