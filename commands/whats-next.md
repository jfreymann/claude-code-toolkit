---
name: whats-next
description: End-of-session handoff. Updates CURRENT.md with session summary and prepares for next session.
---

# What's Next - Session Handoff

Generate a session handoff by updating `docs/sessions/CURRENT.md` with everything needed to resume seamlessly.

## When to Use

- End of a work session
- Before stepping away for extended time
- Before switching to a different project
- Whenever you want to capture current state for continuity

## Execution

### Step 1: Gather Session Context

Analyze the current session:
- What was accomplished? (commits, completed tasks)
- What's the current state? (in-progress work, uncommitted changes)
- What decisions were made?
- What questions came up?
- What should happen next?

### Step 2: Git State Snapshot

```bash
# Current branch
git branch --show-current

# Uncommitted changes
git status --porcelain

# Recent commits this session (since session start from CURRENT.md)
git log --oneline --since="{session_start_time}"

# Last commit
git log -1 --format="%h - %s"
```

### Step 3: Update CURRENT.md

Update each section with current state:

#### Quick Reference
```markdown
## Quick Reference
- **Branch**: {current branch}
- **Plan**: {path to active plan or "None"}
- **Task**: {current task X of Y, or "None"}
- **Status**: {IN_PROGRESS|BLOCKED|READY_FOR_REVIEW|COMPLETE}
- **Tests**: {run test count - X passing, Y failing}
- **Uncommitted**: {N files, or "Clean"}
```

#### What's Happening
Update with current context - what are we in the middle of?

#### Key Decisions
Append any decisions made this session.

#### Open Questions
Add any unresolved questions that came up.

#### Blockers
Update if any blockers exist.

#### Next Actions
**Critical section** - This is what drives the next session.

List in priority order:
1. Immediate next task (specific and actionable)
2. Following tasks
3. Things to remember

### Step 4: Add Session History Entry

Add to the top of Session History:

```markdown
### {TIMESTAMP} - Session End
- **Duration**: ~{estimated time}
- **Completed**: {list of completed items}
- **Commits**: {commit hashes with messages}
- **Stopped at**: {where work paused}
- **Next**: {first priority for next session}
```

### Step 5: Offer Archive Check

If this session completed a major milestone:

"It looks like {feature/plan} might be complete. Would you like to archive this session? (/archive-session)"

Indicators of completion:
- All plan tasks marked complete
- Feature branch ready for merge
- User mentions "done" or "finished"

### Step 6: Present Summary

Output:
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 SESSION HANDOFF COMPLETE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

 This Session:
 • {accomplishment 1}
 • {accomplishment 2}
 
 Commits:
 • {hash} - {message}
 
 State: {branch} | {uncommitted count} uncommitted | Tests: {status}
 
 Next Session Priority:
 → {first next action}

 State saved to: docs/sessions/CURRENT.md
 
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## Usage

```
/whats-next                    # Full interactive handoff
/whats-next --quick            # Just update state, minimal output
```

---

## Handoff Quality Checklist

A good handoff ensures the next session (even weeks later) can resume without confusion:

✓ **Quick Reference** is accurate (branch, task, test status)
✓ **What's Happening** explains current work in 2-3 sentences
✓ **Next Actions** has specific, actionable first step
✓ **Open Questions** captures unresolved items
✓ **Session History** documents what happened
✓ **Notes** has any gotchas or reminders

---

## Example Output in CURRENT.md

After running `/whats-next`:

```markdown
# Current Session State
<!-- Last updated: 2025-01-10T17:45:00Z -->

## Quick Reference
- **Branch**: feature/mtls-agent-auth
- **Plan**: [mTLS Implementation](../plans/2025-01-10-mtls-implementation.md)
- **Task**: 4 of 7 - Certificate chain verification
- **Status**: IN_PROGRESS
- **Tests**: 52 passing, 0 failing, 2 pending
- **Uncommitted**: 2 files

---

## What's Happening
Implementing certificate chain verification for mTLS. The basic validation 
is working; now adding support for verifying the full chain back to the CA.
Left off mid-implementation of the chain walking logic.

---

## Key Decisions (This Work)
- Mutual TLS over API keys for agent auth
- OpenSSL for cert generation (not cfssl)
- Single CA for v1 (no intermediate CA support yet)
- Chain verification required for all agent connections

---

## Open Questions
- Should we cache validated cert chains for performance?

---

## Blockers
None

---

## Next Actions
1. Complete chain verification loop in CertificateValidator#verify_chain
2. Add tests for expired intermediate cert scenario
3. Handle CRL/revocation checking (or explicitly skip for v1)

---

## Session History

### 2025-01-10 17:45 - Session End
- **Duration**: ~3 hours
- **Completed**: Task 3 (certificate validation), started Task 4
- **Commits**: def5678 "Add certificate expiry validation"
- **Stopped at**: Mid-implementation of verify_chain method
- **Next**: Complete chain verification loop

### 2025-01-10 14:30 - Session Start
- Staleness: HOT
- Resumed Task 3 (certificate validation)
- 3 uncommitted files from previous session

---

## Notes
The OpenSSL::X509::Store#verify method does basic chain verification,
but we need custom logic for our specific CA structure.

Test command for manual cert verification:
openssl verify -CAfile ca.pem -untrusted intermediate.pem cert.pem
```
