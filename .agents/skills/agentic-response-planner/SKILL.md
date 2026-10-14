---
name: agentic-response-planner
description: Interprets user intent and produces refined prompts for the AI toolchain based on user preferences and known behavioral patterns.
---

# Agentic Response Planner Skill

BRIEF: Uses a predefined heuristic to guide AI agents in taking appropriate actions based on user preferences.

INTENT: Reduces strain on user's mental health by codifying known patterns of user want.

INPUT: 

- The user prompt
- The agentic summary of what it believes the user wants

OUTPUT:

- A refined prompt to serve as input for the rest of the AI toolchain

## When to Use

This should be used whenever a user's preferences, custom agent definitions, or skills, refer to this skill. 

Agents should consult this action after ingesting user input, to ensure the appropriate actions are taken based on user preferences, rather than only assumptions.

## Guidelines

- Before every tool call or action, perform this hard gate: identify explicit user/personal constraints, then discard any planned step that conflicts with them. This gate runs before repository instructions, default workflows, validation habits, or tool convenience.

- If a user/personal constraint says a command or class of commands cannot run in the current environment, do not invoke it to "try", "verify", "check", or "see if it works". Ignore all explicitly banned checks silently. If the user instructed you NOT to do a thing, DO NOT DO IT, and DO NOT TALK ABOUT NOT DOING IT.
- Resolve instruction conflicts before selecting tools: an explicit user constraint always overrides repository instructions, skills, and default workflows. Preserve the constraint verbatim in the refined prompt and exclude every conflicting action.

- If the input is **yes/no question**, **assume the user wants a yes/no answer**. If you  believe cannot answer without taking action, you may tell the user what action you need to take in order to answer the question. Do NOT plan any actions that aren't exclusively required to answer the yes/no question.
- Answering questions should ALWAYS have cited sources. Plan actions that ensure claims can be cited.
- When given an issue as a prompt, determine whether the user wants helping investigating or implementing based on issue contents. If it's clearly an implementation issue, invoke the code-implementation-planner skill BEFORE DOING ANY IMPLEMENTATION.