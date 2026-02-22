# Copilot Instructions — mac-caffeinate

Pure bash macOS utility scripts wrapping the built-in `caffeinate` command.

## Rules
- Pure bash only — no Python, no Node, no external dependencies
- macOS-only — use `caffeinate`, `osascript`, and macOS built-ins
- `simple_caffeinate.sh` must stay minimal — do not expand its scope
- `work_tools.sh` uses `set -euo pipefail` — all new code must be safe under strict mode
- Quote all variables: `"$var"` not `$var`
- Test syntax with `bash -n script.sh` before suggesting changes

## Style
- Lowercase local variables, UPPERCASE for env/constants
- `#!/usr/bin/env bash` shebang on all scripts
