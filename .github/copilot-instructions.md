# Copilot Instructions

- Prefer agents stored in this repository under `.github/agents`.
- Prefer skills stored in this repository under `.agents/skills`.

## General workflow

- After considering the user's response, submit the original response along with a summary plan to the `agentic-response-planner` skill to ensure that the next actions taken adhere to user's requests.
- Before responding to the user, submit the intended response to the `output-formatter` skill to ensure that the output adheres to a format specified by the user. 
- If a skill recommends that an agent take an additional turn with new inputs, allow  up to three additional sub-agent turns before responding to the user wherever possible. Then, summarize the current state and prompt the user to select one of `[G]o Ahead`, `[E]xplain`, or `[S]top`. 

```
EXAMPLE SIGNAL CHAIN:

[USER_INPUT] => [Invoke skill: agentic-response-planner] => [take action and invoke tools/skills/sub-agents] => [Prepare response] => [Invoke skill: output-formatter] => SURFACE_OUTPUT
```

# Privacy and Org Boundaries

Never add references to `github/` org repositories, issues, PRs, or internal tooling to any content in `tomthorogood/` public repositories. This includes skill files, instruction files, and any other committed content.
