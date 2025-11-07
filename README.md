# Aiman: Markdown-basierte Produktentwicklung mit Knowledge Graph

Aiman ist ein leichtgewichtiges Framework aus Markdown-Templates, Prompts und Bash-Skripten für Produktentwicklung, Architekturarbeit (ADR), Agile-Planung (Epics/Features/Stories/Tasks) und kontinuierliche Reflexion (ACE). Das Repo fungiert als Knowledge Graph mit zentralem Einstieg.

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
- Reflexion (ACE) zu einem Artefakt erzeugen:
  - `bash scripts/reflect.sh docs/work/epics/<ID>-<slug>.md`

Hinweis: Falls du die Skripte als ausführbar nutzen willst, setze einmalig die Rechte:

```sh
chmod +x scripts/*.sh bin/aiman
```

## Struktur

- `docs/index.md` – zentraler Einstieg, automatisch gepflegte Übersichten
- `docs/status.md` – Kennzahlen und Fortschritt (auto)
- `docs/_graph/graph.tsv` – Knowledge-Graph-Index (auto)
- `docs/product` – Vision, Spezifikation
- `docs/work` – Epics, Features, Stories, Tasks
- `docs/architecture/adr` – Architecture Decision Records
- `docs/reflections` – ACE-Reflexionen
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
- `scripts/reflect.sh` erstellt eine ACE-Reflexion zu einem Artefakt.
- `scripts/sync.sh` führt Index- und Status-Update aus.

## LLM-Guidelines und Prompts

Unter `prompts/` findest du Guardrails (z. B. Halluzinationen minimieren, Quellen anfordern, strikt auf Frontmatter achten) sowie aufgabenspezifische Prompts (ADR, ACE, Planung, Review). Diese sind so strukturiert, dass Agenten zuverlässig arbeiten und ihre Schritte dokumentieren.

## Nächste Schritte

- Lege Vision und Spezifikation an (entweder über Templates oder direkt in `docs/product/`).
- Erzeuge erste Epics/Features/Stories via Skript.
- Entscheide architekturelle Fragen per ADR-Template und verlinke diese im Frontmatter der betroffenen Artefakte.
- Nutze regelmäßige ACE-Reflexionen pro Ebene (Epic/Feature/Story/Task) und Meilenstein.
