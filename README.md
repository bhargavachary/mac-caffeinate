# Mac Automation Scripts

Two scripts for different use cases:

1. **`simple_caffeinate.sh`** - Just prevent system sleep (recommended)
2. **`activity_simulator.sh`** - Simulate user activity to fool apps

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

## Activity Simulator (Advanced)

**⚠️ Use with caution - simulates fake user activity**

### Features
- Prevents system sleep AND fools apps
- Minimal mouse movement (1 pixel)
- Safe key press (F15 - rarely used)
- System activity simulation
- Apps will think you're active

### Usage

Make script executable (first time only):
```bash
chmod +x activity_simulator.sh
```

#### Enable activity simulation
```bash
./activity_simulator.sh enable
```
Starts simulating user activity every 30 seconds.

#### Disable activity simulation
```bash
./activity_simulator.sh disable
```
Stops all simulation and allows normal sleep.

#### Check status
```bash
./activity_simulator.sh status
```
Shows if activity simulation is running.

#### Install better mouse control (optional)
```bash
./activity_simulator.sh install-cliclick
```
Installs cliclick for more precise mouse control.

### Examples

```bash
# Start fooling apps
./activity_simulator.sh enable
# Output: Starting activity simulator...
#         Activity simulator enabled (simulating activity every 30s)

# Check if it's running
./activity_simulator.sh status
# Output: Activity simulator is running (PID: 12345)
#         Caffeinate is also active (PID: 12346)

# Stop simulation
./activity_simulator.sh disable
# Output: Activity simulator disabled
```

### What it simulates
- Mouse movement (1 pixel, returns to original position)
- F15 key press (safe, non-functional key)
- Clipboard access (creates system activity)
- Prevents all sleep modes

### Safety measures
- Uses F15 key (rarely mapped to functions)
- Minimal mouse movement that's barely noticeable
- Graceful error handling
- Clean process management

### Notes
- More resource usage than simple caffeinate
- May interfere with precision tasks
- Some security software may detect this
- Use responsibly and within company policies