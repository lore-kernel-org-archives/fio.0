Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ve0-f181.google.com ([209.85.128.181]:46162 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129AbaEGIK2 (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 7 May 2014 04:10:28 -0400
Received: by mail-ve0-f181.google.com with SMTP id pa12so778585veb.26
        for <fio@vger.kernel.org>; Wed, 07 May 2014 01:10:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BLU436-SMTP9791A8BB35991D92CA0E06E54E0@phx.gbl>
References: <BLU436-SMTP9791A8BB35991D92CA0E06E54E0@phx.gbl>
From: puvi <r.puvichakravarthy@gmail.com>
Date: Wed, 7 May 2014 13:40:07 +0530
Message-ID: <CAMYQYmpWDOYaw1wLUnyDL+mhkS4peAtwoFkr8TwJ6VFW=Fd+ZA@mail.gmail.com>
Subject: Re: Fio giving iops results that are equal to RAM speeds
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Kim Holmebakken <kim.holmebakken@hotmail.com>
Cc: fio <fio@vger.kernel.org>

Is all the reads getting satisifed from your filesystem cache? Is your
memory much larger than the file size? Can you try a run after
unmount/mount to clear the fs cache?

On Wed, May 7, 2014 at 1:15 PM, Kim Holmebakken
<kim.holmebakken@hotmail.com> wrote:
> Hey,
>
> Im currently working on a bachelor thesis where I need to measure iops on my
> storage solution.
>
> I have set up a "frontend" server(ubuntu server 13.10) which has zfs on
> linux running, and is connected to an iSCSI RAID(SAN).
>
> When I use this command:
>
> fio --directory=/pool  --size=128M --direct=0 --fallocate=none --rw=randrw
> --refill_buffers --norandommap --randrepeat=0 --ioengine=sync --bs=4k
> --rwmixread=100 --iodepth=16 --numjobs=16 --runtime=60 --group_reporting
> --name=4krandreadtest
>
> I get:
>
> 4krandreadtest: (groupid=0, jobs=16): err= 0: pid=4101
>   read : io=2048.0MB, bw=2158.7MB/s, iops=552463 , runt=   949msec
>     clat (usec): min=4 , max=23125 , avg=26.15, stdev=346.02
>      lat (usec): min=4 , max=23125 , avg=26.28, stdev=346.07
>     clat percentiles (usec):
>      |  1.00th=[    5],  5.00th=[    5], 10.00th=[    6], 20.00th=[    8],
>      | 30.00th=[    9], 40.00th=[    9], 50.00th=[    9], 60.00th=[   10],
>      | 70.00th=[   11], 80.00th=[   12], 90.00th=[   16], 95.00th=[   19],
>      | 99.00th=[   35], 99.50th=[  133], 99.90th=[ 5664], 99.95th=[ 8160],
>      | 99.99th=[14528]
>     bw (KB/s)  : min=114424, max=159840, per=6.09%, avg=134474.12,
> stdev=13435.6
> 7
>     lat (usec) : 10=51.38%, 20=44.19%, 50=3.71%, 100=0.15%, 250=0.19%
>     lat (usec) : 500=0.06%, 750=0.03%, 1000=0.02%
>     lat (msec) : 2=0.05%, 4=0.08%, 10=0.12%, 20=0.03%, 50=0.01%
>   cpu          : usr=5.76%, sys=37.95%, ctx=5049, majf=0, minf=409
>   IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%,
>>=64=0.0%
>
>  read : io=2048.0MB, bw=2158.7MB/s, iops=552463 , runt=   949msec
>     clat (usec): min=4 , max=23125 , avg=26.15, stdev=346.02
>      lat (usec): min=4 , max=23125 , avg=26.28, stdev=346.07
>     clat percentiles (usec):
>      |  1.00th=[    5],  5.00th=[    5], 10.00th=[    6], 20.00th=[    8],
>      | 30.00th=[    9], 40.00th=[    9], 50.00th=[    9], 60.00th=[   10],
>      | 70.00th=[   11], 80.00th=[   12], 90.00th=[   16], 95.00th=[   19],
>      | 99.00th=[   35], 99.50th=[  133], 99.90th=[ 5664], 99.95th=[ 8160],
>      | 99.99th=[14528]
>     bw (KB/s)  : min=114424, max=159840, per=6.09%, avg=134474.12,
> stdev=13435.6
> 7
>     lat (usec) : 10=51.38%, 20=44.19%, 50=3.71%, 100=0.15%, 250=0.19%
>     lat (usec) : 500=0.06%, 750=0.03%, 1000=0.02%
>     lat (msec) : 2=0.05%, 4=0.08%, 10=0.12%, 20=0.03%, 50=0.01%
>   cpu          : usr=5.76%, sys=37.95%, ctx=5049, majf=0, minf=409
>   IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%,
>>=64=0.0%
>      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%,
>>=64=0.0%
>      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%,
>>=64=0.0%
>      issued    : total=r=524288/w=0/d=0, short=r=0/w=0/d=0
>
> Run status group 0 (all jobs):
>    READ: io=2048.0MB, aggrb=2158.7MB/s, minb=2158.7MB/s, maxb=2158.7MB/s,
> mint=9
> 49msec, maxt=949msec
>
> These values are extremly high and I suspect that these are the RAM speed
> being returned to me.
>
> Is there anyway to get a more realistic result?
>
> Thanks in advance,
> Kim Holmebakken
>
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
