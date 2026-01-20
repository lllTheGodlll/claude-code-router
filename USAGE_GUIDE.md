# Claude Code Router - Usage Guide

## Overview
This document explains how to use your Claude Code Router setup with Ollama and OpenRouter providers.

## Current Configuration

### Providers Available
1. **Ollama** - Local models (unlimited usage)
2. **OpenRouter** - Cloud models (free tier: 50 requests/day)

### Pre-configured Routing
- **Default**: `ollama,llama3.2:latest` - General tasks
- **Background**: `ollama,phi3:latest` - Background processing
- **Think**: `ollama,kimi-k2-thinking:cloud` - Reasoning tasks
- **Long Context**: `ollama,gemma3:latest` - Large context tasks
- **Web Search**: `openrouter,google/gemini-flash-1.5:free` - Web search tasks
- **Image**: `ollama,llama3.2-vision:latest` - Image-related tasks
- **Coding**: `ollama,deepseek-coder:33b` - Coding tasks
- **Vision**: `ollama,llama3.2-vision:latest` - Vision tasks
- **Large**: `ollama,deepseek-r1:latest` - Large model tasks
- **Multimodal**: `ollama,llama3.2-vision:latest` - Multimodal tasks

## Available Models

### Ollama Models (27 total)
- `llama3.2:latest` (2.0 GB) - Default model
- `llama3.2-vision:latest` (7.8 GB) - Vision model
- `phi3:latest` - Background tasks
- `llama3.1:latest` - Alternative to llama3.2
- `kimi-k2-thinking:cloud` - Thinking/reasoning
- `gemma3:latest` (3.3 GB) - Long context
- `deepseek-r1:latest` (5.2 GB) - Large model
- `deepseek-coder:33b` (18 GB) - Coding model
- `qwen3-*` series - Various sizes and capabilities
- `mistral-large-3:675b-cloud` - Large Mistral model
- `glm-4.6:cloud` - GLM model
- `gemini-3-*` series - Google models
- `gpt-oss:120b` (65 GB) - GPT OSS model
- And many more...

### OpenRouter Models (16+ free models)
- `anthropic/claude-3.5-sonnet:free` - Advanced Claude model
- `anthropic/claude-3-haiku:free` - Fast Claude model
- `google/gemini-pro:free` - Google Gemini Pro
- `google/gemini-flash-1.5:free` - Google Gemini Flash 1.5
- `meta-llama/llama-3.1-8b-instruct:free` - Meta 8B model
- `meta-llama/llama-3.1-70b-instruct:free` - Meta 70B model
- `microsoft/phi-3.5-mini-instruct:free` - Microsoft Phi models
- `qwen/qwen-2.5-coder-32b-instruct:free` - Qwen coding model
- `cohere/command-r:free` - Cohere model
- `mistralai/mistral-7b-instruct:free` - Mistral 7B
- And more from various providers...

## How to Use

### 1. Interactive Model Selection
```bash
ccr model
```
This opens an interactive interface to switch between different models for different routing categories.

### 2. In Claude Code Commands
Use the `/model` command in Claude Code to switch models:
```
/model ollama,llama3.2:latest
/model openrouter,anthropic/claude-3.5-sonnet:free
/model ollama,deepseek-coder:33b
/model ollama,llama3.2-vision:latest
```

### 3. Web Interface
```bash
ccr ui
```
Open a web-based interface to manage your configuration.

### 4. Check Current Status
```bash
ccr status
```
Check if the router service is running.

### 5. Restart Service
```bash
ccr restart
```
Restart the router service (needed after config changes).

## Available Commands

### Basic Commands
- `ccr code` - Start Claude Code with the router
- `ccr start` - Start the router service
- `ccr stop` - Stop the router service
- `ccr restart` - Restart the router service
- `ccr status` - Check router service status

### Configuration Commands
- `ccr model` - Interactive model selection interface
- `ccr ui` - Web-based configuration interface
- `ccr activate` - Set up environment variables for direct `claude` command usage

### Environment Setup
```bash
eval "$(ccr activate)"
```
This sets up environment variables to use the `claude` command directly with the router.

## Provider-Specific Information

### Ollama Provider
- **Location**: Local (localhost:11434)
- **Usage**: Unlimited (depends on your hardware)
- **Models**: 27+ local and cloud models
- **Best for**: General tasks, coding, privacy-sensitive work
- **Requirements**: Ollama must be running locally

### OpenRouter Provider
- **Location**: Cloud (openrouter.ai)
- **Usage**: Free tier (50 requests/day for new users, 1000/day after $10+ credits)
- **Models**: 16+ free models from various providers
- **Best for**: Access to Claude, Gemini, and other premium models for free
- **Requirements**: API key in `.env` file

## Troubleshooting

### Common Issues
1. **Model not found**: Make sure the model name is exactly as listed
2. **API key issues**: Verify your API keys are correct in `~/.claude-code-router/.env`
3. **Service not running**: Use `ccr status` to check and `ccr restart` to fix
4. **Ollama not responding**: Ensure Ollama service is running (`ollama serve`)

### Logs
Check logs in `~/.claude-code-router/logs/` for detailed error information.

## Adding New API Keys
1. Add to `~/.claude-code-router/.env`:
   ```
   NEW_PROVIDER_API_KEY=your-key-here
   ```
2. Update `config.json` to reference `$NEW_PROVIDER_API_KEY`
3. Restart with `ccr restart`

## Security Notes
- API keys are stored in `~/.claude-code-router/.env`
- Configuration uses environment variable interpolation
- Keep your `.env` file secure and don't share it