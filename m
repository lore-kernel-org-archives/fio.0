Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231218AbhD1MBk (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 28 Apr 2021 08:01:40 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20ED9C06138A
        for <fio@vger.kernel.org>; Wed, 28 Apr 2021 05:00:54 -0700 (PDT)
Received: from [65.144.74.35] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lbirN-008FOo-E6
        for fio@vger.kernel.org; Wed, 28 Apr 2021 12:00:37 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20210428120001.79DC11BC0107@kernel.dk>
Date: Wed, 28 Apr 2021 06:00:01 -0600 (MDT)
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 13169d44d3725847858a7c817965d2cac5abd8f8:

  Merge branch 'pthread_getaffinity_1' of https://github.com/kusumi/fio (2021-04-25 10:23:34 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 6308ef297145e73add65ba86bfdbeaf967957d1f:

  ioengines: don't call zbd_put_io_u() for engines not implementing commit (2021-04-27 11:56:55 -0600)

----------------------------------------------------------------
Niklas Cassel (1):
      ioengines: don't call zbd_put_io_u() for engines not implementing commit

Rebecca Cran (1):
      The GPL isn't a EULA: remove it and introduce WixUI_Minimal_NoEULA

 ioengines.c                         |   1 -
 os/windows/WixUI_Minimal_NoEULA.wxs |  96 ++++++++++++++++++++++++++++++++++++
 os/windows/WixUI_fio.wxl            |  12 +++++
 os/windows/dobuild.cmd              |   5 +-
 os/windows/eula.rtf                 | Bin 1075 -> 0 bytes
 os/windows/install.wxs              |   2 +-
 6 files changed, 113 insertions(+), 3 deletions(-)
 create mode 100755 os/windows/WixUI_Minimal_NoEULA.wxs
 create mode 100755 os/windows/WixUI_fio.wxl
 delete mode 100755 os/windows/eula.rtf

---

Diff of recent changes:

diff --git a/ioengines.c b/ioengines.c
index f88b0537..3561bb4e 100644
--- a/ioengines.c
+++ b/ioengines.c
@@ -414,7 +414,6 @@ enum fio_q_status td_io_queue(struct thread_data *td, struct io_u *io_u)
 	if (!td->io_ops->commit) {
 		io_u_mark_submit(td, 1);
 		io_u_mark_complete(td, 1);
-		zbd_put_io_u(td, io_u);
 	}
 
 	if (ret == FIO_Q_COMPLETED) {
diff --git a/os/windows/WixUI_Minimal_NoEULA.wxs b/os/windows/WixUI_Minimal_NoEULA.wxs
new file mode 100755
index 00000000..48391186
--- /dev/null
+++ b/os/windows/WixUI_Minimal_NoEULA.wxs
@@ -0,0 +1,96 @@
+<?xml version="1.0" encoding="UTF-8"?>
+<!-- Copyright (c) .NET Foundation and contributors. All rights reserved. Licensed under the Microsoft Reciprocal License. See LICENSE.TXT file in the project root for full license information. -->
+
+
+
+<!--
+First-time install dialog sequence:
+ - WixUI_MyWelcomeDlg
+Maintenance dialog sequence:
+ WixUI_MaintenanceWelcomeDlg
+ - WixUI_MaintenanceTypeDlg
+ - WixUI_VerifyReadyDlg
+-->
+
+<Wix xmlns="http://schemas.microsoft.com/wix/2006/wi">
+  <Fragment>
+    <UI Id="WixUI_Minimal_NoEULA">
+      <TextStyle Id="WixUI_Font_Normal" FaceName="Tahoma" Size="8" />
+      <TextStyle Id="WixUI_Font_Bigger" FaceName="Tahoma" Size="12" />
+      <TextStyle Id="WixUI_Font_Title" FaceName="Tahoma" Size="9" Bold="yes" />
+
+      <Property Id="DefaultUIFont" Value="WixUI_Font_Normal" />
+      <Property Id="WixUI_Mode" Value="Minimal" />
+
+      <DialogRef Id="ErrorDlg" />
+      <DialogRef Id="FatalError" />
+      <DialogRef Id="FilesInUse" />
+      <DialogRef Id="MsiRMFilesInUse" />
+      <DialogRef Id="PrepareDlg" />
+      <DialogRef Id="ProgressDlg" />
+      <DialogRef Id="ResumeDlg" />
+      <DialogRef Id="UserExit" />
+      <DialogRef Id="MyWelcomeDlg" />
+
+      <Dialog Id="MyWelcomeDlg" Width="370" Height="270" Title="!(loc.WelcomeDlg_Title)">
+          <Control Id="Install" Type="PushButton" ElevationShield="yes" X="236" Y="243" Width="56" Height="17" Default="yes" Hidden="yes" Text="!(loc.WelcomeEulaDlgInstall)" >
+            <Publish Property="WixUI_InstallMode" Value="Update">Installed AND PATCH</Publish>
+            <Publish Event="SpawnWaitDialog" Value="WaitForCostingDlg">!(wix.WixUICostingPopupOptOut) OR CostingComplete = 1</Publish>
+            <Publish Event="EndDialog" Value="Return"><![CDATA[OutOfDiskSpace <> 1]]></Publish>
+            <Publish Event="SpawnDialog" Value="OutOfRbDiskDlg">OutOfDiskSpace = 1 AND OutOfNoRbDiskSpace = 0 AND (PROMPTROLLBACKCOST="P" OR NOT PROMPTROLLBACKCOST)</Publish>
+            <Publish Event="EndDialog" Value="Return">OutOfDiskSpace = 1 AND OutOfNoRbDiskSpace = 0 AND PROMPTROLLBACKCOST="D"</Publish>
+            <Publish Event="EnableRollback" Value="False">OutOfDiskSpace = 1 AND OutOfNoRbDiskSpace = 0 AND PROMPTROLLBACKCOST="D"</Publish>
+            <Publish Event="SpawnDialog" Value="OutOfDiskDlg">(OutOfDiskSpace = 1 AND OutOfNoRbDiskSpace = 1) OR (OutOfDiskSpace = 1 AND PROMPTROLLBACKCOST="F")</Publish>
+            <Condition Action="show">ALLUSERS</Condition>
+        </Control>
+        <Control Id="InstallNoShield" Type="PushButton" ElevationShield="no" X="212" Y="243" Width="80" Height="17" Default="yes" Text="!(loc.WelcomeEulaDlgInstall)" Hidden="yes">
+          <Publish Event="SpawnWaitDialog" Value="WaitForCostingDlg">!(wix.WixUICostingPopupOptOut) OR CostingComplete = 1</Publish>
+          <Publish Event="EndDialog" Value="Return"><![CDATA[OutOfDiskSpace <> 1]]></Publish>
+          <Publish Event="SpawnDialog" Value="OutOfRbDiskDlg">OutOfDiskSpace = 1 AND OutOfNoRbDiskSpace = 0 AND (PROMPTROLLBACKCOST="P" OR NOT PROMPTROLLBACKCOST)</Publish>
+          <Publish Event="EndDialog" Value="Return">OutOfDiskSpace = 1 AND OutOfNoRbDiskSpace = 0 AND PROMPTROLLBACKCOST="D"</Publish>
+          <Publish Event="EnableRollback" Value="False">OutOfDiskSpace = 1 AND OutOfNoRbDiskSpace = 0 AND PROMPTROLLBACKCOST="D"</Publish>
+          <Publish Event="SpawnDialog" Value="OutOfDiskDlg">(OutOfDiskSpace = 1 AND OutOfNoRbDiskSpace = 1) OR (OutOfDiskSpace = 1 AND PROMPTROLLBACKCOST="F")</Publish>
+          <Condition Action="disable"><![CDATA[LicenseAccepted <> "1"]]></Condition>
+          <Condition Action="show">NOT ALLUSERS</Condition>
+        </Control>
+        <Control Id="Cancel" Type="PushButton" X="304" Y="243" Width="56" Height="17" Cancel="yes" Text="!(loc.WixUICancel)">
+          <Publish Event="SpawnDialog" Value="CancelDlg">1</Publish>
+        </Control>
+        <Control Id="Bitmap" Type="Bitmap" X="0" Y="0" Width="370" Height="234" TabSkip="no" Text="!(loc.WelcomeDlgBitmap)" />
+        <Control Id="Back" Type="PushButton" X="180" Y="243" Width="56" Height="17" Disabled="yes" Text="!(loc.WixUIBack)" />
+        <Control Id="BottomLine" Type="Line" X="0" Y="234" Width="370" Height="0" />
+        <Control Id="Description" Type="Text" X="135" Y="80" Width="220" Height="60" Transparent="yes" NoPrefix="yes" Text="!(loc.MyWelcomeDlgDescription)" >
+          <Condition Action="show">NOT Installed OR NOT PATCH</Condition>
+          <Condition Action="hide">Installed AND PATCH</Condition>
+        </Control>
+        <Control Id="PatchDescription" Type="Text" X="135" Y="80" Width="220" Height="60" Transparent="yes" NoPrefix="yes" Text="!(loc.WelcomeUpdateDlgDescriptionUpdate)" >
+          <Condition Action="show">Installed AND PATCH</Condition>
+          <Condition Action="hide">NOT Installed OR NOT PATCH</Condition>
+        </Control>
+        <Control Id="Title" Type="Text" X="135" Y="20" Width="220" Height="60" Transparent="yes" NoPrefix="yes" Text="!(loc.WelcomeDlgTitle)" />
+      </Dialog>
+
+      <Publish Dialog="ExitDialog" Control="Finish" Event="EndDialog" Value="Return" Order="999">1</Publish>
+
+      <Publish Dialog="VerifyReadyDlg" Control="Back" Event="NewDialog" Value="MaintenanceTypeDlg">1</Publish>
+
+      <Publish Dialog="MaintenanceWelcomeDlg" Control="Next" Event="NewDialog" Value="MaintenanceTypeDlg">1</Publish>
+
+      <Publish Dialog="MaintenanceTypeDlg" Control="RepairButton" Event="NewDialog" Value="VerifyReadyDlg">1</Publish>
+      <Publish Dialog="MaintenanceTypeDlg" Control="RemoveButton" Event="NewDialog" Value="VerifyReadyDlg">1</Publish>
+      <Publish Dialog="MaintenanceTypeDlg" Control="Back" Event="NewDialog" Value="MaintenanceWelcomeDlg">1</Publish>
+
+      <Publish Dialog="MyWelcomeDlg" Control="Install" Event="NewDialog" Value="PrepareDlg">1</Publish>
+      <Publish Dialog="VerifyReadyDlg" Control="Back" Event="NewDialog" Value="WelcomeDlg" Order="2">Installed AND PATCH</Publish>
+
+      <InstallUISequence>
+        <Show Dialog="WelcomeDlg" Before="ProgressDlg">0</Show>
+        <Show Dialog="MyWelcomeDlg" Before="ProgressDlg">NOT Installed</Show>
+      </InstallUISequence>
+
+      <Property Id="ARPNOMODIFY" Value="1" />
+    </UI>
+
+    <UIRef Id="WixUI_Common" />
+  </Fragment>
+</Wix>
\ No newline at end of file
diff --git a/os/windows/WixUI_fio.wxl b/os/windows/WixUI_fio.wxl
new file mode 100755
index 00000000..11ec736a
--- /dev/null
+++ b/os/windows/WixUI_fio.wxl
@@ -0,0 +1,12 @@
+<?xml version="1.0" encoding="utf-8"?>
+<!-- Copyright (c) .NET Foundation and contributors. All rights reserved. Licensed under the Microsoft Reciprocal License. See LICENSE.TXT file in the project root for full license information. -->
+
+
+<WixLocalization Culture="en-US" Codepage="1252" xmlns="http://schemas.microsoft.com/wix/2006/localization">
+  <!-- _locID@Culture="en-US" _locComment="American English" -->
+  <!-- _locID@Codepage="1252" _locComment="Windows-1252" -->
+
+<String Id="MyWelcomeDlgDescription" Overridable="yes">
+<!-- _locID_text="MyWelcomeDlgDescription" _locComment="MyWelcomeDlgDescription" -->The Setup Wizard will install [ProductName] on your computer. Click Install to continue or Cancel to exit the Setup Wizard.
+</String>
+</WixLocalization>
\ No newline at end of file
diff --git a/os/windows/dobuild.cmd b/os/windows/dobuild.cmd
index 08df3e87..7b9cb1dd 100644
--- a/os/windows/dobuild.cmd
+++ b/os/windows/dobuild.cmd
@@ -44,7 +44,10 @@ if exist ..\..\fio.pdb (
 @if ERRORLEVEL 1 goto end
 "%WIX%bin\candle" -nologo -arch %FIO_ARCH% examples.wxs
 @if ERRORLEVEL 1 goto end
-"%WIX%bin\light" -nologo -sice:ICE61 install.wixobj examples.wixobj -ext WixUIExtension -out %FIO_VERSION%-%FIO_ARCH%.msi
+"%WIX%bin\candle" -nologo -arch %FIO_ARCH% WixUI_Minimal_NoEULA.wxs
+@if ERRORLEVEL 1 goto end
+
+"%WIX%bin\light" -nologo -sice:ICE61 install.wixobj examples.wixobj WixUI_Minimal_NoEULA.wixobj -loc WixUI_fio.wxl -ext WixUIExtension -out %FIO_VERSION%-%FIO_ARCH%.msi
 :end
 
 if defined SIGN_FIO (
diff --git a/os/windows/eula.rtf b/os/windows/eula.rtf
deleted file mode 100755
index a931017c..00000000
Binary files a/os/windows/eula.rtf and /dev/null differ
diff --git a/os/windows/install.wxs b/os/windows/install.wxs
index f73ec5e2..7773bb3b 100755
--- a/os/windows/install.wxs
+++ b/os/windows/install.wxs
@@ -107,7 +107,7 @@
 
 	<WixVariable Id="WixUILicenseRtf" Value="eula.rtf" />
 
-	<UIRef Id="WixUI_Minimal"/>
+	<UIRef Id="WixUI_Minimal_NoEULA"/>
 
 	<MajorUpgrade AllowDowngrades="no" DowngradeErrorMessage="A newer version of the application is already installed."
                   AllowSameVersionUpgrades="yes"/>

