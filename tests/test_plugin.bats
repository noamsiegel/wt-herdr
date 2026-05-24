#!/usr/bin/env bats

setup() {
  export REPO_ROOT="$(cd "$BATS_TEST_DIRNAME/.." && pwd)"
  export WT_HERDR_LOG="$BATS_TEST_TMPDIR/herdr.log"
  export WT_HERDR_STATE="$BATS_TEST_TMPDIR/state.json"
  export WT_HERDR_BIN="$BATS_TEST_TMPDIR/herdr"
  export PATH="$BATS_TEST_TMPDIR:$PATH"

  : > "$WT_HERDR_LOG"
  printf '{"result":{"workspaces":[],"panes":[],"tabs":[]}}\n' > "$WT_HERDR_STATE"

  cat > "$WT_HERDR_BIN" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
log() { printf '%s\n' "$*" >> "$WT_HERDR_LOG"; }
state_json() { cat "$WT_HERDR_STATE"; }
write_state() { printf '%s\n' "$1" > "$WT_HERDR_STATE"; }
case "${1:-}" in
  status)
    log "status $*"
    printf 'status: running\n'
    ;;
  workspace)
    case "${2:-}" in
      list)
        log "workspace list $*"
        state_json
        ;;
      create)
        log "workspace create $*"
        write_state '{"result":{"workspaces":[{"workspace_id":"workspace:1","label":"demo"}],"panes":[],"tabs":[]}}'
        printf '{"ok":true}\n'
        ;;
      *)
        log "unknown $*"
        exit 64
        ;;
    esac
    ;;
  pane)
    case "${2:-}" in
      list)
        log "pane list $*"
        printf '{"result":{"panes":[]}}\n'
        ;;
      *)
        log "unknown $*"
        exit 64
        ;;
    esac
    ;;
  tab)
    case "${2:-}" in
      create)
        log "tab create $*"
        printf '{"ok":true}\n'
        ;;
      close|focus|list)
        log "tab $2 $*"
        printf '{"result":{"tabs":[]}}\n'
        ;;
      *)
        log "unknown $*"
        exit 64
        ;;
    esac
    ;;
  *)
    log "unknown $*"
    exit 64
    ;;
esac
EOF
  chmod +x "$WT_HERDR_BIN"
}

@test "manifest prints valid plugin manifest" {
  run "$REPO_ROOT/wt-herdr" manifest
  [ "$status" -eq 0 ]
  [ "$(printf '%s' "$output" | yq -p json -r '.name')" = "herdr" ]
  [ "$(printf '%s' "$output" | yq -p json -r '.executable')" = "wt-herdr" ]
  [ "$(printf '%s' "$output" | yq -p json -r '.api_versions[0]')" = "git-wt.plugin.v0" ]
  [ "$(printf '%s' "$output" | yq -p json -r '.version')" = "0.1.2" ]
}

@test "health reports JSON status and plugin version" {
  run "$REPO_ROOT/wt-herdr" health
  [ "$status" -eq 0 ]
  [[ "$(printf '%s' "$output" | yq -p json -r '.ok')" =~ ^(true|false)$ ]]
  [[ "$(printf '%s' "$output" | yq -p json -r '.version')" =~ ^0\.[0-9]+\.[0-9]+$ ]]
}

@test "worktree-created handles synthetic payload" {
  payload='{"repo":{"name":"demo"},"worktree":{"id":"ABC-1-test","path":"/tmp/demo/ABC-1-test","branch":"noam/ABC-1-test"}}'

  run bash -c 'printf "%s" "$1" | "$2/wt-herdr" event wt:worktree-created' _ "$payload" "$REPO_ROOT"

  [ "$status" -eq 0 ]
  [ "$(printf '%s' "$output" | yq -p json -r '.status')" = "ok" ]
}

@test "worktree-removed no-ops when no matching tab exists" {
  payload='{"repo":{"name":"demo"},"worktree":{"id":"ABC-1-test","path":"/tmp/demo/ABC-1-test"}}'

  run bash -c 'printf "%s" "$1" | "$2/wt-herdr" event wt:worktree-removed' _ "$payload" "$REPO_ROOT"

  [ "$status" -eq 0 ]
  [ "$(printf '%s' "$output" | yq -p json -r '.status')" = "noop" ]
}

@test "focus no-ops when no matching tab exists" {
  payload='{"repo":{"name":"demo"},"worktree":{"id":"ABC-1-test","path":"/tmp/demo/ABC-1-test"}}'

  run bash -c 'printf "%s" "$1" | "$2/wt-herdr" event wt:focus' _ "$payload" "$REPO_ROOT"

  [ "$status" -eq 0 ]
  [ "$(printf '%s' "$output" | yq -p json -r '.status')" = "noop" ]
}

@test "list event emits empty successful result" {
  payload='{"repo":{"name":"demo"},"worktrees":[]}'

  run bash -c 'printf "%s" "$1" | "$2/wt-herdr" event wt:list' _ "$payload" "$REPO_ROOT"

  [ "$status" -eq 0 ]
  [ "$(printf '%s' "$output" | yq -p json -r '.status')" = "ok" ]
  [ "$(printf '%s' "$output" | yq -p json -r '.worktrees | length')" = "0" ]
}

@test "bash syntax is clean" {
  run bash -n "$REPO_ROOT/wt-herdr"
  [ "$status" -eq 0 ]
}
