# PR Status Report Skill

Guidelines for fetching and reporting open PR status for tomthorogood across GitHub org repos.

## Format

Every PR status entry must follow this exact format:

[#PR\_NUMBER](link) - repo-name - #PR\_NUMBER - branch-name - STATUS

Present results as a markdown table:

| Title | Repo | PR # | Branch | CI | Approvals | Notes

The formats of each column should be restricted to:

- **Title**: The first 80 characters of the PR title.
- **Repo**: Formatted as `owner/repo`
- **PR#**: Formatted as a link to the PR: `[#1234](https://github.com/owner/repo/pull/1234)`
- **Branch**: A code snippet in backticks: \`\` `branch-name` \`\`
- **CI**: Exactly ONE of the following options per PR.
    - When all checks passing: 🌈
    - When any checks in progress: 🏃‍♂️
    - When required checks failed: 😭
    - When other checks failed: 🤷‍♂️
- **Approvals**: Include ALL APPROPRIATE options:
    - When @copilot has approved the PR: 🤖
    - When a human user has approved the PR: ⛵
    - When there are unresolved comments: 🗣️
    - When PR is still in draft mode: 🫥
- **Tags**: Include ALL APPROPRIATE options:
    - When a PR is > 1 week old: 🍞
    - When user indicates it is blocked, or it is mentioned in the related issue (when present) or the PR comments/description, or labels: 🤲
    - When it cannot be merged into its base branch due to a merge conflict: 🥊


## Repos to Check

Always check these repos unless the user specifies otherwise:

- `github/github`
- `github/backup-utils-private`
- `github/enterprise2`
- `github/elasticsearch`
- `github/datadog-monitoring`
- `github/vulcan-go`
- `github/vulcan-daemon`
- `github/puppet`
- `github/terraform-github-search`
- Any repo associated with any sessions visible to the current agentic surface.

## Finding PRs

Use all of these searches — do not rely on only one:

1. `gh api "search/issues?q=is:open+is:pr+repo:REPO+author:tomthorogood"`
2. `gh api "search/issues?q=is:open+is:pr+repo:REPO+tomthorogood"` (catches bot-authored PRs where username appears in title/body)
3. `gh api "search/issues?q=is:open+is:pr+repo:REPO+assignee:tomthorogood`

Deduplicate results by PR number+repository.

**Never** use `gh pr list --author` for `github/backup-utils-private` — it returns empty results due to an auth quirk. Use `gh api` only.

**Never** pull or clone `github/github` locally. Use `gh api` for all read access. All tests and edits must be performed in a VS Code Codespace. The user is aware of this, so do not remind them.

## Check Status

For each PR, fetch check status via:

```javascript
gh pr view PR_NUMBER -R REPO --json number,url,headRefName,statusCheckRollup
```

**Never infer or guess branch names from PR titles or descriptions.** Always use the `headRefName` value returned by the API.

A PR is **failing** if any check has `state` or `conclusion` equal to: `FAILURE`, `ERROR`, `failure`, `cancelled`, `timed_out`.

If there are no known required checks for a given repository, treat all checks as required.

## Output

Always write the report to a workspace file named `files/YYYY-MM-DD-daily-report.md` (e.g. `files/2026-07-01-daily-report.md`) and open it in an editor canvas. Do not just print the table in chat. Create a new file each day.

## Summary

When the user asks for a summary (of their day, their work, their PRs, etc.), include a **Todos** section listing all todos from the session database, grouped by status (in\_progress, pending, done, blocked). Use the `sql` tool to query them.

## Daily Task List

- Maintain a daily task list in `files/pr-report.md`, starting a new list each day.
- Keep the daily list updated as the user reports progress — move completed items to a **Done** section; remove sections when they become empty.
- Track ad-hoc completions (e.g. skill updates, instruction changes, issue filings) in the **Done** section even if there was no explicit TODO item, so the user has a complete history of the day's work.
