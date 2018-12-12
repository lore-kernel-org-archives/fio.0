Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-eopbgr780125.outbound.protection.outlook.com ([40.107.78.125]:14800
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726243AbeLLNlm (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 12 Dec 2018 08:41:42 -0500
From: Mohan Mohan <mohan@ertino.com>
Subject: Testing --blocksize_range 
Date: Wed, 12 Dec 2018 13:41:39 +0000
Message-ID: <DM5PR19MB1402B69B8FE2C5019A8926D1DBA70@DM5PR19MB1402.namprd19.prod.outlook.com>
Content-Language: en-IN
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi

I am testing fio with bs ranges 1k-10k 2k-10k 3k-10k 4k-10k 5k-10k 6k-10k.

The test works fine for the below run:
fio --name=3DApp2 --size=3D10m --rw=3Dread --blocksize_range=3D1k-10k
# fio --name=3DApp2 --size=3D10m --rw=3Dread --blocksize_range=3D2k-10k
# fio --name=3DApp2 --size=3D10m --rw=3Dread --blocksize_range=3D5k-10k

But error throws on below runs
# fio --name=3DApp2 --size=3D10m --rw=3Dread --blocksize_range=3D3k-10k
# fio --name=3DApp2 --size=3D10m --rw=3Dread --blocksize_range=3D4k-10k
# fio --name=3DApp2 --size=3D10m --rw=3Dread --blocksize_range=3D6k-10k

App2: (g=3D0): rw=3Dread, bs=3D(R) 3072B-10.0KiB, (W) 3072B-10.0KiB, (T) 30=
72B-10.0KiB, ioengine=3Dpsync, iodepth=3D1
fio-3.12-17-g0fcbc0
Starting 1 process
*** Error in `fio': double free or corruption (!prev): 0x0000555f92a80a60 *=
**
fio: pid=3D1468, got signal=3D6

App2: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D1468: Wed Dec 12 19:09:07 20=
18
  read: IOPS=3D8365, BW=3D52.9MiB/s (55.5MB/s)(9.00MiB/189msec)
    clat (nsec): min=3D874, max=3D74912k, avg=3D116222.51, stdev=3D2186743.=
16
     lat (nsec): min=3D912, max=3D74912k, avg=3D116373.83, stdev=3D2186743.=
70
    clat percentiles (nsec):
     |  1.00th=3D[     964],  5.00th=3D[    1128], 10.00th=3D[    1368],
     | 20.00th=3D[    1672], 30.00th=3D[    2008], 40.00th=3D[    2288],
     | 50.00th=3D[    2704], 60.00th=3D[    3088], 70.00th=3D[    3536],
     | 80.00th=3D[    4768], 90.00th=3D[    6304], 95.00th=3D[    8160],
     | 99.00th=3D[  544768], 99.50th=3D[ 2113536], 99.90th=3D[30539776],
     | 99.95th=3D[74973184], 99.99th=3D[74973184]
  lat (nsec)   : 1000=3D1.52%
  lat (usec)   : 2=3D28.34%, 4=3D44.85%, 10=3D21.70%, 20=3D0.51%, 50=3D0.32=
%
  lat (usec)   : 250=3D0.25%, 500=3D1.20%, 750=3D0.76%
  lat (msec)   : 4=3D0.25%, 20=3D0.13%, 50=3D0.13%, 100=3D0.06%
  cpu          : usr=3D3.72%, sys=3D3.72%, ctx=3D43, majf=3D0, minf=3D14
  IO depths    : 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 32=3D=
0.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     issued rwts: total=3D1581,0,0,0 short=3D0,0,0,0 dropped=3D0,0,0,0
     latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D1

Run status group 0 (all jobs):
   READ: bw=3D52.9MiB/s (55.5MB/s), 52.9MiB/s-52.9MiB/s (55.5MB/s-55.5MB/s)=
, io=3D9.00MiB (10.5MB), run=3D189-189msec

Disk stats (read/write):
  sda: ios=3D24/0, merge=3D0/0, ticks=3D188/0, in_queue=3D260, util=3D55.70=
%

I believe the expected test has run properly but why the error has thrown f=
or the particular ranges.

Thanks and Regards,
Mohan=

