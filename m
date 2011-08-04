Return-Path: <Martin@lichtvoll.de>
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: Measuring IOPS
Date: Thu, 4 Aug 2011 12:23:55 +0200
References: <201107291737.40463.Martin@lichtvoll.de> <201108041134.33127.Martin@lichtvoll.de> <4E3A6E34.8080300@kernel.dk> (sfid-20110804_120722_728257_3A80A489)
In-Reply-To: <4E3A6E34.8080300@kernel.dk>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_7MnOOSHXXJ6PbbW"
Message-Id: <201108041223.55605.Martin@lichtvoll.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Jeff Moyer <jmoyer@redhat.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

--Boundary-00=_7MnOOSHXXJ6PbbW
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Am Donnerstag, 4. August 2011 schrieb Jens Axboe:
> On 2011-08-04 11:34, Martin Steigerwald wrote:
> > Am Donnerstag, 4. August 2011 schrieb Jens Axboe:
> >> On 2011-08-04 10:51, Martin Steigerwald wrote:
[...]
> >> The only example where a sync engine could drive a higher queue
> >> depth on the device side is buffered writes. For any other case
> >> (reads, direct writes), you need async submission to build up a
> >> higher queue depth.
> >=20
> > Great! I think that makes it pretty clear.
> >=20
> > Thus when I want to read subsequent blocks 1, 2, 3, 4, 5, 6, 7, 8, 9
> > and 10 from a file at once and then wait I need async I/O.  Block
> > might be of arbitrary size.
> >=20
> > What when I use 10 processes, each reading one of these blocks as
> > once? Couldn=B4t this fill up the queue at the device level? But then
> > different processes usually read different files...
>=20
> Yes, you could get the same IO on the device side with just more
> processes instead of using async IO. It would not be as efficient,
> though.

Just tried this. See attached file.

> > ... my question hints at how I/O depths might accumulate at the
> > device level, when several processes are issuing read and/or write
> > requests at once.
>=20
> Various things can impact that, ultimately the IO scheduler decides
> when to dispatch more requests to the driver.

Okay. I think not as efficient as asynchronous I/O on the application level=
=20
will do it for now ;).

> > conclusion:
> >=20
> > thus when I want to measure higher I/O depths at read I need libaio
> > and direct=3D1. but then I am measuring something that does not have
> > any practical effect on processes that use synchronous system call
> > I/O.
> >=20
> > so for regular applications ioengine=3Dsync + iodepth=3D64 gives more
> > realistic results - even when its then just I/O depth 1 for reads -
> > and for databases that use direct I/O ioengine=3Dlibaio makes sense
> > and will cause higher I/O depths on the device side if it supports
> > it.
>=20
> iodepth > 1 makes no sense for sync engines...

I mixed it up again, sorry.

Yes, so for regular application using sync which implies iodepth=3D1 might=
=20
still give me a higher iodepth at the device level for buffered writes. A=20
higher iodepth on the device side is only possible with having more than=20
one process with sync engine running at the same time, but this would not=20
be as efficient as asynchronous I/O.

> > anything without direct=3D1 (or the slower sync=3D1) is potentially
> > measuring RAM performance. direct=3D1 omits the page cache. sync=3D1
> > basically disables caching on the device / controller side as well.
>=20
> Not quite measuring RAM (or copy) performance, at some point fio will
> be blocked by the OS and prevented from dirtying more memory. At that
> point it'll either just wait, or participate in flushing out dirty
> data. For any buffered write workload, it'll quickly de-generate into
> that.

Which depends on the size of the job, cause I for bet 1 GB/s with 250000=20
IOPS I need some PCI express based SSD solution - a SATA-300 SSD like the=20
Intel SSD 320 in use here can=B4t reach this (see attached file). It seems=
=20
with 8 GB of RAM I need more than one GB to write in order to get=20
meaningful results (related to raw SSD performance). With Ext4 delayed=20
allocation a subsequent rm might even cause the file to not be written at=20
all.

