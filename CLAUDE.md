# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is the **Claude Code Agentic Workflow Toolkit** - a framework for persistent, context-aware development sessions with Claude Code. It provides:

- **Symlink-based installation** to `~/.claude/` for global availability
- **Session continuity** through state management (CURRENT.md, plans, ADRs)
- **Specialized agents** for domain-specific work (Rails, PostgreSQL, Git, etc.)
- **Workflow commands** (slash commands) for common development tasks
- **Extensible skills** for complex operations (creating hooks, subagents, meta-prompts)

## Architecture

### Three-Layer Structure

```
claude-code-toolkit/              # This repository
├── install.sh                    # Symlinks global-claude/ to ~/.claude/
├── init-project.sh               # Initializes project structure
├── global-claude/                # SYMLINKED to ~/.claude/
│   ├── CLAUDE.md                # Template (copied to user's ~/.claude/)
│   ├── agents/*.md              # Specialized subagents (18 files)
│   ├── commands/*.md            # Slash commands (33 files)
│   └── skills/*/SKILL.md        # Complex skills (8 skills)
└── project-templates/            # Templates for project initialization
    ├── project-CLAUDE.md         # → {project}/.claude/CLAUDE.md
    ├── CURRENT.md                # → {project}/docs/sessions/CURRENT.md
    ├── PLAN-TEMPLATE.md          # Structure for implementation plans
    └── ADR-TEMPLATE.md           # Architecture Decision Record template
```

### Installation Flow

1. User runs `./install.sh`
2. Script creates `~/.claude/` directory
3. `CLAUDE.md` is **copied** (user customizes their identity)
4. `agents/`, `commands/`, `skills/` are **symlinked** (updates via git pull)

Result:
```
~/.claude/
├── CLAUDE.md          # User's copy (customizable)
├── agents/            → ~/claude-code-toolkit/global-claude/agents/
├── commands/          → ~/claude-code-toolkit/global-claude/commands/
└── skills/            → ~/claude-code-toolkit/global-claude/skills/
```

### Project Initialization Flow

1. User runs `./init-project.sh` in their project
2. Script creates directory structure from `project-templates/`
3. Project gets `.claude/CLAUDE.md`, `docs/sessions/CURRENT.md`, etc.

Result:
```
{project}/
├── .claude/CLAUDE.md              # Project-specific context
├── docs/
│   ├── sessions/
│   │   ├── CURRENT.md             # Active session state
│   │   └── archive/
│   ├── plans/
│   └── architecture/decisions/
└── TO-DOS.md
```

## Key Components

### Agents (global-claude/agents/)

Specialized subagents launched via the Task tool. Each agent is a markdown file with YAML frontmatter:

```markdown
---
name: agent-name
description: What this agent does
tools: [Read, Write, Edit, Bash, ...]
---

# Agent Prompt
You are an expert in X...
```

Current agents:
- **rails-expert** - Ruby on Rails development
- **postgres-expert** - PostgreSQL optimization
- **git-workflow-manager** - Git operations (rebase, conflicts, branch management, push workflows)
  - **Special behavior**: Triggered when user says "push code" (without quotes)
  - **Safety constraint**: NEVER pushes to main/master - always creates feature branch first
  - **No attribution**: Never adds Claude attribution to commits
- **code-reviewer** - Quality and security review
- **bash-expert** - Shell scripting
- Plus 13 more language/domain experts

### Commands (global-claude/commands/)

Slash commands for workflow automation. Structure:

```markdown
---
name: command-name
description: What this command does
---

# Command Prompt
Execute this workflow...
```

