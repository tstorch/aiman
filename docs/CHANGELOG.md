---
id: CHANGELOG
type: changelog
title: Change Log
status: draft
updated: 2025-11-08
---
 
- 2025-11-08: Initial scaffold created (Block A).

## v0.1.0 – 2025-11-08

Baseline framework bootstrap.

### Added

- Scaffold (directories, config, initial index/status placeholders)
- Markdown templates for all artifact types (vision, specification, epic, feature, story, task, adr, reflection, review, source, summary, skill, tool, capability)
- Core scripts: id/frontmatter/new, index/status/sync, prompt rendering & install
- Provenance validator, audit & drift detection
- Single-file artifact explorer (HTML + inline JS/CSS)
- Initial sample epic artifact and generated rendered prompt

### Notes

- All scripts POSIX/BSD compatible (macOS tested)
- Prompt hash (sha256) included in rendered prompts
- Knowledge graph JSON + index JSON export operational
