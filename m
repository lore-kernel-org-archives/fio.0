Return-Path: <fio-owner@vger.kernel.org>
Received: from co02.mbox.net ([165.212.64.32]:59908 "EHLO co02.mbox.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731234AbgIHQFh (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 8 Sep 2020 12:05:37 -0400
Date: Tue, 08 Sep 2020 15:02:25 +0100
From: "Ian S. Worthington" <ianworthington@usa.net>
Subject: Re: Using fio for testing for SMR
Mime-Version: 1.0
Message-ID: <551yiHoBZ0368Set.1599573745@web08.cms.usa.net>
References: <177yieNdk0144Set.1599312610@web12.cms.usa.net>
 <CY4PR04MB375151FBEBA78B253EA49247E7280@CY4PR04MB3751.namprd04.prod.outlook.com>
In-Reply-To: <CY4PR04MB375151FBEBA78B253EA49247E7280@CY4PR04MB3751.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Damien Le Moal <Damien.LeMoal@wdc.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

Hello Damien --

Many thanks indeed for this most comprehensive answer.

> On Linux, one easy thing to check is to look at:
> 
> cat /sys/block/<disk name>/device/scsi_disk/X:Y:Z:N/zoned_cap
> 
> A drive managed SMR disk that is no hiding its true nature will say
> "drive-managed". You will need kernel 5.8 to have this attribute files.
> Otherwise, you can use SG to inspect the VPD page 0xB1 (block device
> characteristics). Look for the value of bits 4-5 of byte 8 (ZONED field). If
the
> value is 2 (10b), then your disk is a drive managed SMR disk.

I'm not on 5.8, so I guess that's why I don't have a zoned_cap. But:

sudo sg_vpd --page=bdc /dev/sda
Block device characteristics VPD page (SBC):
  Nominal rotation rate: 5400 rpm
  Product type: Not specified
  WABEREQ=0
  WACEREQ=0
  Nominal form factor not reported
  ZONED=0
  RBWZ=0
  BOCS=0
  FUAB=0
  VBULS=0
  DEPOPULATION_TIME=0 (seconds)

sudo sg_vpd --page=bdc -H /dev/sda
Block device characteristics VPD page (SBC):
 00     00 b1 00 3c 15 18 00 00  00 00 00 00 00 00 00 00    ...<............
 10     00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00    ................
 20     00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00    ................
 30     00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00    ................

This seems to suggest that this is NOT a "drive managed SMR disk".  Are there
other types of SMR disks that could have zoned=0?

> > 1. Why is the average speed, 2MB/s, so much lower than that reported by
> > CrystalDiskMark?
> 
> Likely because CrystalDiskMark is very short and does not trigger internal
> sector management (GC) by the disk. Your 10h run most likely did.

Unfortunately, it was showing that speed pretty much from the start.  I ran it
again in three runs, both of 4k randwrite, with sizes of 256MB and 1GB (the
same as I used in my CDM test), and 10GB, viz:

sudo fio --name SPINUP      --eta-newline=5s --eta-interval=5s
-filename=/dev/sda --rw=randwrite --size=100t --io_size=14t --ioengine=libaio
--iodepth=4 --direct=1 --numjobs=1 --runtime=1m --group_reporting
--blocksize=4k
sudo fio --name 4K256m   --eta-newline=5s --eta-interval=5s -filename=/dev/sda
--rw=randwrite --size=256m --io_size=256m --ioengine=libaio --iodepth=1
--direct=1 --numjobs=1 --group_reporting --blocksize=4k
sudo fio --name 4K1g     --eta-newline=5s --eta-interval=5s -filename=/dev/sda
--rw=randwrite --size=1g   --io_size=1g   --ioengine=libaio --iodepth=1
--direct=1 --numjobs=1 --group_reporting --blocksize=4k
sudo fio --name 4K10g    --eta-newline=5s --eta-interval=5s -filename=/dev/sda
--rw=randwrite --size=10g   --io_size=10g   --ioengine=libaio --iodepth=1
--direct=1 --numjobs=1 --group_reporting --blocksize=4k --runtime=5m

size   KiB/s bw-min  max  avg (KiB/s)
256MB  3216    1600  6896 3216
  1G   3265    1712 12008 3263
 10G   2886    1264  6976 2885

I've noticed that always after finishing running these tests there minutes of
head seeking noise from the drive.  Is this the GC to which you refer?  I'm
curious as to what might it actually doing during this time, if we assume that
SG_VPD is correctly reporting that this is NOT an SMR drive?  Is there other
internal sector management that it might be doing?

If I ran a test where I filled the drive to capacity using sequential writes
so the drive recorded all sectors as being in use, then wrote 10TB randwrite
using a 1MB blocksize to fill as much of any CMR cache as possible, then
finally redid the 10 hour test with 4k randwrite, could I then compare the
results of that final test to the short tests to definitively show if there
were any slowdowns that might be caused by reshingling in that final test?

Best wishes,

Ian
 


------ Original Message ------
Received: 02:39 AM BST, 09/07/2020
From: Damien Le Moal <Damien.LeMoal@wdc.com>
To: "Ian S. Worthington" <ianworthington@usa.net>,       
"fio@vger.kernel.org" <fio@vger.kernel.org>
Subject: Re: Using fio for testing for SMR

> On 2020/09/05 22:38, Ian S. Worthington wrote:
> > I'm trying to establish if a new disk is SMR or not, or has any other
> > characteristics that would make it unsuitable for use in a zfs array.
> > 
> > CrystalDiskMark suggests it has a speed of 6~8 MB/s in its RND4K testing.
> > 
> > iiuc SMR disks contain a CMR area, possibly of variable size, which is
used as
> > a cache, so to test a drive I need to ensure I fill this cache to the
drive is
> > forced to start shingling. 
> 
> That is not necessarily true. One can handle the SMR sequential write
constraint
> using a log structured approach that does not require any CMR caching. It
really
> depends on how the disk FW is implemented, but generally, that is not
public
> information unfortunately.
> 
> > As the disk is 14TB, my first test used:
> > 
> > sudo fio --name TEST --eta-newline=5s --filename=/dev/sda --rw=randwrite
> > --size=100t --io_size=14t  --ioengine=libaio --iodepth=1 --direct=1
> > --numjobs=1 --runtime=10h --group_reporting
> > 
> > which reported:
> > 
> > TEST: (groupid=0, jobs=1): err= 0: pid=4685: Sat Sep  5 07:42:02 2020
> >   write: IOPS=490, BW=1962KiB/s (2009kB/s)(67.4GiB/36000002msec); 0 zone
> > resets
> >     slat (usec): min=16, max=10242, avg=41.02, stdev=11.10
> >     clat (usec): min=17, max=371540, avg=1980.75, stdev=1016.94
> >      lat (usec): min=283, max=371587, avg=2024.00, stdev=1016.92
> >     clat percentiles (usec):
> >      |  1.00th=[  486],  5.00th=[  594], 10.00th=[ 1074], 20.00th=[
1418],
> >      | 30.00th=[ 1565], 40.00th=[ 1713], 50.00th=[ 1876], 60.00th=[
2040],
> >      | 70.00th=[ 2245], 80.00th=[ 2474], 90.00th=[ 2933], 95.00th=[
3589],
> >      | 99.00th=[ 4686], 99.50th=[ 5211], 99.90th=[ 8356],
99.95th=[11863],
> >      | 99.99th=[21627]
> >    bw (  KiB/s): min=  832, max= 7208, per=100.00%, avg=1961.66,
stdev=105.29,
> > samples=72000
> >    iops        : min=  208, max= 1802, avg=490.40, stdev=26.31,
samples=72000
> > 
> > I have a number of concerns about this test:
> > 
> > 1. Why is the average speed, 2MB/s, so much lower than that reported by
> > CrystalDiskMark?
> 
> Likely because CrystalDiskMark is very short and does not trigger internal
> sector management (GC) by the disk. Your 10h run most likely did.
> 
> > 2. After running for 10 hours, only 67 GiB were written.  This could
easily
> > not yet have filled any CMR cache on a SMR disk, rendering the test
> > worthless.
> 
> Likely no. Whatever CMR space the disk has (if any at all) was likely
filled.
> The internal disk sector movements to handle SMR sequential write constraint
is
> causing enormous overhead and leading to 67GB written only. Your 2M random
write
> test is the worst possible for a drive managed SMR disk. You simply are
seeing
> what the drive performance is given the horrible conditions it is subjected
to.
> 
> > 
> > I then ran some 5m tests, using different blocksizes in the command
> > 
> > sudo fio --name TEST --eta-newline=5s --filename=/dev/sda --rw=randwrite
> > --size=100t --io_size=14t  --ioengine=libaio --iodepth=1 --direct=1
> > --numjobs=1 --runtime=5m --group_reporting --blocksize=xxx
> > 
> > with the result:
> > 
> > blksize speed(MB/s) IOPS
> >   4k        2        490
> >   1M      100         97
> >  10M      130         12
> > 100M      160        1~2
> >   1G      160          -
> > 
> > 3. I'm considering running a dual test, where I first write, say 10TB
data
> > with a blocksize of 1M (28 hours), followed by 10 hours of 4k writes
again. 
> > Although the 1M block contents will be sequential data, can I assume that
> > enough of them will do via any CMR cache in order to fill it up and reveal
any
> > slow down?
> 
> On Linux, one easy thing to check is to look at:
> 
> cat /sys/block/<disk name>/device/scsi_disk/X:Y:Z:N/zoned_cap
> 
> A drive managed SMR disk that is no hiding its true nature will say
> "drive-managed". You will need kernel 5.8 to have this attribute files.
> Otherwise, you can use SG to inspect the VPD page 0xB1 (block device
> characteristics). Look for the value of bits 4-5 of byte 8 (ZONED field). If
the
> value is 2 (10b), then your disk is a drive managed SMR disk.
> 
> 
> -- 
> Damien Le Moal
> Western Digital Research



