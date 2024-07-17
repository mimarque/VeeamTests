# Folder Synchronization Script (PowerShell)
Veeam Powershell Script Test Task

## Overview

This PowerShell script provides a solution for synchronizing two folders: a source folder and a replica folder. The script ensures that the replica folder mirrors the exact content of the source folder, handling file creation, updates, and deletions accordingly. It also logs all synchronization operations to a specified log file for tracking and monitoring purposes.

## Features

-   **One-Way Synchronization**: Changes in the source folder are replicated to the replica folder.
-   **File and Folder Management**: Handles creation, updating, and removal of files and folders.
-   **Error Handling**: Includes try-catch blocks to manage potential errors like file permissions or deleted files during synchronization.
-   **Logging**: Logs detailed synchronization operations to a specified log file (`sync.log` by default) with timestamps.
-   **Customizable**: Allows customization of source folder, replica folder, and log file paths via command-line parameters.

## Usage

1.  **Parameters**:
    
    -   `sourceFolder`: Path to the source folder that you want to synchronize.
    -   `replicaFolder`: Path to the replica folder where changes will be mirrored.
    -   `logFile`: Path to the log file where synchronization operations will be logged.
2.  **Example Usage**:
``` .\SyncFolders.ps1 -sourceFolder "C:\Path\To\Source" -replicaFolder "D:\Path\To\Replica" -logFile "C:\Path\To\sync.log"```
3.  **Execution**:
    
    -   Run the script in a PowerShell environment.
    -   Ensure PowerShell script execution policy allows running scripts (e.g., `Set-ExecutionPolicy RemoteSigned`).
4.  **Considerations**:
    
    -   Ensure both source and replica folders exist before running the script.
    -   The script performs one-way synchronization from the source to the replica. Changes made directly in the replica folder will not be reflected back to the source.

## Requirements

-   Windows PowerShell (version 3.0 or later recommended).

## Notes

-   This script does not use external utilities like robocopy, providing a pure PowerShell solution.
-   Make sure to review and adjust file paths and folder permissions as needed for your environment.
- Please review the code before executing it
