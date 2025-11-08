# Releases

## v0.1.0 – 2025-11-08

Baseline framework bootstrap.

### Added

- Scaffold (directories, config, initial index/status placeholders)
- Markdown templates for artifact types (vision, specification, epic, feature, story, task, adr, reflection, review, source, summary, skill, tool, capability)
- Core scripts: id/frontmatter/new, index/status/sync, prompt rendering & install
- Provenance validator, audit & drift detection
- Single-file artifact explorer (HTML + inline JS/CSS)
- Initial sample epic artifact and rendered prompt

### Notes

- POSIX/BSD compatible scripts (macOS tested)
- prompt_hash (sha256) included in rendered prompts
- Knowledge graph JSON + index JSON export operational

### Integrity

- Provenance fields injected on creation/render
- Drift script detects duplicate prompt lines

Tag: `v0.1.0`
