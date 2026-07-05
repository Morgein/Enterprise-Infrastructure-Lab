# How to Apply DNS Aliases Documentation Update

Extract this ZIP into the root of the repository.

It adds/updates:

```text
README.md
docs/README.md
docs/architecture.md
docs/windows/README.md
docs/windows/05-validation-checklist.md
docs/windows/06-dns-aliases.md
diagrams/README.md
diagrams/windows-server/54-dns-cname-records.png
diagrams/windows-server/55-dns-alias-resolution.png
diagrams/windows-server/56-file-share-access-via-dns-alias.png
diagrams/windows-server/57-veeam-alias-access-check.png
```

Commit:

```powershell
git status
git add README.md docs/ diagrams/
git commit -m "Add DNS service aliases documentation"
git push
```
