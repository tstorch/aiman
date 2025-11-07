# Aiman: Markdown-basierte Produktentwicklung mit Knowledge Graph

Aiman ist ein leichtgewichtiges Framework aus Markdown-Templates, Prompts und Bash-Skripten für Produktentwicklung, Architekturarbeit (ADR), Agile-Planung (Epics/Features/Stories/Tasks) und kontinuierliche Reflexion (ACE – Agentic Context Engineering). Das Repo fungiert als Knowledge Graph mit zentralem Einstieg.

## Schnellstart

Voraussetzungen: macOS/Linux, Bash, awk, sed, find, grep (Standard-Tools). Optional: `chmod +x` für ausführbare Skripte.

- Konfiguration prüfen/anpassen: `config/project.yml`
- Neues Artefakt anlegen (z. B. Epic):
  - Option A: direkt mit Bash
    - `bash scripts/new-entity.sh epic "Meine erste Initiative" --tags onboarding,core`
  - Option B: CLI-Wrapper
    - `bash bin/aiman new epic "Meine erste Initiative" --tags onboarding,core`
- Index/Status aktualisieren:
  - `bash scripts/sync.sh`
- ACE-Reflexion (Agentic Context Engineering) zu einem Artefakt erzeugen:
  - `bash scripts/reflect.sh docs/work/epics/<ID>-<slug>.md`

Hinweis: Falls du die Skripte als ausführbar nutzen willst, setze einmalig die Rechte:

```sh
chmod +x scripts/*.sh bin/aiman
```

## Quick Reference (ohne feste Pfade)

Die wichtigsten Kommandos über den CLI-Wrapper (sofern in deinem PATH verfügbar):

```sh
aiman new <type> "<title>" [--tags tag1,tag2]
aiman index
aiman status
aiman reflect <artifact_path_or_id>
aiman sync
aiman prompt --agent <agent> --task <task> [--context <path1,path2>]
aiman prompt-install --agent <agent> --task <task>
```

Kurzbeschreibung:

- new: erzeugt ein Artefakt aus Templates (z. B. epic/feature/story/task/adr/source/summary)
- index: aktualisiert Knowledge Graph und Übersichten
- status: aggregiert Kennzahlen (Counts je Typ/Status)
- reflect: erstellt eine ACE-Reflexion (Agentic Context Engineering) zu einem Artefakt
- sync: führt index + status aus
- prompt: rendert einen zentralen Task-Prompt mit Agent-Addendum
- prompt-install: exportiert einen Prompt für einen Agenten (Option: Zwischenablage auf macOS)

## Struktur

- `docs/index.md` – zentraler Einstieg, automatisch gepflegte Übersichten
- `docs/status.md` – Kennzahlen und Fortschritt (auto)
- `docs/_graph/graph.tsv` – Knowledge-Graph-Index (auto)
- `docs/product` – Vision, Spezifikation
- `docs/work` – Epics, Features, Stories, Tasks
- `docs/architecture/adr` – Architecture Decision Records
- `docs/reflections` – ACE-Reflexionen (Agentic Context Engineering)
- `templates` – Markdown-Vorlagen (YAML Frontmatter)
- `prompts` – LLM-Prompts mit Guardrails
- `scripts` – Bash-Skripte (Erzeugen, Index, Status, Reflexion, Sync)
- `bin/aiman` – kleiner CLI-Wrapper

## Frontmatter-Kontrakt (Knowledge Graph)

Jede Datei beginnt mit YAML-Frontmatter, z. B.:

```yaml
---
id: 20251107-120000-xyz
type: epic
title: "Meine erste Initiative"
status: draft
owner: ""
parent: ""  # Referenz-ID eines Parent-Artefakts
milestone: "M1"
tags: [onboarding, core]
created: 2025-11-07
updated: 2025-11-07
---
```

Pflichtfelder: `id`, `type`, `title`, `status`. Empfohlen: `tags`, `parent` (wo sinnvoll), `milestone`.

## Generierung und Pflege

- `scripts/new-entity.sh` nutzt Templates und füllt Platzhalter (ID, TITLE, DATE, …).
- `scripts/update-index.sh` durchsucht `docs/` und aktualisiert den Knowledge Graph (`docs/_graph/graph.tsv`) und die Übersichtstabellen in `docs/index.md`.
- `scripts/update-status.sh` aggregiert Kennzahlen (Counts pro Typ/Status) und schreibt in `docs/status.md`.
- `scripts/reflect.sh` erstellt eine ACE-Reflexion (Agentic Context Engineering) zu einem Artefakt.
- `scripts/sync.sh` führt Index- und Status-Update aus.

## LLM-Guidelines und Prompts

Unter `prompts/` findest du Guardrails (z. B. Halluzinationen minimieren, Quellen anfordern, strikt auf Frontmatter achten) sowie aufgabenspezifische Prompts (ADR, ACE – Agentic Context Engineering, Planung, Review). Diese sind so strukturiert, dass Agenten zuverlässig arbeiten und ihre Schritte dokumentieren.

ACE-Rollenmodell:

- Generator: erzeugt/ändert Artefakte kontextbewusst und übergibt Ziele, Quellen, Hypothesen
- Reflector: führt ACE-Reflexion (Framing, Grounding, Validation, Decision/Actions) aus
- Curator: prüft, entscheidet, kuratiert und dokumentiert als `type: review`

## Nächste Schritte

## Agent-Integrationen

Prompts für populäre Agenten sind vorbereitet und können gerendert/exportiert werden:

- Unterstützte Agenten: Copilot (VS Code), Claude Code, OpenAI, Goose (OpenAI-kompatibel)
- Unterstützte Tasks: adr, ace_reflection, sprint_planning, status_update, code_change, implementation, knowledge_ingestion

Hinweis zum Prinzip: Der zentrale Prompt (unter `prompts/*_prompt.md`) ist die maßgebliche Quelle. Agent-spezifische Wrapper unter `prompts/agents/<agent>/<task>.md` liefern nur Zusatzhinweise (Addendum) und werden beim Rendern automatisch nach dem zentralen Prompt eingefügt.

Rendern (Ausgabe auf stdout):

```sh
bin/aiman prompt --agent copilot --task ace_reflection --context docs/index.md,config/project.yml
```

Export + Zwischenablage (macOS):

```sh
bin/aiman prompt-install --agent copilot --task adr
```

Exportierte Dateien liegen unter `prompts/agents/<agent>/exports/<task>.md`.

- Lege Vision und Spezifikation an (entweder über Templates oder direkt in `docs/product/`).
- Erzeuge erste Epics/Features/Stories via Skript.
- Entscheide architekturelle Fragen per ADR-Template und verlinke diese im Frontmatter der betroffenen Artefakte.
- Nutze regelmäßige ACE-Reflexionen (Agentic Context Engineering) pro Ebene (Epic/Feature/Story/Task) und Meilenstein.

### Agent-Reference (kurz)

- Copilot (VS Code): Nutzt den Prompt-Renderer; Export via `prompt-install`. Beachte kurze, schrittweise Antworten und Kontextfenster.
- Claude: Gute Eignung für lange Reasoning-Schritte; halte Anweisungen prägnant und strukturiert.
- OpenAI: Achte auf Tokenbudget und gegebenenfalls JSON-konforme Ausgaben.
- Goose (OpenAI-kompatibel): Gleiche Nutzung wie OpenAI; verwende die gleichen Render-/Export-Flows.

Siehe per-Agent-READMEs unter `prompts/agents/<agent>/README.md` für Details und Hinweise.
