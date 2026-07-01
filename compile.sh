#!/usr/bin/env bash
set -e
javac DevLauncher.java
jar cfe DevLauncher.jar DevLauncher DevLauncher.class
rm DevLauncher.class
echo "DevLauncher.jar created successfully."
