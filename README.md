# RuneLite Plugin Tester

Lets you start the official RuneLite client with custom start arguments (`--developer-mode`, etc.) without having to compile RuneLite from source in an IDE.

## How it works

The Jagex Launcher wraps RuneLite and doesn't expose command-line arguments. Normally you'd need to clone the RuneLite repo and run it from an IDE to pass flags like `--developer-mode`. `DevLauncher` loads the official client jars from `~/.runelite/repository2/` and starts the client with whatever arguments you want — no IDE required.

## Prerequisites

- JDK 11+ ([Adoptium](https://adoptium.net/))
- `RuneLite.jar` from [runelite.net](https://runelite.net) — place it in this directory

## Setup

### 1. Populate the repository

Run `RuneLite.jar` at least once. This downloads the client jars to `~/.runelite/repository2/` and creates the `sideloaded-plugins` directory.

### 2. Compile DevLauncher

**Windows:**
```
compile.bat
```

**Linux / Mac:**
```
chmod +x compile.sh
./compile.sh
```

This creates `DevLauncher.jar` in the current directory.

### 3. Build your plugin

```bash
cd your-plugin
./gradlew build
```

The plugin jar is at `build/libs/your-plugin.jar`.

### 4. Install the plugin

Copy the jar to the sideloaded plugins directory:

```
copy build\libs\your-plugin.jar %USERPROFILE%\.runelite\sideloaded-plugins\
```

### 5. Launch

```
java -jar DevLauncher.jar
```

The RuneLite client starts with developer mode enabled, and your plugin loads automatically.

## Jagex Accounts

If you use a Jagex account, see [Using Jagex Accounts](https://github.com/runelite/runelite/wiki/Using-Jagex-Accounts) for the required setup.

## Updating DevLauncher

Rebuild after updating `RuneLite.jar`:

```
compile.bat
```
