Return-Path: <bart.vanassche@gmail.com>
MIME-Version: 1.0
Sender: bart.vanassche@gmail.com
Date: Tue, 2 Feb 2010 08:38:16 +0100
Message-ID: <e2e108261002012338j62fd1983x7f4a0122d3fd97a4@mail.gmail.com>
Subject: Writing to /dev/null with fio
From: Bart Van Assche <bvanassche@acm.org>
Content-Type: text/plain; charset=ISO-8859-1
To: Jens Axboe <jens.axboe@oracle.com>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

Hello Jens,

I noticed that writing with fio to /dev/null takes much more time (220
times more for the test below) than with dd. Did I specify the correct
arguments to fio ? If so, is this known behavior of fio ?

$ dd if=/dev/zero of=/dev/null bs=1M count=1024
1024+0 records in
1024+0 records out
1073741824 bytes (1.1 GB) copied, 0.121485 s, 8.8 GB/s

$ fio --bs=1M --size=1G --buffered=1 --rw=write --verify=0
--name=dev-null /dev/null
dev-null: (g=0): rw=write, bs=1M-1M/1M-1M, ioengine=sync, iodepth=1
Starting 1 process
Jobs: 1 (f=1): [W] [100.0% done] [0K/0K /s] [0/0 iops] [eta 00m:00s]
dev-null: (groupid=0, jobs=1): err= 0: pid=15859
  write: io=1,024MB, bw=39,214KB/s, iops=38, runt= 26740msec
    clat (usec): min=547, max=1,708K, avg=25927.47, stdev=124258.62
    bw (KB/s) : min= 1167, max=732000, per=125.95%, avg=49387.11,
stdev=119413.97
  cpu          : usr=0.01%, sys=4.72%, ctx=780, majf=0, minf=138
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued r/w: total=0/1024, short=0/0
     lat (usec): 750=47.95%, 1000=39.26%
     lat (msec): 2=4.10%, 4=0.49%, 10=0.88%, 20=0.10%, 100=0.29%
     lat (msec): 250=3.12%, 500=2.34%, 750=0.68%, 1000=0.49%, 2000=0.29%

Run status group 0 (all jobs):
  WRITE: io=1,024MB, aggrb=39,213KB/s, minb=40,154KB/s,
maxb=40,154KB/s, mint=26740msec, maxt=26740msec

Bart.

