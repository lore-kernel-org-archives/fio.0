Return-Path: <ecomar@uk.ibm.com>
In-Reply-To: <20130517102244.GV697@kernel.dk>
References: <OF959B9513.E7C6D2A9-ON80257B6D.00837463-80257B6E.0000140D@uk.ibm.com> <20130517074751.GS697@kernel.dk> <OFDD7AB964.9096D732-ON80257B6E.00324017-80257B6E.0033AE26@uk.ibm.com> <20130517102244.GV697@kernel.dk>
MIME-Version: 1.0
Subject: Re: latency measurements when adding thinktime
From: Edoardo Comar <ECOMAR@uk.ibm.com>
Message-ID: <OF73C8695E.65A0A8F9-ON80257B6E.0039B48D-80257B6E.003A72DA@uk.ibm.com>
Date: Fri, 17 May 2013 11:38:14 +0100
Content-Type: text/plain; charset="US-ASCII"
To: Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

Thans Jens

FYI, I have run the load on the host too (previoulsy it was inside a VM), 
using the HDD and the SSD.
The effect on latency are essentially the same when thinktime and 
thinktime_spin are introduced
using both fio 2.0.13 and fio 2.1

THINK=0 HDD             read lat avg=21400.59 us
THINK=10000 HDD         read lat avg=149.99 ms
THINK=20000 HDD read lat avg=299.33 ms
THINK=0         SDD     read lat avg=1998.09 us
THINK=20000 SDD read lat avg=299.33 ms


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



==================================

THINK=0 HDD
[root@twix0208 fio]# ./fio four-threads-randio-012.fio 
bgupdater: (g=0): rw=randrw, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, 
iodepth=16
fio-2.0.13
Starting 1 process
bgupdater: Laying out IO file(s) (1 file(s) / 256MB)
Jobs: 1 (f=1): [m] [100.0% done] [1202K/1086K/0K /s] [300 /271 /0  iops] 
[eta 00m:00s]
bgupdater: (groupid=0, jobs=1): err= 0: pid=21936: Fri May 17 10:37:12 
2013
  read : io=107324KB, bw=1191.1KB/s, iops=297 , runt= 90042msec
    slat (usec): min=5 , max=62744 , avg=36.99, stdev=705.24
    clat (usec): min=39 , max=719439 , avg=21363.06, stdev=37310.18
     lat (usec): min=346 , max=719470 , avg=21400.59, stdev=37313.22
    bw (KB/s)  : min=  846, max= 1440, per=100.00%, avg=1192.70, 
stdev=101.75
  write: io=109204KB, bw=1212.9KB/s, iops=303 , runt= 90042msec
    slat (usec): min=6 , max=142595 , avg=48.04, stdev=1341.40
    clat (usec): min=861 , max=997553 , avg=31676.66, stdev=48625.06
     lat (usec): min=888 , max=997583 , avg=31725.21, stdev=48655.16
    bw (KB/s)  : min=  910, max= 1440, per=100.00%, avg=1214.42, 
stdev=96.44
    lat (usec) : 50=0.01%, 100=0.01%, 250=0.01%, 500=0.01%, 1000=0.04%
    lat (msec) : 2=2.36%, 4=12.19%, 10=29.96%, 20=21.36%, 50=20.79%
    lat (msec) : 100=8.03%, 250=4.61%, 500=0.60%, 750=0.04%, 1000=0.01%
  cpu          : usr=0.48%, sys=1.73%, ctx=55440, majf=0, minf=21
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=100.0%, 32=0.0%, 
>=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
>=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.1%, 32=0.0%, 64=0.0%, 
>=64=0.0%
     issued    : total=r=26831/w=27301/d=0, short=r=0/w=0/d=0

Run status group 0 (all jobs):
   READ: io=107324KB, aggrb=1191KB/s, minb=1191KB/s, maxb=1191KB/s, 
