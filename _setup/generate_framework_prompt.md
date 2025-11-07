# Bootstrap Prompt: Generate a Markdown-First Product Development Framework (Knowledge Graph + ACE – Agentic Context Engineering)

You are an expert prompt engineer, software architect, and agile project manager. You deeply understand LLM quirks and enforce context efficiency, progressive disclosure, and strict provenance.

Default language: English (unless the user/project explicitly requests another language).

## Objective

Design and generate a complete, self-maintaining Markdown-first framework for product development that functions as a knowledge graph with a central entry point, including prompts, shell scripts, templates, and initial docs. Use ACE (Agentic Context Engineering) for reflections and decision support.

## High-level deliverables

- Repository scaffold with clear folder structure and minimal working content
- YAML-frontmatter–based knowledge graph (IDs, links, statuses) with auto-generated index and status
- Prompts (central/canonical) + agent-specific addenda and installer
- Shell scripts for entity generation, index/status sync, ACE reflection, prompt rendering/export
- Templates for all artifact types (vision, specification, epics/features/stories/tasks, ADR, reflections, reviews, knowledge ingestion: source/summary)
- ACE (Agentic Context Engineering) reflections with roles (Generator/Reflector/Curator) across all levels
- Knowledge ingestion pipeline (sources + multi-level summaries) with full provenance
- Spec-as-source alignment and documentation of best practices
- Model awareness (detection/injection of constraints) and safeguards for context-window efficiency
- A skills registry (role-aligned capabilities), tool contracts, and optional MCP capability descriptors
- A reusable prompt template aligned with current best practices
- A smoke-test checklist to validate the generated framework end-to-end
- Continuous reflection and self-improvement across the initial output and all subsequent changes, including repository-wide audits and drift detection
- Single-file web artifact explorer (HTML + Vanilla JS) with universal search/filter, list and graph views, and HATEOAS-style navigation across references

## Constraints & guardrails

- Never invent facts. If required info is missing, ask or create a clarification artifact and pause risky execution.
- Respect YAML frontmatter and keep `updated` accurate on each change. Allowed types/statuses must be defined centrally (choose the name and location of this config sensibly).
- Link artifacts via IDs and relative paths (knowledge graph). No absolute paths.
- Copyright: do not copy full external texts; use minimal quotes with precise citations.
- Progressive disclosure: small, testable steps; avoid long outputs; prefer references and summaries.

## Required components (no fixed names or paths)

Design an appropriate, clean directory structure that contains at least these components (choose sensible names and paths):

- A human-readable project overview and change log
- A central configuration for allowed types and statuses
- A set of shell scripts to: create artifacts, update the index/graph, aggregate status, create reflections, render/export prompts
- A thin CLI entry-point that exposes common commands (new, index, status, reflect, sync, prompt, prompt-install)
- A central index document (overview tables) and a status document (aggregated metrics)
- A machine-readable knowledge-graph export (e.g., TSV/JSON) updated automatically
- Product area (vision, specification)
- Work area (epics, features, stories, tasks) with milestones support
- Architecture area (ADRs)
- Reflections area (ACE – Agentic Context Engineering)
- Knowledge ingestion areas (original sources and derived summaries)
- Reviews area (Curator decisions)
- Prompt area (global guardrails + task prompts + agent addenda)
- Templates area (for all artifact types)
- A registry for skills (role-aligned capabilities), tool contracts, and optional MCP capability descriptors
- A single-file artifact explorer (served from docs/, no external dependencies) that reads the machine-readable graph/index

## Knowledge graph contract (frontmatter)

All artifacts begin with YAML frontmatter:

```yaml
---
id: 20251107-120000-xyz
type: story
title: "..."
status: draft
owner: ""
parent: ""        # parent artifact ID if any
milestone: "M1"
tags: [core]
created: 2025-11-07
updated: 2025-11-07
---
```

- Mandatory: id, type, title, status
- Recommended: tags, parent, milestone
- Keep `updated` accurate; link via IDs/relative paths.

## Provenance contract (minimum viable)

All created or updated artifacts must record provenance to ensure traceability and auditability.

Frontmatter fields (fill where applicable; keep minimal but consistent):

```yaml
# provenance fields (conditional by type)
context_sources: []     # IDs or URLs consulted during creation/update
derived_from: []        # IDs or URLs the artifact is directly derived from
created_by:             # optional: captured automatically by scripts when possible
   agent: ""            # e.g., copilot/claude/openai/goose/manual
   model: ""            # model identifier if known
   version: ""          # agent or tool version
generated_with:         # optional: captured automatically by scripts when possible
   tool: ""             # e.g., aiman-cli, script name
   command: ""          # short command summary (no secrets)
   prompt_ref: ""       # optional: path/ID of the prompt used for generation
   prompt_hash: ""      # optional: stable hash of the rendered prompt (e.g., sha256)

# optional structured citations (recommended for summaries/ADRs/reflections)
citations:
   - id: ""             # internal artifact ID (preferred) or external URL
      locator: ""        # section/paragraph/line selector (e.g., heading slug, anchor)
      quote: ""          # short quote (minimal necessary excerpt)
      quote_hash: ""     # optional hash of normalized quote text
      accessed: ""       # ISO date when accessed (for web)
      license: ""        # optional license note if relevant
```

