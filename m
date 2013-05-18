Return-Path: <ecomar@uk.ibm.com>
In-Reply-To: <20130518122211.GM19781@kernel.dk>
References: <OFB8065112.FF17BF54-ON80257B6F.00062897-80257B6F.000821C0@uk.ibm.com> <20130518065341.GJ19781@kernel.dk> <20130518070110.GK19781@kernel.dk> <OFCAFB895A.56FC581E-ON80257B6F.003AA486-80257B6F.003BB600@uk.ibm.com> <OFEF259463.FACECBD6-ON80257B6F.003C54FB-80257B6F.003CA237@LocalDomain> <OF1E75BC9A.821D96E0-ON80257B6F.003CB4BE-80257B6F.003E2AAA@uk.ibm.com> <20130518122211.GM19781@kernel.dk>
MIME-Version: 1.0
Subject: Re: output - aggregate read bandwitdh
From: Edoardo Comar <ECOMAR@uk.ibm.com>
Message-ID: <OF4E37C571.40B0273E-ON80257B6F.005B05C5-80257B6F.005DC361@uk.ibm.com>
Date: Sat, 18 May 2013 18:03:58 +0100
Content-Type: text/plain; charset="US-ASCII"
To: Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

> 
> Very odd, it seems consistent for me with fio off git, both for initial
> run and repeat runs (with existing files). I wonder if it's the clock.
> Please send me the output of --cpuclock-test and also repeat your run
> (both fresh and reuse) with clocksource=clock_gettime added to your
> config file.
> 
> -- 
> Jens Axboe

Hi Jens, 
I am now using my laptop to generate the output I post here, 
however the problem in the read value of aggrb being sky-high when files 
were created, 
occurred to me on a server machine.

I now noticed that if I keep running fio-2.1-8-gb2c77
I am getting too consistent results (please see below ) but with the 
sky-high value for aggrb read.

If I run the 2.0.1.3 version (over the existsing files created by 
fio-2.1-8-gb2c77) the value reported is 'normal'
and after that I can run fio-2.1-8-gb2c77 and it too reports normal values 
!!!

so to be clear, I have now ran in this sequence

output-fio-2.1-8-gb2c77-clocksource-run01.txt  //new files, read aggrb 
skyhigh      563220KB/s
output-fio-2.1-8-gb2c77-clocksource-run02.txt  //existing files, read 
aggrb skyhigh 510402KB/s
output-fio-2.1-8-gb2c77-clocksource-run03.txt  //existing files, read 
aggrb skyhigh 550064KB/s
output-fio-2.0.1.3-clocksource.txt                   //existing files, 
read aggrb normal       197KB/s

output-fio-2.1-8-gb2c77-clocksource-run04.txt  //existing files, read 
aggrb normal-ish 147KB/s
                                                             // but the 
values is much lower than 2.0.1.3
                                                                //too hard 
for me to know which one to trust !

HTH,
Edo

$ fio -version
fio-2.1-8-gb2c77
$ fio --cpuclock-test
cs: reliable_tsc: no
time     17293 cycles[0]=2525
time     17293 cycles[1]=2526
time     17293 cycles[2]=2527
time     17293 cycles[3]=2526
time     17293 cycles[4]=2526
time     17293 cycles[5]=2527
time     17293 cycles[6]=2528
time     17293 cycles[7]=2527
time     17293 cycles[8]=2528
time     17293 cycles[9]=2526
time     17293 cycles[10]=2526
time     17293 cycles[11]=2527
time     17293 cycles[12]=2527
time     17293 cycles[13]=2527
time     17293 cycles[14]=2526
time     17293 cycles[15]=2526
time     17293 cycles[16]=2525
time     17293 cycles[17]=2525
time     17293 cycles[18]=2526
time     17293 cycles[19]=2527
time     17293 cycles[20]=2527
time     17293 cycles[21]=2527
time     17293 cycles[22]=2527
time     17293 cycles[23]=2525
time     17293 cycles[24]=2526
time     17293 cycles[25]=2527
time     17293 cycles[26]=2526
time     17293 cycles[27]=2525
time     17293 cycles[28]=2526
time     17293 cycles[29]=2527
time     17293 cycles[30]=2527
time     17293 cycles[31]=2527
time     17293 cycles[32]=2527
time     17293 cycles[33]=2525
time     17293 cycles[34]=2525
time     17293 cycles[35]=2527
time     17293 cycles[36]=2527
time     17293 cycles[37]=2526
time     17293 cycles[38]=2527
time     17293 cycles[39]=2526
time     17293 cycles[40]=2527
time     17293 cycles[41]=2528
time     17293 cycles[42]=2527
time     17293 cycles[43]=2526
time     17293 cycles[44]=2525
time     17293 cycles[45]=2525
time     17293 cycles[46]=2526
time     17293 cycles[47]=2526
time     17293 cycles[48]=2526
time     17293 cycles[49]=2527
time     17293 avg: 2527
time     17293 mean=2526.832000, S=0.151963
time     17293 inv_cycles_per_usec=6639
cs: Testing 2 CPUs
cs: cpu  1: 19177735 clocks seen
cs: cpu  0: 20651328 clocks seen
cs: Pass!


