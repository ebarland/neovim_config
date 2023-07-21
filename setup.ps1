#nvim setup script
#May have to run: Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Unrestricted

Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
ECHO 'Y' | choco install git.install
ECHO 'Y' | choco install ripgrep 
ECHO 'Y' | choco install fd

#install windows terminal
#download https://www.nerdfonts.com/font-downloads JetBrainsMono.zip