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

---

## Context Hygiene

**Proactive context management prevents problems before they occur.**

Context isn't just about window limits - it's about mental clarity. Even with unlimited context, cluttered sessions make it harder to think clearly.

### The Context Hygiene Philosophy

```
Compressed context = Clearer thinking
Less clutter = Better decisions
Fresh start = New perspectives
```

### When to Compress Context

#### 🔴 Critical Signals (Act Now)

These mean you should run `/clean-slate` immediately:

- **Can't think clearly** - Decision making feels muddy or circular
- **Repeating failed approaches** - Trying the same thing 3+ times
- **Lost track of attempts** - Don't remember what you've tried
- **Context feels "heavy"** - Session feels overwhelming or cluttered
- **Stuck in a rut** - Keep hitting the same dead ends

#### 🟡 Warning Signs (Consider Compressing)

These suggest context compression would help:

- **Session > 2 hours** - Even if making progress
- **Read 30+ files** - Extensive exploration phase
- **Tried 5+ approaches** - Multiple failed debugging attempts
- **Hard to recall what worked** - Losing track of findings
- **About to switch mental models** - Exploration → implementation
- **Session >2hrs** - Per `/context-check` health assessment

#### 🟢 Preventive Patterns (Good Practice)

Proactive compression before problems emerge:

- **Finished exploration, starting implementation** - Clean break between phases
- **Found root cause, ready to fix** - Compress investigation, start fresh for solution
- **About to make architectural decision** - Clear head for important choices
- **Switching between unrelated tasks** - Clean slate for new context
- **Before major refactoring** - Fresh mental model for restructuring

### The Compression Workflow

```
┌─────────────────────────────────────────────────┐
│         CONTEXT COMPRESSION CYCLE               │
├─────────────────────────────────────────────────┤
│                                                 │
│  MONITOR                                        │
│  /context-check → Shows context health          │
│  ↓ "🟡 Getting full - Consider /clean-slate"    │
│                                                 │
│  ASSESS                                         │
│  Am I:                                          │
│  • Stuck or repeating myself?                   │
│  • Switching mental models?                     │
│  • Ready to implement after exploring?          │
│  ↓ Yes to any? Compress.                        │
│                                                 │
│  COMPRESS                                       │
│  /clean-slate                                   │
│  ↓ Saves insights, drops clutter                │
│  ↓ Exits session                                │
│                                                 │
│  RESUME                                         │
│  [Restart Claude Code]                          │
│  /bootstrap --quick                             │
│  ↓ Loads essentials, fresh context              │
│                                                 │
│  WORK                                           │
│  Continue with clear mental model               │
│  ↓ Make progress                                │
│  ↓ Monitor context health                       │
│  ↓ [cycle repeats as needed]                    │
│                                                 │
└─────────────────────────────────────────────────┘
```

### Three Compression Strategies

#### Strategy 1: The 2-Hour Rule

**Pattern:** Compress every 2 hours of active work, regardless of progress.

**Why:** Fresh context improves thinking even when not stuck.

**How:**
```
[Work for 2 hours]
/clean-slate

[Restart]
/bootstrap --quick
"Continue with [specific next task]"
```

**Best for:** Long exploration sessions, research-heavy work, complex debugging.

#### Strategy 2: Phase Transitions

**Pattern:** Compress when switching mental models.

**Common transitions:**
- Exploration → Implementation
- Debugging → Root cause fix
- Research → Architecture decision
- Planning → Execution

**How:**
```
[Finish exploration phase]
Found the issue: [describe root cause]
/clean-slate

[Restart]
/bootstrap --quick
"Implement fix for [root cause] in [file]"
```

**Best for:** Multi-phase work, TDD workflows, spike-then-implement patterns.

#### Strategy 3: Stuck Detection

**Pattern:** Compress when you notice you're stuck.

**Stuck indicators:**
- Tried same approach 3+ times
- Can't think of new approaches
- Keep forgetting what you already tried
- Decision paralysis

**How:**
```
[Realize you're stuck]
/clean-slate

[Restart]
/bootstrap --quick
"Review dead ends in CURRENT.md and suggest fresh approach"
```

**Best for:** Difficult bugs, unclear requirements, novel problems.

### What Gets Compressed

#### Preserved (Saved to CURRENT.md)

✅ **Keep:**
- Root causes and insights
- Key decisions with rationale
- Dead ends to avoid
- Next specific actions
- Critical file locations
- Important patterns discovered

#### Dropped (Intentionally Lost)

🗑️ **Drop:**
- Failed debugging attempts (details)
- Exploratory file reads (full content)
- Repeated explanations
- Tangential discussions
- Implementation details (in code now)
- Verbose error messages

#### Example: Before/After Compression

**Before Compression (47 messages, cluttered):**
```
[Tried approach A - failed]
[Read file X - not relevant]
[Tried approach B - failed]
[Read file Y - found pattern]
[Tried approach C - partial success]
[Explained pattern to user]
[User asked question]
[Explained again differently]
[Read file Z - confirmed pattern]
[Tried approach D - failed]
[Discussion about architecture]
[Back to approach C]
[Modified approach C - success!]
```