===========================================
$ cat four-threads-randio-016-clocksource.fio
[global]
size=256m
directory=/mnt/vda2/tmp
invalidate=1
runtime=60
time_based
ramp_time=5
clat_percentiles=0
direct=1
clocksource=clock_gettime

[bgwriter]
rw=randwrite
iodepth=32
ioengine=libaio

[queryA]
rw=randread
ioengine=mmap
thinktime=3

[queryB]
rw=randread
ioengine=mmap
thinktime=5

[bgupdater]
rw=randrw
ioengine=libaio
iodepth=16
size=64m
thinktime=5
===========================================
#output-fio-2.1-8-gb2c77-clocksource-run01.txt

bgwriter: (g=0): rw=randwrite, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, 
iodepth=32
queryA: (g=0): rw=randread, bs=4K-4K/4K-4K/4K-4K, ioengine=mmap, iodepth=1
queryB: (g=0): rw=randread, bs=4K-4K/4K-4K/4K-4K, ioengine=mmap, iodepth=1
bgupdater: (g=0): rw=randrw, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, 
iodepth=16
fio-2.1-8-gb2c77
Starting 4 processes
bgwriter: Laying out IO file(s) (1 file(s) / 256MB)
queryA: Laying out IO file(s) (1 file(s) / 256MB)
queryB: Laying out IO file(s) (1 file(s) / 256MB)
bgupdater: Laying out IO file(s) (1 file(s) / 64MB)

bgwriter: (groupid=0, jobs=1): err= 0: pid=7833: Sat May 18 17:41:27 2013
  write: io=41796KB, bw=712167B/s, iops=173, runt= 60097msec
    slat (usec): min=10, max=636557, avg=202.75, stdev=7986.99
    clat (msec): min=1, max=2193, avg=184.61, stdev=153.37
     lat (msec): min=1, max=2193, avg=184.83, stdev=153.68
    bw (KB  /s): min=    0, max= 1304, per=100.00%, avg=713.81, 
stdev=253.15
    lat (msec) : 2=0.01%, 4=0.08%, 10=0.86%, 20=0.93%, 50=8.12%
    lat (msec) : 100=21.95%, 250=40.41%, 500=25.37%, 750=2.02%, 1000=0.19%
    lat (msec) : 2000=0.26%, >=2000=0.10%
  cpu          : usr=0.18%, sys=0.49%, ctx=11011, majf=0, minf=21
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.2%, 32=108.9%, 
>=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
>=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.1%, 64=0.0%, 
>=64=0.0%
     issued    : total=r=0/w=10418/d=0, short=r=0/w=0/d=0
queryA: (groupid=0, jobs=1): err= 0: pid=7834: Sat May 18 17:41:27 2013
  read : io=17554MB, bw=299582KB/s, iops=74895, runt= 60001msec
    clat (usec): min=1, max=11002, avg= 3.85, stdev=17.84
     lat (usec): min=2, max=11003, avg= 5.34, stdev=20.65
    bw (KB  /s): min=    0, max=321288, per=52.73%, avg=296984.06, 
stdev=30994.78
    lat (usec) : 2=0.01%, 4=46.18%, 10=53.27%, 20=0.32%, 50=0.12%
    lat (usec) : 100=0.01%, 250=0.08%, 500=0.01%, 750=0.01%, 1000=0.01%
    lat (msec) : 2=0.01%, 4=0.01%, 10=0.01%, 20=0.01%
  cpu          : usr=87.93%, sys=12.64%, ctx=31565, majf=0, minf=4560748
  IO depths    : 1=107.5%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, 
>=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
>=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
>=64=0.0%
     issued    : total=r=4493804/w=0/d=0, short=r=0/w=0/d=0
queryB: (groupid=0, jobs=1): err= 0: pid=7835: Sat May 18 17:41:27 2013
  read : io=15449MB, bw=263667KB/s, iops=65916, runt= 60001msec
    clat (usec): min=1, max=8042, avg= 3.84, stdev=18.36
     lat (usec): min=2, max=8043, avg= 5.18, stdev=20.30
    bw (KB  /s): min=    0, max=286672, per=46.41%, avg=261403.13, 
stdev=28405.98
    lat (usec) : 2=0.01%, 4=43.00%, 10=56.53%, 20=0.32%, 50=0.10%
    lat (usec) : 100=0.01%, 250=0.02%, 500=0.01%, 750=0.01%, 1000=0.01%
    lat (msec) : 2=0.01%, 4=0.01%, 10=0.01%
  cpu          : usr=90.94%, sys=10.95%, ctx=26807, majf=0, minf=4092290
  IO depths    : 1=107.8%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, 
