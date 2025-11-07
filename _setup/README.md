# `_setup/README.md`

This folder contains the framework bootstrap specification. The file `generate_framework_prompt.md` defines the architecture, scripts, prompt composition, provenance rules, validator requirements, and the web artifact explorer. This README summarizes purpose, usage, and maintenance.

## Purpose of `generate_framework_prompt.md`

This file is the central framework blueprint. It covers:

- Goal: Markdown-first knowledge graph + ACE (Agentic Context Engineering) for product development
- Directory and artifact structure (config, index, status, prompts, templates, ingestion, reflections, skills/tools)
- Script behavior (creation, index/status sync, prompt rendering, provenance injection & validation, drift/audit)
- Prompt composition including agent addendum and optional model addendum
- Provenance contract (created_by, generated_with incl. prompt_hash, citations, content_hash for sources)
- Web explorer specification (single-file HTML + Vanilla JS)

This specification is a reference; it is not meant to be pasted wholesale as a working prompt except when bootstrapping or evolving the framework itself.

## Core domains & artifact types

Configurable types (epic, feature, story, task, adr, reflection, review, source, summary, …) with YAML frontmatter: `id`, `type`, `title`, `status`, timestamps, and optional relations (`parent`, `derived_from`, `context_sources`).

## Prompt composition

Render order:

1. Central task prompt (canonical)
2. Agent addendum (concise bullets, no duplicates)
3. Optional model addendum (if enabled by the constraints matrix)
4. Config/index excerpts and optional context snippets

Conflicts are resolved in favor of the central prompt; addenda should only extend, not contradict.

## Provenance & integrity

Automatic injection by framework scripts:

- `created_by.agent` / `created_by.model` / version
- `generated_with.tool`, `prompt_ref`, `prompt_hash` (sha256 over normalized content)
- Merge `context_sources` & `derived_from` (append-only, do not overwrite)
- For `source`: `content_hash`, retrieval metadata (headers), optional snapshot (subject to license)
- Structured `citations` for `summary`, `adr`, `reflection` (quote + hash + locator)

The standalone validator checks presence, shapes, hash consistency, and addendum rules (model enabled vs. disabled).

## Web artifact explorer

Single file: `docs/explorer.html` reads `docs/_graph/graph.json` and `docs/_graph/index.json`.

Features:

- Universal search (tokenized) across key fields
- Facets: type, status, tags, milestone, owner, date ranges
- Views: list (sort/group) and graph (force/radial, pan/zoom, neighborhood), HATEOAS-style navigation (parent, children, derived, citations, links)
- Accessibility (semantic HTML, ARIA, focus states) and safe text handling (sanitize, no eval)
- Works via `file://` and GitHub Pages (`base_url`)

## Script landscape (planned core commands)

Examples (names may vary — see the blueprint):

- `new`: create artifact from template
- `index`: refresh graph/index
- `status`: aggregate metrics
- `sync`: `index` + `status` in one step
- `reflect`: generate ACE reflection
- `prompt`: render a task prompt with addenda
- `prompt-install`: export and optionally copy to clipboard
- `validate-provenance`: PASS/FAIL with optional JSON
- `audit`: drift, health checks, improvements

## Constraints matrix

JSON template defines agent- and model-specific limits:

- Model addendum enablement (`enabled`)
- Order (always after agent addendum)
- Max bullets, de-duplication and conflict policies

Changes here affect rendering and validator rules immediately.

## Maintenance workflow

1. Plan the change (small, atomic; new sections or rules)
2. Update `generate_framework_prompt.md` and bump `updated`
3. Adjust scripts/prompts → run the smoke-test checklist
4. Run validator & audit (document results)
5. Append CHANGELOG entry (externally visible changes)
6. Repository-wide ACE reflection for larger shifts (drift/backlog)

## Smoke tests (at a glance)

- Create artifacts (epic/feature/story) → index/status updated
- Source + summary with citations & hash → validator PASS
- Prompt rendering order correct incl. optional model addendum
- Explorer loads and supports search/graph navigation
- Reflection with ACE phases and curator handover
- Skill + tool registered → injected into a prompt
- Audit produces an improvement backlog

See the blueprint for the full checklist.

## Quick start (conceptual)

```bash
# Create a new artifact (example)
./bin/aiman new --type epic --title "Core API" --tags core --milestone M1

# Sync (index + status + graph)
./bin/aiman sync

# Render a prompt (agent + optional model)
./bin/aiman prompt --task implementation --agent copilot --model gpt-4o --context <ID1>,<ID2>

# Validate provenance
./scripts/validate-provenance.sh --strict --json

# Open the explorer locally
open docs/explorer.html
```

Note: names/flags may vary slightly once implemented — the blueprint’s semantics take precedence.

## FAQ

**Why a central blueprint file?**  
To enforce consistency and avoid silent drift; it’s the single source of truth for agents/scripts.

**How is prompt drift detected?**  
The `audit` script compares central prompts vs. addenda; differences become backlog items.

**What if required information is missing?**  
Follow the clarification policy: create a clarification task/story first, then proceed.

**When should a model addendum be omitted?**  
When the constraints matrix has `enabled=false` or the model isn’t listed.

## Quality principles

- Progressive disclosure (small steps, reference-first)
- Minimal, verifiable provenance
- Reproducible hashes / normalization
- No fulltext storage of external sources (copyright)
- Deterministic PASS/FAIL validation

## Next steps

- Implement missing scripts per blueprint
- Seed templates (vision, specification, etc.)
- Optional CI hooks for validator/audit
- Iteratively optimize explorer (performance at >500 artifacts)

---
When updating this README, also update the date in `generate_framework_prompt.md` if the interpretation of the framework changes.
