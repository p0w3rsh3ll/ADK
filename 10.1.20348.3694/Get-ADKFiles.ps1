#Requires -Version 5.1
#Requires -RunAsAdministrator

Function Get-ADKFile {
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
    $adkGenericURL = (Invoke-WebRequest -Uri 'https://go.microsoft.com/fwlink/?linkid=2147554' -MaximumRedirection 0 -ErrorAction SilentlyContinue)

    # 302 = redirect as moved temporarily
    # 301 = Moved Permanently
    if ($adkGenericURL.StatusCode -eq 302) {

        # Currently set to https://download.microsoft.com/download/e52143d0-aa4a-4115-a67a-e80de550e5f7/adk
        # Resolving download root for: https://go.microsoft.com/fwlink/?linkid=2147554
        $MainURL = $adkGenericURL.Headers.Location

        Write-Verbose "Root URI set to $($MainURL)"

        if(-not ($MainURL.EndsWith('/'))) {
            $MainURL = "$($MainURL)/"
        }

        $InstallerURLs = DATA {
            ConvertFrom-StringData @'
0=0014e86877cc1e91d48fdeccbd18f9d9.cab
1=01c28e2afff11c906894fd0d3e54ea0c.cab
2=01edf4d7f252a4b769447470b9829c01.cab
3=02a156ff2a70e93ae2fcafa25d77c1f7.cab
4=02d4c8ffdaa6632c8f1bad53fa8843b2.cab
5=09e9c7107ede618bb6c93423f313130d.cab
6=0a3a39d2f8a258e1dea4e76da0ec31b8.cab
7=0ab24be4ae66cd2d38e5495684e0a5a1.cab
8=0ac79ec1eacb2b6c75e7e930ee2c519f.cab
9=0c48c56ca00155f992c30167beb8f23d.cab
10=0d981f062236baed075df3f42b1747db.cab
11=0f1c8d6eb8e918847a7b1cfbda99b3e5.cab
12=10892e7d30d8df29192b7063f0867a97.cab
13=1439dbcbd472f531c37a149237b300fc.cab
14=14e8947966d288df0e3be47b88005ecd.cab
15=14f4df8a2a7fc82a4f415cf6a341415d.cab
16=186c4aa0cae637da0996e87ababf5b71.cab
17=18d637f31dd17f0b1e8ebd6b0abed487.cab
18=194f8ff6609315c815042887c06aa3f8.cab
19=1f90b0f7321fab8dcdedaba3b30415f3.cab
20=205139c72082841bb52dfe6e300d4396.cab
21=21adfb7fc4620dc041e09823a2ea9716.cab
22=22e0cfb1ed87bead097f5f1ebc85fa5e.cab
23=23ca402f61cda3f672b3081da79dab63.cab
24=24b9e5f1f97c2f05aa95ee1f671fd3cc.cab
25=2517aec0259281507bfb693d7d136f30.cab
26=25680084b1f4fc98d88475554cf93f08.cab
27=26880fd396fc2c93727cbb45733589ce.cab
28=268b1a41f6bd2906449944b964bf7393.cab
29=2a6f402a7ff0a4ceccca0a660252167c.cab
30=2be308a6ad881626820550006ac7e3f6.cab
31=2e841ee6ad808e471f2e298e2679e6fe.cab
32=3048e0938ba336678a30618abb5ac970.cab
33=3585b51691616d290315769bec85eb6f.cab
34=36084f1b92cbfdad07d1fde61975509d.cab
35=3611bd81544efa3deb061718f15aee0c.cab
36=3631fbcbd3bdce94e2495d17333808e1.cab
37=36e3c2de16bbebad20daec133c22acb1.cab
38=388dee738d7d1c99d6fe776a85ee32f8.cab
39=38d93b8047d5efb04cf01ab7ec66d090.cab
40=3b71855dfae6a44ab353293c119908b8.cab
41=3e3790b981292706dc3526513cb48323.cab
42=3f3a3cff8652b3a9d93409b37e497b42.cab
43=413a073d16688e177d7536cd2a64eb43.cab
44=436a430b58eb0fa6110e8dfb8f07ef56.cab
45=47a5de534a472f7c2b34129a4f237bae.cab
46=4b56bf982974157df6281909ac6f7b1c.cab
47=4cf60441c7095e39c7a211cc291e7853.cab
48=4d2878f43060bacefdd6379f2dae89b0.cab
49=4defb086385752d8cd0d1432900fb4ca.cab
50=4e56c6c11e546d4265da4e9ff7686b67.cab
51=4f1f782affae673d2c9ccef187839f64.cab
52=500ae334fea5d8d9c93a16515d993cd5.cab
53=500e0afd7cc09e1e1d6daca01bc67430.cab
54=518501e132e499be0132182ce1fa46d1.cab
55=526113b3700d558cc0dd65fb3690ab33.cab
56=537aa8c9ffa2f37021f73710d0c08297.cab
57=56dd07dea070851064af5d29cadfac56.cab
58=56e5d88e2c299be31ce4fc4a604cede4.cab
59=5718b3a1537d248131a2521846a718b2.cab
60=59e5aea2956438ad68229bfbd322b3de.cab
61=5a737ef891d34c14fcb01ab846d0d932.cab
62=5ac1863798809c64e85c2535a27a3da6.cab
63=5c021c21180094f073528925393bb7f8.cab
64=5d984200acbde182fd99cbfbe9bad133.cab
65=5f502819c0b356ae6ffca93bd200f10d.cab
66=625aa8d1c0d2b6e8cf41c50b53868ecd.cab
67=62e0546124d6356af1cd73f6a39f1a97.cab
68=630e2d20d5f2abcc3403b1d7783db037.cab
69=6361319e47039c0d5fc9b61c444f75d1.cab
70=6493517a6964895b920bd7842a30f129.cab
71=662ea66cc7061f8b841891eae8e3a67c.cab
72=68dfe35cd89ccc6c4d08f1fe66e0961b.cab
73=68f184e89129d21f7c7499cd7be36a84.cab
74=69f8595b00cf4081c2ecc89420610cbd.cab
75=6a9dbde126c4c3c7987fc9746fd1271e.cab
76=6bdcd388323175da70d836a25654aa92.cab
77=6cc7aebd21947dbd8ea4884662780188.cab
78=6da2af86cb1227e66cf9bc85f2786782.cab
79=6dc62760f8235e462db8f91f6eaa1d90.cab
80=7011bf2f8f7f2df2fdd2ed7c82053d7f.cab
81=70238934e63384979d80e44779baff30.cab
82=732eefaf52275b7a708311a31c82c814.cab
83=77adc85e5c49bbd36a91bb751dc55b39.cab
84=781e7c95c1b6b277057c9b53b7b5a044.cab
85=7e6e508fe7702607bff0b24b764e4990.cab
86=831d004a8f355684ab94810176e8d4ec.cab
87=83bd1072721871ea0bdc4fab780d9382.cab
88=8540fa7f7b5cfd122e540053bd5240a8.cab
89=8624feeaa6661d6216b5f27da0e30f65.cab
90=870d7f92116bc55f7f72e7a9f5d5d6e1.cab
91=8774e9e67bb2b9439999d036462e313b.cab
92=886bc4b159ab474599ddf295528247b9.cab
93=8adae046d03a4d9b36093ab14d781cbe.cab
94=8d9784f003a72e4680f33c347cff75d9.cab
95=8f4c6e58ca3bc21c0a251ad62f891d69.cab
96=901b3fca4c41dbd30c3aa1d2b30c6d71.cab
97=9050f238beb90c3f2db4a387654fec4b.cab
98=915b9b8c059d8741e901a89f5e1ddc2c.cab
99=941dd5f1c32c7cec49703f0dfde8eba5.cab
100=9adccd836bc489e252549a89a4fa8cc3.cab
101=9ed16d95c5e6b06761cda7bdc29e71fe.cab
102=a011a13d3157dae2dbdaa7090daa6acb.cab
103=a03686381bcfa98a14e9c579f7784def.cab
104=a1d26d38d4197f7873a8da3a26fc351c.cab
105=a22d6a2483a921a887070cd800030e47.cab
106=a30d7a714f70ca6aa1a76302010d7914.cab
107=a7eb3390a15bcd2c80a978c75f2dcc4f.cab
108=a9b2b3a68bb2defdce83b6d56890090b.cab
109=abbeaf25720d61b6b6339ada72bdd038.cab
110=ae5e0f51b591d16bb9ebff997e2c5b67.cab
111=Application Compatibility Toolkit-x64_en-us.msi
112=Application Compatibility Toolkit-x86_en-us.msi
113=Appman Auto Sequencer-x86_en-us.msi
114=Appman Sequencer on amd64-x64_en-us.msi
115=Appman Sequencer on x86-x86_en-us.msi
116=Assessments on Client (DesktopEditions)-x86_en-us.msi
117=Assessments on Client (OnecoreUAP)-x86_en-us.msi
118=b23352a27f081898f997944c1a0f44de.cab
119=b23c58d02dd618582bcf79a7d99a4df0.cab
120=b2bff1e6050294112e13849b614acf35.cab
121=b3892d561b571a5b8c81d33fbe2d6d24.cab
122=b38cadba7626a82b25c9defa9877a3be.cab
123=b50ca418bcca75b45d1b7a32be8ba97b.cab
124=b5e97e57b324181559318a9a2fa2fe80.cab
125=b6758178d78e2a03e1d692660ec642bd.cab
126=b72834f8f22e89676f88009479e1d2de.cab
127=b80e088c414c41ff73ed611b3c18874f.cab
128=bbf55224a0290f00676ddc410f004498.cab
129=BCD and Boot-x86_en-us.msi
130=be7ebc1ac434ead4ab1cf36e3921b70e.cab
131=bf20c035f3d1577ab64bdacea9eb011c.cab
132=bf7b6300431984daf850cc213043c7eb.cab
133=c22f40e58472cada1be3a64d8c202c81.cab
134=c467051cd4d4b8b82d99724c5e1a3a5d.cab
135=c7d6e564ab2de1a5e09434725946ea67.cab
136=c8a93bbadb2672b45a977d95723a6756.cab
137=c98a0a5b63e591b7568b5f66d64dc335.cab
138=ca2a0dd24769ecef3f6889a1eb7ecb74.cab
139=cc14030de775eaeb8dbde9c6be04be40.cab
140=cd23bfdfd9e3dfa8475bf59c2c5d6901.cab
141=ce699cafe1192161c5e6a00c4b16c535.cab
142=cee2f676661a3a238eedf6153d46cb1e.cab
143=cf740d5fd5a14d35763a6468192ad1a7.cab
144=cfb8342932e6752026b63046a8d93845.cab
145=d2611745022d67cf9a7703eb131ca487.cab
146=d2854d845dccc9ef888738dacbd8f707.cab
147=d442964630599664dc64f6693d98f527.cab
148=d519967dbb262c80060d9efb5079aa23.cab
149=d562ae79e25b943d03fc6aa7a65f9b81.cab
150=d63b8dffc336f21acdc0f97850bb5963.cab
151=dca5019b41c59cd2f3138b9c5f0a9e90.cab
152=dd0ca1bac89d99ecd29f764f8ba00ceb.cab
153=dfbb743df86debc6e33cdd2000cafeb8.cab
154=dotNetFx45_Full_x86_x64.exe
155=e2616196812aa14bec761a56d6567ac9.cab
156=e5f4f4dc519b35948be4500a7dfeab14.cab
157=e6349cc7301cf9d9a6a3a673b6b7c10f.cab
158=e739764d2d7f0babe3f10beef7348fa3.cab
159=e7455452ef22c741911f241c6778b85d.cab
160=e7f61a72b469092c67b45ae4c5e59c38.cab
161=ea9c0c38594fd7df374ddfc620f4a1fd.cab
162=eacac0698d5fa03569c86b25f90113b5.cab
163=ed711e0a0102f1716cc073671804eb4c.cab
164=ee415288dc17f6f29b3dda43d57e4281.cab
165=f2a850bce4500b85f37a8aaa71cbb674.cab
166=f480ed0b7d2f1676b4c1d5fc82dd7420.cab
167=f7699e5a82dcf6476e5ed2d8a3507ace.cab
168=fa7c072a4c8f9cf0f901146213ebbce7.cab
169=fcc051e0d61320c78cac9fe4ad56a2a2.cab
170=fdfb8cfc2e4d170431fb6b8c67210672.cab
171=fe43ba83b8d1e88cc4f4bfeac0850c6c.cab
172=feadf48e9bf92b4650615d9195774178.cab
173=ff859f84bde46bac68ec6719c3b9c271.cab
174=Imaging And Configuration Designer (DesktopEditions)-x86_en-us.msi
175=Imaging And Configuration Designer (OnecoreUAP)-x86_en-us.msi
176=Imaging Designer (DesktopEditions)-x86_en-us.msi
177=Imaging Designer (OnecoreUAP)-x86_en-us.msi
178=Imaging Tools Support (DesktopEditions)-x86_en-us.msi
179=Imaging Tools Support (OnecoreUAP)-x86_en-us.msi
180=InstallRegHiveRecoveryDriverAmd64.exe
181=InstallRegHiveRecoveryDriverX86.exe
182=Kits Configuration Installer-x86_en-us.msi
183=MXAx64 (DesktopEditions)-x86_en-us.msi
184=MXAx64 (OnecoreUAP)-x86_en-us.msi
185=MXAx86 (DesktopEditions)-x86_en-us.msi
186=MXAx86 (OnecoreUAP)-x86_en-us.msi
187=OA3Tool-x86_en-us.msi
188=OACheck-x86_en-us.msi
189=OATool-x86_en-us.msi
190=OEM Test Certificates (OnecoreUAP)-x86_en-us.msi
191=Oscdimg (DesktopEditions)-x86_en-us.msi
192=Oscdimg (OnecoreUAP)-x86_en-us.msi
193=Toolkit Documentation-x86_en-us.msi
194=UEV Tools on amd64-x64_en-us.msi
195=UEV Tools on x86-x86_en-us.msi
196=User State Migration Tool (ClientCore)-x86_en-us.msi
197=User State Migration Tool (DesktopEditions)-x86_en-us.msi
198=User State Migration Tool (OnecoreUAP)-x86_en-us.msi
199=Volume Activation Management Tool-x86_en-us.msi
200=WimMountAdkSetupAmd64.exe
201=WimMountAdkSetupX86.exe
202=Windows Assessment Toolkit (AMD64 Architecture Specific)-x86_en-us.msi
203=Windows Assessment Toolkit (DesktopEditions)-x86_en-us.msi
204=Windows Assessment Toolkit (OnecoreUAP)-x86_en-us.msi
205=Windows Assessment Toolkit (X86 Architecture Specific)-x86_en-us.msi
206=Windows Deployment Customizations-x86_en-us.msi
207=Windows Deployment Image Servicing and Management - Headers and Libraries-x86_en-us.msi
208=Windows Deployment Image Servicing and Management Tools (DesktopEditions)-x86_en-us.msi
209=Windows Deployment Image Servicing and Management Tools (OnecoreUAP)-x86_en-us.msi
210=Windows Deployment Tools Environment-x86_en-us.msi
211=Windows Deployment Tools-x86_en-us.msi
212=Windows IP Over USB-x86_en-us.msi
213=Windows Setup Files (ClientCore)-x86_en-us.msi
214=Windows Setup Files (DesktopEditions)-x86_en-us.msi
215=Windows Setup Files (Holographic)-x86_en-us.msi
216=Windows Setup Files (OnecoreUAP)-x86_en-us.msi
217=Windows Setup Files (ShellCommon)-x86_en-us.msi
218=Windows System Image Manager on amd64-x86_en-us.msi
219=Windows System Image Manager on x86-x86_en-us.msi
220=WPT Redistributables-x86_en-us.msi
221=WPTarm (DesktopEditions)-arm_en-us.msi
222=WPTarm (OnecoreUAP)-arm_en-us.msi
223=WPTarm64 (DesktopEditions)-arm_en-us.msi
224=WPTarm64 (OnecoreUAP)-arm_en-us.msi
225=WPTx64 (DesktopEditions)-x86_en-us.msi
226=WPTx64 (OnecoreUAP)-x86_en-us.msi
227=WPTx86 (DesktopEditions)-x86_en-us.msi
228=WPTx86 (OnecoreUAP)-x86_en-us.msi
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
        # Get adksetup.exe
        try {
            Write-Verbose -Message "Attempt to download adksetup.exe from $($MainURL)adksetup.exe"
            Invoke-WebRequest -Uri "$($MainURL)adksetup.exe" -OutFile "$($TargetFolder)\adksetup.exe" @HT
            Write-Verbose -Message "Successfully downloaded adksetup.exe from $($MainURL)adksetup.exe"
        } catch {
            Write-Warning -Message "Failed to download adksetup.exe because $($_.Exception.Message)"
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