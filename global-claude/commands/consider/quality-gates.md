# Consider: Quality Gates

A framework for when and how to apply quality checks in your workflow.

## The Gate Concept

Quality gates are checkpoints that code must pass before progressing. They catch issues early, when they're cheapest to fix.

```
┌─────────────────────────────────────────────────────────────┐
│                    QUALITY GATE FLOW                         │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  Write Code (/implement)                                     │
│      │                                                       │
│      ▼                                                       │
│  ┌──────────────┐                                           │
│  │ /pre-commit  │ ← Lint, tests, quick security             │
│  └──────────────┘                                           │
│      │ pass                                                  │
│      ▼                                                       │
│  ┌──────────────┐                                           │
│  │ /commit      │ ← Clean commit with good message          │
│  └──────────────┘                                           │
│      │                                                       │
│      ▼                                                       │
│  ┌──────────────┐                                           │
│  │ /review      │ ← Self-review before PR (optional)        │
│  └──────────────┘                                           │
│      │ pass                                                  │
│      ▼                                                       │
│  ┌─────────────────────────┐                                │
│  │ git-workflow-manager    │ ← THE "BIG DOG"                │
│  │  • Rebase onto main     │   Prepares branch for remote   │
│  │  • Squash/cleanup       │                                │
│  │  • Resolve conflicts    │                                │
│  │  • Push with safety     │                                │
│  └─────────────────────────┘                                │
│      │                                                       │
│      ▼                                                       │
│  ┌──────────────────────┐                                   │
│  │ /security-review     │ ← For sensitive changes           │
│  └──────────────────────┘                                   │
│      │ pass                                                  │
│      ▼                                                       │
│  ┌──────────────┐                                           │
│  │ PR / Merge   │                                           │
│  └──────────────┘                                           │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

## Command vs Agent Responsibilities

| Tool | Responsibility | When |
|------|----------------|------|
| `/pre-commit` | Quality checks (lint, tests, security) | Before every commit |
| `/commit` | Clean commits with good messages | After pre-commit passes |
| `/review` | Self-review checklist | Before requesting PR |
| `/security-review` | Deep security analysis | Auth/sensitive code |
| `git-workflow-manager` | Branch preparation for remote | Before push/PR |

### The "Big Dog" Pattern

`git-workflow-manager` handles everything needed to get a branch ready for push:

```
Local commits ready (via /commit)
        │
        ▼
┌─────────────────────────────────┐
│     git-workflow-manager        │
│                                 │
│  1. Fetch latest from remote    │
│  2. Rebase onto main/develop    │
│  3. Resolve any conflicts       │
│  4. Squash WIP/fixup commits    │
│  5. Verify conventional format  │
│  6. Push with --force-with-lease│
│  7. Create backup before danger │
│                                 │
└─────────────────────────────────┘
        │
        ▼
Branch ready for PR

## Gate Selection

Not every change needs every gate. Choose based on risk:

| Change Type | Pre-commit | Commit | Review | git-workflow-manager | Security |
|-------------|------------|--------|--------|---------------------|----------|
| Quick fix (typo, config) | ✓ | ✓ | - | - | - |
| Bug fix | ✓ | ✓ | ✓ | ✓ | - |
| New feature | ✓ | ✓ | ✓ | ✓ | ? |
| Auth/security code | ✓ | ✓ | ✓ | ✓ | ✓ |
| Dependency update | ✓ | ✓ | - | ✓ | ✓ |
| Refactoring | ✓ | ✓ | ✓ | ✓ | - |
| Database changes | ✓ | ✓ | ✓ | ✓ | ? |
| WIP (not pushing) | ? | ✓ | - | - | - |

**Legend:** ✓ = Required, ? = Recommended, - = Optional

### Minimal Flow (quick fix, not pushing yet)
```
/pre-commit → /commit
```

### Standard Flow (feature work)
```
/pre-commit → /commit → git-workflow-manager → PR
```

