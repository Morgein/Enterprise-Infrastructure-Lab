# Enterprise Infrastructure Lab

A hands-on infrastructure administration lab built on a Windows 11 Hyper-V host with multiple Ubuntu Server virtual machines.  
The lab demonstrates core skills used in IT administration, system administration, infrastructure operations, junior cloud engineering and DevOps-related roles.

The environment includes Linux servers, Hyper-V virtual networking, Nginx reverse proxy, Dockerized FastAPI application, PostgreSQL database server, Prometheus/Grafana monitoring, UFW firewall segmentation, backup and restore scripts, and Ansible automation.

---

## Project Purpose

The goal of this project is to simulate a small production-like infrastructure environment and practice real operational tasks such as:

- provisioning and managing virtual machines
- configuring Linux servers and network services
- separating application, proxy, database and monitoring roles
- deploying a containerized application
- configuring reverse proxy access
- securing communication between services with firewall rules
- monitoring server availability and performance
- creating database backup and restore procedures
- automating repeatable infrastructure tasks with Ansible
- documenting architecture, troubleshooting steps and operational procedures

This lab is designed to demonstrate practical infrastructure skills without using paid cloud resources.

---

## Current Status

The current version includes:

- Hyper-V based virtual lab environment
- four Ubuntu Server virtual machines
- FastAPI application deployed with Docker Compose
- Nginx reverse proxy
- PostgreSQL database server
- Prometheus and Grafana monitoring
- Node Exporter on Linux hosts
- UFW firewall rules for basic network segmentation
- Fail2ban for SSH protection
- PostgreSQL backup and restore scripts
- Ansible automation for infrastructure deployment
- documentation for networking, security, monitoring and troubleshooting