>=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
>=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
>=64=0.0%
     issued    : total=r=3955067/w=0/d=0, short=r=0/w=0/d=0
bgupdater: (groupid=0, jobs=1): err= 0: pid=7836: Sat May 18 17:41:27 2013
  read : io=1120.0KB, bw=19112B/s, iops=4, runt= 60006msec
    slat (usec): min=9, max=50604, avg=436.92, stdev=3906.57
    clat (usec): min=365, max=528456, avg=120418.40, stdev=134948.37
     lat (usec): min=402, max=549557, avg=120724.24, stdev=135484.13
    bw (KB  /s): min=    0, max=   87, per=0.00%, avg=17.95, stdev=13.06
  write: io=991232B, bw=16518B/s, iops=4, runt= 60006msec
    slat (usec): min=25, max=442604, avg=3416.67, stdev=32428.43
    clat (usec): min=712, max=1597.7K, avg=104399.00, stdev=166691.30
     lat (usec): min=769, max=1597.8K, avg=108249.43, stdev=170645.26
    bw (KB  /s): min=    2, max=   43, per=2.20%, avg=15.67, stdev= 8.30
    lat (usec) : 500=0.57%, 750=0.77%, 1000=0.96%
    lat (msec) : 2=0.57%, 4=5.56%, 10=20.88%, 20=4.79%, 50=8.81%
    lat (msec) : 100=20.69%, 250=19.35%, 500=16.09%, 750=0.38%, 2000=0.57%
  cpu          : usr=0.02%, sys=0.04%, ctx=600, majf=0, minf=21
  IO depths    : 1=109.4%, 2=0.4%, 4=0.8%, 8=1.5%, 16=0.2%, 32=0.0%, 
>=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
>=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
>=64=0.0%
     issued    : total=r=280/w=242/d=0, short=r=0/w=0/d=0

Run status group 0 (all jobs):
   READ: io=33004MB, aggrb=563220KB/s, minb=18KB/s, maxb=299581KB/s, 
mint=60001msec, maxt=60006msec
  WRITE: io=42764KB, aggrb=711KB/s, minb=16KB/s, maxb=695KB/s, 
mint=60006msec, maxt=60097msec

Disk stats (read/write):
    dm-1: ios=306/13827, merge=0/0, ticks=38330/2387423, in_queue=2425763, 
util=100.00%, aggrios=313/13844, aggrmerge=0/0, aggrticks=38390/2387406, 
aggrin_queue=2425797, aggrutil=100.00%
    dm-0: ios=313/13844, merge=0/0, ticks=38390/2387406, in_queue=2425797, 
util=100.00%, aggrios=313/11823, aggrmerge=0/2021, 
aggrticks=38352/2118973, aggrin_queue=2157320, aggrutil=99.99%
  sda: ios=313/11823, merge=0/2021, ticks=38352/2118973, in_queue=2157320, 
util=99.99%

===========================================
#output-fio-2.1-8-gb2c77-clocksource-run02.txt

bgwriter: (g=0): rw=randwrite, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, 
iodepth=32
queryA: (g=0): rw=randread, bs=4K-4K/4K-4K/4K-4K, ioengine=mmap, iodepth=1
queryB: (g=0): rw=randread, bs=4K-4K/4K-4K/4K-4K, ioengine=mmap, iodepth=1
bgupdater: (g=0): rw=randrw, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, 
iodepth=16
fio-2.1-8-gb2c77
Starting 4 processes

bgwriter: (groupid=0, jobs=1): err= 0: pid=21424: Sat May 18 17:45:58 2013
  write: io=38652KB, bw=656531B/s, iops=159, runt= 60286msec
    slat (usec): min=10, max=376955, avg=386.16, stdev=9359.89
    clat (msec): min=1, max=1880, avg=199.44, stdev=167.99
     lat (msec): min=1, max=1880, avg=199.85, stdev=168.52
    bw (KB  /s): min=    0, max= 1235, per=100.00%, avg=657.64, 
stdev=264.27
    lat (msec) : 2=0.01%, 4=0.30%, 10=1.44%, 20=1.90%, 50=10.38%
    lat (msec) : 100=15.62%, 250=39.17%, 500=26.82%, 750=3.54%, 1000=0.65%
    lat (msec) : 2000=0.48%
  cpu          : usr=0.22%, sys=0.57%, ctx=9776, majf=0, minf=21
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.2%, 32=108.9%, 
>=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
>=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.1%, 64=0.0%, 
>=64=0.0%
     issued    : total=r=0/w=9632/d=0, short=r=0/w=0/d=0
