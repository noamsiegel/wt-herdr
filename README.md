# wt-herdr

> Reference herdr plugin for [git-wt](https://github.com/noamsiegel/git-wt).

Implements the `git-wt.plugin.v0` contract for the
[herdr](https://github.com/noamsiegel/herdr) terminal-tab manager. When
git-wt creates, removes, focuses, or lists worktrees, this plugin creates,
closes, or focuses the matching herdr tabs.

## Install

```bash
brew install noamsiegel/tap/wt-herdr
wt plugin install herdr
```

Or for local development:

```bash
git clone https://github.com/noamsiegel/wt-herdr.git
wt plugin link ./wt-herdr
```

## What it does

Subscribes to git-wt's four lifecycle events:

| Event | Action |
|---|---|
| `wt:worktree-created` | `herdr workspace create` (if absent) + `herdr tab create --cwd <worktree>` |
| `wt:worktree-removed` | `herdr tab close <tab_id>` (no-op if no tab) |
| `wt:focus` | `herdr tab focus <tab_id>` |
| `wt:list` | (no-op in v0.1.0; returns empty result) |

## Requirements

- `herdr` (the terminal-tab manager) installed and the server running
- `yq` (mikefarah/yq, the Go binary) for parsing herdr's JSON output
- `bash >= 4`

## Plugin contract

Implements `git-wt.plugin.v0`. The CLI accepts three subcommands:

```bash
wt-herdr manifest             # prints wt-plugin.json
wt-herdr health               # checks herdr install + server reachability
wt-herdr event <name> < json  # handles one event
```

git-wt's core invokes `wt-herdr event <name>` with JSON on stdin. See the
[git-wt plugin docs](https://github.com/noamsiegel/git-wt#plugins) for the
full contract.

## Health check

```bash
wt-herdr health
# {"ok":true,"herdr":"...","yq":"..."}
```

Returns non-zero exit when herdr isn't installed, the server isn't running,
or yq is missing.

## History

This plugin is the **reference implementation** that came out of extracting
herdr-specific code from git-wt core in v0.4.0. Other terminal-tab plugins
(`wt-tmux`, `wt-kitty`, `wt-wezterm`, etc.) can be written against the same
contract.

## License

MIT. See [LICENSE](./LICENSE).