Section-level structure when citing evidence (preferred in content, not frontmatter):

- A dedicated "Evidenz & Zitate" block with short quotes and precise citations (ID/URL + section/selector)
- Do not paste fulltexts; use minimal quotes and exact references

### Provenance automation (CLI & renderer)

Implement automatic provenance injection across the CLI and render/export paths. Behavior and contract:

- On any create/update action performed by framework scripts (new, reflect, prompt render/export, code change helpers):
  - Set `created_by` if missing and always update `generated_with`.
  - `created_by.agent`: detected from environment (prefer `AIMAN_AGENT`, fallback to `copilot|claude|openai|goose|manual`).
  - `created_by.model`: from `AIMAN_MODEL` or renderer metadata if available; else empty string.
  - `created_by.version`: script/agent version if known; else empty string.
  - `generated_with.tool`: the invoking tool name (e.g., `aiman-cli`, script filename).
  - `generated_with.command`: sanitized command summary (no secrets), e.g., `new --type story --title ...`.
  - `generated_with.prompt_ref`: path/ID of the prompt used when rendering (central + agent addendum); empty when not applicable.
  - `generated_with.prompt_hash`: SHA-256 of the fully rendered prompt after normalization.
  - Merge (do not overwrite) arrays: `context_sources` and `derived_from` when flags `--context` / `--from` are provided.
  - Always refresh `updated` (UTC date) on write.

Normalization and hashing:

- Normalize before hashing: trim trailing spaces, convert CRLF to LF, collapse multiple blank lines to single, and remove trailing newline at EOF.
- macOS/BSD compatible hashing: prefer `shasum -a 256`; fallback to `openssl dgst -sha256 | awk '{print $2}'`.
- Store the lowercase hex digest in `generated_with.prompt_hash`.

CLI flags (override/controls):

- `--agent <name>` / `--model <id>` / `--version <v>` / `--prompt-ref <path|id>` / `--context <id|url>[, ...]` / `--from <id|url>[, ...]`.
- `--no-provenance` to skip injection (discouraged; logs a warning and is ignored in `--strict` mode).

Success criteria:

- New artifacts created via CLI contain `created_by` and `generated_with` fields.
- Rendered prompts written to artifacts carry a stable `prompt_hash`.
- Manual edits are preserved; automation only appends/merges without destructive changes.

### Citations (structured) – enforcement

Use a structured list in frontmatter for citations when stricter traceability is required (summaries, ADRs, reflections):

- Required per item:
  - `id`: internal artifact ID (preferred) or external URL.
  - `locator`: section/paragraph/line selector (e.g., heading slug, anchor, line range).
  - `quote`: minimal necessary excerpt only (no fulltexts).
  - `quote_hash`: SHA-256 of a normalized `quote` (trim, normalize whitespace/newlines).
- Recommended:
  - `accessed`: ISO timestamp for web sources.
  - `license`: if relevant.

Enforcement:

- For `type: summary`, `type: adr`, and `type: reflection`, require at least one `citations` entry (configurable minimum via central config).
- Validator flags:
  - Missing `locator` or `quote_hash` → warning (non-strict) or error (strict mode).
  - External `id` URLs must be absolute and HTTPS.

### Source integrity (content_hash)

For `type: source`, include integrity metadata to support snapshots and verification:

- Required fields in frontmatter:
  - `url`: canonical source URL (if applicable).
  - `retrieved_at`: ISO timestamp when accessed.
  - `content_hash`: SHA-256 of the retrieved content (normalized text or binary as-is).
  - `hash_algo`: `sha256` (default).
  - `content_length`: byte length at retrieval time (if available).
- Optional:
  - `etag` / `last_modified` if provided by server headers.
  - `snapshot_path`: relative path to an internal snapshot (only if license permits; otherwise omit content and keep hash-only).

CLI behavior:

- `new --type source --url <URL>` fetches headers/content (within allowlist), computes `content_hash`, and records retrieval metadata without storing full copyrighted text.
- If content cannot be retrieved, allow manual provision of `content_hash` via `--content-hash` (validator will warn).

Validator checks:

- `content_hash` present and algorithm recognized.
- If a snapshot exists, recompute and compare hash → mismatch is an error.
- If only hash recorded, treat as integrity reference (no recomputation).

## Core requirements to implement

1) Product foundations
   - Product vision and specification templates and initial docs
   - Cornerstone documents: engineering best practices, conventions, contribution guidelines
   - Spec-as-source: implementation and tasks derive from spec; keep spec canonical

