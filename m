Return-Path: <fio-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:16565 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726733AbgIGBiy (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 6 Sep 2020 21:38:54 -0400
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: Using fio for testing for SMR
Date: Mon, 7 Sep 2020 01:38:50 +0000
Message-ID: <CY4PR04MB375151FBEBA78B253EA49247E7280@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <177yieNdk0144Set.1599312610@web12.cms.usa.net>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Ian S. Worthington" <ianworthington@usa.net>, "fio@vger.kernel.org" <fio@vger.kernel.org>

On 2020/09/05 22:38, Ian S. Worthington wrote:=0A=
> I'm trying to establish if a new disk is SMR or not, or has any other=0A=
> characteristics that would make it unsuitable for use in a zfs array.=0A=
> =0A=
> CrystalDiskMark suggests it has a speed of 6~8 MB/s in its RND4K testing.=
=0A=
> =0A=
> iiuc SMR disks contain a CMR area, possibly of variable size, which is us=
ed as=0A=
> a cache, so to test a drive I need to ensure I fill this cache to the dri=
ve is=0A=
> forced to start shingling. =0A=
=0A=
That is not necessarily true. One can handle the SMR sequential write const=
raint=0A=
using a log structured approach that does not require any CMR caching. It r=
eally=0A=
depends on how the disk FW is implemented, but generally, that is not publi=
c=0A=
information unfortunately.=0A=
=0A=
> As the disk is 14TB, my first test used:=0A=
> =0A=
> sudo fio --name TEST --eta-newline=3D5s --filename=3D/dev/sda --rw=3Drand=
write=0A=
> --size=3D100t --io_size=3D14t  --ioengine=3Dlibaio --iodepth=3D1 --direct=
=3D1=0A=
> --numjobs=3D1 --runtime=3D10h --group_reporting=0A=
> =0A=
> which reported:=0A=
> =0A=
> TEST: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D4685: Sat Sep  5 07:42:02 =
2020=0A=
>   write: IOPS=3D490, BW=3D1962KiB/s (2009kB/s)(67.4GiB/36000002msec); 0 z=
one=0A=
> resets=0A=
>     slat (usec): min=3D16, max=3D10242, avg=3D41.02, stdev=3D11.10=0A=
>     clat (usec): min=3D17, max=3D371540, avg=3D1980.75, stdev=3D1016.94=
=0A=
>      lat (usec): min=3D283, max=3D371587, avg=3D2024.00, stdev=3D1016.92=
=0A=
>     clat percentiles (usec):=0A=
>      |  1.00th=3D[  486],  5.00th=3D[  594], 10.00th=3D[ 1074], 20.00th=
=3D[ 1418],=0A=
>      | 30.00th=3D[ 1565], 40.00th=3D[ 1713], 50.00th=3D[ 1876], 60.00th=
=3D[ 2040],=0A=
>      | 70.00th=3D[ 2245], 80.00th=3D[ 2474], 90.00th=3D[ 2933], 95.00th=
=3D[ 3589],=0A=
>      | 99.00th=3D[ 4686], 99.50th=3D[ 5211], 99.90th=3D[ 8356], 99.95th=
=3D[11863],=0A=
>      | 99.99th=3D[21627]=0A=
>    bw (  KiB/s): min=3D  832, max=3D 7208, per=3D100.00%, avg=3D1961.66, =
stdev=3D105.29,=0A=
> samples=3D72000=0A=
>    iops        : min=3D  208, max=3D 1802, avg=3D490.40, stdev=3D26.31, s=
amples=3D72000=0A=
> =0A=
> I have a number of concerns about this test:=0A=
> =0A=
> 1. Why is the average speed, 2MB/s, so much lower than that reported by=
=0A=
> CrystalDiskMark?=0A=
=0A=
Likely because CrystalDiskMark is very short and does not trigger internal=
=0A=
sector management (GC) by the disk. Your 10h run most likely did.=0A=
=0A=
> 2. After running for 10 hours, only 67 GiB were written.  This could easi=
ly=0A=
> not yet have filled any CMR cache on a SMR disk, rendering the test=0A=
> worthless.=0A=
=0A=
Likely no. Whatever CMR space the disk has (if any at all) was likely fille=
d.=0A=
The internal disk sector movements to handle SMR sequential write constrain=
t is=0A=
causing enormous overhead and leading to 67GB written only. Your 2M random =
write=0A=
test is the worst possible for a drive managed SMR disk. You simply are see=
ing=0A=
what the drive performance is given the horrible conditions it is subjected=
 to.=0A=
=0A=
> =0A=
> I then ran some 5m tests, using different blocksizes in the command=0A=
> =0A=
> sudo fio --name TEST --eta-newline=3D5s --filename=3D/dev/sda --rw=3Drand=
write=0A=
> --size=3D100t --io_size=3D14t  --ioengine=3Dlibaio --iodepth=3D1 --direct=
=3D1=0A=
> --numjobs=3D1 --runtime=3D5m --group_reporting --blocksize=3Dxxx=0A=
> =0A=
> with the result:=0A=
> =0A=
> blksize speed(MB/s) IOPS=0A=
>   4k        2        490=0A=
>   1M      100         97=0A=
>  10M      130         12=0A=
> 100M      160        1~2=0A=
>   1G      160          -=0A=
> =0A=
> 3. I'm considering running a dual test, where I first write, say 10TB dat=
a=0A=
> with a blocksize of 1M (28 hours), followed by 10 hours of 4k writes agai=
n. =0A=
> Although the 1M block contents will be sequential data, can I assume that=
=0A=
> enough of them will do via any CMR cache in order to fill it up and revea=
l any=0A=
> slow down?=0A=
=0A=
On Linux, one easy thing to check is to look at:=0A=
=0A=
cat /sys/block/<disk name>/device/scsi_disk/X:Y:Z:N/zoned_cap=0A=
=0A=
A drive managed SMR disk that is no hiding its true nature will say=0A=
"drive-managed". You will need kernel 5.8 to have this attribute files.=0A=
Otherwise, you can use SG to inspect the VPD page 0xB1 (block device=0A=
characteristics). Look for the value of bits 4-5 of byte 8 (ZONED field). I=
f the=0A=
value is 2 (10b), then your disk is a drive managed SMR disk.=0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=

