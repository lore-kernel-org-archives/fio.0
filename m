Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:34482 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750705AbdAWSd1 (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 23 Jan 2017 13:33:27 -0500
Received: by mail-wm0-f67.google.com with SMTP id c85so28271347wmi.1
        for <fio@vger.kernel.org>; Mon, 23 Jan 2017 10:33:27 -0800 (PST)
Subject: Re: 4x lower IOPS: Linux MD vs indiv. devices - why?
References: <90865544-f790-513c-97df-7e6a6af20ca8@gmail.com>
 <CANvN+en2ihATNgrbgzwNXAK87wNh+6jXHinmg2-VmHon31AJzA@mail.gmail.com>
 <061acabe-dbd0-ae07-cd69-772eccd15b21@gmail.com>
 <CANvN+em0cjWRnQWccdORKFEJk0OSeQOrZq+XE6kzPmqMPB--4g@mail.gmail.com>
From: Tobias Oberstein <tobias.oberstein@gmail.com>
Message-ID: <49ef9d71-8e52-26e4-76f7-ea03fb331a38@gmail.com>
Date: Mon, 23 Jan 2017 19:33:24 +0100
MIME-Version: 1.0
In-Reply-To: <CANvN+em0cjWRnQWccdORKFEJk0OSeQOrZq+XE6kzPmqMPB--4g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Cc: fio@vger.kernel.org

> You're just running a huge number of threads against the same md device and
> bottleneck on some internal lock. If you step back and set up, say, 256

Ah, alright. Shit.

> threads with ioengine=libaio, qd=128 (to match the in-flight I/O number),
> you'd likely see the locking impact reduced substantially.

The problem with using libaio and QD>1 is: that doesn't represent the 
workload I am optimizing for.

The workload is PostgreSQL, and that is doing all it's IO as regular 
read/writes, and hence the use of ioengine=sync with large thread counts.

Note: we have an internal tool that is able to parallelize PostgreSQL 
via database sessions.

--

I tried anyway. Here is what I get with engine=libaio (results down below):

A)
QD=128 and jobs=8 (same effective IO concurrency as previously = 1024)

iops=200184

The IOPS stay constant during the run (120s).

B)
QD=128 and jobs=16 (effective concurrency = 2048)

iops=1068.7K

But, but:

The IOPS slowly go up to over 5 mio, then collapses to like 20k, and 
then go up again. Very strange.

C)
QD=128 and jobs=32 (effective concurrency = 4096)

FIO claims: iops=2135.9K

Which is still 3.5x lower than what I get with the sync engine and 2800 
threads!

Plus: that strange behavior over run time .. IOPS go up to 10M:

http://picpaste.com/pics/Bildschirmfoto_vom_2017-01-23_19-29-13-ZEyCVcKZ.1485196199.png

and the collapse to 0 IOPS

http://picpaste.com/pics/Bildschirmfoto_vom_2017-01-23_19-30-20-GEEEQR6f.1485196243.png

at which the NVMes don't show any load (I am watching them in another 
window).

===

libaio is nowhere near what I get with engine=sync and high job counts. 
Mmh. Plus the strange behavior.

And as said, that doesn't represent my workload anyways.

I want to stay away from AIO ..

Cheers,
/Tobias


A)

oberstet@svr-psql19:~/scm/parcit/RA/adr/system/docs$ sudo fio 
postgresql_storage_workload.fio
randread: (g=0): rw=randread, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, 
iodepth=128
...
fio-2.1.11
Starting 8 threads
Jobs: 1 (f=1): [_(2),r(1),_(5)] [38.3% done] [0KB/0KB/0KB /s] [0/0/0 
iops] [eta 03m:23s]
randread: (groupid=0, jobs=8): err= 0: pid=1994: Mon Jan 23 19:23:23 2017
   read : io=93837MB, bw=800739KB/s, iops=200184, runt=120001msec
     slat (usec): min=0, max=4291, avg=39.28, stdev=76.95
     clat (usec): min=2, max=22205, avg=5075.21, stdev=3646.18
      lat (usec): min=5, max=22333, avg=5114.55, stdev=3674.10
     clat percentiles (usec):
      |  1.00th=[  916],  5.00th=[ 1224], 10.00th=[ 1448], 20.00th=[ 1864],
      | 30.00th=[ 2320], 40.00th=[ 2960], 50.00th=[ 3920], 60.00th=[ 5024],
      | 70.00th=[ 6368], 80.00th=[ 8384], 90.00th=[10944], 95.00th=[12608],
      | 99.00th=[14272], 99.50th=[15168], 99.90th=[16768], 99.95th=[17536],
      | 99.99th=[18816]
     bw (KB  /s): min=33088, max=400688, per=12.35%, avg=98898.47, 
