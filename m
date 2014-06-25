Return-Path: <fio-owner@vger.kernel.org>
Received: from mailout1b.intuit.com ([206.108.40.7]:23104 "EHLO
	qdcapmail1.data.ie.intuit.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751862AbaFYAdl convert rfc822-to-8bit
	(ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 24 Jun 2014 20:33:41 -0400
From: "Hinson, Roger" <Roger_Hinson@intuit.com>
Subject: Block size of zero in log files
Date: Wed, 25 Jun 2014 00:33:35 +0000
Message-ID: <ab186420ecb140c887b85f36fcdde766@BLUPR02MB453.namprd02.prod.outlook.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=
=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD Hi,

=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=
=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD I'm new to usi=
ng FIO.=EF=BF=BD I'm using FIO 2.1.10, although I had the same problem with=
 FIO 2.1.7.=EF=BF=BD The log files are not listing the blocksize.=EF=BF=BD =
I looked around and can't find anything obvious that I'm doing wrong, altho=
ugh I see posts with it working for people.=EF=BF=BD Has anyone seen and so=
lved this?

Here is a snippet from my FIO config file.

[global]
thread
group_reporting=3D1
direct=3D1
norandommap=3D0
randrepeat=3D0
refill_buffers
buffer_compress_percentage=3D0
ioengine=3Dlibaio
#filename=3D/dev/dm-0:/dev/dm-1:/dev/dm-2:/dev/dm-3:/dev/dm-4:/dev/dm-5

log_avg_msec=3D1000

[128kB_SeqWr_dm0_1stPass]
write_bw_log=3D128kB_SeqWr_dm0_1stPass
write_lat_log=3D128kB_SeqWr_dm0_1stPass
write_iops_log=3D128kB_SeqWr_dm0_1stPass
filename=3D/dev/dm-0
bs=3D128k
rw=3Dwrite
numjobs=3D1
iodepth=3D8

[128kB_SeqWr_dm1_1stPass]
write_bw_log=3D128kB_SeqWr_dm1_1stPass
write_lat_log=3D128kB_SeqWr_dm1_1stPass
write_iops_log=3D128kB_SeqWr_dm1_1stPass
filename=3D/dev/dm-1
bs=3D128k
rw=3Dwrite
numjobs=3D1
iodepth=3D8

and a snippet of a log file

tail -5 128kB_SeqWr_dm0_1stPass_bw.log=20

10767282, 171175, 1, 0
10768286, 167055, 1, 0
10769288, 172508, 1, 0
10770292, 170629, 1, 0
10770926, 174754, 1, 0


=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=
=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD Thanks,
=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=
=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD Roger



