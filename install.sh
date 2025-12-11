#!/usr/bin/env bash
#
# install.sh - Install the Claude Code Agentic Workflow Toolkit
#
# Usage: ./install.sh [options]
#
# Options:
#   -h, --help       Show this help message
#   -f, --force      Overwrite existing ~/.claude without backup
#   -b, --backup     Backup existing ~/.claude (default behavior)
#   --no-backup      Skip backup, fail if ~/.claude exists
#

set -euo pipefail

# ============================================================================
# Configuration
# ============================================================================

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly CLAUDE_DIR="$HOME/.claude"
readonly BACKUP_DIR="$HOME/.claude.backup.$(date +%Y%m%d_%H%M%S)"

# Colors for output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[0;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m' # No Color

# Options
FORCE=false
BACKUP=true

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
    echo -e "${GREEN}[SUCCESS]${NC} $*"
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $*"
}

error() {
    echo -e "${RED}[ERROR]${NC} $*" >&2
    exit 1
}

check_source_files() {
    if [[ ! -d "$SCRIPT_DIR/global-claude" ]]; then
        error "Cannot find global-claude directory. Run this script from the toolkit root."
    fi
}

backup_existing() {
    if [[ -d "$CLAUDE_DIR" ]]; then
        if [[ "$FORCE" == true ]]; then
            warn "Force mode: removing existing $CLAUDE_DIR"
            rm -rf "$CLAUDE_DIR"
        elif [[ "$BACKUP" == true ]]; then
            log "Backing up existing $CLAUDE_DIR to $BACKUP_DIR"
            mv "$CLAUDE_DIR" "$BACKUP_DIR"
            success "Backup created at $BACKUP_DIR"
        else
            error "$CLAUDE_DIR already exists. Use --force or --backup."
        fi
    fi
}

install_global_toolkit() {
    log "Installing global toolkit to $CLAUDE_DIR"
    
    # Copy the global-claude directory
    cp -r "$SCRIPT_DIR/global-claude" "$CLAUDE_DIR"
    
    success "Global toolkit installed to $CLAUDE_DIR"
}

print_next_steps() {
    echo ""
    echo -e "${GREEN}════════════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}  Installation Complete!${NC}"
    echo -e "${GREEN}════════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo "Next steps:"
    echo ""
    echo "  1. Customize your identity:"
    echo -e "     ${BLUE}code ~/.claude/CLAUDE.md${NC}"
    echo "     (Look for sections marked with 🔧)"
    echo ""
    echo "  2. Set up a project:"
    echo -e "     ${BLUE}cd your-project${NC}"
    echo -e "     ${BLUE}$SCRIPT_DIR/init-project.sh${NC}"
    echo ""
    echo "  3. Start coding:"
    echo -e "     ${BLUE}claude${NC}"
    echo -e "     ${BLUE}/bootstrap${NC}"
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
            -f|--force)
                FORCE=true
                shift
                ;;
            -b|--backup)
                BACKUP=true
                shift
                ;;
            --no-backup)
                BACKUP=false
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
    echo -e "${BLUE}  Claude Code Agentic Workflow Toolkit - Installer${NC}"
    echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
    echo ""
    
    check_source_files
    backup_existing
    install_global_toolkit
    print_next_steps
}

main "$@"