mint=90042msec, maxt=90042msec
  WRITE: io=109204KB, aggrb=1212KB/s, minb=1212KB/s, maxb=1212KB/s, 
mint=90042msec, maxt=90042msec

Disk stats (read/write):
    dm-1: ios=26829/27522, merge=0/0, ticks=569051/1195726, 
in_queue=1765761, util=99.99%, aggrios=26830/27415, aggrmerge=1/118, 
aggrticks=569586/1150587, aggrin_queue=1720087, aggrutil=99.97%
  sda: ios=26830/27415, merge=1/118, ticks=569586/1150587, 
in_queue=1720087, util=99.97%
============================================================================
THINK=10000 HDD
[root@twix0208 fio]# ./fio four-threads-randio-012.fio 
bgupdater: (g=0): rw=randrw, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, 
iodepth=16
fio-2.0.13
Starting 1 process
Jobs: 1 (f=1): [m] [100.0% done] [212K/188K/0K /s] [53 /47 /0  iops] [eta 
00m:00s]
bgupdater: (groupid=0, jobs=1): err= 0: pid=23668: Fri May 17 11:06:01 
2013
  read : io=18052KB, bw=205368 B/s, iops=50 , runt= 90010msec
    slat (usec): min=7 , max=5130 , avg=11.93, stdev=93.13
    clat (msec): min=10 , max=196 , avg=149.98, stdev= 4.92
     lat (msec): min=10 , max=196 , avg=149.99, stdev= 4.92
    bw (KB/s)  : min=  136, max=  280, per=100.00%, avg=200.20, 
stdev=30.23
  write: io=17956KB, bw=204276 B/s, iops=49 , runt= 90010msec
    slat (usec): min=9 , max=3915 , avg=12.88, stdev=72.14
    clat (msec): min=6 , max=170 , avg=149.98, stdev= 5.01
     lat (msec): min=6 , max=170 , avg=149.99, stdev= 5.01
    bw (KB/s)  : min=  120, max=  264, per=100.00%, avg=199.70, 
stdev=30.26
    lat (msec) : 10=0.01%, 20=0.02%, 50=0.07%, 100=0.12%, 250=99.78%
  cpu          : usr=96.46%, sys=0.10%, ctx=9362, majf=0, minf=22
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=99.8%, 32=0.0%, 
>=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
>=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.1%, 32=0.0%, 64=0.0%, 
>=64=0.0%
     issued    : total=r=4513/w=4489/d=0, short=r=0/w=0/d=0

Run status group 0 (all jobs):
   READ: io=18052KB, aggrb=200KB/s, minb=200KB/s, maxb=200KB/s, 
mint=90010msec, maxt=90010msec
  WRITE: io=17956KB, aggrb=199KB/s, minb=199KB/s, maxb=199KB/s, 
mint=90010msec, maxt=90010msec

Disk stats (read/write):
    dm-1: ios=4510/4594, merge=0/0, ticks=19925/22423, in_queue=42352, 
util=44.90%, aggrios=4513/4566, aggrmerge=0/36, aggrticks=19948/22446, 
aggrin_queue=42387, aggrutil=45.09%
  sda: ios=4513/4566, merge=0/36, ticks=19948/22446, in_queue=42387, 
util=45.09%
============================================================================
THINK=20000 HDD

bgupdater: (g=0): rw=randrw, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, 
iodepth=16
fio-2.0.13
Starting 1 process
Jobs: 1 (f=1): [m] [100.0% done] [128K/72K/0K /s] [32 /18 /0  iops] [eta 
00m:00s]
bgupdater: (groupid=0, jobs=1): err= 0: pid=24131: Fri May 17 11:14:57 
2013
  read : io=8984.0KB, bw=102203 B/s, iops=24 , runt= 90013msec
    slat (usec): min=8 , max=57 , avg=10.84, stdev= 3.80
    clat (msec): min=7 , max=327 , avg=299.32, stdev=13.73
     lat (msec): min=7 , max=327 , avg=299.33, stdev=13.73
    bw (KB/s)  : min=   48, max=  152, per=100.00%, avg=99.47, stdev=20.04
  write: io=9064.0KB, bw=103113 B/s, iops=25 , runt= 90013msec
    slat (usec): min=10 , max=57 , avg=12.33, stdev= 3.54
    clat (msec): min=27 , max=307 , avg=299.16, stdev=14.03
     lat (msec): min=27 , max=307 , avg=299.18, stdev=14.03
    bw (KB/s)  : min=   48, max=  152, per=100.00%, avg=100.55, 
