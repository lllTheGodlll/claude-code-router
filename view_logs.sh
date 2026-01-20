#!/bin/bash

# Quick Log Viewer for Claude Code Router
# Provides easy access to logs from project directory

LOG_DIR="./logs"
CC_LOG_DIR="$HOME/.claude-code-router/logs"

echo "=== Claude Code Router Quick Log Viewer ==="
echo ""

# Check if the symbolic link exists
if [ ! -d "$LOG_DIR" ]; then
    echo "Error: Log directory not found!"
    echo "Make sure the symbolic link exists or Claude Code Router is running."
    echo "Expected location: $LOG_DIR"
    exit 1
fi

# Function to list recent logs
list_logs() {
    echo "Recent log files:"
    ls -lat $LOG_DIR/ccr-*.log 2>/dev/null | head -10
    echo ""
}

# Function to show recent provider usage
show_recent_providers() {
    local latest_log=$(ls -t $LOG_DIR/ccr-*.log 2>/dev/null | head -n 1)
    if [ -n "$latest_log" ]; then
        echo "Recent providers used (last 20 entries):"
        grep -o "provider([^)]*)" "$latest_log" 2>/dev/null | tail -20 | sort | uniq -c | sort -nr
        echo ""
    else
        echo "No log files found."
    fi
}

# Function to show recent requests
show_recent_requests() {
    local latest_log=$(ls -t $LOG_DIR/ccr-*.log 2>/dev/null | head -n 1)
    if [ -n "$latest_log" ]; then
        echo "Recent requests (last 10):"
        grep "incoming request" "$latest_log" 2>/dev/null | tail -10
        echo ""
    else
        echo "No log files found."
    fi
}

# Function to monitor logs in real-time
monitor_logs() {
    local latest_log=$(ls -t $LOG_DIR/ccr-*.log 2>/dev/null | head -n 1)
    if [ -n "$latest_log" ]; then
        echo "Monitoring: $(basename $latest_log)"
        echo "Press Ctrl+C to stop"
        echo ""
        tail -f "$latest_log" | while read line; do
            if echo "$line" | grep -q "provider("; then
                PROVIDER_INFO=$(echo "$line" | grep -o "provider([^)]*)" | sed 's/provider(//' | sed 's/)$//')
                TIMESTAMP=$(echo "$line" | grep -o '"time":[0-9]*' | cut -d: -f2)
                if [ -n "$TIMESTAMP" ]; then
                    READABLE_TIME=$(date -r $(($TIMESTAMP / 1000)) 2>/dev/null || date -r $(($TIMESTAMP / 1000)) -u)
                else
                    READABLE_TIME="Unknown"
                fi
                echo "[$READABLE_TIME] PROVIDER: $PROVIDER_INFO"
            fi
            echo "$line"
        done
    else
        echo "No log files found to monitor."
    fi
}

# Function to cleanup old logs
cleanup_old_logs() {
    echo "Running log cleanup..."
    ./cleanup_logs.sh
    echo ""
}

# Main menu
while true; do
    echo "Current log directory: $LOG_DIR"
    echo "Claude Code Router logs: $CC_LOG_DIR"
    echo ""
    echo "Choose an option:"
    echo "1) List recent log files"
    echo "2) Show recent provider usage"
    echo "3) Show recent requests"
    echo "4) Monitor logs in real-time"
    echo "5) Show latest log content (last 20 lines)"
    echo "6) Cleanup old logs (keep 15 most recent)"
    echo "7) Exit"
    echo -n "Enter choice (1-7): "
    read choice

    case $choice in
        1)
            echo ""
            list_logs
            ;;
        2)
            echo ""
            show_recent_providers
            ;;
        3)
            echo ""
            show_recent_requests
            ;;
        4)
            echo ""
            monitor_logs
            ;;
        5)
            local latest_log=$(ls -t $LOG_DIR/ccr-*.log 2>/dev/null | head -n 1)
            if [ -n "$latest_log" ]; then
                echo "Latest log content (last 20 lines):"
                tail -20 "$latest_log"
                echo ""
            else
                echo "No log files found."
            fi
            ;;
        6)
            echo ""
            cleanup_old_logs
            ;;
        7)
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo "Invalid choice. Please enter 1-7."
            echo ""
            ;;
    esac
done