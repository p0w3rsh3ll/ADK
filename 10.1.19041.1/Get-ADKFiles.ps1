#Requires -Version 4
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
    $adkGenericURL = (Invoke-WebRequest -Uri 'https://go.microsoft.com/fwlink/?linkid=2095560' -MaximumRedirection 0 -ErrorAction SilentlyContinue)
    
    # 302 = redirect as moved temporarily
    # 301 = Moved Permanently
    if ($adkGenericURL.StatusCode -eq 302) {

        # Currently set to https://download.microsoft.com/download/8/6/c/86c218f3-4349-4aa5-beba-d05e48bbc286/adk
        # Resolving download root for: https://go.microsoft.com/fwlink/?linkid=2095560
        $MainURL = $adkGenericURL.Headers.Location

        Write-Verbose "Root URI set to $($MainURL)"

        if(-not ($MainURL.EndsWith('/'))) {
            $MainURL = "$($MainURL)/"
        }
    
        $InstallerURLs = DATA {
            ConvertFrom-StringData @'
0=01edf4d7f252a4b769447470b9829c01.cab
1=036c618de505eeb40cca35afad6264f5.cab
2=057fdee7f8823d1d8920ad2a76dd4613.cab
3=0708be5ffbe332f6a1571c929c1322a5.cab
4=09e9c7107ede618bb6c93423f313130d.cab
5=0a3a39d2f8a258e1dea4e76da0ec31b8.cab
6=0ac79ec1eacb2b6c75e7e930ee2c519f.cab
7=0c48c56ca00155f992c30167beb8f23d.cab
8=0ce2876e9da7f82aac8755701aecfa64.cab
9=0d981f062236baed075df3f42b1747db.cab
10=0e9cc2f81c324a23b9097fe77c48ba7d.cab
11=10892e7d30d8df29192b7063f0867a97.cab
12=11bdc4a4637c4d7ab86107fd13dcb9c6.cab
13=125b1c8c81e36ec9dbe5abf370ff9919.cab
14=138162d1f2774ceee5b9e192c96a3814.cab
15=1439dbcbd472f531c37a149237b300fc.cab
16=14f4df8a2a7fc82a4f415cf6a341415d.cab
17=186c4aa0cae637da0996e87ababf5b71.cab
18=194f8ff6609315c815042887c06aa3f8.cab
19=1bd4f044e271b42b110fe533720c10e9.cab
20=1ca74677209b9dcc92ebe5bbc0f3917b.cab
21=1f90b0f7321fab8dcdedaba3b30415f3.cab
22=205139c72082841bb52dfe6e300d4396.cab
23=23ca402f61cda3f672b3081da79dab63.cab
24=24b9e5f1f97c2f05aa95ee1f671fd3cc.cab
25=2517aec0259281507bfb693d7d136f30.cab
26=25680084b1f4fc98d88475554cf93f08.cab
27=25e789fdd73b4e3120cd4a7ca2fc9292.cab
28=268b1a41f6bd2906449944b964bf7393.cab
29=27c0562eb1efb3ad282cf987ae40e873.cab
30=2be308a6ad881626820550006ac7e3f6.cab
31=2d129ca39eee60f56d59a7fcbac70540.cab
32=2e134b026e871c5e8e547b6711578fb3.cab
33=2e82f679c8709f838e7c839f7864ac84.cab
34=2e841ee6ad808e471f2e298e2679e6fe.cab
35=3048e0938ba336678a30618abb5ac970.cab
36=33e8428d37f411557fa877aeac07b54a.cab
37=3585b51691616d290315769bec85eb6f.cab
38=36084f1b92cbfdad07d1fde61975509d.cab
39=3611bd81544efa3deb061718f15aee0c.cab
40=3615ccac603c2581ac34f5cf1fbb74e4.cab
41=36e3c2de16bbebad20daec133c22acb1.cab
42=3814eaa1d4e897c02ac4ca93e7e7796a.cab
43=388dee738d7d1c99d6fe776a85ee32f8.cab
44=38d93b8047d5efb04cf01ab7ec66d090.cab
45=3b71855dfae6a44ab353293c119908b8.cab
46=3e602662e913edefa58e52e04e900bf8.cab
47=3eaef6a740a72a55f4a0ac3039d05419.cab
48=413a073d16688e177d7536cd2a64eb43.cab
49=436a430b58eb0fa6110e8dfb8f07ef56.cab
50=44b84b5b8da74088361296fd441e3bd4.cab
51=450f8c76ee138b1d53befd91b735652b.cab
52=45c632fb53b95fe3bd58a6242325afa6.cab
53=473eb000fd92e570d009b4028ae116eb.cab
54=479a99aca2c1b0febb7b827e88ee4785.cab
55=47a5de534a472f7c2b34129a4f237bae.cab
56=4cf60441c7095e39c7a211cc291e7853.cab
57=4d2878f43060bacefdd6379f2dae89b0.cab
58=4defb086385752d8cd0d1432900fb4ca.cab
59=4e56c6c11e546d4265da4e9ff7686b67.cab
60=500ae334fea5d8d9c93a16515d993cd5.cab
61=500e0afd7cc09e1e1d6daca01bc67430.cab
62=526113b3700d558cc0dd65fb3690ab33.cab
63=527b957c06e68ebb115b41004f8e3ad0.cab
64=5294062b05a5b02e187a61e5979dfcc7.cab
65=52be7e8e9164388a9e6c24d01f6f1625.cab
66=537aa8c9ffa2f37021f73710d0c08297.cab
67=5697e2c360736d39a808522581166a77.cab
68=56dd07dea070851064af5d29cadfac56.cab
69=56e5d88e2c299be31ce4fc4a604cede4.cab
70=57007192b3b38fcd019eb88b021e21cc.cab
71=59e5aea2956438ad68229bfbd322b3de.cab
72=5ac1863798809c64e85c2535a27a3da6.cab
73=5c021c21180094f073528925393bb7f8.cab
74=5d984200acbde182fd99cbfbe9bad133.cab
75=5ddf3246dec9de5d773fd3923cdf0a96.cab
76=5eea85046f0c2112e2fcd0bac2c2cfc8.cab
77=5f502819c0b356ae6ffca93bd200f10d.cab
78=625aa8d1c0d2b6e8cf41c50b53868ecd.cab
79=62d5cdeca4a33f724898b7fd1c7e828d.cab
80=630e2d20d5f2abcc3403b1d7783db037.cab
81=6361319e47039c0d5fc9b61c444f75d1.cab
82=662ea66cc7061f8b841891eae8e3a67c.cab
83=666a5567d0bf1d6d15ae370af11fa53c.cab
84=68664e4371f0efe43903b61e003a1ca1.cab
85=68f184e89129d21f7c7499cd7be36a84.cab
86=68fbc6b9592338ad24ecbab6ee8afbc9.cab
87=6987a70e990dd5533eead917363935f6.cab
88=69f8595b00cf4081c2ecc89420610cbd.cab
89=6a68bedadf2564eeef76c19379aae5ef.cab
90=6a9dbde126c4c3c7987fc9746fd1271e.cab
91=6bdcd388323175da70d836a25654aa92.cab
92=6cc7aebd21947dbd8ea4884662780188.cab
93=6d2cfb2c5343c33c8d9e54e7d1f613f9.cab
94=6da2af86cb1227e66cf9bc85f2786782.cab
95=6dc62760f8235e462db8f91f6eaa1d90.cab
96=6e142759ce3a6e36e52e089caffaffe1.cab
97=7011bf2f8f7f2df2fdd2ed7c82053d7f.cab
98=70238934e63384979d80e44779baff30.cab
99=71aa6702f5f8f0dc171b3f618b774f24.cab
100=732eefaf52275b7a708311a31c82c814.cab
101=7608a6c73562800dd82c513d6d2dcd94.cab
102=767acf9ebc7b9e4a87d264eb57bd7ea7.cab
103=77adc85e5c49bbd36a91bb751dc55b39.cab
104=781e7c95c1b6b277057c9b53b7b5a044.cab
105=791b388183dc99f779aa6adadab92e9a.cab
106=7a8eaeba46cc44d02a9a46fcbb641a12.cab
107=7c11b295fb7f25c6d684b1957e96a226.cab
108=7f108a939c14abeafaf4944671ec653e.cab
109=80fe194f291624482820b412e9cc78ad.cab
110=83bd1072721871ea0bdc4fab780d9382.cab
111=84cf100ee76440117226cfb9af196ba3.cab
112=8624feeaa6661d6216b5f27da0e30f65.cab
113=870d7f92116bc55f7f72e7a9f5d5d6e1.cab
114=8774e9e67bb2b9439999d036462e313b.cab
115=882ed373fa700cc85d5dafe78832698e.cab
116=886bc4b159ab474599ddf295528247b9.cab
117=8b4d9d3700a26edb24a9e9334ec996fd.cab
118=8c29502e883d01267f9467b246aed484.cab
119=8c9919a5e8638dd2b352b0a218939370.cab
120=8d25d56b34194978403f6bba33f419c5.cab
121=8d9784f003a72e4680f33c347cff75d9.cab
122=8fc3052a6d4c133053ee527cc9285362.cab
123=9050f238beb90c3f2db4a387654fec4b.cab
124=915b9b8c059d8741e901a89f5e1ddc2c.cab
125=91cbace0d1779de011c85509644dd1f8.cab
126=941dd5f1c32c7cec49703f0dfde8eba5.cab
127=94cae441bc5628e21814208a973bbb9d.cab
128=9624f0afdfeacc987eed9cecc24d0a9a.cab
129=97b6e3671e2e5d03ea25df25a8056e70.cab
130=99b9a8e39b64be83db201f5bb8f19fcc.cab
131=9adccd836bc489e252549a89a4fa8cc3.cab
132=9cd2e822d6bd27a39739e80ce7c97a27.cab
133=9d2b092478d6cca70d5ac957368c00ba.cab
134=9f0be655144a0c68c7f087465e1ad4f9.cab
135=9f8944e2cc69646284cd07010e7eee99.cab
136=a011a13d3157dae2dbdaa7090daa6acb.cab
137=a03686381bcfa98a14e9c579f7784def.cab
138=a1d26d38d4197f7873a8da3a26fc351c.cab
139=a22d6a2483a921a887070cd800030e47.cab
140=a29a0c716f903f42aca181dca250f681.cab
141=a30d7a714f70ca6aa1a76302010d7914.cab
142=a565f18707816c0d052281154b768ac0.cab
143=a7eb3390a15bcd2c80a978c75f2dcc4f.cab
144=a85f350b213e0f1ae5792e74f3b36ca0.cab
145=aa4db181ead2227e76a3d291da71a672.cab
146=abbeaf25720d61b6b6339ada72bdd038.cab
147=ad9e485d54f4d6b44fc21f9208947341.cab
148=Application Compatibility Toolkit-x64_en-us.msi
149=Application Compatibility Toolkit-x86_en-us.msi
150=Appman Auto Sequencer-x86_en-us.msi
151=Appman Sequencer on amd64-x64_en-us.msi
152=Appman Sequencer on x86-x86_en-us.msi
153=Assessments on Client-x86_en-us.msi
154=b0189bdfbad208b3ac765f88f21a89df.cab
155=b205ceed2c8411c13fe9e2e853bd37fc.cab
156=b23352a27f081898f997944c1a0f44de.cab
157=b3892d561b571a5b8c81d33fbe2d6d24.cab
158=b38cadba7626a82b25c9defa9877a3be.cab
159=b4687bc42d465256ad1a68aec6886f83.cab
160=b5227bb68c3d4641d71b769e3ac606a1.cab
161=b6758178d78e2a03e1d692660ec642bd.cab
162=b72834f8f22e89676f88009479e1d2de.cab
163=b80e088c414c41ff73ed611b3c18874f.cab
164=bbf55224a0290f00676ddc410f004498.cab
165=bd00e61b3056a8aa44b48303f6fa1e62.cab
166=be7ebc1ac434ead4ab1cf36e3921b70e.cab
167=bf20c035f3d1577ab64bdacea9eb011c.cab
168=c300c91a497ea70c80a6d0efc9454c35.cab
169=c6babfeb2e1e6f814e70cacb52a0f923.cab
170=c7d6e564ab2de1a5e09434725946ea67.cab
171=c8a93bbadb2672b45a977d95723a6756.cab
172=c98a0a5b63e591b7568b5f66d64dc335.cab
173=c98f90e94c988845dcc6c939ab54cf24.cab
174=cb43cb685388b3f1f60b2301633c1fa6.cab
175=cd23bfdfd9e3dfa8475bf59c2c5d6901.cab
176=cfb8342932e6752026b63046a8d93845.cab
177=d2611745022d67cf9a7703eb131ca487.cab
178=d344672ad340db2b98b706ff06350843.cab
179=d519967dbb262c80060d9efb5079aa23.cab
180=d562ae79e25b943d03fc6aa7a65f9b81.cab
181=d63b8dffc336f21acdc0f97850bb5963.cab
182=d7268c5f6d37bf0eab1c45f544b26f38.cab
183=da7796173f0134f5163ad34eefcbe0d8.cab
184=dca5019b41c59cd2f3138b9c5f0a9e90.cab
185=df291961d41139beb23e8dcf2311f28c.cab
186=dotNetFx45_Full_x86_x64.exe
187=e0509d502dcdae109023403fc3bc8ac4.cab
188=e124519c7fe19f33b0b2a14eb00611f7.cab
189=e5f4f4dc519b35948be4500a7dfeab14.cab
190=e6349cc7301cf9d9a6a3a673b6b7c10f.cab
191=e7f61a72b469092c67b45ae4c5e59c38.cab
192=ea9c0c38594fd7df374ddfc620f4a1fd.cab
193=eacac0698d5fa03569c86b25f90113b5.cab
194=eb90890d25e1dee03cf79844d9f823f4.cab
195=ec093852a41cbd9d167b714e4f4a2648.cab
196=ed711e0a0102f1716cc073671804eb4c.cab
197=ee415288dc17f6f29b3dda43d57e4281.cab
198=f051f100a86ad4c94057a1d5280d9283.cab
199=f2a850bce4500b85f37a8aaa71cbb674.cab
200=f480ed0b7d2f1676b4c1d5fc82dd7420.cab
201=f4e72c453e36ce0795c8c9fcaae2b190.cab
202=f6aa96e71953e06cb7a3f69e76804b6d.cab
203=f7699e5a82dcf6476e5ed2d8a3507ace.cab
204=f8f7800500b180b8a2103c40ce94f56a.cab
205=fa7c072a4c8f9cf0f901146213ebbce7.cab
206=fbcf182748fd71a49becc8bb8d87ba92.cab
207=fcc051e0d61320c78cac9fe4ad56a2a2.cab
208=fd5778f772c39c09c3dd8cd99e7f0543.cab
209=fdfb8cfc2e4d170431fb6b8c67210672.cab
210=fe43ba83b8d1e88cc4f4bfeac0850c6c.cab
211=feadf48e9bf92b4650615d9195774178.cab
212=Imaging And Configuration Designer-x86_en-us.msi
213=Imaging Designer-x86_en-us.msi
214=Imaging Tools Support-x86_en-us.msi
215=InstallRegHiveRecoveryDriverAmd64.exe
216=InstallRegHiveRecoveryDriverX86.exe
217=Kits Configuration Installer-x86_en-us.msi
218=MXAx64-x86_en-us.msi
219=MXAx86-x86_en-us.msi
220=OEM Test Certificates-x86_en-us.msi
221=Toolkit Documentation-x86_en-us.msi
222=UEV Tools on amd64-x64_en-us.msi
223=UEV Tools on x86-x86_en-us.msi
224=User State Migration Tool-x86_en-us.msi
225=Volume Activation Management Tool-x86_en-us.msi
226=WimMountAdkSetupAmd64.exe
227=WimMountAdkSetupArm.exe
228=WimMountAdkSetupArm64.exe
229=WimMountAdkSetupX86.exe
230=Windows Assessment Toolkit (AMD64 Architecture Specific)-x86_en-us.msi
231=Windows Assessment Toolkit (X86 Architecture Specific)-x86_en-us.msi
232=Windows Assessment Toolkit-x86_en-us.msi
233=Windows Deployment Customizations-x86_en-us.msi
234=Windows Deployment Tools-x86_en-us.msi
235=Windows IP Over USB-x86_en-us.msi
236=Windows System Image Manager on amd64-x86_en-us.msi
237=Windows System Image Manager on x86-x86_en-us.msi
238=WPT Redistributables-x86_en-us.msi
239=WPTarm64-arm_en-us.msi
240=WPTarm-arm_en-us.msi
241=WPTx64-x86_en-us.msi
242=WPTx86-x86_en-us.msi
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