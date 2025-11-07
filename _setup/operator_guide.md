# Operator’s Guide: Using the Bootstrap Prompt

This guide explains how to use `generate_framework_prompt.md` to iteratively build the Markdown-first product development framework. It focuses solely on operating the prompt – not on the final framework artifacts.

## 1. Purpose & Audience

- Audience: Human operator using Copilot / Claude / OpenAI / Goose.
- Goal: Generate the repository in small, verifiable increments while enforcing provenance, frontmatter discipline, and contract compliance.

## 2. Core Principles

- Progressive disclosure: small chunks, validate each before the next.
- No hallucinations: create clarification tasks if info missing; never invent facts.
- Frontmatter discipline: mandatory fields present; `updated` correct on changes.
- Provenance: every script-driven write injects `created_by` & `generated_with` (+ `prompt_hash` for rendered prompts).

## 3. Modes of Use

- Iterative (recommended): 3–6 focused prompt blocks at a time.
- Single-shot (fallback): only for regeneration after baseline validated.

## 4. Minimal 7-Step Workflow

1. Read bootstrap prompt; treat as canonical source.
2. Scaffold directories & minimal config.
3. Create Markdown templates for all artifact types.
4. Implement scripts progressively (new → index/status → reflect → prompt → installer → validator → audit/drift).
5. Add central prompts + agent/model addenda.
6. Implement explorer (`docs/explorer.html`) + graph/index JSON export.
7. Run smoke test end-to-end; record results.

## 5. Prompt Building Blocks (Copy/Paste)

Use these blocks in LLM chat. After each answer: apply, run locally, verify, then proceed.

Reference source: see the central Bootstrap Prompt at [./generate_framework_prompt.md](./generate_framework_prompt.md). Prefer referencing section titles (e.g., “Required components”, “Scripts to implement”) rather than pasting long excerpts.

### How to actually send these blocks to an LLM

The paragraph above is an operator instruction, not a prompt block to resend each time. Use it like this:

1. Session start (once): Provide a very short context preface (central spec path, key contracts: frontmatter fields, provenance fields, prompt order). Do NOT paste the entire bootstrap file.
2. Send exactly one block (A–G) per generation round inside a single fenced code block. Optionally add 1–2 clarifying lines ("add folder X", "limit lines").
3. After receiving output: apply changes locally, run quick validation (frontmatter parse / script syntax), commit.
4. Provide a brief context delta before the next block only if something materially changed (e.g., "templates created"), never re-dump prior outputs.
5. Re-send the reference line only if the model drifts (hallucinated fields, wrong order) or you start a fresh chat thread.
6. For provenance-sensitive actions (render prompts, create artifacts), explicitly remind: "ensure created_by + generated_with + prompt_hash" if the block’s purpose is generation.

Minimal session start example:

```text
Central spec: ./_setup/generate_framework_prompt.md
Key contracts: frontmatter(id,type,title,status,updated), provenance(created_by,generated_with.prompt_hash), prompt order central→agent→model.
Task: Scaffold. Provide mkdir + stub files only.
```

Follow-up block example with delta:

```text
Context delta: scaffold applied; proceed with Markdown templates.
<Insert Block B code fence here>
Add: keep each template ≤40 lines; empty arrays only.
```

When to pause: if a block would require unspecified details (e.g., acceptance criteria style), create a clarification artifact first.

### Block A — Scaffold

```text
You are a repository scaffolder. Using the “Required components” from the Bootstrap Prompt, output:
- mkdir commands and stub file paths (no external deps)
- minimal file contents (headings/frontmatter placeholders only)
Constraints: POSIX paths, no destructive actions, concise.
Return ONLY file diffs or minimal content blocks.
```

### Block B — Templates

```text
Create concise Markdown templates for: vision, specification, epic, feature, story, task, adr, reflection, review, source, summary, skill, tool, capability.
Each template:
- Starts with YAML frontmatter per contracts
- Includes placeholder sections (acceptance criteria, links, citations area)
Limit ~40 lines per template.
```

