Return-Path: <ecomar@uk.ibm.com>
In-Reply-To: <OF4E37C571.40B0273E-ON80257B6F.005B05C5-80257B6F.005DC361@uk.ibm.com>
References: <OFB8065112.FF17BF54-ON80257B6F.00062897-80257B6F.000821C0@uk.ibm.com> <20130518065341.GJ19781@kernel.dk> <20130518070110.GK19781@kernel.dk> <OFCAFB895A.56FC581E-ON80257B6F.003AA486-80257B6F.003BB600@uk.ibm.com> <OFEF259463.FACECBD6-ON80257B6F.003C54FB-80257B6F.003CA237@LocalDomain> <OF1E75BC9A.821D96E0-ON80257B6F.003CB4BE-80257B6F.003E2AAA@uk.ibm.com> <20130518122211.GM19781@kernel.dk> <OF4E37C571.40B0273E-ON80257B6F.005B05C5-80257B6F.005DC361@uk.ibm.com>
MIME-Version: 1.0
Subject: Re: output - aggregate read bandwitdh
From: Edoardo Comar <ECOMAR@uk.ibm.com>
Message-ID: <OFD80C407E.DC45623D-ON80257B6F.007F5485-80257B6F.007FC70E@uk.ibm.com>
Date: Sun, 19 May 2013 00:15:30 +0100
Content-Type: text/plain; charset="US-ASCII"
To: Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

I just tried the code from git on my personal macbook.
I replaced libaio with posixaio in the config file and 
the ultra-high aggrb read is there too (files being created).

is caused by the contribution to the aggregate stats 
of the second of the two query threads [queryB]

edoardos-macbook-pro:devel edoardo$ sudo fio four-threads-randio-016.fio 
fio: this platform does not support process shared mutexes, forcing use of 
threads. Use the 'thread' option to get rid of this warning.
bgwriter: (g=0): rw=randwrite, bs=4K-4K/4K-4K/4K-4K, ioengine=posixaio, 
iodepth=32
fio: this platform does not support process shared mutexes, forcing use of 
threads. Use the 'thread' option to get rid of this warning.
queryA: (g=0): rw=randread, bs=4K-4K/4K-4K/4K-4K, ioengine=mmap, iodepth=1
fio: this platform does not support process shared mutexes, forcing use of 
threads. Use the 'thread' option to get rid of this warning.
queryB: (g=0): rw=randread, bs=4K-4K/4K-4K/4K-4K, ioengine=mmap, iodepth=1
fio: this platform does not support process shared mutexes, forcing use of 
threads. Use the 'thread' option to get rid of this warning.
bgupdater: (g=0): rw=randrw, bs=4K-4K/4K-4K/4K-4K, ioengine=posixaio, 
iodepth=16
fio-2.1-8-gb2c77
Starting 4 threads
bgwriter: Laying out IO file(s) (1 file(s) / 256MB)
queryA: Laying out IO file(s) (1 file(s) / 256MB)
queryB: Laying out IO file(s) (1 file(s) / 256MB)
bgupdater: Laying out IO file(s) (1 file(s) / 64MB)
Jobs: 1 (f=1): [___m] [26.9% done] [170.4MB/342KB/0KB /s] [43.6K/85/0 
iops] [eta 02m:59s] 
bgwriter: (groupid=0, jobs=1): err= 0: pid=4611: Sat May 18 23:38:37 2013
  write: io=9632.0KB, bw=164145B/s, iops=39, runt= 60088msec
    slat (usec): min=0, max=3804, avg= 4.82, stdev=74.40
    clat (msec): min=6, max=1308, avg=376.14, stdev=137.62
     lat (msec): min=6, max=1308, avg=376.15, stdev=137.61
    bw (KB  /s): min=    1, max=  456, per=94.60%, avg=158.93, stdev=47.60
    lat (msec) : 10=0.08%, 50=0.17%, 100=1.38%, 250=9.82%, 500=77.03%
    lat (msec) : 750=10.86%, 1000=0.50%, 2000=0.71%
  cpu          : usr=66.60%, sys=34.47%, ctx=70482, majf=2210, 
minf=4379188
  IO depths    : 1=0.1%, 2=0.1%, 4=0.3%, 8=109.0%, 16=2.0%, 32=0.0%, 
>=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
>=64=0.0%
     complete  : 0=0.0%, 4=99.9%, 8=0.1%, 16=0.1%, 32=0.0%, 64=0.0%, 
>=64=0.0%
     issued    : total=r=0/w=2394/d=0, short=r=0/w=0/d=0
