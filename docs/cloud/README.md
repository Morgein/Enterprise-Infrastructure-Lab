# Linux and Cloud Lab Overview

This part of the repository contains the Linux/cloud automation stack.

## Components

| Component | Purpose |
|---|---|
| `app/` | FastAPI application and Dockerfile |
| `nginx/` | Reverse proxy configuration |
| `monitoring/` | Prometheus and Grafana configuration |
| `ansible/` | Infrastructure automation |
| `scripts/` | Backup and restore scripts |

## Planned Cleanup

Recommended future structure:

```text
docs/cloud/
├── 01-application.md
├── 02-nginx-reverse-proxy.md
├── 03-postgresql.md
├── 04-monitoring.md
└── 05-ansible-automation.md
```

## Current Focus

The Windows infrastructure module is the strongest completed part of the project.  
The Linux/cloud module can be improved next by adding clean documentation, health checks and deployment screenshots.
