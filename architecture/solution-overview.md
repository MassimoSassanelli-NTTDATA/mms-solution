# Solution Overview

## Platform

`mobile-maintenance-platform` is the wrapper around the maintenance mobile solution. It provides planning, governance, architecture, and Copilot workspace setup.

## Code Repositories

```text
mobile-app
 ├── maui-toolkit
 ├── net-client-api

maui-toolkit
 └── net-client-api

net-client-api
 └── no platform dependencies
```

## Dependency Direction

Allowed:

```text
mobile-app -> maui-toolkit
mobile-app -> net-client-api
maui-toolkit -> net-client-api
```

Not allowed:

```text
net-client-api -> maui-toolkit
net-client-api -> mobile-app
maui-toolkit -> mobile-app
```