queryA: (groupid=0, jobs=1): err= 0: pid=4867: Sat May 18 23:38:37 2013
  read : io=36340KB, bw=620037B/s, iops=151, runt= 60016msec
    clat (usec): min=6, max=446986, avg=6596.70, stdev=15779.91
     lat (usec): min=6, max=446987, avg=6597.95, stdev=15780.52
    bw (KB  /s): min=    0, max= 1773, per=0.22%, avg=601.57, stdev=232.79
    lat (usec) : 10=64.65%, 20=11.88%, 50=0.57%, 100=0.26%, 250=0.30%
    lat (usec) : 500=0.08%, 750=0.17%, 1000=0.64%
    lat (msec) : 2=0.20%, 4=0.19%, 10=1.66%, 20=1.44%, 50=17.56%
    lat (msec) : 100=0.32%, 250=0.04%, 500=0.06%
  cpu          : usr=66.68%, sys=34.51%, ctx=70432, majf=2210, 
minf=4379191
  IO depths    : 1=109.9%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, 
>=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
>=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
>=64=0.0%
     issued    : total=r=9085/w=0/d=0, short=r=0/w=0/d=0
queryB: (groupid=0, jobs=1): err= 0: pid=5123: Sat May 18 23:38:37 2013
  read : io=16314MB, bw=278418KB/s, iops=69604, runt= 60001msec
    clat (usec): min=0, max=23157, avg= 7.17, stdev=36.81
     lat (usec): min=0, max=23158, avg= 7.77, stdev=37.02
    bw (KB  /s): min=    0, max=313216, per=99.38%, avg=276190.69, 
stdev=34663.74
    lat (usec) : 2=0.01%, 4=0.01%, 10=98.91%, 20=0.65%, 50=0.17%
    lat (usec) : 100=0.13%, 250=0.09%, 500=0.02%, 750=0.01%, 1000=0.01%
    lat (msec) : 2=0.01%, 4=0.01%, 10=0.01%, 20=0.01%, 50=0.01%
  cpu          : usr=66.70%, sys=34.52%, ctx=70426, majf=2209, 
minf=4379192
  IO depths    : 1=109.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, 
>=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
>=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
>=64=0.0%
     issued    : total=r=4176340/w=0/d=0, short=r=0/w=0/d=0
bgupdater: (groupid=0, jobs=1): err= 0: pid=5379: Sat May 18 23:38:37 2013
  read : io=663552B, bw=11015B/s, iops=2, runt= 60240msec
    slat (usec): min=1, max=128, avg= 6.28, stdev=10.86
    clat (usec): min=2, max=628813, avg=193318.38, stdev=145748.34
     lat (usec): min=11, max=628817, avg=193324.99, stdev=145743.69
    bw (KB  /s): min=    2, max=  396, per=0.00%, avg=13.24, stdev=44.04
  write: io=544768B, bw=9043B/s, iops=2, runt= 60240msec
    slat (usec): min=1, max=301, avg=16.59, stdev=41.75
    clat (usec): min=2, max=1131.3K, avg=207503.18, stdev=201150.42
     lat (usec): min=15, max=1131.3K, avg=207521.24, stdev=201134.90
    bw (KB  /s): min=    0, max=  357, per=7.78%, avg=13.06, stdev=43.83
    lat (usec) : 4=14.58%, 10=4.41%, 20=2.71%, 50=2.71%, 100=0.68%
    lat (usec) : 500=0.34%
    lat (msec) : 4=1.36%, 10=4.75%, 20=0.68%, 50=0.34%, 100=2.03%
    lat (msec) : 250=14.92%, 500=48.14%, 750=1.36%, 1000=0.34%, 2000=0.68%
  cpu          : usr=66.44%, sys=34.39%, ctx=70611, majf=2210, 
minf=4379189
  IO depths    : 1=107.8%, 2=0.7%, 4=1.4%, 8=0.3%, 16=0.0%, 32=0.0%, 
>=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
>=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.1%, 16=0.0%, 32=0.0%, 64=0.0%, 
>=64=0.0%
     issued    : total=r=162/w=133/d=0, short=r=0/w=0/d=0

Run status group 0 (all jobs):
   READ: io=16350MB, aggrb=277927KB/s, minb=10KB/s, maxb=278418KB/s, 
mint=60001msec, maxt=60240msec
  WRITE: io=10164KB, aggrb=168KB/s, minb=8KB/s, maxb=160KB/s, 
mint=60088msec, maxt=60240msec
Unless stated otherwise above:
IBM United Kingdom Limited - Registered in England and Wales with number 
741598. 
Registered office: PO Box 41, North Harbour, Portsmouth, Hampshire PO6 3AU