2) Work breakdown & agile
   - Epics, Features, Stories, Tasks; milestones
   - Sprint planning and status updates (auto summaries, counts)
   - MVP + increments; acceptance criteria on each level

3) Architecture decisions (ADR)
   - Template for ADRs; alternatives, trade-offs, consequences; references
   - Cross-links to affected artifacts

4) ACE (Agentic Context Engineering) reflections at all levels
   - Roles: Generator, Reflector, Curator; handovers between roles
   - ACE (Agentic Context Engineering) phases: Framing → Grounding & Evidence → Validation & Risks → Decision & Next Actions
   - Reflection template with fields for role, session, context sources, uncertainties, confidence

5) Knowledge ingestion (sources + summaries)
   - `type: source` with metadata (url, author, publisher, dates, license, trust)
   - `type: summary` derived from a source (TL;DR, key points, structured summary, evidence/quotes with citations, relevance, risks/bias, actionables, open questions)
   - Strict provenance; never store full copyrighted text

6) Agent prompts & model awareness
   - Central prompts (canonical) for each task (ADR, ACE reflection, sprint planning, status update, implementation, code change, knowledge ingestion)
   - Agent-specific files as addenda only; renderer composes central + addendum
   - Installer to export prompts and optionally copy to clipboard (macOS)
   - Detect model/agent and apply constraints (conciseness, token limits, JSON compliance when needed)

7) Memory strategy
   - Define lightweight memory guidelines per role/group (e.g., what to persist, where to link, when to purge)
   - Store memory as concise Markdown notes linked by IDs, organized in a dedicated area per role/group and referenced by artifacts as needed

8) Clarification policy
   - When specifics are not clear: create a clarification entry/task; mark unknowns; do not proceed with risky steps

9) Self-maintenance and provenance
   - Provide scripts that auto-update the central index, the status overview, and a machine-readable graph export
   - Maintain a human-readable change log for externally visible behavior changes

10) Continuous reflection and self-improvement

- Apply ACE (Agentic Context Engineering) not only to individual artifacts but also as a periodic repository-wide reflection sweep
- Detect drift between canonical central prompts and agent addenda; propose fixes
- Run guardrail/compliance health checks (frontmatter validity, allowed types/statuses, orphan links, dead references)
- Maintain an improvement backlog (actionable tasks with owners/dates) derived from reflections/audits
- Curator audits consolidate issues and decisions; updates ripple through the knowledge graph

## Scripts to implement (behavior outline; do not fix names)

- Library helpers: ID/date generation, frontmatter accessors, safe text replacement (POSIX/BSD-compatible)
- New entity: create artifacts from templates; support all types; URL option for sources
- Update index: scan knowledge base → refresh machine-readable graph and overview tables in the index document
- Update status: aggregate counts and write summaries to the status document
- Reflect: create an ACE (Agentic Context Engineering) reflection for a given artifact
- Sync: run index + status updates
- Prompt rendering: compose (guardrails + central task + agent addendum + model addendum + config/index excerpts + optional context)
- Prompt installer: export rendered prompt to an agent-specific export location and to clipboard on macOS (optional)
- CLI entry point: expose commands (new, index, status, reflect, sync, prompt, prompt-install)
- Provenance injection: when creating/updating via scripts/agents, capture and write `created_by` and `generated_with` and preserve/merge `context_sources`/`derived_from`
- Provenance validation: check presence/shape of provenance fields per type and report issues
- Provenance validator (standalone): scan repo, validate provenance contract (presence, shapes, citations structure), verify `content_hash` for sources, flag missing `prompt_hash` for auto-generated changes; output PASS/FAIL with a concise report
- Repository-wide audit: run ACE-based checks across artifacts; summarize findings
- Drift detection: compare central prompts to agent addenda and flag inconsistencies
- Health checks: validate frontmatter/contracts, link integrity, config conformance
- Improvement backlog generator: convert audit/reflection findings into actionable items
- Skills registry management: add/list/update/remove skills; filter by role/task; produce compact injection payloads
- Tool contract validation: lint/validate input/output schemas; safety checks; generate minimal usage docs
- MCP capability discovery/status: detect available capabilities, map to tool contracts, record limits (tokens/rate), and expose a read-only summary
- Optional tool invocation adapters (stubs) with clear safety constraints (no destructive defaults)
- Web explorer support: build/update `docs/_graph/graph.json` and `docs/_graph/index.json` for client-side search; emit `docs/explorer.html` as a single self-contained file (inline CSS/JS) that consumes these files

## Artifact explorer (single-file web app)

Objective:

- Provide a zero-dependency, single HTML file (Vanilla JS + inline CSS) to explore all repository artifacts via list and graph views with universal search/filter and HATEOAS-like navigation across references.

Deliverable:

- `docs/explorer.html` (single file) consuming `docs/_graph/graph.json` and `docs/_graph/index.json` (both generated by the sync/index scripts).

Data contracts:

