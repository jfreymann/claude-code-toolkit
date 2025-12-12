# Consider: Session Continuity

A framework for maintaining context across sessions, context window resets, and time gaps.

## The Continuity Challenge

Every session starts fresh. Claude has no memory of previous sessions. The challenge is capturing enough state that:

1. Future sessions can resume seamlessly
2. Context survives days or weeks of inactivity
3. Important decisions aren't lost
4. Work doesn't get repeated

## Session Lifecycle

```
┌─────────────────────────────────────────────────────────────┐
│                    SESSION LIFECYCLE                         │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  ┌──────────────┐                                           │
│  │ /bootstrap   │ ← Load context, assess staleness          │
│  └──────────────┘                                           │
│         │                                                    │
│         ▼                                                    │
│  ┌──────────────┐                                           │
│  │ /resume      │ ← Quick "where was I?" (optional)         │
│  └──────────────┘                                           │
│         │                                                    │
│         ▼                                                    │
│  ┌──────────────────────────────────────────────┐           │
│  │                                              │           │
│  │              WORK SESSION                    │           │
│  │                                              │           │
│  │   /implement → /pre-commit → /commit         │           │
│  │             ↓                                │           │
│  │   /update-state (periodically)               │           │
│  │                                              │           │
│  └──────────────────────────────────────────────┘           │
│         │                                                    │
│         ▼                                                    │
│  ┌──────────────┐                                           │
│  │ /whats-next  │ ← Capture state, prepare handoff          │
│  └──────────────┘                                           │
│         │                                                    │
│         ├───────────────────┐                               │
│         ▼                   ▼                               │
│  ┌──────────────┐   ┌────────────────┐                      │
│  │ End Session  │   │/archive-session│ ← If feature done    │
│  └──────────────┘   └────────────────┘                      │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

## Command Selection

| Scenario | Command | Notes |
|----------|---------|-------|
| Start of day | `/bootstrap` | Full context load |
| Return from short break | `/resume` | Quick refresh |
| Mid-session state capture | `/update-state` | Periodic save |
| End of session | `/whats-next` | Full handoff |
| Quick pause | `/whats-next --pause` | Minimal capture |
| Feature complete | `/whats-next --complete` | Marks done, suggests archive |
| Major milestone done | `/archive-session` | Archive and fresh start |

## Staleness Tiers

Time since last session affects how much context to reload:

| Tier | Gap | Brief Style | Key Actions |
|------|-----|-------------|-------------|
| 🟢 HOT | < 24h | Terse | Jump right in |
| 🟡 WARM | 1-7 days | Medium | Review state + decisions |
| 🟠 COOL | 8-30 days | Detailed | Full context refresh |
| 🔴 COLD | > 30 days | Full + verify | Check environment too |
| ⚪ NEW | No prior | Setup | Initialize project state |

### HOT Session (< 24 hours)

Context is fresh. Minimal ceremony needed.

```
Quick state check → Continue working
```

### WARM Session (1-7 days)

Need to refresh key decisions and current state.

```
Load context → Review what's happening → Review decisions → Continue
```

### COOL Session (8-30 days)

Significant gap. Need full context reload.

```
Full bootstrap → Review session history → Check git state → Possibly re-orient
```

### COLD Session (> 30 days)

Long gap. Environment may have drifted.

```
Full bootstrap → Check environment → Verify dependencies → May need to rebuild mental model
```

## State Files

### CURRENT.md - Single Source of Truth

Lives at `docs/sessions/CURRENT.md`. Contains:

```markdown
## Quick Reference      ← At-a-glance state
## What's Happening     ← Current context (2-3 sentences)
## Key Decisions        ← Important choices made
## Open Questions       ← Unresolved items
## Blockers             ← What's stopping progress
## Next Actions         ← Priority-ordered next steps
## Session History      ← Log of sessions
## Notes                ← Gotchas, reminders, scratch
```

### Plan Files

Active plan at `docs/plans/ACTIVE.md` (symlink). Contains:
- Task breakdown with checkboxes
- Phase structure
- "Continue Here" section with current position

### Project Context

`.claude/CLAUDE.md` contains project-specific context that doesn't change often:
- Tech stack
- Patterns and conventions
- File structure pointers
- References to deeper docs

## What to Capture

### Always Capture (Every Handoff)

- Current branch and uncommitted changes
- What you're in the middle of
- Immediate next step (specific and actionable)
- Any blockers

### Capture When Relevant

- Decisions made (especially "why" not just "what")
- Questions that came up
- Gotchas discovered
- Useful commands or snippets

### Don't Over-Capture

- Implementation details (they're in the code)
- Step-by-step logs (session history covers this)
- Things that are obvious from git history

## Handoff Quality

A good handoff answers these questions for future-you:

1. **What am I building?** → What's Happening
2. **Where did I stop?** → Next Actions, Session History
3. **What did I decide?** → Key Decisions
4. **What's blocking me?** → Blockers, Open Questions
5. **What should I do first?** → Next Actions[0]

### The "Weeks Later" Test

Imagine reading this handoff 3 weeks from now after working on other projects. Would you be able to:

- Understand what you were doing?
- Know exactly where to start?
- Recall why you made certain choices?
- Avoid re-solving problems you already solved?

## Anti-Patterns

### Too Little State

```markdown
## What's Happening
Working on auth.

