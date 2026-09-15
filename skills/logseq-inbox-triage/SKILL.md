---
name: logseq-inbox-triage
description: Help a user empty their [[inbox]] page in a Logseq file graph. Provide a repeatable triage flow, rewrite items into tasks/notes, and preserve metadata child blocks.
---

# Logseq Inbox Triage (File Graph)

This skill guides a user through **processing and emptying** a dedicated `[[inbox]]` page in a Logseq **file graph**.

It assumes captured items look like:

- A main bullet that ends with `#inbox`
- Child blocks containing metadata (`captured-at::`, `source::`, etc.)

## Goal

- `[[inbox]]` becomes close to empty (or only contains genuinely unprocessed items).
- Every remaining commitment has a clear home: a project page, a context list, a calendar/deadline, or a someday list.

## Triage Rules (Decision Tree)

Process items top-to-bottom. For each item, choose exactly one outcome.

### 0) Trash

If it is irrelevant, duplicate, or no longer useful:

- Delete it.

### 1) Do now (2-minute rule)

If it takes ~2 minutes or less:

- Do it immediately.
- Mark the block `DONE` (or delete it) and keep a brief completion note if useful.

### 2) Clarify

If the item is vague (no clear action):

- Rewrite the main line into a clear next action, or
- Add a child block `next-action:: ...` and leave the main line as a note.

### 3) Next action (single-step)

If it is actionable and not blocked:

- Convert the main line to a task marker (`TODO` is the default).
- Add context/project metadata if known.
- Move the block out of `[[inbox]]` into the appropriate page:
  - `[[Projects/<name>]]` for project-related work
  - `[[@phone]]`, `[[@computer]]`, `[[@errands]]` (or your context pages)
  - a dedicated list page like `[[Next Actions]]`

Important:

- Remove `#inbox` from the main line after moving.

### 4) Project

If it requires multiple steps:

- Create/identify a project page.
- Move the item there as the project header or first note.
- Add at least one child task under it as a concrete next action.
- Remove `#inbox`.

### 5) Waiting for

If someone else must act first:

- Use `WAIT` / `WAITING` marker (or keep `TODO` but add waiting metadata).
- Add `waiting-for:: [[Person]]` if known.
- Move to `[[Waiting For]]` or a person/project page.
- Remove `#inbox`.

### 6) Schedule / Deadline

If it must happen on/after a specific date:

- Keep it as a task (`TODO`).
- Add Logseq’s scheduling syntax via `/Scheduled` or `/Deadline`.
- Optionally add context/project.
- Move it to the relevant project page.
- Remove `#inbox`.

### 7) Someday / Reference

If it is not actionable now:

- Move it to `[[Someday]]` or a topic page.
- Keep it as a note (no task marker) unless you intentionally want it tracked.
- Remove `#inbox`.

## Rewrite Guidelines

### Preserve metadata child blocks

Keep:

- `captured-at:: [[Today]]` (or the captured date)
- `source:: ...`

Add when useful:

- `project:: [[...]]`
- `area:: [[...]]`
- `context:: [[...]]`
- `waiting-for:: [[...]]`

### Remove inbox marker when processed

- Only unprocessed items should still end with `#inbox`.
- Everything processed should have `#inbox` removed.

## Examples

### Convert to next action

Before:

```text
- Email Alice #inbox
	- captured-at:: [[Today]]
	- source:: phone
```

After (moved to a project page or Next Actions page):

```text
- TODO Email Alice about contract terms
	- captured-at:: [[Today]]
	- source:: phone
	- context:: [[@computer]]
```

### Convert to project

```text
- Project: Plan Q1 offsite
	- captured-at:: [[Today]]
	- source:: meeting
	- TODO Draft agenda
		- context:: [[@computer]]
	- TODO Confirm attendees
		- context:: [[@phone]]
```

## Quality Checklist

- [ ] Every unprocessed item still ends with `#inbox`
- [ ] Every processed item has `#inbox` removed
- [ ] Tasks use file-graph markers (`TODO`/`DOING`/`DONE`/`WAIT`/...)
- [ ] Metadata child blocks are preserved
- [ ] Projects have at least one explicit next action