stdev=76253.23
     lat (usec) : 4=0.01%, 10=0.01%, 20=0.01%, 50=0.01%, 100=0.01%
     lat (usec) : 250=0.01%, 500=0.01%, 750=0.22%, 1000=1.48%
     lat (msec) : 2=21.67%, 4=27.51%, 10=35.37%, 20=13.74%, 50=0.01%
   cpu          : usr=1.53%, sys=13.53%, ctx=7504182, majf=0, minf=1032
   IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=0.1%, 
 >=64=100.0%
      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
 >=64=0.0%
      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
 >=64=0.1%
      issued    : total=r=24022368/w=0/d=0, short=r=0/w=0/d=0
      latency   : target=0, window=0, percentile=100.00%, depth=128

Run status group 0 (all jobs):
    READ: io=93837MB, aggrb=800738KB/s, minb=800738KB/s, 
maxb=800738KB/s, mint=120001msec, maxt=120001msec

Disk stats (read/write):
     md1: ios=7485313/0, merge=0/0, ticks=0/0, in_queue=0, util=0.00%, 
aggrios=468407/0, aggrmerge=0/0, aggrticks=51834/0, aggrin_queue=51770, 
aggrutil=35.00%
   nvme15n1: ios=468133/0, merge=0/0, ticks=52628/0, in_queue=52532, 
util=34.39%
   nvme6n1: ios=468355/0, merge=0/0, ticks=48944/0, in_queue=48840, 
util=32.34%
   nvme9n1: ios=468561/0, merge=0/0, ticks=53924/0, in_queue=53956, 
util=35.00%
   nvme11n1: ios=468354/0, merge=0/0, ticks=53424/0, in_queue=53396, 
util=34.70%
   nvme2n1: ios=468418/0, merge=0/0, ticks=51536/0, in_queue=51496, 
util=33.63%
   nvme14n1: ios=468669/0, merge=0/0, ticks=51696/0, in_queue=51576, 
util=33.84%
   nvme5n1: ios=468526/0, merge=0/0, ticks=50004/0, in_queue=49928, 
util=33.00%
   nvme8n1: ios=468233/0, merge=0/0, ticks=52232/0, in_queue=52140, 
util=33.82%
   nvme10n1: ios=468501/0, merge=0/0, ticks=52532/0, in_queue=52416, 
util=34.29%
   nvme1n1: ios=468434/0, merge=0/0, ticks=53492/0, in_queue=53404, 
util=34.58%
   nvme13n1: ios=468544/0, merge=0/0, ticks=51876/0, in_queue=51860, 
util=33.85%
   nvme4n1: ios=468513/0, merge=0/0, ticks=51172/0, in_queue=51176, 
util=33.30%
   nvme7n1: ios=468245/0, merge=0/0, ticks=50564/0, in_queue=50484, 
util=33.14%
   nvme0n1: ios=468318/0, merge=0/0, ticks=49812/0, in_queue=49760, 
util=32.67%
   nvme12n1: ios=468279/0, merge=0/0, ticks=52416/0, in_queue=52344, 
util=34.17%
   nvme3n1: ios=468442/0, merge=0/0, ticks=53092/0, in_queue=53016, 
util=34.37%
oberstet@svr-psql19:~/scm/parcit/RA/adr/system/docs$


B)

oberstet@svr-psql19:~/scm/parcit/RA/adr/system/docs$ sudo fio 
postgresql_storage_workload.fio
randread: (g=0): rw=randread, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, 
iodepth=128
...
fio-2.1.11
Starting 16 threads
Jobs: 1 (f=1): [_(15),r(1)] [100.0% done] [0KB/0KB/0KB /s] [0/0/0 iops] 
[eta 00m:00s]
randread: (groupid=0, jobs=16): err= 0: pid=2141: Mon Jan 23 19:27:38 2017
   read : io=500942MB, bw=4174.5MB/s, iops=1068.7K, runt=120001msec
     slat (usec): min=0, max=3647, avg=11.07, stdev=37.60
     clat (usec): min=2, max=19872, avg=1475.65, stdev=2510.83
      lat (usec): min=4, max=19964, avg=1486.76, stdev=2530.31
     clat percentiles (usec):
      |  1.00th=[  334],  5.00th=[  346], 10.00th=[  358], 20.00th=[  362],
      | 30.00th=[  370], 40.00th=[  378], 50.00th=[  398], 60.00th=[  494],
      | 70.00th=[  780], 80.00th=[ 1480], 90.00th=[ 4256], 95.00th=[ 8032],
      | 99.00th=[12096], 99.50th=[12736], 99.90th=[14272], 99.95th=[14912],
      | 99.99th=[16512]
     bw (KB  /s): min=    0, max=1512848, per=8.04%, avg=343481.50, 