stdev=20.02
    lat (msec) : 10=0.02%, 50=0.09%, 100=0.09%, 250=0.35%, 500=99.45%
  cpu          : usr=96.76%, sys=0.08%, ctx=13629, majf=0, minf=22
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.2%, 16=99.7%, 32=0.0%, 
>=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
>=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.1%, 32=0.0%, 64=0.0%, 
>=64=0.0%
     issued    : total=r=2246/w=2266/d=0, short=r=0/w=0/d=0

Run status group 0 (all jobs):
   READ: io=8984KB, aggrb=99KB/s, minb=99KB/s, maxb=99KB/s, 
mint=90013msec, maxt=90013msec
  WRITE: io=9064KB, aggrb=100KB/s, minb=100KB/s, maxb=100KB/s, 
mint=90013msec, maxt=90013msec

Disk stats (read/write):
    dm-1: ios=2245/2367, merge=0/0, ticks=9778/11313, in_queue=21091, 
util=22.53%, aggrios=2246/2344, aggrmerge=0/34, aggrticks=9786/11171, 
aggrin_queue=20954, aggrutil=22.62%
  sda: ios=2246/2344, merge=0/34, ticks=9786/11171, in_queue=20954, 
util=22.62%

============================================================================
THINK=20000 SDD

bgupdater: (g=0): rw=randrw, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, 
iodepth=16
fio-2.1
Starting 1 process
bgupdater: Laying out IO file(s) (1 file(s) / 256MB)
Jobs: 1 (f=1): [m] [100.0% done] [104KB/96KB/0KB /s] [26/24/0 iops] [eta 
00m:00s]
bgupdater: (groupid=0, jobs=1): err= 0: pid=24593: Fri May 17 11:20:57 
2013
  read : io=9240.0KB, bw=105123B/s, iops=25, runt= 90006msec
    slat (usec): min=7, max=57, avg= 9.86, stdev= 4.12
    clat (usec): min=268, max=300293, avg=299101.30, stdev=15596.56
     lat (usec): min=310, max=300302, avg=299111.39, stdev=15596.30
    bw (KB  /s): min=   56, max=  152, per=100.00%, avg=102.21, 
stdev=19.77
  write: io=8808.0KB, bw=100208B/s, iops=24, runt= 90006msec
    slat (usec): min=12, max=60, avg=14.21, stdev= 4.06
    clat (msec): min=20, max=300, avg=299.35, stdev=12.36
     lat (msec): min=20, max=300, avg=299.36, stdev=12.36
    bw (KB  /s): min=   48, max=  144, per=100.00%, avg=97.83, stdev=19.76
    lat (usec) : 500=0.02%
    lat (msec) : 50=0.09%, 100=0.09%, 250=0.35%, 500=99.45%
  cpu          : usr=96.37%, sys=0.10%, ctx=13480, majf=0, minf=24
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.2%, 16=99.7%, 32=0.0%, 
>=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
>=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.1%, 32=0.0%, 64=0.0%, 
>=64=0.0%
     issued    : total=r=2310/w=2202/d=0, short=r=0/w=0/d=0

Run status group 0 (all jobs):
   READ: io=9240KB, aggrb=102KB/s, minb=102KB/s, maxb=102KB/s, 
