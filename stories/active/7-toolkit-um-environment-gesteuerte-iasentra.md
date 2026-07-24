# Story #7 – Toolkit um Environment-gesteuerte IAS/Entra Anmeldung erweitern

- **Story:** [#7](https://github.com/MassimoSassanelli-NTTDATA/mms-solution/issues/7)
- **Story-Branch:** `story/7-toolkit-um-environment-gesteuerte-iasentra`

## Ziel

Das Toolkit so erweitern, dass Apps je Umgebung entweder SAP IAS oder Azure Entra
zur Anmeldung nutzen können – transparent für den Nutzer, gesteuert über die
konfigurierte Environment. IAS läuft über Duende, Entra über MSAL; jeder Provider in
einem eigenen optionalen Projekt.

## Sub-Tasks

Merge only after all sub-tasks have `status:done`.

- [ ] `maui-toolkit` #6 – Auth-Basis provider-agnostisch machen + Duende/IAS in eigenes Projekt auslagern
- [ ] `maui-toolkit` #7 – Neues Projekt Ndbs.MauiToolkit.Auth.Entra (MSAL) + AzureEntra-Komponente
- [ ] `maui-toolkit` #8 – Implizites Abmelden beim Environmentwechsel pro Switch entscheidbar machen