queryA: (groupid=0, jobs=1): err= 0: pid=21425: Sat May 18 17:45:58 2013
  read : io=15820MB, bw=269982KB/s, iops=67495, runt= 60001msec
    clat (usec): min=1, max=20132, avg= 4.43, stdev=53.74
     lat (usec): min=2, max=24895, avg= 6.03, stdev=60.63
    bw (KB  /s): min=    0, max=316976, per=52.43%, avg=267610.96, 
stdev=45195.79
    lat (usec) : 2=0.01%, 4=42.93%, 10=56.40%, 20=0.34%, 50=0.17%
    lat (usec) : 100=0.04%, 250=0.06%, 500=0.02%, 750=0.01%, 1000=0.01%
    lat (msec) : 2=0.01%, 4=0.01%, 10=0.01%, 20=0.01%, 50=0.01%
  cpu          : usr=79.33%, sys=12.15%, ctx=43544, majf=0, minf=4143503
  IO depths    : 1=108.4%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, 
>=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
>=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
>=64=0.0%
     issued    : total=r=4049802/w=0/d=0, short=r=0/w=0/d=0
queryB: (groupid=0, jobs=1): err= 0: pid=21426: Sat May 18 17:45:58 2013
  read : io=14204MB, bw=242415KB/s, iops=60603, runt= 60001msec
    clat (usec): min=1, max=31102, avg= 4.25, stdev=46.56
     lat (usec): min=2, max=31102, avg= 5.67, stdev=52.90
    bw (KB  /s): min=    0, max=284624, per=47.10%, avg=240381.17, 
stdev=38838.46
    lat (usec) : 2=0.01%, 4=40.74%, 10=58.81%, 20=0.32%, 50=0.05%
    lat (usec) : 100=0.01%, 250=0.02%, 500=0.01%, 750=0.01%, 1000=0.01%
    lat (msec) : 2=0.01%, 4=0.01%, 10=0.01%, 20=0.01%, 50=0.01%
  cpu          : usr=83.81%, sys=10.27%, ctx=20480, majf=0, minf=3774654
  IO depths    : 1=108.4%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, 
>=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
>=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
>=64=0.0%
     issued    : total=r=3636281/w=0/d=0, short=r=0/w=0/d=0
bgupdater: (groupid=0, jobs=1): err= 0: pid=21427: Sat May 18 17:45:58 
2013
  read : io=823296B, bw=13667B/s, iops=3, runt= 60237msec
    slat (usec): min=12, max=14578, avg=152.95, stdev=1253.54
    clat (usec): min=440, max=695116, avg=132719.79, stdev=136919.31
     lat (usec): min=479, max=695136, avg=132886.06, stdev=136970.47
    bw (KB  /s): min=    2, max=   63, per=0.00%, avg=16.68, stdev=11.82
  write: io=729088B, bw=12103B/s, iops=2, runt= 60237msec
    slat (usec): min=21, max=368815, avg=5889.06, stdev=36996.94
    clat (msec): min=12, max=1888, avg=181.73, stdev=304.33
     lat (msec): min=12, max=1900, avg=188.32, stdev=307.45
    bw (KB  /s): min=    0, max=   30, per=1.95%, avg=12.72, stdev= 7.04
    lat (usec) : 500=0.26%
    lat (msec) : 2=0.26%, 4=3.43%, 10=18.47%, 20=3.43%, 50=10.03%
    lat (msec) : 100=20.05%, 250=22.96%, 500=18.47%, 750=0.53%, 1000=0.26%
    lat (msec) : 2000=1.85%
  cpu          : usr=0.02%, sys=0.02%, ctx=467, majf=0, minf=21
  IO depths    : 1=111.9%, 2=0.5%, 4=1.1%, 8=2.1%, 16=0.3%, 32=0.0%, 
>=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
>=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
>=64=0.0%
     issued    : total=r=201/w=178/d=0, short=r=0/w=0/d=0

Run status group 0 (all jobs):
   READ: io=30025MB, aggrb=510402KB/s, minb=13KB/s, maxb=269982KB/s, 
mint=60001msec, maxt=60237msec
  WRITE: io=39364KB, aggrb=652KB/s, minb=11KB/s, maxb=641KB/s, 
mint=60237msec, maxt=60286msec

Disk stats (read/write):
    dm-1: ios=265/12202, merge=0/0, ticks=37253/2417250, in_queue=2459189, 
util=99.96%, aggrios=309/12276, aggrmerge=0/0, aggrticks=42704/2424620, 
aggrin_queue=2467343, aggrutil=99.96%
    dm-0: ios=309/12276, merge=0/0, ticks=42704/2424620, in_queue=2467343, 
util=99.96%, aggrios=274/11161, aggrmerge=35/1128, 
aggrticks=38012/2211094, aggrin_queue=2249116, aggrutil=99.96%
  sda: ios=274/11161, merge=35/1128, ticks=38012/2211094, 
