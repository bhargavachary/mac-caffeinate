#!/bin/bash

# Activity Simulator Script
# Simulates user activity to fool apps while preventing system sleep
# Uses safe, minimal input simulation

PIDFILE="/tmp/activity_simulator.pid"
ACTIVITY_INTERVAL=30  # seconds between activities

simulate_activity() {
    # Method 1: Safe mouse movement using cliclick (if available)
    if command -v cliclick &> /dev/null; then
        # Get current mouse position
        CURRENT_POS=$(cliclick p)
        X=$(echo $CURRENT_POS | cut -d, -f1)
        Y=$(echo $CURRENT_POS | cut -d, -f2)

        # Move mouse 1 pixel and back
        cliclick m:$((X+1)),$Y
        sleep 0.1
        cliclick m:$X,$Y
    else
        # Fallback: Use osascript for mouse movement
        osascript -e "
        tell application \"System Events\"
            set currentLoc to mouseLocation
            set x to item 1 of currentLoc
            set y to item 2 of currentLoc
            set mouseLocation to {x + 1, y}
            delay 0.1
            set mouseLocation to {x, y}
        end tell" 2>/dev/null || true
    fi

    # Method 2: Simulate a safe key press (F15 key - rarely used)
    osascript -e "
    tell application \"System Events\"
        key code 113  -- F15 key
    end tell" 2>/dev/null || true

    # Method 3: Create app-detectable activity by checking clipboard
    # This creates system calls that apps might detect as activity
    pbpaste | head -c 1 > /dev/null 2>&1 || true
}

activity_loop() {
    echo "Starting activity simulation (PID: $$)"
    while [ -f "$PIDFILE" ]; do
        simulate_activity
        sleep $ACTIVITY_INTERVAL
    done
    echo "Activity simulation stopped"
}

case "$1" in
    enable)
        if [ -f "$PIDFILE" ]; then
            echo "Activity simulator already running"
            exit 1
        fi

        echo "Starting activity simulator..."
        echo $$ > "$PIDFILE"

        # Also start caffeinate to prevent sleep
        caffeinate -dimsu &
        echo $! > "/tmp/caffeinate_activity.pid"

        echo "Activity simulator enabled (simulating activity every ${ACTIVITY_INTERVAL}s)"

        # Run activity loop
        activity_loop
        ;;

    disable)
        if [ ! -f "$PIDFILE" ]; then
            echo "Activity simulator not running"
            exit 1
        fi

        echo "Stopping activity simulator..."
        rm -f "$PIDFILE"

        # Stop caffeinate too
        if [ -f "/tmp/caffeinate_activity.pid" ]; then
            CAFF_PID=$(cat "/tmp/caffeinate_activity.pid")
            kill "$CAFF_PID" 2>/dev/null || true
            rm -f "/tmp/caffeinate_activity.pid"
        fi

        echo "Activity simulator disabled"
        ;;

    status)
        if [ -f "$PIDFILE" ]; then
            PID=$(cat "$PIDFILE")
            if kill -0 "$PID" 2>/dev/null; then
                echo "Activity simulator is running (PID: $PID)"
                if [ -f "/tmp/caffeinate_activity.pid" ]; then
                    CAFF_PID=$(cat "/tmp/caffeinate_activity.pid")
                    if kill -0 "$CAFF_PID" 2>/dev/null; then
                        echo "Caffeinate is also active (PID: $CAFF_PID)"
                    fi
                fi
            else
                echo "Activity simulator is stopped (stale PID file)"
                rm -f "$PIDFILE"
            fi
        else
            echo "Activity simulator is not running"
        fi
        ;;

    install-cliclick)
        echo "Installing cliclick for better mouse control..."
        if command -v brew &> /dev/null; then
            brew install cliclick
            echo "cliclick installed successfully"
        else
            echo "Homebrew not found. Install it first:"
            echo '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
        fi
        ;;

    *)
        echo "Usage: $0 {enable|disable|status|install-cliclick}"
        echo ""
        echo "Commands:"
        echo "  enable           - Start activity simulation"
        echo "  disable          - Stop activity simulation"
        echo "  status           - Check current status"
        echo "  install-cliclick - Install cliclick for better mouse control"
        echo ""
        echo "Activity simulation includes:"
        echo "  - Minimal mouse movement (1 pixel)"
        echo "  - F15 key press (safe, rarely used)"
        echo "  - System clipboard access"
        echo "  - Prevents system sleep"
        exit 1
        ;;
esac