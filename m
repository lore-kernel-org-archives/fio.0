Return-Path: <fio-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:2886 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752341AbeCWQIQ (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 23 Mar 2018 12:08:16 -0400
From: Kris Davis <Kris.Davis@wdc.com>
Subject: "No I/O performed by <engine>" reporting bug?
Date: Fri, 23 Mar 2018 16:08:13 +0000
Message-ID: <CY1PR0401MB111683B907AEAA34BB0A9A3881A80@CY1PR0401MB1116.namprd04.prod.outlook.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>
Cc: Itay Ben Yaacov <Itay.BenYaacov@wdc.com>

In fio version 2.20 a test seems to have been added to backend.c which "may=
" falsely report that no I/O has occurred.
Currently, at line 1856 of backend.c there is the following test block, whi=
ch doesn't appear to exist in versions prior to 2.20, unless the equivalent=
 resided elsewhere.

	/*
	 * If td ended up with no I/O when it should have had,
	 * then something went wrong unless FIO_NOIO or FIO_DISKLESSIO.
	 * (Are we not missing other flags that can be ignored ?)
	 */
	if ((td->o.size || td->o.io_size) && !ddir_rw_sum(bytes_done) &&
	    !did_some_io && !td->o.create_only &&
	    !(td_ioengine_flagged(td, FIO_NOIO) ||
	      td_ioengine_flagged(td, FIO_DISKLESSIO)))
		log_err("%s: No I/O performed by %s, "
			 "perhaps try --debug=3Dio option for details?\n",
			 td->o.name, td->io_ops->name);


In the following fio test, the error message is logged, even though it appe=
ars that everything has run ok (fio built from main below, but results appe=
ar to be the same with at least fio version 2.21)
(It's also interesting to note that the estimated "eta" is also grossly ina=
ccurate [captured while running below] - but that is a different issue I th=
ink).
You can see the " Random-read-4K-QD1: No I/O performed by libaio, perhaps t=
ry --debug=3Dio option for details?" error message below, which "appears" t=
o be false.

    $ fio --ioengine=3Dlibaio --loops=3D32 --direct=3D1 --numjobs=3D1--nora=
ndommap --randrepeat=3D0 --size=3D16GB --filename=3D/dev/sdb --name=3DRando=
m-read-4K-QD1 --rw=3Drandread --bs=3D4K --iodepth=3D1 --number_ios=3D8192
    Random-read-4K-QD1: (g=3D0): rw=3Drandread, bs=3D(R) 4096B-4096B, (W) 4=
096B-4096B, (T) 4096B-4096B, ioengine=3Dlibaio, iodepth=3D1
    fio-3.5-60-g69c5
    Starting 1 process
    Jobs: 1 (f=3D1): [r(1)][0.2%][r=3D30.9MiB/s,w=3D0KiB/s][r=3D7898,w=3D0 =
IOPS][eta 04h:45m:35s]

    Random-read-4K-QD1: No I/O performed by libaio, perhaps try --debug=3Di=
o option for details?

    Random-read-4K-QD1: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D21471: Fri=
 Mar 23 10:49:12 2018
       read: IOPS=3D7844, BW=3D30.6MiB/s (32.1MB/s)(1024MiB/33418msec)
        slat (nsec): min=3D4369, max=3D29947, avg=3D4781.26, stdev=3D279.14
        clat (usec): min=3D28, max=3D7778, avg=3D121.24, stdev=3D91.57
         lat (usec): min=3D36, max=3D7783, avg=3D126.18, stdev=3D91.57
        clat percentiles (usec):
         |  1.00th=3D[   32],  5.00th=3D[   33], 10.00th=3D[  116], 20.00th=
=3D[  117],
         | 30.00th=3D[  118], 40.00th=3D[  120], 50.00th=3D[  121], 60.00th=
=3D[  122],
         | 70.00th=3D[  133], 80.00th=3D[  135], 90.00th=3D[  137], 95.00th=
=3D[  139],
         | 99.00th=3D[  141], 99.50th=3D[  141], 99.90th=3D[ 1336], 99.95th=
=3D[ 2868],
         | 99.99th=3D[ 2966]
       bw (  KiB/s): min=3D24424, max=3D32624, per=3D100.00%, avg=3D31379.5=
2, stdev=3D1196.81, samples=3D66
       iops        : min=3D 6106, max=3D 8156, avg=3D7844.88, stdev=3D299.2=
0, samples=3D66
      lat (usec)   : 50=3D6.68%, 100=3D0.09%, 250=3D93.03%, 500=3D0.08%, 75=
0=3D0.02%
      lat (usec)   : 1000=3D0.01%
      lat (msec)   : 2=3D0.01%, 4=3D0.09%, 10=3D0.01%
      cpu          : usr=3D3.20%, sys=3D4.90%, ctx=3D262146, majf=3D0, minf=
=3D206
      IO depths    : 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 3=
2=3D0.0%, >=3D64=3D0.0%
         submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, =
64=3D0.0%, >=3D64=3D0.0%
         complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, =
64=3D0.0%, >=3D64=3D0.0%
         issued rwts: total=3D262144,0,0,0 short=3D0,0,0,0 dropped=3D0,0,0,=
0
         latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D=
1

    Run status group 0 (all jobs):
       READ: bw=3D30.6MiB/s (32.1MB/s), 30.6MiB/s-30.6MiB/s (32.1MB/s-32.1M=
B/s), io=3D1024MiB (1074MB), run=3D33418-33418msec

    Disk stats (read/write):
      sdb: ios=3D261972/0, merge=3D0/0, ticks=3D31245/0, in_queue=3D31188, =
util=3D93.13%


I added a print message which showed that both ddir_rw_sum(bytes_done) and =
did_some_io values were zero at that point in the code.
I didn't try to dig into the operation of the bytes_done and did_some_io va=
lues further, yet.


Also, I noticed that if option "--io_size=3D32M" was used instead of "numbe=
r_ios=3D8192", then the eta appeared to be accurate - so the eta issue does=
 "appear" to be independent - I can open a separate discussion or issue if =
desired.

Thanks

Kris Davis


