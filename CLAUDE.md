# mac-caffeinate — Claude Context

Simple macOS utility scripts to prevent system sleep using the built-in `caffeinate` command.
Pure shell — no dependencies, no build step.

## Files
```
simple_caffeinate.sh   ← minimal caffeinate wrapper
work_tools.sh          ← comprehensive work tools (caffeinate + extras)
README.md
```

## Key Rules
- Pure bash/zsh — do not add Python, Node, or any external dependencies
- Scripts must work on macOS only (use `caffeinate`, `osascript` — macOS built-ins)
- Keep it simple — this is a small utility, do not over-engineer
- Test any changes with `bash -n script.sh` before committing (syntax check)

## Common Usage
```bash
bash simple_caffeinate.sh      # keep awake
bash work_tools.sh             # full work session tools
```
