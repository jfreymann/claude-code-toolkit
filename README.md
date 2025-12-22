# Claude Code Agentic Workflow Toolkit

> A complete framework for agentic development with Claude Code. Persistent state, seamless session continuity, and a structured workflow that always knows what's next.

## The Philosophy

**Every session should pick up exactly where you left off.** No re-explaining. No lost context. No "where was I?"

This toolkit provides:
- **Persistent state** - Session context that survives across days, weeks, or months
- **Clear workflow** - Always know what to do next
- **Quality gates** - Consistent quality without ceremony overhead
- **Expert agents** - Specialized help when you need it

---

## The Workflow

This is the heart of the toolkit. A simple, repeatable flow for any project:

```
┌──────────────────────────────────────────────────────────────────┐
│                     THE PERFECT WORKFLOW                         │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│  START SESSION                                                   │
│  ─────────────                                                   │
│  /bootstrap          Load full context, see what's next          │
│       or                                                         │
│  /resume             Quick "where was I?" (returning from break) │
│                                                                  │
│                              │                                   │
│                              ▼                                   │
│  WORK ───────────────────────────────────────────────────────────│
│                                                                  │
│  /implement          Work on current task                        │
│       ↓                                                          │
│  /update-state       Capture decisions, progress (do this!)      │
│       ↓                                                          │
│  /pre-commit         Quality checks (lint, tests, branch safety) │
│       ↓                                                          │
│  /commit             Clean commit (auto-creates branch if needed)│
│                                                                  │
│  💡 CURRENT.md persists - keeps context across many sessions     │
│                                                                  │
│  ┌────────────────────────────────────────────────────┐          │
│  │  CONTEXT HYGIENE (Every 2 hours or when stuck)     │          │
│  │  /context-check  Check context health              │          │
│  │  /clean-slate    Compress & restart if needed      │          │
│  └────────────────────────────────────────────────────┘          │
│                                                                  │
│  ────────────────────────────────────────────────────────────────│
│                              │                                   │
│                              ▼                                   │
│  END SESSION                                                     │
│  ───────────                                                     │
│  /end-session         Save state (CURRENT.md persists!)          │
│       or                                                         │
│  /end-session --pause Quick save (lunch break)                   │
│                                                                  │
│  💡 CURRENT.md persists for next /bootstrap                      │
│                                                                  │
│                              │                                   │
│                              ▼                                   │
│  READY FOR PUSH? ────────────────────────────────────────────────│
│                                                                  │
│  "push code"              Triggers git-workflow-manager          │
│                           (branch, push, create PR, cleanup)     │
│                                                                  │
│  After PR merged: "post-merge cleanup"                           │
│                   Auto-updates CURRENT.md! ✨                    │
│                   (git-workflow-manager handles this)            │
│                                                                  │
│                              │                                   │
│                              ▼                                   │
│  MAJOR MILESTONE? (weeks of work, 10+ PRs) ──────────────────────│
│                                                                  │
│  /archive-session    Archive CURRENT.md, start completely fresh  │
│                      (RARE - only for major milestones!)         │
│                                                                  │
└──────────────────────────────────────────────────────────────────┘
```

### The Key Insight

**State is always saved.** After every session, CURRENT.md contains:
- What you were working on
- What decisions you made
- What's blocking you
- What to do next

**Next session picks up seamlessly.** `/bootstrap` reads that state and adapts:

| Time Away | What Happens |
|-----------|--------------|
| < 24 hours | Quick 3-line status, jump right in |
| 1-7 days | Key decisions refreshed, state summary |
| 8-30 days | Full context reload, detailed briefing |
| > 30 days | Environment verification suggested |

### Context Hygiene

**Keep context fresh for clearer thinking.** Even with auto-summarization, proactive compression improves productivity:

**Monitor context health:**
- Run `/context-check` for quick health assessment
- Based on session duration: 🟢 0-1hr | 🟡 1-2hrs | 🟠 2-3hrs | 🔴 3+hrs

**Compress when needed:**
- Run `/clean-slate` when context feels cluttered
- After 2+ hours of work (the "2-hour rule")
- When stuck or repeating failed approaches
- Before switching from exploration to implementation

**Result:**
- Fresh mental model without lost insights
- Better decision making
- Faster problem solving
- No context "baggage"

---

## Quick Start

```bash
# 1. Clone the toolkit
cd ~
git clone https://github.com/YOUR_USERNAME/claude-code-toolkit.git

# 2. Run the installer
cd claude-code-toolkit
./install.sh

# 3. Customize your identity
code ~/.claude/CLAUDE.md   # Look for 🔧 markers

# 4. Set up a project
cd /path/to/your-project
~/claude-code-toolkit/init-project.sh

# 5. Start your first session
claude
/bootstrap
```

**[Full setup guide →](SETUP.md)**

---

## Commands Reference

### Session Lifecycle

