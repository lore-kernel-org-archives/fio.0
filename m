Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-by2nam03on0048.outbound.protection.outlook.com ([104.47.42.48]:22859
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1031883AbdEYRPW (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 25 May 2017 13:15:22 -0400
From: "Ratn, Prasun" <Prasun.Ratn@amd.com>
Subject: Running multiple jobs on a raw drive
Date: Thu, 25 May 2017 17:15:21 +0000
Message-ID: <MWHPR12MB16488DDE399E6157B36217EEF1FF0@MWHPR12MB1648.namprd12.prod.outlook.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi

I am trying to run fio on a raw NVMe drive using 2 jobs with QD=3D4.

I am not sure how to specify the offsets for each job to write to. I tried =
using offset_increment but that doesn't seem to work.



The first run with 1 job runs smoothly.

        $ sudo fio --rw=3Drandwrite --bs=3D4k --name=3D/dev/nvme0n1 --runti=
me=3D10 --direct=3D1 --ioengine=3Dlibaio --iodepth=3D4
        /dev/nvme0n1: (g=3D0): rw=3Drandwrite, bs=3D4k-4k/4k-4k/4k-4k, ioen=
gine=3Dlibaio, iodepth=3D4
        fio-2.2.8
        starting 1 process
        jobs: 1 (f=3D1): [w(1)] [100.0% done] [0kb/494.6mb/0kb /s] [0/127k/=
0 iops] [eta 00m:00s]
        /dev/nvme0n1: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D38569: thu m=
ay 25 13:02:50 2017
          write: io=3D4835.3mb, bw=3D495080kb/s, iops=3D123770, runt=3D 100=
01msec
            slat (usec): min=3D2, max=3D206, avg=3D 5.21, stdev=3D 1.70
            clat (usec): min=3D13, max=3D5823, avg=3D25.37, stdev=3D52.46
             lat (usec): min=3D16, max=3D5827, avg=3D30.93, stdev=3D52.43
            clat percentiles (usec):
             |  1.00th=3D[   18],  5.00th=3D[   19], 10.00th=3D[   20], 20.=
00th=3D[   22],
             | 30.00th=3D[   22], 40.00th=3D[   23], 50.00th=3D[   24], 60.=
00th=3D[   24],
             | 70.00th=3D[   25], 80.00th=3D[   26], 90.00th=3D[   27], 95.=
00th=3D[   28],
             | 99.00th=3D[   34], 99.50th=3D[   40], 99.90th=3D[  338], 99.=
95th=3D[  748],
             | 99.99th=3D[ 2992]
            bw (kb  /s): min=3D386360, max=3D523736, per=3D99.74%, avg=3D49=
3776.53, stdev=3D45433.95
            lat (usec) : 20=3D5.37%, 50=3D94.17%, 100=3D0.15%, 250=3D0.17%,=
 500=3D0.07%
            lat (usec) : 750=3D0.02%, 1000=3D0.01%
            lat (msec) : 2=3D0.02%, 4=3D0.02%, 10=3D0.01%
          cpu          : usr=3D17.46%, sys=3D77.55%, ctx=3D2383, majf=3D0, =
minf=3D1332
          io depths    : 1=3D0.1%, 2=3D0.1%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0=
%, 32=3D0.0%, >=3D64=3D0.0%
             submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.=
0%, 64=3D0.0%, >=3D64=3D0.0%
             complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.=
0%, 64=3D0.0%, >=3D64=3D0.0%
             issued    : total=3Dr=3D0/w=3D1237824/d=3D0, short=3Dr=3D0/w=
=3D0/d=3D0, drop=3Dr=3D0/w=3D0/d=3D0
             latency   : target=3D0, window=3D0, percentile=3D100.00%, dept=
h=3D4

        run status group 0 (all jobs):
          write: io=3D4835.3mb, aggrb=3D495080kb/s, minb=3D495080kb/s, maxb=
=3D495080kb/s, mint=3D10001msec, maxt=3D10001msec

        disk stats (read/write):
          nvme0n1: ios=3D130/1223268, merge=3D0/0, ticks=3D5/19173, in_queu=
e=3D18724, util=3D98.98%

When I try specifying numjobs=3D2 with offset_increment, I get an error and=
 only 1 process is launched.


        $ sudo fio --rw=3Drandwrite --bs=3D4k --name=3D/dev/nvme0n1 --runti=
me=3D10 --direct=3D1 --ioengine=3Dlibaio --iodepth=3D4 --numjobs=3D2 --offs=
et_increment=3D81920m
        /dev/nvme0n1: (g=3D0): rw=3Drandwrite, bs=3D4k-4k/4k-4k/4k-4k, ioen=
gine=3Dlibaio, iodepth=3D4
        ...
        fio-2.2.8
        starting 2 processes
        /dev/nvme0n1: you need to specify size=3D
        fio: pid=3D0, err=3D22/file:filesetup.c:802, func=3Dtotal_file_size=
, error=3Dinvalid argument
        ^cbs: 1 (f=3D1): [w(1),x(1)] [54.5% done] [0kb/510.2mb/0kb /s] [0/1=
31k/0 iops] [eta 00m:05s]
        fio: terminating on signal 2

What's the best way to have multiple jobs run on a single raw drive.

Thanks
Prasun
