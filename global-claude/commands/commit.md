---
name: commit
description: Guided commit with conventional message format, optional pre-commit checks, and workflow integration.
---

# Commit

Create well-formatted commits with optional quality checks. Integrates with session state and plans.

**Scope**: Quick, clean commits on a healthy branch. For complex git operations, escalate to `git-workflow-manager`.

## Usage

```bash
/commit                         # Interactive - stages, checks, commits
/commit "message"               # Quick commit with message
/commit --amend                 # Amend previous commit
/commit --fixup abc123          # Create fixup commit
/commit --wip                   # Work-in-progress commit
```

## When to Use This vs git-workflow-manager

| Situation | Use |
|-----------|-----|
| **Quick local commit** | `/commit` ✓ |
| **Currently on main** | `/commit` ✓ (auto-creates branch) |
| Amend last commit (not pushed) | `/commit --amend` ✓ |
| Create fixup for later squash | `/commit --fixup` ✓ |
| **Ready to push + create PR** | `git-workflow-manager` or "push code" |
| Need to rebase first | `git-workflow-manager` |
| Merge conflicts present | `git-workflow-manager` |
| Force push required | `git-workflow-manager` |
| History rewriting | `git-workflow-manager` |
| Post-merge branch cleanup | `git-workflow-manager` (auto-triggered) |

