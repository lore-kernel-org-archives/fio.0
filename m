Return-Path: <fio-owner@vger.kernel.org>
Received: from mail.thomas-krenn.com ([217.7.54.186]:38252 "EHLO
	mail.thomas-krenn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753922Ab2FAJKK (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 1 Jun 2012 05:10:10 -0400
Received: from iris.tks.local (iris.tks.local [192.168.10.63])
	by mail.thomas-krenn.com (Postfix) with ESMTP id 00156BD97A
	for <fio@vger.kernel.org>; Fri,  1 Jun 2012 11:10:09 +0200 (CEST)
Received: from localhost (ate.tks.local [192.168.10.78])
	by iris.tks.local (Postfix) with ESMTP id A7A2D3FA63
	for <fio@vger.kernel.org>; Fri,  1 Jun 2012 11:10:08 +0200 (CEST)
Received: from mail.thomas-krenn.com ([127.0.0.1])
	by localhost (ate.TKS.local [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id AuT3ZZ2ziMil for <fio@vger.kernel.org>;
	Fri,  1 Jun 2012 11:09:59 +0200 (CEST)
Received: from [192.168.102.17] (unknown [91.223.201.22])
	by mail.thomas-krenn.com (Postfix) with ESMTPSA
	for <fio@vger.kernel.org>; Fri,  1 Jun 2012 11:09:59 +0200 (CEST)
Message-ID: <4FC886E6.4000204@thomas-krenn.com>
Date: Fri, 01 Jun 2012 11:09:58 +0200
From: =?ISO-8859-15?Q?Georg_Sch=F6nberger?= 
	<gschoenberger@thomas-krenn.com>
MIME-Version: 1.0
Subject: Output file and async example
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hello out there,

is there a way to specify a separate output file for each job in a job file?
I know how to do that on the command line:
:~$ fio --name= test --rw=read --size=10M --bs=1M --output=test-read
In a job file this is not working:
[global]
size=${SIZE}
numjobs=${NUMJOBS}

[seq]
output=seq-test
rw=read
bs=1M

:~$ SIZE=10M NUMJOBS=1 fio fio.jobs
Bad option <output=seq-test>
fio: job seq dropped

The second question is about an example in the HOWTO file:
[...]
Let's look at an example that has a number of processes writing randomly
to files.

; -- start job file --
[random-writers]
ioengine=libaio
iodepth=4
rw=randwrite
bs=32k
direct=0
size=64m
numjobs=4

; -- end job file --
[...]
Shouldn't the direct option been changed to "direct=1" as buffered I/O
is no async (at least with Linux)?

-Georg


