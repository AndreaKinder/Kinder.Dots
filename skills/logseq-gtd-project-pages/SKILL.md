---
name: logseq-gtd-project-pages
description: Create and manage GTD-style project pages in a Logseq file graph. Includes paste-ready project templates, query patterns to aggregate project tasks, and guidance to avoid DB-graph concepts.
---

# Logseq GTD Project Pages (File Graph)

This skill teaches how to create and maintain **project pages** in a Logseq **file graph** (Markdown-based).

## Assumptions

- Graph type: **file graph** (not DB graph).
- Tasks use markers: `TODO` → `DOING` → `DONE`.
- Properties use `key:: value` syntax.
- Queries use simple syntax: `{{query ...}}`.

## When to Use

Use this skill when the user asks for:

- “create a project page”
- “GTD project setup”
- “template for project”
- “how to organize projects in Logseq”
- “query tasks in a project”

## Core Concept

In GTD, a **project** is anything that requires more than one action.

In a file graph, common conventions:

- Use a dedicated page (e.g., `[[Project Name]]`).
- Put project metadata at the top of the page (optional).
- Add child blocks for:
  - Project definition / goal
  - Completion criteria
  - Next actions (tasks)
  - References / notes

## Project Page Template (Paste-ready)

Copy/paste this as a starting point for a new project page:

```text
- Project: Name
	- status:: active
	- project-start-date:: [[Today]]
	- type:: [[project]]
	
	- Goal
		- ...
	
	- Completion criteria
		- ...
	
	- Next actions
		- TODO First concrete next action
		- TODO Another next action
	
	- Notes / context
		- ...
```

## Adding Tasks to a Project

### Task syntax (file graph)

Use task markers and keep tasks as child blocks:

```text
- TODO Email Alice for requirements review
	- area:: [[Communications]]
	- context:: [[@computer]]
	
- TODO Prepare slides for demo
	- area:: [[Communications]]
	- context:: [[@computer]]
	
- DONE Schedule kick-off meeting
	- completed-at:: [[Today]]
```

### Using project references

To link a task to a project:

- Put tasks as child blocks under the project page.
- Optionally add `project:: [[Project Name]]` property on the task.
- Optionally use block references `((uuid))` if you need a reference a note from elsewhere.

## Query Patterns for Projects

### Find all tasks in a project

Assuming you use a project page `[[Project X]]`:

```text
{{query [[Project X]]}}
```

This finds all blocks that reference `[[Project X]]`, including:
- Child task blocks
- Notes under the project
- Block references to the project

### Filter project tasks by status

```text
- In progress
	- {{query (and [[Project X]] (task doing))}}

- Next actions
	- {{query (and [[Project X]] (task todo))}}

- Completed
	- {{query (and [[Project X]] (task done))}}
```

### Filter by priority

```text
- High priority
	- {{query (and [[Project X]] (task todo) (priority a))}}
```

### Combine project and context

If you use context pages like `[[@computer]]` and also tag tasks with them:

```text
- Computer tasks for Project X
	- {{query (and [[Project X]] [[@computer]] (task todo doing))}}
```

## Avoid DB-Graph Concepts

In a file graph, **do not** use DB-graph-specific concepts:

- ✗ Do not use `#Task` classes or `Status` property tasks.
- ✗ Do not use `{:query ...}` advanced queries unless you explicitly need them.
- ✗ Do not use `:logseq.property/...` namespaced properties.
- ✓ Use markers (`TODO`/`DOING`/`DONE`) for tasks.
- ✓ Use simple `{{query ...}}` blocks for dashboards.
- ✓ Use `key:: value` properties.

## Optional: Project Property Convention (for queries)

If you want to query by “project” without hardcoding page names, adopt a convention:

- Option 1: Use a `type:: [[project]]` property on the project page.
  - Then: `{{query (type project)}}` finds all projects.
- Option 2: Tag project pages with `#project`.
  - Then: `{{query [[project]]}}` finds all project-related content.

## Quality Checklist

When creating or updating project pages:

- [ ] Tasks use file-graph markers (`TODO`/`DOING`/`DONE`)
- [ ] Queries use `{{query ...}}` syntax
- [ ] At least one next action is explicitly defined (TODO)
- [ ] Completion criteria is clear (when is “done”?)
- [ ] Metadata uses `key:: value` properties
- [ ] No DB-graph-only concepts (`#Task` classes, `Status` property tasks, etc.)
