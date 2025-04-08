@echo off
chcp 65001 >nul
cls
echo ===== إدارة تطبيق SalesApp =====
echo.
echo 1. تشغيل التطبيق⁭
echo 2. إيقاف التطبيق
echo 3. إعادة تشغيل التطبيق
echo 4. عرض حالة الحاويات
echo 5. عرض سجلات الباك إند
echo 6. عرض سجلات الفرونت إند
echo 7. إعادة بناء حاويات التطبيق
echo 8. الخروج
echo.

set /p choice=اختر رقم العملية: 

if "%choice%"=="1" (
    docker-compose up -d
    echo تم تشغيل التطبيق بنجاح.
    timeout 2 >nul
    goto start
)
if "%choice%"=="2" (
    docker-compose down
    echo تم إيقاف التطبيق بنجاح.
    timeout 2 >nul
    goto start
)
if "%choice%"=="3" (
    docker-compose down
    docker-compose up -d
    echo تم إعادة تشغيل التطبيق بنجاح.
    timeout 2 >nul
    goto start
)
if "%choice%"=="4" (
    docker ps
    pause
    goto start
)
if "%choice%"=="5" (
    docker logs salesapp-backend --tail 100
    pause
    goto start
)
if "%choice%"=="6" (
    docker logs salesapp-frontend --tail 100
    pause
    goto start
)
if "%choice%"=="7" (
    docker-compose down
    docker-compose build
    docker-compose up -d
    echo تم إعادة بناء وتشغيل التطبيق بنجاح.
    timeout 2 >nul
    goto start
)
if "%choice%"=="8" (
    exit
)

echo اختيار غير صالح، يرجى المحاولة مرة أخرى.
timeout 2 >nul
goto start

:start
cls
goto :eof
