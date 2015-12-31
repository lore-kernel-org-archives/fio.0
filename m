Return-Path: <tbertaud@conforama.fr>
From: Thierry BERTAUD <tbertaud@conforama.fr>
Subject: RE: fio-2c2c93d and with a lot of numjobs causing fio Jobs to Time
 Out
Date: Thu, 31 Dec 2015 16:18:55 +0000
Message-ID: <VI1PR05MB13439C4033DED096900CDF30B1FE0@VI1PR05MB1343.eurprd05.prod.outlook.com>
References: <VI1PR05MB13437814C9CD31D2CECE7398B1FC0@VI1PR05MB1343.eurprd05.prod.outlook.com>
 <56840F80.4060903@kernel.dk>
 <VI1PR05MB13435F5190D9D9A17C59315BB1FD0@VI1PR05MB1343.eurprd05.prod.outlook.com>,<5684A8F1.6010105@kernel.dk>
In-Reply-To: <5684A8F1.6010105@kernel.dk>
Content-Language: fr-FR
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>, Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
List-ID: <fio@vger.kernel.org>

Hi Jens and Andrey,

>I'll be taking a bit of time off, but I should have access to an AIX
>that I can test on sometime next week. What version are you on?

At this time i use a VIOS 2.2.3.52  aka AIX 6100-08-01-1245. I need to buil=
d fio against AIX 6.x, 7.x.=20
After next week, i'll reinstall the server to go to production. So i'll nee=
d to look for a new box with a FC card so i'll use another AIX version.

For your information i don't have the issue with:
HDISK=3Dhdisk6 RWTYPE=3Drw RRATIO=3D0 BS=3D4096 QD=3D128 NJ=3D128  /home/pa=
dmin/fio/fio-5f3bd0f/fio myfio.fio
but
HDISK=3Dhdisk6 RWTYPE=3Drw RRATIO=3D0 BS=3D65536 QD=3D128 NJ=3D128  /home/p=
admin/fio/fio-5f3bd0f/fio myfio.fio

So i think it's perhaps some hardware or OS comportement that the cause of =
the issue it's not fio fio  (it's not the guilty but a collateral victim) b=
ut idon't find why because the statistics data from SAN seems OK.
SAN stats during test:
Latency (ms):      R: 0/ W 0.17=20
Thoughput (M): R 0  / W 9.8
IOPS:                    R 0 / W 2380


1. fIo stay stuck with the last print:
   fio: job 'test' hasn't exited in 97 seconds, it appears to be stuck. Doi=
ng forceful exit of this job.

1.1 The only process that's stay a live is the min fio process (all others =
128 childs have been died or finished)
# ps -ef | grep fio | grep -v grep
    root 41877588 48234628 120 16:18:23  pts/1  1:20 /home/padmin/fio/fio-5=
f3bd0f/fio myfio.fio
#

1.3 System monitor indicate no disk activty test is over but the main proce=
ss uses CPU.
   Topas Monitor for host:    XVIOS16          =20
   Thu Dec 31 16:28:19 2015   Interval:  2     =20
                                               =20
   CPU  User%  Kern%  Wait%  Idle%  Physc   Entc
   ALL   57.4    5.8    0.0   36.8   1.01  101.5

   Disk    Busy%     KBPS     TPS KB-Read KB-Writ
   hdisk3    0.0     0.0      0.0    0.0     0.0=20
   hdisk2    0.0     0.0      0.0    0.0     0.0=20
   hdisk9    0.0     0.0      0.0    0.0     0.0=20
   hdisk1    0.0     0.0      0.0    0.0     0.0=20
   hdisk0    0.0     0.0      0.0    0.0     0.0=20
   hdisk10   0.0     0.0      0.0    0.0     0.0=20
   hdisk7    0.0     0.0      0.0    0.0     0.0=20
   hdisk4    0.0     0.0      0.0    0.0     0.0=20
   hdisk5    0.0     0.0      0.0    0.0     0.0=20
   hdisk6    0.0     0.0      0.0    0.0     0.0=20

   Name            PID  CPU%  PgSp Owner
   fio        41877588  62.6   3.5 root=20
   sched        196614   0.1   0.4 root
   vio_daem   10682558   0.0  46.1 root
   seaproc     3997822   0.0   1.0 root
   syncd       3538998   0.0   0.6 root
   java        9764964   0.0  84.2 root

1.5 During gdb against the process the cpu load disapear. If i don't dgb ag=
ainst the process the load stay alive.

2. 1:  gdb trace
   # gdb -p 41877588
   GNU gdb (GDB) 7.8.1
   Copyright (C) 2014 Free Software Foundation, Inc.
   License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.=
html>
   This is free software: you are free to change and redistribute it.
   There is NO WARRANTY, to the extent permitted by law.  Type "show copyin=
g"
   and "show warranty" for details.
   This GDB was configured as "powerpc-ibm-aix5.1.0.0".
   Type "show configuration" for configuration details.
   For bug reporting instructions, please see:
   <http://www.gnu.org/software/gdb/bugs/>.
   Find the GDB manual and other documentation resources online at:
   <http://www.gnu.org/software/gdb/documentation/>.
   For help, type "help".
   Type "apropos word" to search for commands related to "word".
   Attaching to process 41877588
   0xd0119598 in ?? ()
   (gdb) info threads
     Id   Target Id         Frame
   * 1    process 41877588  0xd0119598 in ?? ()
   (gdb) thread 1
   [Switching to thread 1 (process 41877588)]
   #0  0xd0119598 in ?? ()
   (gdb) bt
   #0  0xd0119598 in ?? ()
   #1  0xffffffff in ?? ()
   #2  0xd0119bc0 in ?? ()
   #3  0xd0118f28 in ?? ()
   #4  0x100625dc in ?? ()
   #5  0x1006482c in ?? ()
   #6  0x10064b90 in ?? ()
   #7  0xd0505c10 in ?? ()
   #8  0x00000000 in ?? ()
   (gdb)

