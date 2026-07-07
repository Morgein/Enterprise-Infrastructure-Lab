# 05 - Validation Checklist


## Cross-Platform Linux-to-Windows Backup

- [x] `db-vm` connected to `EnterpriseLabNet`
- [x] `db-vm` configured with `10.10.10.40/24`
- [x] Linux resolves Windows DNS aliases
- [x] Windows SMB share mounted on Linux using CIFS
- [x] Linux backup file created under `/mnt/labshare/linux-backups`
- [x] Windows can read the Linux-generated backup file
- [x] Veeam backup job completed successfully after Linux file creation
- [x] Linux-generated file deleted from SMB share
- [x] Linux-generated file restored from Veeam backup
- [x] Restore verified from Windows
