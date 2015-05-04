Function Get-ADKFiles that downloads the ADK (Windows Assessment and Deployment Kit)
====================================================================================

Usage
-----

```
Set-ExecutionPolicy -Scope Process -ExecutionPolicy RemoteSigned -Force
# dot sourcing the function stored in get-adkfiles.ps1
.  ~/documents\get-ADKFiles.ps1
mkdir C:\ADK\v10074
Get-ADKFiles -TargetFolder C:\ADK\v10074
```