---
name: logseq-dashboard-file-graph
description: Generate a paste-ready dashboard page for Logseq file graphs using simple {{query ...}} blocks. Includes sections for inbox, next actions, waiting-for, and priorities.
---

# Logseq Dashboard (File Graph)

This skill creates a **single-page working dashboard** for a Logseq **file graph** using simple query blocks.

It is designed to work especially well with the convention:

- Captured items end with `#inbox` (see `logseq-inbox-capture`).

## When to Use

Use when the user says:

- “Build me a Logseq dashboard”
- “Give me a GTD workbench page”
- “Create queries for tasks / next actions / waiting-for”

## Output Contract

Return a **paste-ready page outline** (bulleted blocks) that the user can paste into a page like `[[Dashboard]]`.

- Use nested bullets only.
- Use simple query blocks: `{{query ...}}`.
- Keep the page readable without plugins.

## Recommended Dashboard Template

Paste this into `[[Dashboard]]`:

```text
- Inbox (unprocessed)
	- {{query [[inbox]]}}

- In Progress
	- {{query (task doing)}}

- Next Actions (exclude inbox)
	- {{query (and (task todo) (not [[inbox]]))}}

- Waiting For
	- {{query (task wait waiting)}}

- High Priority
	- {{query (and (task todo doing) (priority a))}}

- By Context
	- @computer
		- {{query (and [[@computer]] (task todo doing))}}
	- @phone
		- {{query (and [[@phone]] (task todo doing))}}
	- @errands
		- {{query (and [[@errands]] (task todo doing))}}

- By Project (examples)
	- {{query (and [[Project X]] (task todo doing))}}
	- {{query (and [[Project Y]] (task todo doing))}}
```

## Notes and Customization

### 1) Make “Inbox (unprocessed)” stricter

If your graph has lots of references to `[[inbox]]`, prefer the stronger convention:

- Only unprocessed items keep `#inbox`.
- Processed items remove it (see `logseq-inbox-triage`).

### 2) Task markers

This dashboard assumes the user uses `TODO` → `DOING` → `DONE`.

If you use a different marker flavor, update the `(task ...)` filters accordingly.

### 3) Context pages

If the user doesn’t already have context pages like `[[@computer]]`, suggest creating them as regular pages and then tagging tasks with them.

## Quality Checklist

- [ ] Output is a bullet outline ready to paste into Logseq
- [ ] Queries use `{{query ...}}` (file graph friendly)
- [ ] Inbox queries assume `#inbox` convention