- `graph.json`
      - `nodes`: [{ id, type, title, status, path, parent, tags[], milestone, owner, created, updated }]
      - `edges`: [{ source, target, rel }] where rel ∈ { parent, derived_from, context, cites, links }
- `index.json`
      - Array form (simple): [{ id, terms, fields }] where `terms` is a normalized aggregate of frontmatter fields; `fields` exposes a subset for facet filters (type, status, tags, milestone, owner, dates)
      - Optional inverted form (advanced): { token: [id, ...] } — may be produced when repo size grows; the web app should support both forms.

Features (must-have):

- Universal search bar: tokenizes input; matches across id, type, title, status, tags, milestone, owner, created/updated, and path; debounce; highlight matches.
- Filters: type, status, tags (multi-select), milestone, owner, date ranges; combine with search (AND semantics).
- Views:
      - List view: sortable (title, updated, status, type), group by type/status; keyboard navigation; deep-linkable URLs (query params reflect search/filter/state).
      - Graph view: force or radial layout (no external libs); pan/zoom; select node to center; show neighbors; click-through to artifact; toggle edge types; search/filter reflect in the graph.
- HATEOAS-like navigation: follow references by ID and path; from any artifact, one-click traverse to parent, children, derived_from, citations, and related links.
- Links: open the artifact file via relative `path`; support optional `base_url` config to rewrite links for GitHub Pages or other hosting.

UX & quality:

- Fast on a few hundred artifacts; graceful on ~1k (debounced search, simple caching, avoid reflow churn, requestAnimationFrame for graph ticks).
- Accessible (semantic HTML, focus states, ARIA labels for controls, color-contrast friendly theme).
- No external network calls; no telemetry; CSP-friendly (no inline event handlers except unavoidable script block in this single file).
- Works locally via `file://` and when served from `docs/` (GitHub Pages).

Security & safety:

- Sanitize text content; never execute artifact content; treat all fields as untrusted.
- Respect relative paths; do not allow directory traversal beyond the repository root in link generation.

Configuration:

- Inline `config` block in `explorer.html` with optional fields: { base_url: "", graph_path: "_graph/graph.json", index_path: "_graph/index.json" }.
- Fallback: if `index.json` missing, the app can derive basic search terms from `graph.json`.

## Provenance validator (standalone)

Purpose:

- Provide a fast, deterministic PASS/FAIL verdict on provenance compliance across the repository.

CLI usage (POSIX-compatible):

- `scripts/validate-provenance.sh [--json] [--strict] [--paths <dir|file> ...]`

Behavior:

- Scans Markdown files with YAML frontmatter.
- Validates required provenance fields by `type` (including `created_by`, `generated_with`, `citations`, and `content_hash` for `source`).
- Verifies `generated_with.prompt_hash` is present when artifacts were created/updated by framework scripts (detect via `generated_with.tool`).
- If a model addendum is enabled for the detected model (from `created_by.model` or CLI flags) per the constraints matrix, verifies a model addendum exists in rendered prompts and appears after the agent addendum; if disabled/not defined, verifies no model addendum is present.
- Emits a concise human-readable summary and optional JSON report to stdout.
- Exit codes: 0 = PASS, 1 = FAIL.

Output (JSON, when `--json`): see "Appendix: provenance validator result schema (JSON)".

## Templates to implement (content outline; do not fix names)

- Vision, Specification: concise structure with references and milestones
- Epic, Feature, Story, Task: frontmatter + acceptance criteria + links to parents
- ADR: context, decision, alternatives/trade-offs, consequences, references
- ACE (Agentic Context Engineering) Reflection: role, session, context_sources, ACE phases, uncertainties, confidence, curator handover
- Review: curator checks, decision (accepted/needs work), follow-ups
- Source, Summary: knowledge ingestion with provenance and derived summary
  - Source must include retrieval metadata and a SHA-256 content hash for integrity checks
  - Summary/ADR/Reflection may include structured `citations` (see Provenance contract)
- Skill, Tool, MCP capability: registry artifacts describing capabilities, schemas, safety, and (optional) MCP bindings
- Meta-reflection / Retrospective: repository-wide reflection output with ACE phases and curator handover
- Audit report & Improvement backlog entry: concise findings, decisions, and actions

### Inline schema prototypes (illustrative; adapt names/fields as needed)

Skill (role-aligned capability):

```yaml
---
id: <ID>
category: skill
name: ""
roles: [Generator, Reflector, Curator]
purpose: ""
inputs:
   - { name: "", type: "", required: true }
outputs:
   - { name: "", type: "" }
failure_modes: [""]
triggers: ["when …"]
defer_when: ["if unclear requirements"]
safety_notes: ["no destructive actions"]
updated: <DATE>
---
```

Tool contract:

```yaml
---
id: <ID>
category: tool
name: ""
description: ""
input_schema: { type: object, properties: {}, required: [] }
output_schema: { type: object, properties: {}, required: [] }
mcp_capability: ""  # optional mapping
safety_notes: ["validate inputs", "rate-limit"]
updated: <DATE>
---
```

