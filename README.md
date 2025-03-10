# Run PowerShell as admin and copy/paste this in:
```
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://github.com/Hello-Games/windows-setup/raw/master/dev-setup.ps1'))
```
