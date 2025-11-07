You are an expert prompt engineer and project manager and know the quirks of LLMs.

Create for me a set of prompts, scripts (bash) and templates (markdown files) to manage a product development via markdown files. When encountering external sources you scrape them and include them with an accompanying markdown document with metadata (such as scraping date, URL, ...) and a multi-level summary

- Product vision
- Specification
- Cornerstone constitution, such as Software Engineering Best Practices (might be part of the knowledge graph infrastructure, see below)
- Epics, Features, Storys, Tasks; milestones
- Architecture planning, decision (ADR) and structured documentation
- Clarification (regular and ad hoc, when not 100% clear); when specifics are not clear mark them as such and do not proceed with further steps until clarified
- Working on artifacts such as implementation
- Agile development: MVP plus incremental development, review
- Reflection on each level (Epics, Features, Storys, Tasks; milestones) based on Agentic Context Engineering ( see https://arxiv.org/html/2510.04618v1 ) utilizing the roles Generator/Reflector/Curator
- Documentation (change and current state of development)
- Development documents (processes, conventions, best practices, knowledge sources, ...)
- The Repo basically works in its entirety as a knowledge graph with a central point of entry
- automatic knowledge scraping (e.g. websites) and integration into the knowledge graph structure
- spec as source ( see https://martinfowler.com/articles/exploring-gen-ai/sdd-3-tools.html )
- complete provenance for all artefacts in the repo


The framework is well integrated and maintaines itself, e.g. cross-updating status documents etc.
You do understand the quirks of LLMs/AI agents well and you keep them in check with proper prompt formulation and structure. You ensure that once read the instructions

---

Erstelle mir einen Prompt, um Original-Wissensquellen im Repo zu hinterlegen (etwa Internetseiten) und eine abgeleitete Markdown-Datei mit einer Zusammenfassung in mehreren Stufen plus Frontmatter mit Metadaten. Erstelle ein entsprechendes Template und hinterlege dieses direkt im Prompt. Die Metadaten-Markdown soll sich nahtlos in die Knowledge-Graph-Struktur einfügen