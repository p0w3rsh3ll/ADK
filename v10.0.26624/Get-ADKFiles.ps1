#Requires -Version 4
#Requires -RunAsAdministrator

Function Get-ADKFiles {
[CmdletBinding()]
param(
    [parameter(Mandatory)]
    [system.string]$TargetFolder
)
Begin {
    $HT = @{}
    $HT += @{ ErrorAction = 'Stop'}
    # Validate target folder
    try {
        Get-Item $TargetFolder @HT | Out-Null
    } catch {
        Write-Warning -Message "The target folder specified as parameter does not exist"
        break
    }
}

Process {
    
    $adkGenericURL = (Invoke-WebRequest -Uri http://go.microsoft.com/fwlink/?LinkID=525592  -MaximumRedirection 0 -ErrorAction SilentlyContinue)
    
    # 302 = redirect as moved temporarily
    if ($adkGenericURL.StatusCode -eq 302) {

        # Currently set to http://download.microsoft.com/download/8/1/9/8197FEB9-FABE-48FD-A537-7D8709586715/adk/
        # Resolving download root for: http://go.microsoft.com/fwlink/?LinkID=525592
        $MainURL = $adkGenericURL.Headers.Location
    
        $InstallerURLs = DATA {
            ConvertFrom-StringData @'
                0=0302dc615b0a5fd4810430b2cdacb5e3.cab
                1=036c618de505eeb40cca35afad6264f5.cab
                2=0708be5ffbe332f6a1571c929c1322a5.cab
                3=0a3a39d2f8a258e1dea4e76da0ec31b8.cab
                4=0b63b7c537782729483bff2d64a620fa.cab
                5=0c48c56ca00155f992c30167beb8f23d.cab
                6=0ce2876e9da7f82aac8755701aecfa64.cab
                7=0d981f062236baed075df3f42b1747db.cab
                8=11bdc4a4637c4d7ab86107fd13dcb9c6.cab
                9=125b1c8c81e36ec9dbe5abf370ff9919.cab
                10=1439dbcbd472f531c37a149237b300fc.cab
                11=14f4df8a2a7fc82a4f415cf6a341415d.cab
                12=186c4aa0cae637da0996e87ababf5b71.cab
                13=18e5e442fc73caa309725c0a69394a46.cab
                14=1bd4f044e271b42b110fe533720c10e9.cab
                15=1f90b0f7321fab8dcdedaba3b30415f3.cab
                16=23ca402f61cda3f672b3081da79dab63.cab
                17=24b9e5f1f97c2f05aa95ee1f671fd3cc.cab
                18=2517aec0259281507bfb693d7d136f30.cab
                19=268b1a41f6bd2906449944b964bf7393.cab
                20=27c0562eb1efb3ad282cf987ae40e873.cab
                21=2e134b026e871c5e8e547b6711578fb3.cab
                22=2e82f679c8709f838e7c839f7864ac84.cab
                23=3585b51691616d290315769bec85eb6f.cab
                24=3611bd81544efa3deb061718f15aee0c.cab
                25=36e3c2de16bbebad20daec133c22acb1.cab
                26=3814eaa1d4e897c02ac4ca93e7e7796a.cab
                27=388dee738d7d1c99d6fe776a85ee32f8.cab
                28=38d93b8047d5efb04cf01ab7ec66d090.cab
                29=3b71855dfae6a44ab353293c119908b8.cab
                30=3d610ba2a5a333717eea5f9db277718c.cab
                31=3dc1ed76e5648b575ed559e37a1052f0.cab
                32=3e602662e913edefa58e52e04e900bf8.cab
                33=3eaef6a740a72a55f4a0ac3039d05419.cab
                34=413a073d16688e177d7536cd2a64eb43.cab
                35=450f8c76ee138b1d53befd91b735652b.cab
                36=45c632fb53b95fe3bd58a6242325afa6.cab
                37=4d2878f43060bacefdd6379f2dae89b0.cab
                38=4defb086385752d8cd0d1432900fb4ca.cab
                39=4e56c6c11e546d4265da4e9ff7686b67.cab
                40=500e0afd7cc09e1e1d6daca01bc67430.cab
                41=527b957c06e68ebb115b41004f8e3ad0.cab
                42=56dd07dea070851064af5d29cadfac56.cab
                43=56e5d88e2c299be31ce4fc4a604cede4.cab
                44=57007192b3b38fcd019eb88b021e21cc.cab
                45=5775a15b7f297f3e705a74609cb21bbc.cab
                46=5ac1863798809c64e85c2535a27a3da6.cab
                47=5d984200acbde182fd99cbfbe9bad133.cab
                48=5eea85046f0c2112e2fcd0bac2c2cfc8.cab
                49=625aa8d1c0d2b6e8cf41c50b53868ecd.cab
                50=630e2d20d5f2abcc3403b1d7783db037.cab
                51=662ea66cc7061f8b841891eae8e3a67c.cab
                52=6894c1e1e549c4ab533078e3ff2e92af.cab
                53=690b8ac88bc08254d351654d56805aea.cab
                54=69f8595b00cf4081c2ecc89420610cbd.cab
                55=6a68bedadf2564eeef76c19379aae5ef.cab
                56=6bdcd388323175da70d836a25654aa92.cab
                57=6cc7aebd21947dbd8ea4884662780188.cab
                58=6d2cfb2c5343c33c8d9e54e7d1f613f9.cab
                59=6d3c63e785ac9ac618ae3f1416062098.cab
                60=6da2af86cb1227e66cf9bc85f2786782.cab
                61=6dc62760f8235e462db8f91f6eaa1d90.cab
                62=6e142759ce3a6e36e52e089caffaffe1.cab
                63=7011bf2f8f7f2df2fdd2ed7c82053d7f.cab
                64=732eefaf52275b7a708311a31c82c814.cab
                65=7608a6c73562800dd82c513d6d2dcd94.cab
                66=77adc85e5c49bbd36a91bb751dc55b39.cab
                67=781e7c95c1b6b277057c9b53b7b5a044.cab
                68=791b388183dc99f779aa6adadab92e9a.cab
                69=7a8eaeba46cc44d02a9a46fcbb641a12.cab
                70=7c11b295fb7f25c6d684b1957e96a226.cab
                71=7c195d91008a0a6ad16e535ac228467d.cab
                72=83bd1072721871ea0bdc4fab780d9382.cab
                73=84cf100ee76440117226cfb9af196ba3.cab
                74=8624feeaa6661d6216b5f27da0e30f65.cab
                75=870d7f92116bc55f7f72e7a9f5d5d6e1.cab
                76=8c9919a5e8638dd2b352b0a218939370.cab
                77=8d25d56b34194978403f6bba33f419c5.cab
                78=8f264641cdc436354282a744033e7850.cab
                79=9050f238beb90c3f2db4a387654fec4b.cab
                80=94cae441bc5628e21814208a973bbb9d.cab
                81=9722214af0ab8aa9dffb6cfdafd937b7.cab
                82=97b6e3671e2e5d03ea25df25a8056e70.cab
                83=9d2b092478d6cca70d5ac957368c00ba.cab
                84=9f0be655144a0c68c7f087465e1ad4f9.cab
                85=9f8944e2cc69646284cd07010e7eee99.cab
                86=a011a13d3157dae2dbdaa7090daa6acb.cab
                87=a03686381bcfa98a14e9c579f7784def.cab
                88=a1d26d38d4197f7873a8da3a26fc351c.cab
                89=a22d6a2483a921a887070cd800030e47.cab
                90=a29a0c716f903f42aca181dca250f681.cab
                91=a30d7a714f70ca6aa1a76302010d7914.cab
                92=a32918368eba6a062aaaaf73e3618131.cab
                93=a565f18707816c0d052281154b768ac0.cab
                94=a7eb3390a15bcd2c80a978c75f2dcc4f.cab
                95=aa25d18a5fcce134b0b89fb003ec99ff.cab
                96=aa4db181ead2227e76a3d291da71a672.cab
                97=abbeaf25720d61b6b6339ada72bdd038.cab
                98=Application Compatibility Toolkit-x64_en-us.msi
                99=Application Compatibility Toolkit-x86_en-us.msi
                100=Assessments on Client-x86_en-us.msi
                101=Assessments on Server-x86_en-us.msi
                102=b0189bdfbad208b3ac765f88f21a89df.cab
                103=b3892d561b571a5b8c81d33fbe2d6d24.cab
                104=b4687bc42d465256ad1a68aec6886f83.cab
                105=b5227bb68c3d4641d71b769e3ac606a1.cab
                106=b6758178d78e2a03e1d692660ec642bd.cab
                107=bbf55224a0290f00676ddc410f004498.cab
                108=bd00e61b3056a8aa44b48303f6fa1e62.cab
                109=be7ebc1ac434ead4ab1cf36e3921b70e.cab
                110=c300c91a497ea70c80a6d0efc9454c35.cab
                111=c36902435dc33ec7f0b63405ca9f0047.cab
                112=c6babfeb2e1e6f814e70cacb52a0f923.cab
                113=c98a0a5b63e591b7568b5f66d64dc335.cab
                114=cd23bfdfd9e3dfa8475bf59c2c5d6901.cab
                115=cfb8342932e6752026b63046a8d93845.cab
                116=d2611745022d67cf9a7703eb131ca487.cab
                117=d344672ad340db2b98b706ff06350843.cab
                118=d519967dbb262c80060d9efb5079aa23.cab
                119=d562ae79e25b943d03fc6aa7a65f9b81.cab
                120=dotNetFx45_Full_x86_x64.exe
                121=e0509d502dcdae109023403fc3bc8ac4.cab
                122=e5f4f4dc519b35948be4500a7dfeab14.cab
                123=e65f08c56c86f4e6d7e9358fa99c4c97.cab
                124=ea9c0c38594fd7df374ddfc620f4a1fd.cab
                125=eacac0698d5fa03569c86b25f90113b5.cab
                126=eb90890d25e1dee03cf79844d9f823f4.cab
                127=ec093852a41cbd9d167b714e4f4a2648.cab
                128=ed711e0a0102f1716cc073671804eb4c.cab
                129=eebe1a56de59fd5a57e26205ff825f33.cab
                130=f051f100a86ad4c94057a1d5280d9283.cab
                131=f2a850bce4500b85f37a8aaa71cbb674.cab
                132=f480ed0b7d2f1676b4c1d5fc82dd7420.cab
                133=f4e72c453e36ce0795c8c9fcaae2b190.cab
                134=f6aa96e71953e06cb7a3f69e76804b6d.cab
                135=f7699e5a82dcf6476e5ed2d8a3507ace.cab
                136=f8f7800500b180b8a2103c40ce94f56a.cab
                137=fa7c072a4c8f9cf0f901146213ebbce7.cab
                138=fbcf182748fd71a49becc8bb8d87ba92.cab
                139=fcc051e0d61320c78cac9fe4ad56a2a2.cab
                140=fd5778f772c39c09c3dd8cd99e7f0543.cab
                141=fe2c9602686dc1bcbf80a0f18bd54b49.cab
                142=fe43ba83b8d1e88cc4f4bfeac0850c6c.cab
                143=Imaging And Configuration Designer-x86_en-us.msi
                144=Imaging Tools Support-x86_en-us.msi
                145=InstallRegHiveRecoveryDriverAmd64.exe
                146=InstallRegHiveRecoveryDriverX86.exe
                147=Kits Configuration Installer-x86_en-us.msi
                148=Microsoft Compatibility Monitor-x86_en-us.msi
                149=SQLEXPR_x86_ENU.exe
                150=Toolkit Documentation-x86_en-us.msi
                151=User State Migration Tool-x86_en-us.msi
                152=Volume Activation Management Tool-x86_en-us.msi
                153=wasinstaller.exe
                154=WimMountAdkSetupAmd64.exe
                155=WimMountAdkSetupArm.exe
                156=WimMountAdkSetupX86.exe
                157=Windows Assessment Services - Client (AMD64 Architecture Specific, Client SKU)-x86_en-us.msi
                158=Windows Assessment Services - Client (AMD64 Architecture Specific, Server SKU)-x86_en-us.msi
                159=Windows Assessment Services - Client (Client SKU)-x86_en-us.msi
                160=Windows Assessment Services - Client (Server SKU)-x86_en-us.msi
                161=Windows Assessment Services - Client (X86 Architecture Specific, Client SKU)-x86_en-us.msi
                162=Windows Assessment Services-x86_en-us.msi
                163=Windows Assessment Toolkit (AMD64 Architecture Specific)-x86_en-us.msi
                164=Windows Assessment Toolkit (X86 Architecture Specific)-x86_en-us.msi
                165=Windows Assessment Toolkit-x86_en-us.msi
                166=Windows Deployment Customizations-x86_en-us.msi
                167=Windows Deployment Tools-x86_en-us.msi
                168=Windows PE x86 x64 wims-x86_en-us.msi
                169=Windows PE x86 x64-x86_en-us.msi
                170=Windows System Image Manager on amd64-x86_en-us.msi
                171=Windows System Image Manager on x86-x86_en-us.msi
                172=WP_CPTT_NT-x86-fre.msi
                173=WPT Redistributables-x86_en-us.msi
                174=WPTarm-arm_en-us.msi
                175=WPTx64-x86_en-us.msi
                176=WPTx86-x86_en-us.msi
'@
        }

        "Installers" | ForEach-Object -Process {
            # Create target folders if required as BIT doesn't accept missing folders
            If (-not(Test-Path (Join-Path -Path $TargetFolder -ChildPath $_))) {
                try {
                    New-Item -Path (Join-Path -Path $TargetFolder -ChildPath $_) -ItemType Directory -Force @HT
                } catch {
                    Write-Warning -Message "Failed to create folder $($TargetFolder)/$_"
                    break
                }
            }
        }
        # Get adksetup.exe
        try {
            Invoke-WebRequest -Uri "$($MainURL)adksetup.exe" -OutFile  "$($TargetFolder)\adksetup.exe" @HT
        } catch {
            Write-Warning -Message "Failed to download adksetup.exe because $($_.Exception.Message)"
        }
    
        # Create a job that will downlad our first file
        $job = Start-BitsTransfer -Suspended -Source "$($MainURL)Installers/$($InstallerURLs['0'])" -Asynchronous -Destination (Join-Path -Path $TargetFolder -ChildPath ("Installers/$($InstallerURLs['0'])")) 
            
        # Downlod installers
        For ($i = 1 ; $i -lt $InstallerURLs.Count ; $i++) {
            $URL = $Destination = $null
            $URL = "$($MainURL)Installers/$($InstallerURLs[$i.ToString()])"
            $Destination = Join-Path -Path (Join-Path -Path $TargetFolder -ChildPath Installers) -ChildPath (([URI]$URL).Segments[-1] -replace '%20'," ")
            # Add-BitsFile http://technet.microsoft.com/en-us/library/dd819411.aspx
            $newjob = Add-BitsFile -BitsJob $job -Source  $URL -Destination $Destination
            Write-Progress -Activity "Adding file $($newjob.FilesTotal)" -Status "Percent completed: " -PercentComplete (($newjob.FilesTotal)*100/($InstallerURLs.Count))
        } 

        # Begin the download and show us the job
        Resume-BitsTransfer  -BitsJob $job -Asynchronous
    
        # http://msdn.microsoft.com/en-us/library/windows/desktop/ee663885%28v=vs.85%29.aspx
        while ($job.JobState -in @('Connecting','Transferring','Queued')) {
            Write-Progress -activity "Downloading ADK files" -Status "Percent completed: " -PercentComplete ($job.BytesTransferred*100/$job.BytesTotal)
        } 
        Switch($job.JobState) {
             "Transferred" {
                Complete-BitsTransfer -BitsJob $job
                break
            }
             "Error" {
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