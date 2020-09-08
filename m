Return-Path: <fio-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:59523 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726560AbgIHXpJ (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 8 Sep 2020 19:45:09 -0400
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: Using fio for testing for SMR
Date: Tue, 8 Sep 2020 23:45:06 +0000
Message-ID: <CY4PR04MB37513B33E7DFBDC3A4F94A08E7290@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <177yieNdk0144Set.1599312610@web12.cms.usa.net>
 <CY4PR04MB375151FBEBA78B253EA49247E7280@CY4PR04MB3751.namprd04.prod.outlook.com>
 <551yiHoBZ0368Set.1599573745@web08.cms.usa.net>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Ian S. Worthington" <ianworthington@usa.net>, "fio@vger.kernel.org" <fio@vger.kernel.org>

On 2020/09/08 23:02, Ian S. Worthington wrote:=0A=
> Hello Damien --=0A=
> =0A=
> Many thanks indeed for this most comprehensive answer.=0A=
> =0A=
>> On Linux, one easy thing to check is to look at:=0A=
>>=0A=
>> cat /sys/block/<disk name>/device/scsi_disk/X:Y:Z:N/zoned_cap=0A=
>>=0A=
>> A drive managed SMR disk that is no hiding its true nature will say=0A=
>> "drive-managed". You will need kernel 5.8 to have this attribute files.=
=0A=
>> Otherwise, you can use SG to inspect the VPD page 0xB1 (block device=0A=
>> characteristics). Look for the value of bits 4-5 of byte 8 (ZONED field)=
. If=0A=
> the=0A=
>> value is 2 (10b), then your disk is a drive managed SMR disk.=0A=
> =0A=
> I'm not on 5.8, so I guess that's why I don't have a zoned_cap. But:=0A=
> =0A=
> sudo sg_vpd --page=3Dbdc /dev/sda=0A=
> Block device characteristics VPD page (SBC):=0A=
>   Nominal rotation rate: 5400 rpm=0A=
>   Product type: Not specified=0A=
>   WABEREQ=3D0=0A=
>   WACEREQ=3D0=0A=
>   Nominal form factor not reported=0A=
>   ZONED=3D0=0A=
>   RBWZ=3D0=0A=
>   BOCS=3D0=0A=
>   FUAB=3D0=0A=
>   VBULS=3D0=0A=
>   DEPOPULATION_TIME=3D0 (seconds)=0A=
> =0A=
> sudo sg_vpd --page=3Dbdc -H /dev/sda=0A=
> Block device characteristics VPD page (SBC):=0A=
>  00     00 b1 00 3c 15 18 00 00  00 00 00 00 00 00 00 00    ...<.........=
...=0A=
>  10     00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00    .............=
...=0A=
>  20     00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00    .............=
...=0A=
>  30     00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00    .............=
...=0A=
> =0A=
> This seems to suggest that this is NOT a "drive managed SMR disk".  Are t=
here=0A=
> other types of SMR disks that could have zoned=3D0?=0A=
=0A=
zoned=3D0 means "not reported". So either your disk is a regular CMR one, o=
r it is=0A=
a drive-managed SMR one but it is not confirming it :) At this point, you m=
ay=0A=
want to contact your drive vendor to ask for information. Some vendors (e.g=
. WD)=0A=
already have clarified which of their drive models are drive managed SMR. G=
oogle=0A=
it and you may be able to find more information online.=0A=
=0A=
> =0A=
>>> 1. Why is the average speed, 2MB/s, so much lower than that reported by=
=0A=
>>> CrystalDiskMark?=0A=
>>=0A=
>> Likely because CrystalDiskMark is very short and does not trigger intern=
al=0A=
>> sector management (GC) by the disk. Your 10h run most likely did.=0A=
> =0A=
> Unfortunately, it was showing that speed pretty much from the start.  I r=
an it=0A=
> again in three runs, both of 4k randwrite, with sizes of 256MB and 1GB (t=
he=0A=
> same as I used in my CDM test), and 10GB, viz:=0A=
> =0A=
> sudo fio --name SPINUP      --eta-newline=3D5s --eta-interval=3D5s=0A=
> -filename=3D/dev/sda --rw=3Drandwrite --size=3D100t --io_size=3D14t --ioe=
ngine=3Dlibaio=0A=
> --iodepth=3D4 --direct=3D1 --numjobs=3D1 --runtime=3D1m --group_reporting=
=0A=
> --blocksize=3D4k=0A=
> sudo fio --name 4K256m   --eta-newline=3D5s --eta-interval=3D5s -filename=
=3D/dev/sda=0A=
> --rw=3Drandwrite --size=3D256m --io_size=3D256m --ioengine=3Dlibaio --iod=
epth=3D1=0A=
> --direct=3D1 --numjobs=3D1 --group_reporting --blocksize=3D4k=0A=
> sudo fio --name 4K1g     --eta-newline=3D5s --eta-interval=3D5s -filename=
=3D/dev/sda=0A=
> --rw=3Drandwrite --size=3D1g   --io_size=3D1g   --ioengine=3Dlibaio --iod=
epth=3D1=0A=
> --direct=3D1 --numjobs=3D1 --group_reporting --blocksize=3D4k=0A=
> sudo fio --name 4K10g    --eta-newline=3D5s --eta-interval=3D5s -filename=
=3D/dev/sda=0A=
> --rw=3Drandwrite --size=3D10g   --io_size=3D10g   --ioengine=3Dlibaio --i=
odepth=3D1=0A=
> --direct=3D1 --numjobs=3D1 --group_reporting --blocksize=3D4k --runtime=
=3D5m=0A=
> =0A=
> size   KiB/s bw-min  max  avg (KiB/s)=0A=
> 256MB  3216    1600  6896 3216=0A=
>   1G   3265    1712 12008 3263=0A=
>  10G   2886    1264  6976 2885=0A=
=0A=
4K@QD=3D4 random write at 3MB/s is actually pretty normal. That is about 80=
0 IOPS.=0A=
I am getting similar results with CMR disks too.=0A=
=0A=
> I've noticed that always after finishing running these tests there minute=
s of=0A=
> head seeking noise from the drive.  Is this the GC to which you refer?  I=
'm=0A=
> curious as to what might it actually doing during this time, if we assume=
 that=0A=
