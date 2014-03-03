Return-Path: <Eric.Lamkin@lsi.com>
From: "Lamkin, Eric" <Eric.Lamkin@lsi.com>
Subject: RE: fio replay
Date: Mon, 3 Mar 2014 13:25:37 +0000
Message-ID: <70dc0e01a5674f159ed9e02dc61b64ce@BN1PR07MB437.namprd07.prod.outlook.com>
References: <651fd21aaf304da0b24902febae3c345@BN1PR07MB437.namprd07.prod.outlook.com>
 <76F46F78-8F5A-45CF-BBCE-3ADC63AFF541@nellans.org>
 <934f861a97f2443aa35296c2d6d8c848@BN1PR07MB437.namprd07.prod.outlook.com>
 <530E2933.2080903@kernel.dk> <530E6056.2020309@kernel.dk>
 <c79c5d2e1b3f4a3487815ca851a8399e@BN1PR07MB437.namprd07.prod.outlook.com>
In-Reply-To: <c79c5d2e1b3f4a3487815ca851a8399e@BN1PR07MB437.namprd07.prod.outlook.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Return-Path: Eric.Lamkin@lsi.com
To: Jens Axboe <axboe@kernel.dk>, David Nellans <david@nellans.org>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

Here's my update with a blktrace captured on a single device with no droppe=
d events.
Also switched to fio 2.1.4.

Capture a single device trace with no dropped events.

[root@Megaraid15 trace2]# blktrace -b 16384 -d /dev/sdc
^C^C
=3D=3D=3D sdc =3D=3D=3D
  CPU  0:              3271662 events,   153360 KiB data
  CPU  1:              2301711 events,   107893 KiB data
  CPU  2:               476799 events,    22350 KiB data
  CPU  3:               388404 events,    18207 KiB data
  CPU  4:               347622 events,    16295 KiB data
  CPU  5:               240275 events,    11263 KiB data
  CPU  6:               177413 events,     8317 KiB data
  CPU  7:               139892 events,     6558 KiB data
  CPU  8:                76175 events,     3571 KiB data
  CPU  9:                77181 events,     3618 KiB data
  CPU 10:                63682 events,     2986 KiB data
  CPU 11:                45967 events,     2155 KiB data
  CPU 12:                35658 events,     1672 KiB data
  CPU 13:                20237 events,      949 KiB data
  CPU 14:                17849 events,      837 KiB data
  CPU 15:                18200 events,      854 KiB data
  CPU 16:              2510411 events,   117676 KiB data
  CPU 17:              1426072 events,    66848 KiB data
  CPU 18:                57914 events,     2715 KiB data
  CPU 19:                37197 events,     1744 KiB data
  CPU 20:                44023 events,     2064 KiB data
  CPU 21:                27153 events,     1273 KiB data
  CPU 22:                29866 events,     1400 KiB data
  CPU 23:                20500 events,      961 KiB data
  CPU 24:                21954 events,     1030 KiB data
  CPU 25:                 7327 events,      344 KiB data
  CPU 26:                12458 events,      584 KiB data
  CPU 27:                10061 events,      472 KiB data
  CPU 28:                10061 events,      472 KiB data
  CPU 29:                 5627 events,      264 KiB data
  CPU 30:                 7835 events,      368 KiB data
  CPU 31:                 3345 events,      157 KiB data
  Total:              11930531 events (dropped 0),   559245 KiB data

Create blkparse .bin file for replay.

[root@Megaraid15 trace2]# blkparse -i sdc -O -d bprun2all.bin
Input file sdc.blktrace.0 added
Input file sdc.blktrace.1 added
Input file sdc.blktrace.2 added
Input file sdc.blktrace.3 added
Input file sdc.blktrace.4 added
Input file sdc.blktrace.5 added
Input file sdc.blktrace.6 added
Input file sdc.blktrace.7 added
Input file sdc.blktrace.8 added
Input file sdc.blktrace.9 added
Input file sdc.blktrace.10 added
Input file sdc.blktrace.11 added
Input file sdc.blktrace.12 added
Input file sdc.blktrace.13 added
Input file sdc.blktrace.14 added
Input file sdc.blktrace.15 added
Input file sdc.blktrace.16 added
Input file sdc.blktrace.17 added
Input file sdc.blktrace.18 added
Input file sdc.blktrace.19 added
Input file sdc.blktrace.20 added
Input file sdc.blktrace.21 added
Input file sdc.blktrace.22 added
Input file sdc.blktrace.23 added
Input file sdc.blktrace.24 added
Input file sdc.blktrace.25 added
Input file sdc.blktrace.26 added
Input file sdc.blktrace.27 added
Input file sdc.blktrace.28 added
Input file sdc.blktrace.29 added
Input file sdc.blktrace.30 added
Input file sdc.blktrace.31 added

