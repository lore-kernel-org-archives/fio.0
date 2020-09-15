Return-Path: <fio-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:27836 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726019AbgIOC2u (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 14 Sep 2020 22:28:50 -0400
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: Using fio for testing for SMR
Date: Tue, 15 Sep 2020 02:28:48 +0000
Message-ID: <CY4PR04MB3751C2D2477B316DE66AC058E7200@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <177yieNdk0144Set.1599312610@web12.cms.usa.net>
 <CY4PR04MB375151FBEBA78B253EA49247E7280@CY4PR04MB3751.namprd04.prod.outlook.com>
 <551yiHoBZ0368Set.1599573745@web08.cms.usa.net>
 <CY4PR04MB37513B33E7DFBDC3A4F94A08E7290@CY4PR04MB3751.namprd04.prod.outlook.com>
 <925yiLsTb8736Set.1599934827@web02.cms.usa.net>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Ian S. Worthington" <ianworthington@usa.net>, "fio@vger.kernel.org" <fio@vger.kernel.org>

On 2020/09/13 3:20, Ian S. Worthington wrote:=0A=
> Many thanks again Damien for that great information.=0A=
> =0A=
> I've now run the following tests:=0A=
> =0A=
> sudo fio --name START   --eta-newline=3D5s --eta-interval=3D5s -filename=
=3D/dev/sda=0A=
> --rw=3Drandwrite --size=3D100t --io_size=3D14t  --ioengine=3Dlibaio --iod=
epth=3D4=0A=
> --direct=3D1 --numjobs=3D1 --group_reporting --blocksize=3D4k --runtime=
=3D1m=0A=
> sudo fio --name FILLSEQ --eta-newline=3D5s --eta-interval=3D5s -filename=
=3D/dev/sda=0A=
> --rw=3Dwrite     --size=3D14t  --io_size=3D14t  --ioengine=3Dlibaio --iod=
epth=3D4=0A=
> --direct=3D1 --numjobs=3D1 --group_reporting --blocksize=3D512m=0A=
> sudo fio --name 10TB1MB --eta-newline=3D5s --eta-interval=3D5s -filename=
=3D/dev/sda=0A=
> --rw=3Drandwrite --size=3D14t  --io_size=3D14t  --ioengine=3Dlibaio --iod=
epth=3D4=0A=
> --direct=3D1 --numjobs=3D1 --group_reporting --blocksize=3D1m=0A=
> sudo fio --name 4K10HR  --eta-newline=3D5s --eta-interval=3D5s -filename=
=3D/dev/sda=0A=
> --rw=3Drandwrite --size=3D14t  --io_size=3D14t  --ioengine=3Dlibaio --iod=
epth=3D1=0A=
> --direct=3D1 --numjobs=3D1 --group_reporting --blocksize=3D4k --runtime=
=3D10h =0A=
> =0A=
> Results:=0A=
> =0A=
> FILLSEQ:=0A=
> Purpose: to fill disk as quickly as possible.=0A=
> Seems FIO IOS counts blocks in some places and maybe split blocks in othe=
r=0A=
> places?=0A=
> blocksize=3D512MiB=0A=
> avg bw=3D157MiB/s ios=3D58720040/93692287 msec(26.03 hours),  io=3D14.0Ti=
B=0A=
> (15.4TB),=0A=
> 14tib =3D 14680064 miB=0A=
> ~/26.03/3600 =3D 156.7 MiB/s=0A=
> 58720040 ios/93692287 msecs =3D 0.6267 ios/ms =3D 626.73 iops=0A=
> 157 MiB/s / 626 iops =3D 0.25 MiB/io =3D 256KiB/io =3D> 2048 ios/512MiB =
=0A=
> 626.73/2048=3D0.31 blks/sec=0A=
> =0A=
> From https://kernel.dk/when-2mb-turns-into-512k.pdf:=0A=
> =0A=
> pi@raspberrypi:/ $ cat /sys/block/sda/queue/max_hw_sectors_kb=0A=
> 256=0A=
> pi@raspberrypi:/ $ cat /sys/block/sda/queue/max_sectors_kb=0A=
> 256=0A=
> pi@raspberrypi:/ $ cat /sys/block/sda/queue/max_segments=0A=
> 2048=0A=
> pi@raspberrypi:/ $ cat /sys/block/sda/queue/max_segment_size=0A=
> 65536=0A=
> =0A=
> This tells us that the maximum size the device can support is 256KB=0A=
> (max_hw_sectors_kb)=0A=
> and the maximum size that the kernel allows is 256KB (max_sectors_kb). =
=0A=
=0A=
Which highly depends on the HBA since the hard-disk interface will accept m=
uch=0A=
larger commands. This 256KB on your system seems to be very low. What HBA a=
re=0A=
you using ? These days, most SAS HBAs have at least 128 or 256 segments, wh=
ich=0A=
allow up to 512KB/1MB IOs. SATA/AHCI is limited at 169 segments for up to 3=
2MB=0A=
max_hw_sectors_kb (and 1280 KB max_sectors_kb).=0A=
=0A=
> Additionally, the DMA engine is limited to 2048 segments of IO, =0A=
> each with a max size of 64KB.=0A=
=0A=
That's a lot. I wonder why max_hw_sectors_kb end up so small.=0A=
=0A=
> 10TB1MB:=0A=
> Blksize 1MB randwrite 14TiB=0A=
> Purpose: Attempt to ensure any CMA cache is full=0A=
> Avg BW: 104 MiB/s; IOPS: 104=0A=
> Samples: BW min: 32 MiB/s; max: 190 MiB/s; avg=3D104 MiB/s=0A=
> 		 IOPS min: 32; max: 190; avg: 104=0A=
> lat (msec)   : 4=3D0.01%, 10=3D0.01%, 20=3D0.86%, 50=3D98.44%, 100=3D0.69=
%=0A=
> lat (msec)   : 250=3D0.01%, 500=3D0.01%=0A=
> =0A=
> =0A=
> 4K10HR:=0A=
> 10 hours of randwrite blksize=3D4KiB=0A=
> Purpose: See if we can see any delays caused by forced destaging from CMA=
=0A=
> cache to SMA=0A=
> BW: 1960 KiB/s; IOPS: 489; 67.3 GiB written=0A=
> Sampling:=0A=
> BW min: 640 KiB/s; max: 8264 KiB/s=0A=
> IOPS min: 160; max: 2066=0A=
>   lat (usec)   : 20=3D0.01%, 50=3D0.01%, 250=3D0.01%, 500=3D1.12%, 750=3D=
5.86%=0A=
>   lat (usec)   : 1000=3D1.80%=0A=
>   lat (msec)   : 2=3D48.59%, 4=3D39.72%, 10=3D2.81%, 20=3D0.07%, 50=3D0.0=
2%=0A=
>   lat (msec)   : 100=3D0.01%, 250=3D0.01%, 500=3D0.01%=0A=
> No obvious slow downs in fio log.=0A=
> =0A=
> Conclusions:=0A=
> =0A=
> So my guess, from the absence of any drastic slow downs during the 4K tes=
t is=0A=
> that either this disk is not an SMR disk, or if it is, I'm not showing it=
 in a=0A=
> test that writes 4k random for only 10 hours.=0A=
> =0A=
>> Getting=0A=
>> clear information from the drive vendors seems to me like a much easier=
=0A=
> solution :)=0A=
> =0A=
> Totally agree.  I've declined to look until now in case it biased my=0A=
> analysis.=0A=
> =0A=
> The model here is a WD140EMFZ-11A0WA0 which WD don't seem to publish any=
=0A=
> information on. HDDScan claim in their blog that its a CMR (PMR, He) driv=
e=0A=
> manufactured by HGST (https://hddscan.com/blog/2020/hdd-wd-smr.html), but=
 I=0A=
> have no idea if this information is reliable or not.=0A=
=0A=
=0A=
The list of WD drives using SMR as drive-managed is published. See:=0A=
=0A=
https://blog.westerndigital.com/wd-red-nas-drives/=0A=
=0A=
and=0A=
=0A=
https://blog.westerndigital.com/wp-content/uploads/2020/07/WD_SMR_SKUs_vDS.=
pdf=0A=
=0A=
Your drive is not on the list :)=0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=

