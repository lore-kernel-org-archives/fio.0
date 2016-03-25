Return-Path: <tbertaud@conforama.fr>
From: Thierry BERTAUD <tbertaud@conforama.fr>
Subject: RE: IO mixed : 12% seqread, 8% seqwrite, 80% random (30% W, 70%R)
Date: Fri, 25 Mar 2016 20:20:51 +0000
Message-ID: <HE1PR05MB17878F1F9FF0A2515C361F84B1830@HE1PR05MB1787.eurprd05.prod.outlook.com>
References: <HE1PR05MB17878EE04B3D85CD447FFBD7B1800@HE1PR05MB1787.eurprd05.prod.outlook.com>
 <CANvN+enipwNVDS4QSsgh67FkpL-EoBsW0j0XRj5F2qSc7w+83A@mail.gmail.com>
 <HE1PR05MB1787EB4BBDE5DE3867EE47D5B1810@HE1PR05MB1787.eurprd05.prod.outlook.com>
 <CANvN+enHQqeXyimRCNnPS5Bp+hc+apVN5+-sKH8HLN=LhyeHHw@mail.gmail.com>
 <HE1PR05MB17875B7FE235655AB2A81519B1810@HE1PR05MB1787.eurprd05.prod.outlook.com>
 <56F4BB3E.6050205@kernel.dk>
 <HE1PR05MB178780CACBC2631A841BB3FDB1830@HE1PR05MB1787.eurprd05.prod.outlook.com>,<56F55429.1090506@kernel.dk>
In-Reply-To: <56F55429.1090506@kernel.dk>
Content-Language: fr-FR
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>, Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

Hi Jens,

Thanks for update.

>Fio can't do a double split like that in a single job, but if you can
>tolerate mixing the 60/40 and 70/30 read/write between sequential and
>random, then you can make it work.

>Or you can split it in two jobs, one doing the sequential part and the
>other the random. The you can use the flow parameters to pace them at
>20/80 ratios.

I tried to use choice 2.
------------------------------
[global]
ioengine=3Dposixaio
invalidate=3D0
norandommap
ramp_time=3D5
iodepth=3D8
runtime=3D10
time_based
direct=3D1
#numjobs=3D1
group_reporting
filesize=3D10M
blocksize=3D8k

[hdisk2]
stonewall
filename=3D/dev/rhdisk2
rw=3Dreadwrite
rwmixread=3D60
flow=3D2

[hdisk2a]
stonewall
filename=3D/dev/rhdisk2
rw=3Drandrw
rwmixread=3D70
flow=3D8
------------------------------
# ./fio inftest.conf
hdisk2: (g=3D0): rw=3Drw, bs=3D8K-8K/8K-8K/8K-8K, ioengine=3Dposixaio, iode=
pth=3D8
hdisk2a: (g=3D1): rw=3Drandrw, bs=3D8K-8K/8K-8K/8K-8K, ioengine=3Dposixaio,=
 iodepth=3D8
fio-2.3
Starting 2 processes
Jobs: 1 (f=3D0): [/(1),P(1)] [-.-% done] [0KB/0KB/0KB /s] [0/0/0 iops] [eta=
 00m:30s]
..

The fio process eat a lot of cpu but no disk activity. Some output from top=
as. So i think i don't use correctly the flow parmeter and perhaps do some =
loops somewhere into fio.
------------------
CPU  User%  Kern%  Wait%  Idle%                =20
ALL   46.9   53.1    0.0    0.0=20

Disk    Busy%     KBPS     TPS KB-Read KB-Writ
hdisk2    0.0     0.0      0.0    0.0     0.0

Name            PID  CPU%  PgSp Owner
fio          504000  46.8   0.3 root
sshd         549094  28.6   1.0 root
fio          393304  24.0   0.2 root
topas        462868   0.1   1.9 root
--------------------------------------


If i do a ctrl+c, i have the following:

# ./fio inftest.conf
hdisk2: (g=3D0): rw=3Drw, bs=3D8K-8K/8K-8K/8K-8K, ioengine=3Dposixaio, iode=
pth=3D8
hdisk2a: (g=3D1): rw=3Drandrw, bs=3D8K-8K/8K-8K/8K-8K, ioengine=3Dposixaio,=
 iodepth=3D8
fio-2.3
Starting 2 processes
Jobs: 1 (f=3D0): [/(1),P(1)] [-.-% done] [0KB/0KB/0KB /s] [0/0/0 iops] [eta=
 00m:30s]
fio: terminating on signal 2

fio: terminating on signal 2
Jobs: 0 (f=3D0): [/(1),P(1)] [-.-% done] [0KB/0KB/0KB /s] [0/0/0 iops] [eta=
 00m:30s]
hdisk2: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D504000: Fri Mar 25 21:19:5=
2 2016
  read : io=3D32768B, bw=3D32000KB/s, iops=3D0, runt=3D     1msec
    slat (usec): min=3D16, max=3D194, avg=3D25.25, stdev=3D15.63
    clat percentiles (usec):
     |  1.00th=3D[    0],  5.00th=3D[    0], 10.00th=3D[    0], 20.00th=3D[=
    0],
     | 30.00th=3D[    0], 40.00th=3D[    0], 50.00th=3D[    0], 60.00th=3D[=
    0],
     | 70.00th=3D[    0], 80.00th=3D[    0], 90.00th=3D[    0], 95.00th=3D[=
    0],
     | 99.00th=3D[    0], 99.50th=3D[    0], 99.90th=3D[    0], 99.95th=3D[=
    0],
     | 99.99th=3D[    0]
  write: io=3D16384B, bw=3D16000KB/s, iops=3D0, runt=3D     1msec
    slat (usec): min=3D16, max=3D105, avg=3D26.12, stdev=3D13.44
    clat percentiles (usec):
     |  1.00th=3D[    0],  5.00th=3D[    0], 10.00th=3D[    0], 20.00th=3D[=
    0],
     | 30.00th=3D[    0], 40.00th=3D[    0], 50.00th=3D[    0], 60.00th=3D[=
    0],
     | 70.00th=3D[    0], 80.00th=3D[    0], 90.00th=3D[    0], 95.00th=3D[=
    0],
     | 99.00th=3D[    0], 99.50th=3D[    0], 99.90th=3D[    0], 99.95th=3D[=
    0],
     | 99.99th=3D[    0]
  cpu          : usr=3D0.00%, sys=3D0.00%, ctx=3D0, majf=3D0, minf=3D0
  IO depths    : 1=3D0.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.=
0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D98.0%, 8=3D2.0%, 16=3D0.0%, 32=3D0.0%, 64=3D=
0.0%, >=3D64=3D0.0%
     issued    : total=3Dr=3D0/w=3D0/d=3D0, short=3Dr=3D0/w=3D0/d=3D0, drop=
=3Dr=3D0/w=3D0/d=3D0
     latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D8

Run status group 0 (all jobs):
   READ: io=3D32KB, aggrb=3D32000KB/s, minb=3D32000KB/s, maxb=3D32000KB/s, =
mint=3D1msec, maxt=3D1msec
  WRITE: io=3D16KB, aggrb=3D16000KB/s, minb=3D16000KB/s, maxb=3D16000KB/s, =
mint=3D1msec, maxt=3D1msec

Run status group 1 (all jobs):
#

Regards,
Thierry