in_queue=2249116, util=99.96%

===========================================
#output-fio-2.1-8-gb2c77-clocksource-run03.txt

bgwriter: (g=0): rw=randwrite, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, 
iodepth=32
queryA: (g=0): rw=randread, bs=4K-4K/4K-4K/4K-4K, ioengine=mmap, iodepth=1
queryB: (g=0): rw=randread, bs=4K-4K/4K-4K/4K-4K, ioengine=mmap, iodepth=1
bgupdater: (g=0): rw=randrw, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, 
iodepth=16
fio-2.1-8-gb2c77
Starting 4 processes

bgwriter: (groupid=0, jobs=1): err= 0: pid=28992: Sat May 18 17:48:33 2013
  write: io=43084KB, bw=734443B/s, iops=178, runt= 60070msec
    slat (usec): min=9, max=267785, avg=174.06, stdev=5320.19
    clat (msec): min=3, max=630, avg=178.97, stdev=109.17
     lat (msec): min=3, max=707, avg=179.14, stdev=109.61
    bw (KB  /s): min=    0, max= 1304, per=98.95%, avg=725.33, 
stdev=228.04
    lat (msec) : 4=0.01%, 10=0.16%, 20=1.02%, 50=10.21%, 100=16.56%
    lat (msec) : 250=44.13%, 500=27.49%, 750=0.70%
  cpu          : usr=0.29%, sys=0.57%, ctx=11390, majf=0, minf=21
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=109.0%, 
>=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
>=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.1%, 64=0.0%, 
>=64=0.0%
     issued    : total=r=0/w=10740/d=0, short=r=0/w=0/d=0
queryA: (groupid=0, jobs=1): err= 0: pid=28993: Sat May 18 17:48:33 2013
  read : io=17010MB, bw=290296KB/s, iops=72574, runt= 60001msec
    clat (usec): min=1, max=18751, avg= 4.00, stdev=28.23
     lat (usec): min=2, max=21993, avg= 5.51, stdev=33.32
    bw (KB  /s): min=    0, max=324568, per=52.32%, avg=287819.09, 
stdev=33580.72
    lat (usec) : 2=0.01%, 4=45.23%, 10=54.21%, 20=0.33%, 50=0.10%
    lat (usec) : 100=0.04%, 250=0.06%, 500=0.01%, 750=0.01%, 1000=0.01%
    lat (msec) : 2=0.01%, 4=0.01%, 10=0.01%, 20=0.01%
  cpu          : usr=85.30%, sys=12.45%, ctx=30102, majf=0, minf=4436073
  IO depths    : 1=107.7%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, 
>=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
>=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
>=64=0.0%
     issued    : total=r=4354517/w=0/d=0, short=r=0/w=0/d=0
queryB: (groupid=0, jobs=1): err= 0: pid=28994: Sat May 18 17:48:33 2013
  read : io=15244MB, bw=260154KB/s, iops=65038, runt= 60001msec
    clat (usec): min=1, max=15439, avg= 3.92, stdev=26.11
     lat (usec): min=2, max=15439, avg= 5.28, stdev=29.16
    bw (KB  /s): min=    0, max=285960, per=46.91%, avg=258013.36, 
stdev=30605.46
    lat (usec) : 2=0.01%, 4=42.79%, 10=56.72%, 20=0.32%, 50=0.12%
    lat (usec) : 100=0.01%, 250=0.02%, 500=0.01%, 750=0.01%, 1000=0.01%
    lat (msec) : 2=0.01%, 4=0.01%, 10=0.01%, 20=0.01%
  cpu          : usr=89.37%, sys=11.14%, ctx=30316, majf=0, minf=4039065
  IO depths    : 1=107.9%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, 
>=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
>=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
>=64=0.0%
     issued    : total=r=3902373/w=0/d=0, short=r=0/w=0/d=0
bgupdater: (groupid=0, jobs=1): err= 0: pid=28995: Sat May 18 17:48:33 
2013
  read : io=1092.0KB, bw=18622B/s, iops=4, runt= 60045msec
    slat (usec): min=9, max=101133, avg=470.37, stdev=6073.32
    clat (usec): min=362, max=555207, avg=128303.00, stdev=133601.26
     lat (usec): min=391, max=555226, avg=128826.96, stdev=134014.07
    bw (KB  /s): min=    5, max=   68, per=0.00%, avg=18.53, stdev=12.06
  write: io=987136B, bw=16439B/s, iops=4, runt= 60045msec
    slat (usec): min=21, max=67195, avg=1354.70, stdev=7790.18
    clat (msec): min=21, max=442, avg=101.90, stdev=74.20
     lat (msec): min=21, max=497, avg=103.19, stdev=79.07
    bw (KB  /s): min=    0, max=   31, per=2.16%, avg=15.86, stdev= 6.93
    lat (usec) : 500=0.39%, 1000=0.19%
    lat (msec) : 2=0.19%, 4=3.70%, 10=18.68%, 20=4.28%, 50=9.14%
    lat (msec) : 100=20.43%, 250=28.02%, 500=14.59%, 750=0.39%
  cpu          : usr=0.03%, sys=0.03%, ctx=598, majf=0, minf=21
  IO depths    : 1=109.1%, 2=0.4%, 4=0.8%, 8=1.6%, 16=0.2%, 32=0.0%, 
