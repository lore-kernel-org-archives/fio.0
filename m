Return-Path: <fio-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:27334 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751156AbdLEABt (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 4 Dec 2017 19:01:49 -0500
From: Jeff Furlong <jeff.furlong@wdc.com>
Subject: fio lat reporting
Date: Tue, 5 Dec 2017 00:01:46 +0000
Message-ID: <CY1PR0401MB14666D5091EECA44B869957E8F3D0@CY1PR0401MB1466.namprd04.prod.outlook.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi All,
In commit "Add support for doing total latency percentiles" (b599759ba565e7=
f2f573af364e6da4fe6d556a90), the total latency percentiles option was added=
.  However, some workloads appear broken:

# fio --name=3Dtest --ioengine=3Dlibaio --direct=3D1 --rw=3Drandread --iode=
pth=3D1 --size=3D100% --bs=3D4k --filename=3D/dev/nvme0n1 --runtime=3D5s --=
write_lat_log=3Dtest --disable_lat=3D0 --disable_clat=3D1 --disable_slat=3D=
1 --lat_percentiles=3D1
test: (g=3D0): rw=3Drandread, bs=3D(R) 4096B-4096B, (W) 4096B-4096B, (T) 40=
96B-4096B, ioengine=3Dlibaio, iodepth=3D1
fio-3.2-66-g67bfe
Starting 1 process
Jobs: 1 (f=3D1): [r(1)][100.0%][r=3D351MiB/s,w=3D0KiB/s][r=3D89.9k,w=3D0 IO=
PS][eta 00m:00s]
test: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D6879: Mon Dec  4 15:46:04 20=
17
   read: IOPS=3D89.7k, BW=3D351MiB/s (368MB/s)(1753MiB/5001msec)
     lat (usec): min=3D9, max=3D2259, avg=3D10.67, stdev=3D 7.66
     lat percentiles (nsec):
     |  1.00th=3D[    0],  5.00th=3D[    0], 10.00th=3D[    0], 20.00th=3D[=
    0],
     | 30.00th=3D[    0], 40.00th=3D[    0], 50.00th=3D[    0], 60.00th=3D[=
    0],
     | 70.00th=3D[    0], 80.00th=3D[    0], 90.00th=3D[    0], 95.00th=3D[=
    0],
     | 99.00th=3D[    0], 99.50th=3D[    0], 99.90th=3D[    0], 99.95th=3D[=
    0],
     | 99.99th=3D[    0]

In the above, we try to enable only lat log, so disable clat and slat.  The=
 summary output shows lat, but the values are zero.

# fio --name=3Dtest --ioengine=3Dlibaio --direct=3D1 --rw=3Drandread --iode=
pth=3D1 --size=3D100% --bs=3D4k --filename=3D/dev/nvme0n1 --runtime=3D5s --=
write_lat_log=3Dtest --disable_lat=3D0 --disable_clat=3D0 --disable_slat=3D=
1 --lat_percentiles=3D1
test: (g=3D0): rw=3Drandread, bs=3D(R) 4096B-4096B, (W) 4096B-4096B, (T) 40=
96B-4096B, ioengine=3Dlibaio, iodepth=3D1
fio-3.2-66-g67bfe
Starting 1 process
Jobs: 1 (f=3D1): [r(1)][100.0%][r=3D356MiB/s,w=3D0KiB/s][r=3D91.1k,w=3D0 IO=
PS][eta 00m:00s]
test: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D6956: Mon Dec  4 15:47:43 20=
17
   read: IOPS=3D87.8k, BW=3D343MiB/s (360MB/s)(1715MiB/5001msec)
    clat (nsec): min=3D561, max=3D2258.3k, avg=3D9941.30, stdev=3D6660.37
     lat (usec): min=3D9, max=3D2259, avg=3D10.88, stdev=3D 7.52
     lat percentiles (nsec):
     |  1.00th=3D[10304],  5.00th=3D[10304], 10.00th=3D[10304], 20.00th=3D[=
10304],
     | 30.00th=3D[10432], 40.00th=3D[10432], 50.00th=3D[10432], 60.00th=3D[=
10432],
     | 70.00th=3D[10432], 80.00th=3D[10944], 90.00th=3D[11072], 95.00th=3D[=
14784],
     | 99.00th=3D[15296], 99.50th=3D[15424], 99.90th=3D[16064], 99.95th=3D[=
17024],
     | 99.99th=3D[24704]

In the above, we force clat on, and now the lat values are non-zero in the =
summary output.

In the commit for stat.c, I see:

	if (ts->lat_percentiles)
		add_clat_percentile_sample(ts, nsec, ddir);

Does that seem correct?

Regards,
Jeff

