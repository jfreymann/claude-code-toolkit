#!/usr/bin/env bash
#
# install.sh - Install the Claude Code Agentic Workflow Toolkit via symlinks
#
# Usage: ./install.sh [options]
#
# Options:
#   -h, --help           Show this help message
#   --copy               Copy files instead of symlinking (not recommended)
#   --dry-run            Show what would be done without doing it
#   --uninstall          Remove symlinks and ~/.claude directory
#
# The installer creates symlinks from ~/.claude/ to this repository.
# To update, simply run: git pull
#

set -euo pipefail

# ============================================================================
# Configuration
# ============================================================================

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly SOURCE_DIR="$SCRIPT_DIR/global-claude"
readonly CLAUDE_DIR="$HOME/.claude"

# Colors for output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[0;33m'
readonly BLUE='\033[0;34m'
readonly CYAN='\033[0;36m'
readonly NC='\033[0m' # No Color

# Options
USE_SYMLINKS=true
DRY_RUN=false
UNINSTALL=false

# ============================================================================
# Functions
# ============================================================================

usage() {
    sed -n '3,/^$/p' "$0" | sed 's/^# //; s/^#//'
    exit "${1:-0}"
}

log() {
    echo -e "${BLUE}[INFO]${NC} $*"
}

success() {
    echo -e "${GREEN}  ✓${NC} $*"
}

warn() {
    echo -e "${YELLOW}  ⚠${NC} $*"
}

skip() {
    echo -e "${CYAN}  ○${NC} $*"
}

error() {
    echo -e "${RED}[ERROR]${NC} $*" >&2
    exit 1
}

dry_run_msg() {
    echo -e "${YELLOW}[DRY RUN]${NC} $*"
}

check_source_files() {
    if [[ ! -d "$SOURCE_DIR" ]]; then
        error "Cannot find global-claude directory. Run this script from the toolkit root."
    fi
}

create_symlink() {
    local src="$1"
    local dest="$2"
    local desc="$3"
    
    if [[ -L "$dest" ]]; then
        # Already a symlink - check if it points to the right place
        local current_target
        current_target=$(readlink "$dest")
        if [[ "$current_target" == "$src" ]]; then
            skip "$desc (symlink already correct)"
            return
        else
            if [[ "$DRY_RUN" == true ]]; then
                dry_run_msg "Would update symlink: $dest -> $src"
            else
                rm "$dest"
                ln -s "$src" "$dest"
                warn "$desc (symlink updated)"
            fi
        fi
    elif [[ -e "$dest" ]]; then
        # Something exists but it's not a symlink
        warn "$desc exists and is not a symlink - skipping"
        echo -e "    ${CYAN}To fix: rm -rf $dest && re-run installer${NC}"
    else
        if [[ "$DRY_RUN" == true ]]; then
            dry_run_msg "Would create symlink: $dest -> $src"
        else
            ln -s "$src" "$dest"
            success "$desc -> $(basename "$src")/"
        fi
    fi
}

install_claude_md() {
    local src="$SOURCE_DIR/CLAUDE.md"
    local dest="$CLAUDE_DIR/CLAUDE.md"
    
    log "Setting up CLAUDE.md..."
    
    if [[ -L "$dest" ]]; then
        # It's a symlink - this is wrong for CLAUDE.md, it should be a copy
        warn "CLAUDE.md is a symlink (should be a copy for customization)"
        echo -e "    ${CYAN}Converting to copy so you can customize it...${NC}"
        if [[ "$DRY_RUN" != true ]]; then
            local target
            target=$(readlink "$dest")
            rm "$dest"
            cp "$target" "$dest"
            success "CLAUDE.md (converted to copy)"
        fi
    elif [[ -f "$dest" ]]; then
        skip "CLAUDE.md (your customizations preserved)"
    else
        if [[ "$DRY_RUN" == true ]]; then
            dry_run_msg "Would copy: CLAUDE.md"
        else
            cp "$src" "$dest"
            success "CLAUDE.md (copied - customize this file!)"
        fi
    fi
}

do_install() {
    log "Creating ~/.claude directory..."
    
    if [[ "$DRY_RUN" == true ]]; then
        dry_run_msg "Would create: $CLAUDE_DIR"
    else
        mkdir -p "$CLAUDE_DIR"
        success "Created $CLAUDE_DIR"
    fi
    
    echo ""
    
    # CLAUDE.md is always a COPY (user customizes it)
    install_claude_md
    
    echo ""
    log "Creating symlinks to repository..."
    echo -e "    ${CYAN}(Updates via 'git pull' will be reflected automatically)${NC}"
    echo ""
    
    # These directories are SYMLINKED (updates via git pull)
    create_symlink "$SOURCE_DIR/agents" "$CLAUDE_DIR/agents" "agents/"
    create_symlink "$SOURCE_DIR/commands" "$CLAUDE_DIR/commands" "commands/"
    create_symlink "$SOURCE_DIR/skills" "$CLAUDE_DIR/skills" "skills/"
}

