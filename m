Return-Path: <fio-owner@vger.kernel.org>
Received: from wdmail02.wdc.com ([129.253.55.42]:54658 "EHLO wdmail02.wdc.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753930AbaLMAX6 convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Fri, 12 Dec 2014 19:23:58 -0500
From: Stephen Nichols <Stephen.Nichols@wdc.com>
Subject: Sequential Commands are essentially random when in mixed
 sequential/random workloads
Date: Sat, 13 Dec 2014 00:23:56 +0000
Message-ID: <89470388ACB8A24491F3E64F24385FD75A4DC251@wdscexmb03>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "'fio@vger.kernel.org'" <fio@vger.kernel.org>

Hi all,

When using fio configuration below..

[global]
ioengine=3Dlibaio
direct=3D1
runtime=3D600
bs=3D32k
iodepth=3D8
rw=3Drandrw
rwmixread=3D80
percentage_random=3D100,0

[drive1]
filename=3D/dev/sda


I am expecting to see 80% reads, 20% writes where all reads are random and =
all writes are sequential. I captured a bus trace of traffic to the disk an=
d the bus trace reflected as much with one issue. The write commands are es=
sentially random. Each write begins at a new random LBA. If 2 or more write=
s occur in a row, the LBA's are sequential based on the block size BUT I fe=
el the heart of this feature would be to emulate a large file write during =
random access. With that in mind would it be possible for sequential reads =
or writes within mixed sequential/random workload to remember the last LBA =
accessed? In this scenario the writes would still only take up 20% of the w=
orkload but when a write did occur it should be the next sequential step fr=
om the last write.


Snippet from the bus trace for reference

Command=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=
=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=
=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=
=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=
=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=
=BD=EF=BF=BD LBA
Read FPDMA Queued:=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=
=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=
=BD=EF=BF=BD=EF=BF=BD 19F3F818
Read FPDMA Queued:=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=
=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=
=BD=EF=BF=BD=EF=BF=BD 1CBE2740
Write FPDMA Queued: =EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=
=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=
=BF=BD 24E35198
Write FPDMA Queued:=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=
=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=
=BF=BD=EF=BF=BD 24E351A0
Read FPDMA Queued:=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=
=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=
=BD=EF=BF=BD=EF=BF=BD 115A9E10
Write FPDMA Queued:=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=
=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=
=BF=BD=EF=BF=BD A3C1968
Read FPDMA Queued:=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=
=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=
=BD=EF=BF=BD=EF=BF=BD 20B89488
Write FPDMA Queued:=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=
=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=
=BF=BD=EF=BF=BD 336EE0D0
Write FPDMA Queued:=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=
=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=
=BF=BD=EF=BF=BD 336EE0D8



Let me know what you think, this feature may be working as intended but it =
seemed off to me.

Thanks,
Stephen "Nick" Nichols
Western Digital
Enterprise Test Development

