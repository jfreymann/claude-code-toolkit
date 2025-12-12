---
name: audit-skill
description: Audit skill for YAML compliance, pure XML structure, progressive disclosure, and best practices. Use for validating skill quality, checking structure standards, and ensuring proper documentation before deployment.
argument-hint: <skill-path>
tools: Task
---

<objective>
Invoke the skill-auditor subagent to audit the skill at $ARGUMENTS for compliance with Agent Skills best practices and quality standards.

Expected argument formats:
- Skill name only: "pdf" (will look in .claude/skills/)
- Relative path: "skills/pdf/SKILL.md"
- Absolute path: "/full/path/to/SKILL.md"

This ensures skills follow proper structure (pure XML, required tags, progressive disclosure patterns), YAML configuration standards, and effectiveness patterns for optimal agent execution.
</objective>

<process>
1. Invoke skill-auditor subagent with Task tool
2. Pass skill path: $ARGUMENTS
3. Subagent performs comprehensive audit covering:
   - YAML frontmatter validation (name, description, trigger, location)
   - Pure XML structure compliance (no markdown headings)
   - Required tags verification (<capability>, <usage>, <examples>)
   - Conditional tags appropriateness (<limitations>, <prerequisites>)
   - Progressive disclosure patterns (simple → complex examples)
   - Anti-pattern detection (mixed markdown/XML, vague examples)
   - Trigger keyword effectiveness for skill invocation
   - Example completeness and clarity
4. Subagent generates detailed report including:
   - Overall score (0-100) and category scores (YAML, XML Structure, Content, Examples)
   - Critical/High/Medium/Low priority issues with specific line numbers
   - Actionable recommendations with before/after XML examples
   - Comparison to well-structured skills for reference
   - Prioritized action plan with effort estimates
5. Review findings and recommendations
6. Decide on remediation approach based on priority
</process>

<success_criteria>
- Skill-auditor invoked successfully
- Arguments passed correctly to subagent
- Audit report generated with overall score (0-100)
- All issues identified with specific line numbers
- Recommendations are actionable with before/after XML examples
- Pure XML structure compliance evaluated
- Progressive disclosure patterns assessed
- User receives prioritized action plan with effort estimates
- Critical issues clearly marked for immediate attention
- Report includes category scores (YAML, XML Structure, Content, Examples)
</success_criteria>

<error_handling>
Common issues and resolutions:

**Skill file not found:**
- List available skills in .claude/skills/ directory
- Check for SKILL.md in skill subdirectories
- Verify path format (name only, relative, or absolute)
- Suggest using Glob to find skill files: `skills/**/SKILL.md`

**Invalid path format:**
- Validate path exists and points to SKILL.md file
- Check for typos in skill name
- Suggest correction based on similar skill names

**skill-auditor missing:**
- Report error: "skill-auditor not found in .claude/agents/"
- This auditor subagent must exist to perform audits
- Suggest creating skill-auditor first

**Empty or malformed skill file:**
- Report as CRITICAL audit failure
- Skill file must have YAML frontmatter and pure XML content
- Suggest reviewing well-structured skills for reference

**Audit returns low score (<50):**
- Review critical issues first (invalid YAML, mixed markdown/XML)
- Focus on pure XML structure (no # markdown headings)
- Check for required tags (<capability>, <usage>, <examples>)
- Verify progressive disclosure pattern (simple → complex)
- Compare against reference skills
</error_handling>

<examples>
# Audit by skill name (most common)
/audit-skill pdf
/audit-skill xlsx
/audit-skill image-analysis

# Audit by relative path
/audit-skill skills/pdf/SKILL.md
/audit-skill skills/data-processing/SKILL.md

# Audit by absolute path
/audit-skill /Users/user/.claude/skills/custom-skill/SKILL.md

# Audit newly created skill
/audit-skill my-new-skill

# Re-audit after fixes
/audit-skill pdf
</examples>
