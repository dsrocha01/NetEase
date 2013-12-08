@echo off

:main
cls
goto init
:initFin
goto prepare
:prepareFin
goto copyFile
:copyFin
goto modifyFile
:modifyFin
goto finish

:init
if not exist "%java_home%" (
    set /p javaHome=������JDK��װ·�����磺C:\Java\jdk����
    set modifier="%javaHome%\bin\java.exe" -jar modifier.jar
) else (
    set modifier="%java_home%\bin\java.exe" -jar modifier.jar
)
set /p projName=����������Ŀ�����ƣ��磺Sample����
set /p addOKS=�Ƿ񼯳ɿ�ݷ���Y/N����
set /p addWechatCallback=�Ƿ񼯳�΢�ż�������Ȧ��Y/N����
if /i %addWechatCallback% == Y (
    set /p package=����������Ŀ�İ������磺cn.sharesdk.demo����
)
set packagePath=%package:.=\%
goto initFin

:prepare
if exist %projName% rd /s /q %projName%
mkdir %projName% > nul
set libDir=%projName%\libs
mkdir %libDir% > nul
set resDir=%projName%\res
mkdir %resDir% > nul
set assetsDir=%projName%\assets
mkdir %assetsDir% > nul
set srcDir=%projName%\src
mkdir %srcDir% > nul
goto prepareFin

:copyFile
xcopy /e Libs\MainLibs\libs %libDir% > nul
xcopy /e Libs\MainLibs\res %resDir% > nul
ren %resDir%\values\strings.xml ssdk_strings.xml > nul
ren %resDir%\values-en\strings.xml ssdk_strings.xml > nul
if /i %addOKS% == Y (
    xcopy /e Libs\OneKeyShare\libs %libDir% > nul
    xcopy /e Libs\OneKeyShare\res %resDir% > nul
    ren %resDir%\values\strings.xml oks_strings.xml > nul
    ren %resDir%\values-en\strings.xml oks_strings.xml > nul
    xcopy /e Libs\OneKeyShare\src %srcDir% > nul
)
xcopy /e Res %assetsDir% > nul
xcopy /e Src %srcDir% > nul
if /i %addWechatCallback% == Y (
    mkdir %srcDir%\%packagePath%\wxapi > nul
    xcopy /e %srcDir%\wxapi %srcDir%\%packagePath%\wxapi > nul
)
rd /s /q %srcDir%\wxapi > nul
goto copyFin

:modifyFile
if /i %addOKS% == Y (
    %modifier% -a "%~dp0%srcDir%\cn\sharesdk\onekeyshare" %package%
)
if /i %addWechatCallback% == Y (
    %modifier% -m "%~dp0%srcDir%\%packagePath%\wxapi" %package%
)
goto modifyFin

:finish
echo.
echo ����Share SDK������ļ��Ѿ����Ƶ�Ŀ¼%projName%�У��븴�����е��ļ���������Ŀ�и���
echo.
pause
del modifier.jar
del ˫�����������ļ���������һ�����ټ���ShareSDK��Ŀ¼.bat
