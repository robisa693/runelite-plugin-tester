# RuneLite Plugin Tester

Lightweight bootstrap launcher for testing sideloaded RuneLite plugins during development.

## How it works

`DevLauncher` loads RuneLite's own client jars from `~/.runelite/repository2/`, then starts the RuneLite client with `--developer-mode`. This lets you test plugins without going through the Jagex Launcher.

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

## Updating DevLauncher

Rebuild after updating `RuneLite.jar`:

```
compile.bat
```
