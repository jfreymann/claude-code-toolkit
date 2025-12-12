---
name: update-plan
description: Update the active plan - mark tasks complete, add tasks, update status, or record decisions/learnings.
---

# Update Plan

Modifies the active plan in `docs/plans/ACTIVE.md` to reflect progress, changes, or learnings.

## Operations

### Mark Task Complete

```bash
/update-plan complete 1.1
/update-plan complete "Task description substring"
```

**Actions:**
1. Find the task in ACTIVE.md
2. Change `- [ ]` to `- [x]`
3. Update progress counter (e.g., "Progress: 2/6 complete")
4. Add completion note to plan History section
5. Update CURRENT.md Quick Reference with new progress

**Output:**
```
✓ Task 1.1 marked complete (2/6)
  "Create development CA and generation scripts"

Next task: 1.2 - Add certificate configuration to Guardian
```

---

### Add Task

```bash
/update-plan add-task 1.3 "Description" --after 1.2
/update-plan add-task "Description" --phase 2
```

**Actions:**
1. Add new task to specified location
2. Update task numbering if needed
3. Update total task count
4. Add note to plan History

**Output:**
```
+ Added Task 1.3: "Handle certificate expiration gracefully"
  Progress: 2/7 complete
```

---

### Remove/Skip Task

```bash
/update-plan skip 2.3 --reason "Covered by task 2.1"
```

**Actions:**
1. Mark task with ~~strikethrough~~ or move to "Skipped" section
2. Record reason in History
3. Update progress counter (denominator decreases)

**Output:**
```
⊘ Task 2.3 skipped: "Covered by task 2.1"
  Progress: 2/5 complete
```

---

### Reorder Tasks

```bash
/update-plan move 2.1 --before 1.3
/update-plan reorder   # Interactive reordering
```

---

### Add Decision

```bash
/update-plan decision "Chose X over Y because Z"
```

**Actions:**
1. Add to plan's "Key Technical Decisions" section
2. Prompt: "Should this be captured as an ADR?"
3. If yes, offer to run `/create-adr`

---

### Resolve Question

```bash
/update-plan resolve "Question text" --answer "The answer"
```

**Actions:**
1. Find question in "Open Questions > Unresolved"
2. Move to "Resolved" with answer and date
3. Add to plan History

**Output:**
```
? Resolved: "Which TLS library?"
  → "Using Ruby's OpenSSL directly - mature, no dependencies"
```

---

### Add Note

```bash
/update-plan note "Important learning or observation"
```

**Actions:**
1. Append to plan's Notes section with timestamp

---

### Update Status

```bash
/update-plan status paused --reason "Waiting on dependency"
/update-plan status complete
/update-plan status abandoned --reason "Approach changed"
```

**Actions:**
1. Update Status in plan header
2. If complete/abandoned:
   - Remove ACTIVE.md symlink
   - Archive plan to `docs/plans/archive/`
   - Trigger `/archive-session` prompt if appropriate

---

## Progress Tracking

The plan maintains a progress counter:

```markdown
## Tasks

Progress: 3/6 complete
```

This is automatically updated when tasks are completed, added, or skipped.

CURRENT.md mirrors this in Quick Reference:

```markdown
## Quick Reference
- **Plan**: docs/plans/2025-01-15-mtls-auth.md
- **Task**: 3/6 - Task 2.1: Implement TLS server
```

---

## Plan Evolution

Plans evolve. Common evolutions:

### Scope Expansion
```bash
# Reality: "We also need X"
/update-plan add-task "Handle X" --phase 2
/update-plan note "Scope expanded to include X - necessary for Y"
```

### Scope Reduction  
```bash
# Reality: "X isn't actually needed"
/update-plan skip 2.3 --reason "Not needed - Z handles this"
```

### Approach Change
```bash
# Reality: "Original approach won't work"
/update-plan decision "Switching from A to B because..."
/update-plan skip 1.3 --reason "Not applicable with new approach"
/update-plan add-task "New task for approach B" --phase 1
```

### Discovery
```bash
# Reality: "Found something important"
/update-plan note "Discovery: System already has X, can reuse"
/update-plan resolve "Do we need to build X?" --answer "No, exists in lib/x.rb"
```

---

## Sync with CURRENT.md

After any plan update, CURRENT.md should reflect:

1. **Quick Reference**: Current task number and name
2. **What's Happening**: If focus changed
3. **Key Decisions**: If significant decision made
4. **Session History**: Log the update

The update-plan command handles Quick Reference automatically. For other sections, it prompts:

```
Plan updated. Also update CURRENT.md?
- What's Happening section? [y/N]
- Key Decisions section? [y/N]
```

---

## Viewing Plan Status

```bash
/update-plan status   # Show current progress
```

**Output:**
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 📋 mTLS Agent Authentication
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

 Progress: 3/6 complete (50%)
 Status: Active
 
 ✓ Phase 1: Certificate Infrastructure (2/2)
   ✓ 1.1 Create development CA and generation scripts
   ✓ 1.2 Add certificate configuration to Guardian
 
 → Phase 2: Server-Side Verification (1/2)
   ✓ 2.1 Implement TLS server with client verification
   ○ 2.2 Extract agent identity from certificate CN
 
 ○ Phase 3: Agent-Side Implementation (0/2)
   ○ 3.1 Update agent to use TLS with client certificate
   ○ 3.2 Agent verifies server certificate

 Open Questions: 1 unresolved
 
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 → Continue with 2.2: Extract agent identity?
```

---

## Usage Summary

```bash
# Progress
/update-plan complete 1.1              # Mark task done
/update-plan status                    # View progress

# Modify
/update-plan add-task "Desc" --phase 1 # Add task
/update-plan skip 2.3 --reason "..."   # Skip task
/update-plan move 2.1 --before 1.3     # Reorder

# Record
/update-plan decision "Chose X..."     # Record decision
/update-plan resolve "Question" --answer "..."
/update-plan note "Learning..."        # Add note

# Status
/update-plan status paused             # Pause plan
/update-plan status complete           # Complete plan
```