Create blkparse .txt file to analyze.
[root@Megaraid15 trace2]# blkparse -t sdc > bprun2all.txt
=20
[root@Megaraid15 trace2]# ls -l
total 1118648
-rw-r--r--. 1 root root 572666191 Feb 27 08:11 bprun2all.bin
-rw-r--r--. 1 root root 705142381 Feb 27 08:44 bprun2all.txt
-rw-r--r--. 1 root root 157039820 Feb 27 07:59 sdc.blktrace.0
-rw-r--r--. 1 root root 110482130 Feb 27 07:59 sdc.blktrace.1
-rw-r--r--. 1 root root   3056749 Feb 27 07:59 sdc.blktrace.10
-rw-r--r--. 1 root root   2206453 Feb 27 07:59 sdc.blktrace.11
-rw-r--r--. 1 root root   1711631 Feb 27 07:59 sdc.blktrace.12
-rw-r--r--. 1 root root    971383 Feb 27 07:59 sdc.blktrace.13
-rw-r--r--. 1 root root    856781 Feb 27 07:59 sdc.blktrace.14
-rw-r--r--. 1 root root    873640 Feb 27 07:59 sdc.blktrace.15
-rw-r--r--. 1 root root 120499732 Feb 27 07:59 sdc.blktrace.16
-rw-r--r--. 1 root root  68451459 Feb 27 07:59 sdc.blktrace.17
-rw-r--r--. 1 root root   2779909 Feb 27 07:59 sdc.blktrace.18
-rw-r--r--. 1 root root   1785457 Feb 27 07:59 sdc.blktrace.19
-rw-r--r--. 1 root root  22886358 Feb 27 07:59 sdc.blktrace.2
-rw-r--r--. 1 root root   2113146 Feb 27 07:59 sdc.blktrace.20
-rw-r--r--. 1 root root   1303379 Feb 27 07:59 sdc.blktrace.21
-rw-r--r--. 1 root root   1433588 Feb 27 07:59 sdc.blktrace.22
-rw-r--r--. 1 root root    984035 Feb 27 07:59 sdc.blktrace.23
-rw-r--r--. 1 root root   1053802 Feb 27 07:59 sdc.blktrace.24
-rw-r--r--. 1 root root    351710 Feb 27 07:59 sdc.blktrace.25
-rw-r--r--. 1 root root    597990 Feb 27 07:59 sdc.blktrace.26
-rw-r--r--. 1 root root    482965 Feb 27 07:59 sdc.blktrace.27
-rw-r--r--. 1 root root    482930 Feb 27 07:59 sdc.blktrace.28
-rw-r--r--. 1 root root    270127 Feb 27 07:59 sdc.blktrace.29
-rw-r--r--. 1 root root  18643407 Feb 27 07:59 sdc.blktrace.3
-rw-r--r--. 1 root root    376114 Feb 27 07:59 sdc.blktrace.30
-rw-r--r--. 1 root root    160568 Feb 27 07:59 sdc.blktrace.31
-rw-r--r--. 1 root root  16685885 Feb 27 07:59 sdc.blktrace.4
-rw-r--r--. 1 root root  11533215 Feb 27 07:59 sdc.blktrace.5
-rw-r--r--. 1 root root   8515854 Feb 27 07:59 sdc.blktrace.6
-rw-r--r--. 1 root root   6714832 Feb 27 07:59 sdc.blktrace.7
-rw-r--r--. 1 root root   3656409 Feb 27 07:59 sdc.blktrace.8
-rw-r--r--. 1 root root   3704733 Feb 27 07:59 sdc.blktrace.9

Trace analysis.
Total capture time 92.93 seconds
% reads 0
% writes 100
Block range 3,842,507,008
Queue operations 910,789
CPUs used for queue operations 32 (all)
Blocks queued 7,286,312
Average blocks per queue operation 8
Sequential queue operations 144,034 88.4%
Sequential blocks queued 6,439,168 88.4%
Max blocks per sequential run 816
Completion operations 503,585
CPUs used for completion 2 (0,1)
Blocks completed 7,286,328
Average blocks per completion operation 14
Sequential completions 139,985 78.1%
Sequential block completions 6,327,912 86.8%

On a different host run fio replay.
fio replay completed in < 5 seconds.  Now using version 2.1.4

