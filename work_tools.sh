#!/bin/bash
# Work Tools - All-in-One Activity Simulator & Wake Mode (Fixed)

set -euo pipefail

readonly VERSION="1.0"
readonly SCRIPT_NAME="work-tools"
readonly DEFAULT_INSTALL_DIR="$HOME/.local/bin"
readonly INSTALLED_FLAG="$HOME/.config/work-tools-installed"

# State files
readonly ACTIVITY_PID="/tmp/wt_activity.pid"
readonly WAKE_PID="/tmp/wt_wake.pid"
readonly TIMER_END="/tmp/wt_timer"
readonly LOG="/tmp/wt_activity.log"

# Colors
readonly G='\033[0;32m' Y='\033[1;33m' R='\033[0;31m' B='\033[0;34m' N='\033[0m'

# ============================================================================
# Installation Logic
# ============================================================================

is_installed() {
    local current_script="$(cd "$(dirname "$0")" && pwd)/$(basename "$0")"
    local installed_path="$DEFAULT_INSTALL_DIR/$SCRIPT_NAME"
    
    [ "$current_script" = "$installed_path" ] && return 0
    [ -f "$INSTALLED_FLAG" ] && [ -x "$installed_path" ] && return 0
    
    return 1
}

detect_shell_rc() {
    if [ -n "${ZSH_VERSION:-}" ]; then
        echo "$HOME/.zshrc"
    elif [ "$SHELL" = "/bin/zsh" ] || [ "$SHELL" = "/usr/bin/zsh" ]; then
        echo "$HOME/.zshrc"
    elif [ -f "$HOME/.zshrc" ]; then
        echo "$HOME/.zshrc"
    elif [ -f "$HOME/.bashrc" ]; then
        echo "$HOME/.bashrc"
    else
        echo "$HOME/.bash_profile"
    fi
}

install_self() {
    echo -e "${B}╔══════════════════════════════════════╗${N}"
    echo -e "${B}║    Work Tools Installer v${VERSION}       ║${N}"
    echo -e "${B}╚══════════════════════════════════════╝${N}\n"
    
    echo -e "${Y}Install directory (default: ${DEFAULT_INSTALL_DIR}):${N}"
    read -r INSTALL_DIR
    INSTALL_DIR=${INSTALL_DIR:-$DEFAULT_INSTALL_DIR}
    INSTALL_DIR="${INSTALL_DIR/#\~/$HOME}"
    
    mkdir -p "$INSTALL_DIR"
    mkdir -p "$(dirname "$INSTALLED_FLAG")"
    
    local target="$INSTALL_DIR/$SCRIPT_NAME"
    
    cp -f "$0" "$target"
    chmod +x "$target"
    echo -e "${G}✓${N} Installed to: $target"
    
    echo "$(date)" > "$INSTALLED_FLAG"
    
    local shell_rc=$(detect_shell_rc)
    echo -e "${Y}Shell config: $shell_rc${N}"
    
    if ! grep -q "export PATH=\"$INSTALL_DIR:\$PATH\"" "$shell_rc" 2>/dev/null; then
        echo "" >> "$shell_rc"
        echo "# Work Tools - $(date +%Y-%m-%d)" >> "$shell_rc"
        echo "export PATH=\"$INSTALL_DIR:\$PATH\"" >> "$shell_rc"
        echo -e "${G}✓${N} Added to PATH"
    else
        echo -e "${G}✓${N} PATH configured"
    fi
    
    if ! grep -q "alias work-start=" "$shell_rc" 2>/dev/null; then
        cat >> "$shell_rc" <<'EOF'

# Work Tools Aliases
alias work-start='work-tools as 480'
alias work-stop='work-tools stop'
alias work-status='work-tools st'
alias work-menu='work-tools menu'
alias wake-on='work-tools ws'
alias wake-off='work-tools wx'
alias wt='work-tools'
EOF
        echo -e "${G}✓${N} Added aliases"
    else
        echo -e "${G}✓${N} Aliases exist"
    fi
    
    echo -e "\n${Y}Install cliclick? (y/n):${N}"
    read -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]] && command -v brew >/dev/null 2>&1; then
        command -v cliclick >/dev/null 2>&1 || brew install cliclick
        echo -e "${G}✓${N} cliclick ready"
    fi
    
    echo -e "\n${G}╔══════════════════════════════════════╗${N}"
    echo -e "${G}║      Installation Complete!          ║${N}"
    echo -e "${G}╚══════════════════════════════════════╝${N}\n"
    echo -e "${Y}Run:${N} exec \$SHELL"
    echo -e "${Y}Test:${N} work-tools st\n"
    exit 0
}

# ============================================================================
# Core Utilities
# ============================================================================

log() { echo "[$(date '+%H:%M:%S')] $*" >> "$LOG"; }

fmt_time() {
    local total=$1
    local h=$((total/3600))
    local m=$(((total%3600)/60))
    local s=$((total%60))
    [ $h -gt 0 ] && printf "%dh %dm" $h $m || printf "%dm %ds" $m $s
}

activity_running() { [ -f "$ACTIVITY_PID" ] && kill -0 "$(cat "$ACTIVITY_PID" 2>/dev/null)" 2>/dev/null; }
wake_running() { [ -f "$WAKE_PID" ] && kill -0 "$(cat "$WAKE_PID" 2>/dev/null)" 2>/dev/null; }

# ============================================================================
# Activity Simulator
# ============================================================================

