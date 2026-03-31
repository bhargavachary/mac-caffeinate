# AGENTS.md — mac-caffeinate

Simple macOS utility to prevent system sleep using the built-in `caffeinate` command.
**Pure bash — zero dependencies, no build step, no Python, no Node.**

---

## Files

```
simple_caffeinate.sh   ← minimal caffeinate wrapper (enable/disable/status via PID at /tmp/)
work_tools.sh          ← comprehensive work session tool (caffeinate + activity simulator + timer)
                          self-installs to ~/.local/bin/work-tools on first run
README.md
```

---

## Commands

```bash
bash simple_caffeinate.sh enable    # prevent sleep
bash simple_caffeinate.sh disable   # re-enable sleep
bash simple_caffeinate.sh status    # check status

bash work_tools.sh                  # full interactive work session
work-tools                          # after self-install
```

---

## Rules

- **Pure bash only** — do not add Python, Node, or any external dependencies
- macOS-only scripts (`caffeinate`, `osascript`) — do not attempt cross-platform porting
- `simple_caffeinate.sh` must stay **minimal** — do not expand its scope
- `work_tools.sh` uses `set -euo pipefail` — all new functions must be safe under it
- Validate syntax before committing: `bash -n simple_caffeinate.sh && bash -n work_tools.sh`
- No API keys, no credentials — this is a public utility

---

## Owner

**D K Bhargav Achary** — sole maintainer.
