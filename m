Return-Path: <andrey.v.kuzmin@gmail.com>
MIME-Version: 1.0
In-Reply-To: <VI1PR05MB13439C4033DED096900CDF30B1FE0@VI1PR05MB1343.eurprd05.prod.outlook.com>
References: <VI1PR05MB13437814C9CD31D2CECE7398B1FC0@VI1PR05MB1343.eurprd05.prod.outlook.com>
	<56840F80.4060903@kernel.dk>
	<VI1PR05MB13435F5190D9D9A17C59315BB1FD0@VI1PR05MB1343.eurprd05.prod.outlook.com>
	<5684A8F1.6010105@kernel.dk>
	<VI1PR05MB13439C4033DED096900CDF30B1FE0@VI1PR05MB1343.eurprd05.prod.outlook.com>
Date: Thu, 31 Dec 2015 19:33:32 +0300
Message-ID: <CANvN+ekwjftjYq=8KFiefRAFmUvZF1qpJ9Y6ohFBdMHH6TEAQg@mail.gmail.com>
Subject: RE: fio-2c2c93d and with a lot of numjobs causing fio Jobs to Time Out
From: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Content-Type: multipart/alternative; boundary=001a1148d7ca271ef505283437ed
To: Thierry BERTAUD <tbertaud@conforama.fr>
Cc: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

--001a1148d7ca271ef505283437ed
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Dec 31, 2015 19:19, "Thierry BERTAUD" <tbertaud@conforama.fr> wrote:
>
> Hi Jens and Andrey,
>
> >I'll be taking a bit of time off, but I should have access to an AIX
> >that I can test on sometime next week. What version are you on?
>
> At this time i use a VIOS 2.2.3.52  aka AIX 6100-08-01-1245. I need to
build fio against AIX 6.x, 7.x.
> After next week, i'll reinstall the server to go to production. So i'll
need to look for a new box with a FC card so i'll use another AIX version.
>
> For your information i don't have the issue with:
> HDISK=3Dhdisk6 RWTYPE=3Drw RRATIO=3D0 BS=3D4096 QD=3D128 NJ=3D128
/home/padmin/fio/fio-5f3bd0f/fio myfio.fio
> but
> HDISK=3Dhdisk6 RWTYPE=3Drw RRATIO=3D0 BS=3D65536 QD=3D128 NJ=3D128
/home/padmin/fio/fio-5f3bd0f/fio myfio.fio
>
> So i think it's perhaps some hardware or OS comportement that the cause
of the issue it's not fio fio  (it's not the guilty but a collateral
victim) but idon't find why because the statistics data from SAN seems OK.
> SAN stats during test:
> Latency (ms):      R: 0/ W 0.17
> Thoughput (M): R 0  / W 9.8
> IOPS:                    R 0 / W 2380
>
>
> 1. fIo stay stuck with the last print:
>    fio: job 'test' hasn't exited in 97 seconds, it appears to be stuck.
Doing forceful exit of this job.
>
> 1.1 The only process that's stay a live is the min fio process (all
others 128 childs have been died or finished)
> # ps -ef | grep fio | grep -v grep
>     root 41877588 48234628 120 16:18:23  pts/1  1:20
/home/padmin/fio/fio-5f3bd0f/fio myfio.fio
> #
>
> 1.3 System monitor indicate no disk activty test is over but the main
process uses CPU.
>    Topas Monitor for host:    XVIOS16
>    Thu Dec 31 16:28:19 2015   Interval:  2
>
>    CPU  User%  Kern%  Wait%  Idle%  Physc   Entc
>    ALL   57.4    5.8    0.0   36.8   1.01  101.5
>
>    Disk    Busy%     KBPS     TPS KB-Read KB-Writ
>    hdisk3    0.0     0.0      0.0    0.0     0.0
>    hdisk2    0.0     0.0      0.0    0.0     0.0
>    hdisk9    0.0     0.0      0.0    0.0     0.0
>    hdisk1    0.0     0.0      0.0    0.0     0.0
>    hdisk0    0.0     0.0      0.0    0.0     0.0
>    hdisk10   0.0     0.0      0.0    0.0     0.0
>    hdisk7    0.0     0.0      0.0    0.0     0.0
>    hdisk4    0.0     0.0      0.0    0.0     0.0
>    hdisk5    0.0     0.0      0.0    0.0     0.0
>    hdisk6    0.0     0.0      0.0    0.0     0.0
>
>    Name            PID  CPU%  PgSp Owner
>    fio        41877588  62.6   3.5 root
>    sched        196614   0.1   0.4 root
>    vio_daem   10682558   0.0  46.1 root
>    seaproc     3997822   0.0   1.0 root
>    syncd       3538998   0.0   0.6 root
>    java        9764964   0.0  84.2 root
>
> 1.5 During gdb against the process the cpu load disapear. If i don't dgb
against the process the load stay alive.
>
> 2. 1:  gdb trace
>    # gdb -p 41877588
>    GNU gdb (GDB) 7.8.1
>    Copyright (C) 2014 Free Software Foundation, Inc.
>    License GPLv3+: GNU GPL version 3 or later <
http://gnu.org/licenses/gpl.html>
>    This is free software: you are free to change and redistribute it.
>    There is NO WARRANTY, to the extent permitted by law.  Type "show
copying"
>    and "show warranty" for details.
>    This GDB was configured as "powerpc-ibm-aix5.1.0.0".
>    Type "show configuration" for configuration details.
>    For bug reporting instructions, please see:
>    <http://www.gnu.org/software/gdb/bugs/>.
>    Find the GDB manual and other documentation resources online at:
>    <http://www.gnu.org/software/gdb/documentation/>.
>    For help, type "help".
>    Type "apropos word" to search for commands related to "word".
>    Attaching to process 41877588
>    0xd0119598 in ?? ()
>    (gdb) info threads
>      Id   Target Id         Frame
>    * 1    process 41877588  0xd0119598 in ?? ()
>    (gdb) thread 1
>    [Switching to thread 1 (process 41877588)]
>    #0  0xd0119598 in ?? ()
>    (gdb) bt
>    #0  0xd0119598 in ?? ()
>    #1  0xffffffff in ?? ()
>    #2  0xd0119bc0 in ?? ()
>    #3  0xd0118f28 in ?? ()
>    #4  0x100625dc in ?? ()
>    #5  0x1006482c in ?? ()
>    #6  0x10064b90 in ?? ()
>    #7  0xd0505c10 in ?? ()
>    #8  0x00000000 in ?? ()
>    (gdb)
>
> 2.1.1 It semmes i nned to build fio with some option to have some
symbole. Which option i can use for that.
> At this time i just do: ./configure; gmake CC=3Dgcc
>

Try 'configure --disable-optimizations'.