**After Compression (CURRENT.md essentials):**
```markdown
## What's Happening
Found race condition in token validator causing intermittent failures.
Modified approach C (add mutex lock) solved it.

## Key Decisions
- Use mutex over queue (simpler, sufficient for our load)
- Lock at validator level, not token level (prevents deadlock)

## Dead Ends
- ✗ Approach A: Caching made race worse
- ✗ Approach B: Queue added complexity, didn't help
- ✗ Approach D: Atomic operations insufficient

## Next Actions
1. Implement mutex fix in `app/services/token_validator.rb:45`
2. Add concurrency test to prevent regression
3. Document locking strategy in code comments
```

### Integration with Context Monitoring

Use `/context-check` to monitor context health throughout session:

```
# At session start
/bootstrap

# After 1 hour of work
/context-check
→ Shows: "🟢 Healthy - Session: 1.0 hours"
→ Continue working

# After 2 hours
/context-check
→ Shows: "🟡 Getting full - Session: 2.1 hours"
→ Consider compressing after current task

# After completing task
/clean-slate
```

### The Context Health Dashboard

Run `/context-check` regularly to see:

| Session Duration | Status | Action Needed |
|-----------------|--------|---------------|
| 0-1 hour | 🟢 Fresh/Healthy | None - continue normally |
| 1-2 hours | 🟡 Getting full | Consider compressing after task |
| 2-3 hours | 🟠 Nearly full | Recommend compressing soon |
| 3+ hours | 🔴 Critical | Strongly recommend compressing now |

### Common Patterns

#### Pattern: Debug → Compress → Implement

```
1. Debugging session (lots of exploration, 50+ messages)
   → Found root cause
   → /clean-slate

2. Fresh session (focused, 5 messages)
   → /bootstrap --quick
   → Implement fix
   → /commit
```

**Result:** Clear implementation without debugging clutter.

#### Pattern: Explore → Compress → Decide

```
1. Exploration (grepped 50 files, read 20 files)
   → Understand patterns
   → /clean-slate

2. Fresh session (clear thinking)
   → /bootstrap --quick
   → Make architectural decision
   → /create-adr
```

**Result:** Important decision made with clear head.

#### Pattern: Stuck → Compress → Fresh Perspective

```
1. Stuck on problem (tried 8 approaches, all failed)
   → Can't think clearly anymore
   → /clean-slate

2. Fresh session (new perspective)
   → /bootstrap --quick
   → "What did I try? What haven't I tried?"
   → Approach #9 succeeds
```

**Result:** Fresh eyes see what tired eyes missed.

### Anti-Patterns (What NOT to Do)

❌ **Don't wait for context to fill completely**
- Proactive compression is better than reactive
- Compress when thinking gets muddy, not when forced

❌ **Don't compress mid-thought**
- Finish current implementation unit first
- Or use `--keep-files` flag to save partial work

❌ **Don't compress without saving state**
- Always run `/clean-slate` (which saves state)
- Never just restart without capturing context

❌ **Don't over-compress**
- Don't compress every 30 minutes
- Some context continuity is valuable
- 2-hour rule is a good balance

❌ **Don't treat compression as failure**
- Compression is a tool, not an admission of defeat
- Professional developers manage cognitive load
- Fresh context is a competitive advantage

### Best Practices

✅ **The 2-Hour Check-in**
```
Set a timer for 2 hours. When it goes off:
1. Run /context-check
2. Assess: Am I making progress? Or stuck?
3. Decide: Continue or compress?
```

✅ **The Phase Transition**
```
When switching from exploration to implementation:
1. /clean-slate before starting implementation
2. Compress all research into clear next actions
3. Start implementation with fresh context
```

✅ **The Stuck Detector**
```
If you've tried the same thing 3 times:
1. Stop immediately
2. /clean-slate
3. Restart with fresh perspective
```

✅ **The End-of-Session Save**
```
Before ending your day:
1. /whats-next (saves full state)
2. Tomorrow: /bootstrap (loads everything)

Not /clean-slate - that's for mid-session compression
```

### FAQ

**Q: Won't I lose important context if I compress?**
A: No - `/clean-slate` saves all insights, decisions, and next actions to CURRENT.md. You lose clutter, not knowledge.

**Q: How is this different from /whats-next?**
A: `/whats-next` is for ending your session. `/clean-slate` is for continuing work with fresh context. Both save state, different purposes.

**Q: Should I compress every hour?**
A: No - that's over-compressing. Every 2 hours is a good baseline. Compress more if stuck, less if flowing.

**Q: What if I'm making progress?**
A: Progress is great! But even productive sessions benefit from compression. Fresh context = clearer thinking. The 2-hour rule applies regardless of progress.

**Q: Can I compress without restarting Claude?**
A: No - the value of compression comes from actually getting fresh context. Save state, restart, load essentials.

**Q: Will my uncommitted code be lost?**
A: No - `/clean-slate` will prompt you to commit first, or use `--keep-files` to save file contents to state.

---

## Summary: Context Hygiene Workflow

**Monitor:**
- Use `/context-check` to assess context health
- Watch for warning signs (stuck, >2 hours session)

**Compress:**
- Run `/clean-slate` when context gets cluttered
- Saves insights, drops clutter
- Exits session for fresh restart

**Resume:**
- Restart Claude Code
- Run `/bootstrap --quick`
- Load essentials, not full history

**Result:**
- Clearer thinking
- Better decisions
- No lost knowledge
- Improved productivity

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
