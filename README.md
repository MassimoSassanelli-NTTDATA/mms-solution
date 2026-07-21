# Mobile Maintenance Platform (`mms-solution`)

Dieses Repository ist der **Plattform-Wrapper** der Wartungs-Mobile-Lösung. Es besitzt
Epics, Stories, Architektur, ADRs, Agenten-Governance und die Copilot-Workspace-Konfiguration –
**aber keinen Produktcode**. Der Code lebt in den Sub-Repositories.

Governance-Details: [AGENTS.md](AGENTS.md) · [architecture/solution-overview.md](architecture/solution-overview.md) · [docs/process/](docs/process)

## Workspace einrichten

- **Lokal:** `./bootstrap-platform.ps1` klont die Sub-Repositories als Geschwisterordner unter `mms-solution/`.
- **Copilot Cloud Agent / CI:** [.github/workflows/copilot-setup-steps.yml](.github/workflows/copilot-setup-steps.yml) läuft automatisch, checkt alle Repos aus (`checkout_mode: all`) und **generiert zur Laufzeit** `WORKSPACE.md` und `REPOSITORY_CONTEXT.md`.

## Entwicklungsprozess

```text
discover-story → refine-story → Tasks als Sub-Issues → Story-Branch
              → start-story → start-task → validate-story → sync-story → review → merge
```

Details: [docs/process/development-process.md](docs/process/development-process.md)

## Mit den Prompts entwickeln

Prompts liegen in [.github/prompts/](.github/prompts) und werden in Copilot Chat als `/<name>` aufgerufen.
Jeder Prompt liest zuerst `REPOSITORY_CONTEXT.md`, die relevanten lokalen `AGENTS.md`/ADRs der betroffenen Repos und die im Plattform-Repo gespiegelten Skills unter `.github/skills/_subrepo_*`.

| Prompt | Zweck | Schreibt Code? |
|---|---|---|
| `/discover-story` | Rohe Idee → Story-Kandidat, betroffene Repos, offene Fragen | Nein |
| `/refine-story` | Kandidat → fertige Story + Repo-spezifische Tasks (als Sub-Issues), aktualisiert `STORY_INDEX.md` | Nein |
| `/start-story` | Fertige Tasks orchestrieren (prüft Sub-Issues + Story-Branch) | Nein |
| `/start-task` | Genau **einen** Task im zuständigen Code-Repo umsetzen | Ja (im Sub-Repo) |
| `/validate-story` | Story über alle Repos prüfen (Branch, Build/Test, Akzeptanzkriterien) | Nein |
| `/sync-story` | GitHub Issues/Sub-Issues/PRs ↔ `STORY_INDEX.md` abgleichen | Nein |

## Status & Labels (GitHub Issues)

Der Prozessstatus wird über `status:*`-Labels auf den GitHub-Issues geführt und ist
weitgehend automatisiert (Label-Sync, Task-Erzeugung, Transition-Guard,
Story-Rollup, PR→Task-Status). Label-Katalog, erlaubte Übergänge und Workflows:
[docs/process/label-model.md](docs/process/label-model.md).

## Instruktionslogik (Schichten)

1. **Plattform-Manifest** [.github/copilot-platform.json](.github/copilot-platform.json) – entscheidet über Orchestrierung, Ownership, Issue-Hierarchie und **Abhängigkeitsrichtung**.
2. **Sub-Repo `AGENTS.md` + Skills + ADRs** – entscheiden über **Implementierungskonventionen**.
3. **Akzeptierte ADRs** überschreiben ältere Vorgaben.

Bei Konflikt gilt: Plattform steuert *Orchestrierung*, Sub-Repo steuert *Umsetzung*.

| Datei | Committet? | Wer pflegt sie |
|---|---|---|
| `STORY_INDEX.md` | **Ja** (versioniert) | Nur Agenten via `refine-story` / `sync-story`. GitHub ist Source of Truth, bei Drift gewinnt GitHub. |
| `REPOSITORY_CONTEXT.md` | **Nein** (generiert) | Setup-Workflow aus dem Manifest. In `.gitignore`. |
| `WORKSPACE.md` | **Nein** (generiert) | Setup-Workflow. |

## Sub-Repositories verwalten

Registriert im Manifest unter `repositories`; ausgecheckt als Geschwisterordner (`checkoutPath`).

| Repo | Rolle | Darf abhängen von |
|---|---|---|
| `mms-app` | Mobile-App (Features/Workflows) | `maui-toolkit`, `net-client-api` |
| `maui-toolkit` | Geteilte MAUI-Controls/Themes | `net-client-api` |
| `net-client-api` | API-Clients, DTOs, Contracts | – (keine) |

Regeln (`rules` im Manifest):

- **Ein Task = ein Repo.** Repo-übergreifende Änderungen erzeugen einen expliziten Folge-Task, kein stilles Mitändern.
- **Reuse before create:** vorhandene APIs/Controls/Contracts in Abhängigkeiten zuerst suchen.
- Die **Abhängigkeitsrichtung** ist verbindlich (`net-client-api` darf nicht auf App/Toolkit zeigen).

## Sub-Repo Instruktionen & Skills bearbeiten

Die Plattform behandelt Sub-Repo-Kontext weiterhin als Source of Truth im jeweiligen Sub-Repo, spiegelt Skills aber für den Agenten-Lauf lokal nach `.github/skills` (Prefix `_subrepo_`). So änderst du sie:

1. Instruktion/Skill/ADR/Doc **im jeweiligen Sub-Repo** bearbeiten (z. B. dessen `AGENTS.md`, `.github/skills/*/SKILL.md`, `adrs/`, `docs/`).
2. Den Pfad im Manifest unter `repositories.<repo>.context` registrieren (`agentInstructions`, `skills`, `architectureDocs`, `adrs`, `buildCommands`, `testCommands`).
3. Nach Änderungen an Skills das Sync-Skript laufen lassen (direkt oder via Hook): `scripts/sync-subrepo-skills.ps1`.
4. Beim nächsten Setup-Lauf erscheint der Eintrag automatisch in `REPOSITORY_CONTEXT.md`; die gespiegelten `_subrepo_`-Skills werden lokal vom Agenten geladen.

> `REPOSITORY_CONTEXT.md` enthält pro Repo `role`, `checkoutPath`, die `context.*`-Listen und `agentGuidance` sowie die globalen `rules` als `## Platform Rules`. Ein neuer Skill/Doc wird nur sichtbar, wenn sein Pfad im `context` registriert ist.
