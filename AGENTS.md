# AGENTS.md

This file orients agents working on **wt-herdr** itself. Read `CONTEXT.md` for plugin-specific invariants. Read git-wt's `docs/plugin-contract.md` for the host protocol; do not redefine it here.

## How to work here

- Keep code edits in `wt-herdr`; it is intentionally one Bash executable.
- Keep plugin metadata in `wt-plugin.json` in sync with implemented events.
- Add bats tests under `tests/` before changing event behavior.
- Run `bash -n wt-herdr`; run bats tests when `tests/` exists or when you add them.
- Never move plugin-contract details from git-wt into this repo.
- Never make worktree removal fail because herdr tab/workspace is already gone.

## Docs index

- `README.md` — user-facing install, behavior, requirements, limitations.
- `CONTEXT.md` — maintainer invariants, module map, seams, ADRs.
- `CHANGELOG.md` — release history.
- `wt-plugin.json` — manifest consumed by git-wt.
- git-wt `docs/plugin-contract.md` — source of truth for `git-wt.plugin.v0`.
- git-wt `docs/plugins.md` — plugin family comparison.

<!-- INDEX:START -->
<!-- Optional future agents-toc-managed index. -->
<!-- INDEX:END -->