[root@x3650M4 Run2]# fio --name=3Drp2 --ioengine=3Dlibaio --iodepth=3D12 --=
read_iolog=3Dbprun2all.bin
rp2: (g=3D0): rw=3Dread, bs=3D4K-4K/4K-4K/4K-4K, ioengine=3Dlibaio, iodepth=
=3D12
fio-2.1.4
Starting 1 process
got timestamp notify: 4000001, 0
Jobs: 1 (f=3D1): [W] [0.6% done] [0KB/2468KB/0KB /s] [0/617/0 iops] [eta 08=
m:11s]          =20
rp2: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D28318: Thu Feb 27 12:12:43 20=
14
  write: io=3D28176KB, bw=3D41558KB/s, iops=3D10389, runt=3D   678msec
    slat (usec): min=3D7, max=3D206, avg=3D22.02, stdev=3D 7.94
    clat (usec): min=3D28, max=3D168903, avg=3D928.91, stdev=3D7207.25
     lat (usec): min=3D47, max=3D168926, avg=3D951.59, stdev=3D7207.26
    clat percentiles (usec):
     |  1.00th=3D[   44],  5.00th=3D[   77], 10.00th=3D[  149], 20.00th=3D[=
  266],
     | 30.00th=3D[  282], 40.00th=3D[  286], 50.00th=3D[  294], 60.00th=3D[=
  302],
     | 70.00th=3D[  338], 80.00th=3D[ 1208], 90.00th=3D[ 1352], 95.00th=3D[=
 1496],
     | 99.00th=3D[ 2800], 99.50th=3D[ 3728], 99.90th=3D[168960], 99.95th=3D=
[168960],
     | 99.99th=3D[168960]
    lat (usec) : 50=3D2.46%, 100=3D5.08%, 250=3D8.97%, 500=3D56.93%, 750=3D=
0.68%
    lat (usec) : 1000=3D0.65%
    lat (msec) : 2=3D22.66%, 4=3D2.13%, 10=3D0.13%, 100=3D0.16%, 250=3D0.16=
%
  cpu          : usr=3D3.10%, sys=3D23.93%, ctx=3D648, majf=3D0, minf=3D15
  IO depths    : 1=3D3.2%, 2=3D6.2%, 4=3D12.4%, 8=3D78.3%, 16=3D0.0%, 32=3D=
0.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D95.6%, 8=3D0.3%, 16=3D4.1%, 32=3D0.0%, 64=3D=
0.0%, >=3D64=3D0.0%
     issued    : total=3Dr=3D0/w=3D7044/d=3D0, short=3Dr=3D0/w=3D0/d=3D0

Run status group 0 (all jobs):
  WRITE: io=3D28176KB, aggrb=3D41557KB/s, minb=3D41557KB/s, maxb=3D41557KB/=
s, mint=3D678msec, maxt=3D678msec
fio: file hash not empty on exit

blktrace of replay
[root@x3650M4 cbRun2replay1]# blktrace -d /dev/sdc
^C=3D=3D=3D sdc =3D=3D=3D
  CPU  0:               100619 events,     4717 KiB data
  CPU  1:                 1731 events,       82 KiB data
  CPU  2:                  113 events,        6 KiB data
  CPU  3:                    0 events,        0 KiB data
  CPU  4:                    0 events,        0 KiB data
  CPU  5:                    0 events,        0 KiB data
  CPU  6:                 7047 events,      331 KiB data
  CPU  7:                  881 events,       42 KiB data
  CPU  8:                    0 events,        0 KiB data
  CPU  9:                    0 events,        0 KiB data
  CPU 10:                    0 events,        0 KiB data
  CPU 11:                    0 events,        0 KiB data
  Total:                110391 events (dropped 0),     5175 KiB data

Create blkparse .txt file to analyze.
[root@x3650M4 cbRun2replay1]# blkparse -t sdc > bp-run2rp1.txt
[root@x3650M4 cbRun2replay1]# ls -l
total 11476
-rw-r--r--. 1 root root 6436652 Feb 27 12:34 bp-run2rp1.txt
-rw-r--r--. 1 root root 4829736 Feb 27 12:12 sdc.blktrace.0
-rw-r--r--. 1 root root   83097 Feb 27 12:12 sdc.blktrace.1
-rw-r--r--. 1 root root       0 Feb 27 12:12 sdc.blktrace.10
-rw-r--r--. 1 root root       0 Feb 27 12:12 sdc.blktrace.11
-rw-r--r--. 1 root root    5427 Feb 27 12:12 sdc.blktrace.2
-rw-r--r--. 1 root root       0 Feb 27 12:12 sdc.blktrace.3
-rw-r--r--. 1 root root       0 Feb 27 12:12 sdc.blktrace.4
-rw-r--r--. 1 root root       0 Feb 27 12:12 sdc.blktrace.5
-rw-r--r--. 1 root root  338288 Feb 27 12:12 sdc.blktrace.6
-rw-r--r--. 1 root root   42333 Feb 27 12:12 sdc.blktrace.7
-rw-r--r--. 1 root root       0 Feb 27 12:12 sdc.blktrace.8
-rw-r--r--. 1 root root       0 Feb 27 12:12 sdc.blktrace.9

