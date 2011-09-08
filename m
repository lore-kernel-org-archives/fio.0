Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:63138 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932400Ab1IHMbq convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Thu, 8 Sep 2011 08:31:46 -0400
Received: by gyg10 with SMTP id 10so276946gyg.19
        for <fio@vger.kernel.org>; Thu, 08 Sep 2011 05:31:46 -0700 (PDT)
From: Kurt <batlin@gmail.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Subject: CPU utilization reporting
Date: Thu, 8 Sep 2011 07:31:45 -0500
Message-Id: <F96F5D48-5D6F-4C99-800C-0DE4B93357E8@gmail.com>
Mime-Version: 1.0 (Apple Message framework v1244.3)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hello FIO community
=20
I have been working with FIO for a month or so and have studied the source =
code quite a bit as well.  I have run into an issue where my CPU utilizatio=
n (sys/user) is actually higher than 100% and in some cases it is higher th=
an 200%!!! When my actual cpu utilization is nowhere near that.=20
=20
These tests were performed on a
Dell T610=20
1x E5520 @ 2.27GHz    4 core / 8 thread
6GB Ram
=20
Example:
=20
[global]
direct=3D1
ramp_time=3D15
runtime=3D30
loops=3D1
sync=3D0
filename=3D/dev/sdb
=20
[512_Seq_Read-256]
rw=3Dread
bs=3D512
rwmixread=3D100
iodepth=3D256
randrepeat=3D0
ioengine=3Dlibaio
name=3D512_Seq_Read-256
numjobs=3D2
=20
512_Seq_Read-256: (g=3D0): rw=3Dread, bs=3D512-512/512-512, ioengine=3Dliba=
io, iodepth=3D256
512_Seq_Read-256: (g=3D0): rw=3Dread, bs=3D512-512/512-512, ioengine=3Dliba=
io, iodepth=3D256
fio 1.57
Starting 2 threads
=20
512_Seq_Read-256: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D25402
  read : io=3D2107.7MB, bw=3D71933KB/s, iops=3D143857 , runt=3D 30003msec
    slat (usec): min=3D1 , max=3D472 , avg=3D 3.73, stdev=3D11.11
    clat (usec): min=3D133 , max=3D9529 , avg=3D1774.29, stdev=3D867.16
     lat (usec): min=3D137 , max=3D9531 , avg=3D1778.35, stdev=3D868.14
    bw (KB/s) : min=3D    0, max=3D102671, per=3D9.42%, avg=3D13701.43, std=
ev=3D29175.35
  cpu          : usr=3D135.37%, sys=3D132.84%, ctx=3D346431, majf=3D0, minf=
=3D302
  IO depths    : 1=3D0.1%, 2=3D0.1%, 4=3D0.1%, 8=3D0.1%, 16=3D0.1%, 32=3D0.=
1%, >=3D64=3D151.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.1%
     issued r/w/d: total=3D4316167/0/0, short=3D0/0/0
     lat (usec): 250=3D0.39%, 500=3D6.15%, 750=3D9.10%, 1000=3D8.69%
     lat (msec): 2=3D29.94%, 4=3D44.97%, 10=3D0.76%
512_Seq_Read-256: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D25403
  read : io=3D2156.4MB, bw=3D73590KB/s, iops=3D147171 , runt=3D 30001msec
    slat (usec): min=3D1 , max=3D650 , avg=3D 3.69, stdev=3D11.05
    clat (usec): min=3D130 , max=3D10959 , avg=3D1734.38, stdev=3D860.90
     lat (usec): min=3D133 , max=3D10961 , avg=3D1738.34, stdev=3D861.86
    bw (KB/s) : min=3D    0, max=3D103101, per=3D49.60%, avg=3D72180.12, st=
dev=3D18747.47
  cpu          : usr=3D135.38%, sys=3D132.85%, ctx=3D346416, majf=3D0, minf=
=3D217
  IO depths    : 1=3D0.1%, 2=3D0.1%, 4=3D0.1%, 8=3D0.1%, 16=3D0.1%, 32=3D0.=
1%, >=3D64=3D149.7%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.1%
     issued r/w/d: total=3D4415302/0/0, short=3D0/0/0
     lat (usec): 250=3D0.42%, 500=3D6.52%, 750=3D9.49%, 1000=3D9.03%
     lat (msec): 2=3D30.91%, 4=3D42.90%, 10=3D0.74%, 20=3D0.01%
=20
Run status group 0 (all jobs):
   READ: io=3D4263.7MB, aggrb=3D145518KB/s, minb=3D73659KB/s, maxb=3D75356K=
B/s, mint=3D30001msec, maxt=3D30003msec
=20
Disk stats (read/write):
  sdb: ios=3D3980775/0, merge=3D9097849/0, ticks=3D4798475/0, in_queue=3D47=
98485, util=3D99.98%
=20
As you see the CPU is 135% both usr and sys=EF=BF=BD    do I need to divide=
 by the number of processor threads (8)?
=20
Thank You
Kurtis Dorsey
Storage Performance Software Developer
=20
 