do_uninstall() {
    log "Uninstalling Claude Code Toolkit..."
    
    if [[ ! -d "$CLAUDE_DIR" ]]; then
        warn "~/.claude does not exist, nothing to uninstall"
        return
    fi
    
    # Remove symlinks
    for item in agents commands skills; do
        local path="$CLAUDE_DIR/$item"
        if [[ -L "$path" ]]; then
            if [[ "$DRY_RUN" == true ]]; then
                dry_run_msg "Would remove symlink: $path"
            else
                rm "$path"
                success "Removed symlink: $item"
            fi
        fi
    done
    
    # Ask about CLAUDE.md
    if [[ -f "$CLAUDE_DIR/CLAUDE.md" ]]; then
        echo ""
        echo -e "${YELLOW}Found CLAUDE.md with your customizations.${NC}"
        read -rp "Delete it? [y/N] " response
        if [[ "$response" =~ ^[Yy]$ ]]; then
            if [[ "$DRY_RUN" != true ]]; then
                rm "$CLAUDE_DIR/CLAUDE.md"
                success "Removed CLAUDE.md"
            fi
        else
            skip "Kept CLAUDE.md"
        fi
    fi
    
    # Remove directory if empty
    if [[ -d "$CLAUDE_DIR" ]] && [[ -z "$(ls -A "$CLAUDE_DIR")" ]]; then
        if [[ "$DRY_RUN" != true ]]; then
            rmdir "$CLAUDE_DIR"
            success "Removed empty ~/.claude directory"
        fi
    fi
    
    echo ""
    success "Uninstall complete"
}

print_success() {
    echo ""
    echo -e "${GREEN}════════════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}  Installation Complete!${NC}"
    echo -e "${GREEN}════════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo "  Toolkit location: $SCRIPT_DIR"
    echo "  Installed to:     $CLAUDE_DIR"
    echo ""
    echo "  Structure:"
    echo "    ~/.claude/"
    echo "    ├── CLAUDE.md    (your copy - customize this!)"
    echo "    ├── agents/      → symlink to repo"
    echo "    ├── commands/    → symlink to repo"
    echo "    └── skills/      → symlink to repo"
    echo ""
}

print_next_steps() {
    echo "Next steps:"
    echo ""
    
    if [[ ! -f "$CLAUDE_DIR/CLAUDE.md" ]] || [[ "$DRY_RUN" == true ]]; then
        echo "  1. Customize your identity:"
        echo -e "     ${BLUE}code ~/.claude/CLAUDE.md${NC}"
        echo "     (Look for sections marked with 🔧)"
        echo ""
        echo "  2. Set up a project:"
    else
        echo "  1. Set up a project:"
    fi
    
    echo -e "     ${BLUE}cd your-project${NC}"
    echo -e "     ${BLUE}$SCRIPT_DIR/init-project.sh${NC}"
    echo ""
    echo "  2. Start coding:"
    echo -e "     ${BLUE}claude${NC}"
    echo -e "     ${BLUE}/bootstrap${NC}"
    echo ""
    echo -e "${CYAN}To update the toolkit:${NC}"
    echo -e "     ${BLUE}cd $SCRIPT_DIR && git pull${NC}"
    echo ""
}

# ============================================================================
# Argument Parsing
# ============================================================================

parse_args() {
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -h|--help)
                usage 0
                ;;
            --copy)
                USE_SYMLINKS=false
                warn "Copy mode selected (symlinks recommended for easy updates)"
                shift
                ;;
            --dry-run)
                DRY_RUN=true
                shift
                ;;
            --uninstall)
                UNINSTALL=true
                shift
                ;;
            *)
                error "Unknown option: $1. Use --help for usage."
                ;;
        esac
    done
}

# ============================================================================
# Main
# ============================================================================

main() {
    parse_args "$@"
    
    echo ""
    echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}  Claude Code Agentic Workflow Toolkit${NC}"
    echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
    echo ""
    
    if [[ "$DRY_RUN" == true ]]; then
        echo -e "${YELLOW}Running in dry-run mode - no changes will be made${NC}"
        echo ""
    fi
    
    if [[ "$UNINSTALL" == true ]]; then
        do_uninstall
        exit 0
    fi
    
    check_source_files
    
    if [[ "$USE_SYMLINKS" == true ]]; then
        do_install
    else
        error "--copy mode not yet implemented. Use symlinks (default) for now."
    fi
    
    if [[ "$DRY_RUN" != true ]]; then
        print_success
        print_next_steps
    else
        echo ""
        echo -e "${YELLOW}Dry run complete. Run without --dry-run to apply changes.${NC}"
        echo ""
    fi
}

main "$@"
