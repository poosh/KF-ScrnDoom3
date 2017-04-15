@echo off


setlocal
set KFDIR=d:\Games\kf
set STEAMDIR=c:\Steam\steamapps\common\KillingFloor
set outputdir=D:\KFOut\ScrnDoom3KF


echo Removing previous release files...
del /S /Q %outputdir%\*


echo Compiling project...
call make.cmd
if %ERRORLEVEL% NEQ 0 goto end

echo Exporting .int file...
%KFDIR%\system\ucc dumpint ScrnDoom3KF.u

echo.
echo Copying release files...
mkdir %outputdir%\System
rem mkdir %outputdir%\Textures
mkdir %outputdir%\uz2


copy /y %KFDIR%\system\ScrnDoom3KF.* %outputdir%\system\
copy /y *.txt  %outputdir%
copy /y *.ini  %outputdir%


echo Compressing to .uz2...
%KFDIR%\system\ucc compress %KFDIR%\system\ScrnDoom3KF.u

move /y %KFDIR%\system\ScrnDoom3KF*.uz2 %outputdir%\uz2

echo Release is ready!

endlocal

pause

:end
