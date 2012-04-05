Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:48685 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957Ab2DEXUV (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 5 Apr 2012 19:20:21 -0400
Received: by eaaq12 with SMTP id q12so567351eaa.19
        for <fio@vger.kernel.org>; Thu, 05 Apr 2012 16:20:20 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 5 Apr 2012 16:20:20 -0700
Message-ID: <CAN8qX8YZoZ2TtcqU0QOTEguHoqsYQRuMoFvRsT3JTJc9Uba19w@mail.gmail.com>
Subject: query on verify_dump option
From: Suresh Dhanarajan <sureshdrajan@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi,

I am trying data integration cases with verify_pattern option.
I am not seeing any dump file generated for the mismatch.
Here are the steps i followed,
Started fio and waited till 30 % writes done the disk and issued a dd
write on the same disc for the first 512 bytes with pattern zero.
then waited till verify gets completed.
I can see the error's in the output log file but not the dump file.

Here is my job file.

[global]
size=10g
direct=1
filename=/dev/sdc
verify_pattern=0x01010101
verify=meta
bs=64k
group_reporting

[write-phase]
rw=write
do_verify=0

[verify-phase]
stonewall
rw=read
do_verify=1
continue_on_error=all
verify_dump=1
~



Let me know if i am missing something over here.

Here is my log file for the verify part,

verify-phase: (groupid=1, jobs=1): err=84 (): pid=9598
  read : io=10240MB, bw=109548KB/s, iops=1711 , runt= 95718msec
    clat (usec): min=443 , max=10326 , avg=487.46, stdev=45.87
     lat (usec): min=443 , max=10326 , avg=487.67, stdev=45.87
    clat percentiles (usec):
     |  1.00th=[  454],  5.00th=[  458], 10.00th=[  462], 20.00th=[  474],
     | 30.00th=[  474], 40.00th=[  478], 50.00th=[  478], 60.00th=[  482],
     | 70.00th=[  486], 80.00th=[  490], 90.00th=[  510], 95.00th=[  532],
     | 99.00th=[  716], 99.50th=[  740], 99.90th=[  764], 99.95th=[  780],
     | 99.99th=[  884]
    bw (KB/s)  : min=105216, max=111360, per=100.00%, avg=109611.56,
stdev=1711.54
    lat (usec) : 500=84.32%, 750=15.45%, 1000=0.23%
    lat (msec) : 2=0.01%, 20=0.01%
  cpu          : usr=16.72%, sys=2.69%, ctx=172103, majf=0, minf=66
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued    : total=r=163840/w=0/d=0, short=r=0/w=0/d=0
     errors    : total=1, first_error=84/<Invalid or incomplete
multibyte or wide character>

Run status group 0 (all jobs):
  WRITE: io=10240MB, aggrb=101239KB/s, minb=103669KB/s,
maxb=103669KB/s, mint=103574msec, maxt=103574msec

Run status group 1 (all jobs):
   READ: io=10240MB, aggrb=109548KB/s, minb=112177KB/s,
maxb=112177KB/s, mint=95718msec, maxt=95718msec

Disk stats (read/write):
  sdc: ios=163444/163841, merge=0/0, ticks=75357/92314,
in_queue=167479, util=84.01%
~


2)Also i have one query like verify_pattern option is it possible to
provide known pattern for write and reads this will be very useful in
DI verification test cases

Thanks,
Suresh.D
