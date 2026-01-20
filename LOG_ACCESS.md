# Claude Code Router - Log Access

## Quick Log Access Setup

This project now has convenient access to Claude Code Router logs through a symbolic link.

## Directory Structure

```
/Volumes/TOSHIBA/GitHub/claude-code-router/
├── logs/                    # Symbolic link to ~/.claude-code-router/logs
├── view_logs.sh            # Quick access script
├── provider_tracker.sh     # Real-time provider monitoring
├── check_usage.sh          # Usage summary
├── monitor_logs.sh         # Interactive monitoring
└── ...
```

## Quick Access Methods

### 1. Direct Directory Access
```bash
# View log files directly
ls -la logs/
cat logs/ccr-*.log
tail -f logs/ccr-latest.log
```

### 2. Quick Log Viewer
```bash
./view_logs.sh
```
Interactive menu with multiple options:
- List recent log files
- Show recent provider usage
- Show recent requests
- Monitor logs in real-time
- View latest log content

### 3. Real-time Monitoring
```bash
./provider_tracker.sh    # Real-time provider tracking
./monitor_logs.sh        # Interactive monitoring
```

### 4. Quick Summary
```bash
./check_usage.sh         # Usage summary
```

## What You Can See

- **Provider usage**: Which provider (Ollama/OpenRouter) is being used
- **Model names**: Specific models being requested
- **Timestamps**: When each request was made
- **Status codes**: Success (200) or error (401, 500, etc.)
- **Request details**: Full request/response information

## Log File Format

Log files are in JSON format with:
- `"time"`: Timestamp in milliseconds
- `"provider"`: Provider and model information
- `"statusCode"`: HTTP status codes
- `"msg"`: Request/response messages

## Benefits

✅ **Quick access** without navigating to hidden directory
✅ **Real-time monitoring** of provider usage
✅ **Easy log viewing** from project directory
✅ **Symbolic link** keeps everything synchronized
✅ **Multiple tools** for different monitoring needs
✅ **Automatic cleanup** keeps only 15 most recent logs