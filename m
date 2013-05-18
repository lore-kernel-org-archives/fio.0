Return-Path: <ecomar@uk.ibm.com>
In-Reply-To: <OFEF259463.FACECBD6-ON80257B6F.003C54FB-80257B6F.003CA237@LocalDomain>
References: <OFB8065112.FF17BF54-ON80257B6F.00062897-80257B6F.000821C0@uk.ibm.com> <20130518065341.GJ19781@kernel.dk> <20130518070110.GK19781@kernel.dk> <OFCAFB895A.56FC581E-ON80257B6F.003AA486-80257B6F.003BB600@uk.ibm.com> <OFEF259463.FACECBD6-ON80257B6F.003C54FB-80257B6F.003CA237@LocalDomain>
MIME-Version: 1.0
Subject: Re: output - aggregate read bandwitdh
From: Edoardo Comar <ECOMAR@uk.ibm.com>
Message-ID: <OF1E75BC9A.821D96E0-ON80257B6F.003CB4BE-80257B6F.003E2AAA@uk.ibm.com>
Date: Sat, 18 May 2013 12:18:51 +0100
Content-Type: text/plain; charset="US-ASCII"
To: Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

In any case, even excluding the alleged bug, the difference in aggrb 
between the runs is very significant.

fio-2.1-8-gb2c77 - run laying out the files (where I think we have a bug)
Run status group 0 (all jobs):
   READ: io=31740MB, aggrb=541365KB/s, minb=18KB/s, maxb=298351KB/s, 
mint=60001msec, maxt=60036msec
  WRITE: io=42116KB, aggrb=701KB/s, minb=15KB/s, maxb=685KB/s, 
mint=60036msec, maxt=60054msec

fio-2.0.13 - run reusing the files
Run status group 0 (all jobs):
   READ: io=12856KB, aggrb=213KB/s, minb=37KB/s, maxb=135KB/s, 
mint=60242msec, maxt=60304msec
  WRITE: io=30048KB, aggrb=498KB/s, minb=134KB/s, maxb=363KB/s, 
mint=60262msec, maxt=60304msec

===========

fio-2.0.13 - run laying out the files
Run status group 0 (all jobs):
   READ: io=11080KB, aggrb=183KB/s, minb=31KB/s, maxb=113KB/s, 
mint=60129msec, maxt=60326msec
  WRITE: io=23756KB, aggrb=393KB/s, minb=115KB/s, maxb=278KB/s, 
mint=60294msec, maxt=60326msec

fio-2.1-8-gb2c77 - run reusing the files
Run status group 0 (all jobs):
   READ: io=8564KB, aggrb=141KB/s, minb=10KB/s, maxb=65KB/s, 
mint=60249msec, maxt=60359msec
  WRITE: io=28632KB, aggrb=474KB/s, minb=9KB/s, maxb=464KB/s, 
mint=60249msec, maxt=60378msec

===========

if I run again reusing the existing files I get quite consistent results 
(within 5% which is ok over just a minute, IMHO) 
with the previous run of the same fio version that also reused the files.
but the two versions report figures that are significantly different, the 
new fio is consistently slower.

fio-2.0.13 - run reusing the files again
Run status group 0 (all jobs):
   READ: io=12844KB, aggrb=212KB/s, minb=31KB/s, maxb=143KB/s, 
mint=60148msec, maxt=60316msec
  WRITE: io=30380KB, aggrb=503KB/s, minb=138KB/s, maxb=365KB/s, 
mint=60163msec, maxt=60316msec

fio-2.1-8-gb2c77 - run reusing the files again
Run status group 0 (all jobs):
   READ: io=8308KB, aggrb=137KB/s, minb=10KB/s, maxb=63KB/s, 
mint=60010msec, maxt=60207msec
  WRITE: io=27672KB, aggrb=459KB/s, minb=8KB/s, maxb=450KB/s, 
mint=60162msec, maxt=60268msec


fio-2.0.13 - run reusing the files again
Run status group 0 (all jobs):
   READ: io=11976KB, aggrb=198KB/s, minb=31KB/s, maxb=129KB/s, 
mint=60332msec, maxt=60442msec
  WRITE: io=29012KB, aggrb=479KB/s, minb=127KB/s, maxb=351KB/s, 
mint=60442msec, maxt=60484msec

fio-2.1-8-gb2c77 - run reusing the files again
Run status group 0 (all jobs):
   READ: io=8496KB, aggrb=141KB/s, minb=10KB/s, maxb=66KB/s, 
