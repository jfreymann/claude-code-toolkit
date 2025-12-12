---
name: run-tests
description: Execute tests and interpret results. Handles failures intelligently with suggested fixes.
---

# Run Tests

Execute the test suite (or specific tests) and interpret the results. More than just running tests - helps diagnose failures and suggest fixes.

## Basic Usage

```bash
/run-tests                    # Run full suite
/run-tests spec/models/       # Run specific directory
/run-tests user_spec.rb       # Run specific file
/run-tests --failed           # Re-run only failed tests
/run-tests --changed          # Run tests for changed files
```

---

## Execution

### Step 1: Detect Test Framework

Check project for test framework:

| Files Present | Framework | Command |
|---------------|-----------|---------|
| `spec/` + `Gemfile` with rspec | RSpec | `bundle exec rspec` |
| `test/` + Rails | Minitest | `bin/rails test` |
| `package.json` with jest | Jest | `npm test` or `npx jest` |
| `package.json` with vitest | Vitest | `npm test` or `npx vitest` |
| `pytest.ini` or `pyproject.toml` | Pytest | `pytest` |
| `go.mod` | Go | `go test ./...` |

### Step 2: Determine Scope

Based on arguments:

| Input | Scope |
|-------|-------|
| (none) | Full suite |
| Directory path | All tests in directory |
| File path | Single test file |
| `--failed` | Previously failed tests |
| `--changed` | Tests for uncommitted changes |
| Test name pattern | Matching tests only |

For `--changed`, identify:
```bash
git diff --name-only HEAD | grep -E '\.(rb|js|ts|py)$'
```
Then map to corresponding test files.

### Step 3: Execute Tests

Run with appropriate flags for output:

**RSpec:**
```bash
bundle exec rspec {scope} --format documentation --format json --out tmp/rspec_results.json
```

**Jest:**
```bash
npx jest {scope} --verbose --json --outputFile=tmp/jest_results.json
```

**Pytest:**
```bash
pytest {scope} -v --tb=short --json-report --json-report-file=tmp/pytest_results.json
```

### Step 4: Parse Results

Extract from output:
- Total tests
- Passed count
- Failed count
- Pending/skipped count
- Duration
- For failures: file, line, message, backtrace

### Step 5: Present Results

#### All Passing

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 ✓ ALL TESTS PASSING
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

 Total: 47 examples
 Time:  3.2s

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

#### With Failures

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 ✗ TESTS FAILED: 2 of 47
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

 FAILURE 1: spec/models/user_spec.rb:23
 ─────────────────────────────────────
 UserModel#full_name
   "returns first and last name"
 
 Expected: "John Doe"
 Got:      "John"
 
 Code:
   expect(user.full_name).to eq("John Doe")
 
 Likely cause: full_name method not including last_name
 
 ─────────────────────────────────────
 
 FAILURE 2: spec/services/checkout_spec.rb:45
 ─────────────────────────────────────
 CheckoutService#process
   "raises error when cart is empty"
 
 Expected: EmptyCartError
 Got:      no error raised
 
 Code:
   expect { service.process }.to raise_error(EmptyCartError)
 
 Likely cause: Missing validation in process method
 
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Passed: 45 | Failed: 2 | Pending: 0
 Time: 3.4s
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 → Fix failure 1 (user_spec.rb:23)?
```

### Step 6: Diagnose Failures

For each failure, analyze:

**Assertion Failures** (expected vs got):
- Compare expected and actual values
- Check if it's a typo, logic error, or stale expectation
- Look at the implementation

**Error Exceptions**:
- Check if error is expected (test wrong) or unexpected (code wrong)
- Trace the error source
- Check for missing dependencies/setup

**Timeout/Hanging**:
- Infinite loops
- Deadlocks
- Missing test doubles for external services

### Step 7: Suggest Fixes

Based on failure analysis:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 SUGGESTED FIX: user_spec.rb:23
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

 The full_name method returns only first_name.
 
 Current (app/models/user.rb:15):
   def full_name
     first_name
   end
 
 Suggested:
   def full_name
     "#{first_name} #{last_name}"
   end

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 → Apply this fix?
```

---

## Smart Features

### Failed Test Re-run

After fixing, run only failed tests:
```bash
/run-tests --failed
```

Uses saved failure list from last run.

### Changed File Detection

Run tests related to uncommitted changes:
```bash
/run-tests --changed
```

Maps source files to test files:
- `app/models/user.rb` → `spec/models/user_spec.rb`
- `src/utils/format.js` → `src/utils/format.test.js`

### Watch Mode

For frameworks that support it:
```bash
/run-tests --watch
```

Runs tests on file changes (Jest, Vitest).

### Coverage Report

```bash
/run-tests --coverage
```

Shows coverage summary:
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 COVERAGE SUMMARY
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

 Overall: 78.3%
 
 By directory:
 • app/models/     92.1%  ████████████░░
 • app/services/   81.4%  ██████████░░░░
 • app/controllers 64.2%  ████████░░░░░░
 
 Uncovered files:
 • app/services/legacy_import.rb (0%)
 • app/controllers/admin_controller.rb (23%)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## Common Failure Patterns

| Pattern | Likely Cause | Fix |
|---------|--------------|-----|
| `nil:NilClass` | Missing setup or association | Check test setup, factories |
| `expected X, got nil` | Method not returning value | Check method return |
| `undefined method` | Typo or missing method | Check spelling, add method |
| `PG::ConnectionBad` | DB not running | Start database |
| `Timeout::Error` | External call not mocked | Add stub/mock |
| `expected to raise, didn't` | Missing validation | Add guard clause |

---

## Integration with Workflow

After running tests:

**All pass → Ready to commit:**
```bash
/run-tests
# All pass
git add . && git commit -m "feat: add user full name"
```

**Failures → Fix first:**
```bash
/run-tests
# 2 failures
# Fix the code
/run-tests --failed
# All pass now
git add . && git commit -m "fix: user full name includes last name"
```

**Pre-push verification:**
```bash
/run-tests --changed
# Verify changes don't break anything
git push
```

---

## Usage

```bash
/run-tests                     # Full suite
/run-tests spec/models/        # Directory
/run-tests user_spec.rb:23     # Specific test (line number)
/run-tests --failed            # Re-run failures
/run-tests --changed           # Tests for uncommitted files
/run-tests --coverage          # With coverage report
/run-tests --watch             # Watch mode (if supported)
```
