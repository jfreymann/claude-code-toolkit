# Complete Workflow Walkthrough

> A practical guide to using the Claude Code Agentic Workflow Toolkit from first install through daily use.

---

## Part 1: Initial Setup (One Time)

### 1.1 Install the Toolkit

```bash
cd ~
git clone https://github.com/YOUR_USERNAME/claude-code-toolkit.git
cd claude-code-toolkit
./install.sh
```

This creates:
```
~/.claude/
├── CLAUDE.md              # Your personal copy (edit this!)
├── agents/                # → symlink to repo
├── commands/              # → symlink to repo
└── skills/                # → symlink to repo
```

### 1.2 Customize Your Identity

```bash
code ~/.claude/CLAUDE.md
```

Find the 🔧 markers and fill in:
- Your name and role
- Your tech stack and expertise
- Your working style preferences
- Which agents you want available

**This is YOUR file** - it travels with you across all projects.

---

## Part 2: Project Setup (Per Project)

### 2.1 Initialize a New Project

```bash
cd /path/to/your-project
~/claude-code-toolkit/init-project.sh
```

This creates:
```
your-project/
├── .claude/
│   └── CLAUDE.md              # Project-specific context
├── docs/
│   ├── sessions/
│   │   ├── CURRENT.md         # Session state
│   │   └── archive/
│   ├── plans/
│   │   └── ACTIVE.md          # → symlink to current plan
│   └── architecture/
│       └── decisions/
└── TO-DOS.md
```

### 2.2 Configure Project Context

```bash
code .claude/CLAUDE.md
```

Fill in:
- Project name and description
- Tech stack specifics
- Key patterns and conventions
- Important architectural decisions

**This file is project-specific** - commit it to your repo so context persists.

---

## Part 3: Daily Workflow

### 3.1 Starting Your Day

```bash
cd your-project
claude
```

Then run:
```
/bootstrap
```

Claude reads your identity, project context, and session state, then gives you an adaptive briefing:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
guardian │ feature/mtls-auth │ 🟡 WARM (2 days)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

WHAT'S HAPPENING
Implementing mTLS certificate verification for agent auth.
Chain validation complete, working on revocation checking.

KEY DECISIONS
• Using OpenSSL for cert parsing (not custom)
• CRL over OCSP (simpler, offline-capable)

NEXT ACTIONS
→ Implement CRL fetching in CertificateValidator
→ Add tests for revoked certificate rejection

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Continue with CRL implementation?
```

**You're immediately productive.** No re-explaining, no context gathering.

### 3.2 Working on Tasks

#### Simple Task (No Plan Needed)

```
/implement "Add CRL fetching to CertificateValidator"
```

Claude:
1. Understands the task in context
2. Implements the code
3. Suggests testing approach
4. Ready for commit

#### Complex Feature (With Plan)

For multi-session work:

```
/create-plan feature "User Authentication System"
```

Claude creates a plan in `docs/plans/` with:
- Phases and milestones
- Tasks with acceptance criteria
- Checkpoints for your approval

Work through it:
```
/implement                    # Works on current task from plan
/update-plan complete 1.1     # Mark task done
/update-plan complete 1.2     # Next task done
```

### 3.3 The Commit Cycle

The correct flow is: **work → capture → commit**

#### Step 1: Capture Your Work

After implementing, capture decisions and progress:

```
/update-state
```

This updates CURRENT.md with:
- What you just did
- Decisions made
- Questions that came up
- What's next

**Why this matters:** Keeps CURRENT.md fresh so next `/bootstrap` has full context.

#### Step 2: Pre-commit Checks

```
/pre-commit
```

Claude runs:
- Linting (auto-fixes what it can)
- Tests (affected files or full suite)
- Security checks (if touching sensitive code)

#### Step 3: Commit

```
/commit
```

Claude:
- **Checks branch safety** - if you're on main/master, it:
  - Reads CURRENT.md "What's Happening" for context
  - Suggests smart branch name (e.g., "feature/workflow-improvements")
  - Auto-creates the branch
  - Switches to it
- Stages appropriate files
- Writes a good commit message (conventional format)
- Commits to the feature branch

Example branch safety in action:
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 ⚠️  BRANCH SAFETY CHECK
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

 You're on: main (protected branch)

 Based on your work:
 • Context: "Add user authentication"
 • Modified: app/models/user.rb, controllers/auth_controller.rb

 Suggested branch: feature/user-authentication

 Options:
  1. Create feature/user-authentication (Recommended)
  2. Specify different branch name
  3. Use git-workflow-manager instead
  4. Cancel
```