MCP capability descriptor (optional):

```yaml
---
id: <ID>
category: capability
name: ""
provider: "mcp"
resource: ""
method: ""
input_schema: { type: object, properties: {}, required: [] }
output_schema: { type: object, properties: {}, required: [] }
limits: { tokens: 0, rate: "" }
updated: <DATE>
---
```

## Prompts to implement (do not fix names)

- Global guardrails: frontmatter usage, no hallucinations, IDs/paths, statuses, ACE roles, handovers
- Central task prompts (one per task): ADR, ACE (Agentic Context Engineering) reflection, sprint planning, status update, implementation, code change, knowledge ingestion
- Agent addenda (per agent/task): concise bullets only; must not duplicate central prompts
- Model addenda (per model/task): concise bullets only; optional; appended after agent addendum; must not duplicate central prompts
- Skills/Tools/MCP prompts: define/register/list/update skills and tool contracts; inject a relevant subset into task prompts based on role, task, and context; align with MCP capabilities when available
- Self-improvement & audit prompts: trigger repository-wide ACE reflections, drift detection, compliance checks, and improvement backlog generation

### Prompt template (best practices)

Provide a concise prompt template to be reused across tasks and agents. The template should enforce clarity, progressive disclosure, reference-first behavior, and verifiable outputs.

```markdown
# Role / Persona
- Who you are and how you should behave (tone, depth, step size)

# Objective
- Precise task goal(s); desired impact and scope boundaries

# Context summary (optional, short)
- Key facts/IDs/links; avoid pasting large texts

# Constraints & guardrails
- Frontmatter + config compliance; no hallucinations; cite sources; progressive disclosure
- Renderer composition: central prompt first; agent addendum; optional model addendum; avoid duplication and resolve conflicts in favor of central prompt

# Inputs (contract)
- Expected inputs (IDs/paths/URLs) and their types; optional vs required

# Plan (small, testable steps)
- Step 1: ...
- Step 2: ...
- Step 3: ...

# Tool usage plan (if applicable)
- Which tools/functions to call, with input/output schemas and safety checks

# Output contract
- Exact format (Markdown with YAML frontmatter when creating/updating artifacts)
- Mandatory sections/fields; where to include references

# Quality gates
- Build/Lint/Test (or structural checks); success criteria

# Risks, assumptions, open questions
- Brief list; propose clarifications if blocking

# Next action
- Immediate next step; request missing info if needed
```

## Agent integration (central-first + addendum)

- Rendering always includes the central prompt first, then the agent-specific addendum; if relevant, append a model-specific addendum ("Model-Addendum").
- Model-Addendum rules: concise bullets only; no Duplikate des zentralen Prompts oder Agent-Addendums; Konflikte werden zugunsten des zentralen Prompts aufgelöst.
- Renderrangfolge: central → agent addendum → model addendum → config/index excerpts.
- Provide READMEs per agent with usage notes
- Support agents: Copilot (VS Code), Claude, OpenAI, Goose (OpenAI-compatible)

## Skills, tools, and MCP capabilities

- Define a compact skills registry mapped to roles (e.g., Generator, Reflector, Curator, Architect, PM, Engineer). For each skill, specify:
  - Purpose, prerequisites, typical inputs/outputs, and failure modes
  - When to apply (triggers) and when to defer (clarification policy)
- Define tool contracts (name, description, input schema, output schema, safety notes). Keep interfaces minimal and composable.
- If the environment supports MCP (Model Context Protocol), provide capability descriptors for the most useful functions, for example:
  - Knowledge access (read-only slices; domain allowlist for web fetch)
  - Repository operations (safe reads; constrained writes within the project)
  - VCS insights (status/diff) and search (code/text)
  - Prompt rendering/export plumbing
- Ensure tools/skills are reference-first (IDs/paths/URLs) and respect progressive disclosure and safety constraints.

## Context efficiency & progressive disclosure

- Keep answers short, structured, and reference-heavy
- Ask for minimal additional context (file IDs/paths) when needed
- Avoid large payloads; prefer summaries and links

## Output contract (what to produce now — no fixed names or paths)

- Create a minimal, working repository scaffold with all required components described above
- Include working POSIX/BSD-compatible shell scripts and templates with valid YAML frontmatter
- Provide central prompts and agent addenda as specified; include renderer/installer capabilities
- Expose a CLI with commands to create artifacts, update index/status, perform reflections, render/export prompts
- Include a central index document and a status document with initial AUTO-GENERATED sections
- Provide a single-file web explorer at `docs/explorer.html` that consumes `docs/_graph/graph.json` and `docs/_graph/index.json`
- Validate by a dry run: create an epic, add a source+summary, render a prompt; document the steps in the main README
- Provide a minimal skills/tools/MCP registry and demonstrate filtered injection into a task prompt

