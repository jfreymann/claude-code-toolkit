---
name: add-tests
description: Add tests to existing working code. The test-after workflow for when you've built something and want to add coverage.
---

# Add Tests

Add test coverage to existing code. Use this when you have working code and want to add tests for confidence.

## When to Use

- You've built a feature and it works
- You want safety before refactoring
- Adding coverage to legacy code
- You know the behavior you want to preserve

## When NOT to Use

- You haven't written the code yet → use `/test-first`
- Quick spike / prototype (maybe skip tests entirely)
- Trivial code that's obvious

---

## Execution

### Step 1: Understand What Exists

Ask (if not provided):
1. **What code needs tests?** (file, class, method)
2. **What does it do?** (or I can read the code)
3. **What's most important to test?** (critical paths, edge cases)

If given a file/class, read it and identify:
- Public interface (what to test)
- Happy path behavior
- Edge cases and error conditions
- Dependencies that need mocking

### Step 2: Assess Test Value

Categorize the code:

| Category | Test Approach |
|----------|---------------|
| Business logic with rules | Test thoroughly |
| Data transformation | Test inputs → outputs |
| Validation | Test valid + invalid cases |
| External API integration | Test with mocks/stubs |
| Simple CRUD | Light testing or skip |
| Glue/orchestration | Test through integration |

Present assessment:
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 TEST ASSESSMENT: {class/file}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

 High Value (recommend testing):
 • {method} - {why}
 • {method} - {why}

 Medium Value (test if time permits):
 • {method} - {why}

 Low Value (likely skip):
 • {method} - {why}

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 → Start with high-value tests?
```

### Step 3: Identify Test Cases

For each method/behavior to test, identify:

```markdown
## {Method/Behavior}

### Happy Path
- Given {setup}, when {action}, then {expected}

### Edge Cases
- Empty input → {expected}
- Nil/null → {expected}
- Boundary values → {expected}

### Error Cases
- Invalid input → {expected error}
- Missing dependency → {expected error}
```

### Step 4: Determine Test Type

| Situation | Test Type |
|-----------|-----------|
| Pure function, no dependencies | Unit test |
| Class with mockable dependencies | Unit test with mocks |
| Database interaction | Integration test |
| Multiple components together | Integration test |
| Full request/response | Request/system test |

### Step 5: Write Tests

Generate tests following project conventions:

**Rails/RSpec pattern:**
```ruby
RSpec.describe ClassName do
  describe '#method_name' do
    context 'when condition' do
      it 'does expected thing' do
        # Arrange
        subject = described_class.new(args)
        
        # Act
        result = subject.method_name(input)
        
        # Assert
        expect(result).to eq(expected)
      end
    end
    
    context 'when edge case' do
      it 'handles gracefully' do
        # ...
      end
    end
  end
end
```

**Jest pattern:**
```javascript
describe('ClassName', () => {
  describe('methodName', () => {
    it('does expected thing when condition', () => {
      // Arrange
      const instance = new ClassName(args);
      
      // Act
      const result = instance.methodName(input);
      
      // Assert
      expect(result).toBe(expected);
    });
  });
});
```

### Step 6: Run and Verify

After writing tests:

1. **Run the new tests** - Should pass (code already works)
2. **Break the code intentionally** - Tests should fail
3. **Fix the code** - Tests pass again

If tests pass with broken code, they're not testing the right thing.

### Step 7: Report

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 ✓ TESTS ADDED: {class/file}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

 File: {test_file_path}
 Tests: {N} examples

 Coverage:
 • {method} - {N} tests (happy path, edge cases)
 • {method} - {N} tests (error handling)

 Skipped (low value):
 • {method} - {reason}

 All passing: ✓

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## Test Quality Checklist

Before finishing, verify:

- [ ] Tests would fail if behavior broke
- [ ] Not testing implementation details
- [ ] Not testing framework code
- [ ] Readable - intent is clear
- [ ] Independent - can run in any order
- [ ] Fast - no unnecessary setup

---

## Mocking Guidelines

**Mock when:**
- External services (APIs, email, etc.)
- Slow operations (file I/O, network)
- Non-deterministic things (time, random)

**Don't mock:**
- The class under test
- Simple value objects
- Database (usually - use test DB instead)

**Mock boundaries, not internals.**

---

## Usage

```bash
/add-tests                           # Interactive
/add-tests app/models/user.rb        # Specific file
/add-tests UserService               # Specific class
/add-tests "the checkout flow"       # Describe what needs tests
```
