Return-Path: <learner.study@gmail.com>
MIME-Version: 1.0
Date: Fri, 19 Jun 2009 15:19:26 -0700
Message-ID: <7efa8a7d0906191519l5b268430o3ec4c96e60dfcb7a@mail.gmail.com>
Subject: Ques on FIO output (how to interpret iops)
From: Learner Study <learner.study@gmail.com>
Content-Type: multipart/alternative; boundary=0016e64095dedd42d8046cbaea4a
To: fio@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>, learner.study@gmail.com
List-ID: <fio@vger.kernel.org>

--0016e64095dedd42d8046cbaea4a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi:

How do I calculate total IOPS done by different FIO threads/jobs?

Following is output from FIO (with two threads)...

Each thread shows "bw" and "iops" numbers. Towards the end of output log,
there is "aggrb" which is sum of individual "bw" of threads, but "io" field
(3 line from the bottom of output below) doesn't seem to be sum of
individual thread iops....

For example, Thread_1 has bw: 15k iops: 29366
Thread_2 has bw: 15k iops: 29445
But, the summary towards the end (third line from bottom of output), says
"io=1,723MiB, aggrb=30,105KiB/s".

In this aggrb is good but io doesn't match up (it should be 58781) ! Can
someone please educate what am I missing?

Thanks a lot!

================================== FIO Output
=========================================
[root@localhost fio-1.24]# ./1.sh
job1: (g=0): rw=read, bs=512-512/512-512, ioengine=libaio, iodepth=4000
job2: (g=0): rw=read, bs=512-512/512-512, ioengine=libaio, iodepth=4000
Starting 2 processes
Jobs: 2 (f=2): [RR] [100.0% done] [ 30609/     0 kb/s] [eta 00m:00s]
job1: (groupid=0, jobs=1): err= 0: pid=3389
  read : io=860MiB, bw=15,035KiB/s, iops=29,366, runt= 60003msec
    slat (usec): min=7, max=72,825, avg=20.43, stdev=219.35
    clat (msec): min=1, max=505, avg=136.08, stdev=43.51
    bw (KiB/s) : min= 4047, max=23724, per=49.91%, avg=15025.60,
stdev=3869.13
  cpu          : usr=14.77%, sys=70.29%, ctx=36920, majf=0, minf=514
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=0.1%,
>=64=100.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%,
>=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%,
>=64=0.1%
     issued r/w: total=1762085/0, short=0/0

     lat (msec): 2=0.01%, 4=0.01%, 10=0.01%, 20=0.02%, 50=0.03%
     lat (msec): 100=28.57%, 250=70.55%, 500=0.68%, 750=0.14%
job2: (groupid=0, jobs=1): err= 0: pid=3390
  read : io=863MiB, bw=15,076KiB/s, iops=29,445, runt= 60030msec
    slat (usec): min=7, max=90,307, avg=20.00, stdev=233.75
    clat (msec): min=28, max=617, avg=135.63, stdev=47.85
    bw (KiB/s) : min= 5039, max=23341, per=49.98%, avg=15047.44,
stdev=4046.40
  cpu          : usr=14.86%, sys=66.24%, ctx=35149, majf=0, minf=514
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=0.1%,
>=64=100.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%,
>=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%,
>=64=0.1%
     issued r/w: total=1767629/0, short=0/0

     lat (msec): 50=0.21%, 100=24.98%, 250=72.56%, 500=2.03%, 750=0.21%

Run status group 0 (all jobs):
   READ: io=1,723MiB, aggrb=30,105KiB/s, minb=15,035KiB/s, maxb=15,076KiB/s,
mint=60003msec, maxt=60030msec

Disk stats (read/write):
  sdb: ios=76944/0, merge=3452770/0, ticks=454753/0, in_queue=454712,
util=99.86%

--0016e64095dedd42d8046cbaea4a
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi:<br><br>How do I calculate total IOPS done by different FIO threads/jobs=
?<br><br>Following is output from FIO (with two threads)...<br><br>Each thr=
ead shows &quot;bw&quot; and &quot;iops&quot; numbers. Towards the end of o=
utput log, there is &quot;aggrb&quot; which is sum of individual &quot;bw&q=
uot; of threads, but &quot;io&quot; field (3 line from the bottom of output=
 below) doesn&#39;t seem to be sum of individual thread iops....<br>
<br>For example, Thread_1 has bw: 15k iops: 29366<br>Thread_2 has bw: 15k i=
ops: 29445 <br> But, the summary towards the end (third line from bottom of=
 output), says &quot;io=3D1,723MiB, aggrb=3D30,105KiB/s&quot;.<br><br>In th=
