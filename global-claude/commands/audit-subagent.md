---
name: audit-subagent
description: Audit subagent configuration for role definition, prompt quality, tool selection, XML structure compliance, and effectiveness. Use for validating agent files, checking gold standard compliance, and ensuring proper documentation before deployment.
argument-hint: <subagent-path>
tools: Task
---

<objective>
Invoke the subagent-auditor subagent to audit the subagent at $ARGUMENTS for compliance with gold standard best practices, including pure XML structure standards.

Expected argument formats:
- Agent name only: "rails-expert" (will look in .claude/agents/)
- Relative path: "agents/rails-expert.md"
- Absolute path: "/full/path/to/agent.md"

This ensures subagents follow proper structure, configuration, pure XML formatting, and implementation patterns compared against gold standard agents like puppet-expert, rails-expert, typescript-expert, and code-reviewer.
</objective>

<process>
1. Invoke subagent-auditor subagent with Task tool
2. Pass subagent path: $ARGUMENTS
3. Subagent performs comprehensive audit covering:
   - YAML frontmatter validation (name, description, tools)
   - Pure XML structure compliance (no markdown headings)
   - Required sections verification (10 critical: role, tool_usage, context_scope, constraints, workflow, quality_acceptance_criteria, validation_before_handoff, error_handling, handoff_notes_template, example_invocations)
   - Modal verb usage analysis (MUST/NEVER/ALWAYS count - minimum 20+ required)
   - Context scope validation (absolute paths, boundaries, ignores)
   - Code patterns and examples completeness (100+ lines of examples required)
   - Workflow and validation procedures
   - Error handling scenarios (10+ required)
4. Subagent generates detailed report including:
   - Overall score (0-100) and category scores
   - Critical/High/Medium/Low priority issues with specific line numbers
   - Actionable recommendations with before/after code examples
   - Gold standard comparison showing compliance gaps
   - Prioritized action plan with time estimates
5. Review findings and recommendations
6. Decide on remediation approach based on priority
</process>

<success_criteria>
- Subagent-auditor invoked successfully
- Arguments passed correctly to subagent
- Audit report generated with overall score (0-100)
- All issues identified with specific line numbers
- Recommendations are actionable with before/after examples
- Gold standard comparison included in report
- User receives prioritized action plan with time estimates
- Critical issues clearly marked for immediate attention
- Report includes category scores (YAML, XML Structure, Sections, Content, Examples)
</success_criteria>

<error_handling>
Common issues and resolutions:

**Agent file not found:**
- List available agents in .claude/agents/ directory
- Verify path format (name only, relative, or absolute)
- Suggest using Glob to find agent files: `agents/*.md`

**Invalid path format:**
- Validate path exists and points to .md file
- Check for typos in agent name
- Suggest correction based on similar agent names

**subagent-auditor missing:**
- Report error: "subagent-auditor not found in .claude/agents/"
- This auditor subagent must exist to perform audits
- Suggest creating subagent-auditor first

**Empty or malformed agent file:**
- Report as CRITICAL audit failure
- Agent file must have YAML frontmatter and content
- Suggest reviewing gold standard agents for structure

**Audit returns low score (<50):**
- Review critical issues first (blocking problems)
- Focus on YAML frontmatter and XML structure compliance
- Check for required sections presence
- Compare against gold standard agents
</error_handling>

<examples>
# Audit by agent name (most common)
/audit-subagent rails-expert
/audit-subagent python-expert
/audit-subagent code-reviewer

# Audit by relative path
/audit-subagent agents/typescript-expert.md
/audit-subagent agents/sql-expert.md

# Audit by absolute path
/audit-subagent /Users/user/.claude/agents/puppet-expert.md

# Audit newly created agent
/audit-subagent my-new-agent

# Re-audit after fixes
/audit-subagent rails-expert
</examples>
