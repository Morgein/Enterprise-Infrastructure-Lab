# How to Apply This Structure Refresh

1. Extract this ZIP into the root of the repository.
2. Allow files like `README.md` and `docs/windows-ad.md` to be replaced.
3. Existing screenshots do not need to be moved.
4. Commit the changes:

```powershell
git status
git add README.md docs/ diagrams/README.md scripts/windows/
git commit -m "Reorganize project documentation structure"
git push
```

This update does not delete the old documentation. The full Windows report is preserved as:

```text
docs/windows/full-report.md
```