=46or the application side of thing it can make perfect sense to measure=20
buffered writes. But one should go with a large enough data set in order to=
=20
get meaningful results. At least when the application uses a large dataset=
=20
too ;).

Thanks,
=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

--Boundary-00=_7MnOOSHXXJ6PbbW
Content-Type: text/plain;
  charset="UTF-8";
  name="parallel-lesen.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="parallel-lesen.txt"

martin@merkaba:~/Zeit> fio --name massiveparallelreads --ioengine=sync --direct=1 --rw=randread --size=1g --filename=testfile --group_reporting --numjobs=1 --runtime=60
massiveparallelreads: (g=0): rw=randread, bs=4K-4K/4K-4K, ioengine=sync, iodepth=1
fio 1.57
Starting 1 process
Jobs: 1 (f=1): [r] [100.0% done] [17316K/0K /s] [4227 /0  iops] [eta 00m:00s]
massiveparallelreads: (groupid=0, jobs=1): err= 0: pid=19234
  read : io=987.22MB, bw=16848KB/s, iops=4212 , runt= 60001msec
    clat (usec): min=170 , max=8073 , avg=225.79, stdev=66.71
     lat (usec): min=170 , max=8073 , avg=226.21, stdev=66.73
    bw (KB/s) : min=15992, max=17248, per=100.02%, avg=16852.15, stdev=184.38
  cpu          : usr=5.29%, sys=11.79%, ctx=254656, majf=0, minf=24
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued r/w/d: total=252725/0/0, short=0/0/0
     lat (usec): 250=88.02%, 500=11.85%, 750=0.04%, 1000=0.02%
     lat (msec): 2=0.04%, 4=0.03%, 10=0.01%

Run status group 0 (all jobs):
   READ: io=987.22MB, aggrb=16848KB/s, minb=17252KB/s, maxb=17252KB/s, mint=60001msec, maxt=60001msec

Disk stats (read/write):
  dm-2: ios=252641/34, merge=0/0, ticks=47496/0, in_queue=47492, util=79.16%, aggrios=252725/26, aggrmerge=0/15, aggrticks=47152/8, aggrin_queue=46888, aggrutil=78.09%
    sda: ios=252725/26, merge=0/15, ticks=47152/8, in_queue=46888, util=78.09%
martin@merkaba:~/Zeit> fio --name massiveparallelreads --ioengine=sync --direct=1 --rw=randread --size=1g --filename=testfile --group_reporting --numjobs=8 --runtime=60 
massiveparallelreads: (g=0): rw=randread, bs=4K-4K/4K-4K, ioengine=sync, iodepth=1
...
massiveparallelreads: (g=0): rw=randread, bs=4K-4K/4K-4K, ioengine=sync, iodepth=1
fio 1.57
Starting 8 processes
Jobs: 8 (f=8): [rrrrrrrr] [100.0% done] [101.9M/0K /s] [25.5K/0  iops] [eta 00m:00s]
massiveparallelreads: (groupid=0, jobs=8): err= 0: pid=19237
  read : io=5855.1MB, bw=99925KB/s, iops=24981 , runt= 60001msec
    clat (usec): min=171 , max=83857 , avg=313.75, stdev=73.37
     lat (usec): min=171 , max=83858 , avg=314.15, stdev=73.36
    bw (KB/s) : min=10008, max=13504, per=12.49%, avg=12485.41, stdev=94.90
  cpu          : usr=1.81%, sys=10.25%, ctx=1514639, majf=0, minf=214
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued r/w/d: total=1498905/0/0, short=0/0/0
     lat (usec): 250=16.99%, 500=81.51%, 750=1.28%, 1000=0.09%
     lat (msec): 2=0.09%, 4=0.02%, 10=0.01%, 20=0.01%, 50=0.01%
     lat (msec): 100=0.01%

Run status group 0 (all jobs):
   READ: io=5855.1MB, aggrb=99925KB/s, minb=102323KB/s, maxb=102323KB/s, mint=60001msec, maxt=60001msec

