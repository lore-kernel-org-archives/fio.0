Return-Path: <fio-owner@vger.kernel.org>
Received: from co01.mbox.net ([165.212.64.31]:40412 "EHLO co01.mbox.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725875AbgILSUo (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 12 Sep 2020 14:20:44 -0400
Date: Sat, 12 Sep 2020 19:20:27 +0100
From: "Ian S. Worthington" <ianworthington@usa.net>
Subject: Re: Using fio for testing for SMR
Mime-Version: 1.0
Message-ID: <925yiLsTb8736Set.1599934827@web02.cms.usa.net>
References: <177yieNdk0144Set.1599312610@web12.cms.usa.net>
 <CY4PR04MB375151FBEBA78B253EA49247E7280@CY4PR04MB3751.namprd04.prod.outlook.com>
 <551yiHoBZ0368Set.1599573745@web08.cms.usa.net> 
 <CY4PR04MB37513B33E7DFBDC3A4F94A08E7290@CY4PR04MB3751.namprd04.prod.outlook.com>
In-Reply-To: <CY4PR04MB37513B33E7DFBDC3A4F94A08E7290@CY4PR04MB3751.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Damien Le Moal <Damien.LeMoal@wdc.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

Many thanks again Damien for that great information.

I've now run the following tests:

sudo fio --name START   --eta-newline=5s --eta-interval=5s -filename=/dev/sda
--rw=randwrite --size=100t --io_size=14t  --ioengine=libaio --iodepth=4
--direct=1 --numjobs=1 --group_reporting --blocksize=4k --runtime=1m
sudo fio --name FILLSEQ --eta-newline=5s --eta-interval=5s -filename=/dev/sda
--rw=write     --size=14t  --io_size=14t  --ioengine=libaio --iodepth=4
--direct=1 --numjobs=1 --group_reporting --blocksize=512m
sudo fio --name 10TB1MB --eta-newline=5s --eta-interval=5s -filename=/dev/sda
--rw=randwrite --size=14t  --io_size=14t  --ioengine=libaio --iodepth=4
--direct=1 --numjobs=1 --group_reporting --blocksize=1m
sudo fio --name 4K10HR  --eta-newline=5s --eta-interval=5s -filename=/dev/sda
--rw=randwrite --size=14t  --io_size=14t  --ioengine=libaio --iodepth=1
--direct=1 --numjobs=1 --group_reporting --blocksize=4k --runtime=10h 

Results:

FILLSEQ:
Purpose: to fill disk as quickly as possible.
Seems FIO IOS counts blocks in some places and maybe split blocks in other
places?
blocksize=512MiB
avg bw=157MiB/s ios=58720040/93692287 msec(26.03 hours),  io=14.0TiB
(15.4TB),
14tib = 14680064 miB
~/26.03/3600 = 156.7 MiB/s
58720040 ios/93692287 msecs = 0.6267 ios/ms = 626.73 iops
157 MiB/s / 626 iops = 0.25 MiB/io = 256KiB/io => 2048 ios/512MiB 
626.73/2048=0.31 blks/sec

From https://kernel.dk/when-2mb-turns-into-512k.pdf:

pi@raspberrypi:/ $ cat /sys/block/sda/queue/max_hw_sectors_kb
256
pi@raspberrypi:/ $ cat /sys/block/sda/queue/max_sectors_kb
256
pi@raspberrypi:/ $ cat /sys/block/sda/queue/max_segments
2048
pi@raspberrypi:/ $ cat /sys/block/sda/queue/max_segment_size
65536

This tells us that the maximum size the device can support is 256KB
(max_hw_sectors_kb)
and the maximum size that the kernel allows is 256KB (max_sectors_kb). 
Additionally, the DMA engine is limited to 2048 segments of IO, 
each with a max size of 64KB.


10TB1MB:
Blksize 1MB randwrite 14TiB
Purpose: Attempt to ensure any CMA cache is full
Avg BW: 104 MiB/s; IOPS: 104
Samples: BW min: 32 MiB/s; max: 190 MiB/s; avg=104 MiB/s
		 IOPS min: 32; max: 190; avg: 104
lat (msec)   : 4=0.01%, 10=0.01%, 20=0.86%, 50=98.44%, 100=0.69%
lat (msec)   : 250=0.01%, 500=0.01%


4K10HR:
10 hours of randwrite blksize=4KiB
Purpose: See if we can see any delays caused by forced destaging from CMA
cache to SMA
BW: 1960 KiB/s; IOPS: 489; 67.3 GiB written
Sampling:
BW min: 640 KiB/s; max: 8264 KiB/s
IOPS min: 160; max: 2066
  lat (usec)   : 20=0.01%, 50=0.01%, 250=0.01%, 500=1.12%, 750=5.86%
  lat (usec)   : 1000=1.80%
  lat (msec)   : 2=48.59%, 4=39.72%, 10=2.81%, 20=0.07%, 50=0.02%
  lat (msec)   : 100=0.01%, 250=0.01%, 500=0.01%
No obvious slow downs in fio log.

Conclusions:

So my guess, from the absence of any drastic slow downs during the 4K test is
that either this disk is not an SMR disk, or if it is, I'm not showing it in a
test that writes 4k random for only 10 hours.

> Getting
> clear information from the drive vendors seems to me like a much easier
solution :)

Totally agree.  I've declined to look until now in case it biased my
analysis.

The model here is a WD140EMFZ-11A0WA0 which WD don't seem to publish any
information on. HDDScan claim in their blog that its a CMR (PMR, He) drive
manufactured by HGST (https://hddscan.com/blog/2020/hdd-wd-smr.html), but I
have no idea if this information is reliable or not.

Ian
...