stdev=460791.59
     lat (usec) : 4=0.01%, 10=0.01%, 20=0.01%, 50=0.01%, 100=0.01%
     lat (usec) : 250=0.01%, 500=60.27%, 750=8.95%, 1000=4.94%
     lat (msec) : 2=9.33%, 4=5.98%, 10=7.89%, 20=2.63%
   cpu          : usr=3.19%, sys=44.95%, ctx=9452424, majf=0, minf=2064
   IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=0.1%, 
 >=64=100.0%
      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
 >=64=0.0%
      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
 >=64=0.1%
      issued    : total=r=128241193/w=0/d=0, short=r=0/w=0/d=0
      latency   : target=0, window=0, percentile=100.00%, depth=128

Run status group 0 (all jobs):
    READ: io=500942MB, aggrb=4174.5MB/s, minb=4174.5MB/s, 
maxb=4174.5MB/s, mint=120001msec, maxt=120001msec

Disk stats (read/write):
     md1: ios=9392258/0, merge=0/0, ticks=0/0, in_queue=0, util=0.00%, 
aggrios=588533/0, aggrmerge=0/0, aggrticks=63464/0, aggrin_queue=63476, 
aggrutil=36.40%
   nvme15n1: ios=588661/0, merge=0/0, ticks=66932/0, in_queue=66824, 
util=36.40%
   nvme6n1: ios=589278/0, merge=0/0, ticks=60768/0, in_queue=60600, 
util=34.84%
   nvme9n1: ios=588744/0, merge=0/0, ticks=64344/0, in_queue=64480, 
util=35.85%
   nvme11n1: ios=588005/0, merge=0/0, ticks=65636/0, in_queue=65828, 
util=36.02%
   nvme2n1: ios=588097/0, merge=0/0, ticks=62296/0, in_queue=62440, 
util=35.00%
   nvme14n1: ios=588451/0, merge=0/0, ticks=64480/0, in_queue=64408, 
util=35.87%
   nvme5n1: ios=588654/0, merge=0/0, ticks=60736/0, in_queue=60704, 
util=34.66%
   nvme8n1: ios=588843/0, merge=0/0, ticks=63980/0, in_queue=63928, 
util=35.40%
   nvme10n1: ios=588315/0, merge=0/0, ticks=62436/0, in_queue=62432, 
util=35.15%
   nvme1n1: ios=588327/0, merge=0/0, ticks=64432/0, in_queue=64564, 
util=36.10%
   nvme13n1: ios=588342/0, merge=0/0, ticks=65856/0, in_queue=65892, 
util=36.06%
   nvme4n1: ios=588343/0, merge=0/0, ticks=64528/0, in_queue=64752, 
util=35.73%
   nvme7n1: ios=589243/0, merge=0/0, ticks=63740/0, in_queue=63696, 
util=35.34%
   nvme0n1: ios=588499/0, merge=0/0, ticks=61308/0, in_queue=61268, 
util=34.83%
   nvme12n1: ios=588221/0, merge=0/0, ticks=62076/0, in_queue=61976, 
util=35.19%
   nvme3n1: ios=588512/0, merge=0/0, ticks=61880/0, in_queue=61824, 
util=35.09%
oberstet@svr-psql19:~/scm/parcit/RA/adr/system/docs$


C)

