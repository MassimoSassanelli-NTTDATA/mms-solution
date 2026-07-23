One task belongs to one repository. Shared changes require explicit tasks. Tasks must be sub-issues of the story.

## Cross-Repository Interfaces

Wenn eine Story Schnittstellen zwischen Repositories betrifft
(Interface, DTO, HTTP-Route, Message-Contract, NuGet-Package), wird die Story
nach folgendem Muster in Tasks zerlegt:

1. **Contract-Task** im Producer-Repository
   - Definiert die öffentliche Signatur: Interface, DTOs, Fehlercodes, Beispiel-Payloads.
   - Enthält keine Consumer-Implementierung.
   - Acceptance Criterion: „Öffentliche Signatur ist im PR-Review bestätigt und dokumentiert." → **Contract frozen**.
   - Darf mit dem Implementation-Task zusammengelegt werden, wenn der Umfang klein ist und es nur einen Consumer gibt.
2. **Implementation-Task** im Producer-Repository
   - Implementiert den gefreezten Contract inkl. Tests.
3. **Release-Task** im Producer-Repository (nur wenn Auslieferung nicht Teil des Merges ist)
   - Version-Bump, Package-Publish (z. B. NuGet), Release-Tag.
   - Nötig z. B. für `net-client-api` → `mms-app`, weil `mms-app` per NuGet konsumiert.
4. **Consumer-Task** im nutzenden Repository
   - `Hängt ab von: <Contract-Task> (frozen)` – erlaubt parallelen Start ab Contract-Freeze.
   - Der finale PR-Merge des Consumers wartet auf den Release-Task (falls vorhanden).

## Contract-Status

Der `Contract-Status` im optionalen Task-Body-Abschnitt `### Cross-Repository Interface`
(siehe [`../../.github/prompts/refine-story.prompt.md`](../../.github/prompts/refine-story.prompt.md))
signalisiert, ab wann abhängige Tasks starten dürfen:

| Status     | Bedeutung                                                        | Consumer darf starten? |
|------------|------------------------------------------------------------------|------------------------|
| `draft`    | Contract wird noch entworfen, Signatur kann sich ändern.         | Nein                   |
| `frozen`   | Contract ist im PR-Review bestätigt; Signatur ändert sich nicht mehr. | Ja – Implementierung gegen Contract erlaubt. |
| `released` | Producer ist implementiert und (falls nötig) ausgeliefert.       | Ja – Consumer-PR mergefähig. |

Nach dem Freeze dürfen Producer-PRs den Contract nicht mehr brechen. Änderungen
am gefreezten Contract erfordern einen neuen Contract-Task und Abstimmung mit
allen Consumer-Tasks.

## Dependency-Richtung

Die Abhängigkeitsrichtung zwischen Repositories folgt dem Dependency-Graph aus
`.github/copilot-platform.json`. Reverse- oder Sideways-Dependencies sind nicht
zulässig. Wenn eine geplante Schnittstelle die erlaubte Richtung verletzt, ist
die Story vor der Task-Erstellung neu zu schneiden.