mint=60005msec, maxt=60029msec
  WRITE: io=27320KB, aggrb=454KB/s, minb=8KB/s, maxb=445KB/s, 
mint=60005msec, maxt=60112msec

... which should I trust ?

--------------------------------------------------
regards,
Edoardo Comar
WebSphere Application Service Platform for Networks (ASPN)
ecomar@uk.ibm.com
+44 (0)1962 81 5576 
IBM UK Ltd, Hursley Park, SO21 2JN




From:   Edoardo Comar/UK/IBM
To:     Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org, 
Date:   18/05/2013 12:02
Subject:        Re: output - aggregate read bandwitdh


Hi Jens,

if you perform the steps in reverse, i.e.

remove the output files,
run the old fio (thus have the file generated) 
the run the freshly built fio (thus reusing the output files)

the problem does not show
so to me it looks like the accounting lost the plot by having created the 
files ?

HTH

===================================================
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

bgwriter: (groupid=0, jobs=1): err= 0: pid=15702: Sat May 18 11:55:16 2013
  write: io=16808KB, bw=285457 B/s, iops=69 , runt= 60294msec
    slat (usec): min=11 , max=888637 , avg=517.21, stdev=19705.69
    clat (msec): min=4 , max=2736 , avg=460.42, stdev=366.02
     lat (msec): min=4 , max=2736 , avg=460.99, stdev=366.53
    bw (KB/s)  : min=    0, max=  870, per=73.62%, avg=289.33, 
stdev=156.06
    lat (msec) : 10=1.46%, 20=4.51%, 50=7.62%, 100=5.20%, 250=7.55%
    lat (msec) : 500=38.29%, 750=18.39%, 1000=7.86%, 2000=9.69%, 
>=2000=0.17%
  cpu          : usr=0.11%, sys=0.21%, ctx=3726, majf=0, minf=22
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.2%, 16=0.4%, 32=110.4%, 
>=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
>=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.1%, 64=0.0%, 
>=64=0.0%
     issued    : total=r=0/w=4171/d=0, short=r=0/w=0/d=0
queryA: (groupid=0, jobs=1): err= 0: pid=15703: Sat May 18 11:55:16 2013
  read : io=1924.0KB, bw=32765 B/s, iops=7 , runt= 60129msec
    clat (msec): min=1 , max=833 , avg=124.99, stdev=159.31
     lat (msec): min=1 , max=833 , avg=125.00, stdev=159.31
    bw (KB/s)  : min=    0, max=   91, per=18.01%, avg=32.96, stdev=17.98
    lat (msec) : 2=0.21%, 10=1.25%, 20=32.43%, 50=21.21%, 100=11.23%
    lat (msec) : 250=12.89%, 500=17.46%, 750=2.91%, 1000=0.42%
  cpu          : usr=0.02%, sys=0.03%, ctx=520, majf=519, minf=27
  IO depths    : 1=107.9%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, 
>=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
>=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
>=64=0.0%
     issued    : total=r=481/w=0/d=0, short=r=0/w=0/d=0
queryB: (groupid=0, jobs=1): err= 0: pid=15704: Sat May 18 11:55:16 2013
  read : io=2304.0KB, bw=39234 B/s, iops=9 , runt= 60133msec
    clat (msec): min=3 , max=796 , avg=104.38, stdev=143.78
     lat (msec): min=3 , max=796 , avg=104.38, stdev=143.78
    bw (KB/s)  : min=    0, max=  103, per=21.36%, avg=39.10, stdev=19.61
    lat (msec) : 4=0.17%, 10=5.21%, 20=32.81%, 50=25.00%, 100=8.33%
    lat (msec) : 250=10.42%, 500=15.80%, 750=2.08%, 1000=0.17%
  cpu          : usr=0.02%, sys=0.03%, ctx=630, majf=629, minf=27
  IO depths    : 1=109.2%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, 
>=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
>=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
>=64=0.0%
     issued    : total=r=576/w=0/d=0, short=r=0/w=0/d=0
