# mac-caffeinate — Claude Context

Simple macOS utility scripts to prevent system sleep using the built-in `caffeinate` command.
Pure shell — no dependencies, no build step, no Python, no Node.

## Files
```
simple_caffeinate.sh   ← minimal caffeinate wrapper (enable/disable/status via PID file at /tmp/)
work_tools.sh          ← comprehensive work session tool (caffeinate + activity simulator + timer)
                          self-installs to ~/.local/bin/work-tools on first run
README.md
```

## Key Rules
- Pure bash — do not add Python, Node, or any external dependencies
- Scripts must work on macOS only (`caffeinate`, `osascript` — macOS built-ins)
- `simple_caffeinate.sh` must stay minimal — do not expand its scope
- `work_tools.sh` uses `set -euo pipefail` — preserve this; all new functions must be safe under it
- Test syntax before committing: `bash -n simple_caffeinate.sh && bash -n work_tools.sh`

## Common Usage
```bash
bash simple_caffeinate.sh enable    # prevent sleep
bash simple_caffeinate.sh disable   # re-enable sleep
bash simple_caffeinate.sh status    # check status

bash work_tools.sh                  # full interactive work session
# or after self-install: work-tools
```
