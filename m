Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-eopbgr680132.outbound.protection.outlook.com ([40.107.68.132]:29976
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726485AbeLKR65 (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 11 Dec 2018 12:58:57 -0500
From: Mohan Mohan <mohan@ertino.com>
Subject: err=84/file:io_u.c:2033, func=io_u_sync_complete, error=Invalid or
 incomplete multibyte or wide character
Date: Tue, 11 Dec 2018 17:58:53 +0000
Message-ID: <DM5PR19MB1402A8B7F86B55C8E10D72FADBA60@DM5PR19MB1402.namprd19.prod.outlook.com>
Content-Language: en-IN
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>


Hi,

Is the error below is expected one for the read operation? I am not getting=
 any error for the write operation.

root@ertino-ThinkPad-T431s:/home/ertino--verify crc32c
xspp: (g=3D0): rw=3Drandread, bs=3D(R) 4096B-4096B, (W) 4096B-4096B, (T) 40=
96B-4096B, ioengine=3Dpsync, iodepth=3D1
fio-3.12-17-g0fcbc0
Starting 1 process
xspp: Laying out IO file (1 file / 10MiB)
verify: bad magic header 1950, wanted acca at file xspp.0.0 offset 630784, =
length 4096 (requested block: offset=3D630784, length=3D4096)
fio: pid=3D32055, err=3D84/file:io_u.c:2033, func=3Dio_u_sync_complete, err=
or=3DInvalid or incomplete multibyte or wide character

xspp: (groupid=3D0, jobs=3D1): err=3D84 (file:io_u.c:2033, func=3Dio_u_sync=
_complete, error=3DInvalid or incomplete multibyte or wide character): pid=
=3D32055: Tue Dec 11 23:09:30 2018
  read: IOPS=3D500, BW=3D2000KiB/s (2048kB/s)(4096B/2msec)
    clat (nsec): min=3D641354, max=3D641354, avg=3D641354.00, stdev=3D 0.00
     lat (nsec): min=3D645363, max=3D645363, avg=3D645363.00, stdev=3D 0.00
    clat percentiles (usec):
     |  1.00th=3D[  644],  5.00th=3D[  644], 10.00th=3D[  644], 20.00th=3D[=
  644],
     | 30.00th=3D[  644], 40.00th=3D[  644], 50.00th=3D[  644], 60.00th=3D[=
  644],
     | 70.00th=3D[  644], 80.00th=3D[  644], 90.00th=3D[  644], 95.00th=3D[=
  644],
     | 99.00th=3D[  644], 99.50th=3D[  644], 99.90th=3D[  644], 99.95th=3D[=
  644],
     | 99.99th=3D[  644]
  lat (usec)   : 750=3D100.00%
  cpu          : usr=3D0.00%, sys=3D0.00%, ctx=3D3, majf=3D0, minf=3D20
  IO depths    : 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 32=3D=
0.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     issued rwts: total=3D1,0,0,0 short=3D0,0,0,0 dropped=3D0,0,0,0
     latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D1

Run status group 0 (all jobs):
   READ: bw=3D2000KiB/s (2048kB/s), 2000KiB/s-2000KiB/s (2048kB/s-2048kB/s)=
, io=3D4096B (4096B), run=3D2-2msec

Disk stats (read/write):
  sda: ios=3D0/0, merge=3D0/0, ticks=3D0/0, in_queue=3D0, util=3D0.00%


Thanks and Regards,
Mohan

