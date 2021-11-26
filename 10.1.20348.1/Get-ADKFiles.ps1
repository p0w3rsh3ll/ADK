#Requires -Version 4
#Requires -RunAsAdministrator

Function Get-ADKFile {
[CmdletBinding()]
Param(
    [parameter(Mandatory)]
    [system.string]$TargetFolder,

    [switch]$OnlySetupFile

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
    $adkGenericURL = (Invoke-WebRequest -Uri 'https://go.microsoft.com/fwlink/?linkid=2147554' -MaximumRedirection 0 -ErrorAction SilentlyContinue)

    # 302 = redirect as moved temporarily
    # 301 = Moved Permanently
    if ($adkGenericURL.StatusCode -eq 302) {

        # Currently set to https://download.microsoft.com/download/b/9/8/b98fd877-f00f-49e3-8abb-77784cdae268/adk
        # Resolving download root for: https://go.microsoft.com/fwlink/?linkid=2147554
        $MainURL = $adkGenericURL.Headers.Location

        Write-Verbose "Root URI set to $($MainURL)"

        if(-not ($MainURL.EndsWith('/'))) {
            $MainURL = "$($MainURL)/"
        }

        # Get adksetup.exe
        try {
            Write-Verbose -Message "Attempt to download adksetup.exe from $($MainURL)adksetup.exe"
            Invoke-WebRequest -Uri "$($MainURL)adksetup.exe" -OutFile "$($TargetFolder)\adksetup.exe" @HT
            Write-Verbose -Message "Successfully downloaded adksetup.exe from $($MainURL)adksetup.exe"
        } catch {
            Write-Warning -Message "Failed to download adksetup.exe because $($_.Exception.Message)"
            break
        }
    } else {
        Write-Warning -Message "Guessing the ADK location returned the status code $($adkGenericURL.StatusCode)"
    }

 if (-not($OnlySetupFile)) {
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $IsoGenericURL = (Invoke-WebRequest -Uri 'https://go.microsoft.com/fwlink/?linkid=2162950' -MaximumRedirection 0 -ErrorAction SilentlyContinue)

    # 302 = redirect as moved temporarily
    # 301 = Moved Permanently
    if ($IsoGenericURL.StatusCode -eq 302) {

        # Currently set to https://software-download.microsoft.com/download/sg/20348.1.210507-1500.fe_release_amd64fre_ADK.iso
        $MainIsoURL = $IsoGenericURL.Headers.Location
        Write-Verbose "Root URI set to $($MainIsoURL)"

        # Create a job that will downlad our first file
        $ffsource = $MainIsoURL
        $ffdest   = (Join-Path -Path $TargetFolder -ChildPath "$(([URI]$MainIsoURL).Segments[-1])")
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

        # Begin the download and show us the job
        $null = Resume-BitsTransfer  -BitsJob $job -Asynchronous

        # http://msdn.microsoft.com/en-us/library/windows/desktop/ee663885%28v=vs.85%29.aspx
        while ($job.JobState -in @('Connecting','Transferring','Queued')) {
            Write-Progress -activity 'Downloading ADK ISO file' -Status 'Percent completed: ' -PercentComplete ($job.BytesTransferred*100/$job.BytesTotal)
        }
        Switch($job.JobState) {
             'Transferred' {
                Complete-BitsTransfer -BitsJob $job
                Write-Verbose -Message "Successfully downloaded ADK ISO file to $($TargetFolder)"
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
        Write-Warning -Message "Guessing the ADK iso location returned the status code $($IsoGenericURL.StatusCode)"
    }
 }
}
End {}
}