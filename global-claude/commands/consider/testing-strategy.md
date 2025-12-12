# Consider: Testing Strategy

A framework for deciding when and how to test.

## The Hybrid Approach

Neither pure TDD nor "test never" - choose the right approach for the context.

```
┌─────────────────────────────────────────────────────────────┐
│                    TESTING SPECTRUM                         │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  TEST-FIRST ◄─────────────────────────────► TEST-AFTER     │
│                                                             │
│  • Known interface         • Learning/exploring            │
│  • Bug reproduction        • Integration with new API      │
│  • Business rules          • UI/visual work                │
│  • Refactoring             • Prototypes                    │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

## Decision Matrix

| Situation | Approach | Why |
|-----------|----------|-----|
| Bug fix | Test-first | Prove bug exists, prove fix works |
| Clear interface/spec | Test-first | Spec drives design |
| Refactoring existing code | Test-first (if missing) | Safety net first |
| Learning new API | Test-after | Discovery mode |
| Spike/prototype | Skip tests | Throwaway code |
| UI component | Test-after (integration) | Unit tests less valuable |
| Business logic | Test-first or after | High value either way |
| CRUD glue code | Light testing | Low risk, low value |

## What to Test

**High Value** - Always test:
- Business logic with rules
- Data transformations
- Validation logic
- Security-sensitive code
- Complex conditionals

**Medium Value** - Test if time permits:
- API response formatting
- Error message generation
- Configuration handling

**Low Value** - Usually skip:
- Trivial getters/setters
- Framework delegation (Rails validations, etc.)
- Simple CRUD operations
- Private implementation details

## Test Quality Over Quantity

One good test beats ten weak ones:

```ruby
# Weak: Tests implementation
it 'calls validator with params' do
  expect(validator).to receive(:call).with(params)
  subject.process(params)
end

# Strong: Tests behavior
it 'rejects invalid email format' do
  result = subject.process(email: 'not-an-email')
  expect(result.errors).to include(:email)
end
```

## The "Break It" Test

After writing a test, verify it works:

1. Run the test (should pass)
2. Break the implementation intentionally
3. Run the test again (should fail)
4. Fix the implementation

If the test still passes with broken code, it's not testing the right thing.

## When to Skip Tests

It's okay to skip tests when:

- **Spiking** - Exploratory code you'll throw away
- **Trivial code** - One-liners with obvious behavior
- **Time pressure** - Ship first, add tests later (but actually add them)
- **Framework code** - Trust that Rails validations work

When you skip, be intentional:
```ruby
# TODO: Add tests before merging
# Skipping for spike - will add if approach works
```

## Test Types by Layer

```
┌─────────────────────────────────────────────────────────────┐
│  E2E/System Tests                                           │
│  └─ Full user workflows, browser-based                      │
│     Value: High (user perspective) | Speed: Slow            │
├─────────────────────────────────────────────────────────────┤
│  Integration Tests                                          │
│  └─ Multiple components together, real DB                   │
│     Value: High | Speed: Medium                             │
├─────────────────────────────────────────────────────────────┤
│  Unit Tests                                                 │
│  └─ Single class/function, mocked dependencies              │
│     Value: Medium | Speed: Fast                             │
└─────────────────────────────────────────────────────────────┘
```

**The pyramid is a guideline, not a rule.** Sometimes more integration tests and fewer unit tests is the right call.

## Mocking Philosophy

**Mock at boundaries, not internals:**

```ruby
# Good: Mock external service
allow(StripeClient).to receive(:charge).and_return(success_response)

# Bad: Mock internal implementation
allow(subject).to receive(:calculate_tax).and_return(10.00)
```

**When to mock:**
- External services (APIs, email, SMS)
- Slow operations (network, file I/O)
- Non-deterministic behavior (time, random)

**When not to mock:**
- The class under test
- Database (usually use test DB)
- Simple value objects
- Internal collaborators (usually)

## Flaky Test Prevention

Tests should be:

1. **Deterministic** - Same result every run
2. **Isolated** - No dependency on other tests
3. **Fast** - No unnecessary waiting
4. **Independent of time** - Use `freeze_time` or `travel_to`

Common flakiness sources:
- Time-dependent assertions
- Order-dependent database state
- Race conditions in async code
- External service dependencies

## Testing in Practice

### Starting a new feature
```
1. Write code (exploratory)
2. Get it working
3. Identify critical paths
4. Add tests for critical paths
5. Refactor with confidence
```

### Fixing a bug
```
1. Write failing test (reproduces bug)
2. Verify test fails
3. Fix the bug
4. Verify test passes
5. Commit test + fix together
```

### Refactoring
```
1. Check for existing tests
2. If missing, add tests first
3. Refactor in small steps
4. Run tests after each step
5. Keep tests passing throughout
```

## Questions to Ask

Before writing tests:
- What's the most important behavior to verify?
- What would break if this code changed?
- Is this testing behavior or implementation?

After writing tests:
- Would this test catch a real bug?
- Is this test readable without the implementation?
- Will this test be stable over time?
