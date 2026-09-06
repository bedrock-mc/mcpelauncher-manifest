# mcpelauncher-client (bedrock-mc fork) — Linux x86_64

The game client only. It contains no Minecraft game code and needs a game installed by the upstream
launcher UI (AppImage, Flatpak or deb) — or an APK extracted with `mcpelauncher-extract` — plus a signed-in
data dir. Built on Ubuntu 22.04, so it runs on 22.04 and newer.

## Runtime packages (Debian/Ubuntu names)

`libssl3 libpng16-16 libzip4 libx11-6 libxi6 libudev1 libevdev2 libegl1 libgles2 libasound2 libpulse0`

## Use

- **Replace the client of an installed launcher:** the deb installs `/usr/bin/mcpelauncher-client`; swap it
  (keep the original). AppImage and Flatpak bundles are read-only — run this binary directly instead.
- **Run directly / headless:** `mcpelauncher-client -dg <game dir> -dd <data dir> --agent-socket <path>
  --fps-cap 10 -ww 640 -wh 360`, under `xvfb-run -a` on a machine without a display (Mesa llvmpipe renders
  it on the CPU; keep the resolution small). `--hidden` is a no-op with the default EGLUT window backend.

## What this build adds

- `--agent-socket <path>` — line-delimited JSON control socket: input injection, PNG frame capture,
  `minecraft:` URIs, state, fps cap, quit. Driven by
  [mcpelauncher-agent](https://github.com/bedrock-mc/mcpelauncher-agent) (MCP server).
- `--fps-cap N` and the `unfocused_fps_cap` setting.
- HTTP shim: 10 s connect / 30 s stall timeouts (the stock launcher had none — one unreachable Xbox
  endpoint stalled sign-in or a server join for ~2 minutes on Linux) and a shared curl handle for
  connection/TLS reuse. `MCPELAUNCHER_HTTP_TIMING=1` logs every request.
- A 30 s watchdog for the quit path that could spin a core forever.

Source: <https://github.com/bedrock-mc/mcpelauncher-manifest> (branch `agent`). GPL-3.0.
