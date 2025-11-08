# aiman

Build products, not docs.

A Markdown-first, provenance-safe framework that turns specs into delivery: prompts, CLI, knowledge graph, and a zero-dependency explorer — all in one place.

## Elevator pitch

Turn specs into shipped outcomes with agent-ready prompts, strict provenance, and a self-updating knowledge graph.

## Core features

- Markdown-first knowledge graph (YAML frontmatter) with auto-generated index/status and machine-readable exports (graph.json, index.json), plus a zero-dependency web explorer.
- CLI-driven workflows: new, index, status, sync, reflect, prompt, prompt-install, validate-provenance, audit, drift-detect, backlog-gen.
- Provenance by default: created_by, generated_with (incl. prompt_hash), content_hash for sources, structured citations and enforcement in strict mode.
- ACE reflections and reviews: Generator/Reflector/Curator roles, repository-wide audits, and improvement backlog generation.
- Central-first prompts with agent/model addenda and a constraints matrix; skills/tools/MCP registries for targeted prompt injection.

## Why it matters

- Ship faster with confidence: reproducible, validated artifacts and scripted guardrails reduce risk.
- Align teams: one canonical spec feeds work breakdown, ADRs, prompts, and status.
- Be auditable by design: hashes, citations, and validators make decisions traceable.
- Discover without dependencies: a single-file explorer surfaces context, links, and impact without a build.
- Work with agents safely: prompts, addenda, and constraints unlock effective AI collaboration.

## Git Hooks (optional)

This repository can enforce strict provenance before commits:

- Pre-commit hook path: `.githooks/pre-commit` (installed via `git config core.hooksPath .githooks`).
- Runs `scripts/validate-provenance.sh --strict` and blocks if any required fields or citations are missing.
- Bypass (not recommended): set `ALLOW_BROKEN_PROVENANCE=1` in the commit environment.

To (re)install manually:

```sh
chmod +x .githooks/pre-commit
git config core.hooksPath .githooks
```

Remove or disable by resetting hooksPath:

```sh
git config --unset core.hooksPath
```

Keep commits green by remediating failures using the Failure recovery flow in the bootstrap prompt.
