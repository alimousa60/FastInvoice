@echo off
set PATH=%PATH%;D:\flutter_windows_3.44.0-stable\flutter\bin
set JAVA_HOME=C:\Program Files\Android\Android Studio\jbr
cd /d C:\Users\PC3\Desktop\invoice-flutter
flutter build apk --release --no-tree-shake-icons > build_output.txt 2>&1
echo BUILD_DONE > build_done.txt
