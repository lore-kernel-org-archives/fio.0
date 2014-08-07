Return-Path: <fio-owner@vger.kernel.org>
Received: from exprod7og102.obsmtp.com ([64.18.2.157]:38260 "EHLO
	exprod7og102.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932537AbaHGRIB (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 7 Aug 2014 13:08:01 -0400
Received: by mail-lb0-f182.google.com with SMTP id z11so2892243lbi.41
        for <fio@vger.kernel.org>; Thu, 07 Aug 2014 10:08:00 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 7 Aug 2014 10:08:00 -0700
Message-ID: <CAPY19uW8EV58gvZ2184DcuJ8gnSG-iTcbbqgWFOLYaHuicwPDA@mail.gmail.com>
Subject: FIO Disk Stats - 0% Utilization
From: Karen Higgins <karen.higgins@sanmina.com>
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

I am loading a Ramdisk driver in various block driver modes (RQ, BIO,
and Multi-Queue[MQ]) to compare IOPS.

When I load the driver in BIO mode and run fio, the Disk Stats shows a
utilization of 0.0%, which makes me wonder if the disk is being
accessed.  On the other hand, when I load the driver in RQ or MQ mode,
the Disk Stats show a utilization of 100% (or near 100%).  The IOPS
for BIO mode are greater than the IOPS for MQ mode, which is another
red flag that the BIO mode IOPS may not be accurate.

I am able to successfully perform read/write/verification tests
outside of fio in all block driver modes.

My question is how can I get an accurate IOPS performance measurement
for the driver in BIO mode?  Is there a bug in fio, or am I missing
some parameter?

Also, it seems that IOPS should be higher in general for MQ mode.  Are
there any performance tuning suggestions for MQ?

=======================================================

Driver loaded w/ blk_mode=BIO, ioremap=nocache ... => 0% Disk Utilization

fio --ioengine=libaio --group_reporting --bs=512 --numjobs=24
--cpus_allowed=1-24 --iodepth=64 --rw=read --time_based=1 --runtime=30
--name=test1 --thread --filename=/dev/mydsk0 --direct=1 --buffered=0

Output:
test1: (g=0): rw=read, bs=512-512/512-512/512-512, ioengine=libaio, iodepth=64
...
fio-2.1.10
Starting 24 threads

test1: (groupid=0, jobs=24): err= 0: pid=1987: Wed Aug  6 17:12:33 2014
  read : io=21390MB, bw=730082KB/s, iops=1460.2K, runt= 30001msec
    slat (usec): min=6, max=24026, avg=15.14, stdev=92.35
    clat (usec): min=1, max=39542, avg=1035.74, stdev=804.55
     lat (usec): min=8, max=39689, avg=1051.05, stdev=811.05
    clat percentiles (usec):
     |  1.00th=[  652],  5.00th=[  716], 10.00th=[  764], 20.00th=[  844],
     | 30.00th=[  884], 40.00th=[  924], 50.00th=[  956], 60.00th=[ 1004],
     | 70.00th=[ 1064], 80.00th=[ 1128], 90.00th=[ 1256], 95.00th=[ 1368],
     | 99.00th=[ 1656], 99.50th=[ 1880], 99.90th=[13888], 99.95th=[14016],
     | 99.99th=[20608]
    bw (KB  /s): min=13309, max=37536, per=4.16%, avg=30407.77, stdev=4089.20
    lat (usec) : 2=0.01%, 4=0.01%, 10=0.01%, 20=0.01%, 50=0.01%
    lat (usec) : 100=0.01%, 250=0.01%, 500=0.01%, 750=8.61%, 1000=50.70%
    lat (msec) : 2=40.26%, 4=0.07%, 10=0.02%, 20=0.33%, 50=0.01%
  cpu          : usr=6.97%, sys=88.38%, ctx=10389, majf=0, minf=3944
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=0.1%, >=64=100.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.1%, >=64=0.0%
     issued    : total=r=43806400/w=0/d=0, short=r=0/w=0/d=0
     latency   : target=0, window=0, percentile=100.00%, depth=64

Run status group 0 (all jobs):
   READ: io=21390MB, aggrb=730082KB/s, minb=730082KB/s,
maxb=730082KB/s, mint=30001msec, maxt=30001msec

Disk stats (read/write):
  mydsk0: ios=0/0, merge=0/0, ticks=0/0, in_queue=0, util=0.00%


=================================================================

Driver loaded w/ blk_mode=MQ, ioremap=nocache ...  => 100% Disk Utilization

fio --ioengine=libaio --group_reporting --bs=512 --numjobs=24
--cpus_allowed=1-24 --iodepth=64 --rw=read --time_based=1 --runtime=30
--name=test1 --thread --filename=/dev/mydsk0 --direct=1 --buffered=0

Output:
test1: (g=0): rw=read, bs=512-512/512-512/512-512, ioengine=libaio, iodepth=64
...
fio-2.1.10
Starting 24 threads

test1: (groupid=0, jobs=24): err= 0: pid=2081: Wed Aug  6 17:13:39 2014
  read : io=18317MB, bw=625210KB/s, iops=1250.5K, runt= 30001msec
    slat (usec): min=8, max=41044, avg=17.75, stdev=104.21
    clat (usec): min=1, max=59034, avg=1209.56, stdev=874.32
     lat (usec): min=9, max=59053, avg=1227.45, stdev=881.06
    clat percentiles (usec):
     |  1.00th=[  836],  5.00th=[  924], 10.00th=[  972], 20.00th=[ 1032],
     | 30.00th=[ 1080], 40.00th=[ 1112], 50.00th=[ 1144], 60.00th=[ 1176],
     | 70.00th=[ 1208], 80.00th=[ 1256], 90.00th=[ 1336], 95.00th=[ 1416],
     | 99.00th=[ 1672], 99.50th=[ 1944], 99.90th=[14016], 99.95th=[14144],
     | 99.99th=[19072]
    bw (KB  /s): min=11778, max=33155, per=4.17%, avg=26050.75, stdev=3243.73
    lat (usec) : 2=0.01%, 4=0.01%, 20=0.01%, 50=0.01%, 100=0.01%
    lat (usec) : 250=0.01%, 500=0.01%, 750=0.07%, 1000=14.23%
    lat (msec) : 2=85.22%, 4=0.02%, 10=0.03%, 20=0.42%, 50=0.01%
    lat (msec) : 100=0.01%
  cpu          : usr=6.68%, sys=88.39%, ctx=7847, majf=0, minf=3896
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=0.1%, >=64=100.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.1%, >=64=0.0%
     issued    : total=r=37513871/w=0/d=0, short=r=0/w=0/d=0
     latency   : target=0, window=0, percentile=100.00%, depth=64

Run status group 0 (all jobs):
   READ: io=18317MB, aggrb=625210KB/s, minb=625210KB/s,
maxb=625210KB/s, mint=30001msec, maxt=30001msec

Disk stats (read/write):
  mydsk0: ios=37387530/0, merge=0/0, ticks=477219/0, in_queue=516648,
util=100.00%
CONFIDENTIALITY
This e-mail message and any attachments thereto, is intended only for use by the addressee(s) named herein and may contain legally privileged and/or confidential information. If you are not the intended recipient of this e-mail message, you are hereby notified that any dissemination, distribution or copying of this e-mail message, and any attachments thereto, is strictly prohibited.  If you have received this e-mail message in error, please immediately notify the sender and permanently delete the original and any copies of this email and any prints thereof.
ABSENT AN EXPRESS STATEMENT TO THE CONTRARY HEREINABOVE, THIS E-MAIL IS NOT INTENDED AS A SUBSTITUTE FOR A WRITING.  Notwithstanding the Uniform Electronic Transactions Act or the applicability of any other law of similar substance and effect, absent an express statement to the contrary hereinabove, this e-mail message its contents, and any attachments hereto are not intended to represent an offer or acceptance to enter into a contract and are not otherwise intended to bind the sender, Sanmina Corporation (or any of its subsidiaries), or any other person or entity.

DISCLAIMER:  The individual sending this e-mail is not an employee of Sanmina Corporation or its subsidiaries, but serves as an independent contractor.  Accordingly, the individual sending this e-mail has no authority to legally bind Sanmina or its subsidiaries.  Only employees possessing the requisite level of authority under Sanmina policies have the ability to bind Sanmina.  If you have a question regarding an individual's ability to bind Sanmina, please contact Sanmina's Legal Department at (408) 964-3156.

