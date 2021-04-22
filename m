Return-Path: <rebecca@bsdio.com>
From: Rebecca Cran <rebecca@bsdio.com>
Date: Wed, 21 Apr 2021 20:32:25 -0600
Message-Id: <20210422023226.935-1-rebecca@bsdio.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Subject: [PATCH] The GPL isn't a EULA: remove it and introduce WixUI_Minimal_NoEULA
To: Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org
Cc: Rebecca Cran <rebecca@bsdio.com>
List-ID: <fio@vger.kernel.org>

The GPL shouldn't be used as a EULA in an installer.
Remove it, and since the WixUI_Minimal dialog set requires a EULA
create a custom WixUI_Minimal_NoEULA set.

Signed-off-by: Rebecca Cran <rebecca@bsdio.com>
---
 os/windows/WixUI_Minimal_NoEULA.wxs |  96 ++++++++++++++++++++++++++++++++=
++++++++++++++++++++++++++++++++++++++++++++++++
 os/windows/WixUI_fio.wxl            |  12 ++++++++++
 os/windows/dobuild.cmd              |   5 ++++-
 os/windows/eula.rtf                 | Bin 1075 -> 0 bytes
 os/windows/install.wxs              |   2 +-
 5 files changed, 113 insertions(+), 2 deletions(-)

diff --git a/os/windows/WixUI_Minimal_NoEULA.wxs b/os/windows/WixUI_Minimal=
_NoEULA.wxs
new file mode 100755
index 00000000..48391186
--- /dev/null
+++ b/os/windows/WixUI_Minimal_NoEULA.wxs
@@ -0,0 +1,96 @@
+<?xml version=3D"1.0" encoding=3D"UTF-8"?>=0D
+<!-- Copyright (c) .NET Foundation and contributors. All rights reserved. =
Licensed under the Microsoft Reciprocal License. See LICENSE.TXT file in th=
e project root for full license information. -->=0D
+=0D
+=0D
+=0D
+<!--=0D
+First-time install dialog sequence:=0D
+ - WixUI_MyWelcomeDlg=0D
+Maintenance dialog sequence:=0D
+ WixUI_MaintenanceWelcomeDlg=0D
+ - WixUI_MaintenanceTypeDlg=0D
+ - WixUI_VerifyReadyDlg=0D
+-->=0D
+=0D
+<Wix xmlns=3D"http://schemas.microsoft.com/wix/2006/wi">=0D
+  <Fragment>=0D
+    <UI Id=3D"WixUI_Minimal_NoEULA">=0D
+      <TextStyle Id=3D"WixUI_Font_Normal" FaceName=3D"Tahoma" Size=3D"8" /=
>=0D
+      <TextStyle Id=3D"WixUI_Font_Bigger" FaceName=3D"Tahoma" Size=3D"12" =
/>=0D
+      <TextStyle Id=3D"WixUI_Font_Title" FaceName=3D"Tahoma" Size=3D"9" Bo=
ld=3D"yes" />=0D
+=0D
+      <Property Id=3D"DefaultUIFont" Value=3D"WixUI_Font_Normal" />=0D
+      <Property Id=3D"WixUI_Mode" Value=3D"Minimal" />=0D
+=0D
+      <DialogRef Id=3D"ErrorDlg" />=0D
+      <DialogRef Id=3D"FatalError" />=0D
+      <DialogRef Id=3D"FilesInUse" />=0D
+      <DialogRef Id=3D"MsiRMFilesInUse" />=0D
+      <DialogRef Id=3D"PrepareDlg" />=0D
+      <DialogRef Id=3D"ProgressDlg" />=0D
+      <DialogRef Id=3D"ResumeDlg" />=0D
+      <DialogRef Id=3D"UserExit" />=0D
+      <DialogRef Id=3D"MyWelcomeDlg" />=0D
+=0D
+      <Dialog Id=3D"MyWelcomeDlg" Width=3D"370" Height=3D"270" Title=3D"!(=
loc.WelcomeDlg_Title)">=0D
+          <Control Id=3D"Install" Type=3D"PushButton" ElevationShield=3D"y=
es" X=3D"236" Y=3D"243" Width=3D"56" Height=3D"17" Default=3D"yes" Hidden=
=3D"yes" Text=3D"!(loc.WelcomeEulaDlgInstall)" >=0D
+            <Publish Property=3D"WixUI_InstallMode" Value=3D"Update">Insta=
lled AND PATCH</Publish>=0D
+            <Publish Event=3D"SpawnWaitDialog" Value=3D"WaitForCostingDlg"=
>!(wix.WixUICostingPopupOptOut) OR CostingComplete =3D 1</Publish>=0D
+            <Publish Event=3D"EndDialog" Value=3D"Return"><![CDATA[OutOfDi=
skSpace <> 1]]></Publish>=0D
+            <Publish Event=3D"SpawnDialog" Value=3D"OutOfRbDiskDlg">OutOfD=
iskSpace =3D 1 AND OutOfNoRbDiskSpace =3D 0 AND (PROMPTROLLBACKCOST=3D"P" O=
R NOT PROMPTROLLBACKCOST)</Publish>=0D
+            <Publish Event=3D"EndDialog" Value=3D"Return">OutOfDiskSpace =
=3D 1 AND OutOfNoRbDiskSpace =3D 0 AND PROMPTROLLBACKCOST=3D"D"</Publish>=0D
+            <Publish Event=3D"EnableRollback" Value=3D"False">OutOfDiskSpa=
ce =3D 1 AND OutOfNoRbDiskSpace =3D 0 AND PROMPTROLLBACKCOST=3D"D"</Publish=
>=0D
+            <Publish Event=3D"SpawnDialog" Value=3D"OutOfDiskDlg">(OutOfDi=
skSpace =3D 1 AND OutOfNoRbDiskSpace =3D 1) OR (OutOfDiskSpace =3D 1 AND PR=
OMPTROLLBACKCOST=3D"F")</Publish>=0D
+            <Condition Action=3D"show">ALLUSERS</Condition>=0D
+        </Control>=0D
+        <Control Id=3D"InstallNoShield" Type=3D"PushButton" ElevationShiel=
d=3D"no" X=3D"212" Y=3D"243" Width=3D"80" Height=3D"17" Default=3D"yes" Tex=
t=3D"!(loc.WelcomeEulaDlgInstall)" Hidden=3D"yes">=0D
+          <Publish Event=3D"SpawnWaitDialog" Value=3D"WaitForCostingDlg">!=
(wix.WixUICostingPopupOptOut) OR CostingComplete =3D 1</Publish>=0D
+          <Publish Event=3D"EndDialog" Value=3D"Return"><![CDATA[OutOfDisk=
Space <> 1]]></Publish>=0D
+          <Publish Event=3D"SpawnDialog" Value=3D"OutOfRbDiskDlg">OutOfDis=
kSpace =3D 1 AND OutOfNoRbDiskSpace =3D 0 AND (PROMPTROLLBACKCOST=3D"P" OR =
NOT PROMPTROLLBACKCOST)</Publish>=0D
+          <Publish Event=3D"EndDialog" Value=3D"Return">OutOfDiskSpace =3D=
 1 AND OutOfNoRbDiskSpace =3D 0 AND PROMPTROLLBACKCOST=3D"D"</Publish>=0D
