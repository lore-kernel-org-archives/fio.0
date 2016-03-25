Return-Path: <tbertaud@conforama.fr>
From: Thierry BERTAUD <tbertaud@conforama.fr>
Subject: RE: IO mixed : 12% seqread, 8% seqwrite, 80% random (30% W, 70%R)
Date: Fri, 25 Mar 2016 06:33:48 +0000
Message-ID: <HE1PR05MB178780CACBC2631A841BB3FDB1830@HE1PR05MB1787.eurprd05.prod.outlook.com>
References: <HE1PR05MB17878EE04B3D85CD447FFBD7B1800@HE1PR05MB1787.eurprd05.prod.outlook.com>
 <CANvN+enipwNVDS4QSsgh67FkpL-EoBsW0j0XRj5F2qSc7w+83A@mail.gmail.com>
 <HE1PR05MB1787EB4BBDE5DE3867EE47D5B1810@HE1PR05MB1787.eurprd05.prod.outlook.com>
 <CANvN+enHQqeXyimRCNnPS5Bp+hc+apVN5+-sKH8HLN=LhyeHHw@mail.gmail.com>
 <HE1PR05MB17875B7FE235655AB2A81519B1810@HE1PR05MB1787.eurprd05.prod.outlook.com>,<56F4BB3E.6050205@kernel.dk>
In-Reply-To: <56F4BB3E.6050205@kernel.dk>
Content-Language: fr-FR
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>, Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

Hi Jens,

Sorry my update lacked precision. I want to tell that the output of my comm=
and is not correct because the IO profile is the same at  70% randread and =
30%randwrite (graph from SAN tools).
I don't want to tell that the Andrey explanation is wrong.

I tried this but it seems the problem is that i don't understand the docume=
ntation so it's why i don't have that i expect.
# cat test.conf
[global]
ioengine=3Dposixaio
invalidate=3D0
norandommap
ramp_time=3D5
iodepth=3D8
runtime=3D60
time_based
direct=3D1
numjobs=3D1
group_reporting
filesize=3D103M
blocksize=3D8k
#rw=3Drandrw
rwmixread=3D70
percentage_random=3D12,8

[hdisk2]
stonewall
filename=3D/dev/rhdisk2
# ./fio test.conf
hdisk2: (g=3D0): rw=3Dread, bs=3D8K-8K/8K-8K/8K-8K, ioengine=3Dposixaio, io=
depth=3D8
fio-2.3
Starting 1 process
Jobs: 1 (f=3D1): [R(1)] [100.0% done] [217.2MB/0KB/0KB /s] [27.8K/0/0 iops]=
 [eta 00m:00s]
hdisk2: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D213240: Fri Mar 25 07:27:4=
7 2016
  read : io=3D12872MB, bw=3D219671KB/s, iops=3D27458, runt=3D 60001msec
    slat (usec): min=3D14, max=3D9705, avg=3D28.74, stdev=3D34.99
    clat (usec): min=3D2, max=3D10363, avg=3D221.22, stdev=3D48.30
     lat (usec): min=3D144, max=3D10382, avg=3D249.52, stdev=3D50.07
    clat percentiles (usec):
     |  1.00th=3D[  149],  5.00th=3D[  165], 10.00th=3D[  175], 20.00th=3D[=
  189],
     | 30.00th=3D[  201], 40.00th=3D[  211], 50.00th=3D[  221], 60.00th=3D[=
  231],
     | 70.00th=3D[  241], 80.00th=3D[  251], 90.00th=3D[  266], 95.00th=3D[=
  282],
     | 99.00th=3D[  310], 99.50th=3D[  326], 99.90th=3D[  362], 99.95th=3D[=
  386],
     | 99.99th=3D[  466]
    bw (KB  /s): min=3D    4, max=3D225344, per=3D99.17%, avg=3D217851.37, =
stdev=3D20237.94
    lat (usec) : 4=3D0.01%, 10=3D0.01%, 50=3D0.01%, 100=3D0.01%, 250=3D78.5=
6%
    lat (usec) : 500=3D21.42%, 750=3D0.01%, 1000=3D0.01%
    lat (msec) : 4=3D0.01%, 10=3D0.01%, 20=3D0.01%
  cpu          : usr=3D8.22%, sys=3D28.38%, ctx=3D0, majf=3D0, minf=3D0
  IO depths    : 1=3D0.1%, 2=3D0.2%, 4=3D68.4%, 8=3D37.6%, 16=3D0.0%, 32=3D=
0.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D99.5%, 8=3D0.5%, 16=3D0.0%, 32=3D0.0%, 64=3D=
0.0%, >=3D64=3D0.0%
     issued    : total=3Dr=3D1647553/w=3D0/d=3D0, short=3Dr=3D0/w=3D0/d=3D0=
, drop=3Dr=3D0/w=3D0/d=3D0
     latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D8

Run status group 0 (all jobs):
   READ: io=3D12872MB, aggrb=3D219671KB/s, minb=3D219671KB/s, maxb=3D219671=
KB/s, mint=3D60001msec, maxt=3D60001msec
#

Regards,
Thierry=

