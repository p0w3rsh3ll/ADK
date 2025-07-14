#Requires -Version 4
#Requires -RunAsAdministrator

Function Get-ADKWinPEAddonsFiles {
[CmdletBinding()]
Param(
    [parameter(Mandatory)]
    [system.string]$TargetFolder
)
Begin {

    $HT = @{ ErrorAction = 'Stop'}

    # Validate target folder
    try {
        $null = Get-Item $TargetFolder @HT
    } catch {
        Write-Warning -Message 'The target folder specified as parameter does not exist'
        break
    }
}

Process {
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $adkGenericURL = (Invoke-WebRequest -Uri 'https://go.microsoft.com/fwlink/?linkid=2223417' -MaximumRedirection 0 -ErrorAction SilentlyContinue)

    # 302 = redirect as moved temporarily
    # 301 = Moved Permanently
    if ($adkGenericURL.StatusCode -eq 302) {

        # Currently set to https://download.microsoft.com/download/4/7/6/47653b91-4dc7-46f3-ad00-e665f6ac8105/ADKWINPEADDONS/
        # Resolving download root for: https://go.microsoft.com/fwlink/?linkid=2223417
        $MainURL = $adkGenericURL.Headers.Location

        Write-Verbose "Root URI set to $($MainURL)"

        if(-not ($MainURL.EndsWith('/'))) {
            $MainURL = "$($MainURL)/"
        }

        $InstallerURLs = DATA {
            ConvertFrom-StringData @'
0=0b63b7c537782729483bff2d64a620fa.cab
1=13334584cdbf659a8dd105fc34851ea3.cab
2=24ab0f36f991590c112d8f31215bfe53.cab
3=3b8aa90b3015bd30b59330184cbbb275.cab
4=3ffff92a2c7e8b2f1a6e85afeaa027ca.cab
5=755a8f59ce4582d52bc4c91761db7935.cab
6=856a378483a6c7e8068c4f52cb49227c.cab
7=8686aa39453398c3a04c1edaac29ca7a.cab
8=9722214af0ab8aa9dffb6cfdafd937b7.cab
9=a6296c5a6eec9ca02b431ed0461b952d.cab
10=bfdbb113d9d5201e5897ed28d0a47f42.cab
11=e4ef343897232361feeab2810591d8ae.cab
12=e7a23bd4ab45aa717a3e0b2fa877dce9.cab
13=f493bb83bbe844f5cd3610b0847bc113.cab
14=f53c2cdf2f5aeeaef4ca19d4b3344930.cab
15=Kits Configuration Installer-x86_en-us.msi
16=Windows PE Boot Files (DesktopEditions)-x86_en-us.msi
17=Windows PE Boot Files (OnecoreUAP)-x86_en-us.msi
18=Windows PE Optional Packages (DesktopEditions)-x86_en-us.msi
19=Windows PE Scripts-x86_en-us.msi
20=Windows PE wims (DesktopEditions)-x86_en-us.msi
'@
        }

        'Installers' | ForEach-Object -Process {
            # Create target folders if required as BIT doesn't accept missing folders
            If (-not(Test-Path (Join-Path -Path $TargetFolder -ChildPath $_))) {
                try {
                    $null = New-Item -Path (Join-Path -Path $TargetFolder -ChildPath $_) -ItemType Directory -Force @HT
                } catch {
                    Write-Warning -Message "Failed to create folder $($TargetFolder)/$_"
                    break
                }
            }
        }
        # Get adkwinpesetup.exe
        try {
            Write-Verbose -Message "Attempt to download adkwinpesetup.exe from $($MainURL)adkwinpesetup.exe"
            Invoke-WebRequest -Uri "$($MainURL)adkwinpesetup.exe" -OutFile "$($TargetFolder)\adkwinpesetup.exe" @HT
            Write-Verbose -Message "Successfully downloaded adkwinpesetup.exe from $($MainURL)adkwinpesetup.exe"
        } catch {
            Write-Warning -Message "Failed to download adkwinpesetup.exe because $($_.Exception.Message)"
            break
        }

        # Create a job that will downlad our first file
        $ffsource = "$($MainURL)Installers/$($InstallerURLs['0'])"
        $ffdest   = (Join-Path -Path $TargetFolder -ChildPath ("Installers/$($InstallerURLs['0'])"))
        $fjobHT = @{
            Suspended = $true ;
            Asynchronous = $true
            Source = $ffsource ;
            Destination = $ffdest ;
            ErrorAction = 'Stop' ;
        }
        try {
            Write-Verbose -Message "Attempt to add to download list $($ffsource) saved to $($ffdest)"
            $job = Start-BitsTransfer @fjobHT
        } catch {
            Write-Warning -Message "Failed to create first BITS job because $($_.Exception.Message)"
            break
        }

        # Downlod installers
        For ($i = 1 ; $i -lt $InstallerURLs.Count ; $i++) {
            $URL = $Destination = $null
            $URL = "$($MainURL)Installers/$($InstallerURLs[$i.ToString()])"
            $Destination = Join-Path -Path (Join-Path -Path $TargetFolder -ChildPath Installers) -ChildPath (([URI]$URL).Segments[-1] -replace '%20'," ")
            Write-Verbose -Message "Attempt to add to download list $($URL) saved to $($Destination)"
            # Add-BitsFile http://technet.microsoft.com/en-us/library/dd819411.aspx
            $newjob = Add-BitsFile -BitsJob $job -Source  $URL -Destination $Destination
            Write-Progress -Activity "Adding file $($newjob.FilesTotal)" -Status "Percent completed: " -PercentComplete (($newjob.FilesTotal)*100/($InstallerURLs.Count))
        }

        # Begin the download and show us the job
        $null = Resume-BitsTransfer  -BitsJob $job -Asynchronous

        # http://msdn.microsoft.com/en-us/library/windows/desktop/ee663885%28v=vs.85%29.aspx
        while ($job.JobState -in @('Connecting','Transferring','Queued')) {
            Write-Progress -activity 'Downloading ADK files' -Status 'Percent completed: ' -PercentComplete ($job.BytesTransferred*100/$job.BytesTotal)
        }
        Switch($job.JobState) {
             'Transferred' {
                Complete-BitsTransfer -BitsJob $job
                Write-Verbose -Message "Successfully downloaded ADK to $($TargetFolder)"
                break
            }
             'Error' {
                # List the errors.
                $job | Format-List
            }
            default {
                # Perform corrective action.
            }
        }
    } else {
        Write-Warning -Message "Guessing the ADK location returned the status code $($adkGenericURL.StatusCode)"
    }
}
End {}
}
