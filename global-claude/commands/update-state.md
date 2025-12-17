---
name: update-state
description: Quick update to CURRENT.md during a session. Use for capturing decisions, completing tasks, or noting blockers.
---

# Update State

Quickly update `docs/sessions/CURRENT.md` during a work session without full handoff.

## When to Use

- Completed a task in the plan
- Made a key decision worth recording
- Hit a blocker
- Want to capture context before stepping away briefly
- Switching focus within the same session

## Usage

```
/update-state                           # Interactive - ask what to update
/update-state task complete             # Mark current task complete, advance to next
/update-state decision "chose X over Y" # Log a decision
/update-state blocker "waiting on API"  # Note a blocker
/update-state note "remember to..."     # Add to Notes section
/update-state question "should we...?"  # Add open question
```

---

## Update Types

### Task Progress

```
/update-state task complete
```

Actions:
1. Update Quick Reference → Task to next task number
2. Update Status → IN_PROGRESS (or COMPLETE if last task)
3. Add Session History entry:
   ```markdown
   ### {TIMESTAMP} - Task {N} Complete
   - Completed: {task name}
   - Next: Task {N+1} - {next task name}
   ```

```
/update-state task blocked
```

Actions:
1. Update Status → BLOCKED
2. Prompt for blocker description
3. Add to Blockers section

---

### Key Decision

```
/update-state decision "Using OpenSSL over cfssl for simplicity"
```

Actions:
1. Append to "Key Decisions (This Work)" section:
   ```markdown
   - Using OpenSSL over cfssl for simplicity
   ```

---

### Blocker

```
/update-state blocker "Waiting on DevOps for cert signing"
```

Actions:
1. Update Blockers section (replace "None" if present)
2. Update Status → BLOCKED
3. Add Session History entry

```
/update-state blocker resolved
```

Actions:
1. Clear Blockers section (set to "None")
2. Update Status → IN_PROGRESS
3. Add Session History entry

---

### Open Question

```
/update-state question "Should certs auto-rotate?"
```

Actions:
1. Append to "Open Questions" section

```
/update-state question answered "Manual rotation for v1"
```

Actions:
1. Remove question from Open Questions
2. Optionally add to Key Decisions

---

### Quick Note

```
/update-state note "Check TimescaleDB extension on test DB"
```

Actions:
1. Append to Notes section (bottom of CURRENT.md)

---

### Git State Sync

```
/update-state sync
```

Actions:
1. Update Quick Reference with current git state:
   - Branch
   - Uncommitted file count
   - Last commit
2. Run quick test count if test runner detected
3. Update timestamp

---

## Auto-Updates

The following are updated automatically on any `/update-state` call:

1. `Last updated` timestamp in header
2. Quick Reference → Uncommitted (from git status)
3. Quick Reference → Branch (from git)

---

## Session History Entry Format

All updates add to Session History:

```markdown
### {TIMESTAMP} - {Update Type}
- {Details}
```

Keep Session History trimmed to last 10-15 entries. Older entries are summarized or removed on `/archive-session`.

---

## Example Session Flow

```
# Start session
/bootstrap

# Work on task, make a decision
/update-state decision "Using service object pattern for validation"

# Complete task
/update-state task complete

# Hit a blocker
/update-state blocker "Need to understand cert chain requirements"

# Resolve and continue
/update-state blocker resolved

# Quick note for later
/update-state note "Refactor the error handling in validator after feature complete"

# End session
/end-session
```

---

## Integration

### In the Session Lifecycle

```
/bootstrap    → Start session
    ↓
/update-state → Periodic state capture (mid-session)
    ↓
/end-session   → End session with full handoff
```

### Frequency

| Situation | Update Frequency |
|-----------|------------------|
| Long task | Every 30-60 minutes |
| After completing sub-tasks | Each completion |
| After decisions | Immediately |
| Before breaks | Quick sync |
| Before risky operations | Capture current state |

### With Plans

When you complete a task:
1. `/update-state task complete` updates CURRENT.md
2. Also updates the active plan (marks task complete)
3. Advances "Continue Here" in plan

### With /commit

After committing:
```bash
/commit                           # Creates commit
/update-state sync               # Updates CURRENT.md with commit info
```

Or let `/end-session` capture commits at session end.

### Why Not Just /end-session?

| Command | Purpose | When |
|---------|---------|------|
| `/update-state` | Quick state capture | During work |
| `/end-session` | Full handoff | End of session |

`/update-state` is lightweight - just update one thing and continue working.
`/end-session` is comprehensive - summarize session, prepare for resumption.
