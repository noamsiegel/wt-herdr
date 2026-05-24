# wt-herdr CONTEXT

Architecture context for agents working on `wt-herdr` itself. User-facing docs live in `README.md`; the plugin protocol lives in git-wt's `docs/plugin-contract.md`.

## Load-bearing invariants

1. **git-wt owns the contract**: this repo implements `git-wt.plugin.v0`; it does not define manifest schema, event vocabulary, or validation rules. See `wt-plugin.json` and `wt-herdr` (`cmd_manifest`, `cmd_event`).
2. **Manifest and executable stay in lockstep**: `wt-plugin.json` names `herdr`, executable `wt-herdr`, events `wt:worktree-created`, `wt:worktree-removed`, `wt:focus`, and `wt:list`; the script must keep matching handlers for those events.
3. **Health is JSON and dependency-focused**: `wt-herdr health` reports herdr server reachability and `yq`; callers should not need to parse human text.
4. **Missing herdr tab is not fatal on remove**: removed worktree cleanup returns `noop` when workspace or tab is absent. Reaping a worktree must not fail because terminal UI was already closed.
5. **`wt:list` remains explicitly empty until query shape is specified**: `handle_list` returns an empty successful result so git-wt can fall back to plain listing.

## Module map

```
wt-herdr          bash executable: subcommands, JSON parsing, herdr calls, event handlers
wt-plugin.json   plugin manifest consumed by git-wt
tests/           absent today; add bats tests here when behavior changes
README.md        user-facing behavior, requirements, env vars, limitations
CHANGELOG.md     release notes
```

## Real seams

- Event handlers are the real seams: created, removed, focus, and list each map one git-wt event to one herdr behavior.
- herdr CLI calls are isolated enough by function names (`herdr_ensure_ws`, `herdr_pane_for_cwd`, `herdr_close_tab`) to test with PATH stubs when tests are added.

## Hypothetical seams

- Do not extract a shared shell plugin framework here. Three plugins duplicate a tiny `manifest`/`health`/`event` shell; the contract is still settling and the duplication is cheaper than a shared runtime dependency.
- Do not move protocol documentation into this repo. git-wt is the host and contract authority.

## Public API stability

No library API. The public surface is the executable CLI (`manifest`, `health`, `event <name>`) plus `wt-plugin.json`. Breaking changes require a plugin release and matching git-wt compatibility note.

## ADRs

ADR-001 — herdr plugin as reference implementation: herdr-specific code was extracted from git-wt core so UI/tab integrations stay out of process.

ADR-002 — keep `wt:list` non-authoritative: until git-wt specifies query response semantics, this plugin returns an empty successful list rather than inventing a contract.
