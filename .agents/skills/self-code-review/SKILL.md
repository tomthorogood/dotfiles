---
name: self-code-review
description: Self-code review.
---

# Self Code Review

## Intent

This skill is intended to replicate @tomthorogood's *personal* preferences when reviewing code he writes, before presenting to others for review. 
This is not intended to conflict with estasblished repository-level maxims.

The intent is to minimize the number of user-prompted turns to achieve similar results by invoking this skill prior to committing.

This should be run *before* committing code, taking into account the pending changeset as a whole. 

### Output

Along with making the request changes, your output to the User or calling surface should follow these guidelines:

- Do not explain what you just did. The user made these rules; he knows what you just did.
- Do not execute tests after making said changes. Let the user review first.
- Do not tell the user that you did not execute tests. Just don't mention it.
- If there are obvious changes that should be made, but weren't due to [rigidity of application](#rigidity-of-application), summarize them with one bullet each; each bullet must be a **maximum** of two sentences. The user will ask if they want more detail.
- Whenever referencing code, link to the code in question.

## Rigidity of Application

The user may indicate a level of rigidty to apply these rules. Use these guidelines to tailor the results based on the user's indication. 

The default rigidity is **Conservative**. The user will then review and let you know when they are ready for follow-up cycles which may apply more liberal guidance.

## Workflow

- Evaluate each rule for the given rigidity level; treat the guidance as a checklist
- Evaluate ONLY the rules explicitly provided for the current rigidity levels

### Conservative Changes

This rigidity level is targeted at **minimizing lines of change** and **reducing total lines of code** while still ensuring some general good practices.

- This is intended to be the cleanest reviewable version with the least amount of deviation from the default (main/master) branch of the target repository/PR.
- We love removing dead code wherever it makes sense to do so.
- The user may request this to be run on code that hasn't changed, to evaluate ideas for future changes.

#### General guidance

- Look for redundant or dangling artifacts and remove them where clearly safe.
  Before removing always check for references to the artifact; if publicly exposed within the code base, perform a general code search.
- New code should not add exceptions to linting rules unless functionally critical. (Example: `# rubocop:disable Foo/Bar` smells really bad.)
- Remove any comments added to the pending changeset, unless they are macros/functional required for compliance.
- When implementing new methods, evaluate whether they should `private` to prevent CI churn later.
- Avoid over-minimizing new variable names. (`change_pct` should be `change_percent`)
- Avoid typing in variable names (`foo_str` should just be `foo`)
- Avoid re-typing variables if used in logic:

