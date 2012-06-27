Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:61819 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865Ab2F0C4u (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 26 Jun 2012 22:56:50 -0400
Received: by ghrr11 with SMTP id r11so585626ghr.19
        for <fio@vger.kernel.org>; Tue, 26 Jun 2012 19:56:50 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 27 Jun 2012 10:56:49 +0800
Message-ID: <CAG1+85H7VFKnYfuHa--0QkGcZ=J7WVTPUz0E4P31+6OychW-AA@mail.gmail.com>
Subject: Single HDD , 700MB/s ??
From: Homer Li <01jay.ly@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hello ,All;

        When I used fio benchmark single HDD,  the write speed could
reached 700~800MB/s
        The HDD model is WD2002FYPS-18U1B0 , 7200rpm, 2TB
        In my raid config, there is only one HDD  in every Raid0
group. like jbod.

        And then, I modify numjobs=8 to numjobs=1. the benchmark
result is ok , it 's about 100MB/s.

        Does any wrong in my fio config ?


Raid controller: PERC 6/E (LSI SAS1068E)
OS : CentOS 5.5 upgrade to 2.6.18-308.8.2.el5 x86_64

# fio -v
fio 2.0.7


# cat /tmp/fio2.cfg
[global]
rw=write
ioengine=sync
size=100g
numjobs=8
bssplit=128k/20:256k/20:512k/20:1024k/40
nrfiles=2
iodepth=128
lockmem=1g
zero_buffers
timeout=120
direct=1
thread

[sdb]
filename=/dev/sdb

run
#fio /tmp/fio2.cfg


Run status group 0 (all jobs):
  WRITE: io=68235MB, aggrb=582254KB/s, minb=72636KB/s, maxb=73052KB/s,
mint=120001msec, maxt=120003msec


#iostat -x 2

Device:         rrqm/s   wrqm/s   r/s   w/s    rMB/s    wMB/s avgrq-sz
avgqu-sz   await  svctm  %util
sdb               0.00     0.00  0.00 2399.50     0.00   571.38
487.67    18.23    7.60   0.42 100.05

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           2.38    0.00    1.12   19.00    0.00   77.50

Device:         rrqm/s   wrqm/s   r/s   w/s    rMB/s    wMB/s avgrq-sz
avgqu-sz   await  svctm  %util
sdb               0.00     0.00  0.00 3231.00     0.00   771.19
488.82    18.29    5.66   0.31 100.05

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           2.19    0.00    1.06   19.36    0.00   77.39

Device:         rrqm/s   wrqm/s   r/s   w/s    rMB/s    wMB/s avgrq-sz
avgqu-sz   await  svctm  %util
sdb               0.00     0.00  0.00 3212.00     0.00   769.94
490.92    18.69    5.82   0.31 100.05

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           1.50    0.00    0.69   20.06    0.00   77.75

Device:         rrqm/s   wrqm/s   r/s   w/s    rMB/s    wMB/s avgrq-sz
avgqu-sz   await  svctm  %util
sdb               0.00     0.00  0.00 1937.50     0.00   466.06
492.64    19.18    9.91   0.52 100.05

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           2.06    0.00    0.94   19.94    0.00   77.06

Device:         rrqm/s   wrqm/s   r/s   w/s    rMB/s    wMB/s avgrq-sz
avgqu-sz   await  svctm  %util
sdb               0.00     0.00  0.00 2789.00     0.00   668.50
490.89    18.72    6.71   0.36 100.05




Here is my Raid controller config:

this is sdb:

DISK GROUP: 0
Number of Spans: 1
SPAN: 0
Span Reference: 0x00
Number of PDs: 1
Number of VDs: 1
Number of dedicated Hotspares: 0
Virtual Drive Information:
Virtual Drive: 0 (Target Id: 0)
Name                :
RAID Level          : Primary-0, Secondary-0, RAID Level Qualifier-0
Size                : 1.818 TB
State               : Optimal
Stripe Size         : 64 KB
Number Of Drives    : 1
Span Depth          : 1
Default Cache Policy: WriteBack, ReadAheadNone, Direct, No Write Cache
if Bad BBU
Current Cache Policy: WriteBack, ReadAheadNone, Direct, No Write Cache
if Bad BBU
Access Policy       : Read/Write
Disk Cache Policy   : Disk's Default
Encryption Type     : None
Physical Disk Information:
Physical Disk: 0
Enclosure Device ID: 16
Slot Number: 0
Device Id: 31
Sequence Number: 4
Media Error Count: 0
Other Error Count: 0
Predictive Failure Count: 0
Last Predictive Failure Event Seq Number: 0
PD Type: SATA
Raw Size: 1.819 TB [0xe8e088b0 Sectors]
Non Coerced Size: 1.818 TB [0xe8d088b0 Sectors]
Coerced Size: 1.818 TB [0xe8d00000 Sectors]
Firmware state: Online, Spun Up
SAS Address(0): 0x5a4badb20bf57f88
Connected Port Number: 4(path0)
Inquiry Data:      WD-WCAVY1070166WDC WD2002FYPS-18U1B0
   05.05G07
FDE Capable: Not Capable
FDE Enable: Disable
Secured: Unsecured
Locked: Unlocked
Needs EKM Attention: No
Foreign State: None
Device Speed: Unknown
Link Speed: Unknown
Media Type: Hard Disk Device

this is sdc :

DISK GROUP: 1
Number of Spans: 1
SPAN: 0
Span Reference: 0x01
Number of PDs: 1
Number of VDs: 1
Number of dedicated Hotspares: 0
Virtual Drive Information:
Virtual Drive: 0 (Target Id: 1)
Name                :
RAID Level          : Primary-0, Secondary-0, RAID Level Qualifier-0
Size                : 1.818 TB
State               : Optimal
Stripe Size         : 64 KB
Number Of Drives    : 1
Span Depth          : 1
Default Cache Policy: WriteBack, ReadAheadNone, Direct, No Write Cache
if Bad BBU
Current Cache Policy: WriteBack, ReadAheadNone, Direct, No Write Cache
if Bad BBU
Access Policy       : Read/Write
Disk Cache Policy   : Disk's Default
Encryption Type     : None
Physical Disk Information:
Physical Disk: 0
Enclosure Device ID: 16
Slot Number: 1
Device Id: 28
Sequence Number: 4
Media Error Count: 0
Other Error Count: 0
Predictive Failure Count: 0
Last Predictive Failure Event Seq Number: 0
PD Type: SATA
Raw Size: 1.819 TB [0xe8e088b0 Sectors]
Non Coerced Size: 1.818 TB [0xe8d088b0 Sectors]
Coerced Size: 1.818 TB [0xe8d00000 Sectors]
Firmware state: Online, Spun Up
SAS Address(0): 0x5a4badb20bf57f87
Connected Port Number: 4(path0)
Inquiry Data:      WD-WCAVY1090906WDC WD2002FYPS-18U1B0
   05.05G07
FDE Capable: Not Capable
FDE Enable: Disable
Secured: Unsecured
Locked: Unlocked
Needs EKM Attention: No
Foreign State: None
Device Speed: Unknown
Link Speed: Unknown
Media Type: Hard Disk Device

.......................................................




Best Regards
HOmer Li