Disk stats (read/write):
  dm-2: ios=1497855/17, merge=0/0, ticks=405216/448, in_queue=405812, util=99.81%, aggrios=1498905/30, aggrmerge=0/11, aggrticks=405948/468, aggrin_queue=405140, aggrutil=99.77%
    sda: ios=1498905/30, merge=0/11, ticks=405948/468, in_queue=405140, util=99.77%
martin@merkaba:~/Zeit> fio --name massiveparallelreads --ioengine=sync --direct=1 --rw=randread --size=1g --filename=testfile --group_reporting --numjobs=32 --runtime=60 
massiveparallelreads: (g=0): rw=randread, bs=4K-4K/4K-4K, ioengine=sync, iodepth=1
...
massiveparallelreads: (g=0): rw=randread, bs=4K-4K/4K-4K, ioengine=sync, iodepth=1
fio 1.57
Starting 32 processes
Jobs: 32 (f=32): [rrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr] [100.0% done] [157.1M/0K /s] [39.5K/0  iops] [eta 00m:00s]
massiveparallelreads: (groupid=0, jobs=32): err= 0: pid=19583
  read : io=9199.6MB, bw=157003KB/s, iops=39250 , runt= 60001msec
    clat (usec): min=173 , max=1016.5K, avg=818.37, stdev=326.10
     lat (usec): min=174 , max=1016.5K, avg=818.60, stdev=326.10
    bw (KB/s) : min=    3, max= 9464, per=3.11%, avg=4885.51, stdev=82.96
  cpu          : usr=0.51%, sys=2.77%, ctx=2399581, majf=0, minf=878
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued r/w/d: total=2355087/0/0, short=0/0/0
     lat (usec): 250=0.03%, 500=0.97%, 750=33.84%, 1000=59.32%
     lat (msec): 2=5.79%, 4=0.03%, 10=0.01%, 20=0.01%, 50=0.01%
     lat (msec): 250=0.01%, 500=0.01%, 750=0.01%, 1000=0.01%, 2000=0.01%

Run status group 0 (all jobs):
   READ: io=9199.6MB, aggrb=157003KB/s, minb=160771KB/s, maxb=160771KB/s, mint=60001msec, maxt=60001msec

Disk stats (read/write):
  dm-2: ios=2352589/34, merge=0/0, ticks=1820480/101988, in_queue=1924564, util=99.91%, aggrios=2355082/52, aggrmerge=0/24, aggrticks=1822620/98852, aggrin_queue=1920740, aggrutil=99.87%
    sda: ios=2355082/52, merge=0/24, ticks=1822620/98852, in_queue=1920740, util=99.87%
martin@merkaba:~/Zeit> 

--Boundary-00=_7MnOOSHXXJ6PbbW
Content-Type: text/plain;
  charset="UTF-8";
  name="cachedwrite.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="cachedwrite.txt"

martin@merkaba:~/Zeit> fio -name cachedwrite --ioengine=sync --buffered=1 --rw write --size=100   
cachedwrite: (g=0): rw=write, bs=4K-4K/4K-4K, ioengine=sync, iodepth=1
fio 1.57
Starting 1 process
cachedwrite: Laying out IO file(s) (1 file(s) / 0MB)


Run status group 0 (all jobs):

Disk stats (read/write):
  dm-2: ios=0/0, merge=0/0, ticks=0/0, in_queue=0, util=-nan%, aggrios=0/0, aggrmerge=0/0, aggrticks=0/0, aggrin_queue=0, aggrutil=0.00%
    sda: ios=0/0, merge=0/0, ticks=0/0, in_queue=0, util=0.00%
martin@merkaba:~/Zeit> fio -name cachedwrite --ioengine=sync --buffered=1 --rw write --size=100m
cachedwrite: (g=0): rw=write, bs=4K-4K/4K-4K, ioengine=sync, iodepth=1
fio 1.57
Starting 1 process
cachedwrite: Laying out IO file(s) (1 file(s) / 100MB)

