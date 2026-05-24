# Releasing wt-herdr

1. Pick `vX.Y.Z` and confirm release inputs:
   ```bash
   bats tests/test_plugin.bats
   bash -n wt-herdr
   git status --short
   ```
   Expected: 7 bats tests pass, shell syntax is clean, and status is empty except intentional release edits.
2. Bump `version` in `wt-plugin.json` (single source of truth; wt-herdr intentionally has no script-level `VERSION`).
3. Prepend a `## [vX.Y.Z] — YYYY-MM-DD` entry to `CHANGELOG.md`; keep sections short and user-facing.
4. Commit, tag, and push in this order:
   ```bash
   git add -A
   git commit -m "Release vX.Y.Z"
   git tag -a vX.Y.Z -m "vX.Y.Z"
   git push origin main
   git push origin vX.Y.Z
   ```
5. Create GitHub release after both pushes succeed:
   ```bash
   gh release create vX.Y.Z --notes "..."
   ```
6. Optional registry update: if adding or changing git-wt's `plugins-registry.json`, edit that file in the `git-wt` repo and cut a git-wt patch release.
7. Smoke install from GitHub through git-wt:
   ```bash
   wt plugin install noamsiegel/wt-herdr --force
   wt plugin validate ~/.local/share/git-wt/plugins/wt-herdr
   ```
8. No brew formula: wt-* plugins install through `wt plugin install`, not Homebrew. Plugins target the git-wt plugin registry, not user `PATH`.

## Recovery

- Push failed before tag push: fix the push failure, verify `git status --short`, then push `main` before `vX.Y.Z`.
- Tag misaligned: compare local and remote tag targets, delete the wrong remote tag, recreate/push the annotated tag from the release commit, then create the GitHub release.
- Stale shim blocks git operations: from this repo, run `ai-git-guardrails install --force` to refresh hooks, then retry the release step.
- Plugin manifest validation fails: run `wt plugin validate ~/.local/share/git-wt/plugins/wt-herdr`; common causes are missing `api_versions`, missing `executable`, or malformed JSON.
- GitHub release created against wrong tag: delete the release, repair the tag, push the corrected tag, then rerun `gh release create`.
