@echo off
setlocal enabledelayedexpansion

cd /d "%~dp0"

REM Step 1: Compile DevLauncher
echo ==^> Compiling DevLauncher...
javac DevLauncher.java
if %errorlevel% neq 0 exit /b %errorlevel%
jar cfe DevLauncher.jar DevLauncher DevLauncher.class
del DevLauncher.class

REM Step 2: If a plugin repo path is given, build and install it
set "PLUGIN_DIR=%~1"
if defined PLUGIN_DIR (
    if not exist "!PLUGIN_DIR!" (
        echo Error: plugin directory not found: !PLUGIN_DIR!
        exit /b 1
    )

    echo ==^> Building plugin in !PLUGIN_DIR!...
    pushd "!PLUGIN_DIR!"
    call gradlew.bat build
    if !errorlevel! neq 0 exit /b !errorlevel!
    popd

    echo ==^> Installing plugin...
    powershell -NoProfile -ExecutionPolicy Bypass -Command "$pluginDir='!PLUGIN_DIR!';$sideloadDir=[System.IO.Path]::Combine($env:USERPROFILE,'.runelite','sideloaded-plugins');$jars=Get-ChildItem (Join-Path $pluginDir 'build\libs\*.jar')|Sort-Object LastWriteTime -Descending;if(-not $jars){Write-Error 'No jar found';exit 1}$latest=$jars[0];$jarName=$latest.Name;Write-Host ('==> Found: '+$jarName);if($jarName -match '^(.+?)-?\d[\d.]*(-(SNAPSHOT|RC\d+|M\d+))?\.jar$'){$prefix=$matches[1]}else{$prefix=[System.IO.Path]::GetFileNameWithoutExtension($jarName)};if(-not (Test-Path $sideloadDir)){New-Item -ItemType Directory -Path $sideloadDir|Out-Null};Get-ChildItem (Join-Path $sideloadDir ($prefix+'*.jar'))|ForEach-Object{Write-Host ('   Removed old: '+$_.Name);Remove-Item $_ -Force};Copy-Item $latest.FullName (Join-Path $sideloadDir $jarName);Write-Host ('==> Installed '+$jarName)"
    if !errorlevel! neq 0 exit /b !errorlevel!
)

REM Step 3: Launch RuneLite
echo ==^> Launching RuneLite...
java -jar DevLauncher.jar
