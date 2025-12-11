# Project Templates

Templates for setting up a new project with the Claude Code toolkit.

## Files

| File | Install To | Purpose |
|------|------------|---------|
| `project-CLAUDE.md` | `.claude/CLAUDE.md` | Project context for Claude |
| `CURRENT.md` | `docs/sessions/CURRENT.md` | Session state tracking |
| `ADR-TEMPLATE.md` | `docs/architecture/decisions/` | Architecture decision template |
| `gitignore-template` | `.gitignore` (merge) | Optional gitignore additions |

## Quick Setup

```bash
cd your-project

# Create directory structure
mkdir -p .claude docs/sessions/archive docs/plans docs/architecture/decisions

# Copy templates
cp /path/to/project-templates/project-CLAUDE.md .claude/CLAUDE.md
cp /path/to/project-templates/CURRENT.md docs/sessions/CURRENT.md
cp /path/to/project-templates/ADR-TEMPLATE.md docs/architecture/decisions/

# Create TODO tracker
touch TO-DOS.md

# Customize project context
code .claude/CLAUDE.md
```

## Customization

### project-CLAUDE.md

Fill in these sections:
- **Overview**: 2-3 sentences about your project
- **Stack**: Core technologies
- **Key Patterns**: Project-specific conventions
- **Theme/Design**: Link to design docs (or remove if N/A)

### CURRENT.md

This file is mostly auto-updated by workflow commands. You may want to:
- Add initial "What's Happening" content
- Pre-populate any known blockers or questions
- Add notes in the Notes section

### ADR-TEMPLATE.md

Copy this template when creating new ADRs:
```bash
cp docs/architecture/decisions/ADR-TEMPLATE.md \
   docs/architecture/decisions/ADR-001-your-decision.md
```

## Directory Structure

After setup, your project should have:

```
your-project/
├── .claude/
│   └── CLAUDE.md                 # Project context
├── docs/
│   ├── sessions/
│   │   ├── CURRENT.md            # Active session state
│   │   └── archive/              # Completed sessions
│   ├── plans/
│   │   └── ACTIVE.md             # → symlink to current plan
│   ├── architecture/
│   │   └── decisions/            # ADRs
│   │       └── ADR-TEMPLATE.md
│   └── theme/                    # Design docs (optional)
└── TO-DOS.md                     # Task tracking
```