bgupdater: (groupid=0, jobs=1): err= 0: pid=15705: Sat May 18 11:55:16 
2013
  read : io=6852.0KB, bw=116308 B/s, iops=28 , runt= 60326msec
    slat (usec): min=5 , max=529234 , avg=1241.91, stdev=18167.48
    clat (usec): min=5 , max=1280.3K, avg=237605.15, stdev=206635.27
     lat (msec): min=2 , max=1280 , avg=238.99, stdev=206.02
    bw (KB/s)  : min=    0, max=  396, per=64.92%, avg=118.80, stdev=67.68
  write: io=6948.0KB, bw=117938 B/s, iops=28 , runt= 60326msec
    slat (usec): min=8 , max=825689 , avg=2209.25, stdev=27458.48
    clat (msec): min=5 , max=1578 , avg=319.33, stdev=261.16
     lat (msec): min=5 , max=1578 , avg=321.77, stdev=264.30
    bw (KB/s)  : min=   15, max=  261, per=30.40%, avg=119.48, stdev=54.96
    lat (usec) : 10=0.03%, 50=0.03%, 100=0.06%, 250=0.17%, 500=0.06%
    lat (msec) : 4=0.15%, 10=1.83%, 20=6.64%, 50=9.34%, 100=10.25%
    lat (msec) : 250=20.79%, 500=36.36%, 750=10.89%, 1000=1.80%, 
2000=2.04%
  cpu          : usr=0.12%, sys=0.17%, ctx=3311, majf=0, minf=22
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.2%, 16=111.1%, 32=0.0%, 
>=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
>=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.1%, 32=0.0%, 64=0.0%, 
>=64=0.0%
     issued    : total=r=1712/w=1723/d=0, short=r=0/w=0/d=0

Run status group 0 (all jobs):
   READ: io=11080KB, aggrb=183KB/s, minb=31KB/s, maxb=113KB/s, 
mint=60129msec, maxt=60326msec
  WRITE: io=23756KB, aggrb=393KB/s, minb=115KB/s, maxb=278KB/s, 
mint=60294msec, maxt=60326msec

Disk stats (read/write):
    dm-1: ios=3253/10771, merge=0/0, ticks=559883/4212209, 
in_queue=4777400, util=99.97%, aggrios=3255/10882, aggrmerge=0/0, 
aggrticks=559956/4221317, aggrin_queue=4781292, aggrutil=99.97%
    dm-0: ios=3255/10882, merge=0/0, ticks=559956/4221317, 
in_queue=4781292, util=99.97%, aggrios=3249/7719, aggrmerge=6/3162, 
aggrticks=554975/3062598, aggrin_queue=3617588, aggrutil=99.97%
  sda: ios=3249/7719, merge=6/3162, ticks=554975/3062598, 
in_queue=3617588, util=99.97%

================================================================================
bgwriter: (g=0): rw=randwrite, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, 
iodepth=32
queryA: (g=0): rw=randread, bs=4K-4K/4K-4K/4K-4K, ioengine=mmap, iodepth=1
queryB: (g=0): rw=randread, bs=4K-4K/4K-4K/4K-4K, ioengine=mmap, iodepth=1
bgupdater: (g=0): rw=randrw, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, 
iodepth=16
fio-2.1-8-gb2c77
Starting 4 processes

bgwriter: (groupid=0, jobs=1): err= 0: pid=20441: Sat May 18 11:56:50 2013
  write: io=28068KB, bw=476028B/s, iops=115, runt= 60378msec
    slat (usec): min=9, max=947265, avg=402.78, stdev=14178.87
    clat (msec): min=3, max=1635, avg=276.89, stdev=209.31
     lat (msec): min=3, max=1635, avg=277.33, stdev=210.07
    bw (KB  /s): min=    0, max= 1019, per=98.32%, avg=466.03, 
stdev=150.91
    lat (msec) : 4=0.01%, 10=1.83%, 20=4.75%, 50=14.50%, 100=11.21%
    lat (msec) : 250=5.22%, 500=52.95%, 750=7.29%, 1000=1.95%, 2000=0.73%
  cpu          : usr=0.19%, sys=0.40%, ctx=7319, majf=0, minf=21
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.2%, 32=109.5%, 
>=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
>=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.1%, 64=0.0%, 
>=64=0.0%
     issued    : total=r=0/w=6986/d=0, short=r=0/w=0/d=0
queryA: (groupid=0, jobs=1): err= 0: pid=20442: Sat May 18 11:56:50 2013
  read : io=3940.0KB, bw=66862B/s, iops=16, runt= 60341msec
    clat (msec): min=6, max=762, avg=61.25, stdev=101.94
     lat (msec): min=6, max=762, avg=61.25, stdev=101.94
    bw (KB  /s): min=    0, max=  133, per=45.87%, avg=64.67, stdev=23.10
    lat (msec) : 10=2.44%, 20=55.43%, 50=24.77%, 100=1.22%, 250=3.65%
    lat (msec) : 500=12.18%, 750=0.20%, 1000=0.10%
  cpu          : usr=0.03%, sys=0.06%, ctx=1076, majf=1075, minf=542
  IO depths    : 1=161.3%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, 
