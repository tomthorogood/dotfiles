---
name: relate-open-copilot-investigations
description: Finds recently active open GitHub Copilot sessions that reference issues or pull requests in a status report.
---

# Skill: Relate Open Copilot Investigations

Find an optional open GitHub Copilot session for each status-report row whose **Copilot Session** cell is empty.

## Inputs

- The report rows with empty **Copilot Session** cells.
- Each row's repository and linked issue or pull request.
- The current time.

Do not search for a row that already has a **Copilot Session** value.

## Time Window

Include open sessions with activity from the start of the last business day through the current time:

- On Monday, the window starts Friday at 00:00.
- On Tuesday through Friday, the window starts the previous calendar day at 00:00.
- On Saturday or Sunday, the window starts Friday at 00:00.

Friday, Saturday, and Sunday are one business day. Interpret boundaries in Pacific local time, using `America/Los_Angeles` so daylight saving time is applied correctly, then convert the boundaries to UTC for queries that require or prefer UTC.

## Finding Candidate Sessions

1. Call `list_sessions_and_chats` and retain only sessions returned by it; these are the open, unarchived sessions.
2. Use `session_store_sql` to retain sessions whose latest activity falls within the time window and inspect their `session_refs` and `turns`.
3. Correlate the session IDs from `session_store_sql` with the `app_url` values from `list_sessions_and_chats`.

Time-bound every `session_store_sql` query and filter by the candidate session IDs before searching message text.

## Matching

A session matches a row only when its references or conversation content identifies that row's issue or pull request in that repository. Accept a repository-qualified reference or a GitHub URL. Do not match a bare issue or pull-request number without repository identity because numbers can collide across repositories.

When multiple sessions match, use the one with the most recent activity. Return:

```markdown
[copilot session](ghapp://sessions/SESSION_ID)
```

Use the exact `app_url` returned by `list_sessions_and_chats`; do not construct the URL. Leave the cell empty when no session matches.