+          <Publish Event=3D"EnableRollback" Value=3D"False">OutOfDiskSpace=
 =3D 1 AND OutOfNoRbDiskSpace =3D 0 AND PROMPTROLLBACKCOST=3D"D"</Publish>=
=0D
+          <Publish Event=3D"SpawnDialog" Value=3D"OutOfDiskDlg">(OutOfDisk=
Space =3D 1 AND OutOfNoRbDiskSpace =3D 1) OR (OutOfDiskSpace =3D 1 AND PROM=
PTROLLBACKCOST=3D"F")</Publish>=0D
+          <Condition Action=3D"disable"><![CDATA[LicenseAccepted <> "1"]]>=
</Condition>=0D
+          <Condition Action=3D"show">NOT ALLUSERS</Condition>=0D
+        </Control>=0D
+        <Control Id=3D"Cancel" Type=3D"PushButton" X=3D"304" Y=3D"243" Wid=
th=3D"56" Height=3D"17" Cancel=3D"yes" Text=3D"!(loc.WixUICancel)">=0D
+          <Publish Event=3D"SpawnDialog" Value=3D"CancelDlg">1</Publish>=0D
+        </Control>=0D
+        <Control Id=3D"Bitmap" Type=3D"Bitmap" X=3D"0" Y=3D"0" Width=3D"37=
0" Height=3D"234" TabSkip=3D"no" Text=3D"!(loc.WelcomeDlgBitmap)" />=0D
+        <Control Id=3D"Back" Type=3D"PushButton" X=3D"180" Y=3D"243" Width=
=3D"56" Height=3D"17" Disabled=3D"yes" Text=3D"!(loc.WixUIBack)" />=0D
+        <Control Id=3D"BottomLine" Type=3D"Line" X=3D"0" Y=3D"234" Width=
=3D"370" Height=3D"0" />=0D
+        <Control Id=3D"Description" Type=3D"Text" X=3D"135" Y=3D"80" Width=
=3D"220" Height=3D"60" Transparent=3D"yes" NoPrefix=3D"yes" Text=3D"!(loc.M=
yWelcomeDlgDescription)" >=0D
+          <Condition Action=3D"show">NOT Installed OR NOT PATCH</Condition=
>=0D
+          <Condition Action=3D"hide">Installed AND PATCH</Condition>=0D
+        </Control>=0D
+        <Control Id=3D"PatchDescription" Type=3D"Text" X=3D"135" Y=3D"80" =
Width=3D"220" Height=3D"60" Transparent=3D"yes" NoPrefix=3D"yes" Text=3D"!(=
loc.WelcomeUpdateDlgDescriptionUpdate)" >=0D
+          <Condition Action=3D"show">Installed AND PATCH</Condition>=0D
+          <Condition Action=3D"hide">NOT Installed OR NOT PATCH</Condition=
>=0D
+        </Control>=0D
+        <Control Id=3D"Title" Type=3D"Text" X=3D"135" Y=3D"20" Width=3D"22=
0" Height=3D"60" Transparent=3D"yes" NoPrefix=3D"yes" Text=3D"!(loc.Welcome=
DlgTitle)" />=0D
+      </Dialog>=0D
+=0D
+      <Publish Dialog=3D"ExitDialog" Control=3D"Finish" Event=3D"EndDialog=
" Value=3D"Return" Order=3D"999">1</Publish>=0D
+=0D
+      <Publish Dialog=3D"VerifyReadyDlg" Control=3D"Back" Event=3D"NewDial=
og" Value=3D"MaintenanceTypeDlg">1</Publish>=0D
+=0D
+      <Publish Dialog=3D"MaintenanceWelcomeDlg" Control=3D"Next" Event=3D"=
NewDialog" Value=3D"MaintenanceTypeDlg">1</Publish>=0D
+=0D
+      <Publish Dialog=3D"MaintenanceTypeDlg" Control=3D"RepairButton" Even=
t=3D"NewDialog" Value=3D"VerifyReadyDlg">1</Publish>=0D
+      <Publish Dialog=3D"MaintenanceTypeDlg" Control=3D"RemoveButton" Even=
t=3D"NewDialog" Value=3D"VerifyReadyDlg">1</Publish>=0D
+      <Publish Dialog=3D"MaintenanceTypeDlg" Control=3D"Back" Event=3D"New=
Dialog" Value=3D"MaintenanceWelcomeDlg">1</Publish>=0D
+=0D
+      <Publish Dialog=3D"MyWelcomeDlg" Control=3D"Install" Event=3D"NewDia=
log" Value=3D"PrepareDlg">1</Publish>=0D
+      <Publish Dialog=3D"VerifyReadyDlg" Control=3D"Back" Event=3D"NewDial=
og" Value=3D"WelcomeDlg" Order=3D"2">Installed AND PATCH</Publish>=0D
+=0D
+      <InstallUISequence>=0D
+        <Show Dialog=3D"WelcomeDlg" Before=3D"ProgressDlg">0</Show>=0D
+        <Show Dialog=3D"MyWelcomeDlg" Before=3D"ProgressDlg">NOT Installed=
</Show>=0D
+      </InstallUISequence>=0D
+=0D
+      <Property Id=3D"ARPNOMODIFY" Value=3D"1" />=0D
+    </UI>=0D
+=0D
+    <UIRef Id=3D"WixUI_Common" />=0D
+  </Fragment>=0D
+</Wix>
\ No newline at end of file
diff --git a/os/windows/WixUI_fio.wxl b/os/windows/WixUI_fio.wxl
new file mode 100755
index 00000000..11ec736a
--- /dev/null
+++ b/os/windows/WixUI_fio.wxl
@@ -0,0 +1,12 @@
+<?xml version=3D"1.0" encoding=3D"utf-8"?>=0D
+<!-- Copyright (c) .NET Foundation and contributors. All rights reserved. =
Licensed under the Microsoft Reciprocal License. See LICENSE.TXT file in th=
e project root for full license information. -->=0D
+=0D
+=0D
+<WixLocalization Culture=3D"en-US" Codepage=3D"1252" xmlns=3D"http://schem=
as.microsoft.com/wix/2006/localization">=0D
+  <!-- _locID@Culture=3D"en-US" _locComment=3D"American English" -->=0D
+  <!-- _locID@Codepage=3D"1252" _locComment=3D"Windows-1252" -->=0D
+=0D
+<String Id=3D"MyWelcomeDlgDescription" Overridable=3D"yes">=0D
+<!-- _locID_text=3D"MyWelcomeDlgDescription" _locComment=3D"MyWelcomeDlgDe=
scription" -->The Setup Wizard will install [ProductName] on your computer.=
 Click Install to continue or Cancel to exit the Setup Wizard.=0D
