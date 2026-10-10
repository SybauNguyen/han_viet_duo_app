@echo off
setlocal EnableExtensions EnableDelayedExpansion
cd /d "%~dp0"

where flutter >nul 2>nul
if errorlevel 1 (
  echo Khong tim thay lenh flutter. Hay cai Flutter SDK va them flutter\bin vao PATH.
  pause
  exit /b 1
)

if not exist "android" (
  echo Tao cau truc nen tang Android, Web va Windows lan dau...
  set "BACKUP=%TEMP%\han_viet_duo_backup_%RANDOM%"
  mkdir "!BACKUP!" >nul 2>nul
  xcopy "lib" "!BACKUP!\lib\" /E /I /Y >nul
  copy /Y "pubspec.yaml" "!BACKUP!\pubspec.yaml" >nul
  flutter create --platforms=android,web,windows --project-name=han_viet_duo .
  if errorlevel 1 (
    echo Flutter khong tao duoc cau truc nen tang. Hay kiem tra flutter doctor.
    pause
    exit /b 1
  )
  xcopy "!BACKUP!\lib" "lib\" /E /I /Y >nul
  copy /Y "!BACKUP!\pubspec.yaml" "pubspec.yaml" >nul
  rmdir /S /Q "!BACKUP!" >nul 2>nul
)

flutter pub get
if errorlevel 1 (
  echo Khong tai duoc dependencies. Kiem tra ket noi mang va pubspec.yaml.
  pause
  exit /b 1
)

flutter run
pause
