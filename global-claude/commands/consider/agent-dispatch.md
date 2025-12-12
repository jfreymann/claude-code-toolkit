# Consider: Agent Dispatch

When and how to engage specialist agents effectively.

## Core Principle

**Agents are colleagues, not buttons.** Don't blindly dispatch - consider whether specialist knowledge adds value.

## The Dispatch Decision

```
┌─────────────────────────────────────────────────────────────┐
│  Should I engage a specialist agent?                        │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  1. Is this their domain?          NO ──────► Work directly │
│          │                                                  │
│         YES                                                 │
│          ▼                                                  │
│  2. Is the problem complex?        NO ──────► Work directly │
│          │                                                  │
│         YES                                                 │
│          ▼                                                  │
│  3. Would user benefit from        NO ──────► Work directly │
│     specialist perspective?                                 │
│          │                                                  │
│         YES                                                 │
│          ▼                                                  │
│  4. ASK USER before dispatching                             │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

## Available Agents

| Agent | Domain | Engage For |
|-------|--------|------------|
| **rails-expert** | Ruby on Rails | Patterns, architecture, performance, Rails-specific issues |
| **postgres-expert** | PostgreSQL | Schema design, query optimization, indexing, migrations |
| **tailwind-expert** | Tailwind CSS | Styling, responsive design, component styling |
| **bash-expert** | Shell/CLI | Scripting, automation, one-liners, deployment |
| **git-workflow-manager** | Git | Complex merges, rebases, history, branching strategy |
| **code-reviewer** | Quality | Security review, code quality, best practices |

## When to Engage

### rails-expert
```
✓ Designing service objects, concerns, or complex models
✓ Debugging Rails-specific behavior
✓ Performance optimization (N+1, caching)
✓ Upgrading Rails versions

✗ Simple CRUD operations
✗ Basic model validations
✗ Following existing patterns
```

### postgres-expert
```
✓ Complex query optimization
✓ Schema design decisions
✓ Index strategy
✓ Partitioning, replication setup
✓ Migration with data transformation

✗ Simple foreign key additions
✗ Adding a column
✗ Basic queries
```

### tailwind-expert
```
✓ Complex responsive layouts
✓ Design system implementation
✓ Animation and transitions
✓ Dark mode, theming

✗ Adding basic classes
✗ Simple spacing adjustments
✗ Color changes
```

### bash-expert
```
✓ Complex shell scripts
✓ Process automation
✓ Text processing pipelines
✓ System administration tasks

✗ Simple file operations
✗ Running rake tasks
✗ Basic git commands
```

### git-workflow-manager
```
✓ Complex merge conflicts
✓ Interactive rebase
✓ History rewriting
✓ Branching strategy design
✓ Recovering from mistakes

✗ Simple commits
✗ Basic branching
✗ Pushing/pulling
```

### code-reviewer
```
✓ Security-sensitive changes
✓ Pre-merge review
✓ Architecture review
✓ Performance review

✗ Obvious code
✗ Following established patterns
✗ Minor changes
```

## How to Ask

**Always ask the user before dispatching:**

```
This involves designing the database schema for the new feature.
Would you like me to engage postgres-expert for the design, 
or should we work through it together?

[A]gent / [T]ogether / [Y]ou handle it
```

Options:
- **Agent**: Formal dispatch with specialist context
- **Together**: Work through it with user, no formal delegation
- **You handle it**: Provide information, let user decide

## Dispatch Format

When engaging an agent, provide:

```markdown
## Agent Request: {agent-name}

### Context
{What we're working on, relevant background}

### Specific Question
{Clear, focused question for the specialist}

### Constraints
{Any limitations, preferences, or requirements}

### Current State
{Relevant code, schema, or configuration}
```

## Agent Handoff

After agent work:

1. **Summarize** - What did the agent recommend?
2. **Translate** - Apply to our specific context
3. **Verify** - Does this align with project patterns?
4. **Integrate** - Merge into the work

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 AGENT SUMMARY: postgres-expert
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

 Recommendation:
 Use partial index on 'status' column for active agents only.
 
 Query: CREATE INDEX idx_agents_active ON agents(hostname) 
        WHERE status = 'active';
 
 Rationale: 90% of queries filter for active agents.
 
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 → Apply this recommendation?
```

## Anti-Patterns

**Don't:**
- Dispatch for simple/obvious tasks
- Dispatch without asking user
- Dispatch to avoid working through something
- Chain multiple agents unnecessarily

**Do:**
- Consider whether specialist knowledge adds value
- Always ask before engaging
- Provide clear context in dispatch
- Synthesize agent output into project context

## Multiple Agents

Sometimes work spans domains. Handle sequentially:

```
This task involves database schema (postgres) and Rails 
model design (rails). 

I'd suggest:
1. Design schema with postgres-expert first
2. Then Rails models based on schema

Or we can work through both together.

Preference?
```

## Skipping Agents

It's often fine to work directly:

- When following established patterns
- For simple, well-understood tasks
- When user has domain expertise
- To move faster on time-sensitive work

Agents are consultants, not requirements.