| Command | When | What It Does |
|---------|------|--------------|
| `/bootstrap` | Start of day, switching projects | Full context load, adaptive briefing |
| `/resume` | Quick return (< few hours) | Lightweight "where was I?" |
| `/update-state` | **During work** (important!) | Capture decisions/progress as you work |
| `/end-session` | End of session | Full handoff, save state (CURRENT.md persists) |
| `/end-session --pause` | Quick break | Minimal state save (checks staleness) |
| `/end-session --complete` | Task/feature done | Mark complete, suggest next steps |
| `/archive-session` | **Major milestone** (rare!) | Archive CURRENT.md, start fresh (10+ sessions) |
| `/clean-slate` | Context cluttered, stuck, 2+ hours | Compress context, restart fresh |
| `/context-check` | Periodic check | Quick **context health** assessment |

### Planning

| Command | When | What It Does |
|---------|------|--------------|
| `/create-plan` | Starting multi-session work | Create implementation plan |
| `/update-plan` | During planned work | Track progress, complete tasks |

### Development

| Command | When | What It Does |
|---------|------|--------------|
| `/implement` | Working on a task | Structured implementation workflow |
| `/pre-commit` | Before committing | Lint, tests, security checks, **branch safety** |
| `/commit` | Ready to commit | **Auto-creates branch** if on main, clean commit |
| `/run-tests` | Anytime | Execute and interpret tests |
| `/add-tests` | After implementation | Add tests to working code |
| `/test-first` | When spec is clear | TDD workflow |
| `/fix-test` | Tests failing | Debug and fix tests |

**Branch Safety:** `/commit` automatically creates a feature branch if you're on main/master. It uses CURRENT.md context to suggest a smart branch name (e.g., "feature/workflow-improvements"). You can accept the suggestion or provide your own.

**State Management:** `/update-state` captures decisions and progress during work. **Post-merge cleanup automatically updates CURRENT.md** with latest commit and branch state. `/end-session` checks if CURRENT.md is stale (> 1 hour old) and prompts you to update first. This keeps context rich for next `/bootstrap`.

### Quality & Review

| Command | When | What It Does |
|---------|------|--------------|
| `/review` | Before PR | Self-review for quality |
| `/security-review` | Auth/sensitive code | Security-focused analysis |

### Documentation

| Command | When | What It Does |
|---------|------|--------------|
| `/create-adr` | Architecture decision | Document decision with rationale |
| `/add-to-todos` | Future work identified | Track for later |
| `/check-todos` | Planning time | Review outstanding items |

### Mental Models (`/consider:*`)

Reference docs for decision-making:

| Model | Purpose |
|-------|---------|
| `session-continuity` | Best practices for state management |
| `quality-gates` | When to apply which checks |
| `testing-strategy` | What to test, when, how |
| `agent-dispatch` | When to engage specialist agents |

---

## The State System

### CURRENT.md - Your Session Memory

Lives at `docs/sessions/CURRENT.md`. This is the **single source of truth** for session state:

```markdown
## Quick Reference
- **Branch**: feature/user-auth
- **Plan**: User Authentication (Task 3/7)
- **Status**: IN_PROGRESS
- **Uncommitted**: 2 files

## What's Happening
Implementing JWT token validation. Basic structure done,
now adding expiry checking and refresh logic.

## Key Decisions
- JWT over session cookies (stateless, scales better)
- 15min access token, 7day refresh token

## Next Actions
1. Complete refresh token endpoint
2. Add token expiry tests
3. Update API docs
```

### The Flow

```
/end-session saves → CURRENT.md ← /bootstrap loads
                        ↑
              /update-state updates
```

### Project Structure

```
your-project/
├── .claude/
│   └── CLAUDE.md              # Project context (tech stack, patterns)
├── docs/
│   ├── sessions/
│   │   ├── CURRENT.md         # Active session state
│   │   └── archive/           # Completed feature sessions
│   ├── plans/
│   │   ├── ACTIVE.md          # → symlink to current plan
│   │   └── *.md               # Implementation plans
│   └── architecture/
│       └── decisions/         # ADRs
└── TO-DOS.md                  # Future work tracking
```

---

## Expert Agents

Specialized agents for domain work. Claude asks before delegating.

| Agent | Domain | Use For |
|-------|--------|---------|
| `rails-expert` | Ruby on Rails | Service objects, patterns, performance |
| `postgres-expert` | PostgreSQL | Schema design, queries, optimization |
| `tailwind-expert` | Tailwind CSS | Layouts, design systems, animations |
| `bash-expert` | Shell | Complex scripts, automation |
| `git-workflow-manager` | Git | Rebases, conflicts, branch prep, push workflows |
| `code-reviewer` | Review | Quality, security, pre-merge |

**Special**: `git-workflow-manager` is triggered when you say **"push code"**. It ensures your work is never pushed to main/master - always creates a feature branch first.

