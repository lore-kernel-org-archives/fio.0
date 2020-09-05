Return-Path: <fio-owner@vger.kernel.org>
Received: from co01.mbox.net ([165.212.64.31]:47214 "EHLO co01.mbox.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728591AbgIENgC (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 5 Sep 2020 09:36:02 -0400
Received: from co01.mbox.net (localhost [127.0.0.1])
        by co01.mbox.net (Postfix) with ESMTP id 4BkFlp2nXJzs4T4
        for <fio@vger.kernel.org>; Sat,  5 Sep 2020 13:30:14 +0000 (UTC)
Date: Sat, 05 Sep 2020 14:30:10 +0100
From: "Ian S. Worthington" <ianworthington@usa.net>
Subject: Using fio for testing for SMR
Mime-Version: 1.0
Message-ID: <177yieNdk0144Set.1599312610@web12.cms.usa.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

I'm trying to establish if a new disk is SMR or not, or has any other
characteristics that would make it unsuitable for use in a zfs array.

CrystalDiskMark suggests it has a speed of 6~8 MB/s in its RND4K testing.

iiuc SMR disks contain a CMR area, possibly of variable size, which is used as
a cache, so to test a drive I need to ensure I fill this cache to the drive is
forced to start shingling. 

As the disk is 14TB, my first test used:

sudo fio --name TEST --eta-newline=5s --filename=/dev/sda --rw=randwrite
--size=100t --io_size=14t  --ioengine=libaio --iodepth=1 --direct=1
--numjobs=1 --runtime=10h --group_reporting

which reported:

TEST: (groupid=0, jobs=1): err= 0: pid=4685: Sat Sep  5 07:42:02 2020
  write: IOPS=490, BW=1962KiB/s (2009kB/s)(67.4GiB/36000002msec); 0 zone
resets
    slat (usec): min=16, max=10242, avg=41.02, stdev=11.10
    clat (usec): min=17, max=371540, avg=1980.75, stdev=1016.94
     lat (usec): min=283, max=371587, avg=2024.00, stdev=1016.92
    clat percentiles (usec):
     |  1.00th=[  486],  5.00th=[  594], 10.00th=[ 1074], 20.00th=[ 1418],
     | 30.00th=[ 1565], 40.00th=[ 1713], 50.00th=[ 1876], 60.00th=[ 2040],
     | 70.00th=[ 2245], 80.00th=[ 2474], 90.00th=[ 2933], 95.00th=[ 3589],
     | 99.00th=[ 4686], 99.50th=[ 5211], 99.90th=[ 8356], 99.95th=[11863],
     | 99.99th=[21627]
   bw (  KiB/s): min=  832, max= 7208, per=100.00%, avg=1961.66, stdev=105.29,
samples=72000
   iops        : min=  208, max= 1802, avg=490.40, stdev=26.31, samples=72000

I have a number of concerns about this test:

1. Why is the average speed, 2MB/s, so much lower than that reported by
CrystalDiskMark?

2. After running for 10 hours, only 67 GiB were written.  This could easily
not yet have filled any CMR cache on a SMR disk, rendering the test
worthless.

I then ran some 5m tests, using different blocksizes in the command

sudo fio --name TEST --eta-newline=5s --filename=/dev/sda --rw=randwrite
--size=100t --io_size=14t  --ioengine=libaio --iodepth=1 --direct=1
--numjobs=1 --runtime=5m --group_reporting --blocksize=xxx

with the result:

blksize speed(MB/s) IOPS
  4k        2        490
  1M      100         97
 10M      130         12
100M      160        1~2
  1G      160          -

3. I'm considering running a dual test, where I first write, say 10TB data
with a blocksize of 1M (28 hours), followed by 10 hours of 4k writes again. 
Although the 1M block contents will be sequential data, can I assume that
enough of them will do via any CMR cache in order to fill it up and reveal any
slow down?