```ruby
# OK EXAMPLE
foo = input.fetch(:foo, "0").to_i  # first declaration is pre-cast to to an int

## BAD EXAMPLE
foo = input.fetch(:foo, "0")
message = "Foo is #{foo}"
foo = foo.to_i
```
- In the event where previous rules conflict with each other, make a choice, and raise it to the user in the output in case they would prefer you made a different one.
- **Evaluate** guidance from [Balanced Changes](#balanced-changes) but do _not_ apply suggestions. Instead, take note of the top red flags and present them to the user or calling surface following output guidelines and user preferences.

#### Test suites

These suggestions only apply to test implementation.

- Don't add new tests when executing this skill at this rigidity level. 
- Wherever possible, remove or minimize use of mocks in tests; prefer to use existing test suites and helpers
- Remove redundant test information

Examples of redundant test information:

```ruby
# Ensure that foo == bar         #! REDUNDANT! We hate comments at this level. 
test "foo should equal bar" do
   foo = Thing.foo
   bar =  Thing.bar
   assert_equal foo, bar, "foo should equal bar"   #! "foo should equal bar" is also REDUNDANT
end
```

- Remove redundant assertions 
- Collapse unnecessary variable extractions (in above example, collapse test to `assert_equal Thing.foo == Thing.bar`)

### Balanced Changes

This rigidity level is targeted at **enforcing maintainable code** within the proposed changeset, while keeping a fuzzier border of what can be modified than the above conservative level. 

- Total lines of code should be reduced wherever directly related to the pending changes (This does not mean to create opaque one-liners to reduce lines of code.)
- New lines of code can be added where promoting maintainability (example: when breaking a block of code into its own method, new lines of code will include method definition/boiler-plate)

#### General guidance

- Follow all guidance from [Conservative changes](#conservative-changes)
- Look for critical availability concerns; address them if they do not add a significant amount of new lines of code; suggest them to the user/calling surface otherwise for the user to evaluate.
  - Performance bottlenecks
  - Race conditions
  - Swallowed/unhandled exceptions
  - DDoS vectors
  - General vectors for malicious intent
- Where related and sensible, remove existing linting rule exceptions and re-implement to follow preferred standards
- Break up extra long methods. Ideas of where to look:
    - long if/then/else clauses -- break each into its own method, unless \<method definition+code body\> is longer than the reference inside the parent method itself (ie, if it's such a short clause that it would add confusion to break it out)
- Look for comments that can be removed: comments that explain self-evident code; comments that duplicate information presented in type indicators and method definition
- DRY out repeated/shared code into a shared module, where possible and sensible; ensure any related tests are also moved to shared suites and collapsed to reduce repeated CI runs and maintenance
- Look for concepts that similar in related contexts, and reduce them to a single idea:

```ruby
# BAD EXAMPLE:
class Foo
   STATUSES = [:ok, :not_ok, :meh]
end

class Bar
   STATUSES = [:good, :bad, :ok]
end

# GOOD EXAMPLE:

class EmotionalStatus
   STATUSES = [:good, :bad, :fine]
end

class Foo < EmotionalStatus; end
class Bar < EmotionalStatus; end
```

- Think critically about component types/definitions and make changes were related and sensible:
  - **ruby**-specific: consider modules vs. classes; include vs. extend; struct vs. enum, etc; built-in rails helpers vs. bespoke helpers (prefer built-in where available)
  - **python**-specific: dataclass vs general class; we love pydantic as a dependency
- Look for repeat calls within any given context that can be cached for the execution
- Look for potential OOM errors (large result sets, unbatched queries, etc.)
- Look for missing metrics that could be emitted so that any new features have an observability story
- Look for existing metrics that could be updated with new tags to include new facets to existing observability stories


#### Test suites

- Ensure new files have new test suites, and that related tests are in the right place
- Remove tests that are duplicated between different test suites
- Add only tests that are not already covered by existing test logic, unless it's an explicit feature/configuration test for a problem we are trying to solve
- Ensure related tests share a related context, where avaialble (example: all tests pertaining to a given feature flag, method, configuration)
- Update test setup/fixtures to reduce compute overhead
- *Do* hard-code/force-apply timestamps wherever possible to prevent flakiness due to date/time/time-zone changes on the testing appliance.
- Do *not* hard-code values that don't matter; prefer randomization to prevent future flakes/maintenance:

```ruby
# BAD:
test "do the thing" do
   blah = create(:foo, name: "angelface")
   blam = create(:bar, name: blah.name)
   assert_equal blam.name, "angelface"
end

# GOOD:
test "do the thing" do
   blah = create(:foo)
   blam = create(:bar, name: blah.name)
   assert_equal blah.name, blam.name
end
```


### Aggressive Changes

This rigidity level is intended for **larger refactors** to bring a part of the ecosystem up to a new standard. It should not be considered unless explicitly requested. 

#### General Guidance

- Follow all guidance from [Conservative changes](#conservative-changes)
- Follow all guidance from [Balanced changes](#balanced-changes)
- Creating new files, and breaking apart long methods should be done with prejudice.
- Cleaning up pre-existing and related code (even if otherwise untouched) should be done where overall clarity and availability is increased, while still trying to reduce total lines of code where possible

#### Test suites

- Remove hard-coded values, except for timestamps, unless functionally required by the test
- Aggressively remove related tests that have no purpose or are covered by other suites
- Aggressively refactor tests to maintain appropriate context/suite boundaries; move tests and create new test suites where needed.