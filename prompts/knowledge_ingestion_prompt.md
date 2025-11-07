# Prompt: Wissensquelle erfassen und zusammenfassen

Rolle: Researcher / Technical Writer
Ziel: Eine Originalquelle (z. B. Webseite) als Artefakt `type: source` im Repo anlegen und eine abgeleitete Zusammenfassung als `type: summary` erstellen. Beide Dokumente sollen per Frontmatter in den Knowledge Graph integriert sein.

Vorgehen:

1) Metadaten erfassen (ohne urheberrechtlich geschützte Volltexte zu kopieren):
   - URL, Titel, Autor:in, Publisher, Veröffentlichungsdatum, Lizenz, Vertrauens-/Qualitätsbewertung (hoch/mittel/niedrig)
   - Nur kurze Zitate mit Quellenangabe verwenden; keine ganzen Artikel einfügen
2) Quelle anlegen (type: source):
   - Datei unter `docs/sources/` mit Template „Source“ (siehe unten) erzeugen
   - `status: draft` belassen; `tags` sinnvoll vergeben
3) Zusammenfassung anlegen (type: summary):
   - Datei unter `docs/knowledge/` erzeugen
   - Mehrstufige Zusammenfassung ausfüllen (TL;DR, 5er-Gist, Details, Evidenz/Zitate mit Verweisen, Relevanz, Risiken/Bias, Actionables, offene Fragen)
   - `parent` auf die `id` der Quelle setzen; `source_url` übernehmen
4) Aktualisieren
   - `updated`-Feld in beiden Dokumenten setzen
   - Index/Status via Sync aktualisieren (nur innerhalb AUTO-GENERATED-Bereiche schreiben)

Validierungsregeln / Guardrails:

- Halte dich strikt an die YAML-Frontmatter-Felder; nutze Werte aus `config/project.yml` (Types/Status)
- Keine Halluzinationen: wenn Angaben fehlen, als „unbekannt“ markieren oder Quelle erneut prüfen
- Bei Zitaten stets Quelle/Abschnitt nennen und Umfang minimal halten

Beispiel-Templates (direkt einsetzbar)

```markdown
---
id: {{ID}}
type: source
title: "{{TITLE}}"
status: draft
owner: "{{OWNER}}"
parent: ""
milestone: "{{MILESTONE}}"
tags: [knowledge, source, {{TAGS}}]
created: {{DATE}}
updated: {{DATE}}
url: "{{URL}}"
source_type: "web"
author: ""
publisher: ""
publication_date: ""
retrieved: {{DATE}}
license: ""
trust: medium
---

## Quelle

- URL: {{URL}}
- Abgerufen am: {{DATE}}
- Typ: web

## Kurzbeschreibung

- Worum geht es?

## Notizen

- Stichpunkte zum Inhalt
```

```markdown
---
id: {{ID}}
type: summary
title: "{{TITLE}}"
status: draft
owner: "{{OWNER}}"
parent: "{{PARENT}}"  # ID der Quelle
milestone: "{{MILESTONE}}"
tags: [knowledge, summary, {{TAGS}}]
created: {{DATE}}
updated: {{DATE}}
source_url: "{{URL}}"
provenance: "manual/agent"
confidence: medium
---

## TL;DR (1–2 Sätze)

- ...

## Wichtigste Punkte (max. 5 Bullets)

- Punkt 1
- Punkt 2
- Punkt 3
- Punkt 4
- Punkt 5

## Detaillierte Zusammenfassung (strukturierter Abriss)

- Thema A
- Thema B
- Thema C

## Evidenz & Zitate (mit Verweisen)

> "Zitat …" — Quelle/Abschnitt

## Relevanz & Anwendbarkeit für das Projekt

- Wie beeinflusst das die Vision/Spezifikation/Architektur?

## Risiken, Bias und Grenzen

- Lizenz, Urheberrecht, Verzerrungen, Aktualität

## Actionable Insights / Nächste Schritte

- Konkrete Empfehlungen

## Offene Fragen

- Noch zu klärende Punkte
```

Ausgabe: Zwei vollständige Markdown-Dateien (Quelle und Zusammenfassung) mit korrekter Frontmatter. Verlinke die Summary auf die Source via `parent`. Aktualisiere `updated`-Felder und respektiere alle Guardrails.