## Smoke test checklist (execute and document)

1. Initialize the minimal structure and components (config, scripts, prompts, templates, index/status, graph export)
1. Create a sample epic/feature/story and verify:
   - Frontmatter validity, IDs/links
   - Index shows the item; status aggregates counts
1. Knowledge ingestion:
   - Add one source (with metadata) and a derived summary (parent link, citations)
   - Verify provenance fields and linkage
   - For the source: verify `content_hash` present and stable
   - For the summary: verify `citations` present (at least one item)
1. Prompt rendering:
   - Render a task prompt and confirm layout: central task → agent addendum → optional model addendum → config/index excerpts
   - Confirm provenance auto-injection: `created_by`, `generated_with.prompt_ref`, and `generated_with.prompt_hash`
   - If a model addendum is enabled for the selected model (see constraints matrix), verify it appears after the agent addendum; otherwise confirm no model addendum is included
1. Artifact explorer (single-file web app):
   - Open `docs/explorer.html` locally or via GitHub Pages
   - Verify universal search matches across frontmatter fields; filters (type/status/tags/milestone/owner/date) work and combine with search
   - Verify list view sorting/grouping and deep links (URL reflects state)
   - Verify graph view pan/zoom, neighbor highlight, and correct placement of model/agent relationships where applicable; following references navigates to target artifacts
1. Reflection (ACE – Agentic Context Engineering):
   - Create a reflection with all ACE phases and a curator handover
1. Export a prompt for one agent and check the exported artifact
1. Skills/Tools/MCP:
   - Register one skill and one tool with schemas; optionally map a capability
   - Validate schemas; generate an injection payload and render a task prompt including it
1. Continuous self-improvement:
   - Run a repository-wide audit/reflection; verify drift detection and health checks
   - Produce a meta-reflection report and at least one improvement backlog entry

1. Provenance validator:

- Run the provenance validator script
- Record PASS/FAIL and list of issues (if any); ensure `--strict` yields no errors

1. Document the dry run outcomes succinctly in the overview doc

Record pass/fail and key notes for each step. Blockers should create clarification tasks rather than proceeding with assumptions.

## Acceptance criteria

- The repository builds (no syntax errors), scripts execute on macOS/Linux shells
- Lint sanity: Markdown headings present; frontmatter parses; tables render
- Index/status update successfully and reflect artifacts
- Prompts render with “central task” followed by “agent-specific addendum”, then optional “model-specific addendum”, and config/index excerpts
- Knowledge ingestion creates correct links and provenance; no fulltext copied
- Web explorer loads without dependencies, supports universal search/filter in list and graph views, and allows navigation across references
- Provenance validator returns PASS (or reports actionable issues resolved within the run)
- ACE (Agentic Context Engineering) reflections template enforces phases and curator handover
- Spec-as-source documented; provenance recorded across artifacts
- Repository-wide audit/reflection runs, drift issues (if any) are reported or resolved, and an improvement backlog is produced

## Quick dry-run plan (path-agnostic)

- Initialize core structure and config
- Create one epic with a child feature or story
- Add one source and a derived summary linked to the source
- Run index and status updates
- Render one central task prompt and an agent-specific variant
- Create one ACE (Agentic Context Engineering) reflection and a curator review
- Register one skill and one tool; generate an injection payload and render a task prompt with it
- Run a repository-wide audit/reflection; capture at least one improvement backlog entry

## Appendix: compact skills registry schema (JSON)

Minimal shape for a single skill entry; adapt fields as needed.

```json
{
   "id": "SKILL-YYYYMMDD-HHMMSS-xyz",
   "category": "skill",
   "name": "Concise status summarization",
   "roles": ["Generator", "Reflector", "Curator"],
   "purpose": "Produce short, structured status summaries linked to artifacts.",
   "inputs": [
      { "name": "artifact_ids", "type": "array[string]", "required": true }
   ],
   "outputs": [
      { "name": "summary_md", "type": "markdown" }
   ],
   "failure_modes": ["insufficient context", "outdated links"],
   "triggers": ["when preparing status updates", "after sync"],
   "defer_when": ["unclear scope", "missing artifact IDs"],
   "safety_notes": ["never modify files directly; propose changes"],
   "updated": "2025-11-07"
}
```

## Appendix: compact tool contract schema (JSON)

Minimales, kopierbares JSON für ein Tool-Contract; Felder bei Bedarf anpassen.

```json
{
   "id": "TOOL-YYYYMMDD-HHMMSS-xyz",
   "category": "tool",
   "name": "update-index",
   "description": "Scannt die Wissensbasis und aktualisiert Graph/Übersichten.",
   "input_schema": {
      "type": "object",
      "properties": {
         "paths": { "type": "array", "items": { "type": "string" } },
         "dry_run": { "type": "boolean" }
      },
      "required": []
   },
   "output_schema": {
      "type": "object",
      "properties": {
         "updated_files": { "type": "array", "items": { "type": "string" } },
         "warnings": { "type": "array", "items": { "type": "string" } }
      },
      "required": ["updated_files"]
   },
   "mcp_capability": "repo.index.update",
   "safety_notes": ["nur lesende Scans außerhalb des Projekts", "keine destruktiven Defaults"],
   "updated": "2025-11-07"
}
```

