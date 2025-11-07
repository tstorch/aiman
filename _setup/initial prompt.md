# Initial Prompt

You are an expert prompt engineer and project manager and know the quirks of LLMs.

Create for me a set of prompts, scripts (bash) and templates (markdown files) to manage a product development via markdown files. When encountering external sources you scrape them and include them with an accompanying markdown document with metadata (such as scraping date, URL, ...) and a multi-level summary

- Product vision
- Role definition and workflow; other prompts should reference the roles as needed
- memory management for specific roles and relevant groups of roles
- Specification
- Cornerstone constitution, such as Software Engineering Best Practices (might be part of the knowledge graph infrastructure, see below)
- Epics, Features, Storys, Tasks; milestones
- Architecture planning, decision (ADR) and structured documentation
- Clarification (regular and ad hoc, when not 100% clear); when specifics are not clear mark them as such and do not proceed with further steps until clarified
- Working on artifacts such as implementation
- Agile development: MVP plus incremental development, review
- Reflection on each level (Epics, Features, Storys, Tasks; milestones) based on Agentic Context Engineering (see <https://arxiv.org/html/2510.04618v1>) utilizing the roles Generator/Reflector/Curator
- Documentation (change and current state of development)
- Development documents (processes, conventions, best practices, knowledge sources, ...)
- The Repo basically works in its entirety as a knowledge graph with a central point of entry
- automatic knowledge scraping (e.g. websites) and integration into the knowledge graph structure
- spec as source (see <https://martinfowler.com/articles/exploring-gen-ai/sdd-3-tools.html>)
- complete provenance for all artefacts in the repo
- specific prompts for popular AI agents such as Copilot in VS Code, Codex, Claude Code, Goose and others in a properly matching folder structure each and setup scripts to initialize this framework for use for the selected ai agent; include agent specific information and constraints in the specifc prompts to leverage each to its maximum; include a prompt and script to update this information
- include model detection and injection of model-specific information and constraints in the prompts to leverage each model to its maximum; include a prompt and script to update this information
- efficency such as llm context window efficiency is mandatory for the agent in order to e.g. prevent known shortcomings for LLMs, one such technic is progressive disclosure and as such the agent and document structure must support this and other technics
- the structure of the framework should adhere to best practices of software engineering, project management and ai interaction engineering
- skills a la claude skills, tools and mcp capabilities
- Smoke-Test“-Checkliste am Ende des Prompts, damit ein Agent die erfolgreiche Generierung sofort validiert und dokumentiert
- Prompt-template nach aktuell bekannten Best Practices


The framework is well integrated and maintaines itself, e.g. cross-updating status documents etc.
In general the language for all artifacts is english if not specified otherwise
You do understand the quirks of LLMs/AI agents well and you keep them in check with proper prompt formulation and structure. You ensure that once read the instructions

---

Erstelle mir einen Prompt, um Original-Wissensquellen im Repo zu hinterlegen (etwa Internetseiten) und eine abgeleitete Markdown-Datei mit einer Zusammenfassung in mehreren Stufen plus Frontmatter mit Metadaten. Erstelle ein entsprechendes Template und hinterlege dieses direkt im Prompt. Die Metadaten-Markdown soll sich nahtlos in die Knowledge-Graph-Struktur einfügen

Die agentenspezifischen Prompt sollen nicht nur für ace_reflector gelten, sondern übergreifend. Das Setup-Skript soll diese Command Prompt and die für den jeweiligen Agenten passende Stelle kopieren

Sollten die agenten-spezifischen Prompts nicht auf die zentralen Prompts verweisen und lediglich agenten-spezifische Zusatzinformationen bieten?