mint=90006msec, maxt=90006msec
  WRITE: io=8808KB, aggrb=97KB/s, minb=97KB/s, maxb=97KB/s, 
mint=90006msec, maxt=90006msec

Disk stats (read/write):
  sdb: ios=2306/2316, merge=0/30, ticks=410/2881, in_queue=3288, 
util=3.57%
============================================================================
THINK=0 SDD
[root@twix0208 fio]# ./fio21 four-threads-randio-012.fio 
bgupdater: (g=0): rw=randrw, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, 
iodepth=16
fio-2.1
Starting 1 process
Jobs: 1 (f=1): [m] [100.0% done] [12696KB/12580KB/0KB /s] [3174/3145/0 
iops] [eta 00m:00s]
bgupdater: (groupid=0, jobs=1): err= 0: pid=25111: Fri May 17 11:28:44 
2013
  read : io=131220KB, bw=13104KB/s, iops=3275, runt= 10014msec
    slat (usec): min=4, max=2132, avg=15.77, stdev=16.28
    clat (usec): min=151, max=9335, avg=1981.99, stdev=1250.96
     lat (usec): min=210, max=9357, avg=1998.09, stdev=1250.85
    bw (KB  /s): min=12184, max=13912, per=100.00%, avg=13112.15, 
stdev=436.14
  write: io=130924KB, bw=13074KB/s, iops=3268, runt= 10014msec
    slat (usec): min=6, max=3283, avg=21.15, stdev=22.14
    clat (usec): min=604, max=11033, avg=2864.34, stdev=1589.82
     lat (usec): min=621, max=11045, avg=2885.85, stdev=1589.91
    bw (KB  /s): min=12048, max=14256, per=100.00%, avg=13082.20, 
stdev=529.54
    lat (usec) : 250=0.03%, 500=1.59%, 750=3.51%, 1000=8.56%
    lat (msec) : 2=39.75%, 4=29.36%, 10=17.20%, 20=0.01%
  cpu          : usr=2.59%, sys=11.36%, ctx=25119, majf=0, minf=24
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=100.0%, 32=0.0%, 
>=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
>=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.1%, 32=0.0%, 64=0.0%, 
>=64=0.0%
     issued    : total=r=32805/w=32731/d=0, short=r=0/w=0/d=0

Run status group 0 (all jobs):
   READ: io=131220KB, aggrb=13103KB/s, minb=13103KB/s, maxb=13103KB/s, 
mint=10014msec, maxt=10014msec
  WRITE: io=130924KB, aggrb=13074KB/s, minb=13074KB/s, maxb=13074KB/s, 
mint=10014msec, maxt=10014msec

Disk stats (read/write):
  sdb: ios=32407/32402, merge=6/9, ticks=63329/91775, in_queue=155061, 
util=99.07%









From:   Jens Axboe <axboe@kernel.dk>
To:     Edoardo Comar/UK/IBM@IBMGB, 
Cc:     fio@vger.kernel.org
Date:   17/05/2013 11:22
Subject:        Re: latency measurements when adding thinktime
Sent by:        fio-owner@vger.kernel.org



On Fri, May 17 2013, Edoardo Comar wrote:
> Hi Jens,
> 
> thanks a lot, I tried your suggestion straight away: 
> The cpu line in the output shows that the job has not been idle at all.
> but even with thinktime_spin, the latency stays high at at 150ms.
> 
> Note also that if I increase thinktime & thinktime_spin by another 10000 

> us
> to a total of 20000, then the reported latency goes up another 150ms to 
a 
> total of 300ms.
> Could this be a bug?

It certainly could. Let me take a look here and see if I can reproduce
it.

-- 
Jens Axboe

--
To unsubscribe from this list: send the line "unsubscribe fio" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html



Unless stated otherwise above:
IBM United Kingdom Limited - Registered in England and Wales with number 
741598. 
Registered office: PO Box 41, North Harbour, Portsmouth, Hampshire PO6 3AU


