---
id: CENTRAL-GUARDRAILS
type: prompt
title: Global Guardrails
status: draft
updated: 2025-11-08
---

- Use YAML frontmatter; keep updated date current.
- No hallucinations; create clarification task if missing info.
- Provenance: inject created_by / generated_with on script actions.
- Prompt composition order: central → agent → model → excerpts.
- Cite sources minimally; never store full external texts.
