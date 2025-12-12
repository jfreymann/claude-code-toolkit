---
name: pre-commit
description: Run quality checks before committing. Linting, tests, security scan, and commit message formatting.
---

# Pre-Commit

Quality gate before committing code. Catches issues early, ensures consistent commits.

**Scope**: Quick quality checks on staged changes. For branch preparation and git operations, escalate to `git-workflow-manager`.

## When to Use

- Before any commit
- After `/implement` completes a task
- Before pushing to remote
- When CI keeps failing locally-fixable issues

## When to Use This vs git-workflow-manager

| Situation | Use |
|-----------|-----|
| Lint + test before commit | `/pre-commit` ✓ |
| Quick security scan | `/pre-commit --security` ✓ |
| Full test suite | `/pre-commit --full` ✓ |
| Branch needs rebasing | `git-workflow-manager` |
| Squash commits before PR | `git-workflow-manager` |
| Prepare branch for push | `git-workflow-manager` |
| Resolve conflicts | `git-workflow-manager` |

## Quick Mode vs Full Mode

```bash
/pre-commit              # Quick: lint + affected tests
/pre-commit --full       # Full: lint + all tests + security
/pre-commit --security   # Security scan only
```

---

## Execution

### Step 1: Identify Changes

```bash
# Staged changes
git diff --cached --name-only

# Unstaged changes (warn if present)
git diff --name-only
```

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 📋 PRE-COMMIT CHECK
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

 Staged files: 4
 • app/models/agent.rb
 • app/services/authenticator.rb
 • spec/models/agent_spec.rb
 • spec/services/authenticator_spec.rb

 ⚠️  Unstaged changes: 2 files
 • config/guardian.yml (not staged)
 • README.md (not staged)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### Step 2: Run Linting

Detect linter and run on changed files:

| Language | Linter | Command |
|----------|--------|---------|
| Ruby | RuboCop | `bundle exec rubocop {files}` |
| JavaScript/TS | ESLint | `npx eslint {files}` |
| Python | Ruff/Flake8 | `ruff check {files}` |
| Go | golangci-lint | `golangci-lint run {files}` |

```
 LINT
 ────────────────────────────────────────────────
 ✓ RuboCop: 4 files, no offenses
```

Or with issues:
```
 LINT
 ────────────────────────────────────────────────
 ✗ RuboCop: 2 offenses

   app/models/agent.rb:15:5 Layout/IndentationWidth
   app/services/authenticator.rb:42:80 Layout/LineLength

 → Auto-fix with `rubocop -a`? [y/N]
```

### Step 3: Run Tests

**Quick mode**: Tests for changed files only
**Full mode**: Entire test suite

```
 TESTS
 ────────────────────────────────────────────────
 Running: spec/models/agent_spec.rb
          spec/services/authenticator_spec.rb

 ✓ 12 examples, 0 failures (1.2s)
```

### Step 4: Security Scan (--full or --security)

Run security tools if available:

| Language | Tool | Checks |
|----------|------|--------|
| Ruby | Brakeman | SQL injection, XSS, etc. |
| Ruby | bundler-audit | Vulnerable gems |
| JavaScript | npm audit | Vulnerable packages |
| Python | safety/bandit | Vulnerable deps, code issues |

```
 SECURITY
 ────────────────────────────────────────────────
 ✓ Brakeman: No warnings
 ✓ bundler-audit: No vulnerabilities
```

Or with issues:
```
 SECURITY
 ────────────────────────────────────────────────
 ⚠️  bundler-audit: 1 vulnerability

   CVE-2024-1234 in nokogiri < 1.15.0
   Severity: Medium
   Fix: bundle update nokogiri

 → This should be addressed before deploying.
   Continue with commit anyway? [y/N]
```

### Step 5: Generate Commit Message

Based on changes, suggest a commit message:

```
 COMMIT MESSAGE
 ────────────────────────────────────────────────
 Suggested:

   feat(auth): add certificate-based agent authentication

   - Add Agent#authenticate method with cert verification
   - Extract AuthenticatorService for mTLS handling
   - Add specs for valid/invalid certificate cases

 Format: {type}({scope}): {description}
 Types: feat|fix|refactor|docs|test|chore

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 → Use this message? [Y/n/edit]
```

### Step 6: Summary & Commit

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 ✓ PRE-COMMIT PASSED
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

 ✓ Lint: passed
 ✓ Tests: 12 passed
 ✓ Security: no issues

 Ready to commit:
   git commit -m "feat(auth): add certificate-based agent authentication"

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 → Commit now? [Y/n]
```

---

## Commit Message Convention

Follow conventional commits:

```
{type}({scope}): {description}

{body - optional}

{footer - optional}
```

### Types

| Type | Use For |
|------|---------|
| `feat` | New feature |
| `fix` | Bug fix |
| `refactor` | Code change that neither fixes nor adds |
| `docs` | Documentation only |
| `test` | Adding or fixing tests |
| `chore` | Maintenance, dependencies, config |
| `perf` | Performance improvement |
| `style` | Formatting, whitespace (no code change) |

### Scope

Optional, indicates area: `auth`, `api`, `ui`, `db`, etc.

### Examples

```
feat(auth): add mTLS certificate verification
fix(api): handle nil agent hostname gracefully
refactor(models): extract validation to concern
test(auth): add specs for expired certificate handling
chore(deps): update rails to 7.1.2
docs(readme): add certificate setup instructions
```

---

## Handling Failures

### Lint Failures

```
 → Auto-fix available. Run auto-fix? [Y/n]
```

If auto-fix applied, re-run checks.

### Test Failures

```
 ✗ 2 failures

 → Debug with /fix-test? [Y/n]
 → Skip tests and commit anyway? [y/N] (not recommended)
```

### Security Issues

```
 ⚠️  Security issue found

 Severity: {Critical|High|Medium|Low}

 → Critical/High: Block commit, must fix
 → Medium/Low: Warn, allow override with confirmation
```

---

## Integration with Workflow

After successful commit:

1. **Update CURRENT.md** - Log the commit
2. **Update plan** - If task completed, mark done
3. **Suggest next action** - Continue or push

```
 ✓ Committed: abc1234

 → Push to origin/feature-branch? [Y/n]
 → Continue with next task (2.2)? [y/N]
```

---

## Configuration

Respects project config if present:

```yaml
# .claude/config.yml (optional)
pre_commit:
  lint: true
  tests: quick          # quick | full | skip
  security: true
  auto_fix: prompt      # prompt | always | never
  commit_format: conventional
```

---

## Usage

```bash
/pre-commit              # Quick checks
/pre-commit --full       # Full suite + security
/pre-commit --security   # Security only
/pre-commit --no-tests   # Skip tests
/pre-commit --amend      # For amending previous commit
```

---

## Escalate to git-workflow-manager

This command runs quality checks. Escalate to `git-workflow-manager` when:

- **Branch behind**: Need to rebase onto main/develop before pushing
- **Messy history**: Commits need squashing/reordering before PR
- **Force push needed**: Any `--force-with-lease` operation
- **Conflicts**: Merge or rebase conflicts need resolution
- **PR preparation**: Full branch cleanup and preparation for review

### Typical Flow

```
/implement          → Work on task
    ↓
/pre-commit         → Quality checks (lint, tests)
    ↓
/commit             → Clean commit with good message
    ↓
git-workflow-manager → Prepare branch for push/PR
                       (rebase, squash, push)
```

```
💡 Think of it as:
   /pre-commit + /commit = Local quality
   git-workflow-manager  = Remote readiness
```
