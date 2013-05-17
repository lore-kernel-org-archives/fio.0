Return-Path: <ecomar@uk.ibm.com>
In-Reply-To: <20130517074751.GS697@kernel.dk>
References: <OF959B9513.E7C6D2A9-ON80257B6D.00837463-80257B6E.0000140D@uk.ibm.com> <20130517074751.GS697@kernel.dk>
MIME-Version: 1.0
Subject: Re: latency measurements when adding thinktime
From: Edoardo Comar <ECOMAR@uk.ibm.com>
Message-ID: <OFDD7AB964.9096D732-ON80257B6E.00324017-80257B6E.0033AE26@uk.ibm.com>
Date: Fri, 17 May 2013 10:24:18 +0100
Content-Type: text/plain; charset="US-ASCII"
To: Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

Hi Jens,

thanks a lot, I tried your suggestion straight away: 
The cpu line in the output shows that the job has not been idle at all.
but even with thinktime_spin, the latency stays high at at 150ms.

Note also that if I increase thinktime & thinktime_spin by another 10000 
us
to a total of 20000, then the reported latency goes up another 150ms to a 
total of 300ms.
Could this be a bug?

regards,
Edoardo.


The system is a RHEL 64 VM running in KVM-QEMU on a Fedora18 Host.
# uname -a
Linux vm25 2.6.32-358.el6.x86_64 #1 SMP Tue Jan 29 11:47:41 EST 2013 
x86_64 x86_64 x86_64 GNU/Linux
----------------------------------------------------------------------------------------
# THINK=10000

# cat four-threads-randio-012.fio 
[global]
size=256m
directory=/mnt/vda2/tmp
invalidate=1
runtime=90
#bs=8k
clat_percentiles=0
thinktime=10000
thinktime_spin=10000
#rate=300k

[bgupdater]
rw=randrw
ioengine=libaio
direct=1
iodepth=16


 #./fio four-threads-randio-012.fio 
bgupdater: (g=0): rw=randrw, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, 
iodepth=16
fio-2.1
Starting 1 process
Jobs: 1 (f=1): [m] [100.0% done] [192KB/208KB/0KB /s] [48/52/0 iops] [eta 
00m:00s]
bgupdater: (groupid=0, jobs=1): err= 0: pid=3102: Fri May 17 10:06:29 2013
  read : io=18012KB, bw=204929B/s, iops=50, runt= 90003msec
    slat (usec): min=6, max=111, avg=14.74, stdev= 6.01
    clat (usec): min=727, max=150438, avg=150061.39, stdev=5468.92
     lat (usec): min=823, max=150453, avg=150076.69, stdev=5468.58
    bw (KB  /s): min=  103, max=  272, per=99.64%, avg=199.28, stdev=28.41
  write: io=17972KB, bw=204474B/s, iops=49, runt= 90003msec
    slat (usec): min=9, max=85, avg=17.45, stdev= 6.01
    clat (msec): min=10, max=150, avg=150.08, stdev= 4.47
     lat (msec): min=10, max=150, avg=150.10, stdev= 4.47
    bw (KB  /s): min=  127, max=  295, per=99.94%, avg=198.88, stdev=28.25
    lat (usec) : 750=0.01%
    lat (msec) : 20=0.02%, 50=0.07%, 100=0.11%, 250=99.79%
  cpu          : usr=25.32%, sys=74.51%, ctx=9646, majf=0, minf=24
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=99.8%, 32=0.0%, 
>=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
>=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.1%, 32=0.0%, 64=0.0%, 
>=64=0.0%
     issued    : total=r=4503/w=4493/d=0, short=r=0/w=0/d=0

Run status group 0 (all jobs):
   READ: io=18012KB, aggrb=200KB/s, minb=200KB/s, maxb=200KB/s, 
mint=90003msec, maxt=90003msec
  WRITE: io=17972KB, aggrb=199KB/s, minb=199KB/s, maxb=199KB/s, 
mint=90003msec, maxt=90003msec

Disk stats (read/write):
  vda: ios=4501/4551, merge=0/35, ticks=2337/7267, in_queue=9601, 
util=10.40%


------------------------------------------------------------------------------------------------------------------------------------
# THINK=20000