> SG_VPD is correctly reporting that this is NOT an SMR drive?  Is there ot=
her=0A=
> internal sector management that it might be doing?=0A=
=0A=
Well, yes. There are a lot of things that drives can do to try to improve s=
mall=0A=
random IO performance, especially writes. E.g. use opportunistic media cach=
ing=0A=
(not in place writes) is special reserved areas of the disk, transforming t=
he=0A=
random pattern into a more sequential one. And such method of course result=
s in=0A=
these media cache areas being cleaned up later to free space (sectors are m=
oved=0A=
in place). And if this is really a drive managed SMR disk, then GC is a=0A=
possibility too. But this is all speculation. Again, without detailed knowl=
edge=0A=
of the disk FW implementation (and if it is SMR or not), this is all guess =
work.=0A=
=0A=
> If I ran a test where I filled the drive to capacity using sequential wri=
tes=0A=
> so the drive recorded all sectors as being in use, then wrote 10TB randwr=
ite=0A=
> using a 1MB blocksize to fill as much of any CMR cache as possible, then=
=0A=
> finally redid the 10 hour test with 4k randwrite, could I then compare th=
e=0A=
> results of that final test to the short tests to definitively show if the=
re=0A=
> were any slowdowns that might be caused by reshingling in that final test=
?=0A=
=0A=
No idea. I do not think this can give a definitive/reliable answer. Getting=
=0A=
clear information from the drive vendors seems to me like a much easier sol=
ution :)=0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=

