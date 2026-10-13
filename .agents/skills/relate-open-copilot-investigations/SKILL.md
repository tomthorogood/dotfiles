---
name: relate-open-copilot-investigations
description: Finds recently active open GitHub Copilot sessions whose contents match supplied references.
---

# Skill: Relate Open Copilot Investigations

Find an optional open GitHub Copilot session for each supplied reference request.

## Inputs

- One or more reference requests, each containing the references to find.
- Optional context for each request to disambiguate its references.
- The current time.

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

A session matches a request only when its references or conversation content identifies a supplied reference, using the request's context when needed to disambiguate it. Do not accept ambiguous matches.

When multiple sessions match a request, use the one with the most recent activity. Return:

```markdown
[copilot session](ghapp://sessions/SESSION_ID)
```

Use the exact `app_url` returned by `list_sessions_and_chats`; do not construct the URL. Return no value for a request when no session matches.
