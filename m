Return-Path: <fio-owner@vger.kernel.org>
Received: from hop-nat-141.emc.com ([168.159.213.141]:33520 "EHLO
	mexforward.lss.emc.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757443Ab3CUL0F convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Thu, 21 Mar 2013 07:26:05 -0400
Received: from hop04-l1d11-si01.isus.emc.com (HOP04-L1D11-SI01.isus.emc.com [10.254.111.54])
	by mexforward.lss.emc.com (Switch-3.4.3/Switch-3.4.3) with ESMTP id r2LBPxfR018134
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <fio@vger.kernel.org>; Thu, 21 Mar 2013 07:26:02 -0400
Received: from mailhub.lss.emc.com (mailhubhoprd04.lss.emc.com [10.254.222.226]) by hop04-l1d11-si01.isus.emc.com (RSA Interceptor) for <fio@vger.kernel.org>; Thu, 21 Mar 2013 07:25:50 -0400
Received: from mxhub25.corp.emc.com (mxhub25.corp.emc.com [10.254.110.181])
	by mailhub.lss.emc.com (Switch-3.4.3/Switch-3.4.3) with ESMTP id r2LBPoc5020810
	for <fio@vger.kernel.org>; Thu, 21 Mar 2013 07:25:50 -0400
From: "Ruvinsky, Konstantin" <Konstantin.Ruvinsky@emc.com>
Date: Thu, 21 Mar 2013 07:25:48 -0400
Subject: data integrity in stress tests
Message-ID: <EEF9E3C12F20174DA289A981D6CCA6C83244B1D850@MX44A.corp.emc.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi fio forum,

Could you please address the following query:

I was wondering about the correct way to perform a data integrity check whi=
le using a high stress scenario,
Scenario 1: File system, =EF=BF=BDCould the following command be used for d=
ata integrity check of IO on device with FS:

fio --name=3Ddedup --ioengine=3Dlibaio --rw=3Drandwrite --bs=3D16k --numjob=
s=3D64 --thread=EF=BF=BD=EF=BF=BD --direct=3D1=EF=BF=BD --write_iolog=3DC -=
-size=3D400m --directory=3D/mnt --do_verify=3D1 --verify=3Dmd5

I got the message that "Multiple writers may overwrite blocks that belong t=
o other jobs. This can cause verification failures."

In the fio man pages is written:=20
filename=3Dstr=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD Fio normally ma=
kes up a filename based on the job name,
=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=
=BF=BD=EF=BF=BD=EF=BF=BD thread number, and file number. If you want to sha=
re
=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=
=BF=BD=EF=BF=BD=EF=BF=BD files between threads in a job or several jobs, sp=
ecify
=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=
=BF=BD=EF=BF=BD=EF=BF=BD a filename for each of them to override the default

Actually, fio creates 64 files and according to man pages every thread is w=
riting to its file. Since -iodepth=3D1 (default) why should there be a prob=
lem with multiple writers even in the case of async ioengine?
If this is not correct, can someone suggest a data integrity check command =
in multithreaded fio run for devices with FS?

Scenario 2: RAW device, Could the flag --lockfile=3Dreadwrite in the follow=
ing fio command solve the problem of "Multiple writers may overwrite blocks=
 that belong to other jobs":

fio --name=3Ddedup --ioengine=3Dposixaio --rw=3Drandwrite --lockfile=3Dread=
write --bs=3D32k --numjobs=3D64 --thread --size=3D100m --verify=3Dmd5 --do_=
verify=3D1 --direct=3D1 --filename=3D/dev/hdiskpower2 --verify_fatal=3D1 --=
invalidate=3D0

In the fio man pages is written:=20
Lockfile=3Dreadwrite=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD Read-writ=
e locking on the file. Many
=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=
=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=
=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=
=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD readers may access the file at the
=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=
=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=
=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=
=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD same time, but writes get exclusive
=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=
=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=
=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=
=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD access.
Taking into account that that iodepth=3D1 and only one thread can write in =
a given time, one can suppose that it solves the problem of blocks overwrit=
e since it looks similar to one threaded writer, isn't it?=20
If this is not correct, can someone explain why and suggest a data integrit=
y check command in multithreaded fio run for raw devices?


Thank you
Konstantin Ruvinsky

