# 05 - Validation Checklist

## Domain Services

- [x] `enterprise.lab` domain exists
- [x] `dc-vm` is the domain controller
- [x] DNS resolves internal records
- [x] DHCP scope exists
- [x] DHCP lease issued to Windows client

## Client, GPO and SMB

- [x] `win-client-vm` joined to domain
- [x] Domain user can log in
- [x] User GPO applies
- [x] Computer GPO applies
- [x] Mapped drive `Z:` appears
- [x] User can write to SMB share

## iSCSI

- [x] `storage-vm` is in Servers OU
- [x] iSCSI Target Server installed
- [x] iSCSI targets created
- [x] Windows client iSCSI session active
- [x] Veeam repository iSCSI session active

## Veeam

- [x] Veeam Console opens
- [x] Repository configured as `R:\Backups`
- [x] SMB source added
- [x] Backup job completes successfully
- [x] File restore completes successfully

## DNS Aliases

- [x] `files.enterprise.lab` resolves to `dc-vm.enterprise.lab`
- [x] `storage.enterprise.lab` resolves to `storage-vm.enterprise.lab`
- [x] `backup.enterprise.lab` resolves to `backup-vm.enterprise.lab`
- [x] `veeam.enterprise.lab` resolves to `backup-vm.enterprise.lab`
- [x] `\\files.enterprise.lab\LabShare` is accessible

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

## Final Validation

- [x] Final health check completed on `backup-vm`
- [x] DNS aliases verified
- [x] SMB share verified
- [x] Linux backup file visible
- [x] Veeam repository volume healthy
- [x] iSCSI session active
- [x] Veeam services running
