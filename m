Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:35022 "EHLO
        mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750732AbdAXJzl (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 24 Jan 2017 04:55:41 -0500
Received: by mail-wm0-f53.google.com with SMTP id r126so173104221wmr.0
        for <fio@vger.kernel.org>; Tue, 24 Jan 2017 01:55:31 -0800 (PST)
Subject: Re: 4x lower IOPS: Linux MD vs indiv. devices - why?
References: <90865544-f790-513c-97df-7e6a6af20ca8@gmail.com>
 <974E4982-D808-4CAF-ACCF-85866C0050A7@intel.com>
 <c7fc722c-f3ca-4abe-7202-8ca67b5e59a0@gmail.com>
 <9D5B6947-2DF8-46B9-AEAD-62132C19A0D3@intel.com>
From: Tobias Oberstein <tobias.oberstein@gmail.com>
Message-ID: <db74d7bd-78ea-cdf2-2446-ec57054952b6@gmail.com>
Date: Tue, 24 Jan 2017 10:55:29 +0100
MIME-Version: 1.0
In-Reply-To: <9D5B6947-2DF8-46B9-AEAD-62132C19A0D3@intel.com>
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Kudryavtsev, Andrey O" <andrey.o.kudryavtsev@intel.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

Am 23.01.2017 um 20:06 schrieb Kudryavtsev, Andrey O:
> Hi Tobias,
> Yes, “imsm” is in generic release, you don’t need to go to the latest or special build then if you want to stay compliant. It’s mainly a different layout of a raid metadata.
>
> Your findings follow my expectations, for QD1 sync engine does good results. Can you try libio with QD4 and 2800/4 jobs?
> Most of the time I’m running Centos7 either with 3.10 or latest kernel depends of the scope of the testing.
>
> Changing sector to 4k is easy, this can really help. see DCT manual, it’s there.
> This can be relevant for you https://itpeernetwork.intel.com/how-to-configure-oracle-redo-on-the-intel-pcie-ssd-dc-p3700/
>
>

It doesn't work =(


oberstet@svr-psql19:~/scm/parcit/RA/user/oberstet$ sudo isdct start 
-nvmeformat -intelssd 0 \
 >   LBAFormat=4 \
 >   SecureEraseSetting=0 \
 >   ProtectionInformation=0 \
 >   MetaDataSettings=0
WARNING! You have selected to format the drive!
Proceed with the format? (Y|N): y
Formatting...

- Intel SSD DC P3608 Series CVF8551400324P0DGN-1 -

Status : NVMe command reported a problem.

oberstet@svr-psql19:~/scm/parcit/RA/user/oberstet$ sudo isdct show -all 
-intelssd 0

- Intel SSD DC P3608 Series CVF8551400324P0DGN-1 -

AggregationThreshold : 0
AggregationTime : 0
ArbitrationBurst : 0
Bootloader : 8B1B0133
CoalescingDisable : 1
DevicePath : /dev/nvme0n1
DeviceStatus : Healthy
EndToEndDataProtCapabilities : 17
EnduranceAnalyzer : Media Workload Indicators have reset values. Run 60+ 
minute workload prior to running the endurance analyzer.
ErrorString :
Firmware : 8DV101F0
FirmwareUpdateAvailable : The selected Intel SSD contains current 
firmware as of this tool release.
HighPriorityWeightArbitration : 0
IOCompletionQueuesRequested : 30
IOSubmissionQueuesRequested : 30
Index : 0
Intel : True
IntelGen3SATA : False
IntelNVMe : True
InterruptVector : 0
LBAFormat : 0
LatencyTrackingEnabled : False
LowPriorityWeightArbitration : 0
MaximumLBA : 3907029167
MediumPriorityWeightArbitration : 0
MetadataSetting : 0
ModelNumber : INTEL SSDPECME040T4
NVMeControllerID : 0
NVMeMajorVersion : 1
NVMeMinorVersion : 0
NVMePowerState : 0
NVMeTertiaryVersion : 0
NamespaceId : 1
NativeMaxLBA : 3907029167
NumErrorLogPageEntries : 63
NumLBAFormats : 6
OEM : Generic
PCILinkGenSpeed : 3
PCILinkWidth : 4
PowerGovernorMode : 0 40W for 8 Lane Slot power
Product : Fultondale X8
ProductFamily : Intel SSD DC P3608 Series
ProductProtocol : NVME
ProtectionInformation : 0
ProtectionInformationLocation : 0
SMARTEnabled : True
SMARTHealthCriticalWarningsConfiguration : 0
SMBusAddress : 106
SectorSize : 512
SerialNumber : CVF8551400324P0DGN-1
TCGSupported : False
TempThreshold : 85
TimeLimitedErrorRecovery : 0
TrimSupported : True
VolatileWriteCacheEnabled : False
WriteAtomicityDisableNormal : 0

oberstet@svr-psql19:~/scm/parcit/RA/user/oberstet$ isdct --version
Syntax Error: Invalid command. Error at or around '--version'.
oberstet@svr-psql19:~/scm/parcit/RA/user/oberstet$ isdct version
- Version Information -
Name: Intel(R) Data Center Tool
Version: 3.0.2
Description: Interact and configure Intel SSDs.


oberstet@svr-psql19:~/scm/parcit/RA/user/oberstet$

