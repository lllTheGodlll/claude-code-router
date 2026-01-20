# Claude Code Router - Log Monitoring Guide

This guide explains how to monitor your Claude Code Router usage, track which providers you're using, and see real-time activity.

## Overview

Claude Code Router already has built-in logging that tracks:
- ✅ **Provider usage** (Ollama vs OpenRouter)
- ✅ **Model names** being used
- ✅ **Timestamps** for each request
- ✅ **Status codes** (success/failure)
- ✅ **Request details**

## Monitoring Scripts

### 1. Provider Tracker (`provider_tracker.sh`)
Real-time monitoring of provider usage with timestamps.

**Usage:**
```bash
./provider_tracker.sh
```

**Output format:**
```
[TIME] | PROVIDER,MODEL | STATUS
[Mon Dec 30 13:03:15 EST 2025] | openrouter,google/gemini-flash-1.5:free | (200)
```

### 2. Usage Checker (`check_usage.sh`)
Quick summary of recent activity and provider usage.

**Usage:**
```bash
./check_usage.sh
```

**Shows:**
- Recent providers used with request counts
- Request statistics (total, successful, errors)
- Recent 5 requests with models used

### 3. Full Monitor (`monitor_logs.sh`)
Interactive menu with multiple monitoring options.

**Usage:**
```bash
./monitor_logs.sh
```

**Options:**
- Real-time log monitoring
- Recent activity summary
- Current model configuration
- Exit

## Built-in Log Files

Logs are automatically stored in:
```
~/.claude-code-router/logs/
├── ccr-YYYYMMDDHHMMSS.log
└── ...
```

Each log file contains:
- **JSON format** with timestamps
- **Provider information** in `provider(provider_name,model_name)` format
- **Request/response details**
- **Error messages** when they occur

## How to Identify Current Provider

### In Claude Code:
- Use `/model` command to see current selection
- Look at the model indicator in the interface
- Format is always `provider,model_name`

### In Logs:
- Search for `provider(` to find provider usage
- Look for `"model":"provider,model"` patterns
- Check timestamps with `"time":` values

## Example Log Entries

**Successful request:**
```json
{"level":30,"time":1767126595423,"msg":"final request","headers":{"authorization":"Bearer $OPENROUTER_API_KEY"},"requestUrl":"https://openrouter.ai/api/v1/chat/completions"}
```

**Provider identification:**
```
"provider(openrouter,google/gemini-flash-1.5:free: 401)"
```

## Quick Commands

```bash
# Check recent usage summary
./check_usage.sh

# Monitor in real-time
./provider_tracker.sh

# Interactive monitoring
./monitor_logs.sh

# View raw logs directly
tail -f ~/.claude-code-router/logs/ccr-*.log

# See current configuration
cat ~/.claude-code-router/config.json | grep -A 20 '"Router":'
```

## Troubleshooting

If you see API errors (like 401 Unauthorized):
- Check your API keys in `~/.claude-code-router/.env`
- Verify OpenRouter API key is valid
- Restart the router: `ccr restart`

## Security Note

- Log files may contain sensitive information
- API keys are masked as `$OPENROUTER_API_KEY` in logs
- Keep log files secure