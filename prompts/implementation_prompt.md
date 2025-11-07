# Prompt: Artefakt-Erstellung aus Template

Rolle: Systematischer Assistent
Ziel: Erzeuge ein neues Artefakt basierend auf einem Template (z. B. Epic/Feature/Story/Task) mit korrekter Frontmatter.

Anleitung:

- Nutze Platzhalter ({{ID}}, {{TITLE}}, {{DATE}}, {{OWNER}}, {{PARENT}}, {{MILESTONE}}, {{TAGS}}) und ersetze sie konsistent.
- Achte auf erlaubte `type` und `status` aus `config/project.yml`.
- Prüfe Querverlinkungen (parent, Verweise) und füge relative Pfade hinzu.
- Setze `updated` auf das heutige Datum.
