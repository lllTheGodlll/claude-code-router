#!/bin/bash

# Claude Code Router Provider Tracker
# Shows real-time provider usage with timestamps

LOG_DIR="$HOME/.claude-code-router/logs"
LOG_FILE_PATTERN="ccr-*.log"

echo "=== Claude Code Router Provider Tracker ==="
echo "Tracking provider usage in real-time..."
echo "Press Ctrl+C to stop"
echo ""

# Find the latest log file and follow it
LATEST_LOG=$(ls -t $LOG_DIR/$LOG_FILE_PATTERN 2>/dev/null | head -n 1)

if [ -z "$LATEST_LOG" ]; then
    echo "No log files found. Make sure Claude Code Router is running."
    echo "Start it with: ccr start"
    exit 1
fi

echo "Monitoring: $(basename $LATEST_LOG)"
echo "Format: [TIME] | PROVIDER | MODEL | STATUS"
echo "----------------------------------------"

# Tail the log file and extract provider information
tail -f "$LATEST_LOG" 2>/dev/null | while read line; do
    # Look for provider information in the log line
    if echo "$line" | grep -q "provider("; then
        # Extract provider and model info
        PROVIDER_MODEL=$(echo "$line" | grep -o "provider([^)]*)" | sed 's/provider(//' | sed 's/)$//')

        # Extract timestamp and convert to readable format
        TIMESTAMP_RAW=$(echo "$line" | grep -o '"time":[0-9]*' | cut -d: -f2)
        if [ -n "$TIMESTAMP_RAW" ] && [ "$TIMESTAMP_RAW" != "null" ]; then
            READABLE_TIME=$(date -r $(($TIMESTAMP_RAW / 1000)) 2>/dev/null)
            if [ $? -ne 0 ]; then
                # Fallback for macOS date command
                READABLE_TIME=$(date -r $(($TIMESTAMP_RAW / 1000)) -u 2>/dev/null)
            fi
        else
            READABLE_TIME="Unknown"
        fi

        # Extract status code if present
        STATUS_CODE=$(echo "$line" | grep -o '"statusCode":[0-9]*' | cut -d: -f2)
        if [ -n "$STATUS_CODE" ]; then
            STATUS="($STATUS_CODE)"
        else
            # Check for error indicators
            if echo "$line" | grep -qi "error"; then
                STATUS="(ERROR)"
            else
                STATUS="(SUCCESS)"
            fi
        fi

        # Format and display the information
        echo "[$READABLE_TIME] | $PROVIDER_MODEL | $STATUS"
    fi
done

# After the monitoring, offer to cleanup
echo ""
echo "Monitoring stopped. Would you like to cleanup old logs? (y/n): "
read cleanup_choice
if [ "$cleanup_choice" = "y" ] || [ "$cleanup_choice" = "Y" ]; then
    if [ -f "./cleanup_logs.sh" ]; then
        ./cleanup_logs.sh
    else
        echo "Cleanup script not found. Run from project directory."
    fi
fi