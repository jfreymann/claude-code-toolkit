#!/usr/bin/env bash
#
# init-project.sh - Initialize a project with Claude Code workflow structure
#
# Usage: ./init-project.sh [options] [project-path]
#
# Arguments:
#   project-path     Path to project (default: current directory)
#
# Options:
#   -h, --help       Show this help message
#   -n, --name NAME  Project name (default: directory name)
#   -f, --force      Overwrite existing files
#   --no-git         Skip .gitignore modifications
#

set -euo pipefail

# ============================================================================
# Configuration
# ============================================================================

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly TEMPLATES_DIR="$SCRIPT_DIR/project-templates"

# Colors for output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[0;33m'
readonly BLUE='\033[0;34m'
readonly CYAN='\033[0;36m'
readonly NC='\033[0m' # No Color

# Options
PROJECT_PATH="."
PROJECT_NAME=""
FORCE=false
MODIFY_GITIGNORE=true

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
    echo -e "${YELLOW}[WARN]${NC} $*"
}

error() {
    echo -e "${RED}[ERROR]${NC} $*" >&2
    exit 1
}

create_if_missing() {
    local file="$1"
    local template="$2"
    local desc="$3"
    
    if [[ -f "$file" ]]; then
        if [[ "$FORCE" == true ]]; then
            warn "Overwriting: $file"
            cp "$template" "$file"
            success "$desc (overwritten)"
        else
            warn "Skipping (exists): $file"
        fi
    else
        cp "$template" "$file"
        success "$desc"
    fi
}

check_templates() {
    if [[ ! -d "$TEMPLATES_DIR" ]]; then
        error "Cannot find templates directory at $TEMPLATES_DIR"
    fi
}

create_directories() {
    log "Creating directory structure..."
    
    mkdir -p "$PROJECT_PATH/.claude"
    success ".claude/"
    
    mkdir -p "$PROJECT_PATH/docs/sessions/archive"
    success "docs/sessions/archive/"
    
    mkdir -p "$PROJECT_PATH/docs/plans"
    success "docs/plans/"
    
    mkdir -p "$PROJECT_PATH/docs/architecture/decisions"
    success "docs/architecture/decisions/"
}

copy_templates() {
    log "Copying templates..."
    
    # Project CLAUDE.md
    create_if_missing \
        "$PROJECT_PATH/.claude/CLAUDE.md" \
        "$TEMPLATES_DIR/project-CLAUDE.md" \
        ".claude/CLAUDE.md (project context)"
    
    # Session state
    create_if_missing \
        "$PROJECT_PATH/docs/sessions/CURRENT.md" \
        "$TEMPLATES_DIR/CURRENT.md" \
        "docs/sessions/CURRENT.md (session state)"
    
    # ADR template
    create_if_missing \
        "$PROJECT_PATH/docs/architecture/decisions/ADR-TEMPLATE.md" \
        "$TEMPLATES_DIR/ADR-TEMPLATE.md" \
        "docs/architecture/decisions/ADR-TEMPLATE.md"
    
    # TO-DOS.md
    if [[ ! -f "$PROJECT_PATH/TO-DOS.md" ]]; then
        cat > "$PROJECT_PATH/TO-DOS.md" << 'EOF'
# TO-DOS

## High Priority

## Medium Priority

## Low Priority

## Completed
<!-- Move completed items here with completion date -->
EOF
        success "TO-DOS.md (task tracking)"
    else
        warn "Skipping (exists): TO-DOS.md"
    fi
}

customize_project_claude() {
    # Replace placeholder in project CLAUDE.md with actual project name
    if [[ -n "$PROJECT_NAME" ]] && [[ -f "$PROJECT_PATH/.claude/CLAUDE.md" ]]; then
        if [[ "$OSTYPE" == "darwin"* ]]; then
            sed -i '' "s/\[PROJECT_NAME\]/$PROJECT_NAME/g" "$PROJECT_PATH/.claude/CLAUDE.md"
        else
            sed -i "s/\[PROJECT_NAME\]/$PROJECT_NAME/g" "$PROJECT_PATH/.claude/CLAUDE.md"
        fi
    fi
}

setup_gitignore() {
    if [[ "$MODIFY_GITIGNORE" != true ]]; then
        return
    fi
    
    local gitignore="$PROJECT_PATH/.gitignore"
    
    # Check if it's a git repo
    if [[ ! -d "$PROJECT_PATH/.git" ]]; then
        log "Not a git repository, skipping .gitignore setup"
        return
    fi
    
    log "Checking .gitignore..."
    
    # Add claude-specific ignores if not present
    local additions=""
    
    if ! grep -q "docs/sessions/CURRENT.md" "$gitignore" 2>/dev/null; then
        # We DON'T ignore CURRENT.md by default (user can choose to)
        # But we add a comment explaining the option
        if ! grep -q "# Claude Code session files" "$gitignore" 2>/dev/null; then
            additions+="
# Claude Code session files
# Uncomment below to keep session state local (not committed):
# docs/sessions/CURRENT.md
# docs/sessions/archive/
"
        fi
    fi
    
    if [[ -n "$additions" ]]; then
        echo "$additions" >> "$gitignore"
        success "Added Claude Code comments to .gitignore"
    else
        success ".gitignore already configured"
    fi
}

print_next_steps() {
    local abs_path
    abs_path="$(cd "$PROJECT_PATH" && pwd)"
    
    echo ""
    echo -e "${GREEN}════════════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}  Project Initialized: ${CYAN}$PROJECT_NAME${NC}"
    echo -e "${GREEN}════════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo "Directory structure created:"
    echo ""
    echo -e "  ${CYAN}$abs_path/${NC}"
    echo "  ├── .claude/"
    echo "  │   └── CLAUDE.md              ← Edit this with project details"
    echo "  ├── docs/"
    echo "  │   ├── sessions/"
    echo "  │   │   ├── CURRENT.md         ← Session state (auto-managed)"
    echo "  │   │   └── archive/"
    echo "  │   ├── plans/"
    echo "  │   └── architecture/"
    echo "  │       └── decisions/"
    echo "  │           └── ADR-TEMPLATE.md"
    echo "  └── TO-DOS.md"
    echo ""
    echo "Next steps:"
    echo ""
    echo "  1. Customize project context:"
    echo -e "     ${BLUE}code $abs_path/.claude/CLAUDE.md${NC}"
    echo ""
    echo "  2. Start Claude Code and initialize session:"
    echo -e "     ${BLUE}cd $abs_path${NC}"
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
            -n|--name)
                PROJECT_NAME="$2"
                shift 2
                ;;
            -f|--force)
                FORCE=true
                shift
                ;;
            --no-git)
                MODIFY_GITIGNORE=false
                shift
                ;;
            -*)
                error "Unknown option: $1. Use --help for usage."
                ;;
            *)
                PROJECT_PATH="$1"
                shift
                ;;
        esac
    done
    
    # Default project name to directory name
    if [[ -z "$PROJECT_NAME" ]]; then
        PROJECT_NAME="$(basename "$(cd "$PROJECT_PATH" && pwd)")"
    fi
}

# ============================================================================
# Main
# ============================================================================

main() {
    parse_args "$@"
    
    echo ""
    echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}  Claude Code Project Initializer${NC}"
    echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
    echo ""
    
    check_templates
    
    # Create project directory if it doesn't exist
    if [[ ! -d "$PROJECT_PATH" ]]; then
        log "Creating project directory: $PROJECT_PATH"
        mkdir -p "$PROJECT_PATH"
    fi
    
    create_directories
    copy_templates
    customize_project_claude
    setup_gitignore
    print_next_steps
}

main "$@"
