#!/bin/bash

# Claude Code Router Log Monitor
# Script to monitor Claude Code Router logs in real-time

LOG_DIR="$HOME/.claude-code-router/logs"
LOG_FILE_PATTERN="ccr-*.log"

echo "=== Claude Code Router Log Monitor ==="
echo "Monitoring directory: $LOG_DIR"
echo "Press Ctrl+C to stop monitoring"
echo ""

# Function to show current log file
show_current_log() {
    local latest_log=$(ls -t $LOG_DIR/$LOG_FILE_PATTERN 2>/dev/null | head -n 1)
    if [ -n "$latest_log" ]; then
        echo "Monitoring: $(basename $latest_log)"
        echo "----------------------------------------"
        tail -f "$latest_log" | while read line; do
            # Extract provider info from log lines
            if echo "$line" | grep -q "provider("; then
                PROVIDER_INFO=$(echo "$line" | grep -o "provider([^)]*)" | sed 's/provider(//' | sed 's/)$//')
                TIMESTAMP=$(echo "$line" | grep -o '"time":[0-9]*' | cut -d: -f2)
                if [ -n "$TIMESTAMP" ]; then
                    # Convert timestamp to readable format
                    READABLE_TIME=$(date -r $(($TIMESTAMP / 1000)) 2>/dev/null || date -r $(($TIMESTAMP / 1000)) -u)
                else
                    READABLE_TIME="Unknown"
                fi
                echo "[$READABLE_TIME] PROVIDER: $PROVIDER_INFO"
            fi
            echo "$line"
        done
    else
        echo "No log files found in $LOG_DIR"
        echo "Make sure Claude Code Router is running: ccr start"
    fi
}

# Function to show summary of recent activity
show_summary() {
    echo ""
    echo "=== Recent Activity Summary ==="
    local latest_log=$(ls -t $LOG_DIR/$LOG_FILE_PATTERN 2>/dev/null | head -n 1)
    if [ -n "$latest_log" ]; then
        echo "Latest log file: $(basename $latest_log)"
        echo ""
        echo "Recent providers used:"
        grep -o "provider([^)]*)" "$latest_log" 2>/dev/null | sort | uniq -c | sort -nr
        echo ""
        echo "Recent request counts by status:"
        grep "request completed" "$latest_log" 2>/dev/null | grep -o '"statusCode":[0-9]*' | sort | uniq -c
        echo ""
        echo "Recent errors:"
        grep -i "error\|401\|500" "$latest_log" 2>/dev/null | tail -5
    fi
}

# Function to cleanup old logs
show_cleanup() {
    echo ""
    echo "Running log cleanup (keeping 15 most recent)..."
    if [ -f "./cleanup_logs.sh" ]; then
        ./cleanup_logs.sh
    else
        echo "Cleanup script not found in current directory."
        echo "Please run this from the project directory or ensure cleanup_logs.sh exists."
    fi
    echo ""
}

# Main menu
while true; do
    echo ""
    echo "Choose an option:"
    echo "1) Monitor logs in real-time"
    echo "2) Show recent activity summary"
    echo "3) Show current model configuration"
    echo "4) Cleanup old logs (keep 15 most recent)"
    echo "5) Exit"
    echo -n "Enter choice (1-5): "
    read choice

    case $choice in
        1)
            echo ""
            show_current_log
            ;;
        2)
            echo ""
            show_summary
            ;;
        3)
            echo ""
            echo "=== Current Model Configuration ==="
            echo "Default model: $(grep -A 10 '"Router":' ~/.claude-code-router/config.json | grep -A 1 '"default"' | cut -d'"' -f4)"
            echo "Background model: $(grep -A 10 '"Router":' ~/.claude-code-router/config.json | grep -A 1 '"background"' | cut -d'"' -f4)"
            echo "Think model: $(grep -A 10 '"Router":' ~/.claude-code-router/config.json | grep -A 1 '"think"' | cut -d'"' -f4)"
            echo "Web search model: $(grep -A 10 '"Router":' ~/.claude-code-router/config.json | grep -A 1 '"webSearch"' | cut -d'"' -f4)"
            echo ""
            echo "Available providers:"
            grep -A 50 '"Providers":' ~/.claude-code-router/config.json | grep '"name"' | cut -d'"' -f4 | sort | uniq
            ;;
        4)
            echo ""
            show_cleanup
            ;;
        5)
            echo "Exiting monitor..."
            exit 0
            ;;
        *)
            echo "Invalid choice. Please enter 1-5."
            ;;
    esac
done