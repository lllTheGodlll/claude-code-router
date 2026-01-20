# Claude Code Router - Log Management System

## Overview

This system provides comprehensive log management for Claude Code Router with automatic cleanup and easy access.

## Features

### ✅ **Automatic Log Cleanup**
- Keeps only the **15 most recent log files**
- Automatically removes older logs to save space
- Preserves recent activity for monitoring

### ✅ **Easy Access**
- Symbolic link to logs in project directory
- Multiple monitoring tools available
- Quick access scripts for different needs

### ✅ **Real-time Monitoring**
- Live provider tracking
- Usage statistics
- Request monitoring

## Directory Structure

```
/Volumes/TOSHIBA/GitHub/claude-code-router/
├── logs/                    # Symbolic link to ~/.claude-code-router/logs
├── cleanup_logs.sh         # Automatic cleanup (15 most recent)
├── view_logs.sh           # Interactive log viewer
├── provider_tracker.sh    # Real-time provider monitoring
├── check_usage.sh         # Usage summary
├── monitor_logs.sh        # Interactive monitoring
├── LOG_ACCESS.md          # Access guide
└── LOG_MANAGEMENT.md      # This guide
```

## Log Cleanup System

### Automatic Cleanup Script
- **File**: `cleanup_logs.sh`
- **Function**: Keeps only 15 most recent log files
- **Usage**: `./cleanup_logs.sh`

### Cleanup Integration
All monitoring tools include cleanup options:
- `view_logs.sh` - Option 6: Cleanup old logs
- `monitor_logs.sh` - Option 4: Cleanup old logs  
- `provider_tracker.sh` - Cleanup prompt after stopping
- Manual cleanup anytime with `./cleanup_logs.sh`

## Monitoring Tools

### 1. **Interactive Log Viewer** (`view_logs.sh`)
```bash
./view_logs.sh
```
- List recent log files
- Show provider usage
- Monitor in real-time
- Cleanup old logs
- View latest content

### 2. **Real-time Provider Tracker** (`provider_tracker.sh`)
```bash
./provider_tracker.sh
```
- Live provider monitoring
- Timestamps and status
- Cleanup prompt after stopping

### 3. **Usage Summary** (`check_usage.sh`)
```bash
./check_usage.sh
```
- Quick provider usage summary
- Request statistics
- Recent activity overview

### 4. **Interactive Monitor** (`monitor_logs.sh`)
```bash
./monitor_logs.sh
```
- Real-time monitoring
- Activity summary
- Configuration viewer
- Log cleanup

## Quick Commands

```bash
# View logs directory directly
ls -la logs/

# Interactive log viewer with cleanup option
./view_logs.sh

# Real-time provider tracking with cleanup prompt
./provider_tracker.sh

# Quick usage summary
./check_usage.sh

# Interactive monitoring with cleanup
./monitor_logs.sh

# Manual cleanup (keeps 15 most recent)
./cleanup_logs.sh

# View recent logs directly
tail -f logs/ccr-*.log
```

## Log File Management

### Cleanup Process
1. Script identifies all log files in `~/.claude-code-router/logs/`
2. Counts total files
3. If more than 15, deletes oldest files
4. Keeps only the 15 most recent by timestamp
5. Reports cleanup results

### Log Retention
- **Kept**: 15 most recent log files
- **Deleted**: Older log files beyond the 15 most recent
- **Preserved**: All recent activity and monitoring data

## Benefits

✅ **Space efficient** - No accumulation of old logs  
✅ **Automatic maintenance** - Cleanup happens on demand  
✅ **Recent data preserved** - Always have latest 15 logs  
✅ **Easy management** - Simple cleanup from any tool  
✅ **Flexible access** - Multiple ways to manage logs  
✅ **Real-time monitoring** - Live tracking with cleanup  
✅ **Quick access** - Direct access from project directory

## Best Practices

1. **Regular cleanup**: Use cleanup options in monitoring tools
2. **Monitor usage**: Track provider usage with real-time tools
3. **Check logs**: Regular monitoring of provider activity
4. **Space management**: Automatic cleanup prevents storage issues
5. **Quick access**: Use symbolic link for easy log access

The system ensures you always have access to recent logs while automatically managing storage space!