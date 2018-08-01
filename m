Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f51.google.com ([209.85.213.51]:46514 "EHLO
        mail-vk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387419AbeHAIXW (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 1 Aug 2018 04:23:22 -0400
Received: by mail-vk0-f51.google.com with SMTP id b14-v6so8766661vke.13
        for <fio@vger.kernel.org>; Tue, 31 Jul 2018 23:39:14 -0700 (PDT)
MIME-Version: 1.0
References: <CAKTzs3R0S8q=tCkNZ99xqpJpjcAjDCphdSV_GvBbGKRA3GWOUw@mail.gmail.com>
In-Reply-To: <CAKTzs3R0S8q=tCkNZ99xqpJpjcAjDCphdSV_GvBbGKRA3GWOUw@mail.gmail.com>
From: Alireza Haghdoost <haghdoost@gmail.com>
Date: Wed, 1 Aug 2018 01:39:03 -0500
Message-ID: <CAB-428kzrUriC9SKetP+YJRdFefQRv0-=DVfeMyyFOiXim8svA@mail.gmail.com>
Subject: Re: get err 5
Content-Type: multipart/alternative; boundary="000000000000f50749057259f3d7"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: =?UTF-8?B?2KLYsdi0INiu2KfZiNix24wg2LHYp9iv?= <arash.khavary@gmail.com>
Cc: fio@vger.kernel.org

--000000000000f50749057259f3d7
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Your jobs step on the foot of each other. You can=E2=80=99t write with mult=
iple
process on the same LBA of a LUN on the same time. That is why you get
error 5 because one thread is writting an LBA and another thread modify if
at the same time. In this case either one can get unknown result.

On Wed, Aug 1, 2018 at 12:32 AM =D8=A2=D8=B1=D8=B4 =D8=AE=D8=A7=D9=88=D8=B1=
=DB=8C =D8=B1=D8=A7=D8=AF <arash.khavary@gmail.com>
wrote:

> Hi i got this error when test FIO sequential write every time, in
> sequential read, random read, random write not got this.
>
> my Linux distro is CentOS Linux release 7.5.1804 (Core)
> and my kernel version is 3.10.0-327.10.1.el7.x86_64
>
> My output is:
>
> job1: (g=3D0): rw=3Dwrite, bs=3D(R) 4096KiB-4096KiB, (W) 4096KiB-4096KiB,=
 (T)
> 4096KiB-4096KiB, ioengine=3Dlibaio, iodepth=3D16
> ...
> job1: (g=3D0): rw=3Dwrite, bs=3D(R) 4096KiB-4096KiB, (W) 4096KiB-4096KiB,=
 (T)
> 4096KiB-4096KiB, ioengine=3Dlibaio, iodepth=3D16
> ...
> job1: (g=3D0): rw=3Dwrite, bs=3D(R) 4096KiB-4096KiB, (W) 4096KiB-4096KiB,=
 (T)
> 4096KiB-4096KiB, ioengine=3Dlibaio, iodepth=3D16
> ...
> job1: (g=3D0): rw=3Dwrite, bs=3D(R) 4096KiB-4096KiB, (W) 4096KiB-4096KiB,=
 (T)
> 4096KiB-4096KiB, ioengine=3Dlibaio, iodepth=3D16
> ...
> job1: (g=3D0): rw=3Dwrite, bs=3D(R) 4096KiB-4096KiB, (W) 4096KiB-4096KiB,=
 (T)
> 4096KiB-4096KiB, ioengine=3Dlibaio, iodepth=3D16
> ...
> job1: (g=3D0): rw=3Dwrite, bs=3D(R) 4096KiB-4096KiB, (W) 4096KiB-4096KiB,=
 (T)
> 4096KiB-4096KiB, ioengine=3Dlibaio, iodepth=3D16
> ...
> fio-3.1
> Starting 16 processes
>
> job1: (groupid=3D0, jobs=3D16): err=3D 5 (file:io_u.c:1756, func=3Dio_u e=
rror,
> error=3DInput/output error): pid=3D10664: Fri Sep  4 00:03:23 2015
>   write: IOPS=3D319, BW=3D1279MiB/s (1341MB/s)(2559GiB/2048690msec)
>     slat (usec): min=3D227, max=3D101577k, avg=3D16698.60, stdev=3D395259=
.01
>     clat (msec): min=3D71, max=3D102013, avg=3D302.24, stdev=3D1524.49
>      lat (msec): min=3D72, max=3D102014, avg=3D318.94, stdev=3D1574.94
>     clat percentiles (msec):
>      |  1.00th=3D[  136],  5.00th=3D[  161], 10.00th=3D[  180], 20.00th=
=3D[  209],
>      | 30.00th=3D[  230], 40.00th=3D[  247], 50.00th=3D[  264], 60.00th=
=3D[  284],
>      | 70.00th=3D[  305], 80.00th=3D[  330], 90.00th=3D[  376], 95.00th=
=3D[  430],
>      | 99.00th=3D[  550], 99.50th=3D[  592], 99.90th=3D[  726], 99.95th=
=3D[  810],
>      | 99.99th=3D[17113]
>    bw (  KiB/s): min=3D 8308, max=3D403830, per=3D13.68%, avg=3D179223.36=
,
> stdev=3D54500.84, samples=3D15737
>    iops        : min=3D    2, max=3D   98, avg=3D43.32, stdev=3D13.35,
> samples=3D15737
>   lat (msec)   : 100=3D0.01%, 250=3D27.42%, 500=3D36.58%, 750=3D1.31%, 10=
00=3D0.03%
>   lat (msec)   : 2000=3D0.01%, >=3D2000=3D0.02%
>   cpu          : usr=3D16.84%, sys=3D4.74%, ctx=3D199315, majf=3D0, minf=
=3D117471
>   IO depths    : 1=3D0.1%, 2=3D0.1%, 4=3D0.1%, 8=3D0.1%, 16=3D1221.9%, 32=
=3D0.0%,
> >=3D64=3D0.0%
>      submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%,
> >=3D64=3D0.0%
>      complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.1%, 32=3D0.0%, 64=
=3D0.0%,
> >=3D64=3D0.0%
>      issued rwt: total=3D0,655023,0, short=3D0,0,0, dropped=3D0,0,0
>      latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D16
>
> Run status group 0 (all jobs):
>   WRITE: bw=3D1279MiB/s (1341MB/s), 1279MiB/s-1279MiB/s (1341MB/s-1341MB/=
s),
> io=3D2559GiB (2748GB), run=3D2048690-2048690msec
>
> Disk stats (read/write):
>   sdb: ios=3D87/12938655, merge=3D0/0, ticks=3D62/1728507436,
> in_queue=3D1728692357, util=3D100.00%
>   sdc: ios=3D43/12688086, merge=3D0/0, ticks=3D12/1680848678,
> in_queue=3D1680921305, util=3D100.00%
>   sdd: ios=3D43/12793381, merge=3D0/0, ticks=3D9/1726297058,
> in_queue=3D1726441852, util=3D100.00%
>   sde: ios=3D34/12824943, merge=3D0/0, ticks=3D9/1726084912,
> in_queue=3D1726194592, util=3D100.00%
>   sdf: ios=3D0/1816141, merge=3D0/0, ticks=3D0/288898653, in_queue=3D3007=
47577,
> util=3D100.00%
>   sdg: ios=3D0/10970577, merge=3D0/0, ticks=3D0/1759675137, in_queue=3D17=
59784380,
> util=3D100.00%
>
> My parameter is :
>
>
> [global]
> readwrite=3Dwrite
> blocksize=3D4m
> direct=3D1
> #numjobs=3D1
> iodepth=3D16
> ioengine=3Dlibaio
> #filename=3D/dev/sdx
> refill_buffers
> time_based
> runtime=3D600
> ramp_time=3D10800
> group_reporting
>
> [job1]
> numjobs=3D3
> filename=3D/dev/sdb
>
>
> [job2]
> numjobs=3D2
> filename=3D/dev/sdc
>
>
> [job3]
> numjobs=3D3
> filename=3D/dev/sdd
>
>
> [job4]
> numjobs=3D3
> filename=3D/dev/sde
>
>
> [job5]
> numjobs=3D2
> filename=3D/dev/sdf
>
>
> [job6]
> numjobs=3D3
> filename=3D/dev/sdg
>
>
> .
>
>
>
>
> Why get err 5?
> thanks
>

--000000000000f50749057259f3d7
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div><div dir=3D"auto">Your jobs step on the foot of each other. You can=E2=
=80=99t write with multiple process on the same LBA of a LUN on the same ti=
me. That is why you get error 5 because one thread is writting an LBA and a=
nother thread modify if at the same time. In this case either one can get u=
nknown result.<br></div></div><div dir=3D"auto"><br></div><div><div class=
=3D"gmail_quote"><div dir=3D"ltr">On Wed, Aug 1, 2018 at 12:32 AM =D8=A2=D8=
=B1=D8=B4 =D8=AE=D8=A7=D9=88=D8=B1=DB=8C =D8=B1=D8=A7=D8=AF &lt;<a href=3D"=
mailto:arash.khavary@gmail.com">arash.khavary@gmail.com</a>&gt; wrote:<br><=
/div><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-le=
ft:1px #ccc solid;padding-left:1ex"><div dir=3D"rtl"><div dir=3D"ltr">Hi i =
got this error when test FIO sequential write every time, in sequential rea=
d, random read, random write not got this.</div><div dir=3D"ltr"><br></div>=
<div dir=3D"ltr">my Linux distro is CentOS Linux release 7.5.1804 (Core)</d=
iv><div dir=3D"ltr">and my kernel version is 3.10.0-327.10.1.el7.x86_64</di=
v><div dir=3D"ltr"><br></div><div dir=3D"ltr">My output is:<br><br>job1: (g=
=3D0): rw=3Dwrite, bs=3D(R) 4096KiB-4096KiB, (W) 4096KiB-4096KiB, (T) 4096K=
iB-4096KiB, ioengine=3Dlibaio, iodepth=3D16<br>...<br>job1: (g=3D0): rw=3Dw=
rite, bs=3D(R) 4096KiB-4096KiB, (W) 4096KiB-4096KiB, (T) 4096KiB-4096KiB, i=
oengine=3Dlibaio, iodepth=3D16<br>...<br>job1: (g=3D0): rw=3Dwrite, bs=3D(R=
) 4096KiB-4096KiB, (W) 4096KiB-4096KiB, (T) 4096KiB-4096KiB, ioengine=3Dlib=
aio, iodepth=3D16<br>...<br>job1: (g=3D0): rw=3Dwrite, bs=3D(R) 4096KiB-409=
6KiB, (W) 4096KiB-4096KiB, (T) 4096KiB-4096KiB, ioengine=3Dlibaio, iodepth=
=3D16<br>...<br>job1: (g=3D0): rw=3Dwrite, bs=3D(R) 4096KiB-4096KiB, (W) 40=
96KiB-4096KiB, (T) 4096KiB-4096KiB, ioengine=3Dlibaio, iodepth=3D16<br>...<=
br>job1: (g=3D0): rw=3Dwrite, bs=3D(R) 4096KiB-4096KiB, (W) 4096KiB-4096KiB=
, (T) 4096KiB-4096KiB, ioengine=3Dlibaio, iodepth=3D16<br>...<br>fio-3.1<br=
>Starting 16 processes<br><br>job1: (groupid=3D0, jobs=3D16): err=3D 5 (fil=
e:io_u.c:1756, func=3Dio_u error, error=3DInput/output error): pid=3D10664:=
 Fri Sep=C2=A0 4 00:03:23 2015<br>=C2=A0 write: IOPS=3D319, BW=3D1279MiB/s =
(1341MB/s)(2559GiB/2048690msec)<br>=C2=A0=C2=A0=C2=A0 slat (usec): min=3D22=
7, max=3D101577k, avg=3D16698.60, stdev=3D395259.01<br>=C2=A0=C2=A0=C2=A0 c=
lat (msec): min=3D71, max=3D102013, avg=3D302.24, stdev=3D1524.49<br>=C2=A0=
=C2=A0=C2=A0=C2=A0 lat (msec): min=3D72, max=3D102014, avg=3D318.94, stdev=
=3D1574.94<br>=C2=A0=C2=A0=C2=A0 clat percentiles (msec):<br>=C2=A0=C2=A0=
=C2=A0=C2=A0 |=C2=A0 1.00th=3D[=C2=A0 136],=C2=A0 5.00th=3D[=C2=A0 161], 10=
.00th=3D[=C2=A0 180], 20.00th=3D[=C2=A0 209],<br>=C2=A0=C2=A0=C2=A0=C2=A0 |=
 30.00th=3D[=C2=A0 230], 40.00th=3D[=C2=A0 247], 50.00th=3D[=C2=A0 264], 60=
.00th=3D[=C2=A0 284],<br>=C2=A0=C2=A0=C2=A0=C2=A0 | 70.00th=3D[=C2=A0 305],=
 80.00th=3D[=C2=A0 330], 90.00th=3D[=C2=A0 376], 95.00th=3D[=C2=A0 430],<br=
>=C2=A0=C2=A0=C2=A0=C2=A0 | 99.00th=3D[=C2=A0 550], 99.50th=3D[=C2=A0 592],=
 99.90th=3D[=C2=A0 726], 99.95th=3D[=C2=A0 810],<br>=C2=A0=C2=A0=C2=A0=C2=
=A0 | 99.99th=3D[17113]<br>=C2=A0=C2=A0 bw (=C2=A0 KiB/s): min=3D 8308, max=
=3D403830, per=3D13.68%, avg=3D179223.36, stdev=3D54500.84, samples=3D15737=
<br>=C2=A0=C2=A0 iops=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : min=3D=C2=
=A0=C2=A0=C2=A0 2, max=3D=C2=A0=C2=A0 98, avg=3D43.32, stdev=3D13.35, sampl=
es=3D15737<br>=C2=A0 lat (msec)=C2=A0=C2=A0 : 100=3D0.01%, 250=3D27.42%, 50=
0=3D36.58%, 750=3D1.31%, 1000=3D0.03%<br>=C2=A0 lat (msec)=C2=A0=C2=A0 : 20=
00=3D0.01%, &gt;=3D2000=3D0.02%<br>=C2=A0 cpu=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 : usr=3D16.84%, sys=3D4.74%, ctx=3D199315, majf=3D=
0, minf=3D117471<br>=C2=A0 IO depths=C2=A0=C2=A0=C2=A0 : 1=3D0.1%, 2=3D0.1%=
, 4=3D0.1%, 8=3D0.1%, 16=3D1221.9%, 32=3D0.0%, &gt;=3D64=3D0.0%<br>=C2=A0=
=C2=A0=C2=A0=C2=A0 submit=C2=A0=C2=A0=C2=A0 : 0=3D0.0%, 4=3D100.0%, 8=3D0.0=
%, 16=3D0.0%, 32=3D0.0%, 64=3D0.0%, &gt;=3D64=3D0.0%<br>=C2=A0=C2=A0=C2=A0=
=C2=A0 complete=C2=A0 : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.1%, 32=3D0.0=
%, 64=3D0.0%, &gt;=3D64=3D0.0%<br>=C2=A0=C2=A0=C2=A0=C2=A0 issued rwt: tota=
l=3D0,655023,0, short=3D0,0,0, dropped=3D0,0,0<br>=C2=A0=C2=A0=C2=A0=C2=A0 =
latency=C2=A0=C2=A0 : target=3D0, window=3D0, percentile=3D100.00%, depth=
=3D16<br><br>Run status group 0 (all jobs):<br>=C2=A0 WRITE: bw=3D1279MiB/s=
 (1341MB/s), 1279MiB/s-1279MiB/s (1341MB/s-1341MB/s), io=3D2559GiB (2748GB)=
, run=3D2048690-2048690msec<br><br>Disk stats (read/write):<br>=C2=A0 sdb: =
ios=3D87/12938655, merge=3D0/0, ticks=3D62/1728507436, in_queue=3D172869235=
7, util=3D100.00%<br>=C2=A0 sdc: ios=3D43/12688086, merge=3D0/0, ticks=3D12=
/1680848678, in_queue=3D1680921305, util=3D100.00%<br>=C2=A0 sdd: ios=3D43/=
12793381, merge=3D0/0, ticks=3D9/1726297058, in_queue=3D1726441852, util=3D=
100.00%<br>=C2=A0 sde: ios=3D34/12824943, merge=3D0/0, ticks=3D9/1726084912=
, in_queue=3D1726194592, util=3D100.00%<br>=C2=A0 sdf: ios=3D0/1816141, mer=
ge=3D0/0, ticks=3D0/288898653, in_queue=3D300747577, util=3D100.00%<br>=C2=
=A0 sdg: ios=3D0/10970577, merge=3D0/0, ticks=3D0/1759675137, in_queue=3D17=
59784380, util=3D100.00%<br><br></div><div dir=3D"ltr">My parameter is :<br=
><br><br>[global]<br>readwrite=3Dwrite<br>blocksize=3D4m<br>direct=3D1<br>#=
numjobs=3D1<br>iodepth=3D16<br>ioengine=3Dlibaio<br>#filename=3D/dev/sdx<br=
>refill_buffers<br>time_based<br>runtime=3D600<br>ramp_time=3D10800<br>grou=
p_reporting<br><br>[job1]<br>numjobs=3D3<br>filename=3D/dev/sdb<br><br><br>=
[job2]<br>numjobs=3D2<br>filename=3D/dev/sdc<br><br><br>[job3]<br>numjobs=
=3D3<br>filename=3D/dev/sdd<br><br><br>[job4]<br>numjobs=3D3<br>filename=3D=
/dev/sde<br><br><br>[job5]<br>numjobs=3D2<br>filename=3D/dev/sdf<br><br><br=
>[job6]<br>numjobs=3D3<br>filename=3D/dev/sdg<br><br><br>.<br><br><br><br><=
br></div><div dir=3D"ltr">Why get err 5?<br></div><div dir=3D"ltr">thanks<b=
r></div></div>
</blockquote></div></div>

--000000000000f50749057259f3d7--
