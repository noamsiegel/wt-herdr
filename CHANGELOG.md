# Changelog

## [0.1.0] — initial release

### Added
- Plugin manifest declaring four lifecycle events.
- Event handlers for `wt:worktree-created`, `wt:worktree-removed`, `wt:focus`.
- `manifest` and `health` meta-commands.
- README + plugin contract docs.

### Notes
- Extracted from git-wt v0.3.x's bundled herdr code into a stand-alone plugin per the v0 contract.
- git-wt v0.4.0 removes the bundled herdr code; users now install this plugin separately.
