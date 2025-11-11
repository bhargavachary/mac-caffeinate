# Mac Automation Scripts

Two scripts for different use cases:

1. **`simple_caffeinate.sh`** - Just prevent system sleep (recommended)
2. **`work_tools.sh`** - Advanced activity simulator & wake mode with installation

---

## Simple Caffeinate (Recommended)

### Features

- Works on both AC power and battery
- Zero system interference
- No disk wear or resource waste
- Official macOS solution

### Usage

Make script executable (first time only):

```bash
chmod +x simple_caffeinate.sh
```

### Enable caffeinate mode

```bash
./simple_caffeinate.sh enable
```

Prevents system from sleeping until disabled.

### Disable caffeinate mode

```bash
./simple_caffeinate.sh disable
```

Returns system to normal sleep behavior.

### Check status

```bash
./simple_caffeinate.sh status
```

Shows if caffeinate mode is currently active.

## Examples

```bash
# Start preventing sleep
./simple_caffeinate.sh enable
# Output: Caffeinate mode enabled (PID: 12345)

# Check if it's running
./simple_caffeinate.sh status
# Output: Caffeinate mode is active (PID: 12345)

# Stop preventing sleep
./simple_caffeinate.sh disable
# Output: Caffeinate mode disabled

# Check status again
./simple_caffeinate.sh status
# Output: Caffeinate mode is inactive
```

### What it prevents

- Display sleep
- System idle sleep
- System sleep on AC power
- System sleep on battery power
- Disk idle sleep

### Notes

- Uses macOS built-in `caffeinate` command
- Safe and official Apple solution
- Apps will still show you as "away" (honest approach)
- Process automatically cleaned up on disable

---

## Work Tools (Advanced)

> **⚠️ Use with caution - simulates fake user activity**

### Key Features

- All-in-one activity simulator and wake mode
- Interactive menu interface
- Timer-based operation
- Installation script with aliases
- Prevents system sleep AND fools apps
- Minimal mouse movement and safe key presses
- System activity simulation
- Apps will think you're active

### Installation

Run the installer:

```bash
./work_tools.sh install
```

This will:

- Copy script to `~/.local/bin/work-tools`
- Add to PATH in your shell config
- Create useful aliases
- Optionally install cliclick for better mouse control

After installation, restart your shell:

```bash
exec $SHELL
```

### Basic Usage

#### Interactive Menu

```bash
work-tools menu
# or just
work-tools
```

#### Command Line

```bash
# Activity simulation (default 8 hours)
work-tools as [minutes]

# Stop activity
work-tools ax

# Wake mode (infinite by default)
work-tools ws [minutes]

# Stop wake
work-tools wx

# Stop all
work-tools stop

# Status
work-tools st
```

#### Aliases (after installation)

```bash
work-start    # Start 8h activity
work-stop     # Stop all
work-status   # Show status
work-menu     # Interactive menu
wake-on       # Wake mode on
wake-off      # Wake mode off
wt            # Short alias
```

### Usage Examples

```bash
# Install first
./work_tools.sh install

# Start 4 hour activity simulation
work-tools as 240

# Check status
work-tools st
# Output:
# ═══ Status ═══
#
# ✓ Activity (12345)
#   ⏱ 3h 58m
#   [14:32:15] Mouse
#
# ✗ Wake

# Start wake mode for 2 hours
work-tools ws 120

# Stop everything
work-tools stop
```

### What it simulates

- Mouse movement (random positions, requires cliclick)
- Arrow key presses (safe navigation keys)
- Clipboard access (creates system activity)
- Prevents all sleep modes

### Safety measures

- Uses safe keys (arrow keys, F15)
- Minimal mouse movement
- Graceful error handling
- Clean process management
- Timer auto-stop with notifications

### Important Notes

- More resource usage than simple caffeinate
- May interfere with precision tasks
- Some security software may detect this
- Use responsibly and within company policies