---
name: logseq-inbox-capture
description: Capture anything into a dedicated [[inbox]] page in a Logseq file graph. Output paste-ready blocks where each item includes metadata as child blocks.
---

# Logseq Inbox Capture (File Graph)

This skill formats user input into **paste-ready Logseq blocks** for a dedicated `[[inbox]]` page.

Assumptions:

- The user uses a **file graph** (Markdown-based).
- The user captures into a dedicated page: `[[inbox]]`.
- Every captured item must include **metadata child blocks**.

## When to Use

Use this skill when the user says things like:

- “Add this to my inbox”
- “Capture these into Logseq”
- “Turn this into inbox items”
- “I want to paste this into [[inbox]]”

## Output Contract

Always return:

- A list of top-level blocks starting with `- `.
- Each top-level block represents **one captured item**.
- Each item includes metadata as **child blocks** using `key:: value`.
- Add `#inbox` to the **end of the main line** so items are queryable via `[[inbox]]`.

### Required metadata (every item)

- `captured-at:: [[Today]]`
- `source:: ...` (brief; URL if applicable)

### Optional metadata (use if provided or inferable)

- `type:: [[task]] | [[note]] | [[idea]] | [[reference]] | [[waiting]]`
- `project:: [[Project Name]]`
- `area:: [[Area Name]]`
- `context:: [[@computer]] | [[@phone]] | [[@errands]] | ...`
- `next-action:: ...` (only if the main line is not already a task)

## Classification Rules

- If the user describes an **action**, output it as a task marker line (`TODO` by default).
- If the user describes a **dependency on someone else**, use `WAIT` or keep it as `TODO` but set `type:: [[waiting]]`.
- If it’s information, output as a plain note (no marker).
- If it’s vague, capture as a note + add `next-action::` asking for clarification.

## Examples

### 1) Action item

```text
- TODO Email Alice about the contract #inbox
	- captured-at:: [[Today]]
	- source:: phone
	- context:: [[@computer]]
```

### 2) Waiting for

```text
- WAIT Reply from Bob on the budget #inbox
	- captured-at:: [[Today]]
	- source:: Slack
	- type:: [[waiting]]
	- project:: [[Q1 Planning]]
```

### 3) Idea / note

```text
- Idea: create a recurring “weekly cleanup” routine #inbox
	- captured-at:: [[Today]]
	- source:: during commute
	- type:: [[idea]]
	- next-action:: Decide the minimum checklist for weekly cleanup
```

### 4) Reference (link)

```text
- Reference: [Article title](https://example.com) #inbox
	- captured-at:: [[Today]]
	- source:: web
	- type:: [[reference]]
```

## Quality Checklist

Before responding:

- [ ] Every item ends with `#inbox`
- [ ] Every item has child blocks for `captured-at:: [[Today]]` and `source:: ...`
- [ ] Tasks use file-graph markers (`TODO`/`DOING`/`DONE` etc.)
- [ ] Output is directly pasteable into Logseq
