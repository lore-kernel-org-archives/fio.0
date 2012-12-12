Return-Path: <sbradshaw@micron.com>
From: "Sam Bradshaw (sbradshaw)" <sbradshaw@micron.com>
Subject: Latency spikes with 'thread' option
Date: Wed, 12 Dec 2012 20:11:49 +0000
Message-ID: <80B89753B40C5141A3E2D53FE7A2A8A930030D7E@NTXBOIMBX02.micron.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: "fio@vger.kernel.org" <fio@vger.kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

Hi All,

We're running queue depth sweeps with a 4k random read workload (sample con=
fig=20
below) against a high performance PCIe SSD - the Micron p320h.  We're seein=
g
latency spikes to 1 sec when the 'thread' option is used.  Instrumenting th=
e
driver, we see max latencies from driver entry point to block layer complet=
ion=20
callback of <20 ms at high queue depths.  If 'thread' is not used, the max=
=20
latencies reported by fio align almost exactly with that seen by the driver=
.
There are typically only one or two of these latency outliers during a 40 s=
ec
run, for example, but they represent a significant enough excursion to pull
our std. dev. very high.

Has anyone witnessed this sort of behavior?  We see it with all the version=
s
of fio that we have used (2.0.5+) with a variety of kernels.  It's also ver=
y
suspicious that the max latency is either almost exactly 1 sec or aligns wi=
th
our hardware incurred latency for the given queue depth.

Thanks,
-Sam

[global]
#thread
group_reporting
direct=3D1
time_based
norandommap=3D1
refill_buffers
runtime=3D40
ioengine=3Dlibaio
filename=3D/dev/rssda
bs=3D4k
rw=3Drandread
=20
[read-qd-256]
numjobs=3D8
iodepth=3D32
stonewall

[read-qd-248]
numjobs=3D8
iodepth=3D31
stonewall

[read-qd-240]
numjobs=3D8
iodepth=3D30
stonewall

[read-qd-232]
numjobs=3D8
iodepth=3D29
stonewall

<snip>

[read-qd-64]
numjobs=3D8
iodepth=3D8
stonewall

[read-qd-56]
numjobs=3D8
iodepth=3D7
stonewall

[read-qd-48]
numjobs=3D8
iodepth=3D6
stonewall

[read-qd-40]
numjobs=3D8
iodepth=3D5
stonewall

[read-qd-32]
numjobs=3D8
iodepth=3D4
stonewall

[read-qd-24]
numjobs=3D8
iodepth=3D3
stonewall

[read-qd-16]
numjobs=3D8
iodepth=3D2
stonewall

[read-qd-8]
numjobs=3D8
iodepth=3D1
stonewall

[read-qd-4]
numjobs=3D4
iodepth=3D1
stonewall

[read-qd-1]
numjobs=3D1
iodepth=3D1
stonewall

