---
name: bootstrap
description: Initialize session with full context stack, state recovery, and adaptive briefing. Run at session start or when switching projects.
---

# Bootstrap Session

Initialize the development session with full context awareness. Loads the context stack, recovers prior state, calculates staleness, and presents an adaptive brief.

## When to Use

| Scenario | Command |
|----------|---------|
| Start of day | `/bootstrap` ✓ |
| Switching projects | `/bootstrap` ✓ |
| First time on project | `/bootstrap` ✓ |
| Return from long break | `/bootstrap` ✓ |
| Quick return (< few hours) | `/resume` (lighter) |
| Mid-session state check | `/resume` (lighter) |

## File Locations

```
~/.claude/CLAUDE.md              # Global context (identity, preferences)
.claude/CLAUDE.md                # Project context (lean, refs docs/)
docs/sessions/CURRENT.md         # Single source of truth for state
docs/sessions/archive/           # Historical session files
docs/plans/ACTIVE.md             # Symlink to current plan
docs/architecture/decisions/     # ADRs
TO-DOS.md                        # Outstanding work (project root)
```

---

## Execution Sequence

### Step 1: Environment Detection

```bash
# Identify project
PROJECT_ROOT=$(pwd)
PROJECT_NAME=$(basename "$PROJECT_ROOT")

# Git status
GIT_BRANCH=$(git branch --show-current 2>/dev/null || echo "not a git repo")
GIT_DIRTY=$(git status --porcelain 2>/dev/null | wc -l | tr -d ' ')
GIT_LAST_COMMIT=$(git log -1 --format="%h - %s" 2>/dev/null || echo "no commits")

# Configuration check
HAS_CLAUDE_DIR=$(test -d .claude && echo "yes" || echo "no")
HAS_DOCS_SESSIONS=$(test -d docs/sessions && echo "yes" || echo "no")
```

---

### Step 2: Context Stack Loading

Load and merge context files (project overrides global):

1. **Global Context**: `~/.claude/CLAUDE.md`
   - Identity, preferences, working style, conventions
   
2. **Project Context**: `.claude/CLAUDE.md`
   - Project-specific stack, patterns, references to docs/

If `.claude/CLAUDE.md` doesn't exist, note this and suggest creating one.

---

### Step 3: State Recovery & Staleness Calculation

#### 3a. Load CURRENT.md

Check for `docs/sessions/CURRENT.md`:

- **If exists**: Parse the `Last updated` timestamp from header
- **If missing**: First Claude session for this project

#### 3b. Calculate Staleness Tier

| Tier | Time Since Last Session | Brief Style |
|------|------------------------|-------------|
| 🟢 HOT | < 24 hours | Terse (3-4 lines) |
| 🟡 WARM | 1-7 days | Medium (state + key decisions) |
| 🟠 COOL | 8-30 days | Detailed (full context refresh) |
| 🔴 COLD | > 30 days | Full + environment verification suggestions |
| ⚪ NEW | No CURRENT.md | First session setup |

#### 3c. Load Supporting Files

1. **Active Plan**: `docs/plans/ACTIVE.md` (symlink to current plan)
2. **TODOs**: `TO-DOS.md` (project root)
3. **Recent ADRs**: `docs/architecture/decisions/` (if COOL/COLD)

---

### Step 4: Capability Inventory

Enumerate available tools:

```
Global Agents:    ~/.claude/agents/*.md
Project Agents:   .claude/agents/*.md (overrides global)

Global Commands:  ~/.claude/commands/*.md  
Project Commands: .claude/commands/*.md

Global Skills:    ~/.claude/skills/*/SKILL.md
Project Skills:   .claude/skills/*/SKILL.md
```

---

### Step 5: Generate Adaptive Brief

#### 🟢 HOT Brief (< 24 hours)

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 {PROJECT_NAME} │ {BRANCH} │ {N} uncommitted
 Task {X}/{Y}: {Task Name} ({STATUS})
 Tests: {status}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 → Continue with {next action from CURRENT.md}?
```

#### 🟡 WARM Brief (1-7 days)

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 {PROJECT_NAME} │ {BRANCH} │ Last session: {N} days ago
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

 WHAT'S HAPPENING
 {From CURRENT.md "What's Happening" section}
 
 Plan: {plan name} (Task {X} of {Y})
 Status: {status}

 KEY DECISIONS
 {From CURRENT.md "Key Decisions" section}

 OPEN QUESTIONS
 {From CURRENT.md "Open Questions" section}

 NEXT ACTIONS
 {From CURRENT.md "Next Actions" section}

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 → Resume with "{first next action}", or review state first?
```

