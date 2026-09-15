---
name: logseq-file-graph-knowledge
description: Canonical guidance for Logseq file graphs (Markdown). Use this skill to avoid DB-graph assumptions. Covers tasks (markers), properties (key:: value), and query syntax ({{query ...}} and advanced queries).
---

# Logseq File Graph Knowledge

This skill is the “ground truth” for working with **Logseq file graphs** (the classic graph type backed by Markdown files).

Many assistants confuse Logseq DB graphs with file graphs. When the user is in a **file graph**, use these rules.

## Scope

- Graph type: file-based (Markdown files)
- Primary use case: everyday note-taking, tasks, GTD, dashboards

## Tasks (File Graph)

### Task markers

In file graphs, tasks are ordinary blocks prefixed with a marker keyword.

Common marker sequences:

- `LATER` → `NOW` → `DONE`
- `TODO` → `DOING` → `DONE`

Additional markers that may appear:

- `WAIT` / `WAITING`
- `IN-PROGRESS`
- `CANCELED` / `CANCELLED`

### Creating and cycling markers

- Users can type the marker at the start of the block (e.g., `TODO call Alice`).
- Users can also use the editor command (e.g., `/TODO`).
- Users can cycle markers with `Ctrl/Cmd+Enter`.

### Priority

File graph tasks support priorities:

- `[#A]` (highest), `[#B]`, `[#C]` (lowest)

Example:

```text
- TODO [#A] Finish weekly review
```

### Scheduling and deadlines

In file graphs, scheduling is typically expressed via Logseq’s built-in `SCHEDULED:` and `DEADLINE:` syntax (inserted via `/Scheduled` and `/Deadline`).

Example:

```text
- TODO Submit form
  DEADLINE: <2026-01-10 Sat>
```

## Properties (File Graph)

### Block properties

Block properties are written as:

```text
key:: value
```

Properties can appear:

- in the same block (inline), or
- in a child block (common for metadata)

### Property naming rules (important)

- Property names are **case-insensitive** and normalized to lowercase.
- Property names with `_` are normalized to `-` (e.g., `done_at` becomes `done-at`).
- Property values cannot contain newlines.

### Values

Property values can include:

- plain text
- page references like `[[Project X]]`
- tags like `#inbox`
- links

To force a value to be treated as plain text (no page refs), wrap it in quotes:

```text
source:: "[[Not a page]]"
```

## Queries (File Graph)

Logseq supports two common query styles.

### Simple query blocks

Use:

```text
{{query ...}}
```

Examples:

```text
{{query (task todo)}}
{{query (and (task todo doing) [[Project X]])}}
{{query (and (task todo) (priority a))}}
{{query (and [[inbox]] (task todo doing))}}
{{query (and (task todo) (not [[inbox]]))}}
```

### Advanced queries

Use an advanced query block when simple query filters are not enough.

General shape:

```text
#+BEGIN_QUERY
{:title "My query"
 :query [:find (pull ?b [*])
        :where
        ...]}
#+END_QUERY
```

## Safe defaults for user-facing workflows

When you are building workflows for file graphs:

- Use markers (`TODO`/`DOING`/`DONE`) for tasks.
- Use child blocks with `key:: value` for metadata.
- Prefer simple `{{query ...}}` blocks for dashboards.
- Do not use DB-graph-only concepts like `#Task` classes, `Status` property tasks, or `{:query ...}`-only conventions.
