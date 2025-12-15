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

After implementing:

```
/pre-commit
```

Claude runs:
- **Branch safety check** (never commit to main/master)
- Linting (auto-fixes what it can)
- Tests (affected files or full suite)
- Security checks (if touching sensitive code)

If you're on main/master, Claude prompts:
```
⚠️  PROTECTED BRANCH: main

You're about to commit to a protected branch.
For safety, commits should be made on feature branches.

→ Create feature branch now? [Y/n]
Branch name: [feature/descriptive-name]
```

If everything passes:

```
/commit
```

Claude:
- **Checks branch safety** (creates feature branch if needed)
- Stages appropriate files
- Writes a good commit message (conventional format)
- Commits

**Repeat this cycle:** `/implement` → `/pre-commit` → `/commit`

### 3.4 Quick Breaks

Going to lunch?

```
/whats-next --pause
```

Quick state save. When you return:

```
/resume
```

Lightweight "where was I?" - no full ceremony.

### 3.5 Ending Your Day

```
/whats-next
```

Claude:
1. Summarizes what you accomplished
2. Notes any uncommitted work
3. Records current state
4. Identifies next priorities
5. Saves everything to CURRENT.md

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
SESSION HANDOFF COMPLETE
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
```

**Tomorrow's `/bootstrap` picks up exactly here.**

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

### 4.3 Branch Preparation

Ask Claude to engage the git-workflow-manager:

```
"Can you help me prepare this branch for PR?"
```

The agent handles:
- Fetching latest main
- Rebasing your branch
- Resolving conflicts
- Squashing WIP commits
- Pushing with `--force-with-lease`

### 4.4 Feature Complete

After PR merges:

```
/archive-session
```

Claude:
- Archives current session state
- Clears CURRENT.md for fresh start
- Optionally generates changelog entry

---

## Part 5: Special Situations

### 5.1 Mid-Session State Capture

Made an important decision? Hit a blocker?

```
/update-state decision "Using Redis for session storage - PostgreSQL overhead too high for this use case"
```

```
/update-state blocker "Waiting on DevOps for Redis credentials"
```

These get saved to CURRENT.md immediately.

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
│  TEST          /run-tests        Execute tests               │
│                /add-tests        Test after implementation   │
│                /test-first       TDD when spec is clear      │
│                /fix-test         Debug failures              │
│                                                              │
│  REVIEW        /review           Self-review                 │
│                /security-review  Security focus              │
│                                                              │
│  END           /whats-next       Full handoff                │
│                /whats-next --pause  Quick break              │
│                                                              │
│  FINISH        /archive-session  Feature complete            │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## The Golden Rule

**Always end with `/whats-next`.** 

This single habit ensures:
- ✅ State is saved
- ✅ Next session knows where to start
- ✅ Decisions are recorded
- ✅ Nothing is lost

Even if you forget, `/bootstrap` will detect uncommitted work and help you reconstruct - but the clean path is always `/whats-next`.

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

/whats-next                   # End of day


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

/whats-next


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

/whats-next --complete        # Feature done!

# After PR merges
/archive-session              # Clean slate for next feature
```

---

That's it. **A clean, repeatable workflow for any project.**