**Repeat this cycle:** `/implement` → `/update-state` → `/commit`

### 3.4 Context Hygiene (Important!)

**Keep context fresh for better thinking.**

After 2 hours of work (or when context feels cluttered):

```
/context-check
```

Check context health:
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
CONTEXT HEALTH CHECK
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Session Duration: 2.1 hours
Estimated Context: ~75% full
Last State Save: 45 minutes ago

Status: 🟡 Getting full

⚠️  Context is accumulating. Consider /clean-slate after
   completing your current task.
```

If context is getting full or you're stuck:

```
/clean-slate
```

This will:
1. Save all insights and decisions to CURRENT.md
2. Drop clutter (failed attempts, exploratory reads)
3. Give you exact restart instructions
4. Exit session

Then restart Claude Code and run:
```
/bootstrap --quick
"Implement the fix for [specific task]"
```

**You get:**
- Fresh mental model
- No lost knowledge
- Clearer thinking
- Better decisions

**When to compress:**
- After 2+ hours of work
- When stuck (tried 3+ approaches)
- Before switching from exploration to implementation
- Session duration >2hrs (per `/context-check`)

### 3.5 Quick Breaks

Going to lunch?

```
/end-session --pause
```

Quick state save. When you return:

```
/resume
```

Lightweight "where was I?" - no full ceremony.

### 3.6 Ending Your Day

**Important:** If you haven't run `/update-state` recently, do that first!

```
/end-session
```

Claude:
1. **Checks CURRENT.md freshness** - if it's > 1 hour old, prompts you to run `/update-state` first
2. Summarizes what you accomplished
3. Notes any uncommitted work
4. Records current state
5. Updates CURRENT.md with session end entry

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 SESSION HANDOFF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

THIS SESSION
• Implemented CRL fetching
• Added CRL cache with 1-hour TTL
• Fixed edge case in chain validation

STATE
Branch: feature/mtls-auth │ Clean │ Tests: 47 passing

NEXT SESSION
→ Add tests for CRL expiry handling
→ Implement OCSP fallback (stretch goal)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 💡 CURRENT.md has been updated and will persist
 💡 No need to archive - ongoing work continues
```

**Key Point:** CURRENT.md persists! Tomorrow's `/bootstrap` picks up exactly here.

**You don't archive** after every session - only after major milestones (see below).

---

## Part 3.7: Understanding CURRENT.md Persistence (Critical!)

**The key insight that prevents workflow confusion:**

### CURRENT.md Persists Across Many Sessions

```
Day 1:  Work → /update-state → /end-session
              ↓
        CURRENT.md saved ✓

Day 2:  /bootstrap → reads CURRENT.md
        Work → /update-state → /end-session
              ↓
        CURRENT.md updated ✓

Day 3:  /bootstrap → reads CURRENT.md
        Work → "push code" → PR created
        /update-state → note PR created
        /end-session
              ↓
        CURRENT.md still there! ✓

Week later: PR merged
        /update-state → note PR merged
        /end-session
              ↓
        CURRENT.md STILL there! ✓

Weeks later: 10+ PRs merged, entire feature done
        /archive-session
              ↓
        NOW CURRENT.md moves to archive
        Fresh CURRENT.md created
```

