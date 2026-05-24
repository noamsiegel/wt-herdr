# Changelog

## [0.1.1] — 2026-05-24

### Added
- Bats test suite for parity with wt-zed and wt-cmux.
- `CONTEXT.md` and `AGENTS.md` for plugin-specific invariants and agent orientation.
- Manifest-derived `version` field included in `health` JSON output.

### Fixed
- `event wt:focus` now returns exit 0 with `noop` JSON when no matching tab exists (was incorrectly returning exit 20).

### Changed
- Slimmed `README.md` to plugin-specific behavior; links to `git-wt/docs/plugin-contract.md` and `git-wt/docs/plugins.md`.
- Migrated manifest to plural `api_versions` shape so git-wt v0.9.0 no longer emits the singular `api_version` deprecation warning.

## [0.1.0] — initial release

### Added
- Plugin manifest declaring four lifecycle events.
- Event handlers for `wt:worktree-created`, `wt:worktree-removed`, `wt:focus`.
- `manifest` and `health` meta-commands.
- README + plugin contract docs.

### Notes
- Extracted from git-wt v0.3.x's bundled herdr code into a stand-alone plugin per the v0 contract.
- git-wt v0.4.0 removes the bundled herdr code; users now install this plugin separately.
