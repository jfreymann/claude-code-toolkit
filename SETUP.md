# Claude Code Agentic Workflow Toolkit

## Setup Guide

A complete framework for agentic development with Claude Code. This toolkit gives Claude full context awareness, state persistence across sessions, and expert agents for specialized work.

---

## Quick Start (5 minutes)

### 1. Install the Toolkit

```bash
# Clone to your home directory (recommended location)
cd ~
git clone https://github.com/YOUR_USERNAME/claude-code-toolkit.git

# Run the installer
cd claude-code-toolkit
./install.sh
```

**What the installer does:**
- Creates `~/.claude/` directory
- Copies `CLAUDE.md` template (your personal copy to customize)
- Creates symlinks for `agents/`, `commands/`, `skills/` pointing to the repo

**Result:**
```
~/.claude/
├── CLAUDE.md     ← Your copy (customize this!)
├── agents/       → ~/claude-code-toolkit/global-claude/agents/
├── commands/     → ~/claude-code-toolkit/global-claude/commands/
└── skills/       → ~/claude-code-toolkit/global-claude/skills/
```

**Installer options:**
```bash
./install.sh --help       # Show all options
./install.sh --dry-run    # Preview what would happen
./install.sh --uninstall  # Remove symlinks
```

**Updating the toolkit:**
```bash
cd ~/claude-code-toolkit
git pull
# That's it! Symlinks pick up changes automatically.
```

### 2. Customize Your Identity

Edit `~/.claude/CLAUDE.md` and fill in the sections marked with 🔧:

```bash
# Open in your editor
code ~/.claude/CLAUDE.md
# or
vim ~/.claude/CLAUDE.md
```

**Minimum required customizations:**
- Your name and role
- Your technical background
- Your preferred collaboration style

### 3. Set Up Your First Project

```bash
cd your-project

# Run the project initializer
/path/to/claude-code-toolkit/init-project.sh

# Or with options
./init-project.sh --name "My Project" /path/to/project
```

**Initializer options:**
```bash
./init-project.sh --help       # Show all options
./init-project.sh --force      # Overwrite existing files
./init-project.sh --name NAME  # Set project name
./init-project.sh --no-git     # Skip .gitignore modifications
```

The initializer creates:
```
your-project/
├── .claude/
│   └── CLAUDE.md              # Project context (edit this!)
├── docs/
│   ├── sessions/
│   │   ├── CURRENT.md         # Session state
│   │   └── archive/
│   ├── plans/
│   └── architecture/
│       └── decisions/
│           └── ADR-TEMPLATE.md
└── TO-DOS.md
```

### 4. Customize Project Context

```bash
# Edit the generated project context
code .claude/CLAUDE.md
```

Fill in:
- Project overview (2-3 sentences)
- Tech stack
- Key patterns/conventions

### 5. Start Working

```bash
# Launch Claude Code
claude

# Initialize your session
/bootstrap
```

That's it! Claude now has full context about you and your project.

---

## What You Get

### Session Continuity
- **Staleness detection**: Claude adapts its briefing based on how long since your last session
- **State persistence**: Pick up exactly where you left off, even after weeks
- **Handoff documents**: Clean session transitions with `/whats-next`

### Expert Agents
Specialized agents for domain-specific work:
- `rails-expert` - Ruby on Rails development
- `postgres-expert` - Database design and optimization
- `tailwind-expert` - CSS and UI styling
- `bash-expert` - Shell scripting and automation
- `git-workflow-manager` - Git operations
- `code-reviewer` - Code quality and security

### Workflow Commands
- `/bootstrap` - Session initialization
- `/whats-next` - Session handoff
- `/update-state` - Quick state updates
- `/archive-session` - Archive completed work
- `/create-adr` - Document decisions
- `/add-to-todos` / `/check-todos` - Task management

---

## Customization Guide

### Collaboration Style

In `~/.claude/CLAUDE.md`, set how you want Claude to interact:

**Colleague Mode** (default):
```markdown
I treat Claude as a **colleague**. This means:
- Be an expert in the domain we're working in
- Have opinions and push back when something seems wrong
- Ask clarifying questions rather than assuming
- Be direct - I'll ask if I need more explanation
```

