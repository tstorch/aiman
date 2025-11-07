# Agent Guidelines (Guardrails)

Diese Richtlinien halten LLMs/Agenten in der Spur und minimieren Halluzinationen.

- Strikte Nutzung der YAML-Frontmatter aus den Artefakten. Wenn ein Feld fehlt: explizit nachfragen oder leer lassen, nicht raten.
- Keine Inhalte erfinden. Wenn Wissen fehlt: Quellen anfordern oder Hinweise liefern, wie Daten beschafft werden können.
- Verweise immer über IDs und relative Pfade herstellen (Knowledge Graph).
- Status und Felder nur gemäß `config/project.yml` verwenden (z. B. `status: draft|proposed|in-progress|blocked|review|done|deprecated`).
- Änderungen an Dokumenten konsistent halten: Frontmatter `updated` setzen, wenn Inhalt geändert wurde.
- Bei Entscheidungen (ADR) Alternativen mit Vor-/Nachteilen listen, Trade-offs transparent machen.
- Bei Planung (Epic/Feature/Story/Task) immer Akzeptanzkriterien definieren und auf Parent (parent: ID) verlinken.
- Bei Reflexion (ACE): Assess -> Compare -> Execute strikt abarbeiten, keine Schritte überspringen.
- Risiken, Annahmen, offene Fragen klar kennzeichnen und in `docs/status.md` verlinken (über ID/Liste).
