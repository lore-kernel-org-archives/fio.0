Return-Path: <fio-owner@vger.kernel.org>
Received: from mail.thomas-krenn.com ([217.7.54.186]:50744 "EHLO
	mail.thomas-krenn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752544Ab2GRR5E (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 18 Jul 2012 13:57:04 -0400
Received: from iris.tks.local (iris.tks.local [192.168.10.63])
	by mail.thomas-krenn.com (Postfix) with ESMTP id 9EAE9DF88A
	for <fio@vger.kernel.org>; Wed, 18 Jul 2012 19:57:02 +0200 (CEST)
Received: from localhost (ate.tks.local [192.168.10.78])
	by iris.tks.local (Postfix) with ESMTP id 50C3E3FA80
	for <fio@vger.kernel.org>; Wed, 18 Jul 2012 19:57:02 +0200 (CEST)
Received: from mail.thomas-krenn.com ([127.0.0.1])
	by localhost (ate.TKS.local [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7oWOkgb4utBm for <fio@vger.kernel.org>;
	Wed, 18 Jul 2012 19:56:52 +0200 (CEST)
Received: from [10.0.0.6] (178-190-166-190.adsl.highway.telekom.at [178.190.166.190])
	by mail.thomas-krenn.com (Postfix) with ESMTPSA
	for <fio@vger.kernel.org>; Wed, 18 Jul 2012 19:56:52 +0200 (CEST)
Message-ID: <5006F8E4.7090806@thomas-krenn.com>
Date: Wed, 18 Jul 2012 19:56:52 +0200
From: =?ISO-8859-1?Q?Georg_Sch=F6nberger?= 
	<gschoenberger@thomas-krenn.com>
MIME-Version: 1.0
Subject: Problem using --offset: fix call to fadvise64
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hello everybody,

I don't know if it is a bug but my usage of the offset parameter seems
not to work correctly. In detail the offset call works, but at a certain
size the call to "fadvise64" is no longer correct:
Here is the working offset:
# strace -o fio.out.working -f fio --rw=read --name=usb-stick --bs=1024k
--direct=1 --filename=/dev/sdb1 --runtime=10 --time_based --offset=1024
usb-stick: (g=0): rw=read, bs=1M-1M/1M-1M, ioengine=sync, iodepth=1
fio-2.0.8-2-gd3987
Starting 1 process
Jobs: 1 (f=1): [R] [100.0% done] [19320K/0K /s] [18 /0  iops] [eta 00m:00s]
usb-stick: (groupid=0, jobs=1): err= 0: pid=20570
  read : io=195584KB, bw=19492KB/s, iops=19 , runt= 10034msec
[...]
# grep fadvise fio.out.working
20570 fadvise64(3, 1024, 20970496, POSIX_FADV_SEQUENTIAL) = 0

With an offset more than half of the device, the overall device size is
no longer correct (should be 20970496 again):
# strace -o fio.out -f fio --rw=read --name=usb-stick --bs=1024k
--direct=1 --filename=/dev/sdb1 --runtime=10 --time_based --offset=10485760
usb-stick: (g=0): rw=read, bs=1M-1M/1M-1M, ioengine=sync, iodepth=1
fio-2.0.8-2-gd3987
Starting 1 process
Run status group 0 (all jobs):
Disk stats (read/write):
  sdb: ios=0/0, merge=0/0, ticks=0/0, in_queue=0, util=0.00%
# grep fadvise fio.out
20848 fadvise64(3, 10485760, 10485760, POSIX_FADV_SEQUENTIAL) = 0

As the call to fadvise64 is not correct (instead of 10485760 as the 3rd
parameter there should be 20970496) the job does not start.
I am using the latest fio version:
# fio --version
fio-2.0.8-9-gfb9f0

-Georg
