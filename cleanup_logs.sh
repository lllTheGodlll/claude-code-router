#!/bin/bash

# Log Cleanup Script for Claude Code Router
# Keeps only the most recent 15 log files

LOG_DIR="$HOME/.claude-code-router/logs"
MAX_LOGS=15

echo "=== Claude Code Router Log Cleanup ==="
echo "Log directory: $LOG_DIR"
echo "Keeping only the most recent $MAX_LOGS log files"
echo ""

# Check if log directory exists
if [ ! -d "$LOG_DIR" ]; then
    echo "Error: Log directory does not exist: $LOG_DIR"
    exit 1
fi

# Count total log files
TOTAL_LOGS=$(ls -1 $LOG_DIR/ccr-*.log 2>/dev/null | wc -l)

echo "Total log files found: $TOTAL_LOGS"

if [ "$TOTAL_LOGS" -le "$MAX_LOGS" ]; then
    echo "No cleanup needed. Only $TOTAL_LOGS log files exist (limit is $MAX_LOGS)."
    echo "All logs are kept."
    exit 0
fi

# Calculate how many files to delete
DELETE_COUNT=$((TOTAL_LOGS - MAX_LOGS))
echo "Deleting $DELETE_COUNT old log files..."

# Get the oldest log files and delete them
OLDEST_LOGS=$(ls -tr $LOG_DIR/ccr-*.log 2>/dev/null | head -n $DELETE_COUNT)

for log_file in $OLDEST_LOGS; do
    if [ -f "$log_file" ]; then
        echo "Deleting: $(basename "$log_file")"
        rm "$log_file"
    fi
done

# Verify cleanup
FINAL_COUNT=$(ls -1 $LOG_DIR/ccr-*.log 2>/dev/null | wc -l)
echo ""
echo "Cleanup complete!"
echo "Remaining log files: $FINAL_COUNT"
echo "Recent log files:"
ls -lat $LOG_DIR/ccr-*.log 2>/dev/null | head -n $MAX_LOGS