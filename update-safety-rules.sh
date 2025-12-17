#!/bin/bash
# Update existing ~/.claude/CLAUDE.md with Git Safety Rules
# This script is idempotent - safe to run multiple times

set -e

CLAUDE_FILE="$HOME/.claude/CLAUDE.md"
BACKUP_FILE="$HOME/.claude/CLAUDE.md.backup-$(date +%Y%m%d-%H%M%S)"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Git Safety Rules Updater"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Check if CLAUDE.md exists
if [[ ! -f "$CLAUDE_FILE" ]]; then
    echo -e "${RED}✗ Error: $CLAUDE_FILE not found${NC}"
    echo ""
    echo "Run ./install.sh first to create the file."
    exit 1
fi

# Check if Git Safety Rules already exist
if grep -q "## Git Safety Rules" "$CLAUDE_FILE"; then
    echo -e "${GREEN}✓ Git Safety Rules already present${NC}"
    echo ""
    echo "Your $CLAUDE_FILE already has the safety rules."
    echo "No update needed."
    exit 0
fi

echo -e "${YELLOW}⚠ Git Safety Rules not found${NC}"
echo ""
echo "This will add Git Safety Rules to your CLAUDE.md file."
echo ""
echo "Actions:"
echo "  1. Create backup: $BACKUP_FILE"
echo "  2. Insert Git Safety Rules section before Anti-patterns"
echo "  3. Preserve all your existing customizations"
echo ""
read -p "Continue? [Y/n] " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]] && [[ -n $REPLY ]]; then
    echo "Cancelled."
    exit 0
fi

# Create backup
echo ""
echo "Creating backup..."
cp "$CLAUDE_FILE" "$BACKUP_FILE"
echo -e "${GREEN}✓ Backup created: $BACKUP_FILE${NC}"

# Create the Git Safety Rules section
SAFETY_RULES=$(cat <<'RULES'

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

RULES
)

# Find the line number of "## Anti-patterns"
ANTI_PATTERNS_LINE=$(grep -n "^## Anti-patterns" "$CLAUDE_FILE" | head -1 | cut -d: -f1)

if [[ -z "$ANTI_PATTERNS_LINE" ]]; then
    # If no Anti-patterns section, append to end
    echo ""
    echo "Note: No Anti-patterns section found. Appending to end of file."
    echo "$SAFETY_RULES" >> "$CLAUDE_FILE"
else
    # Insert before Anti-patterns section
    # Use awk to insert the content before the specified line
    awk -v line="$ANTI_PATTERNS_LINE" -v content="$SAFETY_RULES" '
        NR == line { print content }
        { print }
    ' "$CLAUDE_FILE" > "$CLAUDE_FILE.tmp"

    mv "$CLAUDE_FILE.tmp" "$CLAUDE_FILE"
fi

# Update the Anti-patterns "Never Do" section to reference Git Safety Rules
if grep -q "^### Never Do" "$CLAUDE_FILE"; then
    # Check if it already has the git safety reference
    if ! grep -q "Automatic git commits or pushes" "$CLAUDE_FILE"; then
        # Add the reference after "Never Do" section starts using awk
        awk '/^- Over-engineer before validating the approach/ {
            print
            print "- **Automatic git commits or pushes (see Git Safety Rules above)**"
            next
        }
        { print }' "$CLAUDE_FILE" > "$CLAUDE_FILE.tmp"
        mv "$CLAUDE_FILE.tmp" "$CLAUDE_FILE"
    fi
fi

echo ""
echo -e "${GREEN}✓ Git Safety Rules added${NC}"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Update Complete"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Changes:"
echo "  ✓ Git Safety Rules section added"
echo "  ✓ Anti-patterns section updated"
echo "  ✓ All customizations preserved"
echo ""
echo "Backup: $BACKUP_FILE"
echo ""
echo "Verify:"
echo "  grep \"Git Safety Rules\" ~/.claude/CLAUDE.md"
echo ""
echo "Next Claude Code session will load the new safety rules."
echo ""
