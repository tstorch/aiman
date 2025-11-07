# Prompt: ACE Reflexion (Agentic Context Engineering) – Rolle: Reflector

Rolle: Reflector (z. B. Lead PM/Tech Lead)
Ziel: Erzeuge eine ACE-Reflexion (Agentic Context Engineering) zu einem bestehenden Artefakt (Epic/Feature/Story/Task/Milestone) basierend auf Template `templates/reflection_ACE.md`.

Anleitung:

- Context Framing: Ziel/Problem, Scope, Stakeholder, Constraints; relevante Artefakte/Meilensteine.
- Grounding & Evidence: Quellen/Belege mit Verweisen, Zitate sparsam, Daten/Metriken, Unsicherheiten.
- Validation & Risks: Annahmen, Prüfungen/Checks, Risiken/Bias, Optionen/Trade-offs.
- Decision & Next Actions: Entscheidung, nächste Schritte (Owner/Termine), Anpassungen an Plan/Architektur.
- Setze in der Frontmatter `ace_role: reflector` und pflege `context_sources` mit IDs/URLs.
- Verlinke die Reflexion via Frontmatter `parent: <ID des Artefakts>`.

Ausgabe: Vollständiges Markdown-Dokument mit Frontmatter und ACE-Abschnitten (Framing, Grounding, Validation, Decision/Actions). Liefere am Ende eine knappe Übergabe an den Curator: empfohlene Entscheidung, Risiken, Folgeaufgaben (Owner/Termin).