Regards,
A.
> 2.2: The full log from fio:
>    # HDISK=3Dhdisk6 RWTYPE=3Drw RRATIO=3D0 BS=3D65536 QD=3D128 NJ=3D128
/home/padmin/fio/fio-5f3bd0f/fio myfio.fio
>    test: (g=3D0): rw=3Drw, bs=3D64K-64K/64K-64K/64K-64K, ioengine=3Dposix=
aio,
iodepth=3D128
>    ...
>    fio-2.3
>    Starting 128 processes
>    fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck.
Doing forceful exit of this job.:22s]
>    fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck.
Doing forceful exit of this job.
>    fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck.
Doing forceful exit of this job. iops] [eta 11m:34s]
>    fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck.
Doing forceful exit of this job.] [0/138/0 iops] [eta 17m:34s]
>    fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck.
Doing forceful exit of this job.
>    fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck.
Doing forceful exit of this job.4KB/0KB /s] [0/215/0 iops] [eta 29m:36s]
>    fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck.
Doing forceful exit of this job.4.6% done] [0KB/7488KB/0KB /s] [0/117/0
iops] [eta 35m:36s]
>    fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck.
Doing forceful exit of this job.1),W(21)] [12.8% done] [0KB/8617KB/0KB /s]
[0/134/0 iops] [eta 41m:40s]
>    fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck.
Doing forceful exit of this job.1),W(38)] [11.4% done] [0KB/856KB/0KB /s]
[0/13/0 iops] [eta 47m:44s]
>    fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck.
Doing forceful exit of this job.
>    Jobs: 118 (f=3D118):
[f(1),W(8),_(1),W(11),_(1),W(2),f(1),W(5),_(1),W(9),_(1),W(7),_(1),W(12),_(=
1),W(6),_(1),W(11),_(1),W(2),_(1),W(5),_(1),W(38)]
[9.3% done] [0KB/20057KB/0KB fio: job 'test' hasn't exited in 60 seconds,
it appears to be stuck. Doing forceful exit of this job.
>    Jobs: 117 (f=3D117):
[W(9),_(1),W(11),_(1),W(8),_(1),W(9),_(1),W(4),f(1),W(2),_(1),W(1),_(1),W(1=
0),_(1),W(6),_(1),W(11),_(1),W(2),_(1),W(5),_(1),W(38)]
[8.5% done] [0KB/7255KB/fio: job 'test' hasn't exited in 60 seconds, it
appears to be stuck. Doing forceful exit of this job.
>    Jobs: 116 (f=3D116):
[W(3),_(1),W(5),_(1),W(11),_(1),W(8),_(1),W(9),_(1),W(7),_(1),W(1),_(1),W(1=
0),_(1),W(6),_(1),W(11),_(1),W(2),_(1),W(5),_(1),W(38)]
[7.9% done] [0KB/1130KB/Jobs: 116 (f=3D116):
[W(2),f(1),_(1),W(5),_(1),W(2),f(1),W(8),_(1),W(8),_(1),W(4),f(1),W(4),_(1)=
,W(7),_(1),W(1),_(1),W(10),_(1),W(6),_(1),W(11),_(1),W(2),_(1),W(5),_(1),W(=
38)]
Jobs: 116 (f=3D116):
[W(3),_(1),W(5),_(1),W(1),f(1),W(9),_(1),W(8),_(1),W(4),f(1),W(4),_(1),W(7)=
,_(1),W(1),_(1),W(10),_(1),W(6),_(1),W(11),_(1),W(2),_(1),W(5),_(1),W(38)]
[7.9%Jobs: 116 (f=3D116):
[W(3),_(1),W(5),_(1),W(11),_(1),W(8),_(1),W(9),_(1),W(7),_(1),W(1),_(1),W(1=
0),_(1),W(6),_(1),W(11),_(1),W(2),_(1),W(5),_(1),W(38)]
[7.9% done] [0KB/0KB/0KBfio: job 'test' hasn't exited in 60 seconds, it
appears to be stuck. Doing forceful exit of this job.
>    Jobs: 115 (f=3D115):
[W(3),_(1),W(5),_(1),W(11),_(1),W(3),f(1),W(4),_(1),W(9),_(1),W(7),_(1),W(1=
),_(1),W(1),f(1),W(8),_(1),W(6),_(1),W(11),_(1),W(2),_(1),W(5),_(1),W(36),_=
(1),WJobs:
115 (f=3D115):
[W(3),_(1),W(5),_(1),W(11),_(1),W(8),_(1),W(9),_(1),W(7),_(1),W(1),_(1),W(1=
0),_(1),W(6),_(1),W(6),f(1),W(4),_(1),W(2),_(1),W(5),_(1),W(36),_(1),W(1)]
[7.4%fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck.
Doing forceful exit of this job.
>    Jobs: 114 (f=3D114):
[W(3),_(1),W(5),_(1),W(4),f(1),W(6),_(1),W(8),_(1),W(9),_(1),W(7),_(1),W(1)=
,_(1),W(10),_(1),W(6),_(1),W(11),_(1),W(2),_(1),W(3),_(1),W(1),_(1),W(36),_=
(1),Wfio:
job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doing
forceful exit of this job.
>    Jobs: 113 (f=3D113):
[W(3),_(1),W(5),_(1),W(11),_(1),W(6),f(1),W(1),_(1),W(9),_(1),W(7),_(1),W(1=
),_(1),W(10),_(1),W(6),_(1),W(11),_(1),W(2),_(1),W(1),_(1),W(1),_(1),W(1),_=
(1),WJobs:
113 (f=3D113):
[W(3),_(1),W(5),_(1),W(11),_(1),W(6),f(1),W(1),_(1),W(2),f(2),W(5),_(1),W(7=
),_(1),W(1),_(1),f(1),W(9),_(1),W(6),_(1),W(11),_(1),W(2),_(1),W(1),_(1),W(=
1),_(Jobs:
113 (f=3D113):
[W(3),_(1),W(5),_(1),W(11),_(1),W(8),_(1),W(2),f(2),W(5),_(1),W(7),_(1),W(1=
),_(1),f(1),W(9),_(1),W(6),_(1),W(11),_(1),W(2),_(1),W(1),_(1),W(1),_(1),W(=
1),_(fio:
job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doing
forceful exit of this job.
>    fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck.
Doing forceful exit of this job.
>    Jobs: 111 (f=3D111):
[W(3),_(1),W(5),_(1),W(11),_(1),W(7),f(1),_(1),W(9),_(2),W(6),_(1),W(1),_(1=
),W(3),_(1),W(6),_(1),W(6),_(1),W(11),_(1),W(2),_(1),W(1),_(1),W(1),_(1),W(=
1),_(fio:
job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doing
forceful exit of this job.
>    fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck.
Doing forceful exit of this job.
>    Jobs: 110 (f=3D110):
[W(3),_(1),W(5),_(1),W(10),f(1),_(1),W(8),_(1),W(9),_(2),W(6),_(1),W(1),_(1=
),W(3),_(1),W(6),_(1),W(6),_(1),W(11),_(1),W(2),_(1),W(1),_(1),W(1),_(1),W(=
1),_(Jobs:
109 (f=3D109):
[W(3),_(1),f(1),W(4),_(1),W(10),f(1),_(1),W(8),_(1),W(9),_(2),W(6),_(1),W(1=
),_(1),W(3),_(1),W(6),_(1),W(6),_(1),W(11),_(1),W(2),_(1),W(1),_(1),W(1),_(=
1),W(fio:
job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doing
forceful exit of this job.:55m:38s]
>    Jobs: 108 (f=3D108):
[W(3),_(1),f(1),W(2),f(1),W(1),_(1),W(7),f(1),W(3),_(1),W(8),_(1),W(9),_(2)=
,W(6),_(1),W(1),_(1),W(3),_(1),W(2),f(1),W(3),_(1),W(6),_(1),W(8),_(1),W(2)=
,_(1)fio:
job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doing
forceful exit of this job./0KB /s] [0/142/0 iops] [eta 02h:01m:37s]
>    Jobs: 107 (f=3D107):
[W(3),_(1),W(5),_(1),W(11),_(1),W(5),_(1),W(2),_(1),W(9),_(2),W(6),_(1),W(1=
),_(1),W(3),_(1),W(6),_(1),W(6),_(1),W(8),_(1),W(2),_(1),W(2),_(1),W(1),_(1=
),W(1Jobs:
107 (f=3D107):
[W(3),_(1),W(5),_(1),W(11),_(1),W(5),_(1),W(2),_(1),W(9),_(2),W(6),_(1),W(1=
),_(1),W(3),_(1),W(6),_(1),W(6),_(1),W(8),_(1),W(2),_(1),W(2),_(1),W(1),_(1=
),W(1fio:
job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doing
forceful exit of this job.eta 02h:07m:35s]
>    Jobs: 106 (f=3D106):
[W(3),_(1),W(5),_(1),W(6),f(1),W(1),f(1),W(2),_(1),W(5),_(1),W(2),_(1),W(7)=
,f(1),W(1),_(2),W(6),_(1),W(1),_(1),W(3),_(1),W(6),_(1),W(6),_(1),W(8),_(1)=
,W(2)Jobs:
106 (f=3D106):
[W(3),_(1),W(5),_(1),W(11),_(1),W(5),_(1),W(2),_(1),W(9),_(2),W(6),_(1),W(1=
),_(1),W(3),_(1),W(6),_(1),W(6),_(1),W(8),_(1),W(2),_(1),W(2),_(1),W(1),_(1=
),W(1fio:
job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doing
forceful exit of this job.42/0 iops] [eta 02h:13m:57s]
>    Jobs: 105 (f=3D105):
[W(3),_(1),W(5),_(1),W(11),_(1),W(5),_(1),W(2),_(1),W(9),_(2),W(6),_(1),W(1=
),_(1),W(3),_(2),W(5),_(1),W(6),_(1),W(8),_(1),W(2),_(1),W(2),_(1),W(1),_(1=
),W(1Jobs:
105 (f=3D105):
[W(3),_(1),W(5),_(1),W(11),_(1),W(5),_(1),W(2),_(1),W(9),_(2),W(6),_(1),W(1=
),_(1),W(3),_(2),W(2),f(1),W(2),_(1),W(6),_(1),W(8),_(1),W(2),_(1),W(2),_(1=
),W(1fio:
job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doing
forceful exit of this job.3/0 iops] [eta 02h:19m:56s]
>    Jobs: 104 (f=3D104):
[W(3),_(1),W(5),_(1),W(11),_(1),W(5),_(1),W(2),_(1),W(9),_(2),W(6),_(1),W(1=
),_(1),W(3),_(2),W(2),f(1),W(2),_(1),W(3),_(1),W(2),_(1),W(8),_(1),W(2),_(1=
),W(1fio:
job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doing
forceful exit of this job.B/0KB /s] [0/136/0 iops] [eta 02h:26m:24s]
>    Jobs: 103 (f=3D103):
[W(3),_(1),W(5),_(1),W(11),_(1),W(5),_(1),W(2),_(1),W(9),_(2),W(6),_(1),W(1=
),_(1),W(3),_(2),W(5),_(1),W(3),_(1),W(2),_(1),W(8),_(1),W(2),_(1),W(1),f(1=
),_(1Jobs:
103 (f=3D103):
[W(3),_(1),W(5),_(1),W(11),_(1),W(5),_(1),W(2),_(1),W(9),_(2),W(6),_(1),W(1=
),_(1),W(3),_(2),W(5),_(1),W(3),_(1),W(2),_(1),W(8),_(1),W(2),_(1),W(2),_(1=
),W(1fio:
job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doing
forceful exit of this job.ops] [eta 02h:32m:22s]
>    Jobs: 103 (f=3D103):
[W(3),_(1),W(5),_(1),W(11),_(1),W(5),_(1),W(2),_(1),W(9),_(2),W(6),_(1),W(1=
),_(1),W(3),_(2),W(5),_(1),W(2),f(1),_(1),W(2),_(1),W(8),_(1),W(2),_(1),W(2=
),_(1fio:
job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doing
forceful exit of this job. [0/205/0 iops] [eta 02h:38m:22s]
>    fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck.
Doing forceful exit of this job.
>    fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck.
Doing forceful exit of this job.
>    fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck.
Doing forceful exit of this job.
>    fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck.
Doing forceful exit of this job.
>    Jobs: 97 (f=3D97):
[W(3),_(1),W(5),_(1),W(11),_(1),W(5),_(1),W(2),_(1),W(9),_(2),W(6),_(3),W(3=
),_(2),W(5),_(1),W(3),_(1),W(2),_(2),W(7),_(1),W(2),_(1),W(2),_(1),W(1),_(1=
),W(1),Jobs:
97 (f=3D97):
[W(3),_(1),W(5),_(1),W(11),_(1),W(5),_(1),W(2),_(1),W(9),_(2),W(6),_(3),W(3=
),_(2),W(5),_(1),W(3),_(1),W(2),_(2),W(6),f(1),_(1),W(2),_(1),W(2),_(1),W(1=
),_(1),Jobs:
97 (f=3D97):
[W(3),_(1),W(5),_(1),W(11),_(1),W(5),_(1),W(2),_(1),W(9),_(2),W(6),_(3),W(3=
),_(2),W(5),_(1),W(3),_(1),W(2),_(2),W(7),_(1),W(2),_(1),W(2),_(1),W(1),_(1=
),W(1),fio:
job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doing
forceful exit of this job./0KB /s] [0/0/0 iops] [eta 03h:08m:26s]
>    fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck.
Doing forceful exit of this job.
>    fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck.
Doing forceful exit of this job.
>    Jobs: 94 (f=3D94):
[W(3),_(1),W(4),f(1),_(1),W(11),_(1),W(5),_(1),W(2),_(1),f(1),W(8),_(2),W(6=
),_(3),W(3),_(2),W(5),_(1),W(3),_(1),W(2),_(2),W(7),_(1),W(2),_(1),W(2),_(1=
),W(1),fio:
job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doing
forceful exit of this job. done] [0KB/14019KB/0KB /s] [0/219/0 iops] [eta
03h:26m:33s]
>    fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck.
Doing forceful exit of this job.
>    Jobs: 92 (f=3D92):
[W(3),_(1),W(4),f(1),_(1),W(11),_(1),W(5),_(1),W(2),_(1),f(1),W(8),_(2),W(6=
),_(3),W(3),_(2),W(5),_(1),W(3),_(1),W(2),_(2),W(7),_(1),W(2),_(1),W(2),_(1=
),W(1),fio:
job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doing
forceful exit of this job.(2)] [2.9% done] [0KB/1593KB/0KB /s] [0/24/0
iops] [eta 03h:38m:38s]
>    Jobs: 91 (f=3D91):
[W(3),_(1),W(5),_(1),W(11),_(1),W(5),_(1),W(2),_(1),W(9),_(2),W(6),_(3),W(3=
),_(2),W(5),_(1),W(3),_(1),W(2),_(2),W(7),_(1),W(2),_(1),W(2),_(1),W(1),_(1=
),W(1),fio:
job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doing
forceful exit of this job.(2)] [2.9% done] [0KB/5694KB/0KB /s] [0/88/0
iops] [eta 03h:44m:49s]
>    fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck.
Doing forceful exit of this job.
>    Jobs: 89 (f=3D89):
[W(3),_(1),W(5),_(1),W(11),_(1),W(4),f(1),_(1),W(2),_(1),W(6),f(1),W(2),_(2=
),W(6),_(3),W(3),_(3),W(4),_(1),W(3),_(1),W(2),_(2),W(1),f(1),W(5),_(1),W(2=
),_(1),W(2),_(1),W(1),_(1),W(1),_(1),W(1),_(3),W(3),_(1),f(1),_(1),W(1),_(1=
),W(5),_(1),W(1),_(2),W(3),_(2),W(2),_(3),W(4),_(1),W(2),_(2)]
[2.7% done] [0KB/15730KB/0KB /s] [0/245/0 ifio: job 'test' hasn't exited in
61 seconds, it appears to be stuck. Doing forceful exit of this job.
>    fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck.
Doing forceful exit of this job.
>    Jobs: 87 (f=3D87):
[W(3),_(1),W(5),_(1),W(11),_(1),W(4),f(1),_(1),W(2),_(1),W(6),f(1),W(2),_(2=
),W(6),_(3),W(3),_(3),W(4),_(1),W(3),_(1),W(2),_(2),W(1),f(1),W(5),_(1),W(2=
),_(2),W(1),_(1),W(1),_(3),W(1),_(3),W(2),f(1),_(1),f(1),_(1),W(1),_(1),W(5=
),_(1),W(1),_(2),W(3),_(2),W(2),_(3),W(4),_(1),W(2),_(2)]
[2.6% done] [0KB/12825KB/0KB /s] [0/200/0 iops] fio: job 'test' hasn't
exited in 60 seconds, it appears to be stuck. Doing forceful exit of this
job.
>    fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck.
Doing forceful exit of this job.
>    fio: job 'test' hasn't exited in 94 seconds, it appears to be stuck.
Doing forceful exit of this job.
>    Jobs: 85 (f=3D85):
[W(3),_(1),W(5),_(1),W(11),_(1),W(4),f(1),_(1),W(2),_(1),W(9),_(2),W(6),_(3=
),W(3),_(3),W(4),_(1),W(1),_(1),W(1),_(1),W(2),_(2),W(1),f(1),W(5),_(1),W(2=
),_(2),W(1),_(1),W(1),_(3),W(1),_(3),f(1),W(2),_(1),W(1),_(1),W(1),_(1),W(5=
),_(1),W(1),_(2),W(3),_(2),W(2),_(3),W(2),_(1),W(1),_(1),W(2),_(2)]
[2.5% done] [0KB/10149KB/0KB /s] [0/15fio: job 'test' hasn't exited in 100
seconds, it appears to be stuck. Doing forceful exit of this job.
>    Jobs: 86 (f=3D86):
[W(3),_(1),W(5),_(1),W(11),_(1),W(5),_(1),W(2),_(1),W(9),_(2),W(2),f(1),W(3=
),_(3),W(3),_(3),W(4),_(1),W(1),_(1),W(1),_(1),W(2),_(2),W(7),_(1),W(2),f(1=
),_(1),W(1),_(1),W(1),_(3),W(1),_(3),f(1),W(2),_(1),W(1),_(1),W(1),_(1),W(5=
),_(1),W(1),_(2),W(3),_(2),W(2),_(3),W(2),_(1),W(1),_(1),W(2),_(2)]
[2.4% done] [0KB/15226KB/0KB /s] [0/23fio: job 'test' hasn't exited in 60
seconds, it appears to be stuck. Doing forceful exit of this job.
>    fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck.
Doing forceful exit of this job.
>    fio: job 'test' hasn't exited in 103 seconds, it appears to be stuck.
Doing forceful exit of this job.
>    fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck.
Doing forceful exit of this job.
>    Jobs: 83 (f=3D83):
[W(1),_(1),W(1),_(1),W(5),_(1),W(9),f(1),W(1),_(1),W(5),_(1),W(2),_(1),W(9)=
,_(2),W(6),_(3),W(3),_(3),W(2),_(1),W(1),_(1),W(1),_(1),W(1),_(1),W(2),_(2)=
,W(7),_(1),W(2),_(2),W(1),_(1),W(1),_(3),W(1),_(3),W(3),_(1),W(1),_(1),W(1)=
,_(1),W(5),_(1),W(1),_(2),W(3),_(2),W(2),_(3),W(2),_(1),W(1),_(1),W(2),_(2)=
]
[2.2% done] [0KB/12140KB/0KB fio: job 'test' hasn't exited in 60 seconds,
it appears to be stuck. Doing forceful exit of this job.
>    fio: job 'test' hasn't exited in 103 seconds, it appears to be stuck.
Doing forceful exit of this job.
>    Jobs: 81 (f=3D81):
[W(1),_(1),W(1),_(1),W(1),_(1),W(3),_(1),W(11),_(1),W(5),_(1),W(2),_(1),W(9=
),_(2),W(4),_(1),W(1),_(3),W(3),_(3),W(2),_(1),f(1),_(1),W(1),_(1),W(1),_(1=
),W(2),_(2),W(4),f(1),W(2),_(1),W(2),_(2),W(1),_(1),W(1),_(3),W(1),_(3),W(3=
),_(1),W(1),_(1),W(1),_(1),W(5),_(1),W(1),_(2),W(3),_(2),W(2),_(3),W(2),_(1=
),W(1),_(1),W(2),_(2)]
[2.1% dofio: job 'test' hasn't exited in 60 seconds, it appears to be
stuck. Doing forceful exit of this job.
>    Jobs: 81 (f=3D81):
[W(1),_(1),W(1),_(1),W(1),_(1),W(3),_(1),W(11),_(1),W(5),_(1),W(2),_(1),W(9=
),_(2),W(4),_(1),W(1),_(3),W(3),_(3),W(2),_(1),f(1),_(1),W(1),_(1),W(1),_(1=
),f(1),W(1),_(2),W(7),_(1),W(2),_(2),W(1),_(1),W(1),_(3),W(1),_(3),W(3),_(1=
),W(1),_(1),W(1),_(1),W(5),_(1),W(1),_(2),W(3),_(2),W(2),_(3),W(2),_(1),W(1=
),_(1),W(2),_(2)]
[2.1% done] [fio: job 'test' hasn't exited in 60 seconds, it appears to be
stuck. Doing forceful exit of this job.
>    fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck.
Doing forceful exit of this job.
>    fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck.
Doing forceful exit of this job.
>    Jobs: 77 (f=3D77):
[W(1),_(1),W(1),_(4),W(2),_(1),W(11),_(1),W(5),_(1),W(2),_(1),W(9),_(2),W(4=
),_(1),W(1),_(3),W(3),_(3),W(2),_(1),W(1),_(1),W(1),_(1),W(1),_(1),f(1),W(1=
),_(2),W(7),_(1),W(2),_(2),W(1),_(1),W(1),_(3),W(1),_(3),W(3),_(1),W(1),_(1=
),W(1),_(3),W(3),_(1),W(1),_(2),W(3),_(2),W(2),_(3),W(2),_(1),W(1),_(1),W(2=
),_(2)]
[1.9% done] [0KB/275KB/fio: job 'test' hasn't exited in 89 seconds, it
appears to be stuck. Doing forceful exit of this job.
>    Jobs: 77 (f=3D77):
[W(1),_(1),W(1),_(4),W(2),_(1),W(11),_(1),W(5),_(1),W(2),_(1),W(9),_(2),W(4=
),_(1),f(1),_(3),W(3),_(3),W(2),_(1),W(1),_(1),W(1),_(1),W(1),_(1),W(2),_(2=
),W(7),_(1),W(2),_(2),W(1),_(1),W(1),_(3),W(1),_(3),W(3),_(1),W(1),_(1),W(1=
),_(3),W(3),_(1),W(1),_(2),W(3),_(2),W(2),_(3),W(2),_(1),W(1),_(1),W(2),_(2=
)]
[1.9% done] [0KB/16256KB/0KBfio: job 'test' hasn't exited in 104 seconds,
it appears to be stuck. Doing forceful exit of this job.
>    fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck.
Doing forceful exit of this job.
>    fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck.
Doing forceful exit of this job.
>    Jobs: 77 (f=3D77):
[W(1),_(1),W(1),_(4),W(2),_(1),W(5),f(1),W(5),_(1),W(5),_(1),W(2),_(1),W(9)=
,_(2),W(4),_(1),f(1),_(3),W(3),_(3),W(2),_(1),W(1),_(1),W(1),_(1),W(1),_(1)=
,W(2),_(2),W(7),_(1),W(2),_(2),W(1),_(1),W(1),_(3),W(1),_(3),W(3),_(1),W(1)=
,_(1),W(1),_(3),W(3),_(1),W(1),_(2),W(3),_(2),W(2),_(3),W(2),_(1),W(1),_(1)=
,W(2),_(2)]
[1.9% done] [0KB/29fio: job 'test' hasn't exited in 60 seconds, it appears
to be stuck. Doing forceful exit of this job.
>    fio: job 'test' hasn't exited in 110 seconds, it appears to be stuck.
Doing forceful exit of this job.
>    Jobs: 75 (f=3D75):
[W(1),_(1),W(1),_(4),W(2),_(1),W(5),f(1),W(5),_(1),W(5),_(1),W(2),_(1),W(1)=
,_(1),W(7),_(2),f(1),W(3),_(1),W(1),_(3),W(3),_(3),W(2),_(1),W(1),_(1),W(1)=
,_(1),W(1),_(1),W(2),_(2),W(7),_(1),W(2),_(2),W(1),_(5),W(1),_(3),W(3),_(1)=
,W(1),_(1),W(1),_(3),W(3),_(1),W(1),_(2),W(3),_(2),W(2),_(3),W(2),_(1),W(1)=
,_(1),W(2),_(2)]
[1.8% done] [0fio: job 'test' hasn't exited in 60 seconds, it appears to be
stuck. Doing forceful exit of this job.
>    Jobs: 73 (f=3D73):
[W(1),_(1),W(1),_(4),W(2),_(1),W(11),_(2),W(4),_(1),W(2),_(1),W(1),_(1),W(7=
),_(2),W(4),_(1),W(1),_(3),W(3),_(3),W(2),_(1),W(1),_(1),W(1),_(1),W(1),_(1=
),W(2),_(2),W(2),f(1),W(4),_(1),W(2),_(2),W(1),_(5),W(1),_(3),W(3),_(1),W(1=
),_(1),W(1),_(3),W(3),_(4),W(3),_(2),W(2),_(3),W(2),_(1),W(1),_(1),W(2),_(2=
)]
[1.7% done] [0KB/8633KB/0KB fio: job 'test' hasn't exited in 60 seconds, it
appears to be stuck. Doing forceful exit of this job.
>    fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck.
Doing forceful exit of this job.
>    Jobs: 71 (f=3D71):
[W(1),_(1),W(1),_(4),W(2),_(1),W(1),_(1),W(1),f(1),W(7),_(2),W(4),_(1),W(2)=
,_(1),W(1),_(1),W(7),_(2),W(4),_(1),W(1),_(3),W(3),_(3),W(2),_(1),W(1),_(1)=
,W(1),_(1),W(1),_(1),W(2),_(2),W(7),_(1),W(2),_(2),W(1),_(5),W(1),_(3),W(3)=
,_(1),W(1),_(1),W(1),_(3),W(3),_(4),W(3),_(2),W(1),_(4),W(2),_(1),W(1),_(1)=
,W(2),_(2)]
[1.7% done] [0KB/51fio: job 'test' hasn't exited in 60 seconds, it appears
to be stuck. Doing forceful exit of this job.
>    fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck.
Doing forceful exit of this job.
>    Jobs: 69 (f=3D69):
[W(1),_(1),W(1),_(4),W(2),_(1),W(1),_(2),W(8),_(2),W(4),_(1),W(2),_(1),W(1)=
,_(1),W(7),_(2),W(4),_(1),W(1),_(3),W(3),_(3),W(2),_(1),W(1),_(1),W(1),_(1)=
,W(1),_(1),W(2),_(2),W(7),_(2),W(1),_(2),W(1),_(5),W(1),_(3),W(3),_(1),W(1)=
,_(1),W(1),_(3),W(3),_(4),f(1),W(2),_(2),W(1),_(4),W(2),_(1),W(1),_(1),f(1)=
,W(1),_(2)]
[1.6% done] [0KB/14Jobs: 69 (f=3D69):
[W(1),_(1),W(1),_(4),W(2),_(1),W(1),_(2),W(8),_(2),W(4),_(1),W(2),_(1),W(1)=
,_(1),W(7),_(2),W(4),_(1),W(1),_(3),W(3),_(3),W(2),_(1),W(1),_(1),W(1),_(1)=
,W(1),_(1),W(2),_(2),W(3),f(1),W(3),_(2),W(1),_(2),W(1),_(5),W(1),_(3),W(3)=
,_(1),W(1),_(1),W(1),_(3),W(3),_(4),f(1),W(2),_(2),W(1),_(4),W(2),_(1),W(1)=
,_(1),f(1),W(1),_(2)]
[1.6% donfio: job 'test' hasn't exited in 60 seconds, it appears to be
stuck. Doing forceful exit of this job.
>    fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck.
Doing forceful exit of this job.
>    Jobs: 68 (f=3D68):
[W(1),_(1),W(1),_(4),W(2),_(1),W(1),_(2),W(8),_(2),W(1),_(1),W(2),_(1),W(2)=
,_(1),W(1),_(1),W(7),_(2),W(1),f(1),W(2),_(1),W(1),_(3),W(3),_(3),W(2),_(1)=
,W(1),_(1),W(1),_(1),W(1),_(1),W(2),_(2),W(3),f(1),W(3),_(2),W(1),_(2),W(1)=
,_(5),W(1),_(3),W(3),_(1),W(1),_(1),W(1),_(3),W(3),_(4),W(3),_(2),W(1),_(4)=
,W(2),_(1),W(1),_(1),W(2),_(2)]Jobs:
67 (f=3D67):
[W(1),_(1),W(1),_(4),W(2),_(1),W(1),_(2),W(1),_(1),W(6),_(2),W(1),_(1),W(2)=
,_(1),W(2),_(1),W(1),_(1),W(7),_(2),W(4),_(1),W(1),_(3),W(3),_(3),W(2),_(1)=
,W(1),_(1),W(1),_(1),W(1),_(1),W(2),_(2),W(7),_(2),W(1),_(2),W(1),_(5),W(1)=
,_(3),W(3),_(1),W(1),_(1),W(1),_(3),W(1),f(1),W(1),_(4),W(3),_(2),W(1),_(4)=
,W(2),_(1),W(1),_(1),W(2),_(2)]fio:
job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doing
forceful exit of this job.
>    fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck.
Doing forceful exit of this job.
>    fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck.
Doing forceful exit of this job.
>    fio: job 'test' hasn't exited in 100 seconds, it appears to be stuck.
Doing forceful exit of this job.
>    fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck.
Doing forceful exit of this job.
>    Jobs: 64 (f=3D64):
[_(2),W(1),_(4),W(2),_(1),W(1),_(2),W(1),_(1),W(6),_(2),W(1),_(1),W(2),_(1)=
,W(2),_(1),W(1),_(1),W(7),_(2),W(3),_(2),W(1),_(3),W(3),_(3),W(2),_(1),W(1)=
,_(1),W(1),_(1),W(1),_(1),W(1),f(1),_(3),W(6),_(2),f(1),_(2),W(1),_(5),W(1)=
,_(3),W(3),_(1),W(1),_(1),W(1),_(3),W(1),f(1),W(1),_(4),W(3),_(2),W(1),_(4)=
,f(1),W(1),_(1),W(1),_(1),W(2),Jobs:
63 (f=3D63):
[_(7),W(2),_(1),W(1),_(2),W(1),_(1),W(6),_(2),W(1),_(1),W(2),_(1),W(2),_(1)=
,W(1),_(1),W(7),_(2),W(3),_(2),W(1),_(3),W(3),_(3),W(2),_(1),W(1),_(1),W(1)=
,_(1),W(1),_(1),W(1),f(1),_(3),W(6),_(2),f(1),_(2),W(1),_(5),W(1),_(3),W(3)=
,_(1),W(1),_(1),W(1),_(3),W(3),_(4),W(3),_(2),W(1),_(4),f(1),W(1),_(1),W(1)=
,_(1),W(2),_(2)]
[1.5% done] [0fio: job 'test' hasn't exited in 60 seconds, it appears to be
stuck. Doing forceful exit of this job.
>    fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck.
Doing forceful exit of this job.
>    fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck.
Doing forceful exit of this job.
>    Jobs: 62 (f=3D62):
[_(7),W(2),_(1),W(1),_(2),W(1),_(1),W(6),_(2),W(1),_(1),W(2),_(2),W(1),_(1)=
,W(1),_(1),W(7),_(2),W(3),_(2),W(1),_(3),W(3),_(3),W(2),_(1),W(1),_(1),W(1)=
,_(1),W(1),_(1),W(2),_(3),W(6),_(2),W(1),_(2),W(1),_(5),W(1),_(3),W(3),_(1)=
,W(1),_(1),W(1),_(3),W(3),_(4),W(3),_(2),W(1),_(4),W(2),_(1),W(1),_(1),W(2)=
,_(2)]
[1.5% done] [0KB/1263KB/Jobs: 60 (f=3D60):
[_(7),W(2),_(1),W(1),_(2),W(1),_(1),W(6),_(2),W(1),_(1),W(2),_(2),W(1),_(1)=
,W(1),_(1),W(2),_(1),W(4),_(2),W(3),_(2),W(1),_(3),W(3),_(3),W(2),_(1),W(1)=
,_(1),W(1),_(1),W(1),_(1),W(2),_(3),W(6),_(2),W(1),_(2),W(1),_(5),W(1),_(3)=
,W(1),_(1),W(1),_(1),W(1),_(1),W(1),_(3),W(3),_(4),W(2),f(1),_(2),W(1),_(4)=
,W(2),_(1),W(1),_(1),W(2),_(2)]fio:
job 'test' hasn't exited in 101 seconds, it appears to be stuck. Doing
forceful exit of this job.
>    fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck.
Doing forceful exit of this job.
>    Jobs: 59 (f=3D59):
[_(7),W(2),_(1),W(1),_(2),W(1),_(1),W(6),_(2),W(1),_(1),W(2),_(2),W(1),_(1)=
,W(1),_(1),W(2),_(1),W(4),_(2),W(3),_(2),W(1),_(3),W(2),f(1),_(3),W(2),_(1)=
,W(1),_(1),W(1),_(1),W(1),_(1),W(2),_(3),W(4),_(1),W(1),_(2),W(1),_(2),W(1)=
,_(5),W(1),_(3),W(1),_(1),W(1),_(1),W(1),_(1),W(1),_(3),W(3),_(4),W(3),_(2)=
,W(1),_(4),W(2),_(1),W(1),_(1),fio:
job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doing
forceful exit of this job.
>    fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck.
Doing forceful exit of this job.
>    Jobs: 58 (f=3D58):
[_(7),W(2),_(1),W(1),_(2),W(1),_(1),W(6),_(2),W(1),_(1),W(2),_(2),W(1),_(1)=
,W(1),_(2),W(1),_(1),W(4),_(2),W(3),_(2),W(1),_(3),W(2),f(1),_(3),W(2),_(1)=
,W(1),_(1),W(1),_(1),W(1),_(1),W(2),_(3),W(4),_(1),W(1),_(2),W(1),_(2),W(1)=
,_(5),W(1),_(3),W(1),_(1),W(1),_(1),W(1),_(1),W(1),_(3),W(3),_(4),W(1),f(1)=
,W(1),_(2),W(1),_(4),W(2),_(1),fio:
job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doing
forceful exit of this job.
>    Jobs: 56 (f=3D56):
[_(7),W(2),_(1),W(1),_(2),W(1),_(1),W(6),_(2),f(1),_(2),W(1),_(2),W(1),_(1)=
,W(1),_(2),W(1),_(1),W(3),f(1),_(2),W(3),_(2),W(1),_(3),W(1),_(1),f(1),_(3)=
,W(2),_(1),W(1),_(1),W(1),_(1),W(1),_(1),W(2),_(3),W(4),_(1),W(1),_(2),W(1)=
,_(2),W(1),_(5),W(1),_(3),W(1),_(1),W(1),_(1),W(1),_(1),W(1),_(3),f(1),W(2)=
,_(4),W(3),_(2),W(1),_(4),W(2),fio:
job 'test' hasn't exited in 92 seconds, it appears to be stuck. Doing
forceful exit of this job.
>    fio: job 'test' hasn't exited in 95 seconds, it appears to be stuck.
Doing forceful exit of this job.
>    fio: job 'test' hasn't exited in 96 seconds, it appears to be stuck.
Doing forceful exit of this job.
>    fio: job 'test' hasn't exited in 100 seconds, it appears to be stuck.
Doing forceful exit of this job.
>    fio: job 'test' hasn't exited in 95 seconds, it appears to be stuck.
Doing forceful exit of this job.
>    fio: job 'test' hasn't exited in 95 seconds, it appears to be stuck.
Doing forceful exit of this job.
>    fio: job 'test' hasn't exited in 95 seconds, it appears to be stuck.
Doing forceful exit of this job.
>    fio: job 'test' hasn't exited in 97 seconds, it appears to be stuck.
Doing forceful exit of this job.
>
> Thanks for your feedback
>
> Regards,
> Thierry
>

--001a1148d7ca271ef505283437ed
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<p dir=3D"ltr"><br>
On Dec 31, 2015 19:19, &quot;Thierry BERTAUD&quot; &lt;<a href=3D"mailto:tb=
ertaud@conforama.fr">tbertaud@conforama.fr</a>&gt; wrote:<br>
&gt;<br>
&gt; Hi Jens and Andrey,<br>
&gt;<br>
&gt; &gt;I&#39;ll be taking a bit of time off, but I should have access to =
an AIX<br>
&gt; &gt;that I can test on sometime next week. What version are you on?<br=
>
&gt;<br>
&gt; At this time i use a VIOS 2.2.3.52=C2=A0 aka AIX 6100-08-01-1245. I ne=
ed to build fio against AIX 6.x, 7.x.<br>
&gt; After next week, i&#39;ll reinstall the server to go to production. So=
 i&#39;ll need to look for a new box with a FC card so i&#39;ll use another=
 AIX version.<br>
&gt;<br>
&gt; For your information i don&#39;t have the issue with:<br>
&gt; HDISK=3Dhdisk6 RWTYPE=3Drw RRATIO=3D0 BS=3D4096 QD=3D128 NJ=3D128=C2=
=A0 /home/padmin/fio/fio-5f3bd0f/fio myfio.fio<br>
&gt; but<br>
&gt; HDISK=3Dhdisk6 RWTYPE=3Drw RRATIO=3D0 BS=3D65536 QD=3D128 NJ=3D128=C2=
=A0 /home/padmin/fio/fio-5f3bd0f/fio myfio.fio<br>
&gt;<br>
&gt; So i think it&#39;s perhaps some hardware or OS comportement that the =
cause of the issue it&#39;s not fio fio=C2=A0 (it&#39;s not the guilty but =
a collateral victim) but idon&#39;t find why because the statistics data fr=
om SAN seems OK.<br>
&gt; SAN stats during test:<br>
&gt; Latency (ms):=C2=A0 =C2=A0 =C2=A0 R: 0/ W 0.17<br>
&gt; Thoughput (M): R 0=C2=A0 / W 9.8<br>
&gt; IOPS:=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 R 0 / W 2380<br>
&gt;<br>
&gt;<br>
&gt; 1. fIo stay stuck with the last print:<br>
&gt; =C2=A0 =C2=A0fio: job &#39;test&#39; hasn&#39;t exited in 97 seconds, =
it appears to be stuck. Doing forceful exit of this job.<br>
&gt;<br>
&gt; 1.1 The only process that&#39;s stay a live is the min fio process (al=
l others 128 childs have been died or finished)<br>
&gt; # ps -ef | grep fio | grep -v grep<br>
&gt; =C2=A0 =C2=A0 root 41877588 48234628 120 16:18:23=C2=A0 pts/1=C2=A0 1:=
20 /home/padmin/fio/fio-5f3bd0f/fio myfio.fio<br>
&gt; #<br>
&gt;<br>
&gt; 1.3 System monitor indicate no disk activty test is over but the main =
process uses CPU.<br>
&gt; =C2=A0 =C2=A0Topas Monitor for host:=C2=A0 =C2=A0 XVIOS16<br>
&gt; =C2=A0 =C2=A0Thu Dec 31 16:28:19 2015=C2=A0 =C2=A0Interval:=C2=A0 2<br=
>
&gt;<br>
&gt; =C2=A0 =C2=A0CPU=C2=A0 User%=C2=A0 Kern%=C2=A0 Wait%=C2=A0 Idle%=C2=A0=
 Physc=C2=A0 =C2=A0Entc<br>
&gt; =C2=A0 =C2=A0ALL=C2=A0 =C2=A057.4=C2=A0 =C2=A0 5.8=C2=A0 =C2=A0 0.0=C2=
=A0 =C2=A036.8=C2=A0 =C2=A01.01=C2=A0 101.5<br>
&gt;<br>
&gt; =C2=A0 =C2=A0Disk=C2=A0 =C2=A0 Busy%=C2=A0 =C2=A0 =C2=A0KBPS=C2=A0 =C2=
=A0 =C2=A0TPS KB-Read KB-Writ<br>
&gt; =C2=A0 =C2=A0hdisk3=C2=A0 =C2=A0 0.0=C2=A0 =C2=A0 =C2=A00.0=C2=A0 =C2=
=A0 =C2=A0 0.0=C2=A0 =C2=A0 0.0=C2=A0 =C2=A0 =C2=A00.0<br>
&gt; =C2=A0 =C2=A0hdisk2=C2=A0 =C2=A0 0.0=C2=A0 =C2=A0 =C2=A00.0=C2=A0 =C2=
=A0 =C2=A0 0.0=C2=A0 =C2=A0 0.0=C2=A0 =C2=A0 =C2=A00.0<br>
&gt; =C2=A0 =C2=A0hdisk9=C2=A0 =C2=A0 0.0=C2=A0 =C2=A0 =C2=A00.0=C2=A0 =C2=
=A0 =C2=A0 0.0=C2=A0 =C2=A0 0.0=C2=A0 =C2=A0 =C2=A00.0<br>
&gt; =C2=A0 =C2=A0hdisk1=C2=A0 =C2=A0 0.0=C2=A0 =C2=A0 =C2=A00.0=C2=A0 =C2=
=A0 =C2=A0 0.0=C2=A0 =C2=A0 0.0=C2=A0 =C2=A0 =C2=A00.0<br>
&gt; =C2=A0 =C2=A0hdisk0=C2=A0 =C2=A0 0.0=C2=A0 =C2=A0 =C2=A00.0=C2=A0 =C2=
=A0 =C2=A0 0.0=C2=A0 =C2=A0 0.0=C2=A0 =C2=A0 =C2=A00.0<br>
&gt; =C2=A0 =C2=A0hdisk10=C2=A0 =C2=A00.0=C2=A0 =C2=A0 =C2=A00.0=C2=A0 =C2=
=A0 =C2=A0 0.0=C2=A0 =C2=A0 0.0=C2=A0 =C2=A0 =C2=A00.0<br>
&gt; =C2=A0 =C2=A0hdisk7=C2=A0 =C2=A0 0.0=C2=A0 =C2=A0 =C2=A00.0=C2=A0 =C2=
=A0 =C2=A0 0.0=C2=A0 =C2=A0 0.0=C2=A0 =C2=A0 =C2=A00.0<br>
&gt; =C2=A0 =C2=A0hdisk4=C2=A0 =C2=A0 0.0=C2=A0 =C2=A0 =C2=A00.0=C2=A0 =C2=
=A0 =C2=A0 0.0=C2=A0 =C2=A0 0.0=C2=A0 =C2=A0 =C2=A00.0<br>
&gt; =C2=A0 =C2=A0hdisk5=C2=A0 =C2=A0 0.0=C2=A0 =C2=A0 =C2=A00.0=C2=A0 =C2=
=A0 =C2=A0 0.0=C2=A0 =C2=A0 0.0=C2=A0 =C2=A0 =C2=A00.0<br>
&gt; =C2=A0 =C2=A0hdisk6=C2=A0 =C2=A0 0.0=C2=A0 =C2=A0 =C2=A00.0=C2=A0 =C2=
=A0 =C2=A0 0.0=C2=A0 =C2=A0 0.0=C2=A0 =C2=A0 =C2=A00.0<br>
&gt;<br>
&gt; =C2=A0 =C2=A0Name=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 PID=C2=A0 C=
PU%=C2=A0 PgSp Owner<br>
&gt; =C2=A0 =C2=A0fio=C2=A0 =C2=A0 =C2=A0 =C2=A0 41877588=C2=A0 62.6=C2=A0 =
=C2=A03.5 root<br>
&gt; =C2=A0 =C2=A0sched=C2=A0 =C2=A0 =C2=A0 =C2=A0 196614=C2=A0 =C2=A00.1=
=C2=A0 =C2=A00.4 root<br>
&gt; =C2=A0 =C2=A0vio_daem=C2=A0 =C2=A010682558=C2=A0 =C2=A00.0=C2=A0 46.1 =
root<br>
&gt; =C2=A0 =C2=A0seaproc=C2=A0 =C2=A0 =C2=A03997822=C2=A0 =C2=A00.0=C2=A0 =
=C2=A01.0 root<br>
&gt; =C2=A0 =C2=A0syncd=C2=A0 =C2=A0 =C2=A0 =C2=A03538998=C2=A0 =C2=A00.0=
=C2=A0 =C2=A00.6 root<br>
&gt; =C2=A0 =C2=A0java=C2=A0 =C2=A0 =C2=A0 =C2=A0 9764964=C2=A0 =C2=A00.0=
=C2=A0 84.2 root<br>
&gt;<br>
&gt; 1.5 During gdb against the process the cpu load disapear. If i don&#39=
;t dgb against the process the load stay alive.<br>
&gt;<br>
&gt; 2. 1:=C2=A0 gdb trace<br>
&gt; =C2=A0 =C2=A0# gdb -p 41877588<br>
&gt; =C2=A0 =C2=A0GNU gdb (GDB) 7.8.1<br>
&gt; =C2=A0 =C2=A0Copyright (C) 2014 Free Software Foundation, Inc.<br>
&gt; =C2=A0 =C2=A0License GPLv3+: GNU GPL version 3 or later &lt;<a href=3D=
"http://gnu.org/licenses/gpl.html">http://gnu.org/licenses/gpl.html</a>&gt;=
<br>
&gt; =C2=A0 =C2=A0This is free software: you are free to change and redistr=
ibute it.<br>
&gt; =C2=A0 =C2=A0There is NO WARRANTY, to the extent permitted by law.=C2=
=A0 Type &quot;show copying&quot;<br>
&gt; =C2=A0 =C2=A0and &quot;show warranty&quot; for details.<br>
&gt; =C2=A0 =C2=A0This GDB was configured as &quot;powerpc-ibm-aix5.1.0.0&q=
uot;.<br>
&gt; =C2=A0 =C2=A0Type &quot;show configuration&quot; for configuration det=
ails.<br>
&gt; =C2=A0 =C2=A0For bug reporting instructions, please see:<br>
&gt; =C2=A0 =C2=A0&lt;<a href=3D"http://www.gnu.org/software/gdb/bugs/">htt=
p://www.gnu.org/software/gdb/bugs/</a>&gt;.<br>
&gt; =C2=A0 =C2=A0Find the GDB manual and other documentation resources onl=
ine at:<br>
&gt; =C2=A0 =C2=A0&lt;<a href=3D"http://www.gnu.org/software/gdb/documentat=
ion/">http://www.gnu.org/software/gdb/documentation/</a>&gt;.<br>
&gt; =C2=A0 =C2=A0For help, type &quot;help&quot;.<br>
&gt; =C2=A0 =C2=A0Type &quot;apropos word&quot; to search for commands rela=
ted to &quot;word&quot;.<br>
&gt; =C2=A0 =C2=A0Attaching to process 41877588<br>
&gt; =C2=A0 =C2=A00xd0119598 in ?? ()<br>
&gt; =C2=A0 =C2=A0(gdb) info threads<br>
&gt; =C2=A0 =C2=A0 =C2=A0Id=C2=A0 =C2=A0Target Id=C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0Frame<br>
&gt; =C2=A0 =C2=A0* 1=C2=A0 =C2=A0 process 41877588=C2=A0 0xd0119598 in ?? =
()<br>
&gt; =C2=A0 =C2=A0(gdb) thread 1<br>
&gt; =C2=A0 =C2=A0[Switching to thread 1 (process 41877588)]<br>
&gt; =C2=A0 =C2=A0#0=C2=A0 0xd0119598 in ?? ()<br>
&gt; =C2=A0 =C2=A0(gdb) bt<br>
&gt; =C2=A0 =C2=A0#0=C2=A0 0xd0119598 in ?? ()<br>
&gt; =C2=A0 =C2=A0#1=C2=A0 0xffffffff in ?? ()<br>
&gt; =C2=A0 =C2=A0#2=C2=A0 0xd0119bc0 in ?? ()<br>
&gt; =C2=A0 =C2=A0#3=C2=A0 0xd0118f28 in ?? ()<br>
&gt; =C2=A0 =C2=A0#4=C2=A0 0x100625dc in ?? ()<br>
&gt; =C2=A0 =C2=A0#5=C2=A0 0x1006482c in ?? ()<br>
&gt; =C2=A0 =C2=A0#6=C2=A0 0x10064b90 in ?? ()<br>
&gt; =C2=A0 =C2=A0#7=C2=A0 0xd0505c10 in ?? ()<br>
&gt; =C2=A0 =C2=A0#8=C2=A0 0x00000000 in ?? ()<br>
&gt; =C2=A0 =C2=A0(gdb)<br>
&gt;<br>
&gt; 2.1.1 It semmes i nned to build fio with some option to have some symb=
ole. Which option i can use for that.<br>
&gt; At this time i just do: ./configure; gmake CC=3Dgcc<br>
&gt;</p>
<p dir=3D"ltr">Try &#39;configure --disable-optimizations&#39;.</p>
<p dir=3D"ltr">Regards,<br>
A.<br>
&gt; 2.2: The full log from fio:<br>
&gt; =C2=A0 =C2=A0# HDISK=3Dhdisk6 RWTYPE=3Drw RRATIO=3D0 BS=3D65536 QD=3D1=
28 NJ=3D128=C2=A0 /home/padmin/fio/fio-5f3bd0f/fio myfio.fio<br>
&gt; =C2=A0 =C2=A0test: (g=3D0): rw=3Drw, bs=3D64K-64K/64K-64K/64K-64K, ioe=
ngine=3Dposixaio, iodepth=3D128<br>
&gt; =C2=A0 =C2=A0...<br>
&gt; =C2=A0 =C2=A0fio-2.3<br>
&gt; =C2=A0 =C2=A0Starting 128 processes<br>
&gt; =C2=A0 =C2=A0fio: job &#39;test&#39; hasn&#39;t exited in 60 seconds, =
it appears to be stuck. Doing forceful exit of this job.:22s]<br>
&gt; =C2=A0 =C2=A0fio: job &#39;test&#39; hasn&#39;t exited in 60 seconds, =
it appears to be stuck. Doing forceful exit of this job.<br>
&gt; =C2=A0 =C2=A0fio: job &#39;test&#39; hasn&#39;t exited in 60 seconds, =
it appears to be stuck. Doing forceful exit of this job. iops] [eta 11m:34s=
]<br>
&gt; =C2=A0 =C2=A0fio: job &#39;test&#39; hasn&#39;t exited in 60 seconds, =
it appears to be stuck. Doing forceful exit of this job.] [0/138/0 iops] [e=
ta 17m:34s]<br>
&gt; =C2=A0 =C2=A0fio: job &#39;test&#39; hasn&#39;t exited in 60 seconds, =
it appears to be stuck. Doing forceful exit of this job.<br>
&gt; =C2=A0 =C2=A0fio: job &#39;test&#39; hasn&#39;t exited in 60 seconds, =
it appears to be stuck. Doing forceful exit of this job.4KB/0KB /s] [0/215/=
0 iops] [eta 29m:36s]<br>
&gt; =C2=A0 =C2=A0fio: job &#39;test&#39; hasn&#39;t exited in 60 seconds, =
it appears to be stuck. Doing forceful exit of this job.4.6% done] [0KB/748=
8KB/0KB /s] [0/117/0 iops] [eta 35m:36s]<br>
&gt; =C2=A0 =C2=A0fio: job &#39;test&#39; hasn&#39;t exited in 60 seconds, =
it appears to be stuck. Doing forceful exit of this job.1),W(21)] [12.8% do=
ne] [0KB/8617KB/0KB /s] [0/134/0 iops] [eta 41m:40s]<br>
&gt; =C2=A0 =C2=A0fio: job &#39;test&#39; hasn&#39;t exited in 60 seconds, =
it appears to be stuck. Doing forceful exit of this job.1),W(38)] [11.4% do=
ne] [0KB/856KB/0KB /s] [0/13/0 iops] [eta 47m:44s]<br>
&gt; =C2=A0 =C2=A0fio: job &#39;test&#39; hasn&#39;t exited in 60 seconds, =
it appears to be stuck. Doing forceful exit of this job.<br>
&gt; =C2=A0 =C2=A0Jobs: 118 (f=3D118): [f(1),W(8),_(1),W(11),_(1),W(2),f(1)=
,W(5),_(1),W(9),_(1),W(7),_(1),W(12),_(1),W(6),_(1),W(11),_(1),W(2),_(1),W(=
5),_(1),W(38)] [9.3% done] [0KB/20057KB/0KB fio: job &#39;test&#39; hasn&#3=
9;t exited in 60 seconds, it appears to be stuck. Doing forceful exit of th=
is job.<br>
&gt; =C2=A0 =C2=A0Jobs: 117 (f=3D117): [W(9),_(1),W(11),_(1),W(8),_(1),W(9)=
,_(1),W(4),f(1),W(2),_(1),W(1),_(1),W(10),_(1),W(6),_(1),W(11),_(1),W(2),_(=
1),W(5),_(1),W(38)] [8.5% done] [0KB/7255KB/fio: job &#39;test&#39; hasn&#3=
9;t exited in 60 seconds, it appears to be stuck. Doing forceful exit of th=
is job.<br>
&gt; =C2=A0 =C2=A0Jobs: 116 (f=3D116): [W(3),_(1),W(5),_(1),W(11),_(1),W(8)=
,_(1),W(9),_(1),W(7),_(1),W(1),_(1),W(10),_(1),W(6),_(1),W(11),_(1),W(2),_(=
1),W(5),_(1),W(38)] [7.9% done] [0KB/1130KB/Jobs: 116 (f=3D116): [W(2),f(1)=
,_(1),W(5),_(1),W(2),f(1),W(8),_(1),W(8),_(1),W(4),f(1),W(4),_(1),W(7),_(1)=
,W(1),_(1),W(10),_(1),W(6),_(1),W(11),_(1),W(2),_(1),W(5),_(1),W(38)] Jobs:=
 116 (f=3D116): [W(3),_(1),W(5),_(1),W(1),f(1),W(9),_(1),W(8),_(1),W(4),f(1=
),W(4),_(1),W(7),_(1),W(1),_(1),W(10),_(1),W(6),_(1),W(11),_(1),W(2),_(1),W=
(5),_(1),W(38)] [7.9%Jobs: 116 (f=3D116): [W(3),_(1),W(5),_(1),W(11),_(1),W=
(8),_(1),W(9),_(1),W(7),_(1),W(1),_(1),W(10),_(1),W(6),_(1),W(11),_(1),W(2)=
,_(1),W(5),_(1),W(38)] [7.9% done] [0KB/0KB/0KBfio: job &#39;test&#39; hasn=
&#39;t exited in 60 seconds, it appears to be stuck. Doing forceful exit of=
 this job.<br>
&gt; =C2=A0 =C2=A0Jobs: 115 (f=3D115): [W(3),_(1),W(5),_(1),W(11),_(1),W(3)=
,f(1),W(4),_(1),W(9),_(1),W(7),_(1),W(1),_(1),W(1),f(1),W(8),_(1),W(6),_(1)=
,W(11),_(1),W(2),_(1),W(5),_(1),W(36),_(1),WJobs: 115 (f=3D115): [W(3),_(1)=
,W(5),_(1),W(11),_(1),W(8),_(1),W(9),_(1),W(7),_(1),W(1),_(1),W(10),_(1),W(=
6),_(1),W(6),f(1),W(4),_(1),W(2),_(1),W(5),_(1),W(36),_(1),W(1)] [7.4%fio: =
job &#39;test&#39; hasn&#39;t exited in 60 seconds, it appears to be stuck.=
 Doing forceful exit of this job.<br>
&gt; =C2=A0 =C2=A0Jobs: 114 (f=3D114): [W(3),_(1),W(5),_(1),W(4),f(1),W(6),=
_(1),W(8),_(1),W(9),_(1),W(7),_(1),W(1),_(1),W(10),_(1),W(6),_(1),W(11),_(1=
),W(2),_(1),W(3),_(1),W(1),_(1),W(36),_(1),Wfio: job &#39;test&#39; hasn&#3=
9;t exited in 60 seconds, it appears to be stuck. Doing forceful exit of th=
is job.<br>
&gt; =C2=A0 =C2=A0Jobs: 113 (f=3D113): [W(3),_(1),W(5),_(1),W(11),_(1),W(6)=
,f(1),W(1),_(1),W(9),_(1),W(7),_(1),W(1),_(1),W(10),_(1),W(6),_(1),W(11),_(=
1),W(2),_(1),W(1),_(1),W(1),_(1),W(1),_(1),WJobs: 113 (f=3D113): [W(3),_(1)=
,W(5),_(1),W(11),_(1),W(6),f(1),W(1),_(1),W(2),f(2),W(5),_(1),W(7),_(1),W(1=
),_(1),f(1),W(9),_(1),W(6),_(1),W(11),_(1),W(2),_(1),W(1),_(1),W(1),_(Jobs:=
 113 (f=3D113): [W(3),_(1),W(5),_(1),W(11),_(1),W(8),_(1),W(2),f(2),W(5),_(=
1),W(7),_(1),W(1),_(1),f(1),W(9),_(1),W(6),_(1),W(11),_(1),W(2),_(1),W(1),_=
(1),W(1),_(1),W(1),_(fio: job &#39;test&#39; hasn&#39;t exited in 60 second=
s, it appears to be stuck. Doing forceful exit of this job.<br>
&gt; =C2=A0 =C2=A0fio: job &#39;test&#39; hasn&#39;t exited in 60 seconds, =
it appears to be stuck. Doing forceful exit of this job.<br>
&gt; =C2=A0 =C2=A0Jobs: 111 (f=3D111): [W(3),_(1),W(5),_(1),W(11),_(1),W(7)=
,f(1),_(1),W(9),_(2),W(6),_(1),W(1),_(1),W(3),_(1),W(6),_(1),W(6),_(1),W(11=
),_(1),W(2),_(1),W(1),_(1),W(1),_(1),W(1),_(fio: job &#39;test&#39; hasn&#3=
9;t exited in 60 seconds, it appears to be stuck. Doing forceful exit of th=
is job.<br>
&gt; =C2=A0 =C2=A0fio: job &#39;test&#39; hasn&#39;t exited in 60 seconds, =
it appears to be stuck. Doing forceful exit of this job.<br>
&gt; =C2=A0 =C2=A0Jobs: 110 (f=3D110): [W(3),_(1),W(5),_(1),W(10),f(1),_(1)=
,W(8),_(1),W(9),_(2),W(6),_(1),W(1),_(1),W(3),_(1),W(6),_(1),W(6),_(1),W(11=
),_(1),W(2),_(1),W(1),_(1),W(1),_(1),W(1),_(Jobs: 109 (f=3D109): [W(3),_(1)=
,f(1),W(4),_(1),W(10),f(1),_(1),W(8),_(1),W(9),_(2),W(6),_(1),W(1),_(1),W(3=
),_(1),W(6),_(1),W(6),_(1),W(11),_(1),W(2),_(1),W(1),_(1),W(1),_(1),W(fio: =
job &#39;test&#39; hasn&#39;t exited in 60 seconds, it appears to be stuck.=
 Doing forceful exit of this job.:55m:38s]<br>
&gt; =C2=A0 =C2=A0Jobs: 108 (f=3D108): [W(3),_(1),f(1),W(2),f(1),W(1),_(1),=
W(7),f(1),W(3),_(1),W(8),_(1),W(9),_(2),W(6),_(1),W(1),_(1),W(3),_(1),W(2),=
f(1),W(3),_(1),W(6),_(1),W(8),_(1),W(2),_(1)fio: job &#39;test&#39; hasn&#3=
9;t exited in 60 seconds, it appears to be stuck. Doing forceful exit of th=
is job./0KB /s] [0/142/0 iops] [eta 02h:01m:37s]<br>
&gt; =C2=A0 =C2=A0Jobs: 107 (f=3D107): [W(3),_(1),W(5),_(1),W(11),_(1),W(5)=
,_(1),W(2),_(1),W(9),_(2),W(6),_(1),W(1),_(1),W(3),_(1),W(6),_(1),W(6),_(1)=
,W(8),_(1),W(2),_(1),W(2),_(1),W(1),_(1),W(1Jobs: 107 (f=3D107): [W(3),_(1)=
,W(5),_(1),W(11),_(1),W(5),_(1),W(2),_(1),W(9),_(2),W(6),_(1),W(1),_(1),W(3=
),_(1),W(6),_(1),W(6),_(1),W(8),_(1),W(2),_(1),W(2),_(1),W(1),_(1),W(1fio: =
job &#39;test&#39; hasn&#39;t exited in 60 seconds, it appears to be stuck.=
 Doing forceful exit of this job.eta 02h:07m:35s]<br>
&gt; =C2=A0 =C2=A0Jobs: 106 (f=3D106): [W(3),_(1),W(5),_(1),W(6),f(1),W(1),=
f(1),W(2),_(1),W(5),_(1),W(2),_(1),W(7),f(1),W(1),_(2),W(6),_(1),W(1),_(1),=
W(3),_(1),W(6),_(1),W(6),_(1),W(8),_(1),W(2)Jobs: 106 (f=3D106): [W(3),_(1)=
,W(5),_(1),W(11),_(1),W(5),_(1),W(2),_(1),W(9),_(2),W(6),_(1),W(1),_(1),W(3=
),_(1),W(6),_(1),W(6),_(1),W(8),_(1),W(2),_(1),W(2),_(1),W(1),_(1),W(1fio: =
job &#39;test&#39; hasn&#39;t exited in 60 seconds, it appears to be stuck.=
 Doing forceful exit of this job.42/0 iops] [eta 02h:13m:57s]<br>
&gt; =C2=A0 =C2=A0Jobs: 105 (f=3D105): [W(3),_(1),W(5),_(1),W(11),_(1),W(5)=
,_(1),W(2),_(1),W(9),_(2),W(6),_(1),W(1),_(1),W(3),_(2),W(5),_(1),W(6),_(1)=
,W(8),_(1),W(2),_(1),W(2),_(1),W(1),_(1),W(1Jobs: 105 (f=3D105): [W(3),_(1)=
,W(5),_(1),W(11),_(1),W(5),_(1),W(2),_(1),W(9),_(2),W(6),_(1),W(1),_(1),W(3=
),_(2),W(2),f(1),W(2),_(1),W(6),_(1),W(8),_(1),W(2),_(1),W(2),_(1),W(1fio: =
job &#39;test&#39; hasn&#39;t exited in 60 seconds, it appears to be stuck.=
 Doing forceful exit of this job.3/0 iops] [eta 02h:19m:56s]<br>
&gt; =C2=A0 =C2=A0Jobs: 104 (f=3D104): [W(3),_(1),W(5),_(1),W(11),_(1),W(5)=
,_(1),W(2),_(1),W(9),_(2),W(6),_(1),W(1),_(1),W(3),_(2),W(2),f(1),W(2),_(1)=
,W(3),_(1),W(2),_(1),W(8),_(1),W(2),_(1),W(1fio: job &#39;test&#39; hasn&#3=
9;t exited in 60 seconds, it appears to be stuck. Doing forceful exit of th=
is job.B/0KB /s] [0/136/0 iops] [eta 02h:26m:24s]<br>
&gt; =C2=A0 =C2=A0Jobs: 103 (f=3D103): [W(3),_(1),W(5),_(1),W(11),_(1),W(5)=
,_(1),W(2),_(1),W(9),_(2),W(6),_(1),W(1),_(1),W(3),_(2),W(5),_(1),W(3),_(1)=
,W(2),_(1),W(8),_(1),W(2),_(1),W(1),f(1),_(1Jobs: 103 (f=3D103): [W(3),_(1)=
,W(5),_(1),W(11),_(1),W(5),_(1),W(2),_(1),W(9),_(2),W(6),_(1),W(1),_(1),W(3=
),_(2),W(5),_(1),W(3),_(1),W(2),_(1),W(8),_(1),W(2),_(1),W(2),_(1),W(1fio: =
job &#39;test&#39; hasn&#39;t exited in 60 seconds, it appears to be stuck.=
 Doing forceful exit of this job.ops] [eta 02h:32m:22s]<br>
&gt; =C2=A0 =C2=A0Jobs: 103 (f=3D103): [W(3),_(1),W(5),_(1),W(11),_(1),W(5)=
,_(1),W(2),_(1),W(9),_(2),W(6),_(1),W(1),_(1),W(3),_(2),W(5),_(1),W(2),f(1)=
,_(1),W(2),_(1),W(8),_(1),W(2),_(1),W(2),_(1fio: job &#39;test&#39; hasn&#3=
9;t exited in 60 seconds, it appears to be stuck. Doing forceful exit of th=
is job. [0/205/0 iops] [eta 02h:38m:22s]<br>
&gt; =C2=A0 =C2=A0fio: job &#39;test&#39; hasn&#39;t exited in 60 seconds, =
it appears to be stuck. Doing forceful exit of this job.<br>
&gt; =C2=A0 =C2=A0fio: job &#39;test&#39; hasn&#39;t exited in 60 seconds, =
it appears to be stuck. Doing forceful exit of this job.<br>
&gt; =C2=A0 =C2=A0fio: job &#39;test&#39; hasn&#39;t exited in 60 seconds, =
it appears to be stuck. Doing forceful exit of this job.<br>
&gt; =C2=A0 =C2=A0fio: job &#39;test&#39; hasn&#39;t exited in 60 seconds, =
it appears to be stuck. Doing forceful exit of this job.<br>
&gt; =C2=A0 =C2=A0Jobs: 97 (f=3D97): [W(3),_(1),W(5),_(1),W(11),_(1),W(5),_=
(1),W(2),_(1),W(9),_(2),W(6),_(3),W(3),_(2),W(5),_(1),W(3),_(1),W(2),_(2),W=
(7),_(1),W(2),_(1),W(2),_(1),W(1),_(1),W(1),Jobs: 97 (f=3D97): [W(3),_(1),W=
(5),_(1),W(11),_(1),W(5),_(1),W(2),_(1),W(9),_(2),W(6),_(3),W(3),_(2),W(5),=
_(1),W(3),_(1),W(2),_(2),W(6),f(1),_(1),W(2),_(1),W(2),_(1),W(1),_(1),Jobs:=
 97 (f=3D97): [W(3),_(1),W(5),_(1),W(11),_(1),W(5),_(1),W(2),_(1),W(9),_(2)=
,W(6),_(3),W(3),_(2),W(5),_(1),W(3),_(1),W(2),_(2),W(7),_(1),W(2),_(1),W(2)=
,_(1),W(1),_(1),W(1),fio: job &#39;test&#39; hasn&#39;t exited in 60 second=
s, it appears to be stuck. Doing forceful exit of this job./0KB /s] [0/0/0 =
iops] [eta 03h:08m:26s]<br>
&gt; =C2=A0 =C2=A0fio: job &#39;test&#39; hasn&#39;t exited in 60 seconds, =
it appears to be stuck. Doing forceful exit of this job.<br>
&gt; =C2=A0 =C2=A0fio: job &#39;test&#39; hasn&#39;t exited in 60 seconds, =
it appears to be stuck. Doing forceful exit of this job.<br>
&gt; =C2=A0 =C2=A0Jobs: 94 (f=3D94): [W(3),_(1),W(4),f(1),_(1),W(11),_(1),W=
(5),_(1),W(2),_(1),f(1),W(8),_(2),W(6),_(3),W(3),_(2),W(5),_(1),W(3),_(1),W=
(2),_(2),W(7),_(1),W(2),_(1),W(2),_(1),W(1),fio: job &#39;test&#39; hasn&#3=
9;t exited in 60 seconds, it appears to be stuck. Doing forceful exit of th=
is job. done] [0KB/14019KB/0KB /s] [0/219/0 iops] [eta 03h:26m:33s]<br>
&gt; =C2=A0 =C2=A0fio: job &#39;test&#39; hasn&#39;t exited in 60 seconds, =
it appears to be stuck. Doing forceful exit of this job.<br>
&gt; =C2=A0 =C2=A0Jobs: 92 (f=3D92): [W(3),_(1),W(4),f(1),_(1),W(11),_(1),W=
(5),_(1),W(2),_(1),f(1),W(8),_(2),W(6),_(3),W(3),_(2),W(5),_(1),W(3),_(1),W=
(2),_(2),W(7),_(1),W(2),_(1),W(2),_(1),W(1),fio: job &#39;test&#39; hasn&#3=
9;t exited in 60 seconds, it appears to be stuck. Doing forceful exit of th=
is job.(2)] [2.9% done] [0KB/1593KB/0KB /s] [0/24/0 iops] [eta 03h:38m:38s]=
<br>
&gt; =C2=A0 =C2=A0Jobs: 91 (f=3D91): [W(3),_(1),W(5),_(1),W(11),_(1),W(5),_=
(1),W(2),_(1),W(9),_(2),W(6),_(3),W(3),_(2),W(5),_(1),W(3),_(1),W(2),_(2),W=
(7),_(1),W(2),_(1),W(2),_(1),W(1),_(1),W(1),fio: job &#39;test&#39; hasn&#3=
9;t exited in 60 seconds, it appears to be stuck. Doing forceful exit of th=
is job.(2)] [2.9% done] [0KB/5694KB/0KB /s] [0/88/0 iops] [eta 03h:44m:49s]=
<br>
&gt; =C2=A0 =C2=A0fio: job &#39;test&#39; hasn&#39;t exited in 60 seconds, =
it appears to be stuck. Doing forceful exit of this job.<br>
&gt; =C2=A0 =C2=A0Jobs: 89 (f=3D89): [W(3),_(1),W(5),_(1),W(11),_(1),W(4),f=
(1),_(1),W(2),_(1),W(6),f(1),W(2),_(2),W(6),_(3),W(3),_(3),W(4),_(1),W(3),_=
(1),W(2),_(2),W(1),f(1),W(5),_(1),W(2),_(1),W(2),_(1),W(1),_(1),W(1),_(1),W=
(1),_(3),W(3),_(1),f(1),_(1),W(1),_(1),W(5),_(1),W(1),_(2),W(3),_(2),W(2),_=
(3),W(4),_(1),W(2),_(2)] [2.7% done] [0KB/15730KB/0KB /s] [0/245/0 ifio: jo=
b &#39;test&#39; hasn&#39;t exited in 61 seconds, it appears to be stuck. D=
oing forceful exit of this job.<br>
&gt; =C2=A0 =C2=A0fio: job &#39;test&#39; hasn&#39;t exited in 60 seconds, =
it appears to be stuck. Doing forceful exit of this job.<br>
&gt; =C2=A0 =C2=A0Jobs: 87 (f=3D87): [W(3),_(1),W(5),_(1),W(11),_(1),W(4),f=
(1),_(1),W(2),_(1),W(6),f(1),W(2),_(2),W(6),_(3),W(3),_(3),W(4),_(1),W(3),_=
(1),W(2),_(2),W(1),f(1),W(5),_(1),W(2),_(2),W(1),_(1),W(1),_(3),W(1),_(3),W=
(2),f(1),_(1),f(1),_(1),W(1),_(1),W(5),_(1),W(1),_(2),W(3),_(2),W(2),_(3),W=
(4),_(1),W(2),_(2)] [2.6% done] [0KB/12825KB/0KB /s] [0/200/0 iops] fio: jo=
b &#39;test&#39; hasn&#39;t exited in 60 seconds, it appears to be stuck. D=
oing forceful exit of this job.<br>
&gt; =C2=A0 =C2=A0fio: job &#39;test&#39; hasn&#39;t exited in 60 seconds, =
it appears to be stuck. Doing forceful exit of this job.<br>
&gt; =C2=A0 =C2=A0fio: job &#39;test&#39; hasn&#39;t exited in 94 seconds, =
it appears to be stuck. Doing forceful exit of this job.<br>
&gt; =C2=A0 =C2=A0Jobs: 85 (f=3D85): [W(3),_(1),W(5),_(1),W(11),_(1),W(4),f=
(1),_(1),W(2),_(1),W(9),_(2),W(6),_(3),W(3),_(3),W(4),_(1),W(1),_(1),W(1),_=
(1),W(2),_(2),W(1),f(1),W(5),_(1),W(2),_(2),W(1),_(1),W(1),_(3),W(1),_(3),f=
(1),W(2),_(1),W(1),_(1),W(1),_(1),W(5),_(1),W(1),_(2),W(3),_(2),W(2),_(3),W=
(2),_(1),W(1),_(1),W(2),_(2)] [2.5% done] [0KB/10149KB/0KB /s] [0/15fio: jo=
b &#39;test&#39; hasn&#39;t exited in 100 seconds, it appears to be stuck. =
Doing forceful exit of this job.<br>
&gt; =C2=A0 =C2=A0Jobs: 86 (f=3D86): [W(3),_(1),W(5),_(1),W(11),_(1),W(5),_=
(1),W(2),_(1),W(9),_(2),W(2),f(1),W(3),_(3),W(3),_(3),W(4),_(1),W(1),_(1),W=
(1),_(1),W(2),_(2),W(7),_(1),W(2),f(1),_(1),W(1),_(1),W(1),_(3),W(1),_(3),f=
(1),W(2),_(1),W(1),_(1),W(1),_(1),W(5),_(1),W(1),_(2),W(3),_(2),W(2),_(3),W=
(2),_(1),W(1),_(1),W(2),_(2)] [2.4% done] [0KB/15226KB/0KB /s] [0/23fio: jo=
b &#39;test&#39; hasn&#39;t exited in 60 seconds, it appears to be stuck. D=
oing forceful exit of this job.<br>
&gt; =C2=A0 =C2=A0fio: job &#39;test&#39; hasn&#39;t exited in 60 seconds, =
it appears to be stuck. Doing forceful exit of this job.<br>
&gt; =C2=A0 =C2=A0fio: job &#39;test&#39; hasn&#39;t exited in 103 seconds,=
 it appears to be stuck. Doing forceful exit of this job.<br>
&gt; =C2=A0 =C2=A0fio: job &#39;test&#39; hasn&#39;t exited in 60 seconds, =
it appears to be stuck. Doing forceful exit of this job.<br>
&gt; =C2=A0 =C2=A0Jobs: 83 (f=3D83): [W(1),_(1),W(1),_(1),W(5),_(1),W(9),f(=
1),W(1),_(1),W(5),_(1),W(2),_(1),W(9),_(2),W(6),_(3),W(3),_(3),W(2),_(1),W(=
1),_(1),W(1),_(1),W(1),_(1),W(2),_(2),W(7),_(1),W(2),_(2),W(1),_(1),W(1),_(=
3),W(1),_(3),W(3),_(1),W(1),_(1),W(1),_(1),W(5),_(1),W(1),_(2),W(3),_(2),W(=
2),_(3),W(2),_(1),W(1),_(1),W(2),_(2)] [2.2% done] [0KB/12140KB/0KB fio: jo=
b &#39;test&#39; hasn&#39;t exited in 60 seconds, it appears to be stuck. D=
oing forceful exit of this job.<br>
&gt; =C2=A0 =C2=A0fio: job &#39;test&#39; hasn&#39;t exited in 103 seconds,=
 it appears to be stuck. Doing forceful exit of this job.<br>
&gt; =C2=A0 =C2=A0Jobs: 81 (f=3D81): [W(1),_(1),W(1),_(1),W(1),_(1),W(3),_(=
1),W(11),_(1),W(5),_(1),W(2),_(1),W(9),_(2),W(4),_(1),W(1),_(3),W(3),_(3),W=
(2),_(1),f(1),_(1),W(1),_(1),W(1),_(1),W(2),_(2),W(4),f(1),W(2),_(1),W(2),_=
(2),W(1),_(1),W(1),_(3),W(1),_(3),W(3),_(1),W(1),_(1),W(1),_(1),W(5),_(1),W=
(1),_(2),W(3),_(2),W(2),_(3),W(2),_(1),W(1),_(1),W(2),_(2)] [2.1% dofio: jo=
b &#39;test&#39; hasn&#39;t exited in 60 seconds, it appears to be stuck. D=
oing forceful exit of this job.<br>
&gt; =C2=A0 =C2=A0Jobs: 81 (f=3D81): [W(1),_(1),W(1),_(1),W(1),_(1),W(3),_(=
1),W(11),_(1),W(5),_(1),W(2),_(1),W(9),_(2),W(4),_(1),W(1),_(3),W(3),_(3),W=
(2),_(1),f(1),_(1),W(1),_(1),W(1),_(1),f(1),W(1),_(2),W(7),_(1),W(2),_(2),W=
(1),_(1),W(1),_(3),W(1),_(3),W(3),_(1),W(1),_(1),W(1),_(1),W(5),_(1),W(1),_=
(2),W(3),_(2),W(2),_(3),W(2),_(1),W(1),_(1),W(2),_(2)] [2.1% done] [fio: jo=
b &#39;test&#39; hasn&#39;t exited in 60 seconds, it appears to be stuck. D=
oing forceful exit of this job.<br>
&gt; =C2=A0 =C2=A0fio: job &#39;test&#39; hasn&#39;t exited in 60 seconds, =
it appears to be stuck. Doing forceful exit of this job.<br>
&gt; =C2=A0 =C2=A0fio: job &#39;test&#39; hasn&#39;t exited in 60 seconds, =
it appears to be stuck. Doing forceful exit of this job.<br>
&gt; =C2=A0 =C2=A0Jobs: 77 (f=3D77): [W(1),_(1),W(1),_(4),W(2),_(1),W(11),_=
(1),W(5),_(1),W(2),_(1),W(9),_(2),W(4),_(1),W(1),_(3),W(3),_(3),W(2),_(1),W=
(1),_(1),W(1),_(1),W(1),_(1),f(1),W(1),_(2),W(7),_(1),W(2),_(2),W(1),_(1),W=
(1),_(3),W(1),_(3),W(3),_(1),W(1),_(1),W(1),_(3),W(3),_(1),W(1),_(2),W(3),_=
(2),W(2),_(3),W(2),_(1),W(1),_(1),W(2),_(2)] [1.9% done] [0KB/275KB/fio: jo=
b &#39;test&#39; hasn&#39;t exited in 89 seconds, it appears to be stuck. D=
oing forceful exit of this job.<br>
&gt; =C2=A0 =C2=A0Jobs: 77 (f=3D77): [W(1),_(1),W(1),_(4),W(2),_(1),W(11),_=
(1),W(5),_(1),W(2),_(1),W(9),_(2),W(4),_(1),f(1),_(3),W(3),_(3),W(2),_(1),W=
(1),_(1),W(1),_(1),W(1),_(1),W(2),_(2),W(7),_(1),W(2),_(2),W(1),_(1),W(1),_=
(3),W(1),_(3),W(3),_(1),W(1),_(1),W(1),_(3),W(3),_(1),W(1),_(2),W(3),_(2),W=
(2),_(3),W(2),_(1),W(1),_(1),W(2),_(2)] [1.9% done] [0KB/16256KB/0KBfio: jo=
b &#39;test&#39; hasn&#39;t exited in 104 seconds, it appears to be stuck. =
Doing forceful exit of this job.<br>
&gt; =C2=A0 =C2=A0fio: job &#39;test&#39; hasn&#39;t exited in 60 seconds, =
it appears to be stuck. Doing forceful exit of this job.<br>
&gt; =C2=A0 =C2=A0fio: job &#39;test&#39; hasn&#39;t exited in 60 seconds, =
it appears to be stuck. Doing forceful exit of this job.<br>
&gt; =C2=A0 =C2=A0Jobs: 77 (f=3D77): [W(1),_(1),W(1),_(4),W(2),_(1),W(5),f(=
1),W(5),_(1),W(5),_(1),W(2),_(1),W(9),_(2),W(4),_(1),f(1),_(3),W(3),_(3),W(=
2),_(1),W(1),_(1),W(1),_(1),W(1),_(1),W(2),_(2),W(7),_(1),W(2),_(2),W(1),_(=
1),W(1),_(3),W(1),_(3),W(3),_(1),W(1),_(1),W(1),_(3),W(3),_(1),W(1),_(2),W(=
3),_(2),W(2),_(3),W(2),_(1),W(1),_(1),W(2),_(2)] [1.9% done] [0KB/29fio: jo=
b &#39;test&#39; hasn&#39;t exited in 60 seconds, it appears to be stuck. D=
oing forceful exit of this job.<br>
&gt; =C2=A0 =C2=A0fio: job &#39;test&#39; hasn&#39;t exited in 110 seconds,=
 it appears to be stuck. Doing forceful exit of this job.<br>
&gt; =C2=A0 =C2=A0Jobs: 75 (f=3D75): [W(1),_(1),W(1),_(4),W(2),_(1),W(5),f(=
1),W(5),_(1),W(5),_(1),W(2),_(1),W(1),_(1),W(7),_(2),f(1),W(3),_(1),W(1),_(=
3),W(3),_(3),W(2),_(1),W(1),_(1),W(1),_(1),W(1),_(1),W(2),_(2),W(7),_(1),W(=
2),_(2),W(1),_(5),W(1),_(3),W(3),_(1),W(1),_(1),W(1),_(3),W(3),_(1),W(1),_(=
2),W(3),_(2),W(2),_(3),W(2),_(1),W(1),_(1),W(2),_(2)] [1.8% done] [0fio: jo=
b &#39;test&#39; hasn&#39;t exited in 60 seconds, it appears to be stuck. D=
oing forceful exit of this job.<br>
&gt; =C2=A0 =C2=A0Jobs: 73 (f=3D73): [W(1),_(1),W(1),_(4),W(2),_(1),W(11),_=
(2),W(4),_(1),W(2),_(1),W(1),_(1),W(7),_(2),W(4),_(1),W(1),_(3),W(3),_(3),W=
(2),_(1),W(1),_(1),W(1),_(1),W(1),_(1),W(2),_(2),W(2),f(1),W(4),_(1),W(2),_=
(2),W(1),_(5),W(1),_(3),W(3),_(1),W(1),_(1),W(1),_(3),W(3),_(4),W(3),_(2),W=
(2),_(3),W(2),_(1),W(1),_(1),W(2),_(2)] [1.7% done] [0KB/8633KB/0KB fio: jo=
b &#39;test&#39; hasn&#39;t exited in 60 seconds, it appears to be stuck. D=
oing forceful exit of this job.<br>
&gt; =C2=A0 =C2=A0fio: job &#39;test&#39; hasn&#39;t exited in 60 seconds, =
it appears to be stuck. Doing forceful exit of this job.<br>
&gt; =C2=A0 =C2=A0Jobs: 71 (f=3D71): [W(1),_(1),W(1),_(4),W(2),_(1),W(1),_(=
1),W(1),f(1),W(7),_(2),W(4),_(1),W(2),_(1),W(1),_(1),W(7),_(2),W(4),_(1),W(=
1),_(3),W(3),_(3),W(2),_(1),W(1),_(1),W(1),_(1),W(1),_(1),W(2),_(2),W(7),_(=
1),W(2),_(2),W(1),_(5),W(1),_(3),W(3),_(1),W(1),_(1),W(1),_(3),W(3),_(4),W(=
3),_(2),W(1),_(4),W(2),_(1),W(1),_(1),W(2),_(2)] [1.7% done] [0KB/51fio: jo=
b &#39;test&#39; hasn&#39;t exited in 60 seconds, it appears to be stuck. D=
oing forceful exit of this job.<br>
&gt; =C2=A0 =C2=A0fio: job &#39;test&#39; hasn&#39;t exited in 60 seconds, =
it appears to be stuck. Doing forceful exit of this job.<br>
&gt; =C2=A0 =C2=A0Jobs: 69 (f=3D69): [W(1),_(1),W(1),_(4),W(2),_(1),W(1),_(=
2),W(8),_(2),W(4),_(1),W(2),_(1),W(1),_(1),W(7),_(2),W(4),_(1),W(1),_(3),W(=
3),_(3),W(2),_(1),W(1),_(1),W(1),_(1),W(1),_(1),W(2),_(2),W(7),_(2),W(1),_(=
2),W(1),_(5),W(1),_(3),W(3),_(1),W(1),_(1),W(1),_(3),W(3),_(4),f(1),W(2),_(=
2),W(1),_(4),W(2),_(1),W(1),_(1),f(1),W(1),_(2)] [1.6% done] [0KB/14Jobs: 6=
9 (f=3D69): [W(1),_(1),W(1),_(4),W(2),_(1),W(1),_(2),W(8),_(2),W(4),_(1),W(=
2),_(1),W(1),_(1),W(7),_(2),W(4),_(1),W(1),_(3),W(3),_(3),W(2),_(1),W(1),_(=
1),W(1),_(1),W(1),_(1),W(2),_(2),W(3),f(1),W(3),_(2),W(1),_(2),W(1),_(5),W(=
1),_(3),W(3),_(1),W(1),_(1),W(1),_(3),W(3),_(4),f(1),W(2),_(2),W(1),_(4),W(=
2),_(1),W(1),_(1),f(1),W(1),_(2)] [1.6% donfio: job &#39;test&#39; hasn&#39=
;t exited in 60 seconds, it appears to be stuck. Doing forceful exit of thi=
s job.<br>
&gt; =C2=A0 =C2=A0fio: job &#39;test&#39; hasn&#39;t exited in 60 seconds, =
it appears to be stuck. Doing forceful exit of this job.<br>
&gt; =C2=A0 =C2=A0Jobs: 68 (f=3D68): [W(1),_(1),W(1),_(4),W(2),_(1),W(1),_(=
2),W(8),_(2),W(1),_(1),W(2),_(1),W(2),_(1),W(1),_(1),W(7),_(2),W(1),f(1),W(=
2),_(1),W(1),_(3),W(3),_(3),W(2),_(1),W(1),_(1),W(1),_(1),W(1),_(1),W(2),_(=
2),W(3),f(1),W(3),_(2),W(1),_(2),W(1),_(5),W(1),_(3),W(3),_(1),W(1),_(1),W(=
1),_(3),W(3),_(4),W(3),_(2),W(1),_(4),W(2),_(1),W(1),_(1),W(2),_(2)]Jobs: 6=
7 (f=3D67): [W(1),_(1),W(1),_(4),W(2),_(1),W(1),_(2),W(1),_(1),W(6),_(2),W(=
1),_(1),W(2),_(1),W(2),_(1),W(1),_(1),W(7),_(2),W(4),_(1),W(1),_(3),W(3),_(=
3),W(2),_(1),W(1),_(1),W(1),_(1),W(1),_(1),W(2),_(2),W(7),_(2),W(1),_(2),W(=
1),_(5),W(1),_(3),W(3),_(1),W(1),_(1),W(1),_(3),W(1),f(1),W(1),_(4),W(3),_(=
2),W(1),_(4),W(2),_(1),W(1),_(1),W(2),_(2)]fio: job &#39;test&#39; hasn&#39=
;t exited in 60 seconds, it appears to be stuck. Doing forceful exit of thi=
s job.<br>
&gt; =C2=A0 =C2=A0fio: job &#39;test&#39; hasn&#39;t exited in 60 seconds, =
it appears to be stuck. Doing forceful exit of this job.<br>
&gt; =C2=A0 =C2=A0fio: job &#39;test&#39; hasn&#39;t exited in 60 seconds, =
it appears to be stuck. Doing forceful exit of this job.<br>
&gt; =C2=A0 =C2=A0fio: job &#39;test&#39; hasn&#39;t exited in 100 seconds,=
 it appears to be stuck. Doing forceful exit of this job.<br>
&gt; =C2=A0 =C2=A0fio: job &#39;test&#39; hasn&#39;t exited in 60 seconds, =
it appears to be stuck. Doing forceful exit of this job.<br>
&gt; =C2=A0 =C2=A0Jobs: 64 (f=3D64): [_(2),W(1),_(4),W(2),_(1),W(1),_(2),W(=
1),_(1),W(6),_(2),W(1),_(1),W(2),_(1),W(2),_(1),W(1),_(1),W(7),_(2),W(3),_(=
2),W(1),_(3),W(3),_(3),W(2),_(1),W(1),_(1),W(1),_(1),W(1),_(1),W(1),f(1),_(=
3),W(6),_(2),f(1),_(2),W(1),_(5),W(1),_(3),W(3),_(1),W(1),_(1),W(1),_(3),W(=
1),f(1),W(1),_(4),W(3),_(2),W(1),_(4),f(1),W(1),_(1),W(1),_(1),W(2),Jobs: 6=
3 (f=3D63): [_(7),W(2),_(1),W(1),_(2),W(1),_(1),W(6),_(2),W(1),_(1),W(2),_(=
1),W(2),_(1),W(1),_(1),W(7),_(2),W(3),_(2),W(1),_(3),W(3),_(3),W(2),_(1),W(=
1),_(1),W(1),_(1),W(1),_(1),W(1),f(1),_(3),W(6),_(2),f(1),_(2),W(1),_(5),W(=
1),_(3),W(3),_(1),W(1),_(1),W(1),_(3),W(3),_(4),W(3),_(2),W(1),_(4),f(1),W(=
1),_(1),W(1),_(1),W(2),_(2)] [1.5% done] [0fio: job &#39;test&#39; hasn&#39=
;t exited in 60 seconds, it appears to be stuck. Doing forceful exit of thi=
s job.<br>
&gt; =C2=A0 =C2=A0fio: job &#39;test&#39; hasn&#39;t exited in 60 seconds, =
it appears to be stuck. Doing forceful exit of this job.<br>
&gt; =C2=A0 =C2=A0fio: job &#39;test&#39; hasn&#39;t exited in 60 seconds, =
it appears to be stuck. Doing forceful exit of this job.<br>
&gt; =C2=A0 =C2=A0Jobs: 62 (f=3D62): [_(7),W(2),_(1),W(1),_(2),W(1),_(1),W(=
6),_(2),W(1),_(1),W(2),_(2),W(1),_(1),W(1),_(1),W(7),_(2),W(3),_(2),W(1),_(=
3),W(3),_(3),W(2),_(1),W(1),_(1),W(1),_(1),W(1),_(1),W(2),_(3),W(6),_(2),W(=
1),_(2),W(1),_(5),W(1),_(3),W(3),_(1),W(1),_(1),W(1),_(3),W(3),_(4),W(3),_(=
2),W(1),_(4),W(2),_(1),W(1),_(1),W(2),_(2)] [1.5% done] [0KB/1263KB/Jobs: 6=
0 (f=3D60): [_(7),W(2),_(1),W(1),_(2),W(1),_(1),W(6),_(2),W(1),_(1),W(2),_(=
2),W(1),_(1),W(1),_(1),W(2),_(1),W(4),_(2),W(3),_(2),W(1),_(3),W(3),_(3),W(=
2),_(1),W(1),_(1),W(1),_(1),W(1),_(1),W(2),_(3),W(6),_(2),W(1),_(2),W(1),_(=
5),W(1),_(3),W(1),_(1),W(1),_(1),W(1),_(1),W(1),_(3),W(3),_(4),W(2),f(1),_(=
2),W(1),_(4),W(2),_(1),W(1),_(1),W(2),_(2)]fio: job &#39;test&#39; hasn&#39=
;t exited in 101 seconds, it appears to be stuck. Doing forceful exit of th=
is job.<br>
&gt; =C2=A0 =C2=A0fio: job &#39;test&#39; hasn&#39;t exited in 60 seconds, =
it appears to be stuck. Doing forceful exit of this job.<br>
&gt; =C2=A0 =C2=A0Jobs: 59 (f=3D59): [_(7),W(2),_(1),W(1),_(2),W(1),_(1),W(=
6),_(2),W(1),_(1),W(2),_(2),W(1),_(1),W(1),_(1),W(2),_(1),W(4),_(2),W(3),_(=
2),W(1),_(3),W(2),f(1),_(3),W(2),_(1),W(1),_(1),W(1),_(1),W(1),_(1),W(2),_(=
3),W(4),_(1),W(1),_(2),W(1),_(2),W(1),_(5),W(1),_(3),W(1),_(1),W(1),_(1),W(=
1),_(1),W(1),_(3),W(3),_(4),W(3),_(2),W(1),_(4),W(2),_(1),W(1),_(1),fio: jo=
b &#39;test&#39; hasn&#39;t exited in 60 seconds, it appears to be stuck. D=
oing forceful exit of this job.<br>
&gt; =C2=A0 =C2=A0fio: job &#39;test&#39; hasn&#39;t exited in 60 seconds, =
it appears to be stuck. Doing forceful exit of this job.<br>
&gt; =C2=A0 =C2=A0Jobs: 58 (f=3D58): [_(7),W(2),_(1),W(1),_(2),W(1),_(1),W(=
6),_(2),W(1),_(1),W(2),_(2),W(1),_(1),W(1),_(2),W(1),_(1),W(4),_(2),W(3),_(=
2),W(1),_(3),W(2),f(1),_(3),W(2),_(1),W(1),_(1),W(1),_(1),W(1),_(1),W(2),_(=
3),W(4),_(1),W(1),_(2),W(1),_(2),W(1),_(5),W(1),_(3),W(1),_(1),W(1),_(1),W(=
1),_(1),W(1),_(3),W(3),_(4),W(1),f(1),W(1),_(2),W(1),_(4),W(2),_(1),fio: jo=
b &#39;test&#39; hasn&#39;t exited in 60 seconds, it appears to be stuck. D=
oing forceful exit of this job.<br>
&gt; =C2=A0 =C2=A0Jobs: 56 (f=3D56): [_(7),W(2),_(1),W(1),_(2),W(1),_(1),W(=
6),_(2),f(1),_(2),W(1),_(2),W(1),_(1),W(1),_(2),W(1),_(1),W(3),f(1),_(2),W(=
3),_(2),W(1),_(3),W(1),_(1),f(1),_(3),W(2),_(1),W(1),_(1),W(1),_(1),W(1),_(=
1),W(2),_(3),W(4),_(1),W(1),_(2),W(1),_(2),W(1),_(5),W(1),_(3),W(1),_(1),W(=
1),_(1),W(1),_(1),W(1),_(3),f(1),W(2),_(4),W(3),_(2),W(1),_(4),W(2),fio: jo=
b &#39;test&#39; hasn&#39;t exited in 92 seconds, it appears to be stuck. D=
oing forceful exit of this job.<br>
&gt; =C2=A0 =C2=A0fio: job &#39;test&#39; hasn&#39;t exited in 95 seconds, =
it appears to be stuck. Doing forceful exit of this job.<br>
&gt; =C2=A0 =C2=A0fio: job &#39;test&#39; hasn&#39;t exited in 96 seconds, =
it appears to be stuck. Doing forceful exit of this job.<br>
&gt; =C2=A0 =C2=A0fio: job &#39;test&#39; hasn&#39;t exited in 100 seconds,=
 it appears to be stuck. Doing forceful exit of this job.<br>
&gt; =C2=A0 =C2=A0fio: job &#39;test&#39; hasn&#39;t exited in 95 seconds, =
it appears to be stuck. Doing forceful exit of this job.<br>
&gt; =C2=A0 =C2=A0fio: job &#39;test&#39; hasn&#39;t exited in 95 seconds, =
it appears to be stuck. Doing forceful exit of this job.<br>
&gt; =C2=A0 =C2=A0fio: job &#39;test&#39; hasn&#39;t exited in 95 seconds, =
it appears to be stuck. Doing forceful exit of this job.<br>
&gt; =C2=A0 =C2=A0fio: job &#39;test&#39; hasn&#39;t exited in 97 seconds, =
it appears to be stuck. Doing forceful exit of this job.<br>
&gt;<br>
&gt; Thanks for your feedback<br>
&gt;<br>
&gt; Regards,<br>
&gt; Thierry<br>
&gt;<br>
</p>

--001a1148d7ca271ef505283437ed--

