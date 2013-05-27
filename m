Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:47069 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752566Ab3E0Qss (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 27 May 2013 12:48:48 -0400
Date: Mon, 27 May 2013 18:48:18 +0200
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: Any Delay Introduced by FIO between submission of Two IOs?
Message-ID: <20130527164818.GI29680@kernel.dk>
References: <CAJqT0ix50Pr0+DEVVStAZxiAa6Xx=SGRwQQX9QXa0Jdu13HG2A@mail.gmail.com>
 <20130527133332.GH29680@kernel.dk>
 <CAJqT0izq6_VZ1n8wWR1px+WVDkM9uo+1Hrs=e3oS3HVkOEWMfg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJqT0izq6_VZ1n8wWR1px+WVDkM9uo+1Hrs=e3oS3HVkOEWMfg@mail.gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: sampath rapaka <sampath.rapaka@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Please don't top post!

On Mon, May 27 2013, sampath rapaka wrote:
> hi jens
> 
> Firstly sorry for misplacing the logs in the above mail. Those are
> excerpts from other test program.
> 
> Thanks for your clarification.
> 
> FIO Job File is some thing like this :
> 
>   3 [global]
>   4 ioengine=libaio
>   5 direct=1
>   6 filename=/dev/md0
>   7 blocksize=4k
>   8 iodepth=${IoDepth}
>   9 size=${Size}
>  10 write_iops_log=total_iops_W9R1
>  11
>  12 [read1]
>  13 rw=randread
>  14 write_lat_log=read1_W9R1
>  15
>  16
>  17 [write1]
>  18 rw=randwrite
>  19 write_lat_log=write1_W9R1
>  20
>  21 [write2]
>  22 rw=randwrite
>  23 write_lat_log=write2_W9R1
> 
> 
> Below is the log from blktrace:
> 
> 
> 1163147   8,16   0   172181     2.386764602     0  C  WS 872560 + 8
> [0]  >> This is where commit to 8,16 happens
> 
> 1163148   8,16   0   172182     2.386767040     0  D  WS 2244224 + 8 [swapper/0]
> 
> 1163149   8,32   0   269041     2.388917654     0  C  WS 4992504 + 8 [0]
> 
> 1163150   8,32   0   269042     2.388923411     0  D  WS 3160896 + 8 [swapper/0]
> 
> 1163151   9,0    0    20654     2.388933229 22220  Q  WS 4514832 + 8
> [fio]  >> This is where new IO is Queued
> 
> 1163152   8,16   3   159545     2.388938315 21059  Q  WS 4776976 + 8
> [md0_raid1_slow0]
> 
> 1163153   8,16   3   159546     2.388938804 21059  G  WS 4776976 + 8
> [md0_raid1_slow0]
> 
> Gap between those lines seems to be big. So i was wondering whether
> any Delay is introduced by FIO.

Fio isn't adding delays for that. Are you using the CFQ IO scheduler?
The above are direct writes, so it could decide to idle.

> I have one more question in general though not related to above logs.
> Increasing the nr_request value for a device(some thousands) results
> in increase in Q-D values for a IO while  having  queue depth at 31?
> 
> echo 10000 > /sys/block/sdb/queue/nr_requests
> 
> echo 31 > /sys/block/sdb/device/queue_depth

Yes, increasing that to some huge number could result in having requests
sit in the IO scheduler for much longer before going to the device,
hence much larger Q2D times.

-- 
Jens Axboe

