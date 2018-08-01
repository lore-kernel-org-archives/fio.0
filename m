Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-lf1-f46.google.com ([209.85.167.46]:33082 "EHLO
        mail-lf1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733060AbeHAHPT (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 1 Aug 2018 03:15:19 -0400
Received: by mail-lf1-f46.google.com with SMTP id u14-v6so12391378lfu.0
        for <fio@vger.kernel.org>; Tue, 31 Jul 2018 22:31:28 -0700 (PDT)
MIME-Version: 1.0
From: =?UTF-8?B?2KLYsdi0INiu2KfZiNix24wg2LHYp9iv?= 
        <arash.khavary@gmail.com>
Date: Wed, 1 Aug 2018 05:31:26 +0000
Message-ID: <CAKTzs3R0S8q=tCkNZ99xqpJpjcAjDCphdSV_GvBbGKRA3GWOUw@mail.gmail.com>
Subject: get err 5
Content-Type: multipart/alternative; boundary="0000000000009379ee0572590110"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

--0000000000009379ee0572590110
Content-Type: text/plain; charset="UTF-8"

Hi i got this error when test FIO sequential write every time, in
sequential read, random read, random write not got this.

my Linux distro is CentOS Linux release 7.5.1804 (Core)
and my kernel version is 3.10.0-327.10.1.el7.x86_64

My output is:

job1: (g=0): rw=write, bs=(R) 4096KiB-4096KiB, (W) 4096KiB-4096KiB, (T)
4096KiB-4096KiB, ioengine=libaio, iodepth=16
...
job1: (g=0): rw=write, bs=(R) 4096KiB-4096KiB, (W) 4096KiB-4096KiB, (T)
4096KiB-4096KiB, ioengine=libaio, iodepth=16
...
job1: (g=0): rw=write, bs=(R) 4096KiB-4096KiB, (W) 4096KiB-4096KiB, (T)
4096KiB-4096KiB, ioengine=libaio, iodepth=16
...
job1: (g=0): rw=write, bs=(R) 4096KiB-4096KiB, (W) 4096KiB-4096KiB, (T)
4096KiB-4096KiB, ioengine=libaio, iodepth=16
...
job1: (g=0): rw=write, bs=(R) 4096KiB-4096KiB, (W) 4096KiB-4096KiB, (T)
4096KiB-4096KiB, ioengine=libaio, iodepth=16
...
job1: (g=0): rw=write, bs=(R) 4096KiB-4096KiB, (W) 4096KiB-4096KiB, (T)
4096KiB-4096KiB, ioengine=libaio, iodepth=16
...
fio-3.1
Starting 16 processes

job1: (groupid=0, jobs=16): err= 5 (file:io_u.c:1756, func=io_u error,
error=Input/output error): pid=10664: Fri Sep  4 00:03:23 2015
  write: IOPS=319, BW=1279MiB/s (1341MB/s)(2559GiB/2048690msec)
    slat (usec): min=227, max=101577k, avg=16698.60, stdev=395259.01
    clat (msec): min=71, max=102013, avg=302.24, stdev=1524.49
     lat (msec): min=72, max=102014, avg=318.94, stdev=1574.94
    clat percentiles (msec):
     |  1.00th=[  136],  5.00th=[  161], 10.00th=[  180], 20.00th=[  209],
     | 30.00th=[  230], 40.00th=[  247], 50.00th=[  264], 60.00th=[  284],
     | 70.00th=[  305], 80.00th=[  330], 90.00th=[  376], 95.00th=[  430],
     | 99.00th=[  550], 99.50th=[  592], 99.90th=[  726], 99.95th=[  810],
     | 99.99th=[17113]
   bw (  KiB/s): min= 8308, max=403830, per=13.68%, avg=179223.36,
stdev=54500.84, samples=15737
   iops        : min=    2, max=   98, avg=43.32, stdev=13.35, samples=15737
  lat (msec)   : 100=0.01%, 250=27.42%, 500=36.58%, 750=1.31%, 1000=0.03%
  lat (msec)   : 2000=0.01%, >=2000=0.02%
  cpu          : usr=16.84%, sys=4.74%, ctx=199315, majf=0, minf=117471
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=1221.9%, 32=0.0%,
>=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%,
>=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.1%, 32=0.0%, 64=0.0%,
>=64=0.0%
     issued rwt: total=0,655023,0, short=0,0,0, dropped=0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=16

Run status group 0 (all jobs):
  WRITE: bw=1279MiB/s (1341MB/s), 1279MiB/s-1279MiB/s (1341MB/s-1341MB/s),
io=2559GiB (2748GB), run=2048690-2048690msec

Disk stats (read/write):
  sdb: ios=87/12938655, merge=0/0, ticks=62/1728507436,
in_queue=1728692357, util=100.00%
  sdc: ios=43/12688086, merge=0/0, ticks=12/1680848678,
in_queue=1680921305, util=100.00%
  sdd: ios=43/12793381, merge=0/0, ticks=9/1726297058, in_queue=1726441852,
util=100.00%
  sde: ios=34/12824943, merge=0/0, ticks=9/1726084912, in_queue=1726194592,
util=100.00%
  sdf: ios=0/1816141, merge=0/0, ticks=0/288898653, in_queue=300747577,
util=100.00%
  sdg: ios=0/10970577, merge=0/0, ticks=0/1759675137, in_queue=1759784380,
util=100.00%

My parameter is :


[global]
readwrite=write
blocksize=4m
direct=1
#numjobs=1
iodepth=16
ioengine=libaio
#filename=/dev/sdx
refill_buffers
time_based
runtime=600
ramp_time=10800
group_reporting

[job1]
numjobs=3
filename=/dev/sdb


[job2]
numjobs=2
filename=/dev/sdc


[job3]
numjobs=3
filename=/dev/sdd


[job4]
numjobs=3
filename=/dev/sde


[job5]
numjobs=2
filename=/dev/sdf


[job6]
numjobs=3
filename=/dev/sdg


.




Why get err 5?
thanks

--0000000000009379ee0572590110
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"rtl"><div dir=3D"ltr">Hi i got this error when test FIO sequent=
ial write every time, in sequential read, random read, random write not got=
 this.</div><div dir=3D"ltr"><br></div><div dir=3D"ltr">my Linux distro is =
CentOS Linux release 7.5.1804 (Core)</div><div dir=3D"ltr">and my kernel ve=
rsion is 3.10.0-327.10.1.el7.x86_64</div><div dir=3D"ltr"><br></div><div di=
r=3D"ltr">My output is:<br><br>job1: (g=3D0): rw=3Dwrite, bs=3D(R) 4096KiB-=
4096KiB, (W) 4096KiB-4096KiB, (T) 4096KiB-4096KiB, ioengine=3Dlibaio, iodep=
th=3D16<br>...<br>job1: (g=3D0): rw=3Dwrite, bs=3D(R) 4096KiB-4096KiB, (W) =
4096KiB-4096KiB, (T) 4096KiB-4096KiB, ioengine=3Dlibaio, iodepth=3D16<br>..=
.<br>job1: (g=3D0): rw=3Dwrite, bs=3D(R) 4096KiB-4096KiB, (W) 4096KiB-4096K=
iB, (T) 4096KiB-4096KiB, ioengine=3Dlibaio, iodepth=3D16<br>...<br>job1: (g=
=3D0): rw=3Dwrite, bs=3D(R) 4096KiB-4096KiB, (W) 4096KiB-4096KiB, (T) 4096K=
iB-4096KiB, ioengine=3Dlibaio, iodepth=3D16<br>...<br>job1: (g=3D0): rw=3Dw=
rite, bs=3D(R) 4096KiB-4096KiB, (W) 4096KiB-4096KiB, (T) 4096KiB-4096KiB, i=
oengine=3Dlibaio, iodepth=3D16<br>...<br>job1: (g=3D0): rw=3Dwrite, bs=3D(R=
) 4096KiB-4096KiB, (W) 4096KiB-4096KiB, (T) 4096KiB-4096KiB, ioengine=3Dlib=
aio, iodepth=3D16<br>...<br>fio-3.1<br>Starting 16 processes<br><br>job1: (=
groupid=3D0, jobs=3D16): err=3D 5 (file:io_u.c:1756, func=3Dio_u error, err=
or=3DInput/output error): pid=3D10664: Fri Sep=C2=A0 4 00:03:23 2015<br>=C2=
=A0 write: IOPS=3D319, BW=3D1279MiB/s (1341MB/s)(2559GiB/2048690msec)<br>=
=C2=A0=C2=A0=C2=A0 slat (usec): min=3D227, max=3D101577k, avg=3D16698.60, s=
tdev=3D395259.01<br>=C2=A0=C2=A0=C2=A0 clat (msec): min=3D71, max=3D102013,=
 avg=3D302.24, stdev=3D1524.49<br>=C2=A0=C2=A0=C2=A0=C2=A0 lat (msec): min=
=3D72, max=3D102014, avg=3D318.94, stdev=3D1574.94<br>=C2=A0=C2=A0=C2=A0 cl=
at percentiles (msec):<br>=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 1.00th=3D[=C2=A0=
 136],=C2=A0 5.00th=3D[=C2=A0 161], 10.00th=3D[=C2=A0 180], 20.00th=3D[=C2=
=A0 209],<br>=C2=A0=C2=A0=C2=A0=C2=A0 | 30.00th=3D[=C2=A0 230], 40.00th=3D[=
=C2=A0 247], 50.00th=3D[=C2=A0 264], 60.00th=3D[=C2=A0 284],<br>=C2=A0=C2=
=A0=C2=A0=C2=A0 | 70.00th=3D[=C2=A0 305], 80.00th=3D[=C2=A0 330], 90.00th=
=3D[=C2=A0 376], 95.00th=3D[=C2=A0 430],<br>=C2=A0=C2=A0=C2=A0=C2=A0 | 99.0=
0th=3D[=C2=A0 550], 99.50th=3D[=C2=A0 592], 99.90th=3D[=C2=A0 726], 99.95th=
=3D[=C2=A0 810],<br>=C2=A0=C2=A0=C2=A0=C2=A0 | 99.99th=3D[17113]<br>=C2=A0=
=C2=A0 bw (=C2=A0 KiB/s): min=3D 8308, max=3D403830, per=3D13.68%, avg=3D17=
9223.36, stdev=3D54500.84, samples=3D15737<br>=C2=A0=C2=A0 iops=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : min=3D=C2=A0=C2=A0=C2=A0 2, max=3D=C2=A0=
=C2=A0 98, avg=3D43.32, stdev=3D13.35, samples=3D15737<br>=C2=A0 lat (msec)=
=C2=A0=C2=A0 : 100=3D0.01%, 250=3D27.42%, 500=3D36.58%, 750=3D1.31%, 1000=
=3D0.03%<br>=C2=A0 lat (msec)=C2=A0=C2=A0 : 2000=3D0.01%, &gt;=3D2000=3D0.0=
2%<br>=C2=A0 cpu=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : us=
r=3D16.84%, sys=3D4.74%, ctx=3D199315, majf=3D0, minf=3D117471<br>=C2=A0 IO=
 depths=C2=A0=C2=A0=C2=A0 : 1=3D0.1%, 2=3D0.1%, 4=3D0.1%, 8=3D0.1%, 16=3D12=
21.9%, 32=3D0.0%, &gt;=3D64=3D0.0%<br>=C2=A0=C2=A0=C2=A0=C2=A0 submit=C2=A0=
=C2=A0=C2=A0 : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=3D0=
.0%, &gt;=3D64=3D0.0%<br>=C2=A0=C2=A0=C2=A0=C2=A0 complete=C2=A0 : 0=3D0.0%=
, 4=3D100.0%, 8=3D0.0%, 16=3D0.1%, 32=3D0.0%, 64=3D0.0%, &gt;=3D64=3D0.0%<b=
r>=C2=A0=C2=A0=C2=A0=C2=A0 issued rwt: total=3D0,655023,0, short=3D0,0,0, d=
ropped=3D0,0,0<br>=C2=A0=C2=A0=C2=A0=C2=A0 latency=C2=A0=C2=A0 : target=3D0=
, window=3D0, percentile=3D100.00%, depth=3D16<br><br>Run status group 0 (a=
ll jobs):<br>=C2=A0 WRITE: bw=3D1279MiB/s (1341MB/s), 1279MiB/s-1279MiB/s (=
1341MB/s-1341MB/s), io=3D2559GiB (2748GB), run=3D2048690-2048690msec<br><br=
>Disk stats (read/write):<br>=C2=A0 sdb: ios=3D87/12938655, merge=3D0/0, ti=
cks=3D62/1728507436, in_queue=3D1728692357, util=3D100.00%<br>=C2=A0 sdc: i=
os=3D43/12688086, merge=3D0/0, ticks=3D12/1680848678, in_queue=3D1680921305=
, util=3D100.00%<br>=C2=A0 sdd: ios=3D43/12793381, merge=3D0/0, ticks=3D9/1=
726297058, in_queue=3D1726441852, util=3D100.00%<br>=C2=A0 sde: ios=3D34/12=
824943, merge=3D0/0, ticks=3D9/1726084912, in_queue=3D1726194592, util=3D10=
0.00%<br>=C2=A0 sdf: ios=3D0/1816141, merge=3D0/0, ticks=3D0/288898653, in_=
queue=3D300747577, util=3D100.00%<br>=C2=A0 sdg: ios=3D0/10970577, merge=3D=
0/0, ticks=3D0/1759675137, in_queue=3D1759784380, util=3D100.00%<br><br></d=
iv><div dir=3D"ltr">My parameter is :<br><br><br>[global]<br>readwrite=3Dwr=
ite<br>blocksize=3D4m<br>direct=3D1<br>#numjobs=3D1<br>iodepth=3D16<br>ioen=
gine=3Dlibaio<br>#filename=3D/dev/sdx<br>refill_buffers<br>time_based<br>ru=
ntime=3D600<br>ramp_time=3D10800<br>group_reporting<br><br>[job1]<br>numjob=
s=3D3<br>filename=3D/dev/sdb<br><br><br>[job2]<br>numjobs=3D2<br>filename=
=3D/dev/sdc<br><br><br>[job3]<br>numjobs=3D3<br>filename=3D/dev/sdd<br><br>=
<br>[job4]<br>numjobs=3D3<br>filename=3D/dev/sde<br><br><br>[job5]<br>numjo=
bs=3D2<br>filename=3D/dev/sdf<br><br><br>[job6]<br>numjobs=3D3<br>filename=
=3D/dev/sdg<br><br><br>.<br><br><br><br><br></div><div dir=3D"ltr">Why get =
err 5?<br></div><div dir=3D"ltr">thanks<br></div></div>

--0000000000009379ee0572590110--
