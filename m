Return-Path: <fio-owner@vger.kernel.org>
Received: from adsl-99-17-64-89.dsl.sfldmi.sbcglobal.net ([99.17.64.89]:47551
	"EHLO crunch.scalableinformatics.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S935221Ab0GSPEW (ORCPT
	<rfc822;fio@vger.kernel.org>); Mon, 19 Jul 2010 11:04:22 -0400
Received: from crunch.scalableinformatics.com (localhost [127.0.0.1])
	by crunch.scalableinformatics.com (Postfix) with ESMTP id 829EA84D3DBB
	for <fio@vger.kernel.org>; Mon, 19 Jul 2010 10:57:59 -0400 (EDT)
Received: from [192.168.1.171] (metal.scalableinformatics.com [192.168.1.171])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by crunch.scalableinformatics.com (Postfix) with ESMTPSA id 7186B84D3DBA
	for <fio@vger.kernel.org>; Mon, 19 Jul 2010 10:57:59 -0400 (EDT)
Message-ID: <4C44680B.4050707@scalableinformatics.com>
Date: Mon, 19 Jul 2010 10:58:19 -0400
From: Joe Landman <landman@scalableinformatics.com>
Reply-To: landman@scalableinformatics.com
MIME-Version: 1.0
Subject: An issue with fio performance on an SSD
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Greetings

   We are playing with some SSDs, and as usual, we want to use fio for 
our testing regime.  So we set up a simple streaming write:

[global]
size=16g
iodepth=32
direct=1
blocksize=1m
numjobs=1
nrfiles=1
ioengine=vsync
#iomem=shmhuge
group_reporting
create_serialize=0
create_on_open=1
rw=write

[sw1]
directory=/data/d1


With this test case, fio is getting ~65MB/s writing to this drive.  1M 
blocks, direct IO.

[root@localhost ~]# fio sw2.fio
sw1: (g=0): rw=write, bs=1M-1M/1M-1M, ioengine=vsync, iodepth=32
Starting 1 process
Jobs: 1 (f=1): [W] [99.6% done] [0K/62M /s] [0/61 iops] [eta 00m:01s]
sw1: (groupid=0, jobs=1): err= 0: pid=5528
   write: io=16,353MB, bw=71,870KB/s, iops=70, runt=232998msec
     clat (msec): min=9, max=231, avg=14.22, stdev= 8.98
     bw (KB/s) : min=32188, max=99162, per=100.38%, avg=72139.10, 
stdev=15322.04
   cpu          : usr=0.06%, sys=1.56%, ctx=32769, majf=0, minf=26
   IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=99.8%, 
 >=64=0.0%
      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
 >=64=0.0%
      complete  : 0=0.1%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
 >=64=0.0%
      issued r/w: total=0/16384, short=0/0

      lat (msec): 10=11.57%, 20=83.69%, 50=4.06%, 100=0.20%, 250=0.29%

Run status group 0 (all jobs):
   WRITE: io=16,353MB, aggrb=71,869KB/s, minb=73,594KB/s, 
maxb=73,594KB/s, mint=232998msec, maxt=232998msec

Disk stats (read/write):
   sdc: ios=0/81927, merge=0/0, ticks=0/773830, in_queue=773650, util=99.43%


But when I try the simple dd version ...

[root@localhost ~]# dd if=/dev/zero of=/data/d1/big.file bs=1M count=16k 
oflag=direct
16384+0 records in
16384+0 records out
17179869184 bytes (17 GB) copied, 87.7913 seconds, 196 MB/s

Non-direct IO is faster with the dd, as I suspect it is overlapping 
operations

[root@localhost ~]# dd if=/dev/zero of=/data/d1/big.file bs=1M count=16k
16384+0 records in
16384+0 records out
17179869184 bytes (17 GB) copied, 64.0534 seconds, 268 MB/s

The same fio input deck, with direct set to 0 results in 76.5 MB/s.

Are there are some IO tunables (in the fio input) I should be using for 
SSD testing with fio?

This is 1.41 fio:

[root@localhost ~]# fio --version
fio 1.41

Thanks!

Joe



-- 
Joseph Landman, Ph.D
Founder and CEO
Scalable Informatics Inc.
email: landman@scalableinformatics.com
web  : http://scalableinformatics.com
        http://scalableinformatics.com/jackrabbit
phone: +1 734 786 8423 x121
fax  : +1 866 888 3112
cell : +1 734 612 4615