**Assistant Mode**:
```markdown
I treat Claude as an **assistant**. This means:
- Follow my directions unless something is clearly wrong
- Ask before deviating from what I've asked
- Provide options rather than making decisions
- Explain your reasoning when I ask
```

**Mentor Mode**:
```markdown
I treat Claude as a **mentor**. This means:
- Explain concepts as you go
- Point out learning opportunities
- Suggest best practices and why they matter
- Help me understand, not just complete tasks
```

### Agent Delegation

Choose how Claude should handle specialist work:

**Ask First** (recommended for learning your workflow):
```markdown
**Always ask before delegating to specialist agents.**
```

**Auto-Delegate** (for experienced users):
```markdown
**Auto-delegate for clear domain-specific work.**
Only ask when the domain is ambiguous.
```

**No Delegation**:
```markdown
**Never delegate to specialist agents.**
Always work directly, I prefer a single conversation thread.
```

### Tech Stack Customization

Remove agents you don't use and add ones you need:

```markdown
## Available Agents

| Domain | Agent | Use For |
|--------|-------|---------|
| Python | python-expert | Python 3.11+, async, type hints |
| React | react-expert | Components, hooks, state management |
| Kubernetes | k8s-expert | Deployments, services, debugging |
```

To add a custom agent, create `~/.claude/agents/your-agent.md`:

```markdown
---
name: your-agent
description: What this agent does. When to delegate to it.
---

# Your Agent Name

You are an expert in [domain]. You [core responsibilities].

## Expertise
- [Skill 1]
- [Skill 2]

## Conventions
[How to do things in this domain]

## When Delegated Work
[How to approach tasks]
```

---

## Project Setup Details

### Directory Structure

Each project needs:
```
your-project/
├── .claude/
│   └── CLAUDE.md              # Project-specific context
├── docs/
│   ├── sessions/
│   │   ├── CURRENT.md         # Active session state
│   │   └── archive/           # Completed sessions
│   ├── plans/
│   │   └── ACTIVE.md          # Symlink to current plan
│   ├── architecture/
│   │   └── decisions/         # ADRs
│   └── theme/                 # Design docs (optional)
└── TO-DOS.md                  # Task tracking
```

### Project CLAUDE.md

Keep it lean - just enough for Claude to understand the project:

```markdown
# Project: Your Project Name

## Overview
[2-3 sentences: What is this and why does it exist?]

## Stack
[One-liner or short list of core technologies]

## Key Patterns
[Project-specific conventions]

## Architecture Decisions
See [docs/architecture/decisions/](docs/architecture/decisions/)

## Current State
See [docs/sessions/CURRENT.md](docs/sessions/CURRENT.md)
```

---

## Tips for Best Results

### 1. Run `/bootstrap` Every Session
This ensures Claude has full context. The staleness system adapts the briefing:
- **< 24 hours**: Quick 3-4 line summary
- **1-7 days**: Key decisions and state refresh
- **8-30 days**: Full context reload
- **> 30 days**: Environment verification suggestions

### 2. Use `/update-state` During Work
Quick updates keep state accurate:
```
/update-state task complete
/update-state decision "chose X over Y because..."
/update-state blocker "waiting on API access"
```

### 3. End Sessions with `/whats-next`
Creates a clean handoff for future you:
- What was accomplished
- Where you stopped
- What to do next

### 4. Archive Completed Features
When a major feature is done:
```
/archive-session
```
This moves the current state to archive and starts fresh.

### 5. Document Decisions with ADRs
For significant technical decisions:
```
/create-adr "Why we chose PostgreSQL over MongoDB"
```
Future you will thank present you.

---

## Troubleshooting

### Claude doesn't seem to know my preferences
- Check that `~/.claude/CLAUDE.md` exists and is properly formatted
- Run `/bootstrap` to reload context

### State isn't persisting between sessions
- Ensure `docs/sessions/CURRENT.md` exists in your project
- Check that `/whats-next` was run at end of previous session

### Agents aren't being offered
- Verify agents exist in `~/.claude/agents/`
- Check that agent files have proper YAML frontmatter

### Commands not recognized
- Ensure commands are in `~/.claude/commands/`
- Check for YAML frontmatter with `name:` field

---

## Contributing

Found a bug or have an improvement? PRs welcome!

- Add new agents for popular frameworks
- Improve command workflows
- Better documentation
- Bug fixes

---

## License

MIT - Use it, modify it, share it.
