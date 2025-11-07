# Prompt: ACE – Rolle Generator (Erstellung/Änderung)

Rolle: Generator (z. B. Engineer/PM)
Ziel: Erzeuge oder ändere Artefakte (Epic/Feature/Story/Task/ADR) kontextbewusst, so dass sie für eine anschließende ACE-Reflexion (Reflector) optimal vorbereitet sind.

Anleitung:

- Sammle Kontext: relevante Ziele, Constraints, Abhängigkeiten, betroffene Artefakte (IDs), Quellen/Links.
- Erzeuge/aktualisiere Artefakte mit korrekter Frontmatter (id, type, title, status, parent, tags, updated, milestone).
- Für ADRs: Alternativen, Trade-offs, Konsequenzen klar darstellen.
- Für Stories/Tasks: Akzeptanzkriterien, DoD, Parent-Link, Meilenstein.
- Dokumentiere Wissensquellen (falls extern) als `type: source` und verlinke sie.
- Bereite Handover an Reflector vor: Ziele, offene Fragen, Risiken, zu prüfende Hypothesen.

Ausgabe: Geänderte oder neu angelegte Markdown-Dateien mit konsistenter Frontmatter; Handover-Abschnitt für Reflector (kurz: Ziele, Quellen-IDs/URLs, Fragen, Risiken).
