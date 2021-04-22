Return-Path: <rebecca@bsdio.com>
References: <20210422023226.935-1-rebecca@bsdio.com>
From: Rebecca Cran <rebecca@bsdio.com>
Message-ID: <76320c05-4d0a-2c96-01a7-d5ebb6f4af3e@bsdio.com>
Date: Wed, 21 Apr 2021 20:37:28 -0600
MIME-Version: 1.0
In-Reply-To: <20210422023226.935-1-rebecca@bsdio.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Subject: Re: [PATCH] The GPL isn't a EULA: remove it and introduce
 WixUI_Minimal_NoEULA
To: Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

I've tested this on Windows 10 and it appears to work, but I'd 
appreciate any extra testing people can do because it's been quite a 
while since I've done much MSI work, but I remember how changing the 
InstallUISequence can introduce subtle issues.


-- 

Rebecca Cran


On 4/21/2021 8:32 PM, Rebecca Cran wrote:
> The GPL shouldn't be used as a EULA in an installer.
> Remove it, and since the WixUI_Minimal dialog set requires a EULA
> create a custom WixUI_Minimal_NoEULA set.
>
> Signed-off-by: Rebecca Cran <rebecca@bsdio.com>
> ---
>   os/windows/WixUI_Minimal_NoEULA.wxs |  96 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>   os/windows/WixUI_fio.wxl            |  12 ++++++++++
>   os/windows/dobuild.cmd              |   5 ++++-
>   os/windows/eula.rtf                 | Bin 1075 -> 0 bytes
>   os/windows/install.wxs              |   2 +-
>   5 files changed, 113 insertions(+), 2 deletions(-)
>
> diff --git a/os/windows/WixUI_Minimal_NoEULA.wxs b/os/windows/WixUI_Minimal_NoEULA.wxs
> new file mode 100755
> index 00000000..48391186
> --- /dev/null
> +++ b/os/windows/WixUI_Minimal_NoEULA.wxs
> @@ -0,0 +1,96 @@
> +<?xml version="1.0" encoding="UTF-8"?>
>
> +<!-- Copyright (c) .NET Foundation and contributors. All rights reserved. Licensed under the Microsoft Reciprocal License. See LICENSE.TXT file in the project root for full license information. -->
>
> +
>
> +
>
> +
>
> +<!--
>
> +First-time install dialog sequence:
>
> + - WixUI_MyWelcomeDlg
>
> +Maintenance dialog sequence:
>
> + WixUI_MaintenanceWelcomeDlg
>
> + - WixUI_MaintenanceTypeDlg
>
> + - WixUI_VerifyReadyDlg
>
> +-->
>
> +
>
> +<Wix xmlns="http://schemas.microsoft.com/wix/2006/wi">
>
> +  <Fragment>
>
> +    <UI Id="WixUI_Minimal_NoEULA">
>
> +      <TextStyle Id="WixUI_Font_Normal" FaceName="Tahoma" Size="8" />
>
> +      <TextStyle Id="WixUI_Font_Bigger" FaceName="Tahoma" Size="12" />
>
> +      <TextStyle Id="WixUI_Font_Title" FaceName="Tahoma" Size="9" Bold="yes" />
>
> +
>
> +      <Property Id="DefaultUIFont" Value="WixUI_Font_Normal" />
>
> +      <Property Id="WixUI_Mode" Value="Minimal" />
>
> +
>
> +      <DialogRef Id="ErrorDlg" />
>
> +      <DialogRef Id="FatalError" />
>
> +      <DialogRef Id="FilesInUse" />
>
> +      <DialogRef Id="MsiRMFilesInUse" />
>
> +      <DialogRef Id="PrepareDlg" />
>
> +      <DialogRef Id="ProgressDlg" />
>
> +      <DialogRef Id="ResumeDlg" />
>
> +      <DialogRef Id="UserExit" />
>
> +      <DialogRef Id="MyWelcomeDlg" />
>
> +
>
> +      <Dialog Id="MyWelcomeDlg" Width="370" Height="270" Title="!(loc.WelcomeDlg_Title)">
>
> +          <Control Id="Install" Type="PushButton" ElevationShield="yes" X="236" Y="243" Width="56" Height="17" Default="yes" Hidden="yes" Text="!(loc.WelcomeEulaDlgInstall)" >
>
> +            <Publish Property="WixUI_InstallMode" Value="Update">Installed AND PATCH</Publish>
>
> +            <Publish Event="SpawnWaitDialog" Value="WaitForCostingDlg">!(wix.WixUICostingPopupOptOut) OR CostingComplete = 1</Publish>
>
> +            <Publish Event="EndDialog" Value="Return"><![CDATA[OutOfDiskSpace <> 1]]></Publish>
>
> +            <Publish Event="SpawnDialog" Value="OutOfRbDiskDlg">OutOfDiskSpace = 1 AND OutOfNoRbDiskSpace = 0 AND (PROMPTROLLBACKCOST="P" OR NOT PROMPTROLLBACKCOST)</Publish>
>
> +            <Publish Event="EndDialog" Value="Return">OutOfDiskSpace = 1 AND OutOfNoRbDiskSpace = 0 AND PROMPTROLLBACKCOST="D"</Publish>
>
> +            <Publish Event="EnableRollback" Value="False">OutOfDiskSpace = 1 AND OutOfNoRbDiskSpace = 0 AND PROMPTROLLBACKCOST="D"</Publish>
>
> +            <Publish Event="SpawnDialog" Value="OutOfDiskDlg">(OutOfDiskSpace = 1 AND OutOfNoRbDiskSpace = 1) OR (OutOfDiskSpace = 1 AND PROMPTROLLBACKCOST="F")</Publish>
>
> +            <Condition Action="show">ALLUSERS</Condition>
>
> +        </Control>
>
> +        <Control Id="InstallNoShield" Type="PushButton" ElevationShield="no" X="212" Y="243" Width="80" Height="17" Default="yes" Text="!(loc.WelcomeEulaDlgInstall)" Hidden="yes">
>
> +          <Publish Event="SpawnWaitDialog" Value="WaitForCostingDlg">!(wix.WixUICostingPopupOptOut) OR CostingComplete = 1</Publish>
>
> +          <Publish Event="EndDialog" Value="Return"><![CDATA[OutOfDiskSpace <> 1]]></Publish>
>
> +          <Publish Event="SpawnDialog" Value="OutOfRbDiskDlg">OutOfDiskSpace = 1 AND OutOfNoRbDiskSpace = 0 AND (PROMPTROLLBACKCOST="P" OR NOT PROMPTROLLBACKCOST)</Publish>
>
> +          <Publish Event="EndDialog" Value="Return">OutOfDiskSpace = 1 AND OutOfNoRbDiskSpace = 0 AND PROMPTROLLBACKCOST="D"</Publish>
>
> +          <Publish Event="EnableRollback" Value="False">OutOfDiskSpace = 1 AND OutOfNoRbDiskSpace = 0 AND PROMPTROLLBACKCOST="D"</Publish>
>
> +          <Publish Event="SpawnDialog" Value="OutOfDiskDlg">(OutOfDiskSpace = 1 AND OutOfNoRbDiskSpace = 1) OR (OutOfDiskSpace = 1 AND PROMPTROLLBACKCOST="F")</Publish>
>
> +          <Condition Action="disable"><![CDATA[LicenseAccepted <> "1"]]></Condition>
>
> +          <Condition Action="show">NOT ALLUSERS</Condition>
>
> +        </Control>
>
> +        <Control Id="Cancel" Type="PushButton" X="304" Y="243" Width="56" Height="17" Cancel="yes" Text="!(loc.WixUICancel)">
>
> +          <Publish Event="SpawnDialog" Value="CancelDlg">1</Publish>
>
> +        </Control>
>
> +        <Control Id="Bitmap" Type="Bitmap" X="0" Y="0" Width="370" Height="234" TabSkip="no" Text="!(loc.WelcomeDlgBitmap)" />
>
> +        <Control Id="Back" Type="PushButton" X="180" Y="243" Width="56" Height="17" Disabled="yes" Text="!(loc.WixUIBack)" />
>
> +        <Control Id="BottomLine" Type="Line" X="0" Y="234" Width="370" Height="0" />
>
> +        <Control Id="Description" Type="Text" X="135" Y="80" Width="220" Height="60" Transparent="yes" NoPrefix="yes" Text="!(loc.MyWelcomeDlgDescription)" >
>
> +          <Condition Action="show">NOT Installed OR NOT PATCH</Condition>
>
> +          <Condition Action="hide">Installed AND PATCH</Condition>
>
> +        </Control>
>
> +        <Control Id="PatchDescription" Type="Text" X="135" Y="80" Width="220" Height="60" Transparent="yes" NoPrefix="yes" Text="!(loc.WelcomeUpdateDlgDescriptionUpdate)" >
>
> +          <Condition Action="show">Installed AND PATCH</Condition>
>
> +          <Condition Action="hide">NOT Installed OR NOT PATCH</Condition>
>
> +        </Control>
>
> +        <Control Id="Title" Type="Text" X="135" Y="20" Width="220" Height="60" Transparent="yes" NoPrefix="yes" Text="!(loc.WelcomeDlgTitle)" />
>
> +      </Dialog>
>
> +
>
> +      <Publish Dialog="ExitDialog" Control="Finish" Event="EndDialog" Value="Return" Order="999">1</Publish>
>
> +
>
> +      <Publish Dialog="VerifyReadyDlg" Control="Back" Event="NewDialog" Value="MaintenanceTypeDlg">1</Publish>
>
> +
>
> +      <Publish Dialog="MaintenanceWelcomeDlg" Control="Next" Event="NewDialog" Value="MaintenanceTypeDlg">1</Publish>
>
> +
>
> +      <Publish Dialog="MaintenanceTypeDlg" Control="RepairButton" Event="NewDialog" Value="VerifyReadyDlg">1</Publish>
>
> +      <Publish Dialog="MaintenanceTypeDlg" Control="RemoveButton" Event="NewDialog" Value="VerifyReadyDlg">1</Publish>
>
> +      <Publish Dialog="MaintenanceTypeDlg" Control="Back" Event="NewDialog" Value="MaintenanceWelcomeDlg">1</Publish>
>
> +
>
> +      <Publish Dialog="MyWelcomeDlg" Control="Install" Event="NewDialog" Value="PrepareDlg">1</Publish>
>
> +      <Publish Dialog="VerifyReadyDlg" Control="Back" Event="NewDialog" Value="WelcomeDlg" Order="2">Installed AND PATCH</Publish>
>
> +
>
> +      <InstallUISequence>
>
> +        <Show Dialog="WelcomeDlg" Before="ProgressDlg">0</Show>
>
> +        <Show Dialog="MyWelcomeDlg" Before="ProgressDlg">NOT Installed</Show>
>
> +      </InstallUISequence>
>
> +
>
> +      <Property Id="ARPNOMODIFY" Value="1" />
>
> +    </UI>
>
> +
>
> +    <UIRef Id="WixUI_Common" />
>
> +  </Fragment>
>
> +</Wix>
> \ No newline at end of file
> diff --git a/os/windows/WixUI_fio.wxl b/os/windows/WixUI_fio.wxl
> new file mode 100755
> index 00000000..11ec736a
> --- /dev/null
> +++ b/os/windows/WixUI_fio.wxl
> @@ -0,0 +1,12 @@
> +<?xml version="1.0" encoding="utf-8"?>
>
> +<!-- Copyright (c) .NET Foundation and contributors. All rights reserved. Licensed under the Microsoft Reciprocal License. See LICENSE.TXT file in the project root for full license information. -->
>
> +
>
> +
>
> +<WixLocalization Culture="en-US" Codepage="1252" xmlns="http://schemas.microsoft.com/wix/2006/localization">
>
> +  <!-- _locID@Culture="en-US" _locComment="American English" -->
>
> +  <!-- _locID@Codepage="1252" _locComment="Windows-1252" -->
>
> +
>
> +<String Id="MyWelcomeDlgDescription" Overridable="yes">
>
> +<!-- _locID_text="MyWelcomeDlgDescription" _locComment="MyWelcomeDlgDescription" -->The Setup Wizard will install [ProductName] on your computer. Click Install to continue or Cancel to exit the Setup Wizard.
>
> +</String>
>
> +</WixLocalization>
> \ No newline at end of file
> diff --git a/os/windows/dobuild.cmd b/os/windows/dobuild.cmd
> index 08df3e87..7b9cb1dd 100644
> --- a/os/windows/dobuild.cmd
> +++ b/os/windows/dobuild.cmd
> @@ -44,7 +44,10 @@ if exist ..\..\fio.pdb (
>   @if ERRORLEVEL 1 goto end
>
>   "%WIX%bin\candle" -nologo -arch %FIO_ARCH% examples.wxs
>
>   @if ERRORLEVEL 1 goto end
>
> -"%WIX%bin\light" -nologo -sice:ICE61 install.wixobj examples.wixobj -ext WixUIExtension -out %FIO_VERSION%-%FIO_ARCH%.msi
>
> +"%WIX%bin\candle" -nologo -arch %FIO_ARCH% WixUI_Minimal_NoEULA.wxs
>
> +@if ERRORLEVEL 1 goto end
>
> +
>
> +"%WIX%bin\light" -nologo -sice:ICE61 install.wixobj examples.wixobj WixUI_Minimal_NoEULA.wixobj -loc WixUI_fio.wxl -ext WixUIExtension -out %FIO_VERSION%-%FIO_ARCH%.msi
>
>   :end
>
>   
>
>   if defined SIGN_FIO (
>
> diff --git a/os/windows/eula.rtf b/os/windows/eula.rtf
> deleted file mode 100755
> index a931017cd644cf9f1723705abb785fad694e113c..0000000000000000000000000000000000000000
> GIT binary patch
> literal 0
> HcmV?d00001
>
> literal 1075
> zcmaJ=O>g2b5Z!a7{)aiXD+*2u^n(*yl@curD1a&?UraJdtTlFIJ5Yr9?>kA0s=bhd
> zzw&10z31_fTb~77XeXN?Df1xgg*?S9V_cg`CT3d-f8?3b-ft8w7|+~ZI>)o55Z0k*
> zFh;dQFB361ovyErJTb~xLc@StOc~EDqGo)fDhzwQL4*0pbJS>sHx^=<6qtq#0@h~j
> z;E8pE6W>YP|CKuJ@+t}7`ihsrrrdu#gp9_Z+pVWC=r_~jV?EvXSv_^{8%U2eklsTB
> z>316lMc0srrv~!aCrG1+wo2&y2}aQj?qH<wLv9p8)R}=t=h4>nudiNAd9X4sJlwq8
> zLdXJk7cvTNetwS2LOLj|$*tG|Ei+ON&SZWsEIz}*RFDV_<cxIQ%1z}Fqz9qX4tcRP
> zsmu=bL8Vi);0q)IcI&`o&E{>og15#x1@mg7WC9bJpmqp?>eeTY+=R`cfsg9yi?8Z1
> zGL%(#X><!vQf>=7w2t-=o(p_sYXPyj5xypD!IX8-EwMa+5=7`6*S;kETVV=PH+%|H
> zlAwa}lEl4K3N{Fp!>m#*ATQuOT8?L{B@Cx)cpt{`aJpO%2<Zz$e{qMOdE~ZKl4O#p
> zR%m~y+5dTsU&e$V{)#5ia$O4;Ma${yVgaLB3`3X?<7M=+nhax@uj2V^@!AGhkU_P}
> z7mUrCi?IkPdLfnjPxP8D)DbzALLqiY7n`8m5j6n`b<5e-3+aV2I&UNrk?-aqZczr>
> z_!c<gc%;WCQKd)zlV>WG+WF&nJ%5cS(eyVI-k0vV)7kI$?Oa!FWAhI6M%@>#1E&)O
> ctJFH>j~9`=Qj8}VJJEN38312;>EZtP2jP%zcmMzZ
>
> diff --git a/os/windows/install.wxs b/os/windows/install.wxs
> index f73ec5e2..7773bb3b 100755
> --- a/os/windows/install.wxs
> +++ b/os/windows/install.wxs
> @@ -107,7 +107,7 @@
>   
>   	<WixVariable Id="WixUILicenseRtf" Value="eula.rtf" />
>   
> -	<UIRef Id="WixUI_Minimal"/>
> +	<UIRef Id="WixUI_Minimal_NoEULA"/>
>   
>   	<MajorUpgrade AllowDowngrades="no" DowngradeErrorMessage="A newer version of the application is already installed."
>                     AllowSameVersionUpgrades="yes"/>


