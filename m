Return-Path: <fio-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:28743 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751693AbcIXPEu (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 24 Sep 2016 11:04:50 -0400
From: Greg Frees <greg.frees@hgst.com>
Subject: RE: Can FIO replay a "blktrace/blkparse" command list in Windows?
Date: Sat, 24 Sep 2016 15:04:47 +0000
Message-ID: <BN6PR04MB0788B9C0A175B808383C776FE3CB0@BN6PR04MB0788.namprd04.prod.outlook.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

Just refreshing the original question in hopes of an answer...

Can FIO for Windows replay an output file from blktrace/blkparse?


I need the ability to replay cmds from bus traces with the same timing as f=
ound in a SAS/SATA bus trace.  This is in order to use FIO to mimic the ori=
ginal read/write cmd workload as closely as possible so that I can reproduc=
e customer performance problems on the bench.  My goal is to create/synthes=
ize a replay file that contains the cmds and the timing of the cmds and use=
 FIO to replay it using read_iolog.  My experience is that I cannot accompl=
ish my goal by using a standard iolog such as the following because the WAI=
T statement does not work as documented in the FIO user guide.  I have done=
 several experiments trying to understand the behavior of the WAIT statemen=
t and it simply will not work to control the timing of the cmds in a way th=
at will match the original timing found in the bus trace.  Therefore I need=
 a different solution.

fio version 2 iolog
\.\PhysicalDrive0 add
\.\PhysicalDrive0 open
\.\PhysicalDrive0 read 603182858240 131072
\.\PhysicalDrive0 wait 1000 0
\.\PhysicalDrive0 read 7403516723200 131072
\.\PhysicalDrive0 wait 1000 0
\.\PhysicalDrive0 read 8432532848640 131072
\.\PhysicalDrive0 wait 1000 0
\.\PhysicalDrive0 write 4700536045568 131072
\.\PhysicalDrive0 wait 1000 0
\.\PhysicalDrive0 read 4019454869504 131072
\.\PhysicalDrive0 wait 1000 0
\.\PhysicalDrive0 read 8401981407232 131072
\.\PhysicalDrive0 read 3805264740352 131072
\.\PhysicalDrive0 read 3535500869632 131072
\.\PhysicalDrive0 close


From reading the FIO User's Guide it appears that FIO will try to enforce t=
he cmd timing of a replay file if it was created using the Linux "blktrace/=
blkparse" tools.  The output from blkparse contains records of cmds along w=
ith timestamps.  FIO apparently will use the timestamps of cmds to control =
the timing of when it will send an I/O.  This is exactly what I need.  Howe=
ver, blktrace/blkparse are Linux tools.  I need to be able to run the FIO r=
eplay on a Windows machine and I have not had success trying to use a blkpa=
rse output file as an iolog on Windows. =20


QUESTIONS:

	1.  Does FIO support using a blkparse output file as an iolog/replay file =
on FIO for Windows... or does this ONLY work on FIO for Linux?

	2.  If it does work on FIO for Windows, can you please send me a short exa=
mple blkparse file so that I can study it and use it as a model (i.e. the f=
ormat) for how I would synthesize a blkparse output to suit my needs?




Regards,
Greg


Greg Frees
Lead Performance Engineer
Senior Technologist

HGST, a Western Digital brand
5601 Great Oaks Parkway
San Jose, CA 95138
Email:  greg.frees@hgst.com
Office:  +1-408-717-7852
www.hgst.com
#LongLiveData




