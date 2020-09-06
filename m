Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728905AbgIFOUN (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 6 Sep 2020 10:20:13 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0659C061573
        for <fio@vger.kernel.org>; Sun,  6 Sep 2020 07:14:19 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id j2so12096167wrx.7
        for <fio@vger.kernel.org>; Sun, 06 Sep 2020 07:14:19 -0700 (PDT)
MIME-Version: 1.0
References: <177yieNdk0144Set.1599312610@web12.cms.usa.net>
In-Reply-To: <177yieNdk0144Set.1599312610@web12.cms.usa.net>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Sun, 6 Sep 2020 15:13:51 +0100
Message-ID: <CALjAwxhQAPucLh5mL_=4ydUH3btioAAEehKHLJDqqhgbeSdQ3w@mail.gmail.com>
Subject: Re: Using fio for testing for SMR
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Ian S. Worthington" <ianworthington@usa.net>
Cc: fio <fio@vger.kernel.org>

On Sat, 5 Sep 2020 at 14:40, Ian S. Worthington <ianworthington@usa.net> wrote:
>
> I'm trying to establish if a new disk is SMR or not, or has any other
> characteristics that would make it unsuitable for use in a zfs array.
>
> CrystalDiskMark suggests it has a speed of 6~8 MB/s in its RND4K testing.
>
> iiuc SMR disks contain a CMR area, possibly of variable size, which is used as
> a cache, so to test a drive I need to ensure I fill this cache to the drive is
> forced to start shingling.
>
> As the disk is 14TB, my first test used:
>
> sudo fio --name TEST --eta-newline=5s --filename=/dev/sda --rw=randwrite
> --size=100t --io_size=14t  --ioengine=libaio --iodepth=1 --direct=1
> --numjobs=1 --runtime=10h --group_reporting
>
> which reported:
>
> TEST: (groupid=0, jobs=1): err= 0: pid=4685: Sat Sep  5 07:42:02 2020
>   write: IOPS=490, BW=1962KiB/s (2009kB/s)(67.4GiB/36000002msec); 0 zone
> resets
>     slat (usec): min=16, max=10242, avg=41.02, stdev=11.10
>     clat (usec): min=17, max=371540, avg=1980.75, stdev=1016.94
>      lat (usec): min=283, max=371587, avg=2024.00, stdev=1016.92
>     clat percentiles (usec):
>      |  1.00th=[  486],  5.00th=[  594], 10.00th=[ 1074], 20.00th=[ 1418],
>      | 30.00th=[ 1565], 40.00th=[ 1713], 50.00th=[ 1876], 60.00th=[ 2040],
>      | 70.00th=[ 2245], 80.00th=[ 2474], 90.00th=[ 2933], 95.00th=[ 3589],
>      | 99.00th=[ 4686], 99.50th=[ 5211], 99.90th=[ 8356], 99.95th=[11863],
>      | 99.99th=[21627]
>    bw (  KiB/s): min=  832, max= 7208, per=100.00%, avg=1961.66, stdev=105.29,
> samples=72000
>    iops        : min=  208, max= 1802, avg=490.40, stdev=26.31, samples=72000
>
> I have a number of concerns about this test:
>
> 1. Why is the average speed, 2MB/s, so much lower than that reported by
> CrystalDiskMark?

Hard to say without seeing the exact crystal disk mark job and knowing
how the I/O ends up being seen by the disk. I heard below the hood it
uses diskspd so it would be good to know what parameters it was
sending to that along and/or information about what the *disk* was
actually seeing (e.g. average block size and depth)... Bear in mind
that CDM is usually a filesystem test rather than a block device/raw
disk test so there's some indirection compared to the fio job above
(assuming /dev/sda is a SATA block device).

> 2. After running for 10 hours, only 67 GiB were written.  This could easily
> not yet have filled any CMR cache on a SMR disk, rendering the test
> worthless.
>
> I then ran some 5m tests, using different blocksizes in the command
>
> sudo fio --name TEST --eta-newline=5s --filename=/dev/sda --rw=randwrite
> --size=100t --io_size=14t  --ioengine=libaio --iodepth=1 --direct=1
> --numjobs=1 --runtime=5m --group_reporting --blocksize=xxx
>
> with the result:
>
> blksize speed(MB/s) IOPS
>   4k        2        490
>   1M      100         97
>  10M      130         12
> 100M      160        1~2
>   1G      160          -

I'm not sure I saw the question in this one... Note: when the block
size gets big enough (probably somewhere between 512K but less than 2M
from reading https://stackoverflow.com/a/59403297 and
https://kernel.dk/when-2mb-turns-into-512k.pdf ) the kernel block
layer will split the bigger block into smaller pieces (which it might
then choose to send down to the disk in parallel).

> 3. I'm considering running a dual test, where I first write, say 10TB data
> with a blocksize of 1M (28 hours), followed by 10 hours of 4k writes again.
> Although the 1M block contents will be sequential data, can I assume that
> enough of them will do via any CMR cache in order to fill it up and reveal any
> slow down?

I think that would depend on the size of the cache, the speed at which
it was filled and the speed at which said cache could be destaged. If
those 1MByte blocks are sent "slowly" then the destaging may be able
to keep up...

-- 
Sitsofe | http://sucs.org/~sits/

