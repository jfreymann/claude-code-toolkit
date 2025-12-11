---
name: audit-slash-command
description: Audit slash command file for YAML configuration, prompt quality, user experience, and best practices. Use for validating command quality, checking compliance standards, and ensuring proper documentation before deployment.
argument-hint: <command-path>
tools: Task
---

<objective>
Invoke the slash-command-auditor subagent to audit the slash command at $ARGUMENTS for compliance with best practices and quality standards.

Expected argument formats:
- Command name only: "debug" (will look in .claude/commands/)
- Relative path: "commands/debug.md"
- Subdirectory: "commands/consider/pareto.md"
- Absolute path: "/full/path/to/command.md"

This ensures commands follow YAML configuration standards, security practices, clarity requirements, and effectiveness patterns for optimal user experience.
</objective>

<process>
1. Invoke slash-command-auditor subagent with Task tool
2. Pass command path: $ARGUMENTS
3. Subagent performs comprehensive audit covering:
   - YAML frontmatter validation (name, description, tools, model)
   - Command name matches filename verification
   - Tool permission appropriateness (least privilege principle)
   - Built-in command conflict detection
   - Argument handling validation ($ARGUMENTS patterns)
   - Prompt quality assessment (task definition, instructions, output spec)
   - User experience evaluation (discoverability, usability, clarity)
   - Integration analysis (ecosystem fit, efficiency, model selection)
4. Subagent generates detailed report including:
   - Overall score (0-100) and category scores (Configuration, Prompt Quality, UX, Integration)
   - Critical/Warning/Suggestion issues with specific line numbers
   - Actionable recommendations with before/after YAML examples
   - Comparison to similar commands for consistency
   - Prioritized action plan with effort estimates
5. Review findings and recommendations
6. Decide on remediation approach based on priority
</process>

<success_criteria>
- Slash-command-auditor invoked successfully
- Arguments passed correctly to subagent
- Audit report generated with overall score (0-100)
- All issues identified with specific line numbers
- Recommendations are actionable with before/after examples
- Similar commands comparison included in report
- User receives prioritized action plan with effort estimates
- Critical issues clearly marked for immediate attention
- Report includes category scores (Configuration, Prompt Quality, UX, Integration)
</success_criteria>

<error_handling>
Common issues and resolutions:

**Command file not found:**
- List available commands in .claude/commands/ directory
- Check subdirectories (e.g., .claude/commands/consider/)
- Verify path format (name only, relative, or absolute)
- Suggest using Glob to find command files: `commands/**/*.md`

**Invalid path format:**
- Validate path exists and points to .md file
- Check for typos in command name
- Suggest correction based on similar command names

**slash-command-auditor missing:**
- Report error: "slash-command-auditor not found in .claude/agents/"
- This auditor subagent must exist to perform audits
- Suggest creating slash-command-auditor first

**Empty or malformed command file:**
- Report as CRITICAL audit failure
- Command file must have YAML frontmatter and prompt body
- Suggest reviewing well-structured commands for reference

**Audit returns low score (<50):**
- Review critical issues first (invalid YAML, security concerns)
- Focus on YAML frontmatter validation (name, description)
- Check for built-in command conflicts
- Verify tool permissions follow least privilege
</error_handling>

<examples>
# Audit by command name (most common)
/audit-slash-command debug
/audit-slash-command create-plan
/audit-slash-command status

# Audit consideration framework commands
/audit-slash-command consider/pareto
/audit-slash-command consider/first-principles

# Audit by relative path
/audit-slash-command commands/debug.md
/audit-slash-command commands/consider/5-whys.md

# Audit by absolute path
/audit-slash-command /Users/user/.claude/commands/custom-command.md

# Audit newly created command
/audit-slash-command my-new-command

# Re-audit after fixes
/audit-slash-command debug
</examples>
