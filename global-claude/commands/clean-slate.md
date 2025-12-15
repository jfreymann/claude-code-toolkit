---
name: clean-slate
description: Save state and restart with fresh context. Use after extensive debugging, when switching mental models, or when context feels cluttered.
---

# Clean Slate

Compress current context, save state, and restart with a fresh session. Use when context feels "heavy" or after extensive exploration/debugging.

**Purpose:** Proactive context hygiene - refresh mental model without losing continuity.

## When to Use

### Clear Signals (Use Now)
- **After extensive debugging** - 10+ attempts, lots of dead ends in context
- **Switching mental models** - Moving from exploration to implementation
- **Context feels cluttered** - Hard to think clearly, session feels "heavy"
- **Long exploration session** - Grepped/read 50+ files, now need to implement
- **Stuck in a rut** - Keep repeating the same failed approaches
- **After major discovery** - Found root cause, ready for clean implementation

### Preventive Use (Good Practice)
- **2+ hours on one problem** - Even if making progress
- **Before switching tasks** - Clean break between unrelated work
- **After completing a phase** - Before starting next phase of plan
- **Context >70% full** - Proactive compression before hitting limits

### Don't Use When
- Just started session (< 30 min)
- Making steady progress on current task
- In the middle of active implementation (finish your thought first)
- About to end session anyway (use `/whats-next` instead)

## What It Does

```
┌────────────────────────────────────────────────┐
│              CLEAN SLATE PROCESS               │
├────────────────────────────────────────────────┤
│                                                │
│  1. Capture Current State                     │
│     → Update CURRENT.md with:                  │
│       - What you discovered                    │
│       - Key insights from exploration          │
│       - Dead ends to avoid                     │
│       - Next specific action                   │
│                                                │
│  2. Summarize Key Context                     │
│     → Extract essentials:                      │
│       - Core problem/goal                      │
│       - Key decisions made                     │
│       - Critical files/functions               │
│       - What to load on restart                │
│                                                │
│  3. Create Restart Instructions                │
│     → Generate recovery command:               │
│       "/bootstrap --quick"                     │
│       "Read: file1.rb, file2.rb"               │
│       "Focus: implementing X with approach Y"  │
│                                                │
│  4. Exit Session                               │
│     → Displays: "Restart Claude Code and run:" │
│       [exact commands to resume]               │
│                                                │
└────────────────────────────────────────────────┘
```

## Execution Flow

### Step 1: Pre-Check

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🔄 CLEAN SLATE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Current session:
• Messages: 47
• Duration: 2h 15m
• Branch: feature/auth-fix
• Uncommitted: 3 files

→ Save state and restart with fresh context? [Y/n]
```

If uncommitted changes:
```
⚠️  You have uncommitted changes:
   M app/services/auth.rb
   M spec/services/auth_spec.rb
   A app/models/token.rb

→ Commit before clean slate? [Y/n/skip]
```

### Step 2: Extract Key Context

Claude analyzes conversation and extracts:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EXTRACTING KEY CONTEXT
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

From this session:
✓ Problem: Token validation failing on expired tokens
✓ Root cause: Time comparison using wrong timezone
✓ Solution: Use UTC consistently in validator
✓ Key files: app/services/token_validator.rb
✓ Dead ends: Tried caching (made it worse), tried gem (dependency hell)
✓ Next: Implement UTC fix in validate_expiry method
```

### Step 3: Update CURRENT.md

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
UPDATING STATE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Updated: docs/sessions/CURRENT.md

## What's Happening
Token validation failing on expired tokens. Root cause identified:
time comparison using local time instead of UTC. Ready to implement
fix in TokenValidator.

## Key Decisions
• Use UTC throughout validator (not local time conversions)
• Keep existing token structure (no migration needed)
• Add explicit timezone tests to prevent regression

## Dead Ends (Avoid)
• ✗ Caching expiry checks - made race condition worse
• ✗ Using jwt gem - brought in 5 unwanted dependencies

## Next Actions
1. Implement UTC fix in `app/services/token_validator.rb:45`
   - Change: `token.expires_at > Time.now`
   - To: `token.expires_at > Time.now.utc`
2. Add timezone regression test
3. Verify across all environments

