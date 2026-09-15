---
name: logseq-weekly-review
description: A repeatable weekly review workflow for Logseq file graphs (Markdown). Uses a dedicated [[inbox]] capture page and produces paste-ready review templates with simple {{query ...}} blocks.
---

# Logseq Weekly Review (File Graph)

This skill helps a user run a **weekly review** in a Logseq **file graph** (Markdown-based). It is designed to work with a dedicated capture page: `[[inbox]]`.

## Assumptions

- Graph type: **file graph** (not DB graph).
- Inbox convention: captured, unprocessed items end with `#inbox` and include metadata child blocks like `captured-at::` and `source::`.
- Tasks use workflow markers: `TODO/DOING/DONE`.

## When to Use

Use this skill when the user asks for:

- “weekly review”
- “GTD weekly review”
- “clear my inbox”
- “review my tasks for the week”

## Output Contract

Return a **paste-ready outline** that the user can paste into a page (recommended: `[[Weekly Review]]` or a dated page like `[[Weekly Review 2026-W02]]`).

- Use bullet blocks only.
- Include actionable checklists.
- Prefer **simple queries** (`{{query ...}}`) so it works out-of-the-box.

## Weekly Review Template (Paste-ready)

Copy/paste this into your weekly review page:

```text
- Weekly Review: YYYY-WW
	- review-date:: [[Today]]
	- week-of:: [[YYYY-MM-DD]]
	- focus::
		- 

	- 1) Get to empty: [[inbox]]
		- Rule: every item gets ONE outcome (trash / do-now / next action / project / waiting / schedule / someday)
		- Unprocessed inbox items
			- {{query [[inbox]]}}
		- Triage checklist
			- Trash: delete duplicates and irrelevant items
			- Do now: finish any 2-minute items and mark DONE
			- Clarify: rewrite vague notes into a clear next action
			- Next action: convert to TODO and move to the right page (project/context)
			- Project: if multi-step, create/identify a project page and add at least one TODO under it
			- Waiting: use WAIT/WAITING and move to [[Waiting For]] (or a person/project page)
			- Schedule: add SCHEDULED/DEADLINE via /Scheduled and /Deadline
			- Someday: move to [[Someday]] or a topic page

	- 2) Review current commitments
		- In progress
			- {{query (task doing)}}
		- Next actions (exclude inbox)
			- {{query (and (task todo) (not [[inbox]]))}}
		- Waiting for
			- {{query (task wait waiting)}}
		- High priority
			- {{query (and (task todo doing) (priority a))}}

	- 3) Review projects
		- Active projects (example convention)
			- {{query [[project]]}}
		- For each active project
			- Confirm definition of “done”
			- Ensure at least one next action exists
			- If blocked, convert next action to WAIT and record who/what you’re waiting for

	- 4) Review calendar + journals (last 7 days)
		- Scan journal pages for open loops
			- {{query (between -7d today)}}
		- Capture follow-ups you missed into [[inbox]]

	- 5) Plan the next week
		- Pick 1–3 outcomes (not tasks)
			- 
			- 
			- 
		- Choose 3–10 next actions to pull forward
			- {{query (and (task todo) (priority a b))}}

	- Notes
		- Wins
			- 
		- Lessons
			- 
		- Risks
			- 
```

## Guidance and Conventions

### Inbox definition

- Only unprocessed items should keep `#inbox`.
- As soon as an item is processed and moved to its home, remove `#inbox`.

### Project tagging (optional but recommended)

If you want the “Active projects” query to work, adopt one lightweight convention:

- Tag a project page with `#project` (or add `type:: [[project]]` on the project page).

Then:

- `{{query [[project]]}}` finds project-related blocks/pages that reference `[[project]]`.
- For finer control, prefer a `type:: [[project]]` page property and query for it.

### Task markers

This template assumes `TODO` → `DOING` → `DONE`.

## Quality Checklist

Before returning a weekly review template:

- [ ] Assumes file graph syntax (markers + `{{query ...}}`)
- [ ] Includes an explicit “empty [[inbox]]” step
- [ ] Uses lowercase task keywords in queries (e.g., `todo`, `doing`) for consistency
- [ ] Produces a single paste-ready outline
