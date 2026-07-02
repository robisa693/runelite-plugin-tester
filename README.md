# RuneLite Plugin Tester

Lets you start the official RuneLite client with custom start arguments (`--developer-mode`, etc.) without having to compile RuneLite from source in an IDE.

## How it works

The Jagex Launcher wraps RuneLite and doesn't expose command-line arguments. Normally you'd need to clone the RuneLite repo and run it from an IDE to pass flags like `--developer-mode`. `DevLauncher` loads the official client jars from `~/.runelite/repository2/` and starts the client with whatever arguments you want — no IDE required.

> Only tested on Windows.

## Prerequisites

- JDK 11+ ([Adoptium](https://adoptium.net/))

## Jagex Accounts

If you use a Jagex account, see [Using Jagex Accounts](https://github.com/runelite/runelite/wiki/Using-Jagex-Accounts) for the required setup.

## Setup

### 1. Populate the repository

Run RuneLite at least once (however you normally launch it — standalone launcher or Jagex Launcher). This downloads the client jars to `~/.runelite/repository2/` and creates the `sideloaded-plugins` directory.

### 2. One-command start (build + install + launch)

If you have a plugin repo checked out locally, this does everything in one step:

**Windows:**
```
start.bat C:\path\to\your-plugin
```

**Linux / Mac:**
```
./start.sh /path/to/your-plugin
```

This compiles DevLauncher, runs `./gradlew build` in the plugin repo, copies the latest jar to `~/.runelite/sideloaded-plugins/` (removing stale versions), and launches RuneLite with `--developer-mode`.

Run without arguments to skip the plugin build and just launch RuneLite:
```
start.bat
./start.sh
```

### 3. Manual steps (optional)

If you prefer to do each step separately:

**Compile DevLauncher:**
```
compile.bat
```
```
chmod +x compile.sh && ./compile.sh
```

**Build your plugin** (standard Gradle Java project):
```bash
cd your-plugin
./gradlew build
```

The jar is at `build/libs/your-plugin-*.jar`.

**Install:**
```batch
copy "build\libs\your-plugin.jar" "%USERPROFILE%\.runelite\sideloaded-plugins\"
```

**Launch:**
```
java -jar DevLauncher.jar
```

## Updating DevLauncher

Rebuild after modifying `DevLauncher.java`:

```
compile.bat
```
```
./compile.sh
```

Or use the start scripts which always recompile DevLauncher on each run.
