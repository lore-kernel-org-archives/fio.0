Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-it0-f49.google.com ([209.85.214.49]:35687 "EHLO
	mail-it0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757338AbcGZRBQ (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 26 Jul 2016 13:01:16 -0400
Received: by mail-it0-f49.google.com with SMTP id u186so120108788ita.0
        for <fio@vger.kernel.org>; Tue, 26 Jul 2016 10:01:16 -0700 (PDT)
MIME-Version: 1.0
From: Yao Zhihao <yzhh029@gmail.com>
Date: Tue, 26 Jul 2016 10:01:08 -0700
Message-ID: <CAF_4wirLitECc0seVhDTythHx63BB2f-GU_Wcx+UpA9UJdc+eA@mail.gmail.com>
Subject: question about eta time when replaying trace
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hello,

I have a question on the time unit in trace file. Based on the HOWTO
doc, the time unit in trace v2 format is microseconds. I have a trace
file which wait 190000 microseconds in total. But when I replay a test
trace, the eta in thread status keeps growing until 18m20s. Then the
job finish very fast. When I try with a larger trace which contains 1
day I/O, the eta grows to more than 1000 days and never stop growing.

And in the test result, the runtime of test is 99924 msec, which is 99
seconds. This number is not what I expected.

I think this may be a bug of different time unit in trace file and eta
display. But I am not sure. And my question is, how do I know fio wait
correctly between two I/O in the trace for the exact time that I
specify in the trace file?

The job file, job result and test trace is attached below.

Thank you in advance!
Zhihao Yao

job file(replay.fio):
[replay]
direct=1
read_iolog=/home/test/fiotest/testwait
filename=/dev/sdb1

test trace(testwait):
fio version 2 iolog
/dev/sdb1 add
/dev/sdb1 open
/dev/sdb1 write 3154137088 1024
/dev/sdb1 wait 100000 0
/dev/sdb1 write 1023483904 1024
/dev/sdb1 wait 10000 0
/dev/sdb1 write 3282030592 1024
/dev/sdb1 wait 10000 0
/dev/sdb1 write 3232870400 1024
/dev/sdb1 wait 10000 0
/dev/sdb1 write 3232870400 1024
/dev/sdb1 wait 10000 0
/dev/sdb1 write 3232870400 1024
/dev/sdb1 wait 10000 0
/dev/sdb1 write 3232870400 1024
/dev/sdb1 wait 10000 0
/dev/sdb1 write 3232870400 1024
/dev/sdb1 wait 10000 0
/dev/sdb1 write 3232870400 1024
/dev/sdb1 wait 10000 0
/dev/sdb1 write 3232870400 1024
/dev/sdb1 wait 10000 0
/dev/sdb1 write 3232870400 1024
/dev/sdb1 close

fio job result:
root@ubuntu:/home/test/fiotest# fio replay.fio
replay: (g=0): rw=read, bs=4K-4K/4K-4K/4K-4K, ioengine=psync, iodepth=1
fio-2.13
Starting 1 process
Jobs: 1 (f=1): [W(1)] [8.4% done] [0KB/0KB/0KB /s] [0/0/0 iops] [eta 18m:20s]
replay: (groupid=0, jobs=1): err= 0: pid=1372: Mon Jul 25 23:54:56 2016
  write: io=11264B, bw=112B/s, iops=0, runt= 99924msec
    clat (usec): min=182, max=420, avg=286.27, stdev=61.36
     lat (usec): min=182, max=422, avg=286.91, stdev=61.79
    clat percentiles (usec):
     |  1.00th=[  183],  5.00th=[  183], 10.00th=[  225], 20.00th=[  233],
     | 30.00th=[  278], 40.00th=[  286], 50.00th=[  298], 60.00th=[  298],
     | 70.00th=[  302], 80.00th=[  314], 90.00th=[  318], 95.00th=[  422],
     | 99.00th=[  422], 99.50th=[  422], 99.90th=[  422], 99.95th=[  422],
     | 99.99th=[  422]
    bw (KB  /s): min=    2, max=    2, per=100.00%, avg= 2.00, stdev= 0.00
    lat (usec) : 250=27.27%, 500=72.73%
  cpu          : usr=0.00%, sys=0.00%, ctx=13, majf=0, minf=7
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%


     issued    : total=r=0/w=11/d=0, short=r=0/w=0/d=0, drop=r=0/w=0/d=0
     latency   : target=0, window=0, percentile=100.00%, depth=1

Run status group 0 (all jobs):
  WRITE: io=11KB, aggrb=0KB/s, minb=0KB/s, maxb=0KB/s, mint=99924msec,
maxt=99924msec

Disk stats (read/write):
  sdb: ios=0/0, merge=0/0, ticks=0/0, in_queue=0, util=0.00%
