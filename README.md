# Mac Caffeinate Mode

Simple script to prevent Mac from sleeping using the built-in `caffeinate` command.

## Features
- Works on both AC power and battery
- Zero system interference
- No disk wear or resource waste
- Official macOS solution

## Usage

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

## What it prevents
- Display sleep
- System idle sleep
- System sleep on AC power
- System sleep on battery power
- Disk idle sleep

## Notes
- Uses macOS built-in `caffeinate` command
- Safe and official Apple solution
- No custom input simulation or system modifications
- Process automatically cleaned up on disable