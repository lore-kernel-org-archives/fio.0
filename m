Return-Path: <fio-owner@vger.kernel.org>
Received: from mail.ibr.cs.tu-bs.de ([134.169.34.52]:49124 "EHLO
        mail.ibr.cs.tu-bs.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750808AbdBCRF2 (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 3 Feb 2017 12:05:28 -0500
Received: from localhost (localhost [127.0.0.1])
        by mail.ibr.cs.tu-bs.de (Postfix) with ESMTP id B53B418C25B
        for <fio@vger.kernel.org>; Fri,  3 Feb 2017 17:57:06 +0100 (CET)
From: Frank Steinberg <steinberg@ibr.cs.tu-bs.de>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (Mac OS X Mail 10.2 \(3259\))
Date: Fri, 3 Feb 2017 17:57:02 +0100
Subject: Differences in "BW" and "bw" results
Message-Id: <B0E32160-C38E-4CDF-BBEF-B8259D99016E@ibr.cs.tu-bs.de>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi,

I am quite new to fio, and I cannot interpret bandwidth results, yet. I =
found some articles on the interpretation of fio results, but no answer =
for my specific question.

When I do *not* generate log files, the results seem clear to me. But =
with the "--write_bw_log" option I see a new "bw" section (which also =
reflects the numbers written to the logfile) and a discrepancy between =
these bandwidth numbers:

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
root@knorkator:~/fio# ./fio/fio --numjobs=3D1 --iodepth=3D1 --direct=3D1 =
--runtime=3D13 --time_based --size=3D50M --directory=3D/opt/tmp =
--ioengine=3Dlibaio --rw=3Dread --bs=3D4k --name=3Dlocal-libaio-read-4k =
--write_bw_log=3Dlog/local-libaio-read-4k=20
local-libaio-read-4k: (g=3D0): rw=3Dread, =
bs=3D4096B-4096B,4096B-4096B,4096B-4096B, ioengine=3Dlibaio, iodepth=3D1
fio-2.17-33-g3dd2e
Starting 1 process
Jobs: 1 (f=3D1): [R(1)][100.0%][r=3D91.2MiB/s,w=3D0KiB/s][r=3D23.6k,w=3D0 =
IOPS][eta 00m:00s]
local-libaio-read-4k: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D13599: =
Fri Feb  3 17:26:41 2017
   read: IOPS=3D23.5k, BW=3D91.5MiB/s (95.9MB/s)(1189MiB/13001msec)
    slat (usec): min=3D5, max=3D127, avg=3D 7.56, stdev=3D 2.02
    clat (usec): min=3D2, max=3D1058, avg=3D32.63, stdev=3D 8.33
     lat (usec): min=3D33, max=3D1065, avg=3D40.19, stdev=3D 8.90
    clat percentiles (usec):
     |  1.00th=3D[   29],  5.00th=3D[   29], 10.00th=3D[   29], =
20.00th=3D[   30],
     | 30.00th=3D[   30], 40.00th=3D[   30], 50.00th=3D[   30], =
60.00th=3D[   31],
     | 70.00th=3D[   32], 80.00th=3D[   34], 90.00th=3D[   39], =
95.00th=3D[   41],
     | 99.00th=3D[   58], 99.50th=3D[   91], 99.90th=3D[  126], =
99.95th=3D[  153],
     | 99.99th=3D[  213]
   bw (  KiB/s): min=3D 3871, max=3D2048000, per=3D0.13%, avg=3D128690.23,=
 stdev=3D16014.17
    lat (usec) : 4=3D0.01%, 20=3D0.01%, 50=3D98.87%, 100=3D0.78%, =
250=3D0.34%
    lat (usec) : 500=3D0.01%, 750=3D0.01%
    lat (msec) : 2=3D0.01%
  cpu          : usr=3D10.15%, sys=3D26.03%, ctx=3D304964, majf=3D0, =
minf=3D1802
  IO depths    : 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, =
32=3D0.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, =
64=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, =
64=3D0.0%, >=3D64=3D0.0%
     issued rwt: total=3D304292,0,0, short=3D0,0,0, dropped=3D0,0,0
     latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D1

Run status group 0 (all jobs):
   READ: bw=3D91.5MiB/s (95.9MB/s), 91.5MiB/s-91.5MiB/s =
(95.9MB/s-95.9MB/s), io=3D1189MiB (1246MB), run=3D13001-13001msec

Disk stats (read/write):
  sda: ios=3D301861/41, merge=3D0/25, ticks=3D8612/24, in_queue=3D8660, =
util=3D66.55%
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

The bandwidth numbers on the "read: ..." line and close to the bottom =
claim that I measured a total average bandwidth of 91.5 MiB/s. That =
seems reasonable.

But there is also a "bw" section that claims an avg of 128690.23 KiB/s. =
What is the difference between these numbers?

When I modify iodepth or numjobs parameters, the discrepancy changes, =
e.g. with iodepth=3D8 the first number goes up to 278 MiB/s, while the =
"bw" number goes down to 42921.43 KiB/s.

Unfortunately, the "bw" numbers are written to the logfile, so that my =
plots do not show what I would expect.


Thanks in advance for any help,

 -frank







