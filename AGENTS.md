# bedrock-mc/mcpelauncher-manifest — agent guidelines

This is the bedrock-mc fork of minecraft-linux/mcpelauncher-manifest. Work here, not upstream.

- Branch `agent` (default) is the integration branch. Submodules `mcpelauncher-client`, `game-window` and
  `libc-shim` track the `agent` branch of the bedrock-mc forks; every other submodule tracks the upstream pin.
- Never re-point those three submodules at minecraft-linux. Pull upstream deliberately: in the submodule,
  `git remote add upstream https://github.com/minecraft-linux/<repo>`, merge `upstream/<default branch>` into
  `agent`, push to bedrock-mc, then bump the pointer here.
- Fixes worth upstreaming go out as PRs from the personal fork (HashimTheArab/<repo>), never by pushing to
  minecraft-linux. Sent so far: mcpelauncher-client#150 (quit watchdog), libc-shim#58 (Darwin condvar clock).
- The scheduled upstream `branch_sync` workflow was removed and Actions are disabled on the forks on purpose.
- macOS build + install: `scripts/build-macos-client.sh --install` replaces only the client binary inside an
  installed "Minecraft Bedrock Launcher.app" (original kept as `.orig`). Accepting the launcher UI's update
  banner reinstalls the stock client — rerun the script afterwards.
- Fork features: `mcpelauncher-client` has `--agent-socket`, `--fps-cap`, `--hidden`, the `unfocused_fps_cap`
  setting and a 30 s quit watchdog; `libc-shim` honors monotonic condvar deadlines on Darwin; `game-window`
  has `hide()`/`isFocused()`. The MCP server that drives the socket is bedrock-mc/mcpelauncher-agent.
