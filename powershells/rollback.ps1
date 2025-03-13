$rollbackVersion = Read-Host "Enter rollback version (e.g., U1 for V1)"
$rollbackFile = "C:/Projects/MyDatabaseProject/db_migrations/down/$rollbackVersion*.sql"

if (Test-Path $rollbackFile) {
  flyway -locations="filesystem:C:/Projects/MyDatabaseProject/db_migrations/down" migrate
} else {
  Write-Host "No rollback file found for version $rollbackVersion"
}
