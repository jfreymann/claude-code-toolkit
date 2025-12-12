---
name: create-adr
description: Create a new Architecture Decision Record from template. Guides through the decision documentation process.
---

# Create ADR

Create a new Architecture Decision Record in `docs/architecture/decisions/`.

## When to Use

- Making a significant technical decision
- Choosing between architectural alternatives
- Documenting why something was built a certain way
- Recording decisions that future developers will question

## Good ADR Candidates

- Database choice or schema design decisions
- Authentication/authorization approach
- API design decisions
- Framework or library selections
- Infrastructure architecture
- Integration patterns
- Security approaches

## Not ADR Material

- Code style preferences (use linting config)
- Minor implementation details
- Temporary workarounds (use code comments)
- Bug fixes

---

## Execution

### Step 1: Determine ADR Number

```bash
# Find next ADR number
ls docs/architecture/decisions/ADR-*.md | wc -l
# Next number = count + 1, zero-padded to 3 digits
```

### Step 2: Gather Decision Context

Ask:
1. "What decision are you documenting?"
2. "What problem or need drove this decision?"
3. "What alternatives did you consider?"
4. "Why did you choose this approach?"

### Step 3: Generate ADR

Create `docs/architecture/decisions/ADR-{NNN}-{slug}.md`:

```markdown
# ADR-{NNN}: {Title}

## Status
PROPOSED

## Date
{YYYY-MM-DD}

## Context
{What is the issue? What forces are at play?}

## Decision
{What change are we making? Be specific.}

## Rationale
{Why this over alternatives? What tradeoffs?}

## Alternatives Considered

### Alternative 1: {Name}
- **Description**: {What is this option?}
- **Rejected because**: {Why not this?}

### Alternative 2: {Name}
- **Description**: {What is this option?}
- **Rejected because**: {Why not this?}

## Consequences

### Positive
- {Good outcome 1}
- {Good outcome 2}

### Negative
- {Tradeoff or downside 1}
- {Tradeoff or downside 2}

### Neutral
- {Side effect that's neither good nor bad}

## Related
- {Links to related ADRs, issues, docs}
```

### Step 4: Slug Generation

Convert title to slug:
- Lowercase
- Replace spaces with hyphens
- Remove special characters
- Truncate to ~50 chars

Example: "Mutual TLS for Agent Authentication" → `mtls-agent-auth`

### Step 5: Update References

If this ADR relates to current work:
1. Add to CURRENT.md Key Decisions (brief reference)
2. Add to .claude/CLAUDE.md Architecture Decisions list
3. Link from relevant plan if applicable

### Step 6: Confirm

Output:
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 ADR CREATED
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 
 Created: docs/architecture/decisions/ADR-{NNN}-{slug}.md
 Status: PROPOSED
 
 Next steps:
 • Review and refine the ADR content
 • Change status to ACCEPTED when finalized
 • Reference from relevant documentation
 
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## Usage

```
/create-adr                              # Interactive
/create-adr "Mutual TLS for Agents"      # With title
```

---

## ADR Lifecycle

```
PROPOSED → ACCEPTED → (later) DEPRECATED or SUPERSEDED
```

- **PROPOSED**: Under discussion, not yet final
- **ACCEPTED**: Decision is made and in effect
- **DEPRECATED**: No longer recommended, but still in use
- **SUPERSEDED BY ADR-XXX**: Replaced by newer decision

---

## Tips for Good ADRs

1. **Be specific** - "Use PostgreSQL" not "Use a relational database"
2. **Document the why** - Future you will forget the context
3. **List real alternatives** - What did you actually consider?
4. **Acknowledge tradeoffs** - Every decision has downsides
5. **Keep it concise** - 1-2 pages max, not a design doc
6. **Date it** - Context changes over time
