---
name: resume
description: Quick session resumption. Lightweight "where was I?" without full bootstrap ceremony.
---

# Resume

Quick session continuation. Shows just enough context to get back to work immediately.

**Use `/resume`** when you know the project and just need a quick refresh.
**Use `/bootstrap`** when starting fresh, switching projects, or it's been a while.

## When to Use

- Returning after a short break (lunch, meeting)
- Context window reset mid-session
- Quick "where was I?" check
- Already know the project, just need state refresh

## When to Use /bootstrap Instead

- First session of the day
- It's been more than a few hours
- Switching to a different project
- Need full context reload

---

## Execution

### Step 1: Quick State Load

```bash
# Get essentials
BRANCH=$(git branch --show-current)
UNCOMMITTED=$(git status --porcelain | wc -l | tr -d ' ')
LAST_COMMIT=$(git log -1 --format="%h %s" 2>/dev/null)
```

### Step 2: Parse CURRENT.md

Extract just:
- Quick Reference section
- Next Actions section
- What's Happening (first 2-3 sentences)

### Step 3: Present Compact Brief

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 RESUME: {project}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

 {branch} │ {N} uncommitted │ Last: {last commit}

 Task: {X}/{Y} - {task name}
 Status: {status}

 CONTEXT
 {2-3 sentences from What's Happening}

 NEXT
 → {first next action}

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 [c]ontinue │ [d]etails │ [p]lan │ [t]ests
```

### Step 4: Quick Actions

Based on user response:

| Input | Action |
|-------|--------|
| `c` or Enter | Continue with next action |
| `d` | Show full CURRENT.md |
| `p` | Show active plan |
| `t` | Run test suite |
| (anything else) | Treat as new instruction |

---

## Comparison: /resume vs /bootstrap

| Aspect | /resume | /bootstrap |
|--------|---------|------------|
| Speed | Fast (seconds) | Thorough (may be slower) |
| Context | Minimal refresh | Full stack load |
| Staleness check | No | Yes (HOT/WARM/COOL/COLD) |
| Environment check | No | Yes (for COLD sessions) |
| Capability inventory | No | Yes (agents, commands) |
| State update | No | Yes (adds session start entry) |
| Best for | Quick returns | Day start, project switch |

---

## Output Variants

### With Active Task

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 RESUME: guardian
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

 feature/mtls-auth │ 2 uncommitted │ Last: def456 Add cert validation

 Task: 4/7 - Certificate chain verification
 Status: IN_PROGRESS

 CONTEXT
 Implementing chain verification for mTLS. Basic validation
 working, now adding full chain walk back to CA.

 NEXT
 → Complete chain verification loop in CertificateValidator#verify_chain

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### With Blockers

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 RESUME: guardian
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

 feature/mtls-auth │ 0 uncommitted │ Last: abc123 WIP chain verify

 Task: 4/7 - Certificate chain verification
 Status: BLOCKED

 ⚠️  BLOCKER
 Waiting for decision on CRL vs OCSP for revocation checking.
 See open question in CURRENT.md.

 CONTEXT
 Chain verification paused pending revocation strategy decision.

 NEXT (when unblocked)
 → Implement chosen revocation check in verify_chain

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### No Active Work

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 RESUME: guardian
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

 main │ Clean │ Last: 789ghi Merge mTLS feature

 No active task

 NEXT
 → Check TO-DOS.md for next priority
 → Or start new work with /create-plan

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## Integration

### With Plans

If active plan exists, show task progress:
```
Plan: mTLS Implementation [████████░░] 4/7
```

### With Tests

Quick test status if available:
```
Tests: 52 passing │ 2 pending │ 0 failing
```

### With Git State

Highlight if branch needs attention:
```
⚠️  Branch is 5 commits behind main - consider rebasing
```

---

## Usage

```bash
/resume              # Quick state refresh
/resume --verbose    # Include more context (like light bootstrap)
```
