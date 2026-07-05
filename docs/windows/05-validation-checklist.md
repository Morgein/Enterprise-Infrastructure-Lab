# 05 - Validation Checklist

Use this checklist to prove that the lab is functional.

## Domain Services

- [x] `enterprise.lab` domain exists
- [x] `dc-vm` is domain controller
- [x] DNS resolves `enterprise.lab`
- [x] DHCP scope exists
- [x] DHCP lease issued to client

## Client and GPO

- [x] `win-client-vm` joined to domain
- [x] `testuser01` can log in
- [x] User GPO applies
- [x] Computer GPO applies
- [x] Mapped drive `Z:` appears
- [x] User can write to `\\dc-vm\LabShare`

## iSCSI

- [x] `storage-vm` in Servers OU
- [x] iSCSI Target Server installed
- [x] `LabLUN01.vhdx` created
- [x] `lab-iscsi-target` connected
- [x] Client iSCSI session active
- [x] Client volume `I:` formatted as NTFS
- [x] iSCSI write test completed

## Veeam

- [x] `backup-vm` joined to domain
- [x] Veeam Console opens
- [x] iSCSI repository volume `R:` connected
- [x] Repository configured as `R:\Backups`
- [x] SMB source `\\dc-vm\LabShare` added
- [x] Backup job completed successfully
- [x] Backup files visible on repository
- [x] Source file deleted
- [x] File restored from backup
- [x] Restored file verified


## DNS Aliases

- [x] `files.enterprise.lab` resolves to `dc-vm.enterprise.lab`
- [x] `storage.enterprise.lab` resolves to `storage-vm.enterprise.lab`
- [x] `backup.enterprise.lab` resolves to `backup-vm.enterprise.lab`
- [x] `veeam.enterprise.lab` resolves to `backup-vm.enterprise.lab`
- [x] `\\files.enterprise.lab\LabShare` is accessible
