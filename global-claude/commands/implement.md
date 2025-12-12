---
name: implement
description: Implement a feature or task with structured workflow - code, test, integrate. Works standalone or with active plan.
---

# Implement

Structured implementation workflow that guides through coding, testing, and integration. Adapts to your testing style (test-first or test-after).

## When to Use

- Starting work on a planned task
- Building a new feature
- Implementing a bug fix
- Any substantial code change

## Workflow Overview

```
/implement "Add user authentication"
    │
    ├── 1. SCOPE: Define what we're building
    │
    ├── 2. APPROACH: Decide how to build it
    │       └── Testing style (test-first or test-after?)
    │
    ├── 3. BUILD: Write the code
    │       ├── Test-first: RED → GREEN → REFACTOR
    │       └── Test-after: CODE → TEST → REFINE
    │
    ├── 4. VERIFY: Run tests, check quality
    │
    └── 5. INTEGRATE: Commit, update state
```

---

## Execution

### Step 1: Scope Definition

Ask (if not provided):
1. **What are we building?** (feature, fix, refactor)
2. **What's the acceptance criteria?** (how do we know it's done)
3. **Any constraints?** (dependencies, limitations)

Check for active plan:
- **Has plan**: Link to current task, pull acceptance criteria
- **No plan**: Proceed with ad-hoc implementation

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 IMPLEMENTING: {Title}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

 {Plan: Task 2.1 of mTLS Authentication | or "Ad-hoc"}
 
 SCOPE
 {Description of what we're building}
 
 ACCEPTANCE
 {How we know it's done}
 
 CONSTRAINTS
 {Any limitations or requirements}

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### Step 2: Approach Decision

Determine testing approach based on the work:

**Suggest test-first when:**
- Bug fix (prove the bug first)
- Clear interface/contract
- Business logic with known rules
- User requests it

**Suggest test-after when:**
- Exploratory/discovery work
- Integration with unfamiliar APIs
- UI components
- User requests it

**Skip tests when:**
- Quick script/spike
- Throwaway code
- User requests it

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 APPROACH
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

 This looks like {type of work}.
 
 Suggested: {test-first | test-after | minimal testing}
 Reason: {why this approach fits}
 
 Files likely involved:
 • {file1.rb} - {what changes}
 • {file2.rb} - {what changes}
 
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 → Proceed with {approach}? [Y/n/switch]
```

### Step 3: Build

#### Test-First Path

```
┌─────────────────────────────────────────┐
│  RED: Write failing test               │
│  └─ Describes one behavior             │
├─────────────────────────────────────────┤
│  GREEN: Write code to pass             │
│  └─ Minimum implementation             │
├─────────────────────────────────────────┤
│  REFACTOR: Clean up                    │
│  └─ Improve while tests pass           │
├─────────────────────────────────────────┤
│  REPEAT for next behavior              │
└─────────────────────────────────────────┘
```

Progress checkpoints:
```
🔴 Test written (failing)
   └─ "validates certificate CN format"

🟢 Implementation done (passing)
   └─ Added CN validation regex

🔄 Refactored
   └─ Extracted pattern to constant

→ Next behavior?
```

#### Test-After Path

```
┌─────────────────────────────────────────┐
│  CODE: Build the feature               │
│  └─ Get it working                     │
├─────────────────────────────────────────┤
│  TEST: Add test coverage               │
│  └─ Cover critical paths               │
├─────────────────────────────────────────┤
│  REFINE: Improve with test safety      │
│  └─ Refactor if needed                 │
└─────────────────────────────────────────┘
```

Progress checkpoints:
```
💻 Implementation complete
   └─ mTLS verification working manually
   
✓ Tests added
   └─ 4 specs covering happy path + errors

🔄 Refined
   └─ Extracted SSLContext setup to config

→ Ready to verify?
```

### Step 4: Verify

Before integration, verify:

```bash
# Run relevant tests
/run-tests {affected specs}

# If all pass, optional quality checks:
# - Linting
# - Security scan
# - Type checking (if applicable)
```

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 VERIFICATION
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

 Tests: 4 passed, 0 failed ✓
 Linting: No issues ✓
 
 Changes:
 • app/services/ssl_verifier.rb (new)
 • config/guardian.yml (modified)
 • spec/services/ssl_verifier_spec.rb (new)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 → Ready to commit?
```

### Step 5: Integrate

Commit the work with appropriate message:

```bash
git add {files}
git commit -m "{type}: {description}"
```

Update state:
```bash
/update-state task complete "{task description}"
```

If using a plan:
```bash
/update-plan complete {task-number}
```

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 ✓ COMPLETE: {Title}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

 Committed: abc1234
 Message: "feat: add mTLS certificate verification"
 
 Plan updated: Task 2.1 complete (3/6)
 
 Next task: 2.2 - Extract agent identity from certificate CN

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 → Start next task?
```

---

## Agent Integration

During implementation, Claude may suggest specialist agents:

```
This involves database schema changes. Would you like me to
consult postgres-expert for the migration design?

[Y]es / [N]o, I'll handle it / [D]iscuss together
```

Options:
- **Yes**: Invoke agent, get recommendations
- **No**: Continue without agent
- **Discuss**: Work through together without formal delegation

---

## Handling Blockers

If you hit a blocker during implementation:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 ⚠️  BLOCKER ENCOUNTERED
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

 Issue: OpenSSL::SSL::SSLError on client verify
 
 Tried:
 • Setting verify_mode to VERIFY_PEER
 • Adding CA to cert_store
 
 Need: Figure out why client cert isn't being sent

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Options:
 1. Debug together
 2. Pause and record blocker
 3. Switch to different task
```

Pausing records the blocker in CURRENT.md for later.

---

## Partial Implementation

If stopping mid-task:

```bash
/implement --pause "Got the basic flow working, need to add error handling"
```

Updates CURRENT.md:
```markdown
## What's Happening

Implementing mTLS verification (Task 2.1). Basic verification 
working, still need error handling for expired certs.

## Next Actions
1. Add error handling for expired certificates
2. Add error handling for revoked certificates  
3. Write tests for error cases
```

Resume later:
```bash
/implement --resume
```

---

## Usage

```bash
/implement                           # Interactive
/implement "Feature description"     # Start with description
/implement --task 2.1                # Start specific plan task
/implement --test-first              # Force TDD mode
/implement --test-after              # Force test-after mode
/implement --pause "reason"          # Pause and record state
/implement --resume                  # Resume paused work
```