>=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
>=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
>=64=0.0%
     issued    : total=r=273/w=241/d=0, short=r=0/w=0/d=0

Run status group 0 (all jobs):
   READ: io=32255MB, aggrb=550064KB/s, minb=18KB/s, maxb=290296KB/s, 
mint=60001msec, maxt=60045msec
  WRITE: io=44048KB, aggrb=733KB/s, minb=16KB/s, maxb=717KB/s, 
mint=60045msec, maxt=60070msec

Disk stats (read/write):
    dm-1: ios=305/15205, merge=0/0, ticks=37839/3980140, in_queue=4021506, 
util=99.96%, aggrios=305/15237, aggrmerge=0/0, aggrticks=38072/3988561, 
aggrin_queue=4026637, aggrutil=99.94%
    dm-0: ios=305/15237, merge=0/0, ticks=38072/3988561, in_queue=4026637, 
util=99.94%, aggrios=305/12165, aggrmerge=0/3072, aggrticks=38045/2152312, 
aggrin_queue=2190352, aggrutil=99.94%
  sda: ios=305/12165, merge=0/3072, ticks=38045/2152312, in_queue=2190352, 
util=99.94%

======================================================
#output-fio-2.0.1.3-clocksource.txt

bgwriter: (g=0): rw=randwrite, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, 
iodepth=32
queryA: (g=0): rw=randread, bs=4K-4K/4K-4K/4K-4K, ioengine=mmap, iodepth=1
queryB: (g=0): rw=randread, bs=4K-4K/4K-4K/4K-4K, ioengine=mmap, iodepth=1
bgupdater: (g=0): rw=randrw, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, 
iodepth=16
fio-2.0.13
Starting 4 processes

bgwriter: (groupid=0, jobs=1): err= 0: pid=6668: Sat May 18 17:51:55 2013
  write: io=22280KB, bw=378384 B/s, iops=91 , runt= 60295msec
    slat (usec): min=9 , max=576672 , avg=563.21, stdev=13804.80
    clat (msec): min=4 , max=1524 , avg=347.56, stdev=245.47
     lat (msec): min=4 , max=1525 , avg=348.07, stdev=246.11
    bw (KB/s)  : min=    0, max=  888, per=75.11%, avg=374.79, 
stdev=141.95
    lat (msec) : 10=0.83%, 20=3.68%, 50=9.35%, 100=9.04%, 250=9.24%
    lat (msec) : 500=46.34%, 750=16.14%, 1000=4.17%, 2000=1.75%
  cpu          : usr=0.14%, sys=0.34%, ctx=5754, majf=0, minf=21
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.3%, 32=108.9%, 
>=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
>=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.1%, 64=0.0%, 
>=64=0.0%
     issued    : total=r=0/w=5539/d=0, short=r=0/w=0/d=0
queryA: (groupid=0, jobs=1): err= 0: pid=6669: Sat May 18 17:51:55 2013
  read : io=1976.0KB, bw=33713 B/s, iops=8 , runt= 60018msec
    clat (msec): min=6 , max=649 , avg=121.48, stdev=147.39
     lat (msec): min=6 , max=649 , avg=121.48, stdev=147.39
    bw (KB/s)  : min=    0, max=  119, per=16.55%, avg=32.60, stdev=20.17
    lat (msec) : 10=3.04%, 20=33.81%, 50=21.86%, 100=6.88%, 250=10.32%
    lat (msec) : 500=22.06%, 750=2.02%
  cpu          : usr=0.01%, sys=0.12%, ctx=601, majf=546, minf=26
  IO depths    : 1=110.5%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, 
>=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
>=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
>=64=0.0%
     issued    : total=r=494/w=0/d=0, short=r=0/w=0/d=0
queryB: (groupid=0, jobs=1): err= 0: pid=6670: Sat May 18 17:51:55 2013
  read : io=2268.0KB, bw=38705 B/s, iops=9 , runt= 60002msec
    clat (msec): min=6 , max=698 , avg=105.81, stdev=138.63
     lat (msec): min=6 , max=698 , avg=105.81, stdev=138.63
    bw (KB/s)  : min=    0, max=  125, per=18.86%, avg=37.16, stdev=21.14
    lat (msec) : 10=3.70%, 20=37.21%, 50=23.81%, 100=5.47%, 250=8.29%
    lat (msec) : 500=20.28%, 750=1.23%
  cpu          : usr=0.02%, sys=0.11%, ctx=649, majf=627, minf=26
  IO depths    : 1=110.6%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, 