**Branch Safety**: `/commit` and `/pre-commit` also protect against committing directly to main/master. If you're on a protected branch, they'll prompt you to create a feature branch before proceeding.

### The "Big Dog" Pattern

`git-workflow-manager` handles everything needed to get code from local commits to PR-ready:

```
Local commits ready (via /commit)
        │
        ▼
┌─────────────────────────────┐
│   git-workflow-manager      │
│                             │
│   • Rebase onto main        │
│   • Resolve conflicts       │
│   • Squash WIP commits      │
│   • Push with safety        │
│   • Create backups          │
└─────────────────────────────┘
        │
        ▼
   Branch ready for PR
```

---

## Customization

### Your Identity (`~/.claude/CLAUDE.md`)

Customize sections marked with 🔧:

```markdown
## Identity

### Who I Am
- **Name**: [Your Name]
- **Role**: [Your Role]  
- **Focus Areas**: [Your domains]

### How I Work
- **Philosophy**: [Your approach]

### Collaboration Style
- Colleague (default) | Assistant | Mentor
```

### Adding Agents

Add to `~/claude-code-toolkit/global-claude/agents/`:

```markdown
---
name: vue-expert
description: Vue.js development
---

# Vue Expert

You are a Vue.js specialist...
```

---

## Example: A Perfect Day

```bash
# Morning - Start fresh
claude
/bootstrap

# Output:
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# guardian │ feature/mtls-auth │ 🟡 WARM (3 days)
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 
# WHAT'S HAPPENING
# Implementing mTLS certificate verification.
# Stopped mid-implementation of chain validation.
#
# NEXT ACTIONS
# → Complete verify_chain in CertificateValidator
#
# → Continue with this?

# Work on the task
/implement "Complete verify_chain method"

# Make some commits
/pre-commit
/commit

# Lunch break
/end-session --pause

# Return
/resume

# More work...
/implement
/pre-commit
/commit

# End of day
/end-session

# Output:
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# SESSION HANDOFF COMPLETE
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 
# This Session:
# • Completed certificate chain validation
# • Added tests for expired certs
# 
# State: feature/mtls-auth │ Clean │ Tests: 67 passing
# 
# Next Session Priority:
# → Implement revocation checking

# Tomorrow, /bootstrap picks up exactly here.
```

---

## What's Included

```
claude-code-toolkit/
├── install.sh                  # Creates symlinks to ~/.claude/
├── init-project.sh             # Project initializer
│
├── global-claude/              # → ~/.claude/
│   ├── CLAUDE.md              # Identity template (copied)
│   ├── agents/                # Expert agents
│   ├── commands/              # Workflow commands
│   │   ├── bootstrap.md
│   │   ├── resume.md
│   │   ├── end-session.md
│   │   ├── update-state.md
│   │   ├── archive-session.md
│   │   ├── create-plan.md
│   │   ├── update-plan.md
│   │   ├── implement.md
│   │   ├── pre-commit.md
│   │   ├── commit.md
│   │   ├── run-tests.md
│   │   ├── add-tests.md
│   │   ├── test-first.md
│   │   ├── fix-test.md
│   │   ├── review.md
│   │   ├── security-review.md
│   │   ├── create-adr.md
│   │   ├── add-to-todos.md
│   │   ├── check-todos.md
│   │   └── consider/          # Mental models
│   │       ├── session-continuity.md
│   │       ├── quality-gates.md
│   │       ├── testing-strategy.md
│   │       └── agent-dispatch.md
│   └── skills/                # User skills
│
├── project-templates/         # Per-project templates
│   ├── project-CLAUDE.md     # → .claude/CLAUDE.md
│   ├── CURRENT.md            # → docs/sessions/CURRENT.md
│   ├── PLAN-TEMPLATE.md      # Plan structure
│   └── ADR-TEMPLATE.md       # Decision record structure
│
└── examples/                  # Example configurations
    └── guardian/
```

---

## FAQ

**Q: Does this work with any project type?**  
A: Yes. The workflow is language/framework agnostic. Customize agents for your stack.

**Q: What if I forget to run /end-session?**
A: Your work is in git. Next `/bootstrap` will detect uncommitted changes and help you reconstruct state.

**Q: Can I use this with a team?**  
A: Global `~/.claude/` is personal. Project files (`.claude/`, `docs/`) can be committed and shared.

**Q: How do I update the toolkit?**  
A: `cd ~/claude-code-toolkit && git pull`. Symlinks pick up changes automatically.

**Q: What if I want to add my own commands?**  
A: Add to `~/claude-code-toolkit/global-claude/commands/`. For full control, fork the repo.

---

## Contributing

Contributions welcome:
- New agents for popular frameworks
- Workflow improvements
- Better documentation
- Bug fixes

---

## Credits

Built with inspiration from:
- [Anthropic's Claude Code](https://claude.ai/code)
- [obra/superpowers](https://github.com/obra/superpowers)
- The Claude Code community

---

## License

MIT - Use it, modify it, share it.