2.1.1 It semmes i nned to build fio with some option to have some symbole. =
Which option i can use for that.
At this time i just do: ./configure; gmake CC=3Dgcc

2.2: The full log from fio:
   # HDISK=3Dhdisk6 RWTYPE=3Drw RRATIO=3D0 BS=3D65536 QD=3D128 NJ=3D128  /h=
ome/padmin/fio/fio-5f3bd0f/fio myfio.fio
   test: (g=3D0): rw=3Drw, bs=3D64K-64K/64K-64K/64K-64K, ioengine=3Dposixai=
o, iodepth=3D128
   ...
   fio-2.3
   Starting 128 processes
   fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doi=
ng forceful exit of this job.:22s]
   fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doi=
ng forceful exit of this job.
   fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doi=
ng forceful exit of this job. iops] [eta 11m:34s]
   fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doi=
ng forceful exit of this job.] [0/138/0 iops] [eta 17m:34s]
   fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doi=
ng forceful exit of this job.
   fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doi=
ng forceful exit of this job.4KB/0KB /s] [0/215/0 iops] [eta 29m:36s]
   fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doi=
ng forceful exit of this job.4.6% done] [0KB/7488KB/0KB /s] [0/117/0 iops] =
[eta 35m:36s]
   fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doi=
ng forceful exit of this job.1),W(21)] [12.8% done] [0KB/8617KB/0KB /s] [0/=
134/0 iops] [eta 41m:40s]
   fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doi=
ng forceful exit of this job.1),W(38)] [11.4% done] [0KB/856KB/0KB /s] [0/1=
3/0 iops] [eta 47m:44s]
   fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doi=
