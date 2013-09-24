Return-Path: <fio-owner@vger.kernel.org>
Received: from mailuogwhop.emc.com ([168.159.213.141]:33482 "EHLO
	mailuogwhop.emc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830Ab3IXNQr convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Tue, 24 Sep 2013 09:16:47 -0400
Received: from maildlpprd03.lss.emc.com (maildlpprd03.lss.emc.com [10.253.24.35])
	by mailuogwprd04.lss.emc.com (Sentrion-MTA-4.3.0/Sentrion-MTA-4.3.0) with ESMTP id r8ODGjeV003638
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <fio@vger.kernel.org>; Tue, 24 Sep 2013 09:16:46 -0400
Received: from mailusrhubprd04.lss.emc.com (mailusrhubprd04.lss.emc.com [10.253.24.22]) by maildlpprd03.lss.emc.com (RSA Interceptor) for <fio@vger.kernel.org>; Tue, 24 Sep 2013 09:16:35 -0400
Received: from mxhub36.corp.emc.com (mxhub36.corp.emc.com [10.254.93.84])
	by mailusrhubprd04.lss.emc.com (Sentrion-MTA-4.3.0/Sentrion-MTA-4.3.0) with ESMTP id r8ODGYZL027454
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=FAIL)
	for <fio@vger.kernel.org>; Tue, 24 Sep 2013 09:16:35 -0400
From: "Ruvinsky, Konstantin" <Konstantin.Ruvinsky@emc.com>
Date: Tue, 24 Sep 2013 09:16:32 -0400
Subject: data integrity test using job file
Message-ID: <EEF9E3C12F20174DA289A981D6CCA6C8324A3CC645@MX44A.corp.emc.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

Running the following job file at the beginning for write (fio -section=write fio-job.txt) and then for verify (fio -section=read fio-job.txt) I got correct results:
were created 4 files kuku.1.0, kuku.2.0, kuku.3.0, kuku.4.0 by write and read verified them.
Is there any possibility to accomplish write at the beginning and then verify process without -section parameter in a command line?
I hoped that stonewall parameter allows to do this. But if I run "fio  fio-job.txt" eight files are created (additional files kuku.5.0 etc.) and read checks them with data corruption error.

[global]
bs=32k
ioengine=windowsaio
numjobs=4
thread
direct=1
size=100m
directory=e:\
random_generator=lfsr
randrepeat=1
filename_format=kuku.$jobnum.$filenum
group_reporting
verify=md5

[write]
rw=randwrite
do_verify=0

[read]
stonewall
rw=randread
do_verify=1
verify_fatal=1

Thanks
Konstantin
