#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Step 1: Compile DevLauncher
echo "==> Compiling DevLauncher..."
javac "$SCRIPT_DIR/DevLauncher.java"
jar cfe "$SCRIPT_DIR/DevLauncher.jar" DevLauncher -C "$SCRIPT_DIR" DevLauncher.class
rm "$SCRIPT_DIR/DevLauncher.class"

# Step 2: If a plugin repo path is given, build and install it
if [ -n "$1" ]; then
    PLUGIN_DIR="$1"
    if [ ! -d "$PLUGIN_DIR" ]; then
        echo "Error: plugin directory not found: $PLUGIN_DIR" >&2
        exit 1
    fi

    echo "==> Building plugin in $PLUGIN_DIR..."
    (cd "$PLUGIN_DIR" && ./gradlew build)

    LATEST_JAR=$(ls -t "$PLUGIN_DIR/build/libs/"*.jar 2>/dev/null | head -1)
    if [ -z "$LATEST_JAR" ]; then
        echo "Error: no jar found in $PLUGIN_DIR/build/libs/" >&2
        exit 1
    fi

    JAR_NAME=$(basename "$LATEST_JAR")
    echo "==> Found: $JAR_NAME"

    SIDELOAD_DIR="$HOME/.runelite/sideloaded-plugins"
    mkdir -p "$SIDELOAD_DIR"

    PREFIX=$(printf '%s' "$JAR_NAME" | sed -E 's/-[0-9][0-9.]*(-(SNAPSHOT|RC[0-9]+|M[0-9]+))?\.jar$//')
    if [ "$PREFIX" = "$JAR_NAME" ]; then
        PREFIX="${JAR_NAME%.jar}"
    fi

    for f in "$SIDELOAD_DIR/$PREFIX"*.jar; do
        [ -f "$f" ] && rm "$f" && echo "   Removed old: $(basename "$f")"
    done

    cp "$LATEST_JAR" "$SIDELOAD_DIR/"
    echo "==> Installed $JAR_NAME"
fi

# Step 3: Launch RuneLite
echo "==> Launching RuneLite..."
java -jar "$SCRIPT_DIR/DevLauncher.jar"