>=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
>=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
>=64=0.0%
     issued    : total=r=567/w=0/d=0, short=r=0/w=0/d=0
bgupdater: (groupid=0, jobs=1): err= 0: pid=6671: Sat May 18 17:51:55 2013
  read : io=7612.0KB, bw=129593 B/s, iops=31 , runt= 60147msec
    slat (usec): min=6 , max=393298 , avg=480.26, stdev=10901.42
    clat (usec): min=2 , max=738467 , avg=196112.75, stdev=151447.12
     lat (msec): min=3 , max=738 , avg=196.43, stdev=151.24
    bw (KB/s)  : min=    0, max=  347, per=65.17%, avg=128.39, stdev=64.75
  write: io=7836.0KB, bw=133407 B/s, iops=32 , runt= 60147msec
    slat (usec): min=9 , max=280436 , avg=573.65, stdev=9113.92
    clat (msec): min=5 , max=1531 , avg=303.01, stdev=218.43
     lat (msec): min=5 , max=1531 , avg=303.62, stdev=219.15
    bw (KB/s)  : min=    7, max=  308, per=26.76%, avg=133.54, stdev=55.90
    lat (usec) : 4=0.03%, 50=0.03%, 250=0.03%, 500=0.03%
    lat (msec) : 4=0.03%, 10=1.09%, 20=6.73%, 50=10.71%, 100=10.92%
    lat (msec) : 250=21.55%, 500=39.12%, 750=8.60%, 1000=1.12%, 2000=0.42%
  cpu          : usr=0.13%, sys=0.24%, ctx=4015, majf=0, minf=21
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.2%, 16=108.3%, 32=0.0%, 
>=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
>=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.1%, 32=0.0%, 64=0.0%, 
>=64=0.0%
     issued    : total=r=1896/w=1951/d=0, short=r=0/w=0/d=0

Run status group 0 (all jobs):
   READ: io=11856KB, aggrb=197KB/s, minb=32KB/s, maxb=126KB/s, 
mint=60002msec, maxt=60147msec
  WRITE: io=30116KB, aggrb=499KB/s, minb=130KB/s, maxb=369KB/s, 
mint=60147msec, maxt=60295msec

Disk stats (read/write):
    dm-1: ios=3232/8863, merge=0/0, ticks=520001/2905976, 
in_queue=3432267, util=99.97%, aggrios=3238/8882, aggrmerge=0/0, 
aggrticks=522983/2914392, aggrin_queue=3437376, aggrutil=99.95%
    dm-0: ios=3238/8882, merge=0/0, ticks=522983/2914392, 
in_queue=3437376, util=99.95%, aggrios=3237/8331, aggrmerge=1/551, 
aggrticks=522374/2779308, aggrin_queue=3301679, aggrutil=99.95%
  sda: ios=3237/8331, merge=1/551, ticks=522374/2779308, in_queue=3301679, 
util=99.95%

===========================================
#output-fio-2.1-8-gb2c77-clocksource-run04.txt

bgwriter: (g=0): rw=randwrite, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, 
iodepth=32
queryA: (g=0): rw=randread, bs=4K-4K/4K-4K/4K-4K, ioengine=mmap, iodepth=1
queryB: (g=0): rw=randread, bs=4K-4K/4K-4K/4K-4K, ioengine=mmap, iodepth=1
bgupdater: (g=0): rw=randrw, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, 
iodepth=16
fio-2.1-8-gb2c77
Starting 4 processes

bgwriter: (groupid=0, jobs=1): err= 0: pid=14785: Sat May 18 17:54:34 2013
  write: io=26688KB, bw=453201B/s, iops=110, runt= 60301msec
    slat (usec): min=9, max=378442, avg=289.28, stdev=8413.42
    clat (msec): min=4, max=1352, avg=290.98, stdev=210.53
     lat (msec): min=4, max=1352, avg=291.29, stdev=210.88
    bw (KB  /s): min=    0, max=  988, per=99.50%, avg=448.73, 
stdev=171.09
    lat (msec) : 10=1.79%, 20=5.21%, 50=13.45%, 100=10.54%, 250=4.47%
    lat (msec) : 500=52.76%, 750=10.15%, 1000=1.39%, 2000=0.71%
  cpu          : usr=0.19%, sys=0.38%, ctx=6951, majf=0, minf=21
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.2%, 32=109.2%, 
>=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
>=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.1%, 64=0.0%, 
>=64=0.0%
     issued    : total=r=0/w=6641/d=0, short=r=0/w=0/d=0