## Critical Files
• app/services/token_validator.rb (fix here)
• spec/services/token_validator_spec.rb (add test)
```

### Step 4: Generate Restart Instructions

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✓ STATE SAVED
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Ready for fresh context.

TO RESUME:
1. Restart Claude Code
2. Run these commands:

   /bootstrap --quick

3. Then say:

   "Read app/services/token_validator.rb and implement
   the UTC fix at line 45 as described in CURRENT.md"

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Context compressed:
  Before: 47 messages, ~45K tokens
  After:  Will start fresh with essentials (~5K tokens)

You can now close this session.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## What Gets Saved

### Saved to CURRENT.md
- **What's Happening**: Current context (compressed)
- **Key Decisions**: Important choices made this session
- **Dead Ends**: Failed approaches to avoid
- **Next Actions**: Specific next steps with file locations
- **Critical Files**: Files to read on restart

### Added to Session History
```markdown
### 2025-01-16 14:30 - Clean Slate
Context compressed after 2h debugging session.
Root cause identified: UTC timezone issue in token validator.
Ready to implement fix.
```

### NOT Saved (Intentionally Dropped)
- Failed debugging attempts (dead ends noted, details dropped)
- Exploratory file reads (critical files noted, full content dropped)
- Repeated explanations (conclusions kept, reasoning dropped)
- Tangential discussions (refocused on core problem)

## Resume Strategy

After restart, load only essentials:

```
/bootstrap --quick
```

This loads:
- CURRENT.md Quick Reference
- CURRENT.md Next Actions
- Active plan position (if plan exists)
- **Does NOT load**: Full session history, entire project context

Then immediately focus:
```
"Read app/services/token_validator.rb and implement the UTC fix"
```

This gives you:
- **Fresh context** - No clutter from debugging session
- **Focused start** - Specific file and task
- **Preserved knowledge** - Dead ends and decisions saved

## Options & Flags

```bash
/clean-slate                    # Standard: full compression
/clean-slate --minimal          # Quick: just save state, minimal summary
/clean-slate --keep-files       # Include current file contents in state
/clean-slate --no-commit        # Skip commit prompt, just save state
```

### --minimal
Faster version for quick context refresh:
- Saves current state to CURRENT.md
- No detailed extraction
- Simple restart instruction

### --keep-files
For mid-implementation compression:
- Includes current file contents in CURRENT.md
- Useful when you have code in progress
- Allows resuming exact state

### --no-commit
When you want to compress but aren't ready to commit:
- Warns about uncommitted changes
- Saves file list to state
- No git operations

## Integration with Other Commands

### After Clean Slate
```
[New session]
/bootstrap --quick              # Load essentials
"Implement the UTC fix"         # Jump straight to work
```

### Alternative to Archive
```
/archive-session     # For completed features (full archive)
/clean-slate         # For mid-work compression (continue same feature)
```

### With Planning
```
/clean-slate         # Compress context
[New session]
/bootstrap --quick   # Load state
/update-plan         # Update plan with findings
/implement           # Continue with plan
```

## Best Practices

### The 2-Hour Rule
After 2+ hours of exploration/debugging, run `/clean-slate` even if making progress. Fresh context improves thinking.

### Before Implementation
After exploration phase, compress context before starting implementation:
```
[Exploration session - grepped 50 files, read 20 files]
/clean-slate

[New session - fresh start]
/bootstrap --quick
"Implement X using approach Y"
```

### After Finding Root Cause
Compress after discovering the problem, before implementing solution:
```
Found it! The timezone issue is in token_validator.rb

/clean-slate

[New session]
"Implement the UTC fix in TokenValidator"
```

### When Stuck
If you've tried the same thing 3+ times, compress and restart:
```
[Tried approach A, B, C - all failed]
/clean-slate

[New session - fresh perspective]
/bootstrap --quick
"Review the dead ends in CURRENT.md and suggest new approach"
```

## Common Patterns

### Pattern 1: Debug → Compress → Implement
```
1. Debugging session (lots of exploration)
   → /clean-slate

2. Fresh session (focused implementation)
   → /bootstrap --quick
   → Implement fix
   → /commit
```

### Pattern 2: Explore → Compress → Decide
```
1. Exploration (grepping, reading, understanding)
   → /clean-slate

2. Fresh session (clear decision making)
   → /bootstrap --quick
   → Review findings
   → Make architectural decision
   → /create-adr
```

### Pattern 3: Stuck → Compress → Fresh Perspective
```
1. Stuck on problem (repeated failed attempts)
   → /clean-slate

2. Fresh session (new approach)
   → /bootstrap --quick
   → "What did I try? What haven't I tried?"
   → Different solution emerges
```

## Warning Signs

If you notice these, run `/clean-slate`:

🔴 **Critical (Do Now)**
- Can't think clearly about the problem
- Keep repeating same failed approach
- Lost track of what you've tried
- Context feels "muddy" or "heavy"

🟡 **Warning (Consider)**
- Session > 2 hours
- Read 30+ files
- Tried 5+ different approaches
- Hard to remember what worked vs what didn't

🟢 **Preventive (Good Practice)**
- Finished exploration, starting implementation
- Switching from debugging to feature work
- About to make architectural decision
- Want to start next session focused

## FAQ

**Q: Won't I lose important context?**
A: No. `/clean-slate` saves all key decisions, dead ends, and next actions to CURRENT.md. You lose the *clutter*, not the *insights*.

**Q: How is this different from /whats-next?**
A: `/whats-next` is for ending your session (going offline). `/clean-slate` is for continuing work in a fresh context (staying online, just restarting).

**Q: Should I commit first?**
A: Usually yes. `/clean-slate` will prompt you if you have uncommitted changes. Clean git state makes restart clearer.

**Q: What if I'm in the middle of coding?**
A: Finish your current thought, use `--keep-files` to save file contents, or commit your WIP first.

**Q: How often should I use this?**
A: Every 2 hours of active exploration/debugging is good practice. More often if stuck or context feels cluttered.

**Q: Can I undo it?**
A: You can't "undo" the context compression, but all your insights are saved in CURRENT.md. Just restart and run `/bootstrap --quick`.

---

## Summary

**Use `/clean-slate` when:**
- Context feels cluttered or heavy
- After extensive debugging (10+ attempts)
- Switching from exploration to implementation
- Been working 2+ hours on one problem
- Keep repeating same failed approaches

**It will:**
1. Extract key insights from current session
2. Save everything important to CURRENT.md
3. Drop the clutter (failed attempts, tangents)
4. Give you exact instructions to resume
5. Exit session for fresh restart

**Result:**
- Fresh mental model
- No lost insights
- Focused restart
- Better thinking clarity
