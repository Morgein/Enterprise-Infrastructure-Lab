# Enterprise Infrastructure Lab

A hands-on infrastructure administration lab built on Hyper-V with Linux servers, Docker, Nginx, PostgreSQL, Prometheus, Grafana, firewall segmentation, backup and restore scripts, and Ansible automation.

The project simulates a small enterprise infrastructure environment and focuses on practical day-to-day operations: server deployment, service separation, monitoring, troubleshooting, backup and restore, access control, and technical documentation.

---

## Project Scope

This lab demonstrates practical infrastructure administration skills across several core areas:

- Virtual machine provisioning and network planning with Hyper-V
- Linux server administration and service troubleshooting
- Static IP configuration and VM-to-VM connectivity
- Reverse proxy configuration with Nginx
- Dockerized application deployment
- PostgreSQL database deployment and remote access configuration
- Firewall segmentation with UFW
- Monitoring with Prometheus, Grafana and Node Exporter
- PostgreSQL backup and restore procedures
- Infrastructure automation with Ansible
- Secrets management with Ansible Vault
- Technical documentation and operational troubleshooting

---

## Documentation

- [Windows Server Active Directory, DNS and DHCP Module](docs/windows-ad.md)

---

## Architecture Overview

The lab runs on a Windows 11 Hyper-V host. Several Ubuntu Server virtual machines are connected through a local lab network.

```text
Windows 11 / Hyper-V Host
        |
        | Hyper-V Virtual Network
        | Network: 192.168.0.0/24
        |
-----------------------------------------------------
|              |              |                     |
app-vm         proxy-vm       db-vm                 monitoring-vm
192.168.0.110  192.168.0.111  192.168.0.112         192.168.0.113
Docker + API   Nginx Proxy    PostgreSQL            Prometheus + Grafana
```

The infrastructure is separated by server role. Each VM has a dedicated purpose, which makes the environment easier to troubleshoot, secure, monitor and document.

---

## Network Plan

| VM | IP Address | Role |
|---|---:|---|
| app-vm | 192.168.0.110 | Dockerized FastAPI application |
| proxy-vm | 192.168.0.111 | Nginx reverse proxy |
| db-vm | 192.168.0.112 | PostgreSQL database server |
| monitoring-vm | 192.168.0.113 | Prometheus and Grafana server |

---

## Windows Server Module

The lab also includes a separate Windows Server infrastructure module for enterprise administration practice.

| VM | IP Address | Role |
|---|---:|---|
| dc-vm | 10.10.10.10 | Windows Server 2022, Active Directory Domain Services, DNS, DHCP |

This module uses a separate Hyper-V internal network:

```text
Hyper-V switch: EnterpriseLabNet
Network: 10.10.10.0/24
Domain: enterprise.lab
NetBIOS name: ENTERPRISE
Domain Controller: dc-vm.enterprise.lab
DHCP Scope: 10.10.10.100 - 10.10.10.200
DNS Server for clients: 10.10.10.10
```

Detailed documentation and screenshots are available here:

```text
docs/windows-ad.md
```

---

## Request Flow

User requests are routed through the reverse proxy. The application communicates with the database over the internal lab network.

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

The application is not accessed directly by users. External access goes through the Nginx reverse proxy.

---

## Technology Stack

| Area | Technologies |
|---|---|
| Virtualization | Hyper-V |
| Operating system | Ubuntu Server, Windows Server 2022 |
| Reverse proxy | Nginx |
| Application runtime | Docker, Docker Compose |
| Application | FastAPI |
| Database | PostgreSQL |
| Firewall | UFW |
| Security hardening | Fail2ban, SSH hardening, restricted service access |
| Monitoring | Prometheus, Grafana, Node Exporter |
| Automation | Ansible, Ansible Vault |
| Scripting | Bash, PowerShell |
| Administration | SSH, SCP, systemd, Linux logs, Active Directory Users and Computers, DNS Manager, DHCP Manager |

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
│   ├── troubleshooting.md
│   └── windows-ad.md
└── diagrams/
    ├── architecture.md
    ├── hyper-v-vms.png
    ├── api-health.png
    ├── api-notes.png
    ├── prometheus-targets.png
    ├── grafana-dashboard.png
    └── windows-server/
        ├── 01-server-manager-ad-dns.png
        ├── 02-active-directory-domain.png
        ├── 03-dns-forward-zone.png
        ├── 04-powershell-ad-dns-verification.png
        ├── 05-hyperv-dc-vm-checkpoint.png
        ├── 06-dc-vm-network-config.png
        ├── 07-server-manager-dhcp.png
        ├── 08-dhcp-addresses-pool.png
        ├── 09-dhcp-scope-options.png
        ├── 10-dhcp-powershell-verification.png
        └── 11-hyperv-dhcp-checkpoint.png
