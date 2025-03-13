# Paths
$projectPath    = "C:/Users/jesus/OneDrive/Documents/VScode/Repositories/01-study/aws_mysql/migrations"
$rollbackPath   = Join-Path $projectPath "db_migrations/down"
$changelogPath  = Join-Path $projectPath "changelog.md"

##########################################################
# Function: Update-Changelog
# Purpose:  Appends an entry to changelog.md
# Params:
#   -Version:    Numeric version extracted from Flyway naming
#   -Description: Original description (with spaces or underscores)
#   -Type:       "UP" or "DOWN"
#   -UpFile:     The actual up-migration filename
#   -DownFile:   The rollback (down-migration) filename
##########################################################
function Update-Changelog($Version, $Description, $Type, $UpFile, $DownFile) {
    # For display in the changelog, let's replace underscores with spaces
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
flyway migrate

# Capture the info output after migrate
$flywayInfoOutput = flyway info

##########################################################
# 2) Parse "Applied" lines in Flyway info
#    We look for lines containing "Applied" and matching
#    the standard pattern: V(\d+)__description
##########################################################
$appliedMigrations = $flywayInfoOutput | Select-String "Applied"

foreach ($line in $appliedMigrations) {
    if ($line -match "V(\d+)__([^\s]+)") {
        $version         = $matches[1]
        $fileName        = $matches[2]    # This still has underscores
        # The corresponding rollback file is presumably named U{version}__{same_description}.sql
        $upFile          = "V$version__$fileName.sql"
        $downFile        = "U$version__$fileName.sql"
        
        # Update the changelog for each newly applied migration
        Update-Changelog -Version $version `
                         -Description $fileName `
                         -Type "UP" `
                         -UpFile $upFile `
                         -DownFile $downFile
    }
}

##########################################################
# 3) Run Flyway undo (down-migrations)
#    If you have a Flyway edition that doesn't support undo,
#    your "down" folder might just be a separate location
#    with negative versions or something akin. In that case,
#    you'd do: flyway -locations="filesystem:$rollbackPath" migrate
#    We'll keep your approach as-is.
##########################################################
Write-Output "🔄 Running Flyway Undo (Down Migration)..."
flyway -locations="filesystem:$rollbackPath" migrate

# Capture the info output after down-run
$flywayInfoOutput = flyway info

##########################################################
# 4) Parse "Undone" lines in Flyway info
#    We look for lines containing "Undone" and matching
#    the standard pattern: U(\d+)__description
##########################################################
$rolledBackMigrations = $flywayInfoOutput | Select-String "Undone"

foreach ($line in $rolledBackMigrations) {
    if ($line -match "U(\d+)__([^\s]+)") {
        $version   = $matches[1]
        $fileName  = $matches[2]
        # The "down" file is U{version}__{description}, so to reference the original up-file:
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
