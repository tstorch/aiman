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
