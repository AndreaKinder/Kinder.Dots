---
name: logseq-gtd-contexts
description: Implement and use GTD contexts in a Logseq file graph. Choose between dedicated context pages or context properties, with query patterns to filter tasks by context.
---

# Logseq GTD Contexts (File Graph)

This skill helps you use **GTD contexts** (e.g., `@computer`, `@phone`, `@home`) in a Logseq **file graph** (Markdown-based).

## Assumptions

- Graph type: **file graph** (not DB graph).
- Tasks use markers: `TODO` → `DOING` → `DONE`.
- Queries use simple syntax: `{{query ...}}`.

## When to Use

Use this skill when the user asks for:

- “GTD contexts”
- “setup contexts”
- “how to organize by contexts”
- “filter tasks by context”
- “create @computer @phone pages”

## Core Concept

In GTD, **contexts** represent the environment or tools needed to complete a task.

Common examples:

- `@computer` - needs laptop/desktop
- `@phone` - needs phone
- `@home` - needs to be at home
- `@errands` - needs to go out (shopping, appointments)
- `@office` - needs office environment

## Implementation in File Graph

You have two main patterns:

### Pattern 1: Dedicated context pages

Create a page for each context, e.g.:

- `[[@computer]]`
- `[[@phone]]`
- `[[@home]]`
- `[[@errands]]`

Tag tasks with context references:

```text
- TODO Write project proposal
	- context:: [[@computer]]
	- area:: [[Work]]

- TODO Call Alice
	- context:: [[@phone]]

- TODO Buy groceries
	- context:: [[@errands]]
```

**Pros**: Context pages are queryable and make context discovery easy.  
**Cons**: Need to navigate between pages.

### Pattern 2: Context properties

Keep tasks on project pages or in your daily workflow, and add a `context:: [[@computer]]` property.

```text
- TODO Write project proposal
	- context:: [[@computer]]

- TODO Call Alice
	- context:: [[@phone]]
```

**Pros**: Tasks stay near related work.  
**Cons**: No dedicated page makes it harder to see all contexts at once.

## Query Patterns by Context

### Dedicated context pages (Pattern 1)

If you use pages like `[[@computer]]`:

```text
- All @computer tasks
	- {{query [[@computer]]}}

- In progress, @computer
	- {{query (and [[@computer]] (task doing))}}

- TODO, @computer
	- {{query (and [[@computer]] (task todo))}}
```

### Context property (Pattern 2)

If you use `context:: [[@computer]]` properties, queries get more involved. Simpler: use dedicated context pages.

If you must query by context property, use `#` prefix:

```text
- Tasks with computer context
	- {{query #computer}}
```

**Note**: This matches blocks containing the text `@computer`, which is less selective than a page reference approach.

## Context List Template (Paste-ready)

Create a page like `[[Contexts]]` as your context hub:

```text
- Contexts
	- [[@computer]]
	- [[@phone]]
	- [[@home]]
	- [[@errands]]
```

## Common Workflows

### Daily workflow with contexts

When planning your day:

1. Review your contexts and choose where you will be.
2. Filter tasks in your dashboard or project pages by context:
   - If you’re at a computer, pull up `[[@computer]]` page
   - If you’re running errands, pull up `[[@errands]]` page
3. Tag new tasks with the appropriate context.

### Weekly review and contexts

During weekly review, review whether your contexts still make sense:

- Are you using all of them regularly?
- Should you add or retire any contexts?
- Do any tasks lack a clear context?

## Quality Checklist

When implementing or querying contexts:

- [ ] Tasks use file-graph markers (`TODO`/`DOING`/`DONE`)
- [ ] Queries use `{{query ...}}` syntax
- [ ] Avoid DB-graph concepts (`#Task` classes, `Status` property tasks)
- [ ] Choose one pattern (dedicated pages OR context properties) and stay consistent
- [ ] Provide paste-ready templates
