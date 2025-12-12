# Claude Code Agentic Workflow Toolkit

A complete framework for agentic development with Claude Code. Run `/bootstrap` and Claude has full context, state awareness, and expert agents ready to collaborate.

## Quick Start

### 1. Install Global Toolkit

```bash
# Backup existing config
[ -d ~/.claude ] && mv ~/.claude ~/.claude.backup

# Install global toolkit
cp -r global-claude ~/.claude

# Customize your identity
# Edit ~/.claude/CLAUDE.md with your info
```

### 2. Copy Your Existing Tools

```bash
# Copy your existing agents (if not replacing)
cp -r ~/path/to/claude-code-tools/agents/* ~/.claude/agents/

# Copy your consider commands
cp -r ~/path/to/claude-code-tools/commands/consider/* ~/.claude/commands/consider/

# Copy your skills
cp -r ~/path/to/claude-code-tools/skills/* ~/.claude/skills/
```

### 3. Set Up a Project

```bash
cd your-project

# Create directory structure
mkdir -p .claude docs/sessions/archive docs/plans docs/architecture/decisions

# Copy templates
cp project-templates/project-CLAUDE.md .claude/CLAUDE.md
cp project-templates/CURRENT.md docs/sessions/CURRENT.md
cp project-templates/ADR-TEMPLATE.md docs/architecture/decisions/

# Create TO-DOS.md
touch TO-DOS.md

# Customize .claude/CLAUDE.md for your project
```

### 4. Start Working

```bash
# Start Claude Code in your project
claude

# Initialize session
/bootstrap
```

---

## What's Included

### Global Toolkit (`global-claude/` → `~/.claude/`)

```
~/.claude/
├── CLAUDE.md                     # Your identity & preferences
├── agents/                       # Expert agents
│   ├── rails-expert.md
│   ├── postgres-expert.md
│   ├── tailwind-expert.md
│   ├── bash-expert.md
│   ├── git-workflow-manager.md
│   └── code-reviewer.md
├── commands/                     # Workflow commands
│   ├── bootstrap.md              # Session init
│   ├── whats-next.md             # Session end
│   ├── archive-session.md        # Archive completed work
│   ├── update-state.md           # Quick state updates
│   ├── create-adr.md             # Architecture decisions
│   ├── add-to-todos.md           # Add TODOs
│   ├── check-todos.md            # Manage TODOs
│   └── consider/                 # Mental models (copy from your repo)
└── skills/                       # Knowledge frameworks (copy from your repo)
```

### Project Templates (`project-templates/`)

| File | Install To | Purpose |
|------|------------|---------|
| `project-CLAUDE.md` | `.claude/CLAUDE.md` | Lean project context |
| `CURRENT.md` | `docs/sessions/CURRENT.md` | Session state file |
| `ADR-TEMPLATE.md` | `docs/architecture/decisions/` | ADR template |

### Examples (`examples/guardian/`)

Real-world examples showing populated files:
- `CLAUDE.md` - Lean project context
- `CURRENT.md` - Active session state
- `synthwave.md` - Theme documentation
- `ADR-002-mtls.md` - Architecture decision record

---

## Workflow Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                    DEVELOPMENT WORKFLOW                         │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  SESSION START                                                  │
│  └── /bootstrap                                                 │
│      ├── Load global context (~/.claude/CLAUDE.md)              │
│      ├── Load project context (.claude/CLAUDE.md)               │
│      ├── Recover state (docs/sessions/CURRENT.md)               │
│      ├── Calculate staleness (HOT/WARM/COOL/COLD)               │
│      └── Present adaptive brief + next action                   │
│                                                                 │
│  DURING DEVELOPMENT                                             │
│  ├── /update-state task complete    # Mark progress             │
│  ├── /update-state decision "..."   # Log decisions             │
│  ├── /add-to-todos [HIGH] "..."     # Track future work         │
│  ├── /create-adr "Title"            # Document decisions        │
│  └── Ask Claude to delegate to agents when needed               │
│                                                                 │
│  SESSION END                                                    │
│  └── /whats-next                                                │
│      └── Updates CURRENT.md with handoff info                   │
│                                                                 │
│  MAJOR FEATURE COMPLETE                                         │
│  └── /archive-session                                           │
│      └── Moves CURRENT.md to archive, starts fresh              │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## Key Concepts

### Staleness Tiers

How long since last session determines context depth:

| Tier | Time | Brief Style |
|------|------|-------------|
| 🟢 HOT | < 24h | Terse (3-4 lines) |
| 🟡 WARM | 1-7 days | Medium (state + decisions) |
| 🟠 COOL | 8-30 days | Detailed (full refresh) |
| 🔴 COLD | > 30 days | Full + env verification |

### Single State File

`docs/sessions/CURRENT.md` is the **single source of truth** for:
- Current task/plan
- Key decisions made
- Open questions
- Blockers
- Session history

### Agent Delegation

Claude asks before delegating to specialist agents:
> "This looks like Rails-specific work - should I delegate to rails-expert?"

You control when to leverage specialists vs. work directly.

### ADRs (Architecture Decision Records)

Document significant decisions in `docs/architecture/decisions/`:
- Why you chose this approach
- What alternatives you considered
- What tradeoffs you accepted

Future you will thank you.

---

## Customization

### Add Your Own Agent

Create `~/.claude/agents/your-agent.md`:
```markdown
---
name: your-agent
description: What this does. When to delegate.
---

# Agent Name

Instructions...
```

### Add Your Own Command

Create `~/.claude/commands/your-command.md`:
```markdown
---
name: your-command
description: What this does.
---

# Command Name

Steps...
```

### Project-Specific Overrides

Put overrides in `.claude/agents/` or `.claude/commands/` within the project.

---

## What's Next

This toolkit covers:
- ✅ Phase 0: Session Initialization
- ✅ Phase 1: Context Loading

Still to refine in future sessions:
- Phase 2: Planning (/create-plan refinement)
- Phase 3: Development Cycle (TDD loop, agent dispatch)
- Phase 4: Quality Gates (review, test, commit)
- Phase 5: Session Handoff (further refinement)

---

## Philosophy

- **Colleague, not assistant**: Claude is an expert collaborator
- **Direct and technical**: No fluff, you'll ask if you need more
- **Explicit agent control**: Always asks before delegating
- **Living Architecture**: Planning balanced with flexibility
- **State persistence**: Resume seamlessly after days or weeks
