---
id: {{ID}}
type: review
title: "Curator Review: {{TITLE}}"
status: draft
owner: "{{OWNER}}"
parent: "{{PARENT}}"  # referenziertes Artefakt (z. B. Reflection/ADR/Story)
milestone: "{{MILESTONE}}"
tags: [review, governance, {{TAGS}}]
created: {{DATE}}
updated: {{DATE}}
# optional
scope: "content|process|decision"
resolution: "pending"
---

## Review-Zusammenfassung

- Kurz: Was wurde geprüft? Ergebnis?

## Compliance-Checks

- Frontmatter vollständig/konform (id, type, title, status, parent, tags, updated)
- Konsistenz mit `config/project.yml` (Statuswerte, Typen)
- Verlinkungen (parent, IDs, Pfade) korrekt

## Risiken/Offene Punkte

- ...

## Entscheidung

- akzeptiert / Nacharbeit nötig (was? wer? bis wann?)

## Folgeaktionen

- Änderungen an Artefakten
- Updates in Index/Status
