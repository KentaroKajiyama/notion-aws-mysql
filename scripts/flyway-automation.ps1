# Paths
$migrationPath = "./migrations/up"
$rollbackPath   = "./migrations/down"
$changelogPath  = "./migrations/changelog.md"

##########################################################
# Function: Update-Changelog
# Purpose:  Appends an entry to changelog.md
##########################################################
function Update-Changelog($Version, $Description, $Type, $UpFile, $DownFile) {
    $descriptionPretty = $Description -replace '_', ' '

    $entry = @"
---
### 📌 $Type Migration - V$Version : $descriptionPretty
- **Date:** $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
- **Up File:** `$UpFile`
- **Down File:** `$DownFile`
"@
    Add-Content -Path $changelogPath -Value $entry
}

##########################################################
# 1) Run Flyway migrate (up-migrations)
##########################################################
Write-Output "🚀 Running Flyway Migrate (Up Migration)..."

# Pass environment variables as CLI arguments:

flyway migrate `
  -url="jdbc:mysql://distribution-database.cxsi68guc5rq.ap-northeast-1.rds.amazonaws.com:3306/kisotetsu_03132025" `
  -user="admin" `
  -password="korowatakun22" `
  -locations="filesystem:$migrationPath"

# Capture the info output after migrate
$flywayInfoOutput = flyway info `
  -url="jdbc:mysql://distribution-database.cxsi68guc5rq.ap-northeast-1.rds.amazonaws.com:3306/kisotetsu_03132025" `
  -user="admin" `
  -password="korowatakun22"

##########################################################
# 2) Parse "Applied" lines in Flyway info
##########################################################
$appliedMigrations = $flywayInfoOutput | Select-String "Applied"

foreach ($line in $appliedMigrations) {
    if ($line -match "V(\d+)__([^\s]+)") {
        $version   = $matches[1]
        $fileName  = $matches[2]
        $upFile    = "V$version__$fileName.sql"
        $downFile  = "U$version__$fileName.sql"

        Update-Changelog -Version $version `
                         -Description $fileName `
                         -Type "UP" `
                         -UpFile $upFile `
                         -DownFile $downFile
    }
}

##########################################################
# 3) Run Flyway undo (down-migrations)
##########################################################
Write-Output "🔄 Running Flyway Undo (Down Migration)..."

flyway migrate `
  -url="jdbc:mysql://distribution-database.cxsi68guc5rq.ap-northeast-1.rds.amazonaws.com:3306/kisotetsu_03132025" `
  -user="admin" `
  -password="korowatakun22" `
  -locations="filesystem:$rollbackPath"

# Capture the info output after down-run
$flywayInfoOutput = flyway info `
  -url="jdbc:mysql://distribution-database.cxsi68guc5rq.ap-northeast-1.rds.amazonaws.com:3306/kisotetsu_03132025" `
  -user="admin" `
  -password="korowatakun22"

##########################################################
# 4) Parse "Undone" lines in Flyway info
##########################################################
$rolledBackMigrations = $flywayInfoOutput | Select-String "Undone"

foreach ($line in $rolledBackMigrations) {
    if ($line -match "U(\d+)__([^\s]+)") {
        $version   = $matches[1]
        $fileName  = $matches[2]
        $upFile    = "V$version__$fileName.sql"
        $downFile  = "U$version__$fileName.sql"

        Update-Changelog -Version $version `
                         -Description $fileName `
                         -Type "DOWN" `
                         -UpFile $upFile `
                         -DownFile $downFile
    }
}

Write-Output "✅ Migration & Changelog Updated Successfully!"
