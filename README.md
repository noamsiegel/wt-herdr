# wt-herdr

Reference [git-wt](https://github.com/noamsiegel/git-wt) plugin for the [herdr](https://github.com/noamsiegel/herdr) terminal-tab manager.

`wt-herdr` does one thing: bridge git-wt worktree lifecycle events to herdr tabs. It implements `git-wt.plugin.v0`; the protocol source of truth is git-wt's [`docs/plugin-contract.md`](https://github.com/noamsiegel/git-wt/blob/main/docs/plugin-contract.md). Plugin-family comparison lives in git-wt's [`docs/plugins.md`](https://github.com/noamsiegel/git-wt/blob/main/docs/plugins.md).

## Install

```bash
brew install noamsiegel/tap/wt-herdr
wt plugin install herdr
```

Local development:

```bash
git clone https://github.com/noamsiegel/wt-herdr.git
wt plugin link ./wt-herdr
```

## Behavior

| git-wt event | herdr action |
|---|---|
| `wt:worktree-created` | Create workspace if absent, then create focused tab with worktree cwd. |
| `wt:worktree-removed` | Close matching herdr tab; missing workspace/tab is a no-op. |
| `wt:focus` | Focus matching herdr tab; missing tab returns `not-found`. |
| `wt:list` | Return empty successful result until git-wt specifies query response semantics. |

## Requirements

- `git-wt` with `git-wt.plugin.v0` support.
- `herdr` installed and server running.
- `yq` (mikefarah/yq Go binary) for JSON parsing.
- Bash 4 or newer.

## Commands

```bash
wt-herdr manifest
wt-herdr health
wt-herdr event wt:worktree-created < payload.json
```

`wt-herdr health` returns JSON and exits non-zero when `herdr`, herdr server, or `yq` is unavailable.

## Environment

No plugin-specific environment variables today. Configure herdr itself through herdr's own server/settings surface.

## What it doesn't do

- Does not define the git-wt plugin API; git-wt owns `git-wt.plugin.v0`.
- Does not install, update, or configure herdr.
- Does not manage git worktree naming, branch policy, or cleanup policy.
- Does not make `wt:list` authoritative; it returns an empty result until the host query contract exists.
- Does not fail worktree removal just because the matching tab was already closed.

## Development

```bash
bash -n wt-herdr
```

Add bats tests under `tests/` when changing event behavior.

## License

MIT. See [LICENSE](./LICENSE).
