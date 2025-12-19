---
name: archive-session
description: Archive the current session state when a major feature is complete. Moves CURRENT.md to archive and starts fresh.
---

# Archive Session

Archive the current session state when completing a major feature or work stream.
This moves `docs/sessions/CURRENT.md` to the archive and creates a fresh state file.

## When to Use

**⚠️ USE SPARINGLY - This is for MAJOR milestones only!**

✅ **Good reasons to archive:**
- Multiple PRs merged representing weeks of work
- Entire feature/system complete (e.g., "authentication system done")
- Major phase/milestone reached
- Switching to completely different project area
- CURRENT.md represents 10+ work sessions

❌ **DO NOT archive for:**
- Single PR merged
- Single day's work complete
- Individual task done
- Just taking a break for a few days
- Switching between tasks in same project

**Key point:** You might have 10-20 work sessions (bootstrap → work → end-session) before one archive.

## Execution

### Step 0: Pre-Flight Safety Checks

**CRITICAL: Before proceeding, verify this is actually a major milestone.**

Run these checks:

```bash
# How many session history entries?
grep -c "^### 20" docs/sessions/CURRENT.md

# When was CURRENT.md last modified?
ls -lh docs/sessions/CURRENT.md

# Recent commits (since last archive)
git log --oneline --since="1 week ago" | wc -l
```

**Analysis criteria:**
- Session history entries < 5: **STOP - Too early to archive**
- CURRENT.md modified today: **STOP - Too recent**
- Commits in last week < 10: **STOP - Probably not a major milestone**

### Step 1: Verify Ready to Archive & Get Explicit Confirmation

**Display clear warning:**

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 ⚠️  ARCHIVE SESSION - MAJOR MILESTONE ONLY
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

 This command will:
 • MOVE docs/sessions/CURRENT.md → archive/
 • CREATE fresh CURRENT.md (no history)
 • Next /bootstrap will start with ZERO context

 Use this ONLY when:
 ✓ Entire feature/system complete (not just one PR)
 ✓ Multiple PRs merged
 ✓ Major milestone reached
 ✓ Weeks of work represented

 DO NOT use for:
 ✗ Single PR merged
 ✗ Daily task complete
 ✗ Taking a break (use /end-session instead)

 Current work summary:
 {from CURRENT.md "What's Happening"}

 Session history entries: {count}
 Branch: {current branch}
 Uncommitted changes: {git status count}

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

**Then ask with AskUserQuestion:**
- Question: "Is this truly a MAJOR milestone worth archiving? This will remove all session context."
- Options:
  1. "Yes - major milestone complete" (description: "Archive CURRENT.md and start fresh")
  2. "No - just use /end-session" (description: "Save state but keep context for next session")

**If user selects option 2:** Stop and suggest running `/end-session` instead.

**If user selects option 1:** Proceed with archiving.

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
| **MAJOR** feature complete (multiple PRs, weeks of work) | ✓ Yes |
| All plan tasks complete AND it was a large plan | ✓ Yes |
| User says "entire X system done" | ✓ Yes |
| Starting completely new project area | ✓ Yes |
| CURRENT.md has 10+ session history entries | ✓ Yes |
| **Single** feature branch merged | ✗ No, use `/end-session` |
| User says "task done" or "PR merged" | ✗ No, use `/end-session` |
| Just pausing for a few days | ✗ No, use `/end-session` |
| Switching to different task in same project | ✗ No, use `/end-session` |
| Any work done in < 1 week | ✗ No, use `/end-session` |

### With /end-session

**Most of the time, `/end-session` is all you need:**

```
Daily workflow:
/end-session                → Save state
    │
    └─ CURRENT.md persists    → Ready for next /bootstrap

Rare major milestone:
/end-session
    │
    ├─ Check: Is this a MAJOR milestone?
    │   ├─ No (single PR, task done) → STOP, you're done
    │   └─ Yes (weeks of work, multiple PRs) → /archive-session
```

### With git-workflow-manager

**Typical flow (NO archive needed):**

```
1. Work on feature
2. git-workflow-manager       → Push, create PR
3. (PR merged)
4. /update-state              → Note PR merged in CURRENT.md
5. /end-session               → Save state
6. (CURRENT.md persists)     → Next session continues
```

**Rare major milestone flow:**

```
1. Final PR of major feature merged
2. /update-state              → Note entire system complete
3. /end-session               → Final handoff
4. /archive-session           → Archive only if truly major milestone
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
