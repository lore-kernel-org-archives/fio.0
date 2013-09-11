Return-Path: <fio-owner@vger.kernel.org>
Received: from legacy.ddn.com ([64.47.133.206]:47012 "EHLO legacy.ddn.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754039Ab3IKU4P convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Wed, 11 Sep 2013 16:56:15 -0400
From: Keith Pine <kpine@ddn.com>
Subject: data verification error with ioengine=libaio
Date: Wed, 11 Sep 2013 20:56:10 +0000
Message-ID: <F391FB4F21BEC943926789308B8035907DD18D1B@LAX-EX-MB3.datadirect.datadirectnet.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

I'm consistently hitting a data verification error for random reads when using the libaio ioengine. Am I hitting a bug in fio or in the linux storage stack (aio/block/scsi)? Maybe an underlying hardware issue (SAS backplane)? Any recommendations on digging further into this issue? It seems to only occur with random reads of smaller block sizes (~4k). I have not seen the problem with sequential reads, and running the same test with 512b and 64kb blocks did not produce the verification error. Similarly, using the sg ioengine instead passed all tests, however I could not achieve as high iops as aio (segfaults and crashes when iodepth > 2). High iops could be a contributor to the problem.

There are no problems with the drive; SMART data is clean and as I mentioned sequential reads are ok and random reads with sg passed. I'm going to try lowering the iodepth value (to something like 4), but that will certainly hurt iops for random reads.

Any input is appreciated.

Here's my jobfile (similar to the suface-scan.fio example):

[global]
filename=/dev/sdf
direct=1
size=10g
ba=512
verify=meta
verify_pattern=0xdeadbeef
verify_interval=512
verify_fatal=1
ioengine=libaio
iodepth=64
iodepth_batch_complete=0

[write-phase]
bs=1M
rw=write
do_verify=0

[seq-verify-phase]
stonewall
create_serialize=0
bs=4k
rw=read
do_verify=1

[rand-read]
stonewall
create_serialize=0
bs=4k
rw=randread
do_verify=1

And here's the program output:

write-phase: (g=0): rw=write, bs=1M-1M/1M-1M/1M-1M, ioengine=libaio, iodepth=64
seq-verify-phase: (g=1): rw=read, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, iodepth=64
fio: Any use of blockalign= turns off randommap
rand-read: (g=2): rw=randread, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, iodepth=64
fio-2.1.2-21-gf7133
Starting 3 processes
verify: bad magic header 61b3, wanted acca at file /dev/sdf offset 14562280616, length 1773542936
fio: pid=22326, err=84/file:io_u.c:1613, func=io_u_queued_complete, error=Invalid or incomplete multibyte or wide character

write-phase: (groupid=0, jobs=1): err= 0: pid=22288: Wed Sep 11 11:44:30 2013
  write: io=10240MB, bw=158194KB/s, iops=154, runt= 66284msec
    slat (usec): min=31, max=115, avg=82.11, stdev= 8.04
    clat (msec): min=47, max=845, avg=414.02, stdev=27.16
     lat (msec): min=47, max=845, avg=414.10, stdev=27.16
    clat percentiles (msec):
     |  1.00th=[  396],  5.00th=[  396], 10.00th=[  396], 20.00th=[  404],
     | 30.00th=[  408], 40.00th=[  412], 50.00th=[  416], 60.00th=[  420],
     | 70.00th=[  420], 80.00th=[  420], 90.00th=[  424], 95.00th=[  429],
     | 99.00th=[  429], 99.50th=[  529], 99.90th=[  783], 99.95th=[  816],
     | 99.99th=[  840]
    bw (KB  /s): min=72868, max=165556, per=99.73%, avg=157766.60, stdev=8348.98
    lat (msec) : 50=0.01%, 100=0.05%, 250=0.23%, 500=99.16%, 750=0.39%
    lat (msec) : 1000=0.16%
  cpu          : usr=24.48%, sys=75.37%, ctx=6700, majf=0, minf=28
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.2%, 32=0.3%, >=64=99.4%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.6%, 4=99.4%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.1%, >=64=0.0%
     issued    : total=r=0/w=10240/d=0, short=r=0/w=0/d=0
seq-verify-phase: (groupid=1, jobs=1): err= 0: pid=22297: Wed Sep 11 11:44:30 2013
  read : io=10240MB, bw=52693KB/s, iops=13173, runt=198997msec
    slat (usec): min=2, max=34, avg= 3.45, stdev= 0.63
    clat (usec): min=4004, max=10817, avg=4850.99, stdev=213.17
     lat (usec): min=4008, max=10828, avg=4854.55, stdev=213.16
    clat percentiles (usec):
     |  1.00th=[ 4448],  5.00th=[ 4512], 10.00th=[ 4576], 20.00th=[ 4704],
     | 30.00th=[ 4768], 40.00th=[ 4768], 50.00th=[ 4832], 60.00th=[ 4896],
     | 70.00th=[ 4960], 80.00th=[ 5024], 90.00th=[ 5152], 95.00th=[ 5216],
     | 99.00th=[ 5344], 99.50th=[ 5408], 99.90th=[ 5472], 99.95th=[ 5472],
     | 99.99th=[ 5536]
    bw (KB  /s): min=52064, max=53600, per=100.00%, avg=52697.87, stdev=230.19
    lat (msec) : 10=100.00%, 20=0.01%
  cpu          : usr=27.17%, sys=72.69%, ctx=20115, majf=0, minf=83
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=0.1%, >=64=100.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.1%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.1%, >=64=0.0%
     issued    : total=r=2621440/w=0/d=0, short=r=0/w=0/d=0
rand-read: (groupid=2, jobs=1): err=84 (file:io_u.c:1613, func=io_u_queued_complete, error=Invalid or incomplete multibyte or wide character): pid=22326: Wed Sep 11 11:44:30 2013
  read : io=8633.5MB, bw=1595.1KB/s, iops=398, runt=5539409msec
    slat (usec): min=2, max=41, avg= 4.20, stdev= 0.97
    clat (msec): min=5, max=2220, avg=160.40, stdev=90.77
     lat (msec): min=5, max=2220, avg=160.40, stdev=90.77
    clat percentiles (msec):
     |  1.00th=[   81],  5.00th=[   86], 10.00th=[   90], 20.00th=[   97],
     | 30.00th=[  105], 40.00th=[  116], 50.00th=[  129], 60.00th=[  147],
     | 70.00th=[  172], 80.00th=[  208], 90.00th=[  273], 95.00th=[  338],
     | 99.00th=[  510], 99.50th=[  586], 99.90th=[  775], 99.95th=[  857],
     | 99.99th=[ 1057]
    bw (KB  /s): min=  922, max= 1764, per=100.00%, avg=1597.01, stdev=55.23
    lat (msec) : 10=0.01%, 20=0.01%, 50=0.01%, 100=24.34%, 250=63.06%
    lat (msec) : 500=11.51%, 750=0.97%, 1000=0.11%, 2000=0.02%, >=2000=0.01%
  cpu          : usr=24.33%, sys=75.53%, ctx=559965, majf=0, minf=114
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=0.1%, >=64=100.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.1%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.1%, >=64=0.0%
     issued    : total=r=2210157/w=0/d=0, short=r=0/w=0/d=0

Run status group 0 (all jobs):
  WRITE: io=10240MB, aggrb=158194KB/s, minb=158194KB/s, maxb=158194KB/s, mint=66284msec, maxt=66284msec

Run status group 1 (all jobs):
   READ: io=10240MB, aggrb=52693KB/s, minb=52693KB/s, maxb=52693KB/s, mint=198997msec, maxt=198997msec

Run status group 2 (all jobs):
   READ: io=8633.5MB, aggrb=1595KB/s, minb=1595KB/s, maxb=1595KB/s, mint=5539409msec, maxt=5539409msec

Disk stats (read/write):
  sdf: ios=4831582/10240, merge=0/10240, ticks=367243127/4226709, in_queue=371473715, util=100.00%


Here's the same test using ioengine=sg.

Job file:

[global]
filename=/dev/sg6        
size=10g 
verify=meta
verify_pattern=0xdeadbeef
verify_interval=512
verify_fatal=1
ioengine=sg
iodepth=2
iodepth_batch_complete=0
                         
[write-phase] 
bs=1M 
rw=write 
do_verify=0 
                         
[seq-verify-phase] 
stonewall 
create_serialize=0 
bs=4k 
rw=read 
do_verify=1 
                         
[rand-read] 
stonewall 
create_serialize=0 
bs=4k 
rw=randread 
do_verify=1 

Fio output:

write-phase: (g=0): rw=write, bs=1M-1M/1M-1M/1M-1M, ioengine=sg, iodepth=2
seq-verify-phase: (g=1): rw=read, bs=4K-4K/4K-4K/4K-4K, ioengine=sg, iodepth=2
rand-read: (g=2): rw=randread, bs=4K-4K/4K-4K/4K-4K, ioengine=sg, iodepth=2
fio-2.1.2-21-gf7133
Starting 3 processes
Jobs: 1 (f=1): [__V] [100.0% done] [5824KB/0KB/0KB /s] [1456/0/0 iops] [eta 00m:01s]
write-phase: (groupid=0, jobs=1): err= 0: pid=14522: Wed Sep 11 01:56:39 2013
  write: io=10240MB, bw=158374KB/s, iops=154, runt= 66209msec
    slat (usec): min=0, max=34, avg= 0.75, stdev= 0.82
    clat (msec): min=11, max=69, avg=12.72, stdev= 1.28
     lat (msec): min=11, max=69, avg=12.72, stdev= 1.28
    clat percentiles (usec):
     |  1.00th=[11840],  5.00th=[11840], 10.00th=[11840], 20.00th=[12096],
     | 30.00th=[12096], 40.00th=[12480], 50.00th=[12608], 60.00th=[12608],
     | 70.00th=[12864], 80.00th=[13120], 90.00th=[13376], 95.00th=[13376],
     | 99.00th=[20608], 99.50th=[21376], 99.90th=[21632], 99.95th=[21632],
     | 99.99th=[46848]
    bw (KB  /s): min=136126, max=165556, per=100.00%, avg=158540.06, stdev=3881.00
    lat (msec) : 20=98.70%, 50=1.29%, 100=0.01%
  cpu          : usr=3.34%, sys=4.29%, ctx=14438, majf=0, minf=28
  IO depths    : 1=0.1%, 2=100.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.1%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued    : total=r=0/w=10240/d=0, short=r=0/w=0/d=0
seq-verify-phase: (groupid=1, jobs=1): err= 0: pid=14530: Wed Sep 11 01:56:39 2013
  read : io=10240MB, bw=46730KB/s, iops=11682, runt=224389msec
    slat (usec): min=0, max=22, avg= 0.21, stdev= 0.43
    clat (usec): min=111, max=9616, avg=160.47, stdev=28.63
     lat (usec): min=111, max=9616, avg=160.68, stdev=28.63
    clat percentiles (usec):
     |  1.00th=[  123],  5.00th=[  131], 10.00th=[  131], 20.00th=[  139],
     | 30.00th=[  157], 40.00th=[  159], 50.00th=[  159], 60.00th=[  161],
     | 70.00th=[  165], 80.00th=[  175], 90.00th=[  181], 95.00th=[  195],
     | 99.00th=[  278], 99.50th=[  334], 99.90th=[  378], 99.95th=[  386],
     | 99.99th=[  426]
    bw (KB  /s): min=45560, max=47360, per=100.00%, avg=46734.54, stdev=271.85
    lat (usec) : 250=98.40%, 500=1.60%, 750=0.01%, 1000=0.01%
    lat (msec) : 2=0.01%, 10=0.01%
  cpu          : usr=16.10%, sys=17.18%, ctx=2639195, majf=0, minf=28
  IO depths    : 1=0.1%, 2=100.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.1%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued    : total=r=2621440/w=0/d=0, short=r=0/w=0/d=0
rand-read: (groupid=2, jobs=1): err= 0: pid=14617: Wed Sep 11 01:56:39 2013
  read : io=10240MB, bw=782641B/s, iops=191, runt=13719455msec
    slat (usec): min=0, max=456, avg= 0.36, stdev= 0.67
    clat (usec): min=151, max=155751, avg=10453.37, stdev=8661.75
     lat (usec): min=151, max=155752, avg=10453.73, stdev=8661.75
    clat percentiles (usec):
     |  1.00th=[  195],  5.00th=[ 2672], 10.00th=[ 3216], 20.00th=[ 4256],
     | 30.00th=[ 5472], 40.00th=[ 6688], 50.00th=[ 7840], 60.00th=[ 9024],
     | 70.00th=[10560], 80.00th=[15808], 90.00th=[21632], 95.00th=[27264],
     | 99.00th=[43264], 99.50th=[49920], 99.90th=[64256], 99.95th=[69120],
     | 99.99th=[84480]
    bw (KB  /s): min=  608, max= 6816, per=100.00%, avg=764.59, stdev=108.66
    lat (usec) : 250=1.75%, 500=0.11%, 750=0.01%, 1000=0.01%
    lat (msec) : 2=0.41%, 4=15.29%, 10=49.53%, 20=21.91%, 50=10.50%
    lat (msec) : 100=0.49%, 250=0.01%
  cpu          : usr=0.39%, sys=0.41%, ctx=2681382, majf=0, minf=27
  IO depths    : 1=0.1%, 2=100.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.1%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued    : total=r=2621440/w=0/d=0, short=r=0/w=0/d=0

Run status group 0 (all jobs):
  WRITE: io=10240MB, aggrb=158373KB/s, minb=158373KB/s, maxb=158373KB/s, mint=66209msec, maxt=66209msec

Run status group 1 (all jobs):
   READ: io=10240MB, aggrb=46730KB/s, minb=46730KB/s, maxb=46730KB/s, mint=224389msec, maxt=224389msec

Run status group 2 (all jobs):
   READ: io=10240MB, aggrb=764KB/s, minb=764KB/s, maxb=764KB/s, mint=13719455msec, maxt=13719455msec
