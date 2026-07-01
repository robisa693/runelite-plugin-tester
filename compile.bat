@echo off
javac DevLauncher.java
if %errorlevel% neq 0 exit /b %errorlevel%
jar cfe DevLauncher.jar DevLauncher DevLauncher.class
del DevLauncher.class
echo DevLauncher.jar created successfully.
