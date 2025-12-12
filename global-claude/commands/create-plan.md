---
name: create-plan
description: Create an implementation plan for a feature, refactor, spike, or fix. Establishes scope, tasks, and tracking before starting work.
---

# Create Plan

Creates a structured implementation plan in `docs/plans/` and sets it as the active plan.

## When to Create a Plan

**DO create a plan when:**
- Work spans multiple sessions (> 2 hours estimated)
- Multiple components or files involved
- Significant architectural decisions needed
- You want to track progress across sessions
- The scope could creep without boundaries

**DON'T create a plan when:**
- Quick fix (< 30 min)
- Single file change
- Obvious implementation with clear end state
- Exploration / learning (use a spike instead, or just explore)

**When uncertain**: Start without a plan. If scope expands, create one mid-work.

---

## Plan Types

| Type | Use When | Example |
|------|----------|---------|
| **feature** | Adding new capability | "Agent communication system" |
| **refactor** | Restructuring existing code | "Extract service objects" |
| **spike** | Research / prototype (time-boxed) | "Evaluate mTLS libraries" |
| **fix** | Complex bug requiring investigation | "Connection pooling leak" |
| **chore** | Maintenance / infrastructure | "Upgrade Rails 7 → 8" |

---

## Living Architecture Approach

Plans are **living documents**, not contracts. The goal is:

1. **Start with direction, not destination** - Know where you're headed, discover the path
2. **Refine as you learn** - Update the plan when reality differs from assumptions
3. **Capture decisions as ADRs** - When you make significant choices, document why
4. **Tasks are waypoints, not rails** - Adjust, reorder, add, remove as needed

This contrasts with "Big Design Up Front" where you try to know everything before starting.

---

## Execution

### Step 1: Gather Information

Ask the user (if not already provided):

1. **What are you building?** (one sentence)
2. **Why now?** (context, motivation)
3. **What's the scope?** (boundaries)
4. **Any known constraints?** (tech, time, dependencies)

### Step 2: Generate Plan

Using the template at `docs/plans/PLAN-TEMPLATE.md` (or the embedded structure below), create a plan file:

**Filename**: `{YYYY-MM-DD}-{kebab-case-name}.md`

**Example**: `2025-01-15-mtls-agent-auth.md`

### Step 3: Populate Sections

1. **Overview**: Goal, Why Now, Scope from user input
2. **Context**: Summarize current state, problem being solved
3. **Approach**: High-level strategy (2-3 paragraphs max)
4. **Tasks**: Break into phases and tasks
   - Each task has clear acceptance criteria
   - Estimate 4-8 tasks for typical features
   - Group into logical phases
5. **Out of Scope**: What this plan explicitly excludes
6. **Open Questions**: Unknowns to resolve during work
7. **Dependencies/Risks**: What could block or derail

### Step 4: Create Symlink

```bash
ln -sf "{plan-filename}.md" "docs/plans/ACTIVE.md"
```

### Step 5: Update CURRENT.md

Add to `docs/sessions/CURRENT.md`:

**Quick Reference section:**
```markdown
- **Plan**: docs/plans/{plan-filename}.md
- **Task**: 0/N - Ready to start
```

**Session History section:**
```markdown
### {TIMESTAMP} - Plan Created
- Plan: {plan-name}
- Type: {feature|refactor|spike|fix|chore}
- Tasks: {N} identified
- First task: {task name}
```

### Step 6: Present Summary

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 📋 PLAN CREATED: {Plan Name}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

 Type: {type}
 Tasks: {N} across {M} phases
 File: docs/plans/{filename}.md

 PHASE 1: {Phase Name}
 └─ Task 1.1: {First task description}
 └─ Task 1.2: {Second task description}
 
 {Additional phases...}

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 → Start with Task 1.1: {task}?
```

---

## Task Granularity Guidelines

**Too coarse** (hard to track progress):
- "Implement authentication" 
- "Build the UI"

**Too fine** (overhead exceeds value):
- "Create user.rb file"
- "Add attr_accessor for name"

**Just right** (completable in 1-4 hours, clear end state):
- "Implement User model with validations and factory"
- "Create login form with email/password fields and error states"
- "Add mTLS certificate verification to agent connections"

---

## Spike Plans

Spikes are **time-boxed research**. They differ from features:

```markdown
## Overview

**Question**: {What are we trying to learn?}
**Time box**: {2h | 4h | 1d} - Stop and assess at this point
**Success criteria**: {What constitutes "enough" learning?}

## Approach

{What will you try? In what order?}

## Findings

{Updated during the spike}

### Option A: {Name}
- Pros: 
- Cons:
- Notes:

### Option B: {Name}
- Pros:
- Cons:
- Notes:

## Recommendation

{Filled in at end of spike}

## Next Steps

- [ ] {ADR to capture decision}
- [ ] {Feature plan if proceeding}
```

---

## Example: Guardian mTLS Plan

```markdown
# Plan: mTLS Agent Authentication

## Overview

**Goal**: Agents authenticate to Guardian server using mutual TLS certificates

**Why now**: Currently no auth - agents can connect without verification. 
Security requirement before any production use.

**Scope**: Certificate generation, server verification, agent verification. 
NOT: Certificate revocation, rotation automation, CA infrastructure.

## Context

Guardian agents currently connect via plain TCP. The server accepts any 
connection. For production use, we need:
1. Server verifies agent identity (agent presents cert)
2. Agent verifies server identity (server presents cert)

Evaluated options in ADR-002. Selected mTLS over API keys or JWT.

## Approach

Use Ruby's OpenSSL library directly. Generate self-signed CA for 
development. Each agent gets unique cert with CN = agent hostname.

## Tasks

Progress: 0/6 complete

### Phase 1: Certificate Infrastructure

- [ ] **Task 1.1**: Create development CA and generation scripts
  - Acceptance: Can generate CA, server cert, agent cert via rake task

- [ ] **Task 1.2**: Add certificate configuration to Guardian
  - Acceptance: Server reads CA, cert, key from config paths

### Phase 2: Server-Side Verification

- [ ] **Task 2.1**: Implement TLS server with client verification
  - Acceptance: Server rejects connections without valid client cert

- [ ] **Task 2.2**: Extract agent identity from certificate CN
  - Acceptance: Server logs "Agent {hostname} connected"

### Phase 3: Agent-Side Implementation

- [ ] **Task 3.1**: Update agent to use TLS with client certificate
  - Acceptance: Agent connects with cert, server accepts

- [ ] **Task 3.2**: Agent verifies server certificate
  - Acceptance: Agent rejects connection to server with invalid cert
```

---

## Usage

```bash
/create-plan                    # Interactive - will ask questions
/create-plan "Feature name"     # Start with name, ask rest
/create-plan --spike "Question" # Create a spike plan
```
