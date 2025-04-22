param (
    [Parameter(Mandatory=$true)]
    [string[]]$Folders,

    [Parameter(Mandatory=$true)]
    [string]$ConanInstallCmd  # e.g., 'conan install . --profile=default'
)

function Backup-And-ReplaceFolders {
    foreach ($folder in $Folders) {
        $backup = "$folder.bak"
        if (Test-Path $backup) {
            Write-Host "Removing existing backup: $backup"
            Remove-Item -Recurse -Force $backup
        }

        if (Test-Path $folder) {
            Write-Host "Backing up $folder to $backup"
            Copy-Item -Recurse -Force $folder $backup
            Write-Host "Removing original folder: $folder"
            Remove-Item -Recurse -Force $folder
        } else {
            Write-Warning "Folder $folder does not exist!"
        }
    }
}

function Restore-FromBackup {
    foreach ($folder in $Folders) {
        $backup = "$folder.bak"
        if (Test-Path $backup) {
            Write-Host "Restoring backup: $backup to $folder"
            Copy-Item -Recurse -Force $backup $folder
            Remove-Item -Recurse -Force $backup
        } else {
            Write-Warning "No backup found for $folder!"
        }
    }
}

# Main logic
Backup-And-ReplaceFolders

Write-Host "Running Conan install..."
Invoke-Expression $ConanInstallCmd
if ($LASTEXITCODE -ne 0) {
    Write-Error "Conan install failed. Restoring from backups..."
    Restore-FromBackup
    exit 1
} else {
    Write-Host "Conan install succeeded. Cleaning up backups..."
    foreach ($folder in $Folders) {
        $backup = "$folder.bak"
        if (Test-Path $backup) {
            Remove-Item -Recurse -Force $backup
        }
    }
}