#### 🟠 COOL Brief (8-30 days)

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 {PROJECT_NAME} │ {BRANCH} │ Last session: {N} days ago
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

 PROJECT OVERVIEW
 {From .claude/CLAUDE.md Overview section}

 STACK
 {From .claude/CLAUDE.md Stack section}

 WHAT YOU WERE BUILDING
 {From CURRENT.md "What's Happening" section}
 
 Plan: {plan path}
 Progress: Task {X} of {Y} - {task name}

 KEY DECISIONS (THIS WORK)
 {From CURRENT.md}

 OPEN QUESTIONS
 {From CURRENT.md}

 RECENT SESSION HISTORY
 {Last 2-3 entries from CURRENT.md Session History}

 NEXT ACTIONS
 {From CURRENT.md}

 UNCOMMITTED CHANGES
 {From git status}

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 RECOMMENDED
 1. Review CURRENT.md for full context
 2. Check uncommitted changes (git diff)
 3. Continue with next action

 → Show uncommitted diff, or continue with "{first action}"?
```

#### 🔴 COLD Brief (> 30 days)

Same as COOL, plus:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 ⚠️  ENVIRONMENT CHECK RECOMMENDED
 
 It's been over a month. Dependencies may have drifted.
 
 Suggested verification (run manually):
 
 # Ruby/Rails
 bundle install && bin/rails db:migrate:status && bin/rspec --dry-run
 
 # Node
 npm install && npm test -- --dry-run
 
 # Python
 pip install -r requirements.txt && python -m pytest --collect-only
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

#### ⚪ NEW Brief (No prior state)

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 {PROJECT_NAME} │ {BRANCH} │ First Claude Session
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

 PROJECT CONTEXT
 {From .claude/CLAUDE.md if exists, else "Not configured"}

 AVAILABLE TOOLS
 • {N} agents | {M} commands

 NO SESSION STATE FOUND
 This is the first Claude session for this project,
 or docs/sessions/CURRENT.md hasn't been created.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 GETTING STARTED
 1. Tell me what you'd like to work on
 2. Create a plan (/create-plan)
 3. Review TODOs (if TO-DOS.md exists)
 4. Set up project context (.claude/CLAUDE.md)

 → What would you like to do?
```

---

### Step 6: Update State

After presenting brief, update `docs/sessions/CURRENT.md`:

1. Update `Last updated` timestamp in header
2. Add session start entry to Session History:
   ```markdown
   ### {TIMESTAMP} - Session Start
   - Staleness: {tier}
   - Branch: {branch}
   - Resumed from: {task or "fresh"}
   ```

---

### Step 7: Directory Initialization

If required directories don't exist, create them:

```bash
mkdir -p .claude
mkdir -p docs/sessions/archive
mkdir -p docs/plans
mkdir -p docs/architecture/decisions
```

Do NOT auto-create content files. Note missing files in brief with suggestions.

---

## Symlink Management

### Plan Symlinks

When a plan is created/activated:
```bash
ln -sf "2025-01-10-feature.md" "docs/plans/ACTIVE.md"
```

When a plan completes:
```bash
rm -f docs/plans/ACTIVE.md
```

---

## Session Archival

When a major feature completes (triggered by `/archive-session` or end of major work):

```bash
# Move current state to archive with timestamp
mv docs/sessions/CURRENT.md "docs/sessions/archive/$(date +%Y-%m-%d-%H%M%S)-{feature-name}.md"

# Create fresh CURRENT.md from template
# (or let next bootstrap create it)
```

---

## Usage

```bash
/bootstrap           # Standard session initialization
/bootstrap --force   # Re-run even if already bootstrapped this session
```

---

## Integration

### Session Lifecycle

```
/bootstrap (start) → work → /whats-next (end)
                  ↑                    │
                  └────────────────────┘
                     Next session
```

### With /resume

`/bootstrap` is the full ceremony. `/resume` is the quick refresh:

| Aspect | /bootstrap | /resume |
|--------|------------|---------|
| When | Day start, project switch | Quick returns |
| Context load | Full stack | CURRENT.md only |
| Staleness | Calculates and adapts | Skips |
| Output | Adaptive by tier | Always compact |
| State update | Adds session start entry | No update |

### With /whats-next

State saved by `/whats-next` is loaded by `/bootstrap`:

```
/whats-next saves:          /bootstrap loads:
├─ Quick Reference    →     ├─ Quick Reference
├─ What's Happening   →     ├─ What's Happening  
├─ Next Actions       →     ├─ Next Actions
├─ Key Decisions      →     ├─ Key Decisions (if WARM+)
└─ Session History    →     └─ Session History (if COOL+)
```

### With Plans

If `docs/plans/ACTIVE.md` exists:
- Loads plan context into brief
- Shows task progress
- Syncs with CURRENT.md task reference

### Typical Day Flow

```
Morning:   /bootstrap         → Full context load
           work...
Lunch:     /whats-next --pause → Quick state save
           break
Return:    /resume            → Quick refresh
           work...
End of day: /whats-next       → Full handoff
```
