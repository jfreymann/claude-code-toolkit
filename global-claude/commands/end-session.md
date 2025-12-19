---
name: end-session
description: Session handoff with state capture. Updates CURRENT.md and prepares for seamless resumption.
---

# End Session - Session Handoff

Capture session state and prepare handoff for future resumption. Updates `docs/sessions/CURRENT.md` with everything needed to continue seamlessly.

## Modes

| Mode | When | What It Does |
|------|------|--------------|
| `--pause` | Quick break, will return soon | Minimal update, note stopping point |
| (default) | End of session | Full handoff with summary |
| `--complete` | Task/feature done | Marks completion, suggests archive |

## When to Use

- **End of work session** → `/end-session`
- **Quick break (lunch, meeting)** → `/end-session --pause`
- **Completed a task/feature** → `/end-session --complete`
- **Before switching projects** → `/end-session`
- **Context window getting full** → `/end-session --pause`

**⚠️ Best Practice:** Run `/update-state` BEFORE `/end-session` to capture decisions and progress during your session. If you forget, `/end-session` will remind you.

---

## Execution

### Step 0: State Freshness Check

**CRITICAL: Before ending session, ensure CURRENT.md has been kept up to date.**

Check when CURRENT.md was last updated:

```bash
# Get last modification time
CURRENT_MOD=$(stat -f %m docs/sessions/CURRENT.md 2>/dev/null || stat -c %Y docs/sessions/CURRENT.md 2>/dev/null)
NOW=$(date +%s)
HOURS_SINCE_UPDATE=$(( ($NOW - $CURRENT_MOD) / 3600 ))
```

**Staleness criteria:**

| Hours Since Update | Action |
|-------------------|--------|
| < 1 hour | Proceed normally |
| 1-3 hours | Soft suggestion to update |
| > 3 hours | Strong recommendation to update first |

**If stale (> 1 hour), prompt user:**

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 ⚠️  CURRENT.md MIGHT BE STALE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

 CURRENT.md was last updated {HOURS_SINCE_UPDATE} hours ago.

 Have you captured recent work in CURRENT.md?
 • Key decisions made this session?
 • What's happening now vs. {hours} ago?
 • Open questions discovered?

 Running /update-state first ensures you don't lose context.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

**Then ask with AskUserQuestion:**
- Question: "Update CURRENT.md before ending session?"
- Options:
  1. "Yes - run /update-state first (Recommended)" (description: "Capture recent decisions and progress before ending")
  2. "No - CURRENT.md is already up to date" (description: "Skip to session end handoff")
  3. "I'll update it manually now" (description: "End session will wait while you update")

**If option 1:** Stop and tell user to run `/update-state` first, then come back to `/end-session`

**If option 2:** Proceed with session end

**If option 3:** Wait for user to update CURRENT.md, then proceed

**Note:** In `--pause` mode, skip this check (pauses are quick by nature).

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
3. Suggest next steps (PR, next task)
4. Offer to run full test suite

**Archive suggestions:**

Only suggest `/archive-session` if ALL these conditions are met:
- Entire plan complete (not just one task)
- Plan represents weeks of work (10+ session entries)
- No more tasks in current work stream
- User explicitly says "entire X system done"

**Otherwise:** Just complete the session normally. CURRENT.md persists for next bootstrap.

**Example outputs:**

```
# Single task complete (NO archive suggestion)
✓ Task complete: User authentication endpoint
→ Next: Run tests, then "push code" to create PR
→ CURRENT.md will persist for next session

# Entire major feature complete (suggest archive)
✓ All authentication system tasks complete!
→ This was a major milestone (12 sessions, 3 weeks)
→ Consider /archive-session to start fresh
```

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

### With /update-state

**Best Practice Flow:**

```
During work session:
  Work → make progress → /update-state  (capture decisions)
  Work → more progress → /update-state  (capture more decisions)
  Work → task done → /update-state      (final capture)
                   ↓
              /end-session               (creates handoff from fresh state)
```

**Why this matters:**
- `/update-state` = Capture decisions/progress DURING work
- `/end-session` = Create handoff AFTER work captured

If CURRENT.md is stale (> 1 hour old), `/end-session` will prompt you to run `/update-state` first.

**When to skip the prompt:**
- Using `--pause` mode (quick breaks)
- Just ran `/update-state` in last hour
- Explicitly know CURRENT.md is up to date

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
/end-session saves → CURRENT.md ← /resume loads
```

### With /archive-session

**IMPORTANT: Archive is RARE, not routine.**

```
Typical daily flow (NO archive):
/end-session → CURRENT.md persists → /bootstrap next day

Major milestone flow (rare):
/end-session --complete
    ↓
Check: Major milestone? (weeks of work, 10+ sessions, entire system done)
    ↓
If yes: /archive-session
If no: Done, CURRENT.md persists
```

**Do NOT suggest archive for:**
- Single PR merged
- One task complete
- Daily/weekly work

**Only suggest archive for:**
- Entire feature complete (weeks of work)
- 10+ session entries in CURRENT.md
- Starting completely new project area

---

## Usage

```bash
/end-session              # Full session handoff
/end-session --pause      # Quick pause, minimal update
/end-session --complete   # Task/feature finished
/end-session --quick      # Update state, minimal output
```
