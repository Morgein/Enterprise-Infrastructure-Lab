# Runbook - Veeam File Restore Procedure

## Goal

Restore a deleted file from the Veeam backup of `\\dc-vm\LabShare`.

## 1. Verify source share

```powershell
dir "\\dc-vm\LabShare"
```

## 2. Open restore point

In Veeam:

```text
Home
→ Backups
→ Disk
→ select Backup LabShare to iSCSI Repository
→ Restore files
```

## 3. Select file

Find the deleted file:

```text
veeam-source-test.txt
```

## 4. Restore

```text
Right click file
→ Restore
→ Restore to original location
```

## 5. Verify restore

```powershell
dir "\\dc-vm\LabShare"
type "\\dc-vm\LabShare\veeam-source-test.txt"
```

Expected:

```text
The restored file is visible and content is readable.
```
