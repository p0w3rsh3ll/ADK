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
    $adkGenericURL = (Invoke-WebRequest -Uri 'https://go.microsoft.com/fwlink/?linkid=2095641' -MaximumRedirection 0 -ErrorAction SilentlyContinue)
    
    # 302 = redirect as moved temporarily
    # 301 = Moved Permanently
    if ($adkGenericURL.StatusCode -eq 302) {

        # Currently set to https://download.microsoft.com/download/3/c/2/3c2b23b2-96a0-452c-b9fd-6df72266e335/adkwinpeaddons
        # Resolving download root for: https://go.microsoft.com/fwlink/?linkid=2095641
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
3=30dc279b59ac6b971b6da2fc87ccaed6.cab
4=35bde53afab1aa18383a056af0ce0f2a.cab
5=389fddf0856c8221b40bfa234db3f4eb.cab
6=3b8aa90b3015bd30b59330184cbbb275.cab
7=3ffff92a2c7e8b2f1a6e85afeaa027ca.cab
8=6b989bafe61434aa01ecdc53dfee4052.cab
9=755a8f59ce4582d52bc4c91761db7935.cab
10=856a378483a6c7e8068c4f52cb49227c.cab
11=8686aa39453398c3a04c1edaac29ca7a.cab
12=8a2e0a0e136870ff08761f9842218e80.cab
13=9722214af0ab8aa9dffb6cfdafd937b7.cab
14=a32918368eba6a062aaaaf73e3618131.cab
15=a6296c5a6eec9ca02b431ed0461b952d.cab
16=aa25d18a5fcce134b0b89fb003ec99ff.cab
17=b349f96e35f982019f2133020a0e1d4e.cab
18=bfdbb113d9d5201e5897ed28d0a47f42.cab
19=ce555956b885de2e50313fd305612438.cab
20=e4ef343897232361feeab2810591d8ae.cab
21=e7a23bd4ab45aa717a3e0b2fa877dce9.cab
22=f493bb83bbe844f5cd3610b0847bc113.cab
23=f53c2cdf2f5aeeaef4ca19d4b3344930.cab
24=fbb8341fa3865da250844813d461a879.cab
25=Kits Configuration Installer-x86_en-us.msi
26=Windows PE Boot Files (DesktopEditions)-x86_en-us.msi
27=Windows PE Boot Files (OnecoreUAP)-x86_en-us.msi
28=Windows PE Optional Packages (DesktopEditions)-x86_en-us.msi
29=Windows PE Scripts-x86_en-us.msi
30=Windows PE wims (DesktopEditions)-x86_en-us.msi
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