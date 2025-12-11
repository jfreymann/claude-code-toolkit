# Global Claude Configuration

This directory contains your personal Claude Code configuration. Install it to `~/.claude/`.

## Installation

```bash
cp -r global-claude ~/.claude
```

## Structure

```
~/.claude/
├── CLAUDE.md          # Your identity and preferences (customize this!)
├── agents/            # Expert agents for specialized work
├── commands/          # Workflow slash commands
└── skills/            # Knowledge frameworks (add from other repos)
```

## Customization

### Required: Edit CLAUDE.md

Open `~/.claude/CLAUDE.md` and customize the sections marked with 🔧:

1. **Identity** - Your name, role, background
2. **Working Style** - How you want Claude to interact
3. **Conventions** - Your coding standards
4. **Available Agents** - Enable/disable based on your tech stack

### Optional: Add More Agents

Create `~/.claude/agents/your-agent.md`:

```markdown
---
name: your-agent
description: What this agent specializes in.
---

# Agent Name

Instructions for Claude when acting as this agent...
```

### Optional: Add Skills

Skills are knowledge frameworks from repositories like:
- Your own skills from other repos
- [anthropics/skills](https://github.com/anthropics/skills)
- Community skill repositories

Copy them to `~/.claude/skills/`.

## Commands Reference

| Command | Purpose |
|---------|---------|
| `/bootstrap` | Initialize session with full context |
| `/whats-next` | End session, create handoff |
| `/update-state` | Quick mid-session updates |
| `/archive-session` | Archive when feature completes |
| `/create-adr` | Create architecture decision record |
| `/add-to-todos` | Add TODO item |
| `/check-todos` | Review/manage TODOs |

## Agents Reference

| Agent | Specialty |
|-------|-----------|
| rails-expert | Ruby on Rails development |
| postgres-expert | PostgreSQL database work |
| tailwind-expert | Tailwind CSS styling |
| bash-expert | Shell scripting |
| git-workflow-manager | Git operations |
| code-reviewer | Code quality & security |