### Block C — Scripts (lib + new)

```text
Generate POSIX/BSD bash scripts:
- scripts/lib/id.sh (generate_id per ID policy)
- scripts/lib/frontmatter.sh (safe YAML frontmatter read/write; awk/sed portable)
- scripts/new.sh (--type/--title/--parent/--context/--from/--url; inject provenance)
Constraints: avoid GNU-only sed; robust minimal regex; include usage help.
Return code only.
```

### Block D — Index / Status / Graph

```text
Provide scripts:
- update-index.sh: scan markdown, produce docs/_graph/graph.json & docs/_graph/index.json + artifacts/index.md overview table
- update-status.sh: aggregate counts (type/status/milestone) → artifacts/status.md
- sync.sh: runs index + status
Follow graph & index data shapes.
```

### Block E — Prompt Rendering & Installer

```text
Create:
- render-prompt.sh: compose central → agent → model → excerpts (+ optional context); normalize; sha256 prompt_hash
- prompt-install.sh: export rendered prompt to agent target + optional macOS clipboard (pbcopy)
Enforce no duplicates; prefer central on conflicts.
```

### Block F — Validator / Audit / Drift

```text
Create:
- validate-provenance.sh [--json] [--strict] [--paths ...]
- audit.sh: frontmatter, links, citations, drift, orphan refs; outputs meta-reflection
- drift.sh: compare central prompts vs agent addenda; flag duplicates
Exit codes: 0=PASS, 1=FAIL.
```

### Block G — Explorer

```text
Create docs/explorer.html (single file, inline CSS/JS) reading docs/_graph/graph.json & docs/_graph/index.json.
Features: universal search, filters, list & graph views, pan/zoom, deep-linkable state.
No external dependencies.
```

## 6. Environment & Provenance

- ENV vars: AIMAN_AGENT, AIMAN_MODEL.
- Inject fields: created_by.agent/model/version; generated_with.tool/command/prompt_ref/prompt_hash.
- Merge arrays (`context_sources`, `derived_from`) on create/update.
- Normalization before hashing: trim trailing spaces; CRLF→LF; collapse blank lines; remove trailing newline.

## 7. Clarification Triggers

Create a clarification task if:

- Parent or linkage unclear
- Acceptance criteria missing
- Source trust/license unknown
- Model addendum policy ambiguous

## 8. Quality Gates per Chunk

- Build: scripts executable (no syntax errors)
- Lint: headings present; frontmatter parse
- Sync: index/status regenerate; explorer loads
- Validation: provenance & citations PASS (or fixed)

## 9. Quick 10-Min Dry Run

1. Block A scaffold
2. Block B templates
3. Block C scripts + create epic
4. Block D sync
5. Block E render prompt (reflection, copilot, gpt-4o)
6. Block G explorer
7. Block F validator (non-strict → strict)

## 10. Troubleshooting

| Issue | Action |
|-------|--------|
| Frontmatter corrupted | Recreate via template; use helper script |
| Missing prompt_hash | Ensure normalization + hashing step executes |
| Dead links | Run audit; create missing parent or fix ID |
| Duplicate prompt content | Run drift; prune agent/model addendum |

## 11. Checklist Before Moving to Next Phase

- Artifact(s) created & visible in index
- Status counts updated
- Provenance fields present
- No validation errors (strict) outstanding

## 12. Exit Criteria for This Guide

You can stop using this guide once:

- All core scripts exist
- Templates complete
- Explorer operational
- Validator passes strict mode
- Smoke test documented in overview

## 13. License & Safety Notes

- Do not store full external source texts; only minimal quotes + citations.
- Treat all user inputs as untrusted; sanitize before graph export.

## 14. Short Reference (One-Line Reminders)

Scaffold → Templates → Scripts → Sync → Prompts → Explorer → Validate → Audit → Improve.

---

Last updated: 2025-11-07
