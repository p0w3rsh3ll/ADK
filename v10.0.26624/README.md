Download the Windows Assessment and Deployment Kit
==================================================

Usage
-----

```
Set-ExecutionPolicy -Scope Process -ExecutionPolicy RemoteSigned -Force
# dot sourcing the function stored in get-adkfiles.ps1
.  ~/documents\get-ADKFiles.ps1
mkdir C:\ADK\v10
Get-ADKFiles -TargetFolder C:\ADK\v10
```

Integrity
---------

You can check the integrity of the downloaded files

```
Import-Csv  ~/documents\SHA256SUMS.csv -Delimiter ';' | Foreach-Object {

    if ( (Get-FileHash -Path (Join-Path -Path C:\ADK\v10 -ChildPath $($_.File))).Hash -eq $_.Hash) {
        Write-Verbose -Message "OK: $($_.File)" -Verbose
    } else {
        Write-Warning -Message "NOK: $($_.File)"
    }
}
```
