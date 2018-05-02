Download the Windows Assessment and Deployment Kit
==================================================

Usage
-----

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy RemoteSigned -Force
# dot sourcing the function stored in get-adkfiles.ps1
.  ~/documents\get-ADKFiles.ps1
mkdir C:\ADK
Get-ADKFiles -TargetFolder C:\ADK
```

Integrity
---------

You can check the integrity of the downloaded files

```powershell
Import-Csv  ~/documents\SHA256SUMS.csv -Delimiter ";" | Foreach-Object {

    if ( (Get-FileHash -Path (Join-Path -Path C:\ADK -ChildPath $($_.File))).Hash -eq $_.Hash) {
        Write-Verbose -Message "OK: $($_.File)" -Verbose
    } else {
        Write-Warning -Message "NOK: $($_.File)"
    }
}
```

```powershell
 if ($PSVersionTable.PSVersion -gt [version]'5.1') {
     $files2Skip = @(
         'catatlog.cat',
         'SHA256SUMS.csv',
         'UserExperienceManifest.xml',
         'README.md',
         'Get-ADKFiles.ps1'
     )
     Test-FileCatalog -Path C:\ADK -CatalogFilePath C:\ADK\catalog.cat -Detailed -FilesToSkip $files2Skip
 }
```
