Return-Path: <fio-owner@vger.kernel.org>
Received: from sjc00mx1.hitachigst.com ([199.255.44.36]:49078 "EHLO
	sjc00mx1.hgst.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761AbcAFSpm convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Wed, 6 Jan 2016 13:45:42 -0500
From: Jeff Furlong <jeff.furlong@hgst.com>
Subject: time_based option broken
Date: Wed, 6 Jan 2016 18:45:39 +0000
Message-ID: <BN3PR0401MB145733E19D0EC0B19F88C9D1F7F40@BN3PR0401MB1457.namprd04.prod.outlook.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi All,
Back in version 2.1.14, --time_based would allow a sequential workload to wrap around the device under test, if we reach the end of device or --size limits the range.  But in version 2.3, --time_based is broken.

Here is 2.1.14 with a --runtime of 60s, and a runt of 60s:

# fio --name=SW_1MB_QD32 --ioengine=libaio --direct=1 --rw=write --iodepth=32 --size=1% --runtime=60s --time_based --numjobs=1 --bs=1m --overwrite=1 --filename=/dev/nvme0n1
SW_1MB_QD32: (g=0): rw=write, bs=1M-1M/1M-1M/1M-1M, ioengine=libaio, iodepth=32
fio-2.1.14
Starting 1 process
Jobs: 1 (f=1): [W(1)] [100.0% done] [0KB/995.1MB/0KB /s] [0/995/0 iops] [eta 00m:00s]
SW_1MB_QD32: (groupid=0, jobs=1): err= 0: pid=71018: Wed Jan  6 09:14:53 2016
  write: io=56738MB, bw=968345KB/s, iops=945, runt= 59999msec
    slat (usec): min=357, max=14590, avg=1049.50, stdev=181.80
    clat (usec): min=175, max=73870, avg=32747.94, stdev=3397.28
     lat (usec): min=947, max=75129, avg=33798.39, stdev=3491.75
    clat percentiles (usec):
     |  1.00th=[30592],  5.00th=[30592], 10.00th=[30592], 20.00th=[30848],
     | 30.00th=[30848], 40.00th=[31104], 50.00th=[31360], 60.00th=[31360],
     | 70.00th=[31872], 80.00th=[36608], 90.00th=[38144], 95.00th=[38656],
     | 99.00th=[44288], 99.50th=[46336], 99.90th=[57600], 99.95th=[63744],
     | 99.99th=[70144]
    bw (KB  /s): min=790528, max=1028096, per=99.84%, avg=966794.02, stdev=80569.23
    lat (usec) : 250=0.01%, 1000=0.01%
    lat (msec) : 2=0.01%, 4=0.01%, 10=0.04%, 20=0.07%, 50=99.74%
    lat (msec) : 100=0.13%
  cpu          : usr=25.69%, sys=75.38%, ctx=155, majf=0, minf=3823
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=99.8%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.1%, 64=0.0%, >=64=0.0%
     issued    : total=r=0/w=56738/d=0, short=r=0/w=0/d=0, drop=r=0/w=0/d=0
     latency   : target=0, window=0, percentile=100.00%, depth=32

Run status group 0 (all jobs):
  WRITE: io=56738MB, aggrb=968344KB/s, minb=968344KB/s, maxb=968344KB/s, mint=59999msec, maxt=59999msec

Disk stats (read/write):
  nvme0n1: ios=364/509460, merge=0/0, ticks=21/93539, in_queue=93551, util=80.61%


Here is 2.3 with a --runtime of 60s, and a runt of only 16s, and an error:

# fio --name=SW_1MB_QD32 --ioengine=libaio --direct=1 --rw=write --iodepth=32 --size=1% --runtime=60s --time_based --numjobs=1 --bs=1m --overwrite=1 --filename=/dev/nvme0n1
SW_1MB_QD32: (g=0): rw=write, bs=1M-1M/1M-1M/1M-1M, ioengine=libaio, iodepth=32
fio-2.3-11-g5f3b
Starting 1 process
fio: io_u error on file /dev/nvme0n1: Invalid argument: write offset=153764, buflen=1048576
fio: io_u error on file /dev/nvme0n1: Invalid argument: write offset=1202340, buflen=1048576
fio: pid=68391, err=22/file:io_u.c:1596, func=io_u error, error=Invalid argument

SW_1MB_QD32: (groupid=0, jobs=1): err=22 (file:io_u.c:1596, func=io_u error, error=Invalid argument): pid=68391: Wed Jan  6 08:48:18 2016
  write: io=15262MB, bw=957733KB/s, iops=937, runt= 16318msec
    slat (usec): min=90, max=7299, avg=1057.41, stdev=223.10
    clat (msec): min=6, max=81, avg=33.10, stdev= 4.04
     lat (msec): min=7, max=82, avg=34.16, stdev= 4.15
    clat percentiles (usec):
     |  1.00th=[30336],  5.00th=[30592], 10.00th=[30848], 20.00th=[30848],
     | 30.00th=[31104], 40.00th=[31104], 50.00th=[31360], 60.00th=[31616],
     | 70.00th=[32128], 80.00th=[37120], 90.00th=[38656], 95.00th=[39680],
     | 99.00th=[46336], 99.50th=[46848], 99.90th=[74240], 99.95th=[78336],
     | 99.99th=[81408]
    bw (KB  /s): min=745472, max=1028096, per=99.83%, avg=956100.72, stdev=83519.38
    lat (msec) : 10=0.04%, 20=0.08%, 50=99.39%, 100=0.28%
  cpu          : usr=25.12%, sys=75.00%, ctx=53, majf=0, minf=2253
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=99.8%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued    : total=r=0/w=15294/d=0, short=r=0/w=0/d=0, drop=r=0/w=0/d=0
     latency   : target=0, window=0, percentile=100.00%, depth=32

Run status group 0 (all jobs):
  WRITE: io=15262MB, aggrb=957733KB/s, minb=957733KB/s, maxb=957733KB/s, mint=16318msec, maxt=16318msec

Disk stats (read/write):
  nvme0n1: ios=2/135369, merge=0/0, ticks=0/87547, in_queue=87546, util=82.23%


The issue seems to be that in version 2.3 we no longer wrap around the device when in sequential workloads.  Random workloads seem fine.  Thoughts?

Thanks.

Regards,
Jeff

HGST E-mail Confidentiality Notice & Disclaimer:
This e-mail and any files transmitted with it may contain confidential or legally privileged information of HGST and are intended solely for the use of the individual or entity to which they are addressed. If you are not the intended recipient, any disclosure, copying, distribution or any action taken or omitted to be taken in reliance on it, is prohibited.  If you have received this e-mail in error, please notify the sender immediately and delete the e-mail in its entirety from your system.