### Archive is RARE, Not Routine

| Frequency | Action | CURRENT.md State |
|-----------|--------|------------------|
| **Daily** | /end-session | Persists ✓ |
| **After PR merge** | /update-state + /end-session | Persists ✓ |
| **Major milestone** (rare!) | /archive-session | Archived, starts fresh |

### The Flow You Should Use

**Daily work:**
1. `/bootstrap` - loads CURRENT.md
2. Work on feature
3. `/update-state` - capture progress
4. `/commit` - commit to feature branch
5. `/end-session` - save state
6. **CURRENT.md persists**
7. Next day: `/bootstrap` - loads same CURRENT.md

**Ready to push:**
1. "push code" - triggers git-workflow-manager
2. PR created
3. `/update-state` - note PR created (optional)
4. `/end-session` - save state
5. **CURRENT.md persists**

**After PR merged:**
1. "post-merge cleanup" - git-workflow-manager auto-updates CURRENT.md ✨
2. `/end-session` - save state (optional)
3. **CURRENT.md persists**
4. Continue working on next task

**Note:** Post-merge cleanup now automatically updates CURRENT.md with latest commit, branch state, and timestamp. Manual `/update-state` is no longer required after merges!

**After MAJOR milestone (10+ sessions, weeks of work):**
1. `/archive-session` - archives CURRENT.md
2. Fresh CURRENT.md created
3. Start next major feature

---

## Part 4: Preparing for PR

When your feature is ready for review:

### 4.1 Self-Review

```
/review
```

Claude checks:
- Code correctness
- Test coverage
- Documentation
- Consistency with project patterns

### 4.2 Security Review (If Applicable)

```
/security-review
```

For auth, data handling, or sensitive code.

### 4.3 Push and Create PR

When ready to push and create PR, just say:

```
"push code"
```