is aggrb is good but io doesn&#39;t match up (it should be 58781) ! Can som=
eone please educate what am I missing?<br>
<br>Thanks a lot!<br><br>=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D FIO Output =3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<br>[root@localhost fio-1.24]# ./1.s=
h<br>job1: (g=3D0): rw=3Dread, bs=3D512-512/512-512, ioengine=3Dlibaio, iod=
epth=3D4000<br>
job2: (g=3D0): rw=3Dread, bs=3D512-512/512-512, ioengine=3Dlibaio, iodepth=
=3D4000<br>Starting 2 processes<br>Jobs: 2 (f=3D2): [RR] [100.0% done] [ 30=
609/=A0=A0=A0=A0 0 kb/s] [eta 00m:00s]<br>job1: (groupid=3D0, jobs=3D1): er=
r=3D 0: pid=3D3389<br>=A0 read : io=3D860MiB, bw=3D15,035KiB/s, iops=3D29,3=
66, runt=3D 60003msec<br>
=A0=A0=A0 slat (usec): min=3D7, max=3D72,825, avg=3D20.43, stdev=3D219.35<b=
r>=A0=A0=A0 clat (msec): min=3D1, max=3D505, avg=3D136.08, stdev=3D43.51<br=
>=A0=A0=A0 bw (KiB/s) : min=3D 4047, max=3D23724, per=3D49.91%, avg=3D15025=
.60, stdev=3D3869.13<br>=A0 cpu=A0=A0=A0=A0=A0=A0=A0=A0=A0 : usr=3D14.77%, =
sys=3D70.29%, ctx=3D36920, majf=3D0, minf=3D514<br>
=A0 IO depths=A0=A0=A0 : 1=3D0.1%, 2=3D0.1%, 4=3D0.1%, 8=3D0.1%, 16=3D0.1%,=
 32=3D0.1%, &gt;=3D64=3D100.0%<br>=A0=A0=A0=A0 submit=A0=A0=A0 : 0=3D0.0%, =
4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=3D0.0%, &gt;=3D64=3D0.0%<br>=
=A0=A0=A0=A0 complete=A0 : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D=
0.0%, 64=3D0.0%, &gt;=3D64=3D0.1%<br>
=A0=A0=A0=A0 issued r/w: total=3D1762085/0, short=3D0/0<br><br>=A0=A0=A0=A0=
 lat (msec): 2=3D0.01%, 4=3D0.01%, 10=3D0.01%, 20=3D0.02%, 50=3D0.03%<br>=
=A0=A0=A0=A0 lat (msec): 100=3D28.57%, 250=3D70.55%, 500=3D0.68%, 750=3D0.1=
4%<br>job2: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D3390<br>
=A0 read : io=3D863MiB, bw=3D15,076KiB/s, iops=3D29,445, runt=3D 60030msec<=
br>=A0=A0=A0 slat (usec): min=3D7, max=3D90,307, avg=3D20.00, stdev=3D233.7=
5<br>=A0=A0=A0 clat (msec): min=3D28, max=3D617, avg=3D135.63, stdev=3D47.8=
5<br>=A0=A0=A0 bw (KiB/s) : min=3D 5039, max=3D23341, per=3D49.98%, avg=3D1=
5047.44, stdev=3D4046.40<br>
=A0 cpu=A0=A0=A0=A0=A0=A0=A0=A0=A0 : usr=3D14.86%, sys=3D66.24%, ctx=3D3514=
9, majf=3D0, minf=3D514<br>=A0 IO depths=A0=A0=A0 : 1=3D0.1%, 2=3D0.1%, 4=
=3D0.1%, 8=3D0.1%, 16=3D0.1%, 32=3D0.1%, &gt;=3D64=3D100.0%<br>=A0=A0=A0=A0=
 submit=A0=A0=A0 : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, &gt;=3D64=3D0.0%<br>
=A0=A0=A0=A0 complete=A0 : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D=
0.0%, 64=3D0.0%, &gt;=3D64=3D0.1%<br>=A0=A0=A0=A0 issued r/w: total=3D17676=
29/0, short=3D0/0<br><br>=A0=A0=A0=A0 lat (msec): 50=3D0.21%, 100=3D24.98%,=
 250=3D72.56%, 500=3D2.03%, 750=3D0.21%<br><br>Run status group 0 (all jobs=
):<br>
=A0=A0 READ: io=3D1,723MiB, aggrb=3D30,105KiB/s, minb=3D15,035KiB/s, maxb=
=3D15,076KiB/s, mint=3D60003msec, maxt=3D60030msec<br><br>Disk stats (read/=
write):<br>=A0 sdb: ios=3D76944/0, merge=3D3452770/0, ticks=3D454753/0, in_=
queue=3D454712, util=3D99.86%<br>
<br>

--0016e64095dedd42d8046cbaea4a--


