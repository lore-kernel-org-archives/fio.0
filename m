Return-Path: <fio-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:43323 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754553AbZIKQfg (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 11 Sep 2009 12:35:36 -0400
Date: Fri, 11 Sep 2009 18:35:39 +0200
From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Bug in fio: infinite loop when using two volumes crafted from  one  MD?
Message-ID: <20090911163539.GK14984@kernel.dk>
References: <1252684789.5814.29.camel@cail>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1252684789.5814.29.camel@cail>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Cc: fio@vger.kernel.org

On Fri, Sep 11 2009, Alan D. Brunelle wrote:
> I have a somewhat complex (but practical) situation I'm trying to
> measure (looking at Goyal's io-controller patches). 
> 
> o  24-disk MD RAID10 set (/dev/md0)
> 
> o  12 linear LV volumes crafted from /dev/md0
> 
> o  Ext3 FS created on each LV volume
> 
> o  16GiB test file created on each FS
> 
> # du -s -h /mnt/lv[01]/data.bin
> 33G     /mnt/lv0/data.bin
> 33G     /mnt/lv1/data.bin
> 
> When I execute the following job file (only using 2 of the 12 files/FS):
> 
> [global]
> rw=rw
> rwmixread=80
> randrepeat=1
> size=32g
> direct=0
> ioengine=libaio
> iodepth=32
> iodepth_low=32
> iodepth_batch=32
> iodepth_batch_complete=6
> overwrite=0
> bs=4k
> runtime=30
> 
> [lv0]
> filename=/mnt/lv0/data.bin
> 
> [test]
> filename=/mnt/lv1/data.bin
> 
> the I/O portion of the run completes, but whilst attempting to display
> the Disk stats it hangs whilst outputting:
> 
> ...
> Run status group 0 (all jobs):
>    READ: io=3,602MB, aggrb=120MB/s, minb=61,754KB/s, maxb=64,135KB/s,
> mint=30002msec, maxt=30005msec
>   WRITE: io=903MB, aggrb=30,813KB/s, minb=15,537KB/s, maxb=16,016KB/s,
> mint=30002msec, maxt=30005msec
> 
> Disk stats (read/write):
> 
> <<<hangs...>>>
> 
> Breaking in (via gdb) yields:
> (gdb) where
> #0  0x0000000000428bb4 in aggregate_slaves_stats
> (masterdu=0x7f21bbf511e8)
>     at diskutil.c:458
> #1  0x000000000042905c in show_disk_util () at diskutil.c:528
> #2  0x00000000004121bb in show_run_stats () at stat.c:663
> #3  0x000000000040acad in main (argc=2, argv=0x7fff6b83bba8) at
> fio.c:1654
> 
> setting a break at:
> 
> 454                     ios[0] += dus->ios[0];
> 
> and using 'cont' & "print *slavedu" yields:
> 
> (gdb) print *slavedu
> $3 = {list = {next = 0x28000156a7, prev = 0x1571500006e19}, slavelist =
> {
>     next = 0x7f21bbf513f8, prev = 0x7f21bbf513f8}, 
>   name = 0x74b4 <Address 0x74b4 out of bounds>, 
>   sysfs_root = 0x4aaa6cce <Address 0x4aaa6cce out of bounds>, 
>   path = "\030???\r\000\000\000\000\000\000\020i???!\177\000\000\000\000\000
> \000\000\000\000\000???Z???Z\000\000\000\000\024\000\000\000??????dm-1\000\000
> \000\000???Z???Z", '\0' <repeats 12 times>, "???\001\000\000?????????G???!\177\000
> \000???G???!\177\000\000???G???!\177\000\000???G???!\177\000\000???I???!\177\000\000???W
> \203k???\177\000\000/sys/block/dm-1/slaves/../../md0/stat", '\0' <repeats
> 98 times>, major = 0, minor = 0, 
>   dus = {ios = {0, 0}, merges = {0, 0}, sectors = {0, 0}, ticks = {0,
> 0}, 
>     io_ticks = 0, time_in_queue = 0}, last_dus = {ios = {0, 0}, merges =
> {0, 
>       0}, sectors = {0, 0}, ticks = {0, 0}, io_ticks = 0, time_in_queue
> = 0}, 
>   slaves = {next = 0x0, prev = 0x0}, msec = 9, time = {tv_sec = 0, 
>     tv_usec = 0}, lock = 0x0, users = 0}
> (gdb) cont
> Continuing.
> 
> Breakpoint 1, aggregate_slaves_stats (masterdu=0x7f21bbf511e8)
>     at diskutil.c:454
> 454                     ios[0] += dus->ios[0];
> (gdb) print *slavedu
> $4 = {list = {next = 0x7f21bbf515e8, prev = 0x7f21bbf511e8}, slavelist =
> {
>     next = 0x7f21bbf54780, prev = 0x7f21bbf54780}, 
>   name = 0x7f21bbf515c8 "md0", 
>   sysfs_root = 0x7fff6b8357f0 "/sys/block/dm-1/slaves/../../md0", 
>   path = "/sys/block/dm-0/slaves/../../md0/stat", '\0' <repeats 218
> times>, 
>   major = 9, minor = 0, dus = {ios = {0, 0}, merges = {0, 0}, sectors =
> {0, 
>       0}, ticks = {0, 0}, io_ticks = 0, time_in_queue = 0}, last_dus =
> {ios = {
>       567924, 118793}, merges = {0, 0}, sectors = {71929094, 950344},
> ticks = {
>       0, 0}, io_ticks = 0, time_in_queue = 0}, slaves = {
>     next = 0x7f21bbf515f8, prev = 0x7f21bbf543f8}, msec = 0, time = {
>     tv_sec = 1252682928, tv_usec = 935566}, lock = 0x7f21bc973000, users
> = 0}
> (gdb) cont
> Continuing.
> 
> Breakpoint 1, aggregate_slaves_stats (masterdu=0x7f21bbf511e8)
>     at diskutil.c:454
> 454                     ios[0] += dus->ios[0];
> (gdb) print *slavedu
> $5 = {list = {next = 0x28000156a7, prev = 0x1571500006e19}, slavelist =
> {
>     next = 0x7f21bbf513f8, prev = 0x7f21bbf513f8}, 
>   name = 0x74b4 <Address 0x74b4 out of bounds>, 
>   sysfs_root = 0x4aaa6cce <Address 0x4aaa6cce out of bounds>, 
>   path = "\030???\r\000\000\000\000\000\000\020i???!\177\000\000\000\000\000
> \000\000\000\000\000???Z???Z\000\000\000\000\024\000\000\000??????dm-1\000\000
> \000\000???Z???Z", '\0' <repeats 12 times>, "???\001\000\000?????????G???!\177\000
> \000???G???!\177\000\000???G???!\177\000\000???G???!\177\000\000???I???!\177\000\000???W
> \203k???\177\000\000/sys/block/dm-1/slaves/../../md0/stat", '\0' <repeats
> 98 times>, major = 0, minor = 0, 
>   dus = {ios = {0, 0}, merges = {0, 0}, sectors = {0, 0}, ticks = {0,
> 0}, 
>     io_ticks = 0, time_in_queue = 0}, last_dus = {ios = {0, 0}, merges =
> {0, 
>       0}, sectors = {0, 0}, ticks = {0, 0}, io_ticks = 0, time_in_queue
> = 0}, 
>   slaves = {next = 0x0, prev = 0x0}, msec = 9, time = {tv_sec = 0, 
>     tv_usec = 0}, lock = 0x0, users = 0}
> 
> and then it seems to be bouncing between these two "things". 
> 
> Now using a totally separate disk & FS & data file:
> 
> # du -s -h /mnt/lv0/data.bin /mnt/test/data.bin 
> 33G     /mnt/lv0/data.bin
> 33G     /mnt/test/data.bin
> 
> (/mnt/test is *not* constructed from the MD device) 
> 
> and changing the job file to look like:
> 
> [test]
> filename=/mnt/test/data.bin
> 
> (Removing the /dev/vg/lv1 file)
> 
> It runs to completion correctly.
> 
> It seems to me that there may be some error in the logic dealing with
> finding the underlying devices for different mount points/files the come
> to the same underlying device (/dev/md0, in this case?)? 

Fio does indeed have code to find the below devices for stat purposes,
sure does sound like there's a bug in there. If you have time to poke at
it and find out why, that would be great :-)

If not, I'll try and take a look.

-- 
Jens Axboe

