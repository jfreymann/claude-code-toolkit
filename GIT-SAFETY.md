# Git Safety System

## The Problem

Claude Code should **NEVER** automatically commit or push code without explicit user intent. Automatic git operations are dangerous and violate user control.

## Protection Layers

This toolkit implements multiple layers of defense to prevent automatic git operations:

### Layer 1: Global Instructions (Primary)

**File**: `~/.claude/CLAUDE.md`

Contains explicit "Git Safety Rules" that prohibit:
- Automatic commits after writing code
- Proactive git operations
- Assuming "feature complete" means "commit and push"
- Pushing to main/master under any circumstances

**Scope**: Applies to ALL Claude Code sessions, ALL projects.

### Layer 2: Slash Command Safety

**Files**: `global-claude/commands/commit.md`, `global-claude/commands/pre-commit.md`

Built-in branch safety checks:
- Detect if on main/master branch
- Force creation of feature branch before committing
- Never allow commits directly to protected branches

**Usage**: `/commit` and `/pre-commit` include automatic protection.

### Layer 3: Git Workflow Manager Constraints

**File**: `global-claude/agents/git-workflow-manager.md`

Hard constraints in the agent definition:
- MUST NEVER push directly to main or master
- MUST NEVER add Claude attribution to commits
- MUST create backups before destructive operations
- MUST use `--force-with-lease` exclusively

**Trigger**: When user says "push code" or delegates to git-workflow-manager.

### Layer 4: Git Hook (Optional Safety Net)

**File**: `project-templates/pre-commit-hook`

Git pre-commit hook that blocks commits to main/master at the git level.

**Installation**:
```bash
# In your project root
cp ~/claude-code-toolkit/project-templates/pre-commit-hook .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit
```

**Effect**: Git itself will reject commits to protected branches, even if Claude tries.

---

## How It Works

### Normal Workflow (Safe)

```
User: "I implemented the login feature"
Claude: "Implementation complete. Ready to commit? Use /pre-commit or /commit"
User: "/commit"
Claude: *checks branch, creates feature branch if needed, commits*
```

### Blocked Workflow (Prevented)

```
User: "The feature is complete"
Claude: ❌ *does NOT auto-commit*
Claude: ✅ "Feature looks complete. Ready to commit? (Use /pre-commit or /commit)"
```

### Required User Intent

Git operations ONLY happen when user explicitly:
- Runs `/commit` or `/pre-commit`
- Says "push code" (triggers git-workflow-manager)
- Delegates to git-workflow-manager
- Explicitly asks "commit this" or "push this"

---

## Installation

### For Your Machine (Global Protection)

Already done if you ran `install.sh`:
- `~/.claude/CLAUDE.md` includes Git Safety Rules
- `~/.claude/commands/` includes safe commit commands
- `~/.claude/agents/git-workflow-manager.md` includes constraints

### For Each Project (Additional Protection)

1. **Use toolkit initialization**:
   ```bash
   cd your-project
   ~/claude-code-toolkit/init-project.sh
   ```

2. **Install git hook** (optional but recommended):
   ```bash
   cp ~/claude-code-toolkit/project-templates/pre-commit-hook .git/hooks/pre-commit
   chmod +x .git/hooks/pre-commit
   ```

3. **Verify protection**:
   ```bash
   # Try to commit on main (should fail)
   git checkout main
   echo "test" >> test.txt
   git add test.txt
   git commit -m "test"  # Should be blocked by hook
   ```

---

## For Your Other Computer

You mentioned Claude auto-committed on another computer. To prevent this:

### 1. Update Toolkit (If Already Installed)

If you already have the toolkit installed:

```bash
# On the other computer
cd ~/claude-code-toolkit
git pull
```

### 2. Add Git Safety Rules to CLAUDE.md

**If CLAUDE.md already exists** (toolkit was previously installed):

```bash
cd ~/claude-code-toolkit
./update-safety-rules.sh
```

This migration script will:
- Create a timestamped backup of your existing CLAUDE.md
- Add Git Safety Rules section without losing your customizations
- Safe to run multiple times (idempotent)

**If CLAUDE.md doesn't exist** (fresh install):

```bash
cd ~/claude-code-toolkit
./install.sh
```

This creates CLAUDE.md with Git Safety Rules already included.

### 3. Install Git Hook in Guardian Project

```bash
# On the other computer, in guardian project
cd /path/to/guardian
cp ~/claude-code-toolkit/project-templates/pre-commit-hook .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit
```

### 4. Verify Installation

```bash
# Check that CLAUDE.md exists
ls -la ~/.claude/CLAUDE.md

# Check for Git Safety Rules
grep "Git Safety Rules" ~/.claude/CLAUDE.md
```

**Expected output**: Should show "## Git Safety Rules" at line ~103

If the file doesn't exist or doesn't have Git Safety Rules, Claude Code won't have the constraints.

---

## Emergency: If Auto-Commit Happens

If Claude auto-commits despite these protections:

### 1. Undo the Commit (If Not Pushed)

```bash
# Undo last commit, keep changes
git reset --soft HEAD~1

# Or undo and discard changes
git reset --hard HEAD~1
```

### 2. If Already Pushed to Main

```bash
# Create feature branch from the bad commit
git checkout -b feature/recovery-branch

# Reset main to before the bad commit
git checkout main
git reset --hard HEAD~1

# Force push to fix main (⚠️ coordinate with team first)
git push origin main --force-with-lease
```

### 3. Report the Issue

If auto-commit happens despite having the toolkit installed:
1. Check `~/.claude/CLAUDE.md` exists and has Git Safety Rules
2. Check which commands Claude ran (`history` or `.bash_history`)
3. File issue at: https://github.com/jfreymann/claude-code-toolkit/issues

---

## FAQ

**Q: Will this prevent me from committing manually?**
A: No. You can still run `git commit` manually anytime. The hook only blocks commits to main/master.

**Q: What if I need to commit to main?**
A: You shouldn't. But if absolutely necessary:
```bash
git commit --no-verify  # Bypass hook (not recommended)
```

**Q: Will this slow down my workflow?**
A: No. The slash commands are fast, and the workflow is designed to be efficient:
- `/pre-commit` - Quick quality checks
- `/commit` - Safe commit with good message
- "push code" - Full branch prep and PR creation

**Q: What if the hook doesn't work?**
A: The hook is optional. Layers 1-3 (CLAUDE.md, slash commands, git-workflow-manager) provide the primary protection.

**Q: How do I know it's working?**
A: Try to commit on main:
```bash
git checkout main
touch test.txt
git add test.txt
git commit -m "test"  # Should fail with safety message
```

---

## Checklist: Am I Protected?

Run this on each computer and each project:

### Global (Per Computer)

- [ ] `~/.claude/CLAUDE.md` exists
- [ ] `~/.claude/CLAUDE.md` contains "Git Safety Rules"
- [ ] `~/.claude/commands/commit.md` exists
- [ ] `~/.claude/agents/git-workflow-manager.md` exists

### Per Project

- [ ] `.git/hooks/pre-commit` exists (optional)
- [ ] `.git/hooks/pre-commit` is executable (`chmod +x`)
- [ ] Hook blocks commits to main (test it)

---

## Summary

**The toolkit prevents auto-commits through:**
1. Explicit rules in CLAUDE.md (all sessions)
2. Branch safety in /commit commands
3. Hard constraints in git-workflow-manager
4. Optional git hook as failsafe

**User control is maintained:**
- Git operations require explicit user intent
- Claude MUST ask, never assume
- All protections can be overridden by user if needed

**Install on all computers and all projects for full protection.**