queryA: (groupid=0, jobs=1): err= 0: pid=14786: Sat May 18 17:54:34 2013
  read : io=4132.0KB, bw=70321B/s, iops=17, runt= 60169msec
    clat (msec): min=3, max=824, avg=58.24, stdev=99.91
     lat (msec): min=3, max=824, avg=58.24, stdev=99.91
    bw (KB  /s): min=    0, max=  119, per=46.20%, avg=67.91, stdev=18.24
    lat (msec) : 4=0.10%, 10=5.91%, 20=57.12%, 50=20.52%, 100=0.97%
    lat (msec) : 250=1.36%, 500=13.84%, 750=0.10%, 1000=0.10%
  cpu          : usr=0.05%, sys=0.04%, ctx=1120, majf=1118, minf=570
  IO depths    : 1=160.6%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, 
>=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
>=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
>=64=0.0%
     issued    : total=r=1033/w=0/d=0, short=r=0/w=0/d=0
queryB: (groupid=0, jobs=1): err= 0: pid=14787: Sat May 18 17:54:34 2013
  read : io=4076.0KB, bw=69382B/s, iops=16, runt= 60157msec
    clat (usec): min=740, max=695534, avg=59021.33, stdev=99976.29
     lat (usec): min=741, max=695536, avg=59022.59, stdev=99976.29
    bw (KB  /s): min=    0, max=  124, per=46.10%, avg=67.77, stdev=17.54
    lat (usec) : 750=0.10%
    lat (msec) : 4=0.10%, 10=5.10%, 20=58.98%, 50=19.14%, 100=0.79%
    lat (msec) : 250=1.96%, 500=13.64%, 750=0.20%
  cpu          : usr=0.06%, sys=0.05%, ctx=1111, majf=1107, minf=653
  IO depths    : 1=169.9%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, 
>=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
>=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
>=64=0.0%
     issued    : total=r=1019/w=0/d=0, short=r=0/w=0/d=0
bgupdater: (groupid=0, jobs=1): err= 0: pid=14788: Sat May 18 17:54:34 
2013
  read : io=663552B, bw=11029B/s, iops=2, runt= 60163msec
    slat (usec): min=7, max=261587, avg=2302.71, stdev=21049.01
    clat (usec): min=2, max=680737, avg=136896.22, stdev=132669.42
     lat (msec): min=7, max=680, avg=139.35, stdev=133.27
    bw (KB  /s): min=    0, max=   39, per=8.74%, avg=12.84, stdev= 9.34
  write: io=540672B, bw=8986B/s, iops=2, runt= 60163msec
    slat (usec): min=9, max=100617, avg=1968.88, stdev=13441.24
    clat (msec): min=44, max=973, avg=282.50, stdev=186.38
     lat (msec): min=44, max=973, avg=284.72, stdev=188.77
    bw (KB  /s): min=    3, max=   22, per=1.92%, avg= 8.65, stdev= 4.07
    lat (usec) : 4=0.34%
    lat (msec) : 10=1.02%, 20=15.31%, 50=10.88%, 100=7.82%, 250=26.87%
    lat (msec) : 500=32.99%, 750=3.74%, 1000=1.02%
  cpu          : usr=0.01%, sys=0.02%, ctx=341, majf=0, minf=21
  IO depths    : 1=106.5%, 2=0.7%, 4=1.4%, 8=2.7%, 16=0.3%, 32=0.0%, 
>=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
>=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
>=64=0.0%
     issued    : total=r=162/w=132/d=0, short=r=0/w=0/d=0

Run status group 0 (all jobs):
   READ: io=8856KB, aggrb=147KB/s, minb=10KB/s, maxb=68KB/s, 
mint=60157msec, maxt=60169msec
  WRITE: io=27216KB, aggrb=451KB/s, minb=8KB/s, maxb=442KB/s, 
mint=60163msec, maxt=60301msec

Disk stats (read/write):
    dm-1: ios=2409/10744, merge=0/0, ticks=157436/4722979, 
in_queue=4888552, util=99.97%, aggrios=2414/10759, aggrmerge=0/0, 
aggrticks=157652/4733035, aggrin_queue=4890687, aggrutil=99.95%
    dm-0: ios=2414/10759, merge=0/0, ticks=157652/4733035, 
in_queue=4890687, util=99.95%, aggrios=2414/7627, aggrmerge=0/3132, 
aggrticks=157316/2161791, aggrin_queue=2319104, aggrutil=99.95%
  sda: ios=2414/7627, merge=0/3132, ticks=157316/2161791, 
in_queue=2319104, util=99.95%
Unless stated otherwise above:
IBM United Kingdom Limited - Registered in England and Wales with number 
741598. 
Registered office: PO Box 41, North Harbour, Portsmouth, Hampshire PO6 3AU