# cat four-threads-randio-012.fio 
[global]
size=256m
directory=/mnt/vda2/tmp
invalidate=1
runtime=90
#bs=8k
clat_percentiles=0
thinktime=20000
thinktime_spin=20000
#rate=300k

[bgupdater]
rw=randrw
ioengine=libaio
direct=1
iodepth=16


./fio four-threads-randio-012.fio 
bgupdater: (g=0): rw=randrw, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, 
iodepth=16
fio-2.1
Starting 1 process
Jobs: 1 (f=1): [m] [100.0% done] [128KB/72KB/0KB /s] [32/18/0 iops] [eta 
00m:00s]
bgupdater: (groupid=0, jobs=1): err= 0: pid=3109: Fri May 17 10:19:17 2013
  read : io=9240.0KB, bw=105108B/s, iops=25, runt= 90019msec
    slat (usec): min=6, max=106, avg=14.51, stdev= 4.33
    clat (usec): min=592, max=300425, avg=299037.78, stdev=17053.15
     lat (usec): min=645, max=300443, avg=299052.89, stdev=17053.12
    bw (KB  /s): min=   56, max=  152, per=100.00%, avg=102.21, 
stdev=19.77
  write: io=8804.0KB, bw=100148B/s, iops=24, runt= 90019msec
    slat (usec): min=8, max=110, avg=17.58, stdev= 7.68
    clat (msec): min=20, max=300, avg=299.64, stdev=10.12
     lat (msec): min=20, max=300, avg=299.66, stdev=10.12
    bw (KB  /s): min=   48, max=  144, per=100.00%, avg=97.83, stdev=19.76
    lat (usec) : 750=0.02%
    lat (msec) : 50=0.09%, 100=0.09%, 250=0.35%, 500=99.45%
  cpu          : usr=25.09%, sys=74.74%, ctx=9647, majf=0, minf=24
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.2%, 16=99.7%, 32=0.0%, 
>=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
>=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.1%, 32=0.0%, 64=0.0%, 
>=64=0.0%
     issued    : total=r=2310/w=2201/d=0, short=r=0/w=0/d=0

Run status group 0 (all jobs):
   READ: io=9240KB, aggrb=102KB/s, minb=102KB/s, maxb=102KB/s, 
mint=90019msec, maxt=90019msec
  WRITE: io=8804KB, aggrb=97KB/s, minb=97KB/s, maxb=97KB/s, 
mint=90019msec, maxt=90019msec

Disk stats (read/write):
  vda: ios=2307/2257, merge=0/35, ticks=1228/3715, in_queue=4940, 
util=5.20%
--------------------------------------------------
regards,
Edoardo Comar
WebSphere Application Service Platform for Networks (ASPN)
ecomar@uk.ibm.com
+44 (0)1962 81 5576 
IBM UK Ltd, Hursley Park, SO21 2JN




From:   Jens Axboe <axboe@kernel.dk>
To:     Edoardo Comar/UK/IBM@IBMGB, 
Cc:     fio@vger.kernel.org
Date:   17/05/2013 08:47
Subject:        Re: latency measurements when adding thinktime



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
> bgupdater: (groupid=0, jobs=1): err= 0: pid=2827: Fri May 17 00:40:18 
2013
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
>   vda: ios=32721/32686, merge=0/30, ticks=359611/407708, 
in_queue=767361, 
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
> Jobs: 1 (f=1): [m] [100.0% done] [200KB/192KB/0KB /s] [50/48/0 iops] 
[eta 
> 00m:00s]
> bgupdater: (groupid=0, jobs=1): err= 0: pid=2833: Fri May 17 00:43:21 
2013
>   read : io=17768KB, bw=202135B/s, iops=49, runt= 90011msec
>     slat (usec): min=6, max=166, avg=29.62, stdev=15.64
>     clat (usec): min=632, max=157715, avg=152132.61, stdev=5965.84
>      lat (usec): min=797, max=157744, avg=152163.37, stdev=5965.66
>     bw (KB  /s): min=  102, max=  276, per=99.84%, avg=196.68, 
stdev=27.96
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



Unless stated otherwise above:
IBM United Kingdom Limited - Registered in England and Wales with number 
741598. 
Registered office: PO Box 41, North Harbour, Portsmouth, Hampshire PO6 3AU