cachedwrite: (groupid=0, jobs=1): err= 0: pid=20543
  write: io=102400KB, bw=1000.0MB/s, iops=256000 , runt=   100msec
    clat (usec): min=2 , max=75 , avg= 3.33, stdev= 1.44
     lat (usec): min=2 , max=76 , avg= 3.42, stdev= 1.53
  cpu          : usr=20.20%, sys=72.73%, ctx=9, majf=0, minf=24
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued r/w/d: total=0/25600/0, short=0/0/0
     lat (usec): 4=82.50%, 10=15.28%, 20=2.21%, 50=0.01%, 100=0.01%


Run status group 0 (all jobs):
  WRITE: io=102400KB, aggrb=1000.0MB/s, minb=1024.0MB/s, maxb=1024.0MB/s, mint=100msec, maxt=100msec

Disk stats (read/write):
  dm-2: ios=0/0, merge=0/0, ticks=0/0, in_queue=0, util=-nan%, aggrios=0/0, aggrmerge=0/0, aggrticks=0/0, aggrin_queue=0, aggrutil=0.00%
    sda: ios=0/0, merge=0/0, ticks=0/0, in_queue=0, util=0.00%

martin@merkaba:~/Zeit> fio -name cachedwrite --ioengine=sync --buffered=1 --rw write --size=100m
cachedwrite: (g=0): rw=write, bs=4K-4K/4K-4K, ioengine=sync, iodepth=1
fio 1.57
Starting 1 process

cachedwrite: (groupid=0, jobs=1): err= 0: pid=20552
  write: io=102400KB, bw=966038KB/s, iops=241509 , runt=   106msec
    clat (usec): min=2 , max=36 , avg= 2.88, stdev= 0.74
     lat (usec): min=2 , max=36 , avg= 2.94, stdev= 0.72
  cpu          : usr=15.24%, sys=80.00%, ctx=11, majf=0, minf=24
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued r/w/d: total=0/25600/0, short=0/0/0
     lat (usec): 4=92.35%, 10=7.57%, 20=0.05%, 50=0.02%


Run status group 0 (all jobs):
  WRITE: io=102400KB, aggrb=966037KB/s, minb=989222KB/s, maxb=989222KB/s, mint=106msec, maxt=106msec

Disk stats (read/write):
  dm-2: ios=0/0, merge=0/0, ticks=0/0, in_queue=0, util=-nan%, aggrios=0/0, aggrmerge=0/0, aggrticks=0/0, aggrin_queue=0, aggrutil=0.00%
    sda: ios=0/0, merge=0/0, ticks=0/0, in_queue=0, util=0.00%
martin@merkaba:~/Zeit> fio -name cachedwrite --ioengine=sync --buffered=1 --rw write --size=100m
cachedwrite: (g=0): rw=write, bs=4K-4K/4K-4K, ioengine=sync, iodepth=1
fio 1.57
Starting 1 process

cachedwrite: (groupid=0, jobs=1): err= 0: pid=20555
  write: io=102400KB, bw=223581KB/s, iops=55895 , runt=   458msec
    clat (usec): min=2 , max=74675 , avg=10.57, stdev=474.70
     lat (usec): min=2 , max=74675 , avg=10.67, stdev=474.70
  cpu          : usr=3.50%, sys=30.63%, ctx=77, majf=0, minf=24
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued r/w/d: total=0/25600/0, short=0/0/0
     lat (usec): 4=55.96%, 10=43.44%, 20=0.18%, 50=0.05%, 100=0.12%
     lat (usec): 250=0.02%
     lat (msec): 2=0.21%, 4=0.01%, 10=0.01%, 100=0.01%

Run status group 0 (all jobs):
  WRITE: io=102400KB, aggrb=223580KB/s, minb=228946KB/s, maxb=228946KB/s, mint=458msec, maxt=458msec

Disk stats (read/write):
  dm-2: ios=0/200, merge=0/0, ticks=0/31632, in_queue=39816, util=78.23%, aggrios=0/200, aggrmerge=0/0, aggrticks=0/40580, aggrin_queue=40580, aggrutil=78.05%
    sda: ios=0/200, merge=0/0, ticks=0/40580, in_queue=40580, util=78.05%
