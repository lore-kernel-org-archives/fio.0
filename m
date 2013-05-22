Return-Path: <ecomar@uk.ibm.com>
In-Reply-To: <20130522101858.GH9714@kernel.dk>
References: <OFCAFB895A.56FC581E-ON80257B6F.003AA486-80257B6F.003BB600@uk.ibm.com> <OFEF259463.FACECBD6-ON80257B6F.003C54FB-80257B6F.003CA237@LocalDomain> <OF1E75BC9A.821D96E0-ON80257B6F.003CB4BE-80257B6F.003E2AAA@uk.ibm.com> <20130518122211.GM19781@kernel.dk> <OF4E37C571.40B0273E-ON80257B6F.005B05C5-80257B6F.005DC361@uk.ibm.com> <OFD80C407E.DC45623D-ON80257B6F.007F5485-80257B6F.007FC70E@uk.ibm.com> <OFE288D6C7.BEB7BBEB-ON80257B73.002E3467-80257B73.002E896D@uk.ibm.com> <20130522085736.GE9714@kernel.dk> <OF4C0E9045.FB0B29B3-ON80257B73.0036DB50-80257B73.00373934@uk.ibm.com> <20130522101554.GG9714@kernel.dk> <20130522101858.GH9714@kernel.dk>
MIME-Version: 1.0
Subject: Re: output - aggregate read bandwitdh
From: Edoardo Comar <ECOMAR@uk.ibm.com>
Message-ID: <OFABB32A79.2C0C3A51-ON80257B73.00423F23-80257B73.0043C1F5@uk.ibm.com>
Date: Wed, 22 May 2013 13:19:55 +0100
Content-Type: text/plain; charset="US-ASCII"
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

> > So 67bf982340d95ca98098ea050b54b4c7adb116c0 is the first bad commit,
> > funky. Ah I think I see what it is, hang on.
> 
> http://git.kernel.dk/?
> p=fio.git;a=commit;h=4b20c6814d4742e27a68f8a740a955283869fbcd
> 
> If you git pull, you'll get that. Please see if that makes it behave
> like 2.0.13 for you.
> 

Thanks,
this has fixed the read aggrb reported value to be unreasonably high
however the value is now significantly lower than 2.0.13  it's about 1/2
while the write value is very comparable.
Please find the outputs below.

MASTER:
Run status group 0 (all jobs):
   READ: io=7976KB, aggrb=132KB/s, minb=13KB/s, maxb=59KB/s, 
mint=60023msec, maxt=60131msec
  WRITE: io=39552KB, aggrb=658KB/s, minb=12KB/s, maxb=646KB/s, 
mint=60023msec, maxt=60079msec

2.0.13
Run status group 0 (all jobs):
   READ: io=13716KB, aggrb=227KB/s, minb=32KB/s, maxb=162KB/s, 
mint=60118msec, maxt=60368msec
  WRITE: io=41100KB, aggrb=680KB/s, minb=168KB/s, maxb=513KB/s, 
mint=60230msec, maxt=60368msec

=========================================================

bgwriter: (g=0): rw=randwrite, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, 
iodepth=32
queryA: (g=0): rw=randread, bs=4K-4K/4K-4K/4K-4K, ioengine=mmap, iodepth=1
queryB: (g=0): rw=randread, bs=4K-4K/4K-4K/4K-4K, ioengine=mmap, iodepth=1
bgupdater: (g=0): rw=randrw, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, 
iodepth=16
fio-2.1-10-g4b20
Starting 4 processes
bgwriter: Laying out IO file(s) (1 file(s) / 256MB)
queryA: Laying out IO file(s) (1 file(s) / 256MB)
queryB: Laying out IO file(s) (1 file(s) / 256MB)
bgupdater: Laying out IO file(s) (1 file(s) / 64MB)
Jobs: 4 (f=4): 
bgwriter: (groupid=0, jobs=1): err= 0: pid=31283: Wed May 22 12:57:10 2013
  write: io=38816KB, bw=661588B/s, iops=161, runt= 60079msec
    slat (usec): min=11, max=90943, avg=36.96, stdev=906.14
    clat (msec): min=3, max=1325, avg=200.20, stdev=164.31
     lat (msec): min=3, max=1325, avg=200.24, stdev=164.33
    bw (KB  /s): min=    0, max= 1088, per=99.83%, avg=656.91, 
