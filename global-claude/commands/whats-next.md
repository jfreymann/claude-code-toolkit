---
name: whats-next
description: Session handoff with state capture. Updates CURRENT.md and prepares for seamless resumption.
---

# What's Next - Session Handoff

Capture session state and prepare handoff for future resumption. Updates `docs/sessions/CURRENT.md` with everything needed to continue seamlessly.

## Modes

| Mode | When | What It Does |
|------|------|--------------|
| `--pause` | Quick break, will return soon | Minimal update, note stopping point |
| (default) | End of session | Full handoff with summary |
| `--complete` | Task/feature done | Marks completion, suggests archive |

## When to Use

- **End of work session** → `/whats-next`
- **Quick break (lunch, meeting)** → `/whats-next --pause`
- **Completed a task/feature** → `/whats-next --complete`
- **Before switching projects** → `/whats-next`
- **Context window getting full** → `/whats-next --pause`

---

## Execution

### Step 1: Gather Session Context

Analyze what happened this session:

```bash
# Git state
BRANCH=$(git branch --show-current)
UNCOMMITTED=$(git status --porcelain | wc -l)
LAST_COMMIT=$(git log -1 --format="%h - %s")

# Commits this session (if session start time known)
COMMITS_THIS_SESSION=$(git log --oneline --since="{session_start}" | wc -l)

# Test status (if recently run)
# Check for test output in recent commands
```

Review conversation for:
- What was accomplished?
- What decisions were made?
- What questions came up?
- What's the logical next step?

### Step 2: Assess Completion State

| Indicator | Likely State |
|-----------|--------------|
| All plan tasks done | COMPLETE → suggest archive |
| Tests passing, task done | READY_FOR_REVIEW |
| Mid-implementation | IN_PROGRESS |
| Waiting on decision/info | BLOCKED |
| Just started | IN_PROGRESS |

### Step 3: Update CURRENT.md

#### Quick Reference
```markdown
## Quick Reference
- **Branch**: {current branch}
- **Plan**: {path to active plan or "None"}
- **Task**: {current task X of Y, or "None"}
- **Status**: {IN_PROGRESS|BLOCKED|READY_FOR_REVIEW|COMPLETE}
- **Tests**: {X passing, Y failing, Z pending}
- **Uncommitted**: {N files, or "Clean"}
```

#### What's Happening
Update with current context - concise summary of where things stand.

#### Key Decisions
Append any new decisions made this session.

#### Open Questions
Add unresolved questions. Remove any that were answered.

#### Blockers
Update blocker status. Clear if resolved.

#### Next Actions
**Most critical section** - drives the next session.

Format as specific, actionable items:
```markdown
## Next Actions
1. **Immediate**: {specific next step with file/method name}
2. {Following step}
3. {Lower priority item}

💡 {Any gotcha or reminder for next session}
```

### Step 4: Add Session History Entry

Add to **top** of Session History:

```markdown
### {TIMESTAMP} - Session End
- **Duration**: ~{estimated time}
- **Completed**: 
  - {completed item 1}
  - {completed item 2}
- **Commits**: 
  - {hash} - {message}
- **Stopped at**: {where work paused - be specific}
- **Next**: {first priority for resumption}
```

### Step 5: Integration Checks

#### Plan Progress
If active plan, update task status:
```bash
# Check docs/plans/ACTIVE.md
# Update task checkboxes if any completed
# Update "Continue Here" section
```

#### Git State Warning
If uncommitted changes:
```
⚠️  {N} uncommitted files - consider committing before ending session
→ Run /pre-commit then /commit?
```

If branch behind main:
```
⚠️  Branch is {N} commits behind main
→ Next session should start with rebase
```

#### Test State
If tests not recently run:
```
💡 Tests not run this session - consider running before handoff
→ Run /run-tests?
```

### Step 6: Offer Appropriate Actions

Based on state:

**If IN_PROGRESS with uncommitted changes:**
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 SESSION HANDOFF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

 This Session:
 • Implemented certificate chain walking
 • Added tests for intermediate cert validation
 
 Commits:
 • def456 - Add intermediate cert support
 
 ⚠️  2 uncommitted files remaining
 
 State: feature/mtls-auth │ IN_PROGRESS │ Task 4/7
 
 Next Session Priority:
 → Complete verify_chain edge case handling

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Options:
 [c]ommit changes first │ [s]ave and exit │ [r]un tests
```

**If task/feature COMPLETE:**
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 ✓ FEATURE COMPLETE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

 mTLS Agent Authentication - All tasks complete!
 
 This Session:
 • Completed final task: Agent-side verification
 • All tests passing (67 examples, 0 failures)
 
 Branch: feature/mtls-auth │ Clean │ Ready for PR

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Ready for next steps:
 → Prepare branch for PR with git-workflow-manager
 → Archive this session (/archive-session)
 → Start security review (/security-review)
```

**If BLOCKED:**
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 ⚠️  SESSION BLOCKED
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

 Blocker: Waiting for decision on revocation strategy
 
 Options documented:
 1. CRL-based checking (simpler, may have latency)
 2. OCSP (real-time, more complex)
 
 This Session:
 • Researched both approaches
 • Documented trade-offs in ADR draft
 
 When Unblocked:
 → Implement chosen revocation check
 → Update CertificateValidator#verify_chain

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 State saved. Blocker noted in CURRENT.md.
```

---

## Pause Mode (--pause)

For quick breaks - minimal ceremony:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 ⏸  PAUSED
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 
 Stopped at: verify_chain method, line 45
 2 uncommitted files
 
 To resume: /resume

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

Updates only:
- "What's Happening" with stopping point
- "Next Actions" with immediate next step
- Brief session history entry

---

## Complete Mode (--complete)

For finished tasks/features:

1. Mark current task complete in plan
2. Update plan progress
3. Suggest next steps (PR, archive, next task)
4. Offer to run full test suite
5. Check if entire plan is done → suggest archive

---

## Handoff Quality Checklist

A good handoff ensures the next session can resume without confusion:

✓ **Quick Reference** is accurate and current
✓ **What's Happening** explains state in 2-3 sentences
✓ **Next Actions** has specific, actionable first step
✓ **Open Questions** captures unresolved items
✓ **Session History** documents what happened
✓ **Blockers** are clearly noted with unblock conditions
✓ **Uncommitted changes** are either committed or noted

---

## Integration Points

### With Plans
- Updates task status in active plan
- Syncs plan progress with CURRENT.md
- Suggests next task when current completes

### With git-workflow-manager
If feature complete and ready for PR:
```
→ Ready for PR? Invoke git-workflow-manager to:
  • Rebase onto main
  • Squash commits if needed
  • Push and prepare for review
```

### With /resume
State saved here is what `/resume` loads:
```
/whats-next saves → CURRENT.md ← /resume loads
```

### With /archive-session
When work truly complete:
```
/whats-next --complete → suggests → /archive-session
```

---

## Usage

```bash
/whats-next              # Full session handoff
/whats-next --pause      # Quick pause, minimal update
/whats-next --complete   # Task/feature finished
/whats-next --quick      # Update state, minimal output
```