```

---

## Application Component

The application is a small FastAPI service connected to PostgreSQL.

The API runs on the application VM:

```text
192.168.0.110:8080
```

User traffic reaches the API through the Nginx reverse proxy:

```text
http://cloudlab.local
```

### API Endpoints

| Method | Endpoint | Description |
|---|---|---|
| GET | `/` | Basic API message |
| GET | `/health` | Health check endpoint |
| POST | `/notes` | Create a note in PostgreSQL |
| GET | `/notes` | List notes from PostgreSQL |

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

Nginx runs on the proxy VM:

```text
proxy-vm: 192.168.0.111
```

It forwards HTTP requests to the application VM:

```text
http://192.168.0.110:8080
```

Local name resolution is configured with:

```text
192.168.0.111 cloudlab.local
```

The reverse proxy provides a single access point for the application and keeps direct application access separated from user traffic.

---

## PostgreSQL Database Server

PostgreSQL runs on a dedicated VM:

```text
db-vm: 192.168.0.112
```

The database accepts connections only from the application VM:

```text
app-vm: 192.168.0.110
```

PostgreSQL configuration includes:

- PostgreSQL installation
- remote listening configuration
- `pg_hba.conf` access rules
- database and user creation
- privilege configuration
- UFW rule allowing port `5432` only from the application VM

Expected PostgreSQL listening address:

```text
192.168.0.112:5432
```

---

## Security and Network Segmentation

The lab uses basic network segmentation with UFW firewall rules. Each VM exposes only the ports required for its role.

### proxy-vm

Allowed:

- SSH from the lab network
- HTTP port `80` from the lab network

### app-vm

Allowed:

- SSH from the lab network
- Application port `8080` only from proxy-vm `192.168.0.111`

### db-vm

Allowed:

- SSH from the lab network
- PostgreSQL port `5432` only from app-vm `192.168.0.110`

### monitoring-vm

Allowed:

- SSH from the lab network
- Prometheus port `9090` from the lab network
- Grafana port `3000` from the lab network
- Node Exporter port `9100` from the lab network

This setup reduces unnecessary exposure between services and makes troubleshooting easier.

---

## Monitoring

Monitoring is implemented with Prometheus, Grafana and Node Exporter.

The monitoring stack runs on:

```text
monitoring-vm: 192.168.0.113
```

### Monitored Targets

| Target | Role |
|---|---|
| 192.168.0.110:9100 | app-vm |
| 192.168.0.111:9100 | proxy-vm |
| 192.168.0.112:9100 | db-vm |
| 192.168.0.113:9100 | monitoring-vm |

Prometheus is available inside the lab network:

```text
http://192.168.0.113:9090
```

Grafana is available inside the lab network:

```text
http://192.168.0.113:3000
```

Grafana uses Prometheus as a datasource:

```text
http://prometheus:9090
```

Monitoring is used to verify host availability, resource usage and basic infrastructure health.

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

The backup and restore process is documented to practice operational recovery, not only deployment.

---

## Ansible Automation

Infrastructure configuration is automated with Ansible.

The playbook automates:

- common package installation
- Node Exporter installation
- UFW firewall rules
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

PostgreSQL credentials are managed with Ansible Vault.

The real vault file is not committed to Git.

Example file:

```text
ansible/group_vars/all/vault.example.yml
```

Expected variable:

```yaml
vault_postgres_password: "CHANGE"
```

Create a real vault file:

```bash
cp ansible/group_vars/all/vault.example.yml ansible/group_vars/all/vault.yml
ansible-vault encrypt ansible/group_vars/all/vault.yml
```

Edit it later:

```bash
ansible-vault edit ansible/group_vars/all/vault.yml
```

---

## Operational Verification

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

## Troubleshooting Practice

This lab was also used to practice common infrastructure troubleshooting scenarios:

- VM connectivity issues
- incorrect static IP or gateway configuration
- Nginx reverse proxy errors
- API container downtime
- Docker port conflicts
- stale `docker-proxy` processes
- PostgreSQL remote connection failures
- firewall rule misconfiguration
- service restart and log analysis
- Prometheus target availability issues

Troubleshooting notes are documented in:

```text
docs/troubleshooting.md
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

### Windows Server AD DS, DNS and DHCP

Detailed Windows Server screenshots are documented in:

```text
docs/windows-ad.md
```

---

## Skills Demonstrated

This project demonstrates hands-on experience with:

- Linux server administration
- virtualized lab infrastructure
- infrastructure service separation
- Nginx reverse proxy configuration
- Docker and Docker Compose deployment
- PostgreSQL administration basics
- firewall segmentation
- monitoring and observability basics
- backup and restore scripting
- Ansible automation
- secrets management
- service troubleshooting
- infrastructure documentation
- Windows Server domain controller configuration
- Active Directory Domain Services basics
- DNS zone verification and domain name resolution
- DHCP Server configuration and scope options

---

## Roadmap

Planned improvements:

- Create Organizational Units, users and groups
- Add a Windows client joined to the domain
- Configure basic Group Policy Objects
- Add iSCSI storage simulation
- Add Prometheus alert rules and Alertmanager
- Add PostgreSQL exporter
- Add Docker container monitoring with cAdvisor
- Add HTTPS with a local certificate authority
- Add documented recovery testing with RTO/RPO
- Rebuild the same architecture in Microsoft Azure using Terraform

---

## Project Status

Current status: active lab project.

The existing environment covers Linux server administration, reverse proxying, Docker application deployment, PostgreSQL, monitoring, firewall segmentation, backup scripts and Ansible automation.

The Windows Server module currently includes a Windows Server 2022 domain controller with Active Directory Domain Services, DNS and DHCP for the `enterprise.lab` domain.

The next major improvement is to extend the Windows Server module with Organizational Units, users, groups, a domain-joined Windows client and basic Group Policy Objects.
