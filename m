Return-Path: <Roger_Sibert@xyratex.com>
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Subject: RE: segfault runninng fio against 2048 jobs
Date: Wed, 18 Apr 2012 11:16:03 -0700
Message-ID: <0FEAAA2D70C89D49A62173478A6C4A5D02DECCC6@XYUS-EX22.xyus.xyratex.com>
In-Reply-To: <0FEAAA2D70C89D49A62173478A6C4A5D02DECCB6@XYUS-EX22.xyus.xyratex.com>
References: <0FEAAA2D70C89D49A62173478A6C4A5D02DECC2A@XYUS-EX22.xyus.xyratex.com> <4F8E6BFD.10408@kernel.dk> <0FEAAA2D70C89D49A62173478A6C4A5D02DECCB6@XYUS-EX22.xyus.xyratex.com>
From: "Roger Sibert" <Roger_Sibert@xyratex.com>
To: Roger Sibert <Roger_Sibert@xyratex.com>, Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

Hello Jens,

Not sure if this is a red herring or not.

I did a quick check using valgrind with its memcheck on the 1 job sample
and noted that there appears to be a small memory leak which gets
noticeably worse when you run against a larger job configuration.

All the leaks appear to be the same originating line of code so just a
snippet of the valgrind output is included below.

1 job configuration file
=3D=3D19277=3D=3D 168 bytes in 1 blocks are definitely lost in loss =
record 9 of
10
=3D=3D19277=3D=3D    at 0x4A0610C: malloc (vg_replace_malloc.c:195)
=3D=3D19277=3D=3D    by 0x408A44: load_ioengine (ioengines.c:148)
=3D=3D19277=3D=3D    by 0x409BE2: ioengine_load (init.c:694)
=3D=3D19277=3D=3D    by 0x409F79: add_job (init.c:765)
=3D=3D19277=3D=3D    by 0x40BD26: parse_jobs_ini (init.c:1135)
=3D=3D19277=3D=3D    by 0x40C059: parse_options (init.c:1602)
=3D=3D19277=3D=3D    by 0x4082F3: main (fio.c:104)
=3D=3D19277=3D=3D
.
.
=3D=3D19277=3D=3D
=3D=3D19277=3D=3D LEAK SUMMARY:
=3D=3D19277=3D=3D    definitely lost: 211 bytes in 6 blocks
=3D=3D19277=3D=3D    indirectly lost: 0 bytes in 0 blocks
=3D=3D19277=3D=3D      possibly lost: 272 bytes in 1 blocks
=3D=3D19277=3D=3D    still reachable: 12 bytes in 3 blocks
=3D=3D19277=3D=3D         suppressed: 0 bytes in 0 blocks
=3D=3D19277=3D=3D Reachable blocks (those to which a pointer was found) =
are not
shown.
=3D=3D19277=3D=3D To see them, rerun with: --leak-check=3Dfull
--show-reachable=3Dyes


2048 job configuration file.
=3D=3D19365=3D=3D 50,618,216 (311,144 direct, 50,307,072 indirect) bytes =
in
2,047 blocks are definitely lost in loss record 22 of 22
=3D=3D19365=3D=3D    at 0x4A0610C: malloc (vg_replace_malloc.c:195)
=3D=3D19365=3D=3D    by 0x42DA03: setup_log (iolog.c:499)
=3D=3D19365=3D=3D    by 0x40A9DD: add_job (init.c:846)
=3D=3D19365=3D=3D    by 0x40BD26: parse_jobs_ini (init.c:1135)
=3D=3D19365=3D=3D    by 0x40C059: parse_options (init.c:1602)
=3D=3D19365=3D=3D    by 0x4082F3: main (fio.c:104)
=3D=3D19365=3D=3D
=3D=3D19365=3D=3D LEAK SUMMARY:
=3D=3D19365=3D=3D    definitely lost: 1,843,954 bytes in 22,523 blocks
=3D=3D19365=3D=3D    indirectly lost: 201,154,560 bytes in 8,185 blocks
=3D=3D19365=3D=3D      possibly lost: 73,728 bytes in 3 blocks
=3D=3D19365=3D=3D    still reachable: 580 bytes in 4 blocks
=3D=3D19365=3D=3D         suppressed: 0 bytes in 0 blocks

Thanks,
Roger
-----Original Message-----
From: fio-owner@vger.kernel.org [mailto:fio-owner@vger.kernel.org] On
Behalf Of Roger Sibert
Sent: Wednesday, April 18, 2012 1:27 PM
To: Jens Axboe
Cc: fio@vger.kernel.org
Subject: RE: segfault runninng fio against 2048 jobs

Heres hoping Outlook doesn't inject html into the message again.

[global]
direct=3D1
ioengine=3Dlibaio
zonesize=3D1g
randrepeat=3D1
write_bw_log
write_lat_log
time_based
ramp_time=3D15s
runtime=3D15s
;
[sdf-iodepth1-rw-readwrite_mix_5050-bs128k-2048]
description=3D[sdf-iodepth1-rw-readwrite_mix_5050-bs128k-2048]
stonewall
filename=3D/dev/sdf
iodepth=3D1
rw=3Drw
rwmixread=3D50
rwmixwrite=3D50
bs=3D128k

