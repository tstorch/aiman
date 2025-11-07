# Aiman Prompt – Agent: copilot – Task: adr

<!-- Agent Instructions Start -->
# Copilot (VS Code) – Verwendung

- Öffne Copilot Chat und füge den gerenderten Prompt (aus `bin/aiman prompt`) in die Eingabe ein.
- Optional: Lege dauerhafte "Custom Instructions" an, indem du den Guardrails-Abschnitt übernimmst.
- Nutze knappe, konkrete Follow-ups (eine Aufgabe pro Turn) und verweise auf IDs/Pfade.

Agent-spezifische Hinweise:

- Copilot bevorzugt klare, kurze Teilaufgaben. Vermeide mehrdeutige Anweisungen.
- Bei Dateibezügen immer relative Pfade und IDs im Prompt nennen.
<!-- Agent Instructions End -->

## Guardrails
# Agent Guidelines (Guardrails)

Diese Richtlinien halten LLMs/Agenten in der Spur und minimieren Halluzinationen.

- Strikte Nutzung der YAML-Frontmatter aus den Artefakten. Wenn ein Feld fehlt: explizit nachfragen oder leer lassen, nicht raten.
- Keine Inhalte erfinden. Wenn Wissen fehlt: Quellen anfordern oder Hinweise liefern, wie Daten beschafft werden können.
- Verweise immer über IDs und relative Pfade herstellen (Knowledge Graph).
- Status und Felder nur gemäß `config/project.yml` verwenden (z. B. `status: draft|proposed|in-progress|blocked|review|done|deprecated`).
- Änderungen an Dokumenten konsistent halten: Frontmatter `updated` setzen, wenn Inhalt geändert wurde.
- Bei Entscheidungen (ADR) Alternativen mit Vor-/Nachteilen listen, Trade-offs transparent machen.
- Bei Planung (Epic/Feature/Story/Task) immer Akzeptanzkriterien definieren und auf Parent (parent: ID) verlinken.
- Bei Reflexion (ACE = Agentic Context Engineering): Kontext rahmen -> Belege verankern (Grounding) -> Validieren & Risiken prüfen -> Entscheidung & nächste Schritte dokumentieren. Schritte nachvollziehbar protokollieren.
- Risiken, Annahmen, offene Fragen klar kennzeichnen und in `docs/status.md` verlinken (über ID/Liste).

## ACE Rollenmodell: Generator / Reflector / Curator

- Generator: erstellt/ändert Artefakte (Stories/Tasks/ADRs etc.), liefert Kontextquellen und klare Zielhypothesen. Erwartet: saubere Frontmatter, Links (parent), Akzeptanzkriterien, Auswirkungen.
- Reflector: führt ACE-Reflexion durch (Framing, Grounding, Validation, Decision/Actions), referenziert Quellen/Belege, dokumentiert Unsicherheiten und empfiehlt nächste Schritte.
- Curator: prüft Qualität/Compliance, konsolidiert Entscheidungen, startet Folgeaktionen (Reviews/Updates), sorgt für Konsistenz im Knowledge Graph (Index/Status aktualisieren).

Handover-Regeln:

- Generator -> Reflector: Übergibt Artefakt-ID(s), Ziel(e), relevante Quellen (IDs/URLs).
- Reflector -> Curator: Übergibt Reflexions-Dokument (ID), vorgeschlagene Entscheidungen/Aufgaben, Risiken/Offene Punkte.
- Curator: dokumentiert Review als `type: review`, entscheidet „akzeptiert“ oder „Nacharbeit“, initiiert/aktualisiert verlinkte Artefakte.

## Task
# Copilot – ADR (Architecture Decision Record)

Rolle: Senior-Architekt:in
Ziel: Erzeuge/Aktualisiere ein ADR basierend auf `templates/adr.md`. Beziehe Alternativen, Trade-offs und Konsequenzen ein. Verweise auf betroffene Artefakte per ID/parent.

Hinweise:

- Guardrails beachten (Frontmatter, IDs/Links, Statuswerte)
- Kurze, konkrete Schritte bevorzugen

## Project Config (excerpt)
name: aiman
owner: ""
description: "Markdown-basierte Wissensbasis für Produktentwicklung, Architektur, Agile und Reflexion (ACE)"
repo_url: ""
default_owner: ""
default_status: draft
default_milestone: "M1"
conventions:
  id_format: "YYYYMMDD-HHMMSS-rand"
  types: [epic, feature, story, task, adr, vision, specification, architecture, source, summary, review]
  status: [draft, proposed, in-progress, blocked, review, done, deprecated]

## Index (excerpt)
# Projektindex (Knowledge Graph Einstieg)

Dieses Dokument ist der zentrale Einstiegspunkt in alle Artefakte. Tabellen werden automatisch von `scripts/update-index.sh` gepflegt.

## Übersicht

- Produkt: Vision, Spezifikation
- Arbeit: Epics, Features, Stories, Tasks
- Architektur: ADRs und Architekturübersicht
- Agile: MVP, Roadmap, Milestones
- Reflexion: ACE (Agentic Context Engineering) auf allen Ebenen
- Status: Kennzahlen und Fortschritt

## Produkt

- [Vision](product/vision.md)
- [Spezifikation](product/specification.md)

## Arbeit

### Epics

<!-- AUTO-GENERATED: EPICS TABLE START -->
| ID | Title | Status | Updated |
|---|---|---|---|
<!-- AUTO-GENERATED: EPICS TABLE END -->

### Features

<!-- AUTO-GENERATED: FEATURES TABLE START -->
| ID | Title | Status | Updated |
|---|---|---|---|
<!-- AUTO-GENERATED: FEATURES TABLE END -->

### Stories

<!-- AUTO-GENERATED: STORIES TABLE START -->
| ID | Title | Status | Updated |
|---|---|---|---|
<!-- AUTO-GENERATED: STORIES TABLE END -->

### Tasks

<!-- AUTO-GENERATED: TASKS TABLE START -->
| ID | Title | Status | Updated |
|---|---|---|---|
<!-- AUTO-GENERATED: TASKS TABLE END -->

## Architektur

### ADRs

<!-- AUTO-GENERATED: ADR TABLE START -->
| ID | Title | Status | Updated |
|---|---|---|---|
<!-- AUTO-GENERATED: ADR TABLE END -->

## Reflexionen (ACE – Agentic Context Engineering)

<!-- AUTO-GENERATED: REFLECTIONS TABLE START -->
| ID | Title | Status | Updated |
|---|---|---|---|
<!-- AUTO-GENERATED: REFLECTIONS TABLE END -->

## Quellen

<!-- AUTO-GENERATED: SOURCES TABLE START -->
| ID | Title | Status | Updated |
|---|---|---|---|
<!-- AUTO-GENERATED: SOURCES TABLE END -->

## Wissenszusammenfassungen

<!-- AUTO-GENERATED: SUMMARIES TABLE START -->
| ID | Title | Status | Updated |
|---|---|---|---|
<!-- AUTO-GENERATED: SUMMARIES TABLE END -->

## Reviews (Curator)

<!-- AUTO-GENERATED: REVIEWS TABLE START -->
| ID | Title | Status | Updated |
|---|---|---|---|
<!-- AUTO-GENERATED: REVIEWS TABLE END -->