## Appendix: tool validation result schema (JSON)

Kompakte Ergebnisform für eine Tool-Validierung (z. B. `tools validate`).

```json
{
   "tool_id": "TOOL-YYYYMMDD-HHMMSS-xyz",
   "valid": true,
   "errors": [
      { "path": "input_schema.properties.paths", "message": "must be array", "severity": "error", "code": "schema.type" }
   ],
   "warnings": [
      { "path": "safety_notes[0]", "message": "missing rate-limit note", "severity": "warning", "code": "safety.missing" }
   ],
   "suggestions": [
      "Add 'dry_run' boolean input",
      "Document failure modes"
   ],
   "checked_at": "2025-11-07T12:00:00Z",
   "schema_version": "1.0.0"
}
```

## Appendix: provenance validator result schema (JSON)

Kompaktes, maschinenlesbares Ergebnisformat des Provenance Validators inkl. Model-Addendum-Check.

```json
{
   "valid": true,
   "fail_count": 0,
   "errors": [
      { "path": "docs/feature-x.md::frontmatter.created_by", "message": "missing created_by.agent", "severity": "error", "code": "prov.missing" }
   ],
   "warnings": [
      { "path": "docs/summary-y.md::frontmatter.citations[0].locator", "message": "locator missing (non-strict)", "severity": "warning", "code": "citations.shape" }
   ],
   "checks": {
      "frontmatter_required": { "pass": true, "details": "all required fields present" },
      "provenance_fields": { "pass": true, "details": "created_by/generated_with ok" },
      "citations_shape": { "pass": true, "details": "all citations include id/locator/quote/quote_hash" },
      "source_content_hash": { "pass": true, "details": "sha256 present and valid" },
      "prompt_hash_present": { "pass": true, "details": "generated_with.prompt_hash present where tool detected" },
      "model_addendum": {
         "pass": true,
         "required": true,
         "found": true,
         "placement_ok": true,
         "details": "model addendum rendered after agent addendum for model gpt-4o"
      }
   },
   "files": [
      {
         "path": "prompts/rendered/status_update.md",
         "type": "rendered-prompt",
         "created_by": { "agent": "openai", "model": "gpt-4o" },
         "generated_with": { "tool": "aiman-cli", "prompt_hash": "..." },
         "checks": {
            "model_addendum": { "pass": true, "required": true, "found": true, "placement_ok": true }
         }
      }
   ],
   "strict": true,
   "checked_at": "2025-11-07T12:00:00Z",
   "schema_version": "1.0.0"
}
```

## Appendix: skills registry entry form (JSON template)

Wiederverwendbare, kopierbare Vorlage ohne Frontmatter. Felder bei Bedarf anpassen.

```json
{
   "id": "SKILL-YYYYMMDD-HHMMSS-xyz",
   "category": "skill",
   "name": "",
   "roles": ["Generator", "Reflector", "Curator"],
   "purpose": "",
   "inputs": [ { "name": "", "type": "", "required": true } ],
   "outputs": [ { "name": "", "type": "" } ],
   "failure_modes": [],
   "triggers": [],
   "defer_when": [],
   "safety_notes": [],
   "updated": "YYYY-MM-DD"
}
```

## Appendix: config schema for types/statuses

Minimal zulässige Struktur für die zentrale Konfiguration der erlaubten Typen und Statuswerte.

YAML (illustrativ):

```yaml
types:
   - epic
   - feature
   - story
   - task
   - adr
   - reflection
   - review
   - source
   - summary
   - changelog

statuses:
   - draft
   - proposed
   - in-progress
   - review
   - accepted
   - done
   - deprecated

rules:
   frontmatter_required: [id, type, title, status]
   link_policy:
      use_relative_paths: true
      id_reference_required: true
```

JSON (gleichwertig):

```json
{
  "types": ["epic", "feature", "story", "task", "adr", "reflection", "review", "source", "summary", "changelog"],
  "statuses": ["draft", "proposed", "in-progress", "review", "accepted", "done", "deprecated"],
  "rules": {
    "frontmatter_required": ["id", "type", "title", "status"],
    "link_policy": { "use_relative_paths": true, "id_reference_required": true }
  }
}
```

## Appendix: ID policy (format & generation)

- Format: `YYYYMMDD-HHMMSS-<slug>` oder `YYYYMMDD-HHMMSS-<rand>`
- Eigenschaften:
  - Zeitbasierte Präfixe für natürliche Ordnung
  - Kleinbuchstaben, Ziffern, Bindestriche im Suffix (`[a-z0-9-]{3,}`)
  - Eindeutigkeit: Timestamp + 3–6 zufällige Zeichen reichen in Praxis