martin@merkaba:~/Zeit> fio -name cachedwrite --ioengine=sync --buffered=1 --rw write --size=1000m
cachedwrite: (g=0): rw=write, bs=4K-4K/4K-4K, ioengine=sync, iodepth=1
fio 1.57
Starting 1 process
cachedwrite: Laying out IO file(s) (1 file(s) / 1000MB)
Jobs: 1 (f=1)
cachedwrite: (groupid=0, jobs=1): err= 0: pid=20558
  write: io=1000.0MB, bw=581488KB/s, iops=145371 , runt=  1761msec
    clat (usec): min=2 , max=28078 , avg= 6.29, stdev=236.66
     lat (usec): min=2 , max=28078 , avg= 6.37, stdev=236.66
    bw (KB/s) : min=214976, max=1004912, per=110.42%, avg=642049.67, stdev=398863.44
  cpu          : usr=12.05%, sys=50.23%, ctx=206, majf=0, minf=24
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued r/w/d: total=0/256000/0, short=0/0/0
     lat (usec): 4=62.17%, 10=36.27%, 20=1.44%, 50=0.10%, 100=0.01%
     lat (usec): 250=0.01%
     lat (msec): 2=0.01%, 4=0.01%, 10=0.01%, 20=0.01%, 50=0.01%

Run status group 0 (all jobs):
  WRITE: io=1000.0MB, aggrb=581487KB/s, minb=595443KB/s, maxb=595443KB/s, mint=1761msec, maxt=1761msec

Disk stats (read/write):
  dm-2: ios=0/714, merge=0/0, ticks=0/152156, in_queue=173448, util=71.91%, aggrios=1/631, aggrmerge=0/1, aggrticks=76/174312, aggrin_queue=196172, aggrutil=73.97%
    sda: ios=1/631, merge=0/1, ticks=76/174312, in_queue=196172, util=73.97%
martin@merkaba:~/Zeit> fio -name cachedwrite --ioengine=sync --buffered=1 --rw write --size=1000m
cachedwrite: (g=0): rw=write, bs=4K-4K/4K-4K, ioengine=sync, iodepth=1
fio 1.57
Starting 1 process
Jobs: 1 (f=1): [W] [-.-% done] [0K/659.1M /s] [0 /165K iops] [eta 00m:00s]
cachedwrite: (groupid=0, jobs=1): err= 0: pid=20561
  write: io=1000.0MB, bw=316440KB/s, iops=79110 , runt=  3236msec
    clat (usec): min=1 , max=120823 , avg= 6.54, stdev=342.44
     lat (usec): min=1 , max=120823 , avg= 6.61, stdev=342.44
    bw (KB/s) : min=    2, max=1111080, per=154.15%, avg=487795.00, stdev=488926.65
  cpu          : usr=6.18%, sys=30.79%, ctx=236, majf=0, minf=24
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued r/w/d: total=0/256000/0, short=0/0/0
     lat (usec): 2=0.17%, 4=77.44%, 10=21.17%, 20=1.00%, 50=0.09%
     lat (usec): 100=0.10%, 250=0.01%, 500=0.01%, 750=0.01%
     lat (msec): 4=0.01%, 10=0.01%, 20=0.01%, 50=0.01%, 250=0.01%

Run status group 0 (all jobs):
  WRITE: io=1000.0MB, aggrb=316440KB/s, minb=324034KB/s, maxb=324034KB/s, mint=3236msec, maxt=3236msec

Disk stats (read/write):
  dm-2: ios=0/1463, merge=0/0, ticks=0/378048, in_queue=411168, util=93.56%, aggrios=0/1348, aggrmerge=0/0, aggrticks=0/392324, aggrin_queue=423772, aggrutil=93.79%
    sda: ios=0/1348, merge=0/0, ticks=0/392324, in_queue=423772, util=93.79%
martin@merkaba:~/Zeit> 

--Boundary-00=_7MnOOSHXXJ6PbbW--