Trace analysis.
Total capture time 0.816 seconds
% reads 1.16
% writes 98.8
Block range 3,999,399,928
Queue operations 7,127
CPUs used for queue operations 5 (0,1,2,6,7)
Blocks queued 57,016
Average blocks per queue operation 8
Sequential queue operations 599 95.8%
Sequential blocks queued 54,624 95.8%
Max blocks per sequential run 256
Completion operations 7,127
CPUs used for completion 1 (0)
Blocks completed 57,016
Average blocks per completion operation 8
Sequential completions 600 95.8%
Sequential block completions 54,608 95.8%

Comparative analysis replay to original
Capture time .88%
% reads +1.16%
% writes -1.16%
Block range 104%
Queue operations .78%
Blocks queued .78%
% sequential queued 108%
Max blocks per sequential run 31.4%
Completion operations 1.42%
Blocks completed .78%
% sequential completions 110%

Salient kernel parameters for reference
Originating host
[root@Megaraid15 Scripts]# ./gkparams.sh sdc
Get Scheduler noop anticipatory deadline [cfq]=20
Get nr_requests 128
Get queue_depth 256
Get max_sectors_kb 280
Get minimum_io_size 4096
Get Linux IO Read-Ahead 256
Get nomerges - IO merging and coalescing 0
Get rq_affinity 1
Get rotational 1

Replay host
[root@x3650M4 Scripts]# ./gkparams.sh sdc
Get Scheduler noop anticipatory deadline [cfq]=20
Get nr_requests 128
Get queue_depth 256
Get max_sectors_kb 280
Get minimum_io_size 4096
Get Linux IO Read-Ahead 256
Get nomerges - IO merging and coalescing 0
Get rq_affinity 1
Get rotational 1

Eric
-----Original Message-----
From: fio-owner@vger.kernel.org [mailto:fio-owner@vger.kernel.org] On Behal=
f Of Lamkin, Eric
Sent: Wednesday, February 26, 2014 3:55 PM
To: Jens Axboe; David Nellans
Cc: fio@vger.kernel.org
Subject: RE: fio replay

Jens,

Sorry I don't know how to compile.
Hope that doesn't mean no one will ever replay to me again.

I'm very appreciative of the suggestions you've made and will try capturing=
 a source trace where I don't get any dropped event messages.  I'll also ca=
pture just one device.

My blktrace log files go to the OS storage device whereas the devices trace=
d are on a different storage path.

In this first experiment I didn't have to do any device mapping as I was ab=
le to arrange storage on the replay host of sufficient capacity with matchi=
ng device references.

Eric
-----Original Message-----
From: Jens Axboe [mailto:axboe@kernel.dk]
Sent: Wednesday, February 26, 2014 3:45 PM
To: Lamkin, Eric; David Nellans
Cc: fio@vger.kernel.org
Subject: Re: fio replay

On 2014-02-26 09:49, Jens Axboe wrote:
> On 2014-02-26 06:23, Lamkin, Eric wrote:
>> David,
>>
>> Thanks for responding.
>> I sent the below out last week but didn't get a reply so thought I'd=20
>> try a simpler 'what works' tactic this morning.
>> As seen in the below I'm using 2.0.10.
>
> I just ran a quick test here, current -git seems to work fine for me.=20
> It might be a bit finicky in that the error handling isn't stellar,=20
> which I'm thinking could be your issue since you have dropped events=20
> in your blktraces. You need to eliminate any dropped events - either=20
> log to tmpfs or send the traces over the network, that would likely do it=
.
>
> If that doesn't solve it for you, please boil this down to a smaller=20
> test case. Start with one device. Does that work? Up the complexity=20
> until you see an issue, then I can likely help you get this fixed if I=20
> get the problematic trace.

Can you try current -git? I made some improvements/fixes to the multiple de=
vice handling.

--
Jens Axboe


--
To unsubscribe from this list: send the line "unsubscribe fio" in the body =
of a message to majordomo@vger.kernel.org More majordomo info at  http://vg=
er.kernel.org/majordomo-info.html