>=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
>=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
>=64=0.0%
     issued    : total=r=985/w=0/d=0, short=r=0/w=0/d=0
queryB: (groupid=0, jobs=1): err= 0: pid=20443: Sat May 18 11:56:50 2013
  read : io=3968.0KB, bw=67317B/s, iops=16, runt= 60359msec
    clat (msec): min=4, max=781, avg=60.83, stdev=102.14
     lat (msec): min=4, max=781, avg=60.83, stdev=102.14
    bw (KB  /s): min=    0, max=  143, per=46.11%, avg=65.02, stdev=23.70
    lat (msec) : 10=3.83%, 20=55.04%, 50=23.59%, 100=1.31%, 250=3.23%
    lat (msec) : 500=12.80%, 750=0.10%, 1000=0.10%
  cpu          : usr=0.05%, sys=0.05%, ctx=1084, majf=1081, minf=654
  IO depths    : 1=172.1%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, 
>=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
>=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
>=64=0.0%
     issued    : total=r=992/w=0/d=0, short=r=0/w=0/d=0
bgupdater: (groupid=0, jobs=1): err= 0: pid=20444: Sat May 18 11:56:50 
2013
  read : io=671744B, bw=11149B/s, iops=2, runt= 60249msec
    slat (usec): min=11, max=2602, avg=66.32, stdev=294.44
    clat (msec): min=5, max=759, avg=123.67, stdev=127.15
     lat (msec): min=5, max=759, avg=123.74, stdev=127.24
    bw (KB  /s): min=    3, max=   54, per=9.89%, avg=13.94, stdev=10.61
  write: io=577536B, bw=9585B/s, iops=2, runt= 60249msec
    slat (usec): min=9, max=774595, avg=7006.26, stdev=62617.17
    clat (msec): min=32, max=837, avg=275.34, stdev=170.22
     lat (msec): min=33, max=900, avg=283.34, stdev=179.59
    bw (KB  /s): min=    0, max=   16, per=1.93%, avg= 9.13, stdev= 3.62
    lat (msec) : 10=2.30%, 20=17.05%, 50=8.52%, 100=6.23%, 250=34.10%
    lat (msec) : 500=27.87%, 750=2.95%, 1000=0.98%
  cpu          : usr=0.01%, sys=0.02%, ctx=373, majf=0, minf=21
  IO depths    : 1=109.8%, 2=0.7%, 4=1.3%, 8=2.6%, 16=0.3%, 32=0.0%, 
>=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
>=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
>=64=0.0%
     issued    : total=r=164/w=141/d=0, short=r=0/w=0/d=0

Run status group 0 (all jobs):
   READ: io=8564KB, aggrb=141KB/s, minb=10KB/s, maxb=65KB/s, 
mint=60249msec, maxt=60359msec
  WRITE: io=28632KB, aggrb=474KB/s, minb=9KB/s, maxb=464KB/s, 
mint=60249msec, maxt=60378msec

Disk stats (read/write):
    dm-1: ios=2345/12102, merge=0/0, ticks=153582/7496914, 
in_queue=7659457, util=99.97%, aggrios=2345/12119, aggrmerge=0/0, 
aggrticks=154444/7512052, aggrin_queue=7666496, aggrutil=99.95%
    dm-0: ios=2345/12119, merge=0/0, ticks=154444/7512052, 
in_queue=7666496, util=99.95%, aggrios=2345/8178, aggrmerge=0/3941, 
aggrticks=153937/2410287, aggrin_queue=2564220, aggrutil=99.95%
  sda: ios=2345/8178, merge=0/3941, ticks=153937/2410287, 
in_queue=2564220, util=99.95%
--------------------------------------------------
regards,
Edoardo Comar
WebSphere Application Service Platform for Networks (ASPN)
ecomar@uk.ibm.com
+44 (0)1962 81 5576 
IBM UK Ltd, Hursley Park, SO21 2JN


Unless stated otherwise above:
IBM United Kingdom Limited - Registered in England and Wales with number 
741598. 
Registered office: PO Box 41, North Harbour, Portsmouth, Hampshire PO6 3AU


Unless stated otherwise above:
IBM United Kingdom Limited - Registered in England and Wales with number 
741598. 
Registered office: PO Box 41, North Harbour, Portsmouth, Hampshire PO6 3AU


