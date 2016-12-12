Return-Path: <Vincent.Fu@sandisk.com>
From: Vincent Fu <Vincent.Fu@sandisk.com>
Subject: steadystate job termination
Date: Mon, 12 Dec 2016 16:25:23 +0000
Message-ID: <BL2PR02MB19867DB3F155CE80CB07DEF08C980@BL2PR02MB1986.namprd02.prod.outlook.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

Jens, at https://bitbucket.org/vincentfu/fio-steadystate/commits/all is
a repo where I have committed patches to fio's steady-state branch that
address the following TODO items:

steadystate data is now transmitted over the wire in client/server mode
steadystate summary data is included with --output-format=3Dnormal
example steadystate job file added
man page updated

Please let me know what feedback you have.

With respect to client/server mode, I successfully tested the job file
below on x86-64 hardware using the following server platforms with each
of the listed client operating systems:
servers: Ubuntu 64-bit, Ubuntu 32-bit, OSX 10.11
clients: Ubuntu 64-bit, Ubuntu 32-bit, OSX 10.11, Windows 8.1 x64

Vincent

[iops_slope]
filename=3D/dev/zero
time_based=3D1
runtime=3D300s
size=3D8M
ss=3Diops_slope:0.5%
ss_dur=3D5
ss_ramp=3D2
numjobs=3D4
group_reporting

[bw_dev]
stonewall
filename=3D/dev/zero
time_based=3D1
runtime=3D300s
size=3D8M
ss=3Dbw:4%
ss_dur=3D5
ss_ramp=3D2
numjobs=3D2

--
Vincent Fu
Software Dev Engr II
SanDisk, a Western Digital brand
Email: Vincent.Fu@SanDisk.com
Office: 801 987 7079

PLEASE NOTE: The information contained in this electronic mail message is i=
ntended only for the use of the designated recipient(s) named above. If the=
 reader of this message is not the intended recipient, you are hereby notif=
ied that you have received this message in error and that any review, disse=
mination, distribution, or copying of this message is strictly prohibited. =
If you have received this communication in error, please notify the sender =
by telephone or e-mail (as shown above) immediately and destroy any and all=
 copies of this message in your possession (whether hard copies or electron=
ically stored copies).

