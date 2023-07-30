$installPackages = @(
    'vcredist140'
    'vcredist2013'
    'vcredist2012'
    'dotnetfx'
    'dotnet-6.0-desktopruntime'
    'dotnet-7.0-desktopruntime'
    '7zip'
    'everything'
    'tortoisesvn'
    'slack'
    'steam'
    'zoom'
    'windirstat'
)

function Confirm-Install($installName, $packages) {
    $caption = "Select a $installName"
    $message = "What do you want to install?"
    $choices = [System.Management.Automation.Host.ChoiceDescription[]](new-Object System.Management.Automation.Host.ChoiceDescription "&Skip","skip");

    Foreach ($p in $packages)
    {
        $choices += new-Object System.Management.Automation.Host.ChoiceDescription "&$p","$p";
    }
    $answer = $host.ui.PromptForChoice($caption,$message,$choices,0)

    if($answer -gt 0)
    {
        Write-Output $choices[$answer].HelpMessage
        $global:installPackages += $choices[$answer].HelpMessage
    }
}
    
Confirm-Install "Internet Browser" @("googlechrome","firefox","opera")
Confirm-Install "Text Editor" @("notepadplusplus","vscode")
Confirm-Install "Video Player" @("vlc","mpc-hc-clsid2")
Confirm-Install "Working from home? VPN" @("pritunl-client")

#download boxstarter
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://boxstarter.org/bootstrapper.ps1'))
#install it
Get-Boxstarter -force

#--- Windows Features ---
# Show file extensions
Set-WindowsExplorerOptions -EnableShowFileExtensions
#--- File Explorer Settings ---
# will expand explorer to the actual folder you're in
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name NavPaneExpandToCurrentFolder -Value 1
#adds things back in your left pane like recycle bin
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name NavPaneShowAllFolders -Value 1
#opens PC to This PC, not quick access
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name LaunchTo -Value 1
#restrict windows update p2p to local net only
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization" -Name "SystemSettingsDownloadMode" -Type DWord -Value 3
# Set current network to private
Set-NetConnectionProfile -NetworkCategory Private
# Disable Fast boot
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power" -Name "HiberbootEnabled" -Type DWord -Value 0

Enable-RemoteDesktop -ErrorAction SilentlyContinue

#install this outside boxstarter since it doesn't handle the vs packages
choco install visualstudio2022professional -y --package-parameters "--add Microsoft.VisualStudio.Workload.NativeDesktop Microsoft.VisualStudio.ComponentGroup.NativeDesktop.Core Microsoft.VisualStudio.Component.Windows10SDK.19041 Microsoft.VisualStudio.Component.VC.v141.x86.x64 Microsoft.VisualStudio.Component.VC.Tools.x86.x64 Microsoft.VisualStudio.Component.VC.Llvm.Clang Microsoft.VisualStudio.Component.VC.Llvm.ClangToolset Microsoft.VisualStudio.Component.VC.ASAN"

Foreach ($p in $installPackages)
{
    choco install $p -y
}