activity_daemon() {
    echo $$ > "$ACTIVITY_PID"
    log "Started ($$)"
    
    caffeinate -dimsu >/dev/null 2>&1 &
    
    while [ -f "$ACTIVITY_PID" ]; do
        case $((RANDOM % 10)) in
            0|1|2)
                local keys=(113 124 123 126 125)
                osascript -e "tell application \"System Events\" to key code ${keys[$RANDOM % ${#keys[@]}]}" 2>/dev/null
                log "Key"
                ;;
            3|4)
                command -v cliclick >/dev/null && cliclick "m:$((400+RANDOM%1200)),$((300+RANDOM%600))" 2>/dev/null && log "Mouse" || log "Key"
                ;;
            *)
                pbpaste | head -c1 >/dev/null 2>&1 && log "Clip"
                ;;
        esac
        
        sleep $((90 + RANDOM % 90)) & wait $!
    done
    
    log "Stopped"
    pkill -f "caffeinate -dimsu" 2>/dev/null || true
    rm -f "$ACTIVITY_PID"
}

start_activity() {
    local min=${1:-480}
    activity_running && { echo -e "${R}✗ Already running${N}"; return 1; }
    wake_running && { echo -e "${Y}Stopping wake...${N}"; stop_wake; }
    
    bash -c "$(declare -f log activity_daemon); ACTIVITY_PID='$ACTIVITY_PID'; LOG='$LOG'; activity_daemon" &
    sleep 2
    
    activity_running || { echo -e "${R}✗ Failed${N}"; return 1; }
    
    echo $(($(date +%s) + min * 60)) > "$TIMER_END"
    (while [ -f "$TIMER_END" ] && [ $(cat "$TIMER_END") -gt $(date +%s) ]; do sleep 30; done; \
     [ -f "$ACTIVITY_PID" ] && stop_activity && osascript -e 'display notification "Stopped" with title "Timer Expired"' 2>/dev/null) &
    
    echo -e "${G}✓ Activity started${N} (${min}m)"
}

stop_activity() {
    activity_running || { echo -e "${R}✗ Not running${N}"; return 1; }
    rm -f "$ACTIVITY_PID" "$TIMER_END"
    sleep 2
    echo -e "${G}✓ Stopped${N}"
}

# ============================================================================
# Wake Mode
# ============================================================================

start_wake() {
    local min=${1:-0}
    wake_running && { echo -e "${R}✗ Already active${N}"; return 1; }
    activity_running && { echo -e "${Y}Stopping activity...${N}"; stop_activity; }
    
    caffeinate -dimsu >/dev/null 2>&1 &
    echo $! > "$WAKE_PID"
    
    [ $min -gt 0 ] && { (sleep $((min * 60)); [ -f "$WAKE_PID" ] && stop_wake) & echo -e "${G}✓ Wake ON${N} (${min}m)"; } || echo -e "${G}✓ Wake ON${N} (∞)"
}

stop_wake() {
    wake_running || { echo -e "${R}✗ Not active${N}"; return 1; }
    kill "$(cat "$WAKE_PID")" 2>/dev/null; rm -f "$WAKE_PID"
    echo -e "${G}✓ Wake OFF${N}"
}

# ============================================================================
# Status & Menu
# ============================================================================

show_status() {
    echo -e "\n${B}═══ Status ═══${N}\n"
    
    if activity_running; then
        echo -e "${G}✓ Activity${N} ($(cat "$ACTIVITY_PID"))"
        [ -f "$TIMER_END" ] && { local r=$(($(cat "$TIMER_END")-$(date +%s))); [ $r -gt 0 ] && echo "  ⏱ $(fmt_time $r)"; }
        [ -f "$LOG" ] && echo "  $(tail -n1 "$LOG")"
    else
        echo -e "${R}✗ Activity${N}"
    fi
    
    wake_running && echo -e "${G}✓ Wake${N} ($(cat "$WAKE_PID"))" || echo -e "${R}✗ Wake${N}"
    echo ""
}

show_menu() {
    while true; do
        clear
        echo -e "${B}╔═══════════════════════════════════╗${N}"
        echo -e "${B}║      Work Tools v${VERSION}            ║${N}"
        echo -e "${B}╚═══════════════════════════════════╝${N}\n"
        echo -e "${Y}Activity:${N} 1)1h 2)2h 3)4h 4)8h 5)Custom 6)Stop"
        echo -e "${Y}Wake:${N} 7)1h 8)2h 9)∞ 0)Stop"
        echo -e "\ns)Status q)Quit\n"
        read -p "→ " -n 1 c
        echo -e "\n"
        
        case $c in
            1) start_activity 60 ;;
            2) start_activity 120 ;;
            3) start_activity 240 ;;
            4) start_activity 480 ;;
            5) read -p "Minutes: " m; start_activity $m ;;
            6) stop_activity ;;
            7) start_wake 60 ;;
            8) start_wake 120 ;;
            9) start_wake ;;
            0) stop_wake ;;
            s|S) show_status; read -p "↵ " ;;
            q|Q) exit 0 ;;
        esac
        sleep 1
    done
}

# ============================================================================
# Main
# ============================================================================

[ "${1:-}" = "install" ] && install_self

if ! is_installed; then
    echo -e "${R}✗ Not installed${N}"
    echo -e "Run: ${G}$0 install${N}"
    exit 1
fi

case "${1:-menu}" in
    as) start_activity ${2:-480} ;;
    ax) stop_activity ;;
    ws) start_wake ${2:-0} ;;
    wx) stop_wake ;;
    stop) stop_activity 2>/dev/null; stop_wake 2>/dev/null; echo -e "${G}✓ All stopped${N}" ;;
    st) show_status ;;
    menu|m|"") show_menu ;;
    *) echo -e "${Y}Usage:${N} work-tools {as|ax|ws|wx|stop|st|menu}" ;;
esac