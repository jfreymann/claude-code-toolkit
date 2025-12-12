---
name: fix-test
description: Debug and fix a failing test. Whether it's TDD red-phase, CI failure, or a regression - systematically identify and resolve the issue.
---

# Fix Test

Diagnose and fix failing tests. Works for any scenario: TDD workflow, CI failures, or regressions.

## Usage

```bash
/fix-test                              # Interactive - asks what's failing
/fix-test spec/models/user_spec.rb:42  # Specific test by line
/fix-test "user authentication"        # By description
/fix-test --ci                         # Analyze CI failure output
```

---

## Diagnostic Process

### Step 1: Reproduce the Failure

```bash
# Run the specific failing test
bundle exec rspec spec/path/to_spec.rb:LINE --format documentation

# Or with verbose output
bundle exec rspec spec/path/to_spec.rb:LINE --format documentation --backtrace
```

Capture:
- The failure message
- The expected vs actual values
- The stack trace

### Step 2: Classify the Failure

| Failure Type | Symptoms | Likely Cause |
|--------------|----------|--------------|
| **Assertion failure** | `expected X, got Y` | Logic bug or wrong expectation |
| **Error raised** | `RuntimeError`, `NoMethodError` | Code bug or missing setup |
| **Timeout** | Test hangs | Infinite loop, deadlock, slow external call |
| **Flaky** | Passes sometimes | Race condition, time-dependent, order-dependent |
| **Setup failure** | `before` block errors | Missing fixtures, DB state |

### Step 3: Diagnose

Based on failure type:

#### Assertion Failure
```
Expected: "authenticated"
     Got: "pending"
```

Questions:
1. Is the expectation correct? (Maybe the test is wrong)
2. Is the code correct? (Maybe the implementation is wrong)
3. Is setup correct? (Maybe test data is wrong)

Debug approach:
```ruby
it 'authenticates the user' do
  # Add debugging
  pp user.attributes
  pp user.status
  
  result = authenticate(user)
  
  pp result  # What did we actually get?
  
  expect(result).to eq("authenticated")
end
```

#### Error Raised
```
NoMethodError: undefined method `authenticate' for nil:NilClass
```

Questions:
1. What's nil that shouldn't be?
2. Is the setup creating the required objects?
3. Are mocks returning nil instead of objects?

Debug approach:
- Add nil checks
- Verify setup creates expected objects
- Check mock return values

#### Flaky Test
Questions:
1. Time-dependent? (Freeze time with `travel_to`)
2. Order-dependent? (Run in isolation vs suite)
3. Race condition? (Async operations)
4. External dependency? (Network, file system)

Debug approach:
```bash
# Run in isolation
bundle exec rspec spec/path/to_spec.rb:LINE

# Run multiple times
for i in {1..10}; do bundle exec rspec spec/path/to_spec.rb:LINE; done

# Run in random order
bundle exec rspec spec/path/to_spec.rb --order random
```

### Step 4: Identify Root Cause

Present findings:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 🔍 TEST DIAGNOSIS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

 Test: user authentication with valid credentials
 File: spec/services/auth_service_spec.rb:24

 Failure: Assertion - expected "authenticated", got "pending"
 
 Root Cause: User factory creates users with status: "pending"
             but authentication requires status: "active"

 The test is correct. The setup is incomplete.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### Step 5: Determine Fix

| Root Cause | Fix |
|------------|-----|
| Test expectation wrong | Update test |
| Test setup incomplete | Fix setup/fixtures |
| Code has bug | Fix implementation |
| Mock misconfigured | Fix mock |
| Flaky due to timing | Add time freeze / waits |
| Flaky due to order | Fix test isolation |

### Step 6: Apply Fix

Make the minimal change to fix the issue. Present:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 ✓ FIX APPLIED
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

 Change: spec/services/auth_service_spec.rb

 - let(:user) { create(:user) }
 + let(:user) { create(:user, status: :active) }

 Reason: Authentication requires active user status

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 → Run test to verify fix?
```

### Step 7: Verify

```bash
# Run the fixed test
bundle exec rspec spec/path/to_spec.rb:LINE

# Run related tests to check for regressions
bundle exec rspec spec/services/auth_service_spec.rb

# Run full suite if change was significant
bundle exec rspec
```

---

## Common Fixes

### Wrong Factory Defaults
```ruby
# Problem: Factory doesn't match test assumptions
let(:user) { create(:user) }  # status: "pending" by default

# Fix: Override the default
let(:user) { create(:user, status: :active) }

# Better fix: Create a trait
# In factory:
trait :active do
  status { :active }
end

# In test:
let(:user) { create(:user, :active) }
```

### Time-Dependent Tests
```ruby
# Problem: Test depends on current time
it 'expires after 24 hours' do
  token = create(:token)  # created_at = Time.now
  travel 25.hours
  expect(token).to be_expired
end

# Fix: Freeze time for consistency
it 'expires after 24 hours' do
  freeze_time do
    token = create(:token)
    travel 25.hours
    expect(token).to be_expired
  end
end
```

### Missing Stubs
```ruby
# Problem: External service called in test
it 'sends notification' do
  user.notify!  # Actually calls Twilio API
end

# Fix: Stub the external call
it 'sends notification' do
  allow(TwilioClient).to receive(:send_sms).and_return(true)
  user.notify!
  expect(TwilioClient).to have_received(:send_sms)
end
```

### Order-Dependent Tests
```ruby
# Problem: Test passes alone, fails in suite
it 'has no users' do
  expect(User.count).to eq(0)  # Fails if previous test created users
end

# Fix: Don't depend on global state
it 'has no users' do
  # Either clean up explicitly
  User.delete_all
  expect(User.count).to eq(0)
  
  # Or test the behavior, not the count
  user = create(:user)
  expect(User.where(id: user.id)).to exist
end
```

---

## CI Failure Analysis

When analyzing CI output:

1. **Find the failure** - Look for `FAILED` or error sections
2. **Get the context** - What tests ran before?
3. **Check environment** - CI vs local differences?
4. **Check timing** - CI is often slower

Common CI-specific issues:
- Different database (SQLite vs Postgres)
- Missing environment variables
- Timezone differences
- Slower machines (timeout issues)
- Parallel test interference

---

## When to Ask for Help

Escalate if:
- Spent 30+ minutes without progress
- Issue involves unfamiliar code
- Flaky test with no obvious cause
- CI passes but local fails (or vice versa)

```bash
/fix-test --stuck   # Provide detailed context for pairing/debugging
```
