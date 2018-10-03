Download the Windows Assessment and Deployment Kit
==================================================

[Info](https://docs.microsoft.com/en-us/windows-hardware/get-started/adk-install)
> Starting with Windows 10, version 1809, Windows Preinstallation Environment (PE) is released separately from the Assessment and Deployment Kit (ADK). To add Windows PE to your ADK installation, download the Windows PE Addon and run the included installer after installing the ADK. This change enables post-RTM updates to tools in the ADK. After you run the installer, the WinPE files will be in the same location as they were in previous ADK installs.

Usage
-----

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy RemoteSigned -Force
# dot sourcing the function stored in get-adkfiles.ps1
.  ~/documents\get-ADKFiles.ps1
.  ~/documents\Get-ADKWinPEAddons.ps1
mkdir C:\Download\ADK
mkdir C:\Download\ADKWinPEAddons
Get-ADKFiles -TargetFolder C:\Download\ADK
Get-ADKWinPEAddonsFiles -TargetFolder C:\Download\ADKWinPEAddons
```

Integrity
---------

You can check the integrity of the downloaded files

```powershell
# ADK
Import-Csv  ~/documents\ADK-SHA256SUMS.csv -Delimiter ";" | 
Foreach-Object {

    if ( (Get-FileHash -Path (Join-Path -Path C:\Download\ADK -ChildPath $($_.File))).Hash -eq $_.Hash) {
        Write-Verbose -Message "OK: $($_.File)" -Verbose
    } else {
        Write-Warning -Message "NOK: $($_.File)"
    }
}
# ADKWinPEAddons
Import-Csv  ~/documents\PE-SHA256SUMS.csv -Delimiter ";" | 
Foreach-Object {
    if ( (Get-FileHash -Path (Join-Path -Path C:\Download\ADKWinPEAddons -ChildPath $($_.File))).Hash -eq $_.Hash) {
        Write-Verbose -Message "OK: $($_.File)" -Verbose
    } else {
        Write-Warning -Message "NOK: $($_.File)"
    }
}
```

```powershell
 if ($PSVersionTable.PSVersion -gt [version]'5.1') 
 {
     $files2Skip = @(
         'ADK-catatlog.cat',
         'PE-catatlog.cat',         
         'ADK-SHA256SUMS.csv',
         'PE-SHA256SUMS.csv',         
         'UserExperienceManifest.xml',
         'README.md',
         'Get-ADKFiles.ps1',
         'Get-ADKWinPEAddons.ps1'
     )

     # ADK
     Test-FileCatalog -Path C:\Download\ADK -CatalogFilePath C:\Download\ADK-catalog.cat -Detailed -FilesToSkip $files2Skip

     # ADKWinPEAddons
     Test-FileCatalog -Path C:\Download\ADKWinPEAddons -CatalogFilePath C:\Download\PE-catalog.cat -Detailed -FilesToSkip $files2Skip
 }
```