oberstet@svr-psql19:~/scm/parcit/RA/adr/system/docs$ sudo fio 
postgresql_storage_workload.fio
randread: (g=0): rw=randread, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, 
iodepth=128
...
fio-2.1.11
Starting 32 threads
Jobs: 1 (f=0): [_(24),r(1),_(7)] [100.0% done] [0KB/0KB/0KB /s] [0/0/0 
iops] [eta 00m:00s]
randread: (groupid=0, jobs=32): err= 0: pid=2263: Mon Jan 23 19:30:49 2017
   read : io=977.76GB, bw=8343.4MB/s, iops=2135.9K, runt=120001msec
     slat (usec): min=0, max=3372, avg= 7.30, stdev=27.48
     clat (usec): min=1, max=21871, avg=997.26, stdev=1995.10
      lat (usec): min=4, max=21982, avg=1004.60, stdev=2010.61
     clat percentiles (usec):
      |  1.00th=[  374],  5.00th=[  378], 10.00th=[  378], 20.00th=[  386],
      | 30.00th=[  390], 40.00th=[  394], 50.00th=[  394], 60.00th=[  398],
      | 70.00th=[  406], 80.00th=[  540], 90.00th=[ 1496], 95.00th=[ 5408],
      | 99.00th=[10944], 99.50th=[12224], 99.90th=[14016], 99.95th=[14784],
      | 99.99th=[16512]
     bw (KB  /s): min=    0, max=1353208, per=5.91%, avg=505187.96, 
stdev=549388.79
     lat (usec) : 2=0.01%, 4=0.01%, 10=0.01%, 20=0.01%, 50=0.01%
     lat (usec) : 100=0.01%, 250=0.01%, 500=78.69%, 750=5.80%, 1000=2.94%
     lat (msec) : 2=3.84%, 4=2.66%, 10=4.52%, 20=1.56%, 50=0.01%
   cpu          : usr=3.09%, sys=68.19%, ctx=10916103, majf=0, minf=4128
   IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=0.1%, 
 >=64=100.0%
      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
 >=64=0.0%
      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
 >=64=0.1%
      issued    : total=r=256309234/w=0/d=0, short=r=0/w=0/d=0
      latency   : target=0, window=0, percentile=100.00%, depth=128

Run status group 0 (all jobs):
    READ: io=977.76GB, aggrb=8343.4MB/s, minb=8343.4MB/s, 
maxb=8343.4MB/s, mint=120001msec, maxt=120001msec

Disk stats (read/write):
     md1: ios=10762806/0, merge=0/0, ticks=0/0, in_queue=0, util=0.00%, 
aggrios=675866/0, aggrmerge=0/0, aggrticks=70332/0, aggrin_queue=70505, 
aggrutil=28.65%
   nvme15n1: ios=675832/0, merge=0/0, ticks=69604/0, in_queue=69648, 
util=27.82%
   nvme6n1: ios=676181/0, merge=0/0, ticks=75584/0, in_queue=75552, 
util=28.65%
   nvme9n1: ios=675762/0, merge=0/0, ticks=67916/0, in_queue=68236, 
util=27.79%
   nvme11n1: ios=675745/0, merge=0/0, ticks=68296/0, in_queue=68804, 
util=27.66%
   nvme2n1: ios=676036/0, merge=0/0, ticks=70904/0, in_queue=71240, 
util=28.14%
   nvme14n1: ios=675737/0, merge=0/0, ticks=71560/0, in_queue=71716, 
util=28.13%
   nvme5n1: ios=676592/0, merge=0/0, ticks=71832/0, in_queue=71976, 
util=28.02%
   nvme8n1: ios=675969/0, merge=0/0, ticks=69152/0, in_queue=69192, 
util=27.63%
   nvme10n1: ios=675607/0, merge=0/0, ticks=67600/0, in_queue=67668, 
util=27.74%
   nvme1n1: ios=675528/0, merge=0/0, ticks=72856/0, in_queue=73136, 
util=28.48%
   nvme13n1: ios=675189/0, merge=0/0, ticks=69736/0, in_queue=70084, 
util=28.04%
   nvme4n1: ios=676117/0, merge=0/0, ticks=68120/0, in_queue=68600, 
util=27.88%
   nvme7n1: ios=675726/0, merge=0/0, ticks=72004/0, in_queue=71960, 
util=28.25%
   nvme0n1: ios=676119/0, merge=0/0, ticks=71228/0, in_queue=71264, 
util=28.12%
   nvme12n1: ios=675837/0, merge=0/0, ticks=70320/0, in_queue=70368, 
util=27.99%
   nvme3n1: ios=675887/0, merge=0/0, ticks=68600/0, in_queue=68636, 
util=27.95%
oberstet@svr-psql19:~/scm/parcit/RA/adr/system/docs$

