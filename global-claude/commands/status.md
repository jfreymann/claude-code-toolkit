---
description: Update project status.md with comprehensive repository state analysis
arguments:
  - name: focus
    description: Optional focus area (e.g., "tasks", "health", "full")
    required: false
---

# /status - Authoritative Project Status Update

Update `status.md` to be the **single source of truth** for project state by performing comprehensive repository analysis.

## Core Principle

> **`status.md` is the ABSOLUTE AUTHORITATIVE document for project status.**
> All other sources (todos, plans, changelogs) are inputs that feed INTO status.md, not peers.

## Execution Workflow

### Step 1: Gather Repository Intelligence

Execute these analyses in sequence:

```
1. Read existing status.md (if present) to preserve context
2. git status                          → uncommitted changes
3. git log --oneline -15               → recent activity
4. git branch -vv                      → branch state
5. Read CHANGELOG.md                   → version/release info
6. Read TO-DOS.md / PLAN.md            → task state
7. Scan for TODO/FIXME/HACK comments   → technical debt
8. Assess context health               → session metrics
```

### Step 1.5: Calculate Context Health

**Context health indicators:**

| Messages | Context % | Status | Recommendation |
|----------|-----------|--------|----------------|
| 0-20 | 0-30% | 🟢 Fresh | Continue normally |
| 21-40 | 31-60% | 🟢 Healthy | Continue normally |
| 41-60 | 61-80% | 🟡 Getting full | Consider /clean-slate after current task |
| 61-80 | 81-90% | 🟠 Nearly full | Recommend /clean-slate soon |
| 81+ | 91-100% | 🔴 Critical | Strongly recommend /clean-slate now |

**Calculate approximately:**
- Estimate ~1.5K tokens per message on average
- Claude's context window is ~200K tokens
- Message count is a proxy for context usage

**Check last state save:**
- Look for most recent entry in `docs/sessions/CURRENT.md`
- If last save >2 hours ago, note it

**Session duration markers:**
- < 1 hour: Fresh session
- 1-2 hours: Normal session
- 2-3 hours: Consider compression
- > 3 hours: Strong recommendation to compress

### Step 2: Cross-Reference Project Commands

If these commands/agents exist in the project, invoke or reference their output:

| Command | Information to Extract |
|---------|----------------------|
| `/sync` | Remote sync state, push/pull status |
| `/whats-next` | Prioritized next actions, handoff context |
| `/check-todos` | Outstanding items, completion status |
| `changelog-generator` agent | Latest release notes, unreleased changes |

### Step 3: Synthesize & Write status.md

Generate `status.md` in the **project root** with this exact structure:

```markdown
# Project Status

> **This file is the authoritative source of truth for project state.**
> Last updated: [YYYY-MM-DD HH:MM:SS] via `/status` command

## Quick Reference

| Attribute | Value |
|-----------|-------|
| Branch | `[current-branch]` |
| Version | `[version from changelog/package]` |
| Last Commit | `[short hash] - [message]` |
| Working Tree | `[clean/dirty - X files changed]` |

## Executive Summary

[2-3 sentences: What is the project's current momentum? What's the primary focus?]

---

## 🔄 Active Work

Items currently in progress:

- [ ] **[Task Name]** - [Brief status/progress note]
- [ ] **[Task Name]** - [Brief status/progress note]

## ✅ Recently Completed

Items completed since last status update:

- [x] **[Task Name]** - Completed [date]
- [x] **[Task Name]** - Completed [date]

## 📋 Queued / Next Up

Priority-ordered upcoming work:

1. [Next priority item]
2. [Second priority]
3. [Third priority]

---

## Repository Health

| Check | Status | Notes |
|-------|--------|-------|
| Uncommitted Changes | ✅/⚠️ | [details] |
| Tests | ✅/❌/❓ | [pass/fail/unknown] |
| Lint | ✅/⚠️/❓ | [clean/warnings/unknown] |
| Documentation | ✅/⚠️ | [current/needs update] |
| Technical Debt | 🟢/🟡/🔴 | [X TODOs, Y FIXMEs] |

## Context Health

| Metric | Value | Recommendation |
|--------|-------|----------------|
| Session Messages | [count] messages | [status indicator] |
| Estimated Context | [percentage]% full (~[X]K tokens) | [action if needed] |
| Last State Save | [time ago] | [status] |
| Session Duration | [duration] | [status] |

**Context Status:** [🟢 Fresh / 🟡 Consider compressing / 🔴 Should compress]

[If context is getting full, add recommendation:]
⚠️  **Context Recommendation**: [Specific action like "Consider running /clean-slate after current task" or "Context is healthy, continue working"]

## ⛔ Blockers & Dependencies

[List any blocking issues, external dependencies, or items waiting on others]

- **[Blocker]**: [Description and what's needed to unblock]

## 📝 Session Notes & Context

[Important context for future sessions, architectural decisions, gotchas, etc.]

---

## Change Log

| Date | Update |
|------|--------|
| [date] | [What changed in project status] |
| [date] | [Previous update summary] |

---
*Generated by `/status` command. This file should be updated at the start and end of each work session.*
```

### Step 4: Validate & Report

After writing `status.md`:

1. **Confirm** the file was written successfully
2. **Summarize** key changes from previous status (if existed)
3. **Highlight** any concerns (blockers, failing tests, stale areas)
4. **Recommend** the logical next action based on current state

## Usage Examples

```
/status                  # Full status update
/status focus:tasks      # Focus on task tracking sections
/status focus:health     # Focus on repository health assessment
```

## Guidelines

- **Be factual**: Only include verifiable information from the repository
- **Preserve history**: Keep Change Log entries from previous status.md
- **Be actionable**: Any developer should immediately know what to do next
- **Be concise**: Scannable over comprehensive; link to details don't repeat them
- **Timestamp everything**: Future sessions need temporal context

## Integration Notes

This command is designed to work alongside:
- `/whats-next` - For handoff documents (status.md is the persistent version)
- `/sync` - For repository synchronization before status update
- `/add-to-todos` - Tasks added via this command should appear in status
- `/check-todos` - Outstanding todos should be reflected in Active Work

---

*The goal: Any Claude Code session can `/status` at start to get full context, and `/status` at end to leave a clean handoff.*