### High-Risk Flow (security-sensitive)
```
/pre-commit → /commit → /review --self → git-workflow-manager → /security-review → PR
```

## When to Skip Gates

It's okay to skip gates when:

- **Hotfix in production** - Fix first, review after
- **Trivial change** - README typo doesn't need full review
- **Spike/experiment** - Throwaway code on throwaway branch
- **Time-critical** - But document what was skipped

When you skip, note it:
```bash
git commit -m "fix: emergency patch for prod crash [skip-review]"
```

## Gate Failure Strategies

### Lint Failures

```
Options:
1. Fix the issue (preferred)
2. Auto-fix if available
3. Disable rule inline with justification
4. Update project config if rule is wrong for project
```

### Test Failures

```
Options:
1. Fix the code (if bug)
2. Fix the test (if test is wrong)
3. Skip test temporarily with TODO (last resort)
   - it.skip('reason: ticket #123')
```

### Security Findings

```
By severity:
- Critical/High: MUST fix before merge
- Medium: Should fix, can defer with justification
- Low: Note and track, fix when convenient
```

### Review Feedback

```
Categories:
- Must fix: Bugs, security issues, broken behavior
- Should fix: Code quality, maintainability
- Consider: Style preferences, alternative approaches
- Question: Clarification needed
```

## Commit Message Quality

Good commit messages are part of quality:

```
# Good
feat(auth): add mTLS certificate verification

Implement mutual TLS authentication for agent connections.
Certificates are verified against the configured CA.

Closes #123

# Bad  
fixed stuff
WIP
changes
update code
```

### Commit Message Template

```
{type}({scope}): {subject}

{body - what and why, not how}

{footer - issues, breaking changes}
```

## Quality vs Speed Tradeoff

```
High Quality ◄─────────────────────────► High Speed

Full gates          Selective gates       Minimal gates
Every commit        Important commits     Emergency only
Thorough review     Quick review          Post-merge review
All tests           Affected tests        Smoke tests

Use for:            Use for:              Use for:
- Production code   - Most development    - Hotfixes
- Security code     - Feature work        - Spikes
- Shared libraries  - Bug fixes           - Experiments
```

## Automation

Automate what you can:

| Check | Automate? | How |
|-------|-----------|-----|
| Linting | Yes | Pre-commit hook, CI |
| Tests | Yes | Pre-commit hook, CI |
| Security scan | Yes | CI, scheduled |
| Code review | Partially | Automated checks + human review |
| Performance | Partially | Benchmarks in CI |

## Team Patterns

### Solo Developer
```
/pre-commit → /commit → git-workflow-manager → push
```

### Small Team
```
/pre-commit → /commit → git-workflow-manager → push → PR → peer review → merge
```

### Larger Team
```
/pre-commit → /commit → /review --self → git-workflow-manager → push → PR 
→ automated checks → peer review → /security-review (if needed) → merge
```

### Multiple Commits Before Push
```
/pre-commit → /commit    ─┐
/pre-commit → /commit     │ (multiple commits)
/pre-commit → /commit    ─┘
        │
        ▼
git-workflow-manager     (squash, rebase, push)
        │
        ▼
       PR
```

## Questions to Ask

Before committing:
- Would I be comfortable if this was reviewed right now?
- If this breaks, how bad is it?
- Is this the smallest logical unit of change?

Before merging:
- Have all concerns been addressed?
- Are there any deferred issues tracked?
- Is documentation updated?

## Anti-Patterns

**Rubber-stamping**: Approving without actually reviewing
- Fix: Require specific comments on PRs

**Gate fatigue**: So many checks that people start skipping
- Fix: Keep gates fast, remove low-value checks

**Review bottleneck**: PRs waiting days for review
- Fix: Smaller PRs, async review culture, time-box

**False security**: Passing gates doesn't mean code is good
- Fix: Gates are minimum bar, not goal