Running just the 2048 job on its own doesn't cause any issues.

I did a fresh git clone and ended up with fio-2.0.7-10-g8430 (which was
compiled on the local system without making any changes to the code) and
re-ran the test using the full 2048 to verify that the segfault still
occurs, which it does.  I also noted that the segfault is about
immediate once seeing Jobs: 1 (f=3Dxxx) print and stays that way until =
you
reduce it down to 535.  At about 535 it runs for about 15 or so seconds
before segfaulting, 500 is still running after about 3 minutes.

Thanks,
Roger

-----Original Message-----
From: Jens Axboe [mailto:axboe@kernel.dk]=20
Sent: Wednesday, April 18, 2012 3:24 AM
To: Roger Sibert
Cc: fio@vger.kernel.org
Subject: Re: segfault runninng fio against 2048 jobs

On 04/17/2012 11:05 PM, Roger Sibert wrote:
> Hello Everyone,
>=20
> I am using a 2.0x variant ran across a couple of things, one of which
> looks to be as designed and the other was a segfault in fio.
>=20
> My original job file had 4800 entries which exceeds the max limit.
> (error: maximum number of jobs (2048) reached)  The question I have
> here , is there a reason the limit can't be raised to handle larger
> job files?

There's no inherent limit in fio that causes this, it was done to avoid
errors on platforms where shared memory segments were more limited. A
check now reveals that thread_data is around 15KB, which means that the
segment is around 30MB in total. You should be safe to bump the

#define REAL_MAX_JOBS           2048

in fio.h to something bigger. In fact I should just make it bigger, we
scale it down these days if we see errors.

> Reducing the job file to the max re-running it jumped straight to the
initial print screen and then to a segfault. (Segmentation fault (core
dumped))
>=20
> Doing a quick look gave me=20
>=20
> [root@localhost std-testing]# gdb fio core.9582
> GNU gdb (GDB) CentOS (7.0.1-42.el5.centos)
> Copyright (C) 2009 Free Software Foundation, Inc.
> License GPLv3+: GNU GPL version 3 or later
<http://gnu.org/licenses/gpl.html>
> This is free software: you are free to change and redistribute it.
> There is NO WARRANTY, to the extent permitted by law.  Type "show
copying"
> and "show warranty" for details.
> This GDB was configured as "x86_64-redhat-linux-gnu".
> For bug reporting instructions, please see:
> <http://www.gnu.org/software/gdb/bugs/>...
> Reading symbols from /root/fio-test/std-testing/fio...done.
> [New Thread 9583]
> [New Thread 9582]
>=20
> warning: no loadable sections found in added symbol-file
system-supplied DSO at 0x7fff213fd000
> Core was generated by `./fio --output=3D1.log 1.inp'.
> Program terminated with signal 11, Segmentation fault.
> #0  0x00000000004167b0 in display_thread_status (je=3D<value optimized
out>) at eta.c:416
> 416     eta.c: No such file or directory.
>         in eta.c
> (gdb) quit
>=20
> I reduced the job count down to about 33 and re-started the run which
I am waiting to finish so I can re-compile fio with whatever extra flags
and to whatever code level are requested.  Currently file gives me:
> fio: ELF 64-bit LSB executable, AMD x86-64, version 1 (GNU/Linux), for
GNU/Linux 2.6.15, statically linked, not stripped
> Which is running on a CentOS box
> Linux localhost.localdomain 2.6.18-308.1.1.el5 #1 SMP Wed Mar 7
04:16:51 EST 2012 x86_64 x86_64 x86_64 GNU/Linux

There's not enough information here to help you out, I'm afraid. What
fio version are you running? What job did you run that caused this
failure?

--=20
Jens Axboe

--
To unsubscribe from this list: send the line "unsubscribe fio" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
______________________________________________________________________
This email may contain privileged or confidential information, which shou=
ld only be used for the purpose for which it was sent by Xyratex. No furt=
her rights or licenses are granted to use such information. If you are no=
t the intended recipient of this message, please notify the sender by ret=
urn and delete it. You may not use, copy, disclose or rely on the informa=
tion contained in it.
 =

Internet email is susceptible to data corruption, interception and unauth=
orised amendment for which Xyratex does not accept liability. While we ha=
ve taken reasonable precautions to ensure that this email is free of viru=
ses, Xyratex does not accept liability for the presence of any computer v=
iruses in this email, nor for any losses caused as a result of viruses.
 =

Xyratex Technology Limited (03134912), Registered in England & Wales, Reg=
istered Office, Langstone Road, Havant, Hampshire, PO9 1SA.
 =

The Xyratex group of companies also includes, Xyratex Ltd, registered in =
Bermuda, Xyratex International Inc, registered in California, Xyratex (Ma=
laysia) Sdn Bhd registered in Malaysia, Xyratex Technology (Wuxi) Co Ltd =
registered in The People's Republic of China and Xyratex Japan Limited re=
gistered in Japan.
______________________________________________________________________
 =

=0D

