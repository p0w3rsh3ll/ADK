#Requires -Version 5.1
#Requires -RunAsAdministrator

Function Get-ADKFiles {
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
    $adkGenericURL = (Invoke-WebRequest -Uri 'https://go.microsoft.com/fwlink/?linkid=2243860' -MaximumRedirection 0 -UseBasicParsing -ErrorAction SilentlyContinue)

    # 302 = redirect as moved temporarily
    # 301 = Moved Permanently
    if ($adkGenericURL.StatusCode -eq 302) {

        # Currently set to https://download.microsoft.com/download/5/8/6/5866fc30-973c-40c6-ab3f-2edb2fc3f727/ADK
        #  Resolving download root for: https://go.microsoft.com/fwlink/?linkid=2243860
        $MainURL = $adkGenericURL.Headers.Location

        Write-Verbose "Root URI set to $($MainURL)"

        if(-not ($MainURL.EndsWith('/'))) {
            $MainURL = "$($MainURL)/"
        }

        $InstallerURLs = DATA {
            ConvertFrom-StringData @'
0=01c28e2afff11c906894fd0d3e54ea0c.cab
1=01edf4d7f252a4b769447470b9829c01.cab
2=01fca1465219b13ba419f35fef19e47a.cab
3=02a156ff2a70e93ae2fcafa25d77c1f7.cab
4=02d4c8ffdaa6632c8f1bad53fa8843b2.cab
5=060c8936d4a55c475808092fa4e2b28b.cab
6=0a3a39d2f8a258e1dea4e76da0ec31b8.cab
7=0ab24be4ae66cd2d38e5495684e0a5a1.cab
8=0c48c56ca00155f992c30167beb8f23d.cab
9=0d981f062236baed075df3f42b1747db.cab
10=0e01877d7cebd7fc6730e1aae0091728.cab
11=0f1c8d6eb8e918847a7b1cfbda99b3e5.cab
12=10892e7d30d8df29192b7063f0867a97.cab
13=138162d1f2774ceee5b9e192c96a3814.cab
14=1439dbcbd472f531c37a149237b300fc.cab
15=14e8947966d288df0e3be47b88005ecd.cab
16=14f4df8a2a7fc82a4f415cf6a341415d.cab
17=154d4e953fccda55774e27ffbe8710a8.cab
18=186c4aa0cae637da0996e87ababf5b71.cab
19=18d637f31dd17f0b1e8ebd6b0abed487.cab
20=194f8ff6609315c815042887c06aa3f8.cab
21=1bd4f044e271b42b110fe533720c10e9.cab
22=1f90b0f7321fab8dcdedaba3b30415f3.cab
23=205139c72082841bb52dfe6e300d4396.cab
24=20d1600b963d6c4812741ca62bc491e1.cab
25=21adfb7fc4620dc041e09823a2ea9716.cab
26=22e0cfb1ed87bead097f5f1ebc85fa5e.cab
27=23ca402f61cda3f672b3081da79dab63.cab
28=24b9e5f1f97c2f05aa95ee1f671fd3cc.cab
29=2517aec0259281507bfb693d7d136f30.cab
30=252751cc5dacf45d8d98d1844e2d4f6c.cab
31=25680084b1f4fc98d88475554cf93f08.cab
32=268b1a41f6bd2906449944b964bf7393.cab
33=27c0562eb1efb3ad282cf987ae40e873.cab
34=2a6f402a7ff0a4ceccca0a660252167c.cab
35=2be308a6ad881626820550006ac7e3f6.cab
36=2e134b026e871c5e8e547b6711578fb3.cab
37=2e82f679c8709f838e7c839f7864ac84.cab
38=2e841ee6ad808e471f2e298e2679e6fe.cab
39=3048e0938ba336678a30618abb5ac970.cab
40=319d37cdfc2364311ae06e2a35924de9.cab
41=34d7210a1cf17d6ab6dd8fd5b1e3066b.cab
42=3584ff4817547e9adefc53b3233a891d.cab
43=3585b51691616d290315769bec85eb6f.cab
44=36084f1b92cbfdad07d1fde61975509d.cab
45=3611bd81544efa3deb061718f15aee0c.cab
46=3631fbcbd3bdce94e2495d17333808e1.cab
47=36e3c2de16bbebad20daec133c22acb1.cab
48=384cef345dd89a98f0fa6a6c7b6b3d3c.cab
49=38d93b8047d5efb04cf01ab7ec66d090.cab
50=3b71855dfae6a44ab353293c119908b8.cab
51=3c40aa9c4f6ccd875398dcb36e6248da.cab
52=3cb3df171c667e615400eba20d3db073.cab
53=3e3790b981292706dc3526513cb48323.cab
54=3e602662e913edefa58e52e04e900bf8.cab
55=3f3a3cff8652b3a9d93409b37e497b42.cab
56=413a073d16688e177d7536cd2a64eb43.cab
57=436a430b58eb0fa6110e8dfb8f07ef56.cab
58=47a5de534a472f7c2b34129a4f237bae.cab
59=4cf60441c7095e39c7a211cc291e7853.cab
60=4d2878f43060bacefdd6379f2dae89b0.cab
61=4e56c6c11e546d4265da4e9ff7686b67.cab
62=4f1f782affae673d2c9ccef187839f64.cab
63=500ae334fea5d8d9c93a16515d993cd5.cab
64=500e0afd7cc09e1e1d6daca01bc67430.cab
65=508826cb1992ae414951fc09c4dd5aa1.cab
66=511754b813e05f3d5aec2ea5ce2b84e2.cab
67=518501e132e499be0132182ce1fa46d1.cab
68=526113b3700d558cc0dd65fb3690ab33.cab
69=54e796616a9b92182c672bce41ccc813.cab
70=56dd07dea070851064af5d29cadfac56.cab
71=56e5d88e2c299be31ce4fc4a604cede4.cab
72=5a737ef891d34c14fcb01ab846d0d932.cab
73=5ac1863798809c64e85c2535a27a3da6.cab
74=5c021c21180094f073528925393bb7f8.cab
75=5d984200acbde182fd99cbfbe9bad133.cab
76=5eea85046f0c2112e2fcd0bac2c2cfc8.cab
77=5f502819c0b356ae6ffca93bd200f10d.cab
78=625aa8d1c0d2b6e8cf41c50b53868ecd.cab
79=62d5cdeca4a33f724898b7fd1c7e828d.cab
80=62e0546124d6356af1cd73f6a39f1a97.cab
81=630e2d20d5f2abcc3403b1d7783db037.cab
82=6361319e47039c0d5fc9b61c444f75d1.cab
83=6493517a6964895b920bd7842a30f129.cab
84=662ea66cc7061f8b841891eae8e3a67c.cab
85=68c79fbd9a119d7870fb398e0cd1b90c.cab
86=68dfe35cd89ccc6c4d08f1fe66e0961b.cab
87=68f184e89129d21f7c7499cd7be36a84.cab
88=69f8595b00cf4081c2ecc89420610cbd.cab
89=6a68bedadf2564eeef76c19379aae5ef.cab
90=6bdcd388323175da70d836a25654aa92.cab
91=6cc7aebd21947dbd8ea4884662780188.cab
92=6da2af86cb1227e66cf9bc85f2786782.cab
93=6dc62760f8235e462db8f91f6eaa1d90.cab
94=6e142759ce3a6e36e52e089caffaffe1.cab
95=7011bf2f8f7f2df2fdd2ed7c82053d7f.cab
96=732eefaf52275b7a708311a31c82c814.cab
97=7608a6c73562800dd82c513d6d2dcd94.cab
98=767acf9ebc7b9e4a87d264eb57bd7ea7.cab
99=77adc85e5c49bbd36a91bb751dc55b39.cab
100=781e7c95c1b6b277057c9b53b7b5a044.cab
101=79e66d69e463b9f04d9d2d98da1bdda1.cab
102=7a2e0aedd6d5e2ffeb7baa69b520ea7e.cab
103=7a8eaeba46cc44d02a9a46fcbb641a12.cab
104=7e6e508fe7702607bff0b24b764e4990.cab
105=82ffd11e6716eed0941e144dd5491893.cab
106=831d004a8f355684ab94810176e8d4ec.cab
107=83bd1072721871ea0bdc4fab780d9382.cab
108=84cf100ee76440117226cfb9af196ba3.cab
109=8540fa7f7b5cfd122e540053bd5240a8.cab
110=8624feeaa6661d6216b5f27da0e30f65.cab
111=870d7f92116bc55f7f72e7a9f5d5d6e1.cab
112=8774e9e67bb2b9439999d036462e313b.cab
113=886bc4b159ab474599ddf295528247b9.cab
114=8adae046d03a4d9b36093ab14d781cbe.cab
115=8ae6e3f2b02bc9aa4d16ce91ff65faf9.cab
116=8c9919a5e8638dd2b352b0a218939370.cab
117=8d25d56b34194978403f6bba33f419c5.cab
118=8d9784f003a72e4680f33c347cff75d9.cab
119=8f229e5b514b00a3afc0a17397681bde.cab
120=8f4c6e58ca3bc21c0a251ad62f891d69.cab
121=901b3fca4c41dbd30c3aa1d2b30c6d71.cab
122=9050f238beb90c3f2db4a387654fec4b.cab
123=915b9b8c059d8741e901a89f5e1ddc2c.cab
124=93b31c4dee564de581e7a00f1378aeae.cab
125=941dd5f1c32c7cec49703f0dfde8eba5.cab
126=997e08fa1159d8ef11e6f9e684a964f0.cab
127=9adccd836bc489e252549a89a4fa8cc3.cab
128=9d2b092478d6cca70d5ac957368c00ba.cab
129=9deaf43e263fecaa37191931b7ff7296.cab
130=9ed16d95c5e6b06761cda7bdc29e71fe.cab
131=9f0be655144a0c68c7f087465e1ad4f9.cab
132=9f8944e2cc69646284cd07010e7eee99.cab
133=a011a13d3157dae2dbdaa7090daa6acb.cab
134=a03686381bcfa98a14e9c579f7784def.cab
135=a1d26d38d4197f7873a8da3a26fc351c.cab
136=a22d6a2483a921a887070cd800030e47.cab
137=a29a0c716f903f42aca181dca250f681.cab
138=a30d7a714f70ca6aa1a76302010d7914.cab
139=a7eb3390a15bcd2c80a978c75f2dcc4f.cab
140=a9b2b3a68bb2defdce83b6d56890090b.cab
141=a9f72fa9efb22bcd45d7a260b1cfea27.cab
142=abbeaf25720d61b6b6339ada72bdd038.cab
143=af2fdd5d3e2de65c266eee3cf9872f9d.cab
144=Application Compatibility Toolkit-x64_en-us.msi
145=Application Compatibility Toolkit-x86_en-us.msi
146=Appman Auto Sequencer-x86_en-us.msi
147=Appman Sequencer on amd64-x64_en-us.msi
148=Appman Sequencer on x86-x86_en-us.msi
149=Assessments on Client (DesktopEditions)-x86_en-us.msi
150=Assessments on Client (OnecoreUAP)-x86_en-us.msi
151=b030a522352ccbbbc2fa88e4016c4b6e.cab
152=b1b61a66720e6e45853f71c13c134227.cab
153=b205ceed2c8411c13fe9e2e853bd37fc.cab
154=b2197baac9d94e4eb774ef11bc66233b.cab
155=b23352a27f081898f997944c1a0f44de.cab
156=b2bff1e6050294112e13849b614acf35.cab
157=b3892d561b571a5b8c81d33fbe2d6d24.cab
158=b38cadba7626a82b25c9defa9877a3be.cab
159=b4687bc42d465256ad1a68aec6886f83.cab
160=b50ca418bcca75b45d1b7a32be8ba97b.cab
161=b50e39502c26b1b66b9636983ed044c5.cab
162=b5e97e57b324181559318a9a2fa2fe80.cab
163=b6758178d78e2a03e1d692660ec642bd.cab
164=b72834f8f22e89676f88009479e1d2de.cab
165=b80e088c414c41ff73ed611b3c18874f.cab
166=bb5aa1f1c39269df2835409a8f52b50d.cab
167=bba98c61346d05faea37846d4ef28162.cab
168=bbf55224a0290f00676ddc410f004498.cab
169=BCD and Boot-x86_en-us.msi
170=bd00e61b3056a8aa44b48303f6fa1e62.cab
171=bde7112522a3e1f44d7f40bb7a283018.cab
172=be7ebc1ac434ead4ab1cf36e3921b70e.cab
173=bf20c035f3d1577ab64bdacea9eb011c.cab
174=bf7b6300431984daf850cc213043c7eb.cab
175=c22f40e58472cada1be3a64d8c202c81.cab
176=c300c91a497ea70c80a6d0efc9454c35.cab
177=c467051cd4d4b8b82d99724c5e1a3a5d.cab
178=c67e88a62ef1cb6d7b0faf010533f0d7.cab
179=c7d6e564ab2de1a5e09434725946ea67.cab
180=c8a93bbadb2672b45a977d95723a6756.cab
181=c98a0a5b63e591b7568b5f66d64dc335.cab
182=c98f90e94c988845dcc6c939ab54cf24.cab
183=c997e16c91853657131a2f6958af3cf7.cab
184=ca2a0dd24769ecef3f6889a1eb7ecb74.cab
185=cb43cb685388b3f1f60b2301633c1fa6.cab
186=cc14030de775eaeb8dbde9c6be04be40.cab
187=cd23bfdfd9e3dfa8475bf59c2c5d6901.cab
188=cd4fecfb8f7f082db3cec8b7c5455e9b.cab
189=ce699cafe1192161c5e6a00c4b16c535.cab
190=cee2f676661a3a238eedf6153d46cb1e.cab
191=cfb8342932e6752026b63046a8d93845.cab
192=cfd1e9bfbfa2edfd547c63b8d86630ff.cab
193=d15a84c48db1f6aba47403c9b5068c39.cab
194=d2611745022d67cf9a7703eb131ca487.cab
195=d2854d845dccc9ef888738dacbd8f707.cab
196=d344672ad340db2b98b706ff06350843.cab
197=d3cf4d885932e92fada0675dc52d6752.cab
198=d519967dbb262c80060d9efb5079aa23.cab
199=d562ae79e25b943d03fc6aa7a65f9b81.cab
200=d63b8dffc336f21acdc0f97850bb5963.cab
201=d727e5c6c8037b1f6c628fa2227d0bd6.cab
202=dd0ca1bac89d99ecd29f764f8ba00ceb.cab
203=dd6d04846f4eb5095edef870d4ae408e.cab
204=dfbb743df86debc6e33cdd2000cafeb8.cab
205=dotNetFx45_Full_x86_x64.exe
206=e2616196812aa14bec761a56d6567ac9.cab
207=e39af06f3e2cea568cf3e47dc590d9de.cab
208=e4dc2b54abac1a0455a410f7cf84d419.cab
209=e5f4f4dc519b35948be4500a7dfeab14.cab
210=e6349cc7301cf9d9a6a3a673b6b7c10f.cab
211=e680c0b9ab0c101fcc71698257990785.cab
212=e718eb532fa17fd014ec933dd4f131e0.cab
213=e739764d2d7f0babe3f10beef7348fa3.cab
214=e7455452ef22c741911f241c6778b85d.cab
215=e7f61a72b469092c67b45ae4c5e59c38.cab
216=e8171d0204e37ce7144ae09197584c79.cab
217=ea9c0c38594fd7df374ddfc620f4a1fd.cab
218=eacac0698d5fa03569c86b25f90113b5.cab
219=ec093852a41cbd9d167b714e4f4a2648.cab
220=ed711e0a0102f1716cc073671804eb4c.cab
221=ee415288dc17f6f29b3dda43d57e4281.cab
222=f051f100a86ad4c94057a1d5280d9283.cab
223=f2a850bce4500b85f37a8aaa71cbb674.cab
224=f480ed0b7d2f1676b4c1d5fc82dd7420.cab
225=f4e72c453e36ce0795c8c9fcaae2b190.cab
226=f7699e5a82dcf6476e5ed2d8a3507ace.cab
227=f987bcc2423899313229c1052361a8db.cab
228=fa7c072a4c8f9cf0f901146213ebbce7.cab
229=fb4caf9acea1e5ab8349e1f22377438c.cab
230=fbf606008559f00f1d8c4cc19888d744.cab
231=fcc051e0d61320c78cac9fe4ad56a2a2.cab
232=fdfb8cfc2e4d170431fb6b8c67210672.cab
233=fe43ba83b8d1e88cc4f4bfeac0850c6c.cab
234=feadf48e9bf92b4650615d9195774178.cab
235=ff859f84bde46bac68ec6719c3b9c271.cab
236=Imaging And Configuration Designer (DesktopEditions)-x86_en-us.msi
237=Imaging And Configuration Designer (OnecoreUAP)-x86_en-us.msi
238=Imaging Designer (DesktopEditions)-x86_en-us.msi
239=Imaging Designer (OnecoreUAP)-x86_en-us.msi
240=Imaging Tools Support (DesktopEditions)-x86_en-us.msi
241=Imaging Tools Support (OnecoreUAP)-x86_en-us.msi
242=Kits Configuration Installer-x86_en-us.msi
243=Modern Standby Cycle Utility (DesktopEditions)-x86_en-us.msi
244=Modern Standby Cycle Utility (OnecoreUAP)-x86_en-us.msi
245=MXAx64 (DesktopEditions)-x86_en-us.msi
246=MXAx64 (OnecoreUAP)-x86_en-us.msi
247=MXAx86 (DesktopEditions)-x86_en-us.msi
248=MXAx86 (OnecoreUAP)-x86_en-us.msi
249=OA3Tool-x86_en-us.msi
250=OACheck-x86_en-us.msi
251=OATool-x86_en-us.msi
252=OEM Test Certificates (OnecoreUAP)-x86_en-us.msi
253=Oscdimg (DesktopEditions)-x86_en-us.msi
254=Oscdimg (OnecoreUAP)-x86_en-us.msi
255=Supply Chain Trust Tools ADK-x86_en-us.msi
256=Toolkit Documentation-x86_en-us.msi
257=UEV Tools on amd64-x64_en-us.msi
258=UEV Tools on x86-x86_en-us.msi
259=User State Migration Tool (ClientCore)-x86_en-us.msi
260=User State Migration Tool (DesktopEditions)-x86_en-us.msi
261=User State Migration Tool (OnecoreUAP)-x86_en-us.msi
262=Volume Activation Management Tool-x86_en-us.msi
263=WimMountAdkSetupAmd64.exe
264=WimMountAdkSetupArm64.exe
265=WimMountAdkSetupX86.exe
266=Windows Assessment Toolkit (AMD64 Architecture Specific)-x86_en-us.msi
267=Windows Assessment Toolkit (DesktopEditions)-x86_en-us.msi
268=Windows Assessment Toolkit (OnecoreUAP)-x86_en-us.msi
269=Windows Assessment Toolkit (X86 Architecture Specific)-x86_en-us.msi
270=Windows Deployment Customizations-x86_en-us.msi
271=Windows Deployment Image Servicing and Management - Headers and Libraries-x86_en-us.msi
272=Windows Deployment Image Servicing and Management Tools (DesktopEditions)-x86_en-us.msi
273=Windows Deployment Image Servicing and Management Tools (OnecoreUAP)-x86_en-us.msi
274=Windows Deployment Tools Environment-x86_en-us.msi
275=Windows Deployment Tools-x86_en-us.msi
276=Windows Setup Files (ClientCore)-x86_en-us.msi
277=Windows Setup Files (DesktopEditions)-x86_en-us.msi
278=Windows Setup Files (Holographic)-x86_en-us.msi
279=Windows Setup Files (OnecoreUAP)-x86_en-us.msi
280=Windows Setup Files (ShellCommon)-x86_en-us.msi
281=Windows System Image Manager-x86_en-us.msi
282=WPT Redistributables-x86_en-us.msi
283=WPTarm64 (DesktopEditions)-arm64_en-us.msi
284=WPTarm64 (OnecoreUAP)-arm64_en-us.msi
285=WPTx64 (DesktopEditions)-x64_en-us.msi
286=WPTx64 (DesktopEditions)-x86_en-us.msi
287=WPTx64 (OnecoreUAP)-x64_en-us.msi
288=WPTx64 (OnecoreUAP)-x86_en-us.msi
289=WPTx86 (DesktopEditions)-x86_en-us.msi
290=WPTx86 (OnecoreUAP)-x86_en-us.msi
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
            Invoke-WebRequest -Uri "$($MainURL)adksetup.exe"  -UseBasicParsing -OutFile "$($TargetFolder)\adksetup.exe" @HT
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