+</String>=0D
+</WixLocalization>
\ No newline at end of file
diff --git a/os/windows/dobuild.cmd b/os/windows/dobuild.cmd
index 08df3e87..7b9cb1dd 100644
--- a/os/windows/dobuild.cmd
+++ b/os/windows/dobuild.cmd
@@ -44,7 +44,10 @@ if exist ..\..\fio.pdb (
 @if ERRORLEVEL 1 goto end=0D
 "%WIX%bin\candle" -nologo -arch %FIO_ARCH% examples.wxs=0D
 @if ERRORLEVEL 1 goto end=0D
-"%WIX%bin\light" -nologo -sice:ICE61 install.wixobj examples.wixobj -ext W=
ixUIExtension -out %FIO_VERSION%-%FIO_ARCH%.msi=0D
+"%WIX%bin\candle" -nologo -arch %FIO_ARCH% WixUI_Minimal_NoEULA.wxs=0D
+@if ERRORLEVEL 1 goto end=0D
+=0D
+"%WIX%bin\light" -nologo -sice:ICE61 install.wixobj examples.wixobj WixUI_=
Minimal_NoEULA.wixobj -loc WixUI_fio.wxl -ext WixUIExtension -out %FIO_VERS=
ION%-%FIO_ARCH%.msi=0D
 :end=0D
 =0D
 if defined SIGN_FIO (=0D
diff --git a/os/windows/eula.rtf b/os/windows/eula.rtf
deleted file mode 100755
index a931017cd644cf9f1723705abb785fad694e113c..000000000000000000000000000=
0000000000000
GIT binary patch
literal 0
HcmV?d00001

literal 1075
zcmaJ=3DO>g2b5Z!a7{)aiXD+*2u^n(*yl@curD1a&?UraJdtTlFIJ5Yr9?>kA0s=3Dbhd
zzw&10z31_fTb~77XeXN?Df1xgg*?S9V_cg`CT3d-f8?3b-ft8w7|+~ZI>)o55Z0k*
zFh;dQFB361ovyErJTb~xLc@StOc~EDqGo)fDhzwQL4*0pbJS>sHx^=3D<6qtq#0@h~j
z;E8pE6W>YP|CKuJ@+t}7`ihsrrrdu#gp9_Z+pVWC=3Dr_~jV?EvXSv_^{8%U2eklsTB
z>316lMc0srrv~!aCrG1+wo2&y2}aQj?qH<wLv9p8)R}=3Dt=3Dh4>nudiNAd9X4sJlwq8
zLdXJk7cvTNetwS2LOLj|$*tG|Ei+ON&SZWsEIz}*RFDV_<cxIQ%1z}Fqz9qX4tcRP
zsmu=3DbL8Vi);0q)IcI&`o&E{>og15#x1@mg7WC9bJpmqp?>eeTY+=3DR`cfsg9yi?8Z1
zGL%(#X><!vQf>=3D7w2t-=3Do(p_sYXPyj5xypD!IX8-EwMa+5=3D7`6*S;kETVV=3DPH+%|H
zlAwa}lEl4K3N{Fp!>m#*ATQuOT8?L{B@Cx)cpt{`aJpO%2<Zz$e{qMOdE~ZKl4O#p
zR%m~y+5dTsU&e$V{)#5ia$O4;Ma${yVgaLB3`3X?<7M=3D+nhax@uj2V^@!AGhkU_P}
z7mUrCi?IkPdLfnjPxP8D)DbzALLqiY7n`8m5j6n`b<5e-3+aV2I&UNrk?-aqZczr>
z_!c<gc%;WCQKd)zlV>WG+WF&nJ%5cS(eyVI-k0vV)7kI$?Oa!FWAhI6M%@>#1E&)O
ctJFH>j~9`=3DQj8}VJJEN38312;>EZtP2jP%zcmMzZ

diff --git a/os/windows/install.wxs b/os/windows/install.wxs
index f73ec5e2..7773bb3b 100755
--- a/os/windows/install.wxs
+++ b/os/windows/install.wxs
@@ -107,7 +107,7 @@
=20
 	<WixVariable Id=3D"WixUILicenseRtf" Value=3D"eula.rtf" />
=20
-	<UIRef Id=3D"WixUI_Minimal"/>
+	<UIRef Id=3D"WixUI_Minimal_NoEULA"/>
=20
 	<MajorUpgrade AllowDowngrades=3D"no" DowngradeErrorMessage=3D"A newer ver=
sion of the application is already installed."
                   AllowSameVersionUpgrades=3D"yes"/>
--=20
2.31.1