**Key difference:**
- **`/commit`**: Local branch safety + commit (doesn't push)
- **`git-workflow-manager`**: Branch + commit + push + PR (full workflow)

---

## Execution

### Step 0: Branch Safety Check

**CRITICAL**: Never commit directly to protected branches.

```bash
# Get current branch
current_branch=$(git branch --show-current)
main_branch=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@' || echo "main")

# Check if on protected branch
if [[ "$current_branch" == "main" || "$current_branch" == "master" || "$current_branch" == "$main_branch" ]]; then
  # Protected branch detected - must create feature branch
  # Display warning and generate smart branch name suggestion
fi
```

**If on protected branch (main/master), display:**

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 ⚠️  BRANCH SAFETY CHECK
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

 You're on: main (protected branch)

 Commits require a feature branch for safety.

 Based on your work:
 • Context: "Improving workflow UX"
 • Modified: commands/archive-session.md, commands/end-session.md

 Suggested branch: feature/workflow-ux-improvements

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

**Generate smart branch name suggestion:**

1. **Check CURRENT.md "What's Happening"** - Use this for context
   ```bash
   # Extract from CURRENT.md if exists
   what_happening=$(grep -A 1 "## What's Happening" docs/sessions/CURRENT.md | tail -1)
   ```

2. **Infer type from changed files:**
   ```
   Files changed              → Inferred type
   ─────────────────────────────────────────
   app/models/*.rb            → feature/
   spec/**/*_spec.rb          → test/
   app/services/*.rb          → feature/
   config/**                  → chore/
   *.md (docs only)           → docs/
   Rakefile, Gemfile, *.gemspec → chore/
   lib/**/bug_fix.rb          → bugfix/
   ```

3. **Slugify context into branch name:**
   ```
   "Improving workflow UX" → "workflow-ux-improvements"
   "Add user authentication" → "user-authentication"
   "Fix login bug" → "login-bug"
   ```

4. **Combine: `{type}/{slug}`**
   ```
   feature/workflow-ux-improvements
   bugfix/login-issue
   docs/update-readme
   ```

**Then ask with AskUserQuestion:**

- **Question**: "Create feature branch before committing?"
- **Options**:
  1. **"Create feature/{suggested-name} (Recommended)"** - Description: "Create branch and commit to it"
  2. **"Specify different branch name"** - Description: "I'll provide a custom branch name"
  3. **"Use git-workflow-manager instead"** - Description: "Full push workflow (branch + commit + push + PR)"
  4. **"Cancel - I'll create branch manually"** - Description: "Abort this commit"

**If option 1 (use suggestion):**
```bash
git checkout -b "feature/{suggested-name}"
```

```
✓ Created and switched to: feature/workflow-ux-improvements

Proceeding with commit on new branch...
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

**If option 2 (custom name):**
```
Enter branch name (e.g., feature/my-work, bugfix/issue-123): _
```

Validate format:
- Warns if doesn't start with type prefix (feature/, bugfix/, etc.)
- Suggests correction if malformed
- Creates branch and continues

**If option 3 (git-workflow-manager):**
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Switching to git-workflow-manager
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

 This provides full workflow:
 • Create feature branch
 • Commit changes
 • Push to remote
 • Create pull request

 Note: You said "push code" triggers git-workflow-manager.
 Just say that to invoke the full workflow.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

Exit `/commit`, prompt user to say "push code".

**If option 4 (cancel):**
```
✗ Commit cancelled

To commit this work:
  1. Create branch: git checkout -b feature/your-branch-name
  2. Run: /commit

Or use git-workflow-manager for full push workflow.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

Exit without committing.

---

### Step 1: Check Status

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 📦 COMMIT
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

 Branch: feature/agent-auth
 
 Staged (3 files):
 • M app/models/agent.rb
 • A app/services/authenticator.rb
 • A spec/services/authenticator_spec.rb

 Unstaged (2 files):
 • M config/guardian.yml
 • M README.md

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 → Stage additional files? [y/N]
```

### Step 2: Pre-commit Checks (Optional)

```
 → Run pre-commit checks? [Y/n]
```

If yes, runs `/pre-commit` (lint + affected tests).

### Step 3: Generate Commit Message

Analyze changes and suggest message:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 COMMIT MESSAGE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

 Based on changes, suggested message:

 ┌────────────────────────────────────────────────┐
 │ feat(auth): implement certificate verification │
 │                                                │
 │ Add AuthenticatorService for mTLS cert verify. │
 │ Agents must present valid certificate to       │
 │ connect.                                       │
 │                                                │
 │ - Add Authenticator service with cert parsing  │
 │ - Update Agent model with auth hooks           │
 │ - Add specs for valid/invalid certs            │
 │                                                │
 │ Part of: Plan task 2.1                         │
 └────────────────────────────────────────────────┘

 [U]se as-is | [E]dit | [R]ewrite | [C]ancel

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### Step 4: Commit

```bash
git commit -m "feat(auth): implement certificate verification

Add AuthenticatorService for mTLS cert verify.
Agents must present valid certificate to connect.

- Add Authenticator service with cert parsing
- Update Agent model with auth hooks  
- Add specs for valid/invalid certs

Part of: Plan task 2.1"
```

### Step 5: Post-commit Actions

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 ✓ COMMITTED: abc1234
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

 feat(auth): implement certificate verification

 → Update CURRENT.md with this commit? [Y/n]
 → Mark plan task 2.1 complete? [y/N]
 → Push to origin? [y/N]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## Conventional Commit Format

```
{type}({scope}): {subject}

{body}

{footer}
```

### Type (Required)

| Type | When to Use |
|------|-------------|
| `feat` | New feature for users |
| `fix` | Bug fix for users |
| `refactor` | Code change, no feature/fix |
| `perf` | Performance improvement |
| `test` | Adding/fixing tests |
| `docs` | Documentation only |
| `style` | Formatting (no logic change) |
| `chore` | Maintenance, deps, config |
| `build` | Build system changes |
| `ci` | CI configuration |
| `revert` | Reverting previous commit |

### Scope (Optional)

Area of codebase: `auth`, `api`, `ui`, `db`, `config`, etc.

### Subject (Required)

- Imperative mood: "add" not "added" or "adds"
- No period at end
- Under 50 characters
- Lowercase first letter

### Body (Optional)

- Explain what and why, not how
- Wrap at 72 characters
- Blank line between subject and body

### Footer (Optional)

- Reference issues: `Closes #123`
- Breaking changes: `BREAKING CHANGE: description`
- Co-authors: `Co-authored-by: Name <email>`

---

## Examples

### Branch Safety in Action

**Scenario: Currently on main, want to commit**

```
User on main: /commit

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 ⚠️  BRANCH SAFETY CHECK
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

 You're on: main (protected branch)

 Based on your work:
 • Context: "Add user authentication"
 • Modified: app/models/user.rb, app/controllers/auth_controller.rb

 Suggested branch: feature/user-authentication

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

→ Options:
  1. Create feature/user-authentication (Recommended)
  2. Specify different branch name
  3. Use git-workflow-manager instead
  4. Cancel

User selects: 1

✓ Created and switched to: feature/user-authentication

Proceeding with commit...
```

### Simple Feature
```
feat(auth): add certificate verification
```

### Bug Fix with Context
```
fix(api): handle nil hostname gracefully

The agent registration could crash when hostname
was nil. Now returns 400 Bad Request instead.

Closes #456
```

### Breaking Change
```
feat(api)!: require authentication on all endpoints

All API endpoints now require valid JWT token.
Previously, /health and /status were public.

BREAKING CHANGE: /health and /status now require auth.
Migration: Update monitoring to include auth headers.
```

### Refactoring
```
refactor(models): extract validation to concern

Move shared validation logic to ValidatableAgent
concern. Reduces duplication across Agent and
AgentConfig models.
```

### Multi-part Work
```
feat(auth): implement certificate verification

Part 1 of 3 for mTLS agent authentication.
This commit adds the verification logic.
Next: server-side integration.

Part of: Plan task 2.1
See: ADR-002
```

---

## Special Commit Types

### WIP Commit

For work-in-progress that shouldn't be merged:

```bash
/commit --wip
```

Creates:
```
wip: certificate verification (do not merge)

Work in progress. Still needs:
- [ ] Error handling
- [ ] Tests
```

### Fixup Commit

For amending a previous commit (will be squashed):

```bash
/commit --fixup abc123
```

Creates:
```
fixup! feat(auth): add certificate verification
```

Use with `git rebase -i --autosquash`.

### Amend

Fix the previous commit:

```bash
/commit --amend
```

Options:
- Keep message, update files
- Update message
- Both

---

## Workflow Integration

### With Plans

If working on a plan task:

```
 Related to plan task 2.1?
 → Include "Part of: Plan task 2.1" in message? [Y/n]
 → Mark task complete after commit? [y/N]
```

### With Session State

Updates CURRENT.md Session History:

```markdown
### 2025-01-16 14:30 - Commit abc1234
- feat(auth): implement certificate verification
- 3 files changed, +82 lines
```

### With TODOs

If commit addresses a TODO:

```
 This appears to address TODO: "Add auth to agent connections"
 → Mark TODO complete? [Y/n]
```

---

## Best Practices

### Atomic Commits

Each commit should be:
- One logical change
- Self-contained (passes tests)
- Revertable without breaking other things

### Commit Frequency

```
Too few:  Giant commits mixing features, fixes, refactors
          Hard to review, hard to revert
          
Too many: Tiny commits that don't work alone
          "Add file" "Fix typo" "Actually fix typo"
          
Just right: Logical units of work
            Each commit compiles and tests pass
            Clear history telling the story
```

### Before Committing

Ask yourself:
- Is this one logical change?
- Would the message make sense in 6 months?
- Does this commit work on its own?
- Am I mixing unrelated changes?

---

## Usage Summary

```bash
/commit                  # Interactive guided commit
/commit "message"        # Quick commit
/commit --amend          # Amend previous
/commit --fixup abc123   # Fixup for squash
/commit --wip            # Work-in-progress
/commit --no-verify      # Skip pre-commit checks
```

---

## Escalate to git-workflow-manager

This command handles simple commits. Escalate to `git-workflow-manager` when:

- **Rebase needed**: Branch is behind, needs updating before commit
- **Conflicts present**: Merge/rebase conflicts need resolution
- **History cleanup**: Interactive rebase to squash/reorder commits
- **Force push**: Any operation requiring `--force-with-lease`
- **Branch prep**: Getting branch ready for PR (cleanup, squash, rebase onto main)
- **Recovery**: Detached HEAD, lost commits, corrupted state

```
💡 git-workflow-manager is the "big dog" for:
   • Preparing branches for push/PR
   • Interactive rebases
   • Conflict resolution
   • History rewriting
   • Safe force operations
```
