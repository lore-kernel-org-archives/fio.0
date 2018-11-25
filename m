Return-Path: <fio-owner@vger.kernel.org>
Received: from esa6.dell-outbound.iphmx.com ([68.232.149.229]:6991 "EHLO
        esa6.dell-outbound.iphmx.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725936AbeKYWRT (ORCPT
        <rfc822;fio@vger.kernel.org>); Sun, 25 Nov 2018 17:17:19 -0500
Received: from pps.filterd (m0089484.ppops.net [127.0.0.1])
        by mx0b-00154901.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id wAPBBe9r121142
        for <fio@vger.kernel.org>; Sun, 25 Nov 2018 06:26:25 -0500
Received: from esa4.dell-outbound2.iphmx.com (esa4.dell-outbound2.iphmx.com [68.232.154.98])
        by mx0b-00154901.pphosted.com with ESMTP id 2nytdng229-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <fio@vger.kernel.org>; Sun, 25 Nov 2018 06:26:25 -0500
From: "Beierl, Mark" <Mark.Beierl@dell.com>
Subject: Re: Re changing filename format.
Date: Sun, 25 Nov 2018 11:26:13 +0000
Message-ID: <67E7F83C-0316-4D3B-BABE-E067B5F99331@emc.com>
References: <CAFF4W0Uxs5eFvTH=Se3C9y80-3pDskX8jt9vv+mDG_PjjZMsfA@mail.gmail.com>
In-Reply-To: <CAFF4W0Uxs5eFvTH=Se3C9y80-3pDskX8jt9vv+mDG_PjjZMsfA@mail.gmail.com>
Content-Language: en-CA
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Mohanraj B <bmohanraj91@gmail.com>
Cc: fio <fio@vger.kernel.org>

Hello,

This has to do with environment variable expansion in bash. You need to esc=
ape the $, or put the argument into single quotes:

filename_format=3D=91$jobname.$jobnum.$filenum=92

Regards,
Mark=20

> On Nov 25, 2018, at 01:36, Mohanraj B <bmohanraj91@gmail.com> wrote:
>=20
>=20
> [EXTERNAL EMAIL]=20
>=20
> Hello,
>=20
> I am trying to changing filename format, so run the below command to test=
 it
>=20
> fio --name=3Djob --size=3D10m --numjobs=3D3
> --filename_format=3D$jobname.$jobnum.$filenum
>=20
> job: (g=3D0): rw=3Dread, bs=3D(R) 4096B-4096B, (W) 4096B-4096B, (T)
> 4096B-4096B, ioengine=3Dpsync, iodepth=3D1
> ...
> fio-3.12-17-g0fcbc0
> Starting 3 processes
> job: Laying out IO file (1 file / 10MiB)
> fio: pid=3D0, err=3D21/file:filesetup.c:138, func=3Dunlink, error=3DIs a =
directory
> job: Laying out IO file (1 file / 10MiB)
> fio: pid=3D0, err=3D21/file:filesetup.c:138, func=3Dunlink, error=3DIs a =
directory
> job: Laying out IO file (1 file / 10MiB)
> fio: pid=3D0, err=3D21/file:filesetup.c:138, func=3Dunlink, error=3DIs a =
directory
>=20
> Run status group 0 (all jobs):
>=20
> Got the above error, how to change the format of a file?
>=20
> Then tired set the filename format like below and test works.
> fio --name=3Djob --size=3D10m --numjobs=3D3 --filename_format=3Dtest.$job=
num.$filenum
> ...
> fio-3.12-17-g0fcbc0
> Starting 3 processes
> job: Laying out IO file (1 file / 10MiB)
>=20
> job: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D5117: Sun Nov 25 11:03:27 2=
018
>  read: IOPS=3D29.1k, BW=3D114MiB/s (119MB/s)(10.0MiB/88msec)
>    clat (nsec): min=3D1092, max=3D24776k, avg=3D32878.38, stdev=3D646198.=
51
>     lat (nsec): min=3D1153, max=3D24777k, avg=3D33010.36, stdev=3D646198.=
32
>    clat percentiles (nsec):
>     |  1.00th=3D[    1144],  5.00th=3D[    1448], 10.00th=3D[    1464],
>     | 20.00th=3D[    1512], 30.00th=3D[    1608], 40.00th=3D[    2064],
>     | 50.00th=3D[    2576], 60.00th=3D[    2896], 70.00th=3D[    2960],
>     | 80.00th=3D[    3024], 90.00th=3D[    3216], 95.00th=3D[    3664],
>     | 99.00th=3D[  411648], 99.50th=3D[  493568], 99.90th=3D[12124160],
>     | 99.95th=3D[13041664], 99.99th=3D[24772608]
>  lat (usec)   : 2=3D38.67%, 4=3D57.11%, 10=3D1.45%, 20=3D0.94%, 50=3D0.12=
%
>  lat (usec)   : 100=3D0.08%, 250=3D0.08%, 500=3D1.09%, 750=3D0.31%
>  lat (msec)   : 20=3D0.12%, 50=3D0.04%
>  cpu          : usr=3D11.49%, sys=3D4.60%, ctx=3D43, majf=3D0, minf=3D13
>  IO depths    : 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 32=
=3D0.0%, >=3D64=3D0.0%
>     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
>     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
>     issued rwts: total=3D2560,0,0,0 short=3D0,0,0,0 dropped=3D0,0,0,0
>     latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D1
>=20
> Run status group 0 (all jobs):
>   READ: bw=3D114MiB/s (119MB/s), 114MiB/s-114MiB/s (119MB/s-119MB/s),
> io=3D10.0MiB (10.5MB), run=3D88-88msec
>=20
> Disk stats (read/write):
>  sda: ios=3D31/0, merge=3D0/0, ticks=3D44/0, in_queue=3D48, util=3D30.14%
>=20
> There is only one file has created --> test. .
>=20
> 3 process has run, why it not create 3 files?.
>=20
> Thanks and Regards,
> Mohan

