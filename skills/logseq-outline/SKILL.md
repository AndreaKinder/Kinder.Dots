---
name: logseq-outline
description: Format any content as a Logseq-compatible outline using nested bullets only (no Markdown headers, no bold-for-emphasis). Designed for clean copy/paste into Logseq.
---

# Logseq Outline Formatting Skill

This skill teaches the assistant to turn any structured content into a Logseq-friendly outline.

Logseq supports Markdown (including headings and emphasis). However, when the goal is to paste content into Logseq as clean blocks with predictable hierarchy, nested bullets usually translate better than header-heavy formatting. This skill therefore produces a bullet-only outline and converts headings into outline levels.

## When to Use This Skill

Use this skill whenever the user wants content they can paste into Logseq with minimal cleanup:

- Research notes and summaries
- Reading lists
- Meeting notes
- Project plans and documentation outlines
- Any hierarchical list intended for Logseq blocks

**Common trigger phrases:**

- "Format this for Logseq"
- "Create a Logseq outline"
- "Make this Logseq-compatible"
- "Turn this into blocks / an outline"
- "I want to paste this into Logseq"

## Core Rules (Non-negotiable)

### 1) Hierarchy via nested bullets only

- Use `-` bullets at every level.
- Use indentation to show depth (tabs are usually best for copy/paste, but consistent spaces are OK too).
- Do not emit standalone Markdown header lines (`# ...`, `## ...`, `### ...`). If the input uses headers, convert them into bullet levels.

Example structure:

```text
- Top level
	- Second level
		- Third level
			- Fourth level
```

### 2) Plain text over visual emphasis

- Do not use bold (`**...**`) or italics (`*...*`) for emphasis.
- Prefer clear wording (e.g., prefixes like `Decision:` / `Owner:` / `Due:`) instead of styling.

```text
✗ Wrong:
- **Important**: Do the thing

✓ Right:
- Important: Do the thing
```

### 3) Links in standard Markdown link syntax

- Use `[label](url)`.
- Keep links inline with the bullet that references them.

```text
- Reference: [Paper title](https://example.com)
```

### 4) No decorative formatting

Avoid formatting that looks nice in Markdown but makes Logseq pasting noisy:

- No horizontal rules (`---`)
- No "Summary" section appended at the end
- No totals/counts ("Total: 18 items")
- No meta commentary about how you organized it

## Output Expectations

### Output format

- Produce a single outline.
- Keep sections as bullets; use deeper nesting for sub-sections.
- Keep phrasing concise and scannable.

### Depth guidance

- Prefer 2–4 levels of nesting for readability.
- If the input is very dense, group it into a few top-level buckets, then nest.

## Environment-specific Behavior

### Claude Desktop

- Return the formatted outline as a single Markdown artifact for easy copy/paste.

### Claude Code

- If file system access is available, save the outline to a `.md` file on the user Desktop and report the exact path.
- If file writes are not available, output the outline directly.

**Suggested filename pattern:** `Topic_Name_Outline.md`

**Pasting tip:** Logseq has both formatted paste and raw paste (often “paste” vs “paste as plain text”). If a user reports paste behaving unexpectedly, ask which paste mode they used.

## Common Templates

### Meeting notes

```text
- Meeting: YYYY-MM-DD - Topic
	- Attendees
		- Name
	- Agenda
		- Item
	- Discussion
		- Topic
			- Notes
			- Decision: ...
			- Owner: ...
	- Action Items
		- Action (Owner: ...)
			- Due: YYYY-MM-DD
```

### Research notes

```text
- Research Topic: ...
	- Background
		- Concept
			- Definition
			- Example
	- Key points
		- Point
			- Evidence
			- Source: [Title](https://example.com)
	- Open questions
		- Question
	- Next steps
		- Action
```

### Reading list

```text
- Reading List: ...
	- Must read
		- Title — Author (Year)
			- Why: ...
	- Recommended
		- Title — Author (Year)
	- Optional
		- Title — Author (Year)
```

## Conversion Guidance

### Convert Markdown headers into nested bullets

Input:

```markdown
# Main Topic
## Subtopic
Details
```

Output:

```text
- Main Topic
	- Subtopic
		- Details
```

### Remove bold-driven structure

Input:

```markdown
- **Section**
  - **Point:** Details
```

Output:

```text
- Section
	- Point: Details
```

## Quality Checklist

Before responding, verify:

- [ ] No Markdown headers (`#`, `##`, `###`) in the final output
- [ ] No bold/italics used for emphasis
- [ ] All hierarchy is expressed by nested bullets + indentation
- [ ] Links are `[label](url)`
- [ ] No decorative separators, summaries, or counts