stdev=229.78
    lat (msec) : 4=0.01%, 10=1.58%, 20=6.64%, 50=16.00%, 100=13.95%
    lat (msec) : 250=27.55%, 500=29.66%, 750=3.71%, 1000=1.17%, 2000=0.05%
  cpu          : usr=0.22%, sys=0.58%, ctx=9875, majf=0, minf=21
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.2%, 32=108.6%, 
>=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
>=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.1%, 64=0.0%, 
>=64=0.0%
     issued    : total=r=0/w=9673/d=0, short=r=0/w=0/d=0
queryA: (groupid=0, jobs=1): err= 0: pid=31284: Wed May 22 12:57:10 2013
  read : io=3604.0KB, bw=61374B/s, iops=14, runt= 60131msec
    clat (msec): min=3, max=700, avg=66.73, stdev=91.42
     lat (msec): min=3, max=700, avg=66.73, stdev=91.42
    bw (KB  /s): min=    0, max=  125, per=45.45%, avg=60.00, stdev=21.47
    lat (msec) : 4=0.11%, 10=2.66%, 20=47.17%, 50=19.42%, 100=8.10%
    lat (msec) : 250=17.20%, 500=5.22%, 750=0.11%
  cpu          : usr=0.04%, sys=0.04%, ctx=971, majf=970, minf=29
  IO depths    : 1=107.7%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, 
>=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
>=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
>=64=0.0%
     issued    : total=r=901/w=0/d=0, short=r=0/w=0/d=0
queryB: (groupid=0, jobs=1): err= 0: pid=31285: Wed May 22 12:57:10 2013
  read : io=3548.0KB, bw=60452B/s, iops=14, runt= 60099msec
    clat (usec): min=725, max=583477, avg=67740.67, stdev=94737.81
     lat (usec): min=726, max=583479, avg=67741.96, stdev=94737.80
    bw (KB  /s): min=    0, max=  112, per=44.47%, avg=58.70, stdev=22.41
    lat (usec) : 750=0.11%
    lat (msec) : 10=3.38%, 20=49.38%, 50=18.49%, 100=6.43%, 250=16.57%
    lat (msec) : 500=5.52%, 750=0.11%
  cpu          : usr=0.03%, sys=0.04%, ctx=962, majf=961, minf=29
  IO depths    : 1=108.3%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, 
>=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
>=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
>=64=0.0%
     issued    : total=r=887/w=0/d=0, short=r=0/w=0/d=0
bgupdater: (groupid=0, jobs=1): err= 0: pid=31286: Wed May 22 12:57:10 
2013
  read : io=843776B, bw=14057B/s, iops=3, runt= 60023msec
    slat (usec): min=10, max=227735, avg=1445.97, stdev=15443.42
    clat (usec): min=5, max=579413, avg=120337.02, stdev=108882.11
     lat (msec): min=7, max=579, avg=121.96, stdev=109.78
    bw (KB  /s): min=    4, max=   85, per=11.82%, avg=15.60, stdev=12.91
  write: io=753664B, bw=12556B/s, iops=3, runt= 60023msec
    slat (usec): min=17, max=132927, avg=3184.62, stdev=18633.89
    clat (msec): min=17, max=566, avg=186.08, stdev=122.85
     lat (msec): min=17, max=582, avg=189.64, stdev=129.83
    bw (KB  /s): min=    0, max=   23, per=1.82%, avg=11.97, stdev= 4.60
    lat (usec) : 10=0.26%
    lat (msec) : 10=1.28%, 20=9.74%, 50=11.54%, 100=18.72%, 250=39.49%
    lat (msec) : 500=17.44%, 750=1.54%
  cpu          : usr=0.03%, sys=0.01%, ctx=466, majf=0, minf=21
  IO depths    : 1=108.2%, 2=0.5%, 4=1.0%, 8=2.1%, 16=0.3%, 32=0.0%, 
