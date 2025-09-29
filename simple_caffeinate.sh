#!/bin/bash

# Simple Caffeinate Script using built-in macOS caffeinate command
# This is the cleanest, safest approach

PIDFILE="/tmp/simple_caffeinate.pid"

case "$1" in
    enable)
        if [ -f "$PIDFILE" ]; then
            echo "Caffeinate mode already enabled"
            exit 1
        fi

        echo "Enabling caffeinate mode..."
        # -d: prevent display from sleeping
        # -i: prevent system from idle sleeping
        # -s: prevent system from sleeping (AC power)
        # -m: prevent disk from idle sleeping
        # -u: prevent system from sleeping (also works on battery)
        caffeinate -dimsu &
        echo $! > "$PIDFILE"
        echo "Caffeinate mode enabled (PID: $(cat $PIDFILE))"
        ;;

    disable)
        if [ ! -f "$PIDFILE" ]; then
            echo "Caffeinate mode not running"
            exit 1
        fi

        PID=$(cat "$PIDFILE")
        echo "Disabling caffeinate mode (PID: $PID)..."
        kill "$PID" 2>/dev/null
        rm -f "$PIDFILE"
        echo "Caffeinate mode disabled"
        ;;

    status)
        if [ -f "$PIDFILE" ]; then
            PID=$(cat "$PIDFILE")
            if kill -0 "$PID" 2>/dev/null; then
                echo "Caffeinate mode is active (PID: $PID)"
            else
                echo "Caffeinate mode is inactive (stale PID file)"
                rm -f "$PIDFILE"
            fi
        else
            echo "Caffeinate mode is inactive"
        fi
        ;;

    *)
        echo "Usage: $0 {enable|disable|status}"
        echo "  enable  - Prevent system from sleeping"
        echo "  disable - Allow system to sleep normally"
        echo "  status  - Check current status"
        exit 1
        ;;
esac