Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-bl2on0064.outbound.protection.outlook.com ([65.55.169.64]:11335
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751006AbcEMA2L convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Thu, 12 May 2016 20:28:11 -0400
From: Todd Lawall <tlawall@pivot3.com>
Subject: Potential Bug: Block size dropped in log files when running with
 log_avg_msec
Date: Thu, 12 May 2016 22:54:51 +0000
Message-ID: <BN3PR1001MB1137DE7C7340FA5B1DD9E6709D730@BN3PR1001MB1137.namprd10.prod.outlook.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hello,

I've been doing some test runs with fio using the write_bw_log, write_lat_l=
og and write_iops_log options, and I've needed to use the log_avg_msec opti=
on to set my sample interval.=EF=BF=BD=EF=BF=BD I've noticed when running w=
ith log_avg_msec, the block size is dropped from the logs.=EF=BF=BD See exa=
mples of the BW log:

Without log_avg_msec:

13, 14833, 0, 32768
13, 14780, 1, 32768
13, 14780, 1, 32768
13, 15003, 0, 32768
13, 17702, 1, 32768
13, 17655, 1, 32768

With log_avg_msec:

500, 312320, 0, 0
1090, 343972, 0, 0
1090, 310784, 1, 0
2083, 329861, 0, 0
2083, 324756, 1, 0
3073, 285252, 0, 0
3073, 306290, 1, 0
4040, 320644, 0, 0

-----------------------------------------------------------
Now for the other details:

Environment: Linux Kubuntu 16.04.  Uname output:

=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BDLinux <hostname> 4.4.0-21-generic #37-U=
buntu SMP Mon Apr 18 18:33:37 UTC 2016 x86_64 x86_64 x86_64 GNU/Linux

Fio version:

   fio-2.9-35-g5c8f

GCC version:

    $ gcc --version
    gcc (Ubuntu 5.3.1-14ubuntu2) 5.3.1 20160413

Job file (named fileTest.job):

    [global]
    ioengine=3Daio
    numjobs=3D1
    offset=3D0
    verify=3Dcrc32c-intel
    time_based
    runtime=3D120
    thread

    [1]
    blocksize=3D32k
    readwrite=3Drw
    verify=3Dmeta
    do_verify=3D0
    verify_pattern=3D0xAA55AA55
    iodepth=3D32
    filename=3D/tmp/fio.dat
    size=3D100M

Command line:

    #!/bin/bash
    /opt/build/fio/fio --write_iops_log $1 --write_bw_log $1 --write_lat_lo=
g $1 --output-format=3Djson --status-interval=3D1 fileTest.job

Failure command line is the same as above, but add --log_avg_msec 500
