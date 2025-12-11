# Claude Code Agentic Workflow Toolkit

> A complete framework for agentic development with Claude Code. Full context awareness, session persistence, and expert agents - ready in 5 minutes.

## Why This Toolkit?

**The problem**: Claude Code starts fresh every session. You lose context, repeat yourself, and spend time re-explaining your project.

**The solution**: This toolkit gives Claude:
- 🧠 **Memory of who you are** - Your preferences, working style, expertise level
- 📍 **Awareness of where you left off** - Session state that persists across days/weeks
- 🤖 **Expert agents** - Specialized personas for domain-specific work
- 📋 **Workflow commands** - Streamlined session management

**Result**: Run `/bootstrap` and Claude picks up exactly where you left off, with full context about you and your project.

---

## Quick Start

```bash
# 1. Clone the toolkit
git clone https://github.com/YOUR_USERNAME/claude-code-toolkit.git
cd claude-code-toolkit

# 2. Install global toolkit to ~/.claude
./install.sh

# 3. Customize your identity (edit the 🔧 sections)
code ~/.claude/CLAUDE.md

# 4. Set up a project
cd /path/to/your-project
/path/to/claude-code-toolkit/init-project.sh

# 5. Start coding
claude
/bootstrap
```

**[Full setup guide →](SETUP.md)**

---

## Features

### 🔄 Session Continuity

Claude adapts based on how long since your last session:

| Time Away | What Happens |
|-----------|--------------|
| < 24 hours | Quick 3-line status, jump right in |
| 1-7 days | Key decisions refreshed, state summary |
| 8-30 days | Full context reload, detailed briefing |
| > 30 days | Environment verification suggested |

### 🤖 Expert Agents

Specialized agents for domain work (Claude asks before delegating):

- **rails-expert** - Ruby on Rails development
- **postgres-expert** - Database design & optimization  
- **tailwind-expert** - CSS and UI styling
- **bash-expert** - Shell scripting & automation
- **git-workflow-manager** - Git operations
- **code-reviewer** - Code quality & security

### 📋 Workflow Commands

| Command | Purpose |
|---------|---------|
| `/bootstrap` | Start session with full context |
| `/whats-next` | End session, create handoff |
| `/update-state` | Quick mid-session updates |
| `/archive-session` | Archive when feature completes |
| `/create-adr` | Document architecture decisions |
| `/add-to-todos` | Track future work |
| `/check-todos` | Review outstanding items |

### 📁 Project Structure

```
your-project/
├── .claude/
│   └── CLAUDE.md              # Project context (lean)
├── docs/
│   ├── sessions/
│   │   ├── CURRENT.md         # Session state (single source of truth)
│   │   └── archive/           # Completed sessions
│   ├── plans/                 # Implementation plans
│   └── architecture/
│       └── decisions/         # ADRs
└── TO-DOS.md                  # Task tracking
```

---

## Customization

### Your Identity (`~/.claude/CLAUDE.md`)

The template includes markers (🔧) for sections to customize:

```markdown
## Identity

### Who I Am
- **Name**: [Your Name]
- **Role**: [Your Role]
- **Focus Areas**: [Your domains]

### How I Work
- **Philosophy**: [Your approach]
```

### Collaboration Style

Choose how Claude interacts with you:

- **Colleague** (default) - Claude has opinions, pushes back, acts as peer
- **Assistant** - Claude follows directions, asks before deviating
- **Mentor** - Claude explains concepts, points out learning opportunities

### Tech Stack

Remove agents you don't need, add ones you do:

```markdown
## Available Agents

| Domain | Agent | Use For |
|--------|-------|---------|
| Python | python-expert | Python development |
| React | react-expert | Frontend components |
```

---

## How It Works

### The Bootstrap Flow

```
/bootstrap
    │
    ├── Load ~/.claude/CLAUDE.md (your identity)
    ├── Load .claude/CLAUDE.md (project context)
    ├── Load docs/sessions/CURRENT.md (session state)
    ├── Calculate staleness (HOT/WARM/COOL/COLD)
    ├── Generate adaptive brief
    └── Offer context-aware next action
```

### The Development Loop

```
┌─────────────────────────────────────────┐
│  /bootstrap                             │ ← Start
├─────────────────────────────────────────┤
│  Work on tasks                          │
│  ├── /update-state task complete        │
│  ├── /update-state decision "..."       │
│  └── /add-to-todos for future work      │
├─────────────────────────────────────────┤
│  /whats-next                            │ ← End
└─────────────────────────────────────────┘
         │
         ↓ (feature complete?)
┌─────────────────────────────────────────┐
│  /archive-session                       │
└─────────────────────────────────────────┘
```

---

## What's Included

```
claude-code-toolkit/
├── install.sh                  # Global toolkit installer
├── init-project.sh             # Project initializer
├── README.md                   # This file
├── SETUP.md                    # Detailed setup guide
│
├── global-claude/              # → Install to ~/.claude/
│   ├── CLAUDE.md              # Your identity template
│   ├── agents/                # Expert agents
│   │   ├── rails-expert.md
│   │   ├── postgres-expert.md
│   │   ├── tailwind-expert.md
│   │   ├── bash-expert.md
│   │   ├── git-workflow-manager.md
│   │   └── code-reviewer.md
│   └── commands/              # Workflow commands
│       ├── bootstrap.md
│       ├── whats-next.md
│       ├── update-state.md
│       ├── archive-session.md
│       ├── create-adr.md
│       ├── add-to-todos.md
│       └── check-todos.md
│
├── project-templates/         # Per-project templates
│   ├── project-CLAUDE.md     # → .claude/CLAUDE.md
│   ├── CURRENT.md            # → docs/sessions/CURRENT.md
│   └── ADR-TEMPLATE.md       # → docs/architecture/decisions/
│
└── examples/                  # Real-world examples
    └── guardian/             # Example project setup
```

---

## FAQ

**Q: Does this work with any project type?**  
A: Yes! The toolkit is language/framework agnostic. Customize the agents for your stack.

**Q: What if I don't want agent delegation?**  
A: Set "Never delegate" in your CLAUDE.md - Claude will always work directly.

**Q: Can I use this with a team?**  
A: The global `~/.claude/` is personal. Project files (`.claude/`, `docs/`) can be committed and shared.

**Q: How does state persistence actually work?**  
A: The `CURRENT.md` file tracks session state. `/bootstrap` reads it, `/whats-next` updates it.

---

## Contributing

Contributions welcome! Ideas:
- New agents for popular frameworks (Vue, Django, Go, etc.)
- Improved workflows
- Better documentation
- Bug fixes

---

## Credits

Built with inspiration from:
- [Anthropic's Claude Code](https://claude.ai/code)
- [obra/superpowers](https://github.com/obra/superpowers)
- The Claude Code community

---

## License

MIT - Use it, modify it, share it.
