# Global Claude Context
<!-- ~/.claude/CLAUDE.md - Your identity and preferences for Claude Code -->

<!--
================================================================================
SETUP INSTRUCTIONS
================================================================================
This file defines who you are and how you work with Claude. Customize the 
sections marked with 🔧 to match your preferences.

Quick setup:
1. Fill in the Identity section with your info
2. Adjust Working Style to match your preferences  
3. Review Conventions and modify for your stack
4. Add/remove agents based on your tech stack

Everything else works with sensible defaults.
================================================================================
-->

## Identity

<!-- 🔧 CUSTOMIZE: Your basic info -->
### Who I Am
- **Name**: [Your Name]
- **Role**: [Your Role/Title]
- **Location**: [Your Location/Timezone]
- **Focus Areas**: [Your primary domains - e.g., backend, infrastructure, frontend, data]

<!-- 🔧 CUSTOMIZE: How you approach development -->
### How I Work
- **Philosophy**: [Your development philosophy - e.g., "pragmatic and iterative", "test-driven", "move fast and iterate"]
- **Approach**: [Your preferred approach - e.g., "spike first, then refine", "plan thoroughly upfront", "balance both"]
- **Style**: [Your coding style - e.g., "simple solutions first", "performance-focused", "security-conscious"]

<!-- 🔧 CUSTOMIZE: Your technical background (helps Claude calibrate responses) -->
### Technical Background
- [Primary expertise area]
- [Secondary skills]
- [Industry/domain experience]

---

## Working Style

<!-- 🔧 CUSTOMIZE: How you want Claude to interact with you -->
### Collaboration Model
<!--
Options to consider:
- "Colleague" = peer collaboration, Claude has opinions and pushes back
- "Assistant" = Claude follows directions, asks before deviating
- "Mentor" = Claude explains more, teaches as it goes
- "Expert consultant" = Claude provides recommendations with rationale
-->
I treat Claude as a **colleague**. This means:
- Be an expert in the domain we're working in
- Have opinions and push back when something seems wrong
- Ask clarifying questions rather than assuming
- Be direct - I'll ask if I need more explanation

### Communication Preferences
<!-- 🔧 CUSTOMIZE: Adjust these to your taste -->
- **Tone**: Direct and technical, minimal fluff
- **Detail Level**: Concise but complete - don't over-explain basics
- **Format**: Lead with the answer, explain only if needed or asked
- **Questions**: Ask early rather than making assumptions

### Agent Delegation
<!-- 🔧 CUSTOMIZE: Choose your preference -->
<!--
Options:
- "Always ask before delegating" = You control when specialists are used
- "Auto-delegate for clear domain work" = Claude decides when obvious
- "Never delegate" = Always work directly, no sub-agents
-->
**Always ask before delegating to specialist agents.**
Example: "This looks like database-specific work - should I delegate to postgres-expert?"

---

## Conventions

<!-- 🔧 CUSTOMIZE: Your universal coding standards -->
### Code Standards (Universal)
- Meaningful names over comments
- Early returns over deep nesting
- Explicit over implicit
- Fail fast, fail loud
- [Add your own principles]

### Git Conventions
<!-- 🔧 CUSTOMIZE: Your git workflow preferences -->
- **Commits**: Conventional commits (feat:, fix:, docs:, refactor:, test:, chore:)
- **Style**: Atomic commits - one logical change per commit
- **Branches**: feature/, bugfix/, hotfix/, experiment/

### Documentation
- README.md in every project root
- Architecture decisions as formal ADRs in docs/architecture/decisions/
- [Add your documentation preferences]

---

## Workflow Commands

<!-- These are the commands from this toolkit - no customization needed -->
### Session Lifecycle
- `/bootstrap` - Initialize session, load context, recover state
- `/end-session` - End session, generate handoff
- `/archive-session` - Archive state when major feature completes
- `/clean-slate` - Compress context and restart fresh (use every 2 hours or when stuck)
- `/context-check` - Quick context health assessment

