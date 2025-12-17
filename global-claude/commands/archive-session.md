---
name: archive-session
description: Archive the current session state when a major feature is complete. Moves CURRENT.md to archive and starts fresh.
---

# Archive Session

Archive the current session state when completing a major feature or work stream.
This moves `docs/sessions/CURRENT.md` to the archive and creates a fresh state file.

## When to Use

- Major feature branch is complete and merged
- Significant milestone reached
- Starting a completely new area of work
- CURRENT.md has grown large with history

## Execution

### Step 1: Verify Ready to Archive

Check current state:
- Is the current work actually complete?
- Are there uncommitted changes that should be noted?
- Is there an active plan that should be closed?

Ask: "This will archive the current session state. The feature/work appears to be: {summary from CURRENT.md}. Ready to archive?"

### Step 2: Generate Archive Filename

Format: `YYYY-MM-DD-HHMMSS-{feature-summary}.md`

Example: `2025-01-10-143022-mtls-implementation.md`

The feature summary comes from:
1. Current branch name (sanitized)
2. Or plan name if active
3. Or "What's Happening" summary (slugified)

### Step 3: Add Completion Entry

Before archiving, add a final entry to Session History:

```markdown
### {TIMESTAMP} - Session Archived
- **Status**: COMPLETE
- **Branch**: {branch}
- **Final Commit**: {git log -1 --format="%h - %s"}
- **Summary**: {brief summary of what was accomplished}
```

### Step 4: Move to Archive

```bash
mv docs/sessions/CURRENT.md "docs/sessions/archive/{archive-filename}"
```

### Step 5: Create Fresh CURRENT.md

Create new state file from template:

```markdown
# Current Session State
<!-- Last updated: {TIMESTAMP} -->
<!-- Archive this file to docs/sessions/archive/ when a major feature completes -->

## Quick Reference
- **Branch**: {current branch, likely main after merge}
- **Plan**: None
- **Task**: None
- **Status**: NOT_STARTED
- **Tests**: Unknown
- **Uncommitted**: Clean

---

## What's Happening
<!-- Ready for new work -->

---

## Key Decisions (This Work)
- 

---

## Open Questions
- 

---

## Blockers
None

---

## Next Actions
1. Check TO-DOS.md for next priority
2. Or start new feature planning with /create-plan

---

## Session History

### {TIMESTAMP} - Fresh Start
- Archived previous session: {archive-filename}
- Ready for new work

---

## Notes

```

### Step 6: Handle Plan Symlink

If `docs/plans/ACTIVE.md` exists and points to the completed plan:

```bash
rm -f docs/plans/ACTIVE.md
```

### Step 7: Confirm

Output:
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 SESSION ARCHIVED
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 
 Archived: docs/sessions/archive/{archive-filename}
 Fresh state: docs/sessions/CURRENT.md
 
 Ready for new work. What's next?
 • Check TO-DOS.md
 • Start new feature (/create-plan)
 • Tell me what you'd like to work on
 
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## Usage

```
/archive-session                    # Interactive archive
/archive-session --name "mtls"      # Specify archive name suffix
```

---

## Integration

### In the Session Lifecycle

```
┌─────────────────────────────────────────────────────────────┐
│  FEATURE WORK                                                │
│                                                              │
│  /bootstrap → work → /end-session                            │
│       ↑                   │                                  │
│       └───────────────────┘                                  │
│           (repeat across sessions)                           │
└─────────────────────────────────────────────────────────────┘
                    │
                    │ Feature complete
                    ▼
┌─────────────────────────────────────────────────────────────┐
│  /archive-session                                            │
│                                                              │
│  • Moves CURRENT.md to archive/                             │
│  • Creates fresh CURRENT.md                                  │
│  • Clears ACTIVE.md plan link                               │
│  • Ready for new work                                        │
└─────────────────────────────────────────────────────────────┘
```

### When to Archive

| Indicator | Archive? |
|-----------|----------|
| All plan tasks complete | ✓ Yes |
| Feature branch merged | ✓ Yes |
| User says "done" / "finished" | ✓ Yes |
| Starting completely new work | ✓ Yes |
| CURRENT.md getting very long | ✓ Yes |
| Just pausing for a few days | ✗ No, use `/end-session` |
| Switching to different task in same project | ✗ No |

### With /end-session

`/end-session --complete` suggests archiving when appropriate:

```
/end-session --complete
    │
    ├─ All tasks done? → "Ready to archive?"
    │                         │
    │                         ▼
    │                   /archive-session
    │
    └─ More tasks? → Normal handoff
```

### With git-workflow-manager

Typical completion flow:

```
1. /end-session --complete     → Marks feature done
2. git-workflow-manager       → Prepare branch, push, create PR
3. (PR merged)
4. /archive-session           → Archive and fresh start
```

### Finding Archived Sessions

Archived sessions live in `docs/sessions/archive/`:

```bash
ls docs/sessions/archive/
# 2025-01-10-143022-mtls-implementation.md
# 2025-01-05-091545-initial-setup.md
# 2024-12-20-163210-api-redesign.md
```

Useful for:
- Reviewing past decisions
- Understanding how features were built
- Onboarding (seeing project history)
