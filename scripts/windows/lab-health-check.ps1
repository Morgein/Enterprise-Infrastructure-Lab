# Enterprise Infrastructure Lab - Windows Health Check
# Run as Administrator on the relevant VM. Some commands are role-specific.

Write-Host "=== Basic Identity ===" -ForegroundColor Cyan
hostname
whoami

Write-Host "`n=== Network Configuration ===" -ForegroundColor Cyan
ipconfig /all

Write-Host "`n=== Domain Controller Discovery ===" -ForegroundColor Cyan
nltest /dsgetdc:enterprise.lab

Write-Host "`n=== DNS Checks ===" -ForegroundColor Cyan
nslookup enterprise.lab
nslookup dc-vm.enterprise.lab
nslookup storage-vm.enterprise.lab
nslookup backup-vm.enterprise.lab

Write-Host "`n=== SMB Share Check ===" -ForegroundColor Cyan
Test-Path "\\dc-vm\LabShare"
Get-ChildItem "\\dc-vm\LabShare" -ErrorAction SilentlyContinue

Write-Host "`n=== iSCSI Client Checks ===" -ForegroundColor Cyan
Get-Service MSiSCSI -ErrorAction SilentlyContinue
Get-IscsiSession -ErrorAction SilentlyContinue
Get-Disk
Get-Volume

Write-Host "`n=== Veeam Service Checks ===" -ForegroundColor Cyan
Get-Service | Where-Object {
    $_.Name -like "*Veeam*" -or $_.DisplayName -like "*Veeam*" -or
    $_.Name -like "*postgres*" -or $_.DisplayName -like "*postgres*"
} | Sort-Object DisplayName | Format-Table Status,Name,DisplayName -AutoSize

Write-Host "`n=== Repository Checks ===" -ForegroundColor Cyan
if (Test-Path "R:\") {
    Get-ChildItem "R:\" -ErrorAction SilentlyContinue
}
if (Test-Path "R:\Backups") {
    Get-ChildItem "R:\Backups" -Recurse -ErrorAction SilentlyContinue | Select-Object FullName,Length,LastWriteTime
}

Write-Host "`nHealth check completed." -ForegroundColor Green
