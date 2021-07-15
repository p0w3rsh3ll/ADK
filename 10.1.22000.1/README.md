Download the Windows Assessment and Deployment Kit
==================================================

[Info](https://docs.microsoft.com/en-us/windows-hardware/get-started/adk-install)
> 

[What's new](https://docs.microsoft.com/en-us/windows-hardware/get-started/what-s-new-in-kits-and-tools)

Usage
-----

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy RemoteSigned -Force
# dot sourcing the function stored in get-adkfiles.ps1
.  ~/Documents\get-ADKFiles.ps1
.  ~/Documents\Get-ADKWinPEAddons.ps1
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
Import-Csv  ~/Documents\ADK-SHA256SUMS.csv -Delimiter ';' | 
Foreach-Object {

    if ( (Get-FileHash -Path (Join-Path -Path C:\Download\ADK -ChildPath $($_.File))).Hash -eq $_.Hash) {
        Write-Verbose -Message "OK: $($_.File)" -Verbose
    } else {
        Write-Warning -Message "NOK: $($_.File)"
    }
}
# ADKWinPEAddons
Import-Csv  ~/Documents\PE-SHA256SUMS.csv -Delimiter ';' | 
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
         'ADK-catalog.cat',
         'PE-catalog.cat',         
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