This automatically triggers git-workflow-manager which handles:
- Creating feature branch (if you're on main)
- Fetching latest main
- Rebasing your branch
- Resolving conflicts
- Pushing
- Creating pull request
- Post-merge cleanup (when PR merges)

### 4.4 After PR Merges

**DO NOT archive!** Just update state:

```
/update-state
```

Capture that the PR merged and you're moving to next task.

```
/end-session
```

**CURRENT.md persists** - you'll continue working in the same session context.

### 4.5 Major Milestone Complete (RARE)

Only use `/archive-session` when **ALL** these are true:
- ✅ Multiple PRs merged (10+)
- ✅ Weeks of work complete
- ✅ Entire feature/system done (e.g., "entire auth system complete")
- ✅ CURRENT.md has 10+ session history entries
- ✅ Starting completely new project area

**Example of when to archive:**
- "All 15 PRs for authentication system merged"
- "Migration from Rails 6 to 7 complete (8 weeks, 20+ PRs)"
- "Entire API redesign shipped to production"

**Example of when NOT to archive:**
- "Login feature PR merged" ← post-merge cleanup auto-updates CURRENT.md
- "Fixed the auth bug" ← post-merge cleanup auto-updates CURRENT.md
- "Completed task 3 of 10" ← just use /end-session

When you do archive:

```
/archive-session
```

Claude will:
- Run pre-flight checks (session count, recency)
- Show clear warning
- Ask for confirmation
- Only proceed if truly a major milestone

---

## Part 5: Special Situations

### 5.1 Mid-Session State Capture (Important!)

**Do this regularly!** Made progress? Made a decision? Hit a blocker?

```
/update-state
```

Claude will:
- Review recent conversation
- Extract key decisions, progress, questions
- Update CURRENT.md sections
- Ensure next /bootstrap has full context

**Best practice:** Run `/update-state` every 30-60 minutes during active work.

**Why this matters:**
- `/end-session` checks if CURRENT.md is stale
- If > 1 hour old, it prompts you to update first
- Fresh state = rich context for next /bootstrap

### 5.2 Debugging Failing Tests

```
/fix-test spec/models/certificate_validator_spec.rb:45
```

Claude:
1. Analyzes the failure
2. Identifies root cause
3. Proposes fix
4. Verifies fix works

### 5.3 Architecture Decisions

Making a significant choice?

```
/create-adr "Session Storage Strategy"
```

Claude creates a decision record with:
- Context
- Options considered
- Decision and rationale
- Consequences

Lives in `docs/architecture/decisions/` for future reference.

### 5.4 Tracking Future Work

Found something that needs doing later?

```
/add-to-todos "Refactor CertificateValidator to support multiple CA chains" --priority medium
```

Review later:

```
/check-todos
```

---

## Part 6: The Mental Models

When you need guidance on approach:

### Testing Strategy
```
/consider:testing-strategy
```
- When to test first vs after
- What to test, what to skip
- Mocking guidelines

### Quality Gates
```
/consider:quality-gates
```
- Which checks for which situations
- When to escalate to full review

### Agent Dispatch
```
/consider:agent-dispatch
```
- When to engage specialists
- How to provide good context

### Session Continuity
```
/consider:session-continuity
```
- State management best practices
- Handoff patterns

---

## Quick Reference Card

```
┌─────────────────────────────────────────────────────────────┐
│                    DAILY WORKFLOW                            │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  START         /bootstrap        Full context load           │
│                /resume           Quick return                │
│                                                              │
│  PLAN          /create-plan      Multi-session work          │
│                /update-plan      Track progress              │
│                                                              │
│  WORK          /implement        Do the task                 │
│                /pre-commit       Quality checks              │
│                /commit           Clean commit                │
│                /update-state     Capture decisions           │
│                                                              │
│  HYGIENE       /context-check    Check context health        │
│  (Every 2h)    /clean-slate      Compress & restart          │
│                                                              │
│  TEST          /run-tests        Execute tests               │
│                /add-tests        Test after implementation   │
│                /test-first       TDD when spec is clear      │
│                /fix-test         Debug failures              │
│                                                              │
│  REVIEW        /review           Self-review                 │
│                /security-review  Security focus              │
│                                                              │
│  END           /end-session       Full handoff                │
│                /end-session --pause  Quick break              │
│                                                              │
│  FINISH        /archive-session  Feature complete            │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## The Golden Rule

**Always end with `/end-session`.** 

This single habit ensures:
- ✅ State is saved
- ✅ Next session knows where to start
- ✅ Decisions are recorded
- ✅ Nothing is lost

Even if you forget, `/bootstrap` will detect uncommitted work and help you reconstruct - but the clean path is always `/end-session`.

---

## Example: Complete Feature Lifecycle

```bash
# === DAY 1: Start Feature ===

claude
/bootstrap                    # First time on project, full setup

/create-plan feature "Add mTLS Authentication"
                              # Creates plan with phases

/implement                    # Work on Phase 1, Task 1
/pre-commit
/commit

/implement                    # Task 2
/pre-commit  
/commit

/end-session                   # End of day


# === DAY 2: Continue ===

claude
/bootstrap                    # Picks up where you left off

/implement                    # Continue Phase 1
/update-state decision "Using OpenSSL over custom parsing"
/pre-commit
/commit

/update-plan complete 1       # Phase 1 done

/implement                    # Start Phase 2
/pre-commit
/commit

/end-session


# === DAY 3: Finish ===

claude  
/bootstrap

/implement                    # Finish remaining tasks
/pre-commit
/commit

/add-tests                    # Ensure coverage
/run-tests                    # Verify all green

/review                       # Self-review
/security-review              # Security check (auth code)

# Prepare for PR
"Help me prepare this branch for PR"
                              # git-workflow-manager handles it

/end-session --complete        # Feature done!

# After PR merges
/archive-session              # Clean slate for next feature
```

---

That's it. **A clean, repeatable workflow for any project.**
