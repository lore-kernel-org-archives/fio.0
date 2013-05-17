Return-Path: <fio-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:57758
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752176Ab3EQHsA (ORCPT
	<rfc822;fio@vger.kernel.org>); Fri, 17 May 2013 03:48:00 -0400
Date: Fri, 17 May 2013 09:47:51 +0200
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: latency measurements when adding thinktime
Message-ID: <20130517074751.GS697@kernel.dk>
References: <OF959B9513.E7C6D2A9-ON80257B6D.00837463-80257B6E.0000140D@uk.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OF959B9513.E7C6D2A9-ON80257B6D.00837463-80257B6E.0000140D@uk.ibm.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Edoardo Comar <ECOMAR@uk.ibm.com>
Cc: fio@vger.kernel.org

On Fri, May 17 2013, Edoardo Comar wrote:
> Hi
> I am running a very simple randrw workload
> 
> if I uncomment the thinktime line, the latencies reported become much 
> larger.
> It doesn't make senes to me that a lower disk load results in higher 
> latencies.
> 
> can anyone please tell me if I am wrongly interpreting the output ?
> thanks!!
> 
> [global]
> size=256m
> directory=/mnt/vda2/tmp
> invalidate=1
> runtime=90
> clat_percentiles=0
> #thinktime=10000
> 
> [bgupdater]
> rw=randrw
> ioengine=libaio
> direct=1
> iodepth=16
> 
> 
> without thinktime (high KB/s) - latency about 11ms (it's an ssd drive)
> 
> bgupdater: (g=0): rw=randrw, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, 
> iodepth=16
> fio-2.1
> Starting 1 process
> Jobs: 1 (f=1): [m] [100.0% done] [2788KB/2836KB/0KB /s] [697/709/0 iops] 
> [eta 00m:00s]
> bgupdater: (groupid=0, jobs=1): err= 0: pid=2827: Fri May 17 00:40:18 2013
>   read : io=131220KB, bw=2718.5KB/s, iops=679, runt= 48270msec
>     slat (usec): min=3, max=22626, avg=25.35, stdev=196.44
>     clat (usec): min=68, max=42871, avg=11013.43, stdev=5577.65
>      lat (usec): min=337, max=42898, avg=11039.70, stdev=5577.81
>     bw (KB  /s): min= 2051, max= 3320, per=99.85%, avg=2713.95, 
> stdev=273.34
>   write: io=130924KB, bw=2712.4KB/s, iops=678, runt= 48270msec
>     slat (usec): min=5, max=22547, avg=27.85, stdev=169.45
>     clat (usec): min=792, max=40276, avg=12491.74, stdev=6069.90
>      lat (usec): min=806, max=47342, avg=12520.54, stdev=6072.64
>     bw (KB  /s): min= 2096, max= 3209, per=99.96%, avg=2710.88, 
> stdev=210.73
>     lat (usec) : 100=0.01%, 250=0.01%, 500=0.38%, 750=1.75%, 1000=0.50%
>     lat (msec) : 2=1.03%, 4=1.02%, 10=46.23%, 20=39.03%, 50=10.06%
>   cpu          : usr=1.50%, sys=5.51%, ctx=51567, majf=0, minf=24
>   IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=100.0%, 32=0.0%, 
> >=64=0.0%
>      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
> >=64=0.0%
>      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.1%, 32=0.0%, 64=0.0%, 
> >=64=0.0%
>      issued    : total=r=32805/w=32731/d=0, short=r=0/w=0/d=0
> 
> Run status group 0 (all jobs):
>    READ: io=131220KB, aggrb=2718KB/s, minb=2718KB/s, maxb=2718KB/s, 
> mint=48270msec, maxt=48270msec
>   WRITE: io=130924KB, aggrb=2712KB/s, minb=2712KB/s, maxb=2712KB/s, 
> mint=48270msec, maxt=48270msec
> 
> Disk stats (read/write):
>   vda: ios=32721/32686, merge=0/30, ticks=359611/407708, in_queue=767361, 
> util=99.87%
> 
> 
> re-runing after having introduced thinktime=10000
> much lower bandwitdh, but 152ms latency !
> 
> bgupdater: (g=0): rw=randrw, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, 
> iodepth=16
> fio-2.1
> Starting 1 process
> Jobs: 1 (f=1): [m] [100.0% done] [200KB/192KB/0KB /s] [50/48/0 iops] [eta 
> 00m:00s]
> bgupdater: (groupid=0, jobs=1): err= 0: pid=2833: Fri May 17 00:43:21 2013
>   read : io=17768KB, bw=202135B/s, iops=49, runt= 90011msec
>     slat (usec): min=6, max=166, avg=29.62, stdev=15.64
>     clat (usec): min=632, max=157715, avg=152132.61, stdev=5965.84
>      lat (usec): min=797, max=157744, avg=152163.37, stdev=5965.66
>     bw (KB  /s): min=  102, max=  276, per=99.84%, avg=196.68, stdev=27.96
>   write: io=17720KB, bw=201589B/s, iops=49, runt= 90011msec
>     slat (usec): min=8, max=164, avg=34.02, stdev=16.60
>     clat (msec): min=20, max=157, avg=152.23, stdev= 4.09
>      lat (msec): min=20, max=157, avg=152.27, stdev= 4.09
>     bw (KB  /s): min=  118, max=  291, per=100.00%, avg=196.23, 
> stdev=27.95
>     lat (usec) : 750=0.01%
>     lat (msec) : 20=0.02%, 50=0.07%, 100=0.11%, 250=99.79%
>   cpu          : usr=0.12%, sys=0.36%, ctx=8891, majf=0, minf=24
>   IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=99.8%, 32=0.0%, 
> >=64=0.0%
>      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
> >=64=0.0%
>      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.1%, 32=0.0%, 64=0.0%, 
> >=64=0.0%
>      issued    : total=r=4442/w=4430/d=0, short=r=0/w=0/d=0
> 
> Run status group 0 (all jobs):
>    READ: io=17768KB, aggrb=197KB/s, minb=197KB/s, maxb=197KB/s, 
> mint=90011msec, maxt=90011msec
>   WRITE: io=17720KB, aggrb=196KB/s, minb=196KB/s, maxb=196KB/s, 
> mint=90011msec, maxt=90011msec
> 
> Disk stats (read/write):
>   vda: ios=4441/4488, merge=0/34, ticks=2965/8118, in_queue=11083, 
> util=11.64%

Could be scheduling artifacts, the thinktime will generally cause the
process to be scheduled out (or put to sleep, at least). Try and use
thinktime_spin instead. If you set that to the same value as thinktime,
then fio will busy loop instead of going to sleep. If that changes the
picture, then it would indicate that it's related to be scheduled in and
out.

-- 
Jens Axboe

