---
name: code-implementation-planner
description: Plans code implementation from the user's requirements and repository context.
---

# Code Implementation Planner

## When to Use

This should be used before starting any new implementation. If not available as a native skill, it should be read directly and used as part of the task requirements.

## Inputs

- The user's request, which may be in the form of an issue ID.
- Relevant repository context and constraints.

## Guidelines
When assigned an implementation task, you must perform the implementation in several steps in order to allow the user places to course-correct. 

- PLAN the change and check direction with the user (unless the user is giving fresh direction on an existing request)
- Implement ONLY THE NECESSARY change, targeting the SMALLEST POSSIBLE DIFF. Run the `self-code-review`skill from this repository BEFORE committing, and prompt user if unsure about how to apply rules to UNCOMMITTED DIFF.
- Create a Draft PR so that the user can easily review
- You and the user will collaborate on the draft PR until the user is happy with the implementation. On subsequent iterations,the self-code-review skill should take the ENTIRE PR DIFF into account, not just the iteration.
- When requested by the user (after he is happy with implementation), generate tests for the implementation and post them to the draft PR so that CI can execute those tests
- Further action should only be taken from user cues.

This workflow is VERY IMPORTANT to REDUCE WASTED TURNS.


## Output

### PLAN output:

- A table with the following columns:
- Description (One short sentence explaining the intended change)
- Filename (just the filename relative to the repository root; in code backticks)
- T-shirt size for change (XS, S,M,L, XL)
- Flags:
- Concerns with approach
- Unknowns/Questions












 