>=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
>=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
>=64=0.0%
     issued    : total=r=206/w=184/d=0, short=r=0/w=0/d=0

Run status group 0 (all jobs):
   READ: io=7976KB, aggrb=132KB/s, minb=13KB/s, maxb=59KB/s, 
mint=60023msec, maxt=60131msec
  WRITE: io=39552KB, aggrb=658KB/s, minb=12KB/s, maxb=646KB/s, 
mint=60023msec, maxt=60079msec

Disk stats (read/write):
    dm-1: ios=2165/15038, merge=0/0, ticks=159046/3058053, 
in_queue=3222168, util=99.97%, aggrios=2165/15066, aggrmerge=0/0, 
aggrticks=159722/3065336, aggrin_queue=3225058, aggrutil=99.95%
    dm-0: ios=2165/15066, merge=0/0, ticks=159722/3065336, 
in_queue=3225058, util=99.95%, aggrios=2165/11221, aggrmerge=0/3841, 
aggrticks=159422/2284175, aggrin_queue=2443590, aggrutil=99.95%
  sda: ios=2165/11221, merge=0/3841, ticks=159422/2284175, 
in_queue=2443590, util=99.95%

=========================================================

[ecomar@edow500 fio]$ rm -rf /mnt/vda2/tmp/*; /usr/bin/fio 
../fio-check-bug/four-threads-randio-016.fio 
bgwriter: (g=0): rw=randwrite, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, 
iodepth=32
queryA: (g=0): rw=randread, bs=4K-4K/4K-4K/4K-4K, ioengine=mmap, iodepth=1
queryB: (g=0): rw=randread, bs=4K-4K/4K-4K/4K-4K, ioengine=mmap, iodepth=1
bgupdater: (g=0): rw=randrw, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, 
iodepth=16
fio-2.0.13
Starting 4 processes
bgwriter: Laying out IO file(s) (1 file(s) / 256MB)
queryA: Laying out IO file(s) (1 file(s) / 256MB)
queryB: Laying out IO file(s) (1 file(s) / 256MB)
bgupdater: Laying out IO file(s) (1 file(s) / 64MB)
Jobs: 4 (f=4): 
bgwriter: (groupid=0, jobs=1): err= 0: pid=10553: Wed May 22 13:10:21 2013
  write: io=30900KB, bw=525346 B/s, iops=127 , runt= 60230msec
    slat (usec): min=10 , max=520 , avg=26.59, stdev=10.78
    clat (msec): min=5 , max=1559 , avg=250.44, stdev=195.85
     lat (msec): min=5 , max=1559 , avg=250.47, stdev=195.85
    bw (KB/s)  : min=    0, max=  890, per=76.42%, avg=519.68, 
stdev=168.78
    lat (msec) : 10=0.70%, 20=5.06%, 50=12.65%, 100=9.51%, 250=24.34%
    lat (msec) : 500=39.76%, 750=5.63%, 1000=2.16%, 2000=0.60%
  cpu          : usr=0.16%, sys=0.49%, ctx=8153, majf=0, minf=21
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.2%, 32=109.2%, 
>=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
>=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.1%, 64=0.0%, 
>=64=0.0%
     issued    : total=r=0/w=7694/d=0, short=r=0/w=0/d=0
queryA: (groupid=0, jobs=1): err= 0: pid=10554: Wed May 22 13:10:21 2013
  read : io=1940.0KB, bw=32964 B/s, iops=8 , runt= 60263msec
    clat (msec): min=5 , max=634 , avg=124.24, stdev=125.99
     lat (msec): min=5 , max=634 , avg=124.24, stdev=125.99
    bw (KB/s)  : min=    0, max=   87, per=14.16%, avg=32.14, stdev=17.10
    lat (msec) : 10=1.24%, 20=25.77%, 50=18.35%, 100=11.34%, 250=25.98%
    lat (msec) : 500=15.88%, 750=1.44%
  cpu          : usr=0.01%, sys=0.03%, ctx=516, majf=515, minf=26
  IO depths    : 1=106.2%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, 
>=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
>=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
>=64=0.0%
     issued    : total=r=485/w=0/d=0, short=r=0/w=0/d=0
queryB: (groupid=0, jobs=1): err= 0: pid=10555: Wed May 22 13:10:21 2013
  read : io=1960.0KB, bw=33385 B/s, iops=8 , runt= 60118msec
    clat (msec): min=5 , max=741 , avg=122.67, stdev=129.91
     lat (msec): min=5 , max=741 , avg=122.68, stdev=129.91
    bw (KB/s)  : min=    0, max=  110, per=14.24%, avg=32.33, stdev=17.89
    lat (msec) : 10=2.65%, 20=27.14%, 50=18.98%, 100=10.61%, 250=23.47%
    lat (msec) : 500=16.53%, 750=0.61%
  cpu          : usr=0.01%, sys=0.03%, ctx=528, majf=527, minf=26
  IO depths    : 1=107.6%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, 
>=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
>=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
>=64=0.0%
     issued    : total=r=490/w=0/d=0, short=r=0/w=0/d=0
bgupdater: (groupid=0, jobs=1): err= 0: pid=10556: Wed May 22 13:10:21 
2013
  read : io=9816.0KB, bw=166505 B/s, iops=40 , runt= 60368msec
    slat (usec): min=5 , max=217275 , avg=166.39, stdev=4660.87
    clat (usec): min=214 , max=684589 , avg=167396.86, stdev=117164.35
     lat (msec): min=2 , max=684 , avg=167.58, stdev=117.11
    bw (KB/s)  : min=    0, max=  344, per=72.87%, avg=165.41, stdev=64.85
  write: io=10200KB, bw=173018 B/s, iops=42 , runt= 60368msec
    slat (usec): min=9 , max=369054 , avg=629.51, stdev=11351.66
    clat (msec): min=5 , max=1273 , avg=217.41, stdev=168.08
     lat (msec): min=5 , max=1273 , avg=218.05, stdev=168.80
    bw (KB/s)  : min=   39, max=  515, per=25.10%, avg=170.70, stdev=71.17
    lat (usec) : 250=0.02%
    lat (msec) : 4=0.02%, 10=1.16%, 20=5.75%, 50=11.89%, 100=12.83%
    lat (msec) : 250=36.90%, 500=28.42%, 750=2.57%, 1000=0.66%, 2000=0.08%
  cpu          : usr=0.18%, sys=0.26%, ctx=5309, majf=0, minf=21
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.2%, 16=110.0%, 32=0.0%, 
>=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
>=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.1%, 32=0.0%, 64=0.0%, 
>=64=0.0%
     issued    : total=r=2449/w=2540/d=0, short=r=0/w=0/d=0

Run status group 0 (all jobs):
   READ: io=13716KB, aggrb=227KB/s, minb=32KB/s, maxb=162KB/s, 
mint=60118msec, maxt=60368msec
  WRITE: io=41100KB, aggrb=680KB/s, minb=168KB/s, maxb=513KB/s, 
mint=60230msec, maxt=60368msec

Disk stats (read/write):
    dm-1: ios=3772/13937, merge=0/0, ticks=567832/3199902, 
in_queue=3780615, util=99.96%, aggrios=3773/13956, aggrmerge=0/0, 
aggrticks=571088/3212158, aggrin_queue=3783247, aggrutil=99.94%
    dm-0: ios=3773/13956, merge=0/0, ticks=571088/3212158, 
in_queue=3783247, util=99.94%, aggrios=3766/11395, aggrmerge=7/2561, 
aggrticks=569634/2696054, aggrin_queue=3265686, aggrutil=99.94%
  sda: ios=3766/11395, merge=7/2561, ticks=569634/2696054, 
in_queue=3265686, util=99.94%
Unless stated otherwise above:
IBM United Kingdom Limited - Registered in England and Wales with number 
741598. 
Registered office: PO Box 41, North Harbour, Portsmouth, Hampshire PO6 3AU