Categories:
- **Session lifecycle**: bootstrap.md, end-session.md, resume.md
- **Planning**: create-plan.md, update-plan.md, run-plan.md
- **Development**: implement.md, run-tests.md, add-tests.md, test-first.md
- **Quality**: pre-commit.md, commit.md
- **Documentation**: create-adr.md, add-to-todos.md
- **Mental models**: consider/*.md (12 decision-making frameworks)

### Skills (global-claude/skills/)

Complex, multi-step capabilities with reference docs and workflows:

- **create-agent-skills/** - Build new Claude Code skills
- **create-subagents/** - Build specialized agents
- **create-slash-commands/** - Build slash commands
- **create-hooks/** - Build event-driven hooks
- **create-meta-prompts/** - Build multi-stage prompts
- **create-plans/** - Create hierarchical project plans
- **debug-like-expert/** - Deep debugging methodology

Each skill has:
```
skill-name/
├── SKILL.md                 # Main skill logic (router pattern)
├── references/*.md          # Knowledge base
├── workflows/*.md           # Step-by-step procedures
├── templates/*.md           # Code templates
└── scripts/*.sh             # Automation helpers
```

## Development Workflow

### Adding a New Agent

1. Create `global-claude/agents/your-agent.md`
2. Add YAML frontmatter with name, description, tools
3. Write expert prompt defining capabilities
4. Test by asking Claude to delegate work to it
5. Update `global-claude/CLAUDE.md` agent table

### Adding a New Command

1. Create `global-claude/commands/your-command.md`
2. Add YAML frontmatter with name and description
3. Write command prompt (what Claude should do)
4. Test by running `/your-command` in Claude Code
5. Document in README.md if it's a core workflow command

### Adding a New Skill

Use the toolkit itself:
```
/create-agent-skill "skill description"
```

Or manually:
1. Create `global-claude/skills/skill-name/`
2. Create `SKILL.md` with router pattern
3. Add `references/`, `workflows/`, `templates/` as needed
4. Register in skill system

### Modifying Templates

Templates live in `project-templates/`:
- **project-CLAUDE.md** - Edit structure for project context
- **CURRENT.md** - Edit session state format
- **PLAN-TEMPLATE.md** - Edit plan structure
- **ADR-TEMPLATE.md** - Edit decision record format

Changes take effect on next `init-project.sh` run.

## Installation Scripts

### install.sh

Bash script with safety features:
- `--dry-run` - Preview without changes
- `--uninstall` - Remove symlinks
- Detects existing symlinks and updates them
- Preserves user's CLAUDE.md customizations
- Colored output with status indicators

### init-project.sh

Project initializer with options:
- `-n, --name NAME` - Set project name
- `-f, --force` - Overwrite existing files
- `--no-git` - Skip .gitignore modifications
- Supports arbitrary project paths
- Customizes templates with project name

## State Management Philosophy

The toolkit implements "living architecture" through persistent state:

1. **Global state** (`~/.claude/CLAUDE.md`) - User identity, never changes
2. **Project state** (`.claude/CLAUDE.md`) - Project context, rarely changes
3. **Session state** (`docs/sessions/CURRENT.md`) - What's happening now, updates constantly
4. **Plan state** (`docs/plans/*.md`) - Active work breakdown, task-level tracking

Session continuity flow:
```
/end-session → saves CURRENT.md
                     ↓
              (time passes)
                     ↓
/bootstrap   ← reads CURRENT.md → adaptive briefing
```

## Testing Changes

### Test Installation
```bash
./install.sh --dry-run          # Preview changes
./install.sh                    # Actual install
ls -la ~/.claude/               # Verify symlinks
```

### Test Project Init
```bash
mkdir /tmp/test-project
./init-project.sh /tmp/test-project
ls -R /tmp/test-project         # Verify structure
```

### Test Agent/Command Changes
Edit file in `global-claude/`, then:
```bash
claude                          # Start Claude Code
/your-command                   # Test command
# or
"delegate to your-agent"        # Test agent
```

Changes are live immediately (symlinks).

## Updating the Toolkit

Users update by pulling changes:
```bash
cd ~/claude-code-toolkit
git pull
```

Because `~/.claude/agents/`, `commands/`, `skills/` are symlinks, updates are instant. User's `~/.claude/CLAUDE.md` remains untouched (it's a copy, not a symlink).

## Key Design Decisions

### Symlinks over Copying
- **Rationale**: Users get updates via `git pull` without reinstalling
- **Tradeoff**: Requires keeping toolkit repo around
- **Exception**: CLAUDE.md is copied so users can customize

### Three-Level State
- **Global** (`~/.claude/`) - Personal preferences
- **Project** (`.claude/`) - Project context
- **Session** (`docs/sessions/`) - Current work
- **Rationale**: Separation of concerns, different update frequencies

### Markdown Everything
- All agents, commands, skills, templates are markdown
- Easy to read, edit, version control
- Claude Code natively understands markdown structure

### Router Pattern for Skills
- Skills use a dispatch pattern (SKILL.md routes to workflows)
- Enables complex, multi-step operations
- References separate knowledge from execution logic

## Common Pitfalls

### Editing Files in ~/.claude/ Directly
Don't edit `~/.claude/agents/`, `commands/`, or `skills/` - they're symlinks. Edit in the toolkit repo, then git commit.

Exception: `~/.claude/CLAUDE.md` is a copy - edit freely.

### Forgetting to Update Documentation
When adding agents/commands/skills:
1. Update this CLAUDE.md
2. Update README.md if it's a key feature
3. Update WALKTHROUGH.md if it affects user workflow

### Breaking Symlink Installation
The installer expects this structure:
```
claude-code-toolkit/
└── global-claude/
    ├── CLAUDE.md
    ├── agents/
    ├── commands/
    └── skills/
```

Don't rename `global-claude/` or move these directories.

## File Naming Conventions

- **Agents**: `kebab-case.md` matching agent name
- **Commands**: `kebab-case.md` matching command name (without leading `/`)
- **Skills**: `skill-name/SKILL.md` (uppercase SKILL.md)
- **Templates**: `UPPERCASE.md` or `descriptive-name.md`

## Contributing to the Toolkit

When adding features:
1. Add capability (agent/command/skill)
2. Test in a real project
3. Document in relevant files (CLAUDE.md, README.md)
4. Update WALKTHROUGH.md if user-facing
5. Commit with conventional commit message

Conventional commits:
- `feat:` - New agent, command, or skill
- `fix:` - Bug fix in existing capability
- `docs:` - Documentation only
- `refactor:` - Restructuring without behavior change
- `chore:` - Maintenance (dependencies, scripts)
