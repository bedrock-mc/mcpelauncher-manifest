# mcpelauncher-client (bedrock-mc fork) — macOS arm64

Drop-in replacement for the client binary inside an installed **Minecraft Bedrock Launcher.app**. It contains
no Minecraft game code; the launcher UI downloads the game itself, exactly as upstream does.

## Install

```sh
APP="/Applications/Minecraft Bedrock Launcher.app/Contents/MacOS"
cp -p "$APP/mcpelauncher-client-arm64-v8a" "$APP/mcpelauncher-client-arm64-v8a.orig"   # keep the stock one
cp mcpelauncher-client-arm64-v8a "$APP/"
codesign --force --sign - "$APP/mcpelauncher-client-arm64-v8a"
```

Accepting the launcher's own update banner restores the stock client — reinstall afterwards.

## What this build adds

- `--agent-socket <path>` — line-delimited JSON control socket: keyboard/mouse/text input, PNG frame capture,
  `minecraft:` URIs, window state, fps cap, quit. Driven by
  [mcpelauncher-agent](https://github.com/bedrock-mc/mcpelauncher-agent) (MCP server).
- `--fps-cap N` and the `unfocused_fps_cap` setting (default 15) — bound the render rate; the game ticks
  independently, so this is a pure CPU/GPU saving.
- `--hidden` — start with the window hidden (it still renders, so captures work).
- Two macOS fixes: a 30 s watchdog for the quit path that could spin a core forever
  ([client#150](https://github.com/minecraft-linux/mcpelauncher-client/pull/150)), and monotonic condvar
  deadlines in libc-shim, worth ~100% → 3–4% CPU at the main menu
  ([libc-shim#58](https://github.com/minecraft-linux/libc-shim/pull/58)).

Source: <https://github.com/bedrock-mc/mcpelauncher-manifest> (branch `agent`). GPL-3.0.