## Next Actions
- Continue
```

**Problem**: No specifics. Future-you has no idea where to start.

### Too Much State

```markdown
## Session History
### 14:30 - Started working
### 14:32 - Opened file
### 14:33 - Added line 1
### 14:35 - Fixed typo
...
```

**Problem**: Signal buried in noise. Important info is lost.

### Stale State

State file not updated in days but work continued.

**Problem**: State diverged from reality. Handoff is misleading.

### Missing "Why"

```markdown
## Key Decisions
- Using OpenSSL
```

**Problem**: No rationale. Can't evaluate if decision still makes sense.

**Better**:
```markdown
## Key Decisions
- Using OpenSSL for cert generation (lightweight, no external deps, sufficient for our needs)
```

## Patterns for Long-Running Work

### The Checkpoint Pattern

For multi-day/week work, create explicit checkpoints:

```markdown
## Checkpoints

### ✓ Phase 1 Complete (2025-01-10)
- CA infrastructure working
- Server accepts certs
- See: abc123...def456

### → Phase 2 In Progress
- Agent-side implementation
- Current: Task 2.2 (client cert loading)
```

### The Decision Log Pattern

For work with many decisions:

```markdown
## Key Decisions

### Architecture
- mTLS over API keys (see ADR-002)
- Single CA for v1

### Implementation
- OpenSSL for cert ops (no gems)
- Chain caching disabled (simplicity > perf for v1)

### Deferred
- [ ] CRL vs OCSP - decide when we hit revocation task
```

### The Breadcrumb Pattern

Leave specific markers for where to resume:

```markdown
## Next Actions
1. **Resume at**: `app/services/cert_validator.rb:45`
   - In `verify_chain` method
   - Just added the loop, need to handle expired certs
   - Test to write: `spec/services/cert_validator_spec.rb` expired chain case
```

## Context Window Management

When context window fills up:

1. **Before reset**: Run `/whats-next --pause` to capture state
2. **After reset**: Run `/resume` to reload essentials
3. **If complex**: Run full `/bootstrap`

### What to Load After Reset

| Staleness | Load |
|-----------|------|
| Just reset | CURRENT.md Quick Reference + Next Actions |
| Been a while | CURRENT.md fully + Plan if active |
| Complex work | Full bootstrap with project context |

## Integration with Other Commands

### With Planning

```
/create-plan → Creates plan → Links in CURRENT.md
/update-plan → Updates plan → Syncs with CURRENT.md
/whats-next  → Updates both CURRENT.md and plan
```

### With Git

```
/commit      → Creates commit
/whats-next  → Notes commits in session history
             → Warns about uncommitted changes
```

### With Quality Gates

```
/pre-commit  → Run before commit
/commit      → Clean commit
/whats-next  → Captures final state
             → Suggests git-workflow-manager if PR ready
```

## Questions to Ask

### At Session Start
- How long since last session?
- Is state file current?
- Are there uncommitted changes to understand?
- What's the first priority?

### At Session End
- What did I accomplish?
- Where exactly did I stop?
- What decisions did I make?
- What's the next specific step?
- Are there uncommitted changes?

### Before Context Reset
- Did I capture current state?
- Will I know where to resume?
- Are important decisions documented?