Planned enterprise extensions are listed in the [Roadmap](#roadmap) section.

---

## Architecture Overview

The lab runs on a Windows 11 machine with Hyper-V enabled.  
Each major infrastructure function is separated into its own virtual machine.

```text
Windows 11 / Hyper-V Host
        |
        | Hyper-V Virtual Network
        | Network: 192.168.0.0/24
        |
-----------------------------------------------------------------
|               |                |                 |             |
app-vm          proxy-vm         db-vm             monitoring-vm
192.168.0.110   192.168.0.111    192.168.0.112     192.168.0.113
Docker + API    Nginx Proxy      PostgreSQL        Prometheus + Grafana
```

---

## Request Flow

User traffic is routed through the reverse proxy.  
The application server communicates with the database server over the internal lab network.

```text
Windows browser / PowerShell
   ↓
http://cloudlab.local
   ↓
proxy-vm / Nginx reverse proxy
192.168.0.111
   ↓
app-vm / Dockerized FastAPI application
192.168.0.110:8080
   ↓
db-vm / PostgreSQL database
192.168.0.112:5432
```

---

## Network Plan

| VM | IP Address | Role | Main Services |
|---|---:|---|---|
| app-vm | 192.168.0.110 | Application server | Docker, FastAPI, Node Exporter |
| proxy-vm | 192.168.0.111 | Reverse proxy | Nginx, Node Exporter |
| db-vm | 192.168.0.112 | Database server | PostgreSQL, backup scripts, Node Exporter |
| monitoring-vm | 192.168.0.113 | Monitoring server | Prometheus, Grafana, Node Exporter |

Local domain mapping:

```text
192.168.0.111 cloudlab.local
```

---

## Technology Stack

### Virtualization and Infrastructure

- Hyper-V
- Ubuntu Server
- Static IP addressing
- SSH administration
- PowerShell from Windows host

### Application and Services

- FastAPI
- Docker
- Docker Compose
- Nginx reverse proxy
- PostgreSQL

### Monitoring and Operations

- Prometheus
- Grafana
- Node Exporter
- Linux service logs
- systemd timers

### Security and Access Control

- UFW firewall
- Fail2ban
- SSH hardening basics
- service-level network restrictions
- Ansible Vault for secret handling

### Automation

- Ansible
- Ansible inventory and playbooks
- Jinja2 templates
- Bash scripts

---

## Repository Structure

```text
enterprise-infrastructure-lab/
├── README.md
├── app/
│   ├── app.py
│   ├── requirements.txt
│   ├── Dockerfile
│   ├── docker-compose.yml
│   └── .env.example
├── ansible/
│   ├── inventory.ini
│   ├── playbook.yml
│   ├── group_vars/
│   │   └── all/
│   │       ├── vars.yml
│   │       └── vault.example.yml
│   └── templates/
│       └── cloudlab.conf.j2
├── nginx/
│   └── cloudlab.conf
├── monitoring/
│   ├── prometheus.yml
│   └── docker-compose.yml
├── scripts/
│   ├── backup-postgres.sh
│   └── restore-postgres.sh
├── docs/
│   ├── network.md
│   ├── security.md
│   ├── monitoring.md
│   └── troubleshooting.md
└── diagrams/
    ├── architecture.md
    ├── hyper-v-vms.png
    ├── api-health.png
    ├── api-notes.png
    ├── prometheus-targets.png
    └── grafana-dashboard.png
```

---

## Application Server

The application server runs a small FastAPI service in Docker.

```text
app-vm: 192.168.0.110
Application port: 8080
```

The application is not intended to be accessed directly by users.  
External access goes through the Nginx reverse proxy on `proxy-vm`.

### API Endpoints

| Method | Endpoint | Description |
|---|---|---|
| GET | `/` | Basic API response |
| GET | `/health` | Health check endpoint |
| POST | `/notes` | Create a note in PostgreSQL |
| GET | `/notes` | List notes stored in PostgreSQL |

### Example Requests

Health check:

```powershell
curl.exe http://cloudlab.local/health
```

Create a note:

```powershell
curl.exe -X POST "http://cloudlab.local/notes" `
  -H "Content-Type: application/json" `
  -d '{"text":"Request through Nginx reverse proxy"}'
```

List notes:

```powershell
curl.exe http://cloudlab.local/notes
```

---

## Reverse Proxy

Nginx runs on the proxy VM and forwards HTTP traffic to the application server.

```text
proxy-vm: 192.168.0.111
Nginx listens on: 80
Upstream API: http://192.168.0.110:8080
```

Nginx is used to practice:

- reverse proxy configuration
- service separation
- local DNS-style access with `cloudlab.local`
- application access through a controlled entry point
- basic troubleshooting of HTTP and upstream errors

---

## Database Server

PostgreSQL runs on a separate VM.

```text
db-vm: 192.168.0.112
PostgreSQL port: 5432
```

The database accepts connections only from the application server:

```text
app-vm: 192.168.0.110
```

PostgreSQL configuration includes:

- database installation
- user and database creation
- `listen_addresses` configuration
- `pg_hba.conf` access rules
- firewall rule for port `5432`
- backup and restore scripts

---

## Monitoring

Monitoring is implemented with Prometheus, Grafana and Node Exporter.

```text
monitoring-vm: 192.168.0.113
Prometheus: http://192.168.0.113:9090
Grafana:    http://192.168.0.113:3000
```

### Prometheus Targets

| Target | Role |
|---|---|
| 192.168.0.110:9100 | app-vm |
| 192.168.0.111:9100 | proxy-vm |
| 192.168.0.112:9100 | db-vm |
| 192.168.0.113:9100 | monitoring-vm |

Grafana uses Prometheus as its datasource:

```text
http://prometheus:9090
```

Monitoring is used to observe:

- VM availability
- CPU usage
- memory usage
- disk usage
- Linux host metrics
- service availability through Prometheus targets

---

## Backup and Restore

PostgreSQL backups are created with `pg_dump`.

Backup script:

```text
scripts/backup-postgres.sh
```

Restore script:

```text
scripts/restore-postgres.sh
```

Backups are scheduled with a systemd timer:

```text
cloudlab-db-backup.timer
```

The backup and restore part of the lab is used to practice:

- database backup creation
- restore testing
- basic recovery procedures
- service verification after restore
- operational documentation

Recommended recovery verification:

```text
1. Create test data through the API.
2. Run a PostgreSQL backup.
3. Remove or modify test data.
4. Restore the database from backup.
5. Verify that the API returns the restored data.
```

---

## Security Model

The lab uses basic network segmentation with UFW firewall rules.

### proxy-vm

Allowed:

- SSH from the lab network
- HTTP port 80 from the lab network

### app-vm

Allowed:

- SSH from the lab network
- application port 8080 only from proxy-vm `192.168.0.111`

### db-vm

Allowed:

- SSH from the lab network
- PostgreSQL port 5432 only from app-vm `192.168.0.110`

### monitoring-vm

Allowed:

- SSH from the lab network
- Prometheus port 9090 from the lab network
- Grafana port 3000 from the lab network
- Node Exporter port 9100 from the lab network

Security concepts practiced in this lab:

- least-privilege network access
- service isolation
- SSH access control
- firewall troubleshooting
- separation of public-facing and internal services
- secret handling with Ansible Vault

---

## Ansible Automation

Ansible is used to automate repeatable infrastructure configuration.

The playbook automates:

- common package installation
- Node Exporter installation
- UFW firewall configuration
- Nginx reverse proxy configuration
- Docker installation
- FastAPI application deployment with Docker Compose
- PostgreSQL installation and configuration
- PostgreSQL user and database creation
- Prometheus and Grafana deployment
- cleanup of old containers and stale port conflicts

### Inventory

```ini
[api]
api-vm ansible_host=192.168.0.110

[proxy]
proxy-vm ansible_host=192.168.0.111

[database]
db-vm ansible_host=192.168.0.112

[monitoring]
monitoring-vm ansible_host=192.168.0.113

[all:vars]
ansible_user=cloudadmin
ansible_ssh_private_key_file=~/.ssh/id_rsa
```

### Run the Full Playbook

From the `ansible/` directory:

```bash
ansible-playbook -i inventory.ini playbook.yml --ask-become-pass --ask-vault-pass
```

### Run a Specific Group

```bash
ansible-playbook -i inventory.ini playbook.yml --limit api --ask-become-pass --ask-vault-pass
ansible-playbook -i inventory.ini playbook.yml --limit proxy --ask-become-pass --ask-vault-pass
ansible-playbook -i inventory.ini playbook.yml --limit database --ask-become-pass --ask-vault-pass
ansible-playbook -i inventory.ini playbook.yml --limit monitoring --ask-become-pass --ask-vault-pass
```

---

## Secrets Management

PostgreSQL credentials are handled with Ansible Vault.

The real vault file is not committed to the repository.

Example file:

```text
ansible/group_vars/all/vault.example.yml
```

Expected variable:

```yaml
vault_postgres_password: "CHANGE_ME"
```

Create a real vault file:

```bash
cp ansible/group_vars/all/vault.example.yml ansible/group_vars/all/vault.yml
ansible-vault encrypt ansible/group_vars/all/vault.yml
```

Edit the vault file:

```bash
ansible-vault edit ansible/group_vars/all/vault.yml
```

---

## Basic Verification Commands

### Check VM Connectivity

```bash
ping 192.168.0.110
ping 192.168.0.111
ping 192.168.0.112
ping 192.168.0.113
```

### Check Nginx

```bash
sudo nginx -t
sudo systemctl status nginx
curl http://192.168.0.110:8080/health
```

### Check Docker Application

```bash
docker ps
docker logs cloudlab-api
curl http://localhost:8080/health
curl http://192.168.0.110:8080/health
```

### Check PostgreSQL

```bash
sudo systemctl status postgresql
sudo ss -lntp | grep 5432
```

### Check Prometheus Targets

Open:

```text
http://192.168.0.113:9090/targets
```

All targets should be in the `UP` state.

---

## Troubleshooting Scenarios Practiced

This lab is also used for incident troubleshooting practice.

Examples:

- API container is down
- Nginx returns `502 Bad Gateway`
- PostgreSQL is not reachable from the application server
- Docker port `8080` is already in use
- Prometheus target is down
- firewall rule blocks expected traffic
- SSH access fails
- database restore needs verification

Common diagnostic commands:

```bash
systemctl status <service>
journalctl -u <service> --no-pager -n 100
ss -lntp
ufw status numbered
docker ps
docker logs <container>
curl -v http://<host>:<port>/health
```

---

## Screenshots

### Hyper-V Virtual Machines

![Hyper-V VMs](diagrams/hyper-v-vms.png)

### API Health Check

![API Health](diagrams/api-health.png)

### API Notes Endpoint

![API Notes](diagrams/api-notes.png)

### Prometheus Targets

![Prometheus Targets](diagrams/prometheus-targets.png)

### Grafana Dashboard

![Grafana Dashboard](diagrams/grafana-dashboard.png)

---

## Skills Demonstrated

| Area | Practical Work in This Lab |
|---|---|
| Virtualization | Hyper-V virtual machines and virtual networking |
| Linux administration | Ubuntu Server setup, SSH, packages, services, logs |
| Networking | static IPs, service ports, local domain mapping, connectivity checks |
| Web infrastructure | Nginx reverse proxy and upstream troubleshooting |
| Containers | Docker and Docker Compose application deployment |
| Databases | PostgreSQL installation, access control, backup and restore |
| Security | UFW rules, Fail2ban, SSH access, service isolation |
| Monitoring | Prometheus, Grafana, Node Exporter, target verification |
| Automation | Ansible playbook, inventory, templates, Vault |
| Troubleshooting | service failures, firewall issues, port conflicts, database connectivity |
| Documentation | architecture, security, monitoring and troubleshooting docs |

---

## What I Learned

During this project, I practiced:

- designing a small multi-VM infrastructure environment
- separating infrastructure roles across dedicated servers
- configuring Linux services in a repeatable way
- deploying a containerized application behind a reverse proxy
- connecting an application to a remote PostgreSQL database
- restricting service access with firewall rules
- monitoring Linux hosts with Prometheus and Grafana
- writing backup and restore scripts
- automating infrastructure tasks with Ansible
- handling secrets with Ansible Vault
- troubleshooting port conflicts, service failures and connectivity problems
- documenting infrastructure so it can be understood and reproduced

---

## Roadmap

Planned improvements:

- Add Windows Server VM with Active Directory Domain Services, DNS, DHCP and basic Group Policy
- Add Windows client VM joined to the domain
- Add iSCSI storage lab to simulate basic SAN/storage concepts
- Add Prometheus alert rules and Alertmanager
- Add PostgreSQL exporter for database metrics
- Add cAdvisor for Docker container metrics
- Add HTTPS with a local certificate authority
- Add more incident runbooks for common infrastructure failures
- Add a tested disaster recovery procedure with documented RTO/RPO
- Rebuild the same architecture in Microsoft Azure using Terraform

---

## Target Roles

This project is relevant for the following entry-level and junior infrastructure roles:

- IT Administrator
- System Administrator
- Infrastructure Specialist
- Linux Administrator
- Junior Cloud Engineer
- Junior DevOps Engineer
- Virtualization Support Engineer
- Technical Support / L2 Infrastructure Support

---

## Summary

This project demonstrates a practical infrastructure administration environment built with Hyper-V, Linux servers, Docker, Nginx, PostgreSQL, Prometheus, Grafana, firewall segmentation, backup scripts and Ansible automation.

The main focus is not only deployment, but also day-to-day infrastructure operations: monitoring, troubleshooting, backup and restore, access control, service separation and technical documentation.
