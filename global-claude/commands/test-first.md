---
name: test-first
description: TDD workflow - write the test first, then make it pass. Use when the contract/interface matters.
---

# Test First (TDD Mode)

Write a failing test first, then implement code to make it pass. Use this when:
- The interface/contract is important
- You're fixing a bug (prove it exists first)
- Adding to well-established code
- Business logic with clear rules

## The Cycle

```
   ┌─────────────────────────────────┐
   │                                 │
   ▼                                 │
 RED ──────► GREEN ──────► REFACTOR ─┘
 (test fails)  (test passes)  (clean up)
```

1. **RED**: Write a test that fails (describes what you want)
2. **GREEN**: Write minimum code to make it pass
3. **REFACTOR**: Clean up while keeping tests green
4. **Repeat**: Next test case

---

## Execution

### Step 1: Define What You're Building

Ask (if not provided):
1. **What behavior are you adding?** (one thing at a time)
2. **What's the expected interface?** (inputs/outputs)
3. **What are the rules?** (business logic, constraints)

### Step 2: Start with the Simplest Case

Don't try to solve everything at once. Pick the simplest happy path.

**Example - Building a price calculator:**

❌ Don't start here:
```ruby
it 'calculates price with discounts, taxes, and shipping for multiple items'
```

✅ Start here:
```ruby
it 'returns 0 for empty cart'
```

Then:
```ruby
it 'returns item price for single item'
```

Then:
```ruby
it 'sums prices for multiple items'
```

Build up complexity one test at a time.

### Step 3: Write the Failing Test

Write a test that:
- Describes the behavior in plain language
- Will fail (code doesn't exist or doesn't do this yet)
- Is specific and focused

```ruby
# RED - This test should fail
RSpec.describe PriceCalculator do
  describe '#total' do
    it 'returns 0 for empty cart' do
      calculator = PriceCalculator.new(items: [])
      
      expect(calculator.total).to eq(0)
    end
  end
end
```

**Run the test - confirm it fails:**
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 🔴 RED: Test fails as expected
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

 Failure: NameError - uninitialized constant PriceCalculator
 
 This is correct! The class doesn't exist yet.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 → Write implementation to make it pass?
```

### Step 4: Write Minimum Code to Pass

Don't write the "right" solution. Write the **simplest** thing that makes the test pass.

```ruby
# GREEN - Minimum code to pass
class PriceCalculator
  def initialize(items:)
    @items = items
  end
  
  def total
    0  # Yes, just return 0. That's all the test requires.
  end
end
```

**Run the test - confirm it passes:**
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 🟢 GREEN: Test passes
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

 PriceCalculator#total
   returns 0 for empty cart ✓

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 → Refactor, or add next test?
```

### Step 5: Refactor (If Needed)

With a passing test, you can safely refactor. If the code is already clean, skip to the next test.

### Step 6: Add Next Test

Now add a test that forces you to write real logic:

```ruby
it 'returns item price for single item' do
  item = Item.new(price: 100)
  calculator = PriceCalculator.new(items: [item])
  
  expect(calculator.total).to eq(100)
end
```

**Run - it fails** (because we just return 0):
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 🔴 RED: New test fails
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

 Failure: expected 100, got 0
 
 Previous test still passes.
 New test drives us to add real logic.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

**Update implementation:**
```ruby
def total
  @items.sum(&:price)
end
```

**Run - all pass:**
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 🟢 GREEN: All tests pass
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

 PriceCalculator#total
   returns 0 for empty cart ✓
   returns item price for single item ✓

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### Step 7: Continue the Cycle

Build up the implementation test by test:
- Multiple items
- Discounts
- Tax
- Edge cases
- Error handling

Each test adds one new requirement.

---

## Bug Fix Workflow

TDD is perfect for bug fixes:

1. **Write a test that reproduces the bug** (should fail)
2. **Confirm it fails** (proves the bug exists)
3. **Fix the bug** (test passes)
4. **Bug can never silently return** (test prevents regression)

```ruby
# Step 1: Prove the bug
it 'handles negative quantities without crashing' do
  # This was reported as a bug - system crashes on negative qty
  item = Item.new(price: 100, quantity: -1)
  calculator = PriceCalculator.new(items: [item])
  
  # We want it to raise a clear error, not crash
  expect { calculator.total }.to raise_error(InvalidQuantityError)
end
```

---

## When to Stop

TDD can go on forever. Stop when:
- All acceptance criteria are met
- You can't think of another meaningful test
- The tests describe the full behavior
- Edge cases are covered

You don't need to test every possible input - test the categories:
- Typical case
- Edge cases (empty, nil, boundary values)
- Error cases

---

## Common Pitfalls

**Writing too much code at once**
- Resist the urge to "finish" the implementation
- Only write what the current test requires

**Tests that are too big**
- One behavior per test
- If a test needs lots of setup, break it down

**Testing implementation, not behavior**
- Test what it does, not how it does it
- "returns total" not "calls sum method"

**Not running tests frequently**
- Run after every small change
- Catch mistakes immediately

---

## Integration with Plan

When doing TDD within a plan:

```bash
/test-first "Task 2.1: Validate agent certificates"
```

After completing:
```bash
/update-plan complete 2.1
```

---

## Usage

```bash
/test-first                              # Interactive - what are we building?
/test-first "price calculator"           # Start TDD session for feature
/test-first --bug "issue #123"           # Bug fix workflow
/test-first --continue                   # Resume TDD session (next test)
```
