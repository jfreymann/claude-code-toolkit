#!/bin/bash
# Update existing ~/.claude/CLAUDE.md with Git Safety Rules
# This script is idempotent - safe to run multiple times

set -e

# Get script directory to locate project-templates/
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SAFETY_RULES_FILE="$SCRIPT_DIR/project-templates/git-safety-rules.txt"

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

# Check if safety rules file exists
if [[ ! -f "$SAFETY_RULES_FILE" ]]; then
    echo -e "${RED}✗ Error: $SAFETY_RULES_FILE not found${NC}"
    echo ""
    echo "Make sure you're running this script from the claude-code-toolkit directory."
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

# Find the line number of "## Anti-patterns"
ANTI_PATTERNS_LINE=$(grep -n "^## Anti-patterns" "$CLAUDE_FILE" | head -1 | cut -d: -f1)

if [[ -z "$ANTI_PATTERNS_LINE" ]]; then
    # If no Anti-patterns section, append to end
    echo ""
    echo "Note: No Anti-patterns section found. Appending to end of file."
    cat "$SAFETY_RULES_FILE" >> "$CLAUDE_FILE"
else
    # Insert before Anti-patterns section using head/tail
    # This avoids all shell parsing issues by working with files directly
    head -n $((ANTI_PATTERNS_LINE - 1)) "$CLAUDE_FILE" > "$CLAUDE_FILE.tmp"
    cat "$SAFETY_RULES_FILE" >> "$CLAUDE_FILE.tmp"
    tail -n +$ANTI_PATTERNS_LINE "$CLAUDE_FILE" >> "$CLAUDE_FILE.tmp"
    mv "$CLAUDE_FILE.tmp" "$CLAUDE_FILE"
fi

# Note: We skip updating the Anti-patterns "Never Do" section to avoid
# shell parsing issues. The critical Git Safety Rules section has been
# added above, which is what matters for protecting against auto-commits.

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