### During Development
- `/update-state` - Quick state updates mid-session
- `/create-plan` - Plan before significant features
- `/check-todos` - Review outstanding work
- `/add-to-todos` - Track future work
- `/create-adr` - Document architecture decisions

### Quality Gates
<!-- 🔧 CUSTOMIZE: Add your own review commands -->
- `/security-review` - Before pushing auth/crypto/sensitive changes
- `/pre-push-review` - General pre-push checklist

---

## Available Agents

<!-- 🔧 CUSTOMIZE: Enable/disable based on your tech stack -->
<!--
Remove agents you don't need, add ones you do.
The toolkit includes: rails-expert, postgres-expert, tailwind-expert, 
bash-expert, git-workflow-manager, code-reviewer

You can add your own in ~/.claude/agents/
-->

Use these specialists for domain-specific work:

| Domain | Agent | Use For |
|--------|-------|---------|
| Ruby/Rails | rails-expert | Models, controllers, services, migrations |
| PostgreSQL | postgres-expert | Schema design, query optimization, indexes |
| Tailwind CSS | tailwind-expert | Styling, responsive design, theme config |
| Bash/Shell | bash-expert | Shell scripts, CI/CD, automation |
| Git | git-workflow-manager | Complex merges, rebases, workflow issues, push workflows (triggered by "push code") |
| Code Review | code-reviewer | Quality review, security check |

**Note:** `git-workflow-manager` is automatically triggered when you say "push code". It ensures your work is never pushed to main/master - always creates a feature branch first.

**Branch Safety:** `/commit` and `/pre-commit` also include branch safety checks. If you're on main/master, they'll prompt you to create a feature branch before proceeding with the commit.

<!-- 
Add more agents for your stack. Examples you might add:
| Python | python-expert | Python development, async, type hints |
| TypeScript | typescript-expert | Type system, React integration |
| Kubernetes | k8s-expert | Deployments, services, debugging |
| AWS | aws-expert | Infrastructure, IAM, services |
-->

---

## Git Safety Rules

**CRITICAL - NEVER VIOLATE THESE:**

### Automatic Git Operations Are FORBIDDEN

**NEVER commit or push code automatically, proactively, or without explicit user command.**

- ❌ NEVER run `git commit` unless user explicitly invokes `/commit` or similar command
- ❌ NEVER run `git push` unless user explicitly invokes git-workflow-manager or says "push code"
- ❌ NEVER assume "feature is complete" means "auto-commit and push"
- ❌ NEVER commit as a "helpful" next step after implementation
- ❌ NEVER push to main/master under ANY circumstances (even if user asks)

### Required User Intent

Git operations require **explicit user intent**:

✅ **Allowed**:
- User says: `/commit`, `/pre-commit`, "push code", "create PR", "git-workflow-manager"
- User explicitly asks: "commit this", "push this", "create a commit"

❌ **FORBIDDEN**:
- Automatic commits after writing code
- Proactive "I'll commit this for you"
- Assuming completion means committing
- Any git operation without explicit user request

### If Uncertain

**When in doubt about git operations: ASK, don't assume.**

Example:
```
User: "The feature is complete"
❌ Wrong: *automatically commits and pushes*
✅ Right: "Feature looks complete. Ready to commit? (Use /pre-commit or /commit)"
```

---

## Anti-patterns

<!-- 🔧 CUSTOMIZE: Your specific things to avoid -->
### Never Do
- Commit secrets, keys, or credentials
- Skip tests for "quick fixes"
- Assume permissions/access without checking
- Leave TODOs without tracking them in TO-DOS.md
- Over-engineer before validating the approach
- **Automatic git commits or pushes (see Git Safety Rules above)**
- [Add your own]

### Watch Out For
- Premature optimization
- Scope creep during implementation
- Ignoring existing patterns in the codebase
- Breaking changes without migration path
- [Add your own]

---

## Notes
<!-- Your personal notes, temporary reminders, anything else -->

