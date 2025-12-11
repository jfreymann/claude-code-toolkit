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