ng forceful exit of this job.
   Jobs: 118 (f=3D118): [f(1),W(8),_(1),W(11),_(1),W(2),f(1),W(5),_(1),W(9)=
,_(1),W(7),_(1),W(12),_(1),W(6),_(1),W(11),_(1),W(2),_(1),W(5),_(1),W(38)] =
[9.3% done] [0KB/20057KB/0KB fio: job 'test' hasn't exited in 60 seconds, i=
t appears to be stuck. Doing forceful exit of this job.
   Jobs: 117 (f=3D117): [W(9),_(1),W(11),_(1),W(8),_(1),W(9),_(1),W(4),f(1)=
,W(2),_(1),W(1),_(1),W(10),_(1),W(6),_(1),W(11),_(1),W(2),_(1),W(5),_(1),W(=
38)] [8.5% done] [0KB/7255KB/fio: job 'test' hasn't exited in 60 seconds, i=
t appears to be stuck. Doing forceful exit of this job.
   Jobs: 116 (f=3D116): [W(3),_(1),W(5),_(1),W(11),_(1),W(8),_(1),W(9),_(1)=
,W(7),_(1),W(1),_(1),W(10),_(1),W(6),_(1),W(11),_(1),W(2),_(1),W(5),_(1),W(=
38)] [7.9% done] [0KB/1130KB/Jobs: 116 (f=3D116): [W(2),f(1),_(1),W(5),_(1)=
,W(2),f(1),W(8),_(1),W(8),_(1),W(4),f(1),W(4),_(1),W(7),_(1),W(1),_(1),W(10=
),_(1),W(6),_(1),W(11),_(1),W(2),_(1),W(5),_(1),W(38)] Jobs: 116 (f=3D116):=
 [W(3),_(1),W(5),_(1),W(1),f(1),W(9),_(1),W(8),_(1),W(4),f(1),W(4),_(1),W(7=
),_(1),W(1),_(1),W(10),_(1),W(6),_(1),W(11),_(1),W(2),_(1),W(5),_(1),W(38)]=
 [7.9%Jobs: 116 (f=3D116): [W(3),_(1),W(5),_(1),W(11),_(1),W(8),_(1),W(9),_=
(1),W(7),_(1),W(1),_(1),W(10),_(1),W(6),_(1),W(11),_(1),W(2),_(1),W(5),_(1)=
,W(38)] [7.9% done] [0KB/0KB/0KBfio: job 'test' hasn't exited in 60 seconds=
, it appears to be stuck. Doing forceful exit of this job.
   Jobs: 115 (f=3D115): [W(3),_(1),W(5),_(1),W(11),_(1),W(3),f(1),W(4),_(1)=
,W(9),_(1),W(7),_(1),W(1),_(1),W(1),f(1),W(8),_(1),W(6),_(1),W(11),_(1),W(2=
),_(1),W(5),_(1),W(36),_(1),WJobs: 115 (f=3D115): [W(3),_(1),W(5),_(1),W(11=
),_(1),W(8),_(1),W(9),_(1),W(7),_(1),W(1),_(1),W(10),_(1),W(6),_(1),W(6),f(=
1),W(4),_(1),W(2),_(1),W(5),_(1),W(36),_(1),W(1)] [7.4%fio: job 'test' hasn=
't exited in 60 seconds, it appears to be stuck. Doing forceful exit of thi=
s job.
   Jobs: 114 (f=3D114): [W(3),_(1),W(5),_(1),W(4),f(1),W(6),_(1),W(8),_(1),=
W(9),_(1),W(7),_(1),W(1),_(1),W(10),_(1),W(6),_(1),W(11),_(1),W(2),_(1),W(3=
),_(1),W(1),_(1),W(36),_(1),Wfio: job 'test' hasn't exited in 60 seconds, i=
t appears to be stuck. Doing forceful exit of this job.
   Jobs: 113 (f=3D113): [W(3),_(1),W(5),_(1),W(11),_(1),W(6),f(1),W(1),_(1)=
,W(9),_(1),W(7),_(1),W(1),_(1),W(10),_(1),W(6),_(1),W(11),_(1),W(2),_(1),W(=
1),_(1),W(1),_(1),W(1),_(1),WJobs: 113 (f=3D113): [W(3),_(1),W(5),_(1),W(11=
),_(1),W(6),f(1),W(1),_(1),W(2),f(2),W(5),_(1),W(7),_(1),W(1),_(1),f(1),W(9=
),_(1),W(6),_(1),W(11),_(1),W(2),_(1),W(1),_(1),W(1),_(Jobs: 113 (f=3D113):=
 [W(3),_(1),W(5),_(1),W(11),_(1),W(8),_(1),W(2),f(2),W(5),_(1),W(7),_(1),W(=
1),_(1),f(1),W(9),_(1),W(6),_(1),W(11),_(1),W(2),_(1),W(1),_(1),W(1),_(1),W=
(1),_(fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck. =
Doing forceful exit of this job.
   fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doi=
ng forceful exit of this job.
   Jobs: 111 (f=3D111): [W(3),_(1),W(5),_(1),W(11),_(1),W(7),f(1),_(1),W(9)=
,_(2),W(6),_(1),W(1),_(1),W(3),_(1),W(6),_(1),W(6),_(1),W(11),_(1),W(2),_(1=
),W(1),_(1),W(1),_(1),W(1),_(fio: job 'test' hasn't exited in 60 seconds, i=
t appears to be stuck. Doing forceful exit of this job.
   fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doi=
ng forceful exit of this job.
   Jobs: 110 (f=3D110): [W(3),_(1),W(5),_(1),W(10),f(1),_(1),W(8),_(1),W(9)=
,_(2),W(6),_(1),W(1),_(1),W(3),_(1),W(6),_(1),W(6),_(1),W(11),_(1),W(2),_(1=
),W(1),_(1),W(1),_(1),W(1),_(Jobs: 109 (f=3D109): [W(3),_(1),f(1),W(4),_(1)=
,W(10),f(1),_(1),W(8),_(1),W(9),_(2),W(6),_(1),W(1),_(1),W(3),_(1),W(6),_(1=
),W(6),_(1),W(11),_(1),W(2),_(1),W(1),_(1),W(1),_(1),W(fio: job 'test' hasn=
't exited in 60 seconds, it appears to be stuck. Doing forceful exit of thi=
s job.:55m:38s]
   Jobs: 108 (f=3D108): [W(3),_(1),f(1),W(2),f(1),W(1),_(1),W(7),f(1),W(3),=
_(1),W(8),_(1),W(9),_(2),W(6),_(1),W(1),_(1),W(3),_(1),W(2),f(1),W(3),_(1),=
W(6),_(1),W(8),_(1),W(2),_(1)fio: job 'test' hasn't exited in 60 seconds, i=
t appears to be stuck. Doing forceful exit of this job./0KB /s] [0/142/0 io=
ps] [eta 02h:01m:37s]
   Jobs: 107 (f=3D107): [W(3),_(1),W(5),_(1),W(11),_(1),W(5),_(1),W(2),_(1)=
,W(9),_(2),W(6),_(1),W(1),_(1),W(3),_(1),W(6),_(1),W(6),_(1),W(8),_(1),W(2)=
,_(1),W(2),_(1),W(1),_(1),W(1Jobs: 107 (f=3D107): [W(3),_(1),W(5),_(1),W(11=
),_(1),W(5),_(1),W(2),_(1),W(9),_(2),W(6),_(1),W(1),_(1),W(3),_(1),W(6),_(1=
),W(6),_(1),W(8),_(1),W(2),_(1),W(2),_(1),W(1),_(1),W(1fio: job 'test' hasn=
't exited in 60 seconds, it appears to be stuck. Doing forceful exit of thi=
s job.eta 02h:07m:35s]
   Jobs: 106 (f=3D106): [W(3),_(1),W(5),_(1),W(6),f(1),W(1),f(1),W(2),_(1),=
W(5),_(1),W(2),_(1),W(7),f(1),W(1),_(2),W(6),_(1),W(1),_(1),W(3),_(1),W(6),=
_(1),W(6),_(1),W(8),_(1),W(2)Jobs: 106 (f=3D106): [W(3),_(1),W(5),_(1),W(11=
),_(1),W(5),_(1),W(2),_(1),W(9),_(2),W(6),_(1),W(1),_(1),W(3),_(1),W(6),_(1=
),W(6),_(1),W(8),_(1),W(2),_(1),W(2),_(1),W(1),_(1),W(1fio: job 'test' hasn=
't exited in 60 seconds, it appears to be stuck. Doing forceful exit of thi=
s job.42/0 iops] [eta 02h:13m:57s]
   Jobs: 105 (f=3D105): [W(3),_(1),W(5),_(1),W(11),_(1),W(5),_(1),W(2),_(1)=
,W(9),_(2),W(6),_(1),W(1),_(1),W(3),_(2),W(5),_(1),W(6),_(1),W(8),_(1),W(2)=
,_(1),W(2),_(1),W(1),_(1),W(1Jobs: 105 (f=3D105): [W(3),_(1),W(5),_(1),W(11=
),_(1),W(5),_(1),W(2),_(1),W(9),_(2),W(6),_(1),W(1),_(1),W(3),_(2),W(2),f(1=
),W(2),_(1),W(6),_(1),W(8),_(1),W(2),_(1),W(2),_(1),W(1fio: job 'test' hasn=
't exited in 60 seconds, it appears to be stuck. Doing forceful exit of thi=
s job.3/0 iops] [eta 02h:19m:56s]
   Jobs: 104 (f=3D104): [W(3),_(1),W(5),_(1),W(11),_(1),W(5),_(1),W(2),_(1)=
,W(9),_(2),W(6),_(1),W(1),_(1),W(3),_(2),W(2),f(1),W(2),_(1),W(3),_(1),W(2)=
,_(1),W(8),_(1),W(2),_(1),W(1fio: job 'test' hasn't exited in 60 seconds, i=
t appears to be stuck. Doing forceful exit of this job.B/0KB /s] [0/136/0 i=
ops] [eta 02h:26m:24s]
   Jobs: 103 (f=3D103): [W(3),_(1),W(5),_(1),W(11),_(1),W(5),_(1),W(2),_(1)=
,W(9),_(2),W(6),_(1),W(1),_(1),W(3),_(2),W(5),_(1),W(3),_(1),W(2),_(1),W(8)=
,_(1),W(2),_(1),W(1),f(1),_(1Jobs: 103 (f=3D103): [W(3),_(1),W(5),_(1),W(11=
),_(1),W(5),_(1),W(2),_(1),W(9),_(2),W(6),_(1),W(1),_(1),W(3),_(2),W(5),_(1=
),W(3),_(1),W(2),_(1),W(8),_(1),W(2),_(1),W(2),_(1),W(1fio: job 'test' hasn=
't exited in 60 seconds, it appears to be stuck. Doing forceful exit of thi=
s job.ops] [eta 02h:32m:22s]
   Jobs: 103 (f=3D103): [W(3),_(1),W(5),_(1),W(11),_(1),W(5),_(1),W(2),_(1)=
,W(9),_(2),W(6),_(1),W(1),_(1),W(3),_(2),W(5),_(1),W(2),f(1),_(1),W(2),_(1)=
,W(8),_(1),W(2),_(1),W(2),_(1fio: job 'test' hasn't exited in 60 seconds, i=
t appears to be stuck. Doing forceful exit of this job. [0/205/0 iops] [eta=
 02h:38m:22s]
   fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doi=
ng forceful exit of this job.
   fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doi=
ng forceful exit of this job.
   fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doi=
ng forceful exit of this job.
   fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doi=
ng forceful exit of this job.
   Jobs: 97 (f=3D97): [W(3),_(1),W(5),_(1),W(11),_(1),W(5),_(1),W(2),_(1),W=
(9),_(2),W(6),_(3),W(3),_(2),W(5),_(1),W(3),_(1),W(2),_(2),W(7),_(1),W(2),_=
(1),W(2),_(1),W(1),_(1),W(1),Jobs: 97 (f=3D97): [W(3),_(1),W(5),_(1),W(11),=
_(1),W(5),_(1),W(2),_(1),W(9),_(2),W(6),_(3),W(3),_(2),W(5),_(1),W(3),_(1),=
W(2),_(2),W(6),f(1),_(1),W(2),_(1),W(2),_(1),W(1),_(1),Jobs: 97 (f=3D97): [=
W(3),_(1),W(5),_(1),W(11),_(1),W(5),_(1),W(2),_(1),W(9),_(2),W(6),_(3),W(3)=
,_(2),W(5),_(1),W(3),_(1),W(2),_(2),W(7),_(1),W(2),_(1),W(2),_(1),W(1),_(1)=
,W(1),fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck. =
Doing forceful exit of this job./0KB /s] [0/0/0 iops] [eta 03h:08m:26s]
   fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doi=
ng forceful exit of this job.
   fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doi=
ng forceful exit of this job.
   Jobs: 94 (f=3D94): [W(3),_(1),W(4),f(1),_(1),W(11),_(1),W(5),_(1),W(2),_=
(1),f(1),W(8),_(2),W(6),_(3),W(3),_(2),W(5),_(1),W(3),_(1),W(2),_(2),W(7),_=
(1),W(2),_(1),W(2),_(1),W(1),fio: job 'test' hasn't exited in 60 seconds, i=
t appears to be stuck. Doing forceful exit of this job. done] [0KB/14019KB/=
0KB /s] [0/219/0 iops] [eta 03h:26m:33s]
   fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doi=
ng forceful exit of this job.
   Jobs: 92 (f=3D92): [W(3),_(1),W(4),f(1),_(1),W(11),_(1),W(5),_(1),W(2),_=
(1),f(1),W(8),_(2),W(6),_(3),W(3),_(2),W(5),_(1),W(3),_(1),W(2),_(2),W(7),_=
(1),W(2),_(1),W(2),_(1),W(1),fio: job 'test' hasn't exited in 60 seconds, i=
t appears to be stuck. Doing forceful exit of this job.(2)] [2.9% done] [0K=
B/1593KB/0KB /s] [0/24/0 iops] [eta 03h:38m:38s]
   Jobs: 91 (f=3D91): [W(3),_(1),W(5),_(1),W(11),_(1),W(5),_(1),W(2),_(1),W=
(9),_(2),W(6),_(3),W(3),_(2),W(5),_(1),W(3),_(1),W(2),_(2),W(7),_(1),W(2),_=
(1),W(2),_(1),W(1),_(1),W(1),fio: job 'test' hasn't exited in 60 seconds, i=
t appears to be stuck. Doing forceful exit of this job.(2)] [2.9% done] [0K=
B/5694KB/0KB /s] [0/88/0 iops] [eta 03h:44m:49s]
   fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doi=
ng forceful exit of this job.
   Jobs: 89 (f=3D89): [W(3),_(1),W(5),_(1),W(11),_(1),W(4),f(1),_(1),W(2),_=
(1),W(6),f(1),W(2),_(2),W(6),_(3),W(3),_(3),W(4),_(1),W(3),_(1),W(2),_(2),W=
(1),f(1),W(5),_(1),W(2),_(1),W(2),_(1),W(1),_(1),W(1),_(1),W(1),_(3),W(3),_=
(1),f(1),_(1),W(1),_(1),W(5),_(1),W(1),_(2),W(3),_(2),W(2),_(3),W(4),_(1),W=
(2),_(2)] [2.7% done] [0KB/15730KB/0KB /s] [0/245/0 ifio: job 'test' hasn't=
 exited in 61 seconds, it appears to be stuck. Doing forceful exit of this =
job.
   fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doi=
ng forceful exit of this job.
   Jobs: 87 (f=3D87): [W(3),_(1),W(5),_(1),W(11),_(1),W(4),f(1),_(1),W(2),_=
(1),W(6),f(1),W(2),_(2),W(6),_(3),W(3),_(3),W(4),_(1),W(3),_(1),W(2),_(2),W=
(1),f(1),W(5),_(1),W(2),_(2),W(1),_(1),W(1),_(3),W(1),_(3),W(2),f(1),_(1),f=
(1),_(1),W(1),_(1),W(5),_(1),W(1),_(2),W(3),_(2),W(2),_(3),W(4),_(1),W(2),_=
(2)] [2.6% done] [0KB/12825KB/0KB /s] [0/200/0 iops] fio: job 'test' hasn't=
 exited in 60 seconds, it appears to be stuck. Doing forceful exit of this =
job.
   fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doi=
ng forceful exit of this job.
   fio: job 'test' hasn't exited in 94 seconds, it appears to be stuck. Doi=
ng forceful exit of this job.
   Jobs: 85 (f=3D85): [W(3),_(1),W(5),_(1),W(11),_(1),W(4),f(1),_(1),W(2),_=
(1),W(9),_(2),W(6),_(3),W(3),_(3),W(4),_(1),W(1),_(1),W(1),_(1),W(2),_(2),W=
(1),f(1),W(5),_(1),W(2),_(2),W(1),_(1),W(1),_(3),W(1),_(3),f(1),W(2),_(1),W=
(1),_(1),W(1),_(1),W(5),_(1),W(1),_(2),W(3),_(2),W(2),_(3),W(2),_(1),W(1),_=
(1),W(2),_(2)] [2.5% done] [0KB/10149KB/0KB /s] [0/15fio: job 'test' hasn't=
 exited in 100 seconds, it appears to be stuck. Doing forceful exit of this=
 job.
   Jobs: 86 (f=3D86): [W(3),_(1),W(5),_(1),W(11),_(1),W(5),_(1),W(2),_(1),W=
(9),_(2),W(2),f(1),W(3),_(3),W(3),_(3),W(4),_(1),W(1),_(1),W(1),_(1),W(2),_=
(2),W(7),_(1),W(2),f(1),_(1),W(1),_(1),W(1),_(3),W(1),_(3),f(1),W(2),_(1),W=
(1),_(1),W(1),_(1),W(5),_(1),W(1),_(2),W(3),_(2),W(2),_(3),W(2),_(1),W(1),_=
(1),W(2),_(2)] [2.4% done] [0KB/15226KB/0KB /s] [0/23fio: job 'test' hasn't=
 exited in 60 seconds, it appears to be stuck. Doing forceful exit of this =
job.
   fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doi=
ng forceful exit of this job.
   fio: job 'test' hasn't exited in 103 seconds, it appears to be stuck. Do=
ing forceful exit of this job.
   fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doi=
ng forceful exit of this job.
   Jobs: 83 (f=3D83): [W(1),_(1),W(1),_(1),W(5),_(1),W(9),f(1),W(1),_(1),W(=
5),_(1),W(2),_(1),W(9),_(2),W(6),_(3),W(3),_(3),W(2),_(1),W(1),_(1),W(1),_(=
1),W(1),_(1),W(2),_(2),W(7),_(1),W(2),_(2),W(1),_(1),W(1),_(3),W(1),_(3),W(=
3),_(1),W(1),_(1),W(1),_(1),W(5),_(1),W(1),_(2),W(3),_(2),W(2),_(3),W(2),_(=
1),W(1),_(1),W(2),_(2)] [2.2% done] [0KB/12140KB/0KB fio: job 'test' hasn't=
 exited in 60 seconds, it appears to be stuck. Doing forceful exit of this =
job.
   fio: job 'test' hasn't exited in 103 seconds, it appears to be stuck. Do=
ing forceful exit of this job.
   Jobs: 81 (f=3D81): [W(1),_(1),W(1),_(1),W(1),_(1),W(3),_(1),W(11),_(1),W=
(5),_(1),W(2),_(1),W(9),_(2),W(4),_(1),W(1),_(3),W(3),_(3),W(2),_(1),f(1),_=
(1),W(1),_(1),W(1),_(1),W(2),_(2),W(4),f(1),W(2),_(1),W(2),_(2),W(1),_(1),W=
(1),_(3),W(1),_(3),W(3),_(1),W(1),_(1),W(1),_(1),W(5),_(1),W(1),_(2),W(3),_=
(2),W(2),_(3),W(2),_(1),W(1),_(1),W(2),_(2)] [2.1% dofio: job 'test' hasn't=
 exited in 60 seconds, it appears to be stuck. Doing forceful exit of this =
job.
   Jobs: 81 (f=3D81): [W(1),_(1),W(1),_(1),W(1),_(1),W(3),_(1),W(11),_(1),W=
(5),_(1),W(2),_(1),W(9),_(2),W(4),_(1),W(1),_(3),W(3),_(3),W(2),_(1),f(1),_=
(1),W(1),_(1),W(1),_(1),f(1),W(1),_(2),W(7),_(1),W(2),_(2),W(1),_(1),W(1),_=
(3),W(1),_(3),W(3),_(1),W(1),_(1),W(1),_(1),W(5),_(1),W(1),_(2),W(3),_(2),W=
(2),_(3),W(2),_(1),W(1),_(1),W(2),_(2)] [2.1% done] [fio: job 'test' hasn't=
 exited in 60 seconds, it appears to be stuck. Doing forceful exit of this =
job.
   fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doi=
ng forceful exit of this job.
   fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doi=
ng forceful exit of this job.
   Jobs: 77 (f=3D77): [W(1),_(1),W(1),_(4),W(2),_(1),W(11),_(1),W(5),_(1),W=
(2),_(1),W(9),_(2),W(4),_(1),W(1),_(3),W(3),_(3),W(2),_(1),W(1),_(1),W(1),_=
(1),W(1),_(1),f(1),W(1),_(2),W(7),_(1),W(2),_(2),W(1),_(1),W(1),_(3),W(1),_=
(3),W(3),_(1),W(1),_(1),W(1),_(3),W(3),_(1),W(1),_(2),W(3),_(2),W(2),_(3),W=
(2),_(1),W(1),_(1),W(2),_(2)] [1.9% done] [0KB/275KB/fio: job 'test' hasn't=
 exited in 89 seconds, it appears to be stuck. Doing forceful exit of this =
job.
   Jobs: 77 (f=3D77): [W(1),_(1),W(1),_(4),W(2),_(1),W(11),_(1),W(5),_(1),W=
(2),_(1),W(9),_(2),W(4),_(1),f(1),_(3),W(3),_(3),W(2),_(1),W(1),_(1),W(1),_=
(1),W(1),_(1),W(2),_(2),W(7),_(1),W(2),_(2),W(1),_(1),W(1),_(3),W(1),_(3),W=
(3),_(1),W(1),_(1),W(1),_(3),W(3),_(1),W(1),_(2),W(3),_(2),W(2),_(3),W(2),_=
(1),W(1),_(1),W(2),_(2)] [1.9% done] [0KB/16256KB/0KBfio: job 'test' hasn't=
 exited in 104 seconds, it appears to be stuck. Doing forceful exit of this=
 job.
   fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doi=
ng forceful exit of this job.
   fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doi=
ng forceful exit of this job.
   Jobs: 77 (f=3D77): [W(1),_(1),W(1),_(4),W(2),_(1),W(5),f(1),W(5),_(1),W(=
5),_(1),W(2),_(1),W(9),_(2),W(4),_(1),f(1),_(3),W(3),_(3),W(2),_(1),W(1),_(=
1),W(1),_(1),W(1),_(1),W(2),_(2),W(7),_(1),W(2),_(2),W(1),_(1),W(1),_(3),W(=
1),_(3),W(3),_(1),W(1),_(1),W(1),_(3),W(3),_(1),W(1),_(2),W(3),_(2),W(2),_(=
3),W(2),_(1),W(1),_(1),W(2),_(2)] [1.9% done] [0KB/29fio: job 'test' hasn't=
 exited in 60 seconds, it appears to be stuck. Doing forceful exit of this =
job.
   fio: job 'test' hasn't exited in 110 seconds, it appears to be stuck. Do=
ing forceful exit of this job.
   Jobs: 75 (f=3D75): [W(1),_(1),W(1),_(4),W(2),_(1),W(5),f(1),W(5),_(1),W(=
5),_(1),W(2),_(1),W(1),_(1),W(7),_(2),f(1),W(3),_(1),W(1),_(3),W(3),_(3),W(=
2),_(1),W(1),_(1),W(1),_(1),W(1),_(1),W(2),_(2),W(7),_(1),W(2),_(2),W(1),_(=
5),W(1),_(3),W(3),_(1),W(1),_(1),W(1),_(3),W(3),_(1),W(1),_(2),W(3),_(2),W(=
2),_(3),W(2),_(1),W(1),_(1),W(2),_(2)] [1.8% done] [0fio: job 'test' hasn't=
 exited in 60 seconds, it appears to be stuck. Doing forceful exit of this =
job.
   Jobs: 73 (f=3D73): [W(1),_(1),W(1),_(4),W(2),_(1),W(11),_(2),W(4),_(1),W=
(2),_(1),W(1),_(1),W(7),_(2),W(4),_(1),W(1),_(3),W(3),_(3),W(2),_(1),W(1),_=
(1),W(1),_(1),W(1),_(1),W(2),_(2),W(2),f(1),W(4),_(1),W(2),_(2),W(1),_(5),W=
(1),_(3),W(3),_(1),W(1),_(1),W(1),_(3),W(3),_(4),W(3),_(2),W(2),_(3),W(2),_=
(1),W(1),_(1),W(2),_(2)] [1.7% done] [0KB/8633KB/0KB fio: job 'test' hasn't=
 exited in 60 seconds, it appears to be stuck. Doing forceful exit of this =
job.
   fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doi=
ng forceful exit of this job.
   Jobs: 71 (f=3D71): [W(1),_(1),W(1),_(4),W(2),_(1),W(1),_(1),W(1),f(1),W(=
7),_(2),W(4),_(1),W(2),_(1),W(1),_(1),W(7),_(2),W(4),_(1),W(1),_(3),W(3),_(=
3),W(2),_(1),W(1),_(1),W(1),_(1),W(1),_(1),W(2),_(2),W(7),_(1),W(2),_(2),W(=
1),_(5),W(1),_(3),W(3),_(1),W(1),_(1),W(1),_(3),W(3),_(4),W(3),_(2),W(1),_(=
4),W(2),_(1),W(1),_(1),W(2),_(2)] [1.7% done] [0KB/51fio: job 'test' hasn't=
 exited in 60 seconds, it appears to be stuck. Doing forceful exit of this =
job.
   fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doi=
ng forceful exit of this job.
   Jobs: 69 (f=3D69): [W(1),_(1),W(1),_(4),W(2),_(1),W(1),_(2),W(8),_(2),W(=
4),_(1),W(2),_(1),W(1),_(1),W(7),_(2),W(4),_(1),W(1),_(3),W(3),_(3),W(2),_(=
1),W(1),_(1),W(1),_(1),W(1),_(1),W(2),_(2),W(7),_(2),W(1),_(2),W(1),_(5),W(=
1),_(3),W(3),_(1),W(1),_(1),W(1),_(3),W(3),_(4),f(1),W(2),_(2),W(1),_(4),W(=
2),_(1),W(1),_(1),f(1),W(1),_(2)] [1.6% done] [0KB/14Jobs: 69 (f=3D69): [W(=
1),_(1),W(1),_(4),W(2),_(1),W(1),_(2),W(8),_(2),W(4),_(1),W(2),_(1),W(1),_(=
1),W(7),_(2),W(4),_(1),W(1),_(3),W(3),_(3),W(2),_(1),W(1),_(1),W(1),_(1),W(=
1),_(1),W(2),_(2),W(3),f(1),W(3),_(2),W(1),_(2),W(1),_(5),W(1),_(3),W(3),_(=
1),W(1),_(1),W(1),_(3),W(3),_(4),f(1),W(2),_(2),W(1),_(4),W(2),_(1),W(1),_(=
1),f(1),W(1),_(2)] [1.6% donfio: job 'test' hasn't exited in 60 seconds, it=
 appears to be stuck. Doing forceful exit of this job.
   fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doi=
ng forceful exit of this job.
   Jobs: 68 (f=3D68): [W(1),_(1),W(1),_(4),W(2),_(1),W(1),_(2),W(8),_(2),W(=
1),_(1),W(2),_(1),W(2),_(1),W(1),_(1),W(7),_(2),W(1),f(1),W(2),_(1),W(1),_(=
3),W(3),_(3),W(2),_(1),W(1),_(1),W(1),_(1),W(1),_(1),W(2),_(2),W(3),f(1),W(=
3),_(2),W(1),_(2),W(1),_(5),W(1),_(3),W(3),_(1),W(1),_(1),W(1),_(3),W(3),_(=
4),W(3),_(2),W(1),_(4),W(2),_(1),W(1),_(1),W(2),_(2)]Jobs: 67 (f=3D67): [W(=
1),_(1),W(1),_(4),W(2),_(1),W(1),_(2),W(1),_(1),W(6),_(2),W(1),_(1),W(2),_(=
1),W(2),_(1),W(1),_(1),W(7),_(2),W(4),_(1),W(1),_(3),W(3),_(3),W(2),_(1),W(=
1),_(1),W(1),_(1),W(1),_(1),W(2),_(2),W(7),_(2),W(1),_(2),W(1),_(5),W(1),_(=
3),W(3),_(1),W(1),_(1),W(1),_(3),W(1),f(1),W(1),_(4),W(3),_(2),W(1),_(4),W(=
2),_(1),W(1),_(1),W(2),_(2)]fio: job 'test' hasn't exited in 60 seconds, it=
 appears to be stuck. Doing forceful exit of this job.
   fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doi=
ng forceful exit of this job.
   fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doi=
ng forceful exit of this job.
   fio: job 'test' hasn't exited in 100 seconds, it appears to be stuck. Do=
ing forceful exit of this job.
   fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doi=
ng forceful exit of this job.
   Jobs: 64 (f=3D64): [_(2),W(1),_(4),W(2),_(1),W(1),_(2),W(1),_(1),W(6),_(=
2),W(1),_(1),W(2),_(1),W(2),_(1),W(1),_(1),W(7),_(2),W(3),_(2),W(1),_(3),W(=
3),_(3),W(2),_(1),W(1),_(1),W(1),_(1),W(1),_(1),W(1),f(1),_(3),W(6),_(2),f(=
1),_(2),W(1),_(5),W(1),_(3),W(3),_(1),W(1),_(1),W(1),_(3),W(1),f(1),W(1),_(=
4),W(3),_(2),W(1),_(4),f(1),W(1),_(1),W(1),_(1),W(2),Jobs: 63 (f=3D63): [_(=
7),W(2),_(1),W(1),_(2),W(1),_(1),W(6),_(2),W(1),_(1),W(2),_(1),W(2),_(1),W(=
1),_(1),W(7),_(2),W(3),_(2),W(1),_(3),W(3),_(3),W(2),_(1),W(1),_(1),W(1),_(=
1),W(1),_(1),W(1),f(1),_(3),W(6),_(2),f(1),_(2),W(1),_(5),W(1),_(3),W(3),_(=
1),W(1),_(1),W(1),_(3),W(3),_(4),W(3),_(2),W(1),_(4),f(1),W(1),_(1),W(1),_(=
1),W(2),_(2)] [1.5% done] [0fio: job 'test' hasn't exited in 60 seconds, it=
 appears to be stuck. Doing forceful exit of this job.
   fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doi=
ng forceful exit of this job.
   fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doi=
ng forceful exit of this job.
   Jobs: 62 (f=3D62): [_(7),W(2),_(1),W(1),_(2),W(1),_(1),W(6),_(2),W(1),_(=
1),W(2),_(2),W(1),_(1),W(1),_(1),W(7),_(2),W(3),_(2),W(1),_(3),W(3),_(3),W(=
2),_(1),W(1),_(1),W(1),_(1),W(1),_(1),W(2),_(3),W(6),_(2),W(1),_(2),W(1),_(=
5),W(1),_(3),W(3),_(1),W(1),_(1),W(1),_(3),W(3),_(4),W(3),_(2),W(1),_(4),W(=
2),_(1),W(1),_(1),W(2),_(2)] [1.5% done] [0KB/1263KB/Jobs: 60 (f=3D60): [_(=
7),W(2),_(1),W(1),_(2),W(1),_(1),W(6),_(2),W(1),_(1),W(2),_(2),W(1),_(1),W(=
1),_(1),W(2),_(1),W(4),_(2),W(3),_(2),W(1),_(3),W(3),_(3),W(2),_(1),W(1),_(=
1),W(1),_(1),W(1),_(1),W(2),_(3),W(6),_(2),W(1),_(2),W(1),_(5),W(1),_(3),W(=
1),_(1),W(1),_(1),W(1),_(1),W(1),_(3),W(3),_(4),W(2),f(1),_(2),W(1),_(4),W(=
2),_(1),W(1),_(1),W(2),_(2)]fio: job 'test' hasn't exited in 101 seconds, i=
t appears to be stuck. Doing forceful exit of this job.
   fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doi=
ng forceful exit of this job.
   Jobs: 59 (f=3D59): [_(7),W(2),_(1),W(1),_(2),W(1),_(1),W(6),_(2),W(1),_(=
1),W(2),_(2),W(1),_(1),W(1),_(1),W(2),_(1),W(4),_(2),W(3),_(2),W(1),_(3),W(=
2),f(1),_(3),W(2),_(1),W(1),_(1),W(1),_(1),W(1),_(1),W(2),_(3),W(4),_(1),W(=
1),_(2),W(1),_(2),W(1),_(5),W(1),_(3),W(1),_(1),W(1),_(1),W(1),_(1),W(1),_(=
3),W(3),_(4),W(3),_(2),W(1),_(4),W(2),_(1),W(1),_(1),fio: job 'test' hasn't=
 exited in 60 seconds, it appears to be stuck. Doing forceful exit of this =
job.
   fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doi=
ng forceful exit of this job.
   Jobs: 58 (f=3D58): [_(7),W(2),_(1),W(1),_(2),W(1),_(1),W(6),_(2),W(1),_(=
1),W(2),_(2),W(1),_(1),W(1),_(2),W(1),_(1),W(4),_(2),W(3),_(2),W(1),_(3),W(=
2),f(1),_(3),W(2),_(1),W(1),_(1),W(1),_(1),W(1),_(1),W(2),_(3),W(4),_(1),W(=
1),_(2),W(1),_(2),W(1),_(5),W(1),_(3),W(1),_(1),W(1),_(1),W(1),_(1),W(1),_(=
3),W(3),_(4),W(1),f(1),W(1),_(2),W(1),_(4),W(2),_(1),fio: job 'test' hasn't=
 exited in 60 seconds, it appears to be stuck. Doing forceful exit of this =
job.
   Jobs: 56 (f=3D56): [_(7),W(2),_(1),W(1),_(2),W(1),_(1),W(6),_(2),f(1),_(=
2),W(1),_(2),W(1),_(1),W(1),_(2),W(1),_(1),W(3),f(1),_(2),W(3),_(2),W(1),_(=
3),W(1),_(1),f(1),_(3),W(2),_(1),W(1),_(1),W(1),_(1),W(1),_(1),W(2),_(3),W(=
4),_(1),W(1),_(2),W(1),_(2),W(1),_(5),W(1),_(3),W(1),_(1),W(1),_(1),W(1),_(=
1),W(1),_(3),f(1),W(2),_(4),W(3),_(2),W(1),_(4),W(2),fio: job 'test' hasn't=
 exited in 92 seconds, it appears to be stuck. Doing forceful exit of this =
job.
   fio: job 'test' hasn't exited in 95 seconds, it appears to be stuck. Doi=
ng forceful exit of this job.
   fio: job 'test' hasn't exited in 96 seconds, it appears to be stuck. Doi=
ng forceful exit of this job.
   fio: job 'test' hasn't exited in 100 seconds, it appears to be stuck. Do=
ing forceful exit of this job.
   fio: job 'test' hasn't exited in 95 seconds, it appears to be stuck. Doi=
ng forceful exit of this job.
   fio: job 'test' hasn't exited in 95 seconds, it appears to be stuck. Doi=
ng forceful exit of this job.
   fio: job 'test' hasn't exited in 95 seconds, it appears to be stuck. Doi=
ng forceful exit of this job.
   fio: job 'test' hasn't exited in 97 seconds, it appears to be stuck. Doi=
ng forceful exit of this job.

Thanks for your feedback

Regards,
Thierry