- Regex (vereinfachend):

```text
^[0-9]{8}-[0-9]{6}-[a-z0-9-]{3,}$
```

- Generatorhinweise:
  - Nutze Systemzeit (UTC) für `YYYYMMDD-HHMMSS`
  - Füge 3–6 zufällige alphanumerische Zeichen an (lowercase)
  - Keine Leerzeichen, keine Unterstriche

## Appendix: model/agent constraints matrix (JSON template)

Vorlage zur Dokumentation agent-/modell-spezifischer Constraints (Platzhalter ausfüllen). Berücksichtigt Model-Addenda: steuere Rendering (aktiviert, Position nach Agent-Addendum, max. Bullets, Duplikats-/Konfliktregeln) pro Modell.

```json
{
   "agents": [
      {
         "name": "copilot",
         "preferred_format": ["markdown"],
         "max_context_tokens": null,
         "guidance": ["kurze, schrittweise Antworten", "Referenzen statt Volltexte"],
         "safety": ["keine destruktiven Aktionen", "rate-limit aware"],
         "notes": []
      },
      {
         "name": "claude",
         "preferred_format": ["markdown", "json"],
         "max_context_tokens": null,
         "guidance": ["prägnante Struktur", "lange Reasoning-Schritte möglich"],
         "safety": ["Quellenzitierung", "progressive disclosure"],
         "notes": []
      },
      {
         "name": "openai",
         "preferred_format": ["markdown", "json"],
         "max_context_tokens": null,
         "guidance": ["bei Bedarf JSON-Ausgabe strikt halten", "Tokenbudget beachten"],
         "safety": ["keine Volltexte externer Quellen", "validiere Frontmatter"],
         "notes": []
      },
      {
         "name": "goose",
         "preferred_format": ["markdown", "json"],
         "max_context_tokens": null,
         "guidance": ["OpenAI-kompatible Nutzung"],
         "safety": ["gleiches Sicherheitsprofil wie OpenAI"],
         "notes": []
      }
   ],
   "models": [
      {
         "agent": "openai",
         "name": "gpt-4o",
         "match": ["gpt-4o", "gpt-4o-mini"],
         "preferred_format": ["markdown", "json"],
         "guidance": ["kurze Bullets im Model-Addendum", "JSON strikt wenn gefordert"],
         "addendum": {
            "enabled": true,
            "max_bullets": 8,
            "placement": "after-agent",
            "duplicate_policy": "forbid"
         },
         "safety": ["keine Volltexte externer Quellen", "validiere Frontmatter"],
         "notes": []
      },
      {
         "agent": "claude",
         "name": "claude-3.5",
         "match": ["claude-3.5", "claude-3-opus"],
         "preferred_format": ["markdown", "json"],
         "guidance": ["prägnante Struktur", "längere Reasoning-Schritte möglich"],
         "addendum": {
            "enabled": true,
            "max_bullets": 10,
            "placement": "after-agent",
            "duplicate_policy": "forbid"
         },
         "safety": ["Quellenzitierung", "progressive disclosure"],
         "notes": []
      }
   ],
   "composition": {
      "order": ["central", "agent", "model", "excerpts"],
      "conflict_resolution": "prefer-central",
      "dedupe": true
   }
}
```

## Appendix: repository audit checklist (concise)

- Frontmatter vollständig (Pflichtfelder), `updated` aktuell
- Typen/Status entsprechen zentraler Konfiguration
- IDs eindeutig; Pfade relativ; Eltern-/Kind-Verlinkungen korrekt
- Waisen/Dead Links: keine toten Referenzen
- Index/Status aktuell; Graph-Export vorhanden
- Prompt-Drift: zentrale Prompts vs. Agent-Addenda konsistent; keine Duplikate
- Knowledge Ingestion: Quellen-Metadaten vollständig; Summary mit Zitaten/Provenienz
- ACE-Reflexionen: alle Phasen + Curator-Handover vorhanden
- Reviews: Entscheidungen dokumentiert; Folgeaktionen erfasst
- Improvement-Backlog: abgeleitete Tasks mit Owner/Datum

## Appendix: quality gates rubric (PASS/FAIL)

- Build: PASS, wenn Skripte ohne Syntaxfehler laufen (z. B. `shellcheck` optional)
- Lint: PASS, wenn Markdown-Überschriften/Lücken/Codefences stimmig; Frontmatter parsebar
- Tests/Checks: PASS, wenn Index/Status/Graph-Export generiert; Drift/Audit ohne Blocker
- Selbstcheck nach Änderungen:
   1) `new` auf Probe, 2) `sync`, 3) Prompt rendern, 4) eine ACE-Reflexion anlegen, 5) Audit laufen lassen

## Final notes

- Keep all content concise and structured to maximize token efficiency
- Prefer IDs and relative paths throughout
- If uncertain, create a clarification task and pause further steps
