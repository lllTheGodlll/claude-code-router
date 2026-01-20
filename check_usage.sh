#!/bin/bash

# Claude Code Router Usage Checker
# Quick script to check recent provider usage

LOG_DIR="$HOME/.claude-code-router/logs"

echo "=== Claude Code Router Usage Report ==="
echo ""

# Check if logs directory exists
if [ ! -d "$LOG_DIR" ]; then
    echo "Error: Log directory not found at $LOG_DIR"
    echo "Make sure Claude Code Router is installed and running."
    exit 1
fi

# Find the latest log file
LATEST_LOG=$(ls -t $LOG_DIR/ccr-*.log 2>/dev/null | head -n 1)

if [ -z "$LATEST_LOG" ]; then
    echo "No log files found. Make sure Claude Code Router is running."
    echo "Start it with: ccr start"
    exit 1
fi

echo "Latest log file: $(basename $LATEST_LOG)"
echo "Generated on: $(date -r $LATEST_LOG)"
echo ""

# Show recent provider usage
echo "Recent providers used:"
grep -o "provider([^)]*)" "$LATEST_LOG" 2>/dev/null | sort | uniq -c | sort -nr | while read count provider; do
    PROVIDER_NAME=$(echo "$provider" | sed 's/provider(//' | sed 's/)$//')
    echo "  $count requests -> $PROVIDER_NAME"
done

if [ $? -eq 0 ] && [ -z "$(grep -o "provider([^)]*)" "$LATEST_LOG" 2>/dev/null)" ]; then
    echo "  No provider usage found in this log file"
fi

echo ""

# Show request statistics
echo "Request statistics:"
TOTAL_REQUESTS=$(grep -c "request completed" "$LATEST_LOG" 2>/dev/null || echo "0")
SUCCESS_REQUESTS=$(grep -c "statusCode\":200" "$LATEST_LOG" 2>/dev/null || echo "0")
ERROR_REQUESTS=$(grep -c "statusCode\":4\|statusCode\":5\|error" "$LATEST_LOG" 2>/dev/null || echo "0")

echo "  Total requests: $TOTAL_REQUESTS"
echo "  Successful: $SUCCESS_REQUESTS"
echo "  Errors: $ERROR_REQUESTS"
echo ""

# Show recent activity
echo "Recent 5 requests:"
grep -A 2 "incoming request" "$LATEST_LOG" 2>/dev/null | grep -o '"model":"[^"]*"' | head -10 | while read model_line; do
    MODEL=$(echo "$model_line" | sed 's/"model":"//' | sed 's/"$//')
    if [[ "$MODEL" == *","* ]]; then
        PROVIDER=$(echo "$MODEL" | cut -d',' -f1)
        MODEL_NAME=$(echo "$MODEL" | cut -d',' -f2-)
        echo "  $PROVIDER -> $MODEL_NAME"
    else
        echo "  $MODEL"
    fi
done

if [ $? -eq 0 ] && [ -z "$(grep -A 2 "incoming request" "$LATEST_LOG" 2>/dev/null | grep -o '"model":"[^"]*"')" ]; then
    echo "  No recent requests found"
fi

echo ""
echo "To monitor in real-time, run: ./provider_tracker.sh"
echo "To see full logs: tail -f $LATEST_LOG"