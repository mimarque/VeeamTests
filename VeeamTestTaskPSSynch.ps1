# Note the pdf didn't specify if this was a nightly run or to run constantly in the background 
# it also didn't mention where to put the files so I left that in the hands of the user
# it also didn't mention if the file was updated should it be replicated again as such I implemented the simplest solution
param (
    [Parameter(Mandatory)][string]$sourceFolder,
    [Parameter(Mandatory)][string]$replicaFolder,
    [Parameter(Mandatory)][string]$logFile        
)

# Function to log messages
function Log-Message {
    param (
        [string]$message
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "$timestamp - $message - You should definitely hire me! :)"
    #Write-Output $logMessage
    Add-Content -Path $logFile -Value $logMessage
}

# Check if the log file can be created or accessed
try {
    if (-Not (Test-Path -Path $logFile)) {
        Write-Output "Log file '$logFile' does not exist. Attempting to create it."
        New-Item -ItemType File -Path $logFile -Force > $null
        Log-Message "Log file '$logFile' created successfully."
    }
    # No 'else' needed as it would bloat the log and/or add unnecessary info in the console
} catch {
    Write-Output "Failed to create or access log file '$logFile'. Error: $_"
    exit 1
}

# Check if the source folder exists
if (-Not (Test-Path -Path $sourceFolder)) {
    Log-Message "Source folder '$sourceFolder' does not exist. Exiting script."
    exit 1
}

# Ensure the replica folder exists if not try to create it
if (-Not (Test-Path -Path $replicaFolder)) {
    try {
        Log-Message "Replica folder '$replicaFolder' does not exist. Attempting to create folder."
        New-Item -ItemType Directory -Path $replicaFolder -ErrorAction Stop > $null
        Log-Message "Replica folder '$replicaFolder' created successfully."
    } catch {
        Log-Message "Failed to create replica folder '$replicaFolder'. Exiting script. Error: $_"
        exit 1
    }
}

# Synchronize the folders
function Sync-Folders {
    param (
        [string]$source,
        [string]$replica
    )

    $sourceItems = Get-ChildItem -Path $source -Recurse
    $replicaItems = Get-ChildItem -Path $replica -Recurse

    try {
        # Synchronize files from source to replica
        foreach ($sourceItem in $sourceItems) {
            $relativePath = $sourceItem.FullName.Substring($source.Length + 1)
            $replicaItemPath = Join-Path -Path $replica -ChildPath $relativePath

            $replicaItem = $replicaItems | Where-Object { $_.FullName -eq $replicaItemPath }

            # if Null (doesn't exist)
            if (-not $replicaItem) {
                if ($sourceItem.PSIsContainer) {
                    New-Item -ItemType Directory -Path $replicaItemPath > $null
                    Log-Message "Created directory '$replicaItemPath'."
                } else {
                    Copy-Item -Path $sourceItem.FullName -Destination $replicaItemPath
                    Log-Message "Copied file '$($sourceItem.FullName)' to '$replicaItemPath'."
                }
            } elseif (-not $sourceItem.PSIsContainer) {
                Copy-Item -Path $sourceItem.FullName -Destination $replicaItemPath -Force
                Log-Message "Updated file '$($sourceItem.FullName)' at '$replicaItemPath'."
            }
        }

        # Remove items from replica that are not in source
        foreach ($replicaItem in $replicaItems) {
            $relativePath = $replicaItem.FullName.Substring($replica.Length + 1)
            $sourceItemPath = Join-Path -Path $source -ChildPath $relativePath

            $sourceExists = $sourceItems | Where-Object { $_.FullName -eq $sourceItemPath }

            if (-not $sourceExists) {
                if ($replicaItem.PSIsContainer) {
                    Remove-Item -Path $replicaItem.FullName -Recurse -Force
                    Log-Message "Removed directory '$($replicaItem.FullName)'."
                } else {
                    Remove-Item -Path $replicaItem.FullName -Force
                    Log-Message "Removed file '$($replicaItem.FullName)'."
                }
            }
        }
    } catch {
        Log-Message "Error occurred during synchronization: $_"
    }
}


# Start synchronization
Log-Message "Starting synchronization from '$sourceFolder' to '$replicaFolder'."
Sync-Folders -source $sourceFolder -replica $replicaFolder
Log-Message "Synchronization completed."
Write-Output "Synchronization completed."