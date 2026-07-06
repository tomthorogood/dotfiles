# Skill: PR Status

Fetches and formats open PR status for a given list of repositories.

## Format

Present results as a markdown table:

| Title | Repo | PR # | Branch | CI | Approvals | Tags |
| --- | --- | --- | --- | --- | --- | --- |

Column rules:

- **Title**: First 80 characters of the PR title.
- **Repo**: `owner/repo`
- **PR #**: `[#1234](https://github.com/owner/repo/pull/1234)`
- **Branch**: `` `branch-name` ``
- **CI**: Exactly one:
    - All checks passing: 🌈
    - Any checks in progress: 🏃‍♂️
    - Required checks failed: 😭
    - Other checks failed: 🤷‍♂️
- **Approvals**: All that apply:
    - @copilot approved: 🤖
    - Human approved: ⛵
    - Unresolved comments: 🗣️
    - Draft: 🫥
- **Tags**: All that apply:
    - PR is > 1 week old: 🍞
    - Blocked (by user, issue, comments, or labels): 🤲
    - Merge conflict with base branch: 🥊

## Finding PRs

Include PRs authored by tomthorogood. Also include PRs authored by Copilot bots (e.g. copilot, github-actions, app/copilot-swe-agent) where tomthorogood is assigned or a requested reviewer. Exclude PRs authored by other human users.

Use all three searches per repo and deduplicate by PR number:

1. `gh api "search/issues?q=is:open+is:pr+repo:REPO+author:tomthorogood"`
2. `gh api "search/issues?q=is:open+is:pr+repo:REPO+tomthorogood"` (catches bot-authored PRs referencing the username)
3. `gh api "search/issues?q=is:open+is:pr+repo:REPO+assignee:tomthorogood"`

Never use `gh pr list --author` — it returns empty results for some repos due to auth quirks. Use `gh api` only.

## Fetching Check Status

```
gh pr view PR_NUMBER -R REPO --json number,url,headRefName,statusCheckRollup,reviewDecision,reviews
```

Never infer branch names from PR titles. Always use the `headRefName` value from the API.

A PR is **failing** if any check has `state` or `conclusion` equal to: `FAILURE`, `ERROR`, `failure`, `cancelled`, `timed_out`.
