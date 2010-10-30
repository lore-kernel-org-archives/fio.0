Return-Path: <fio-owner@vger.kernel.org>
Received: from 85-18-250-96.ip.fastwebnet.it ([85.18.250.96]:36479 "EHLO
	mail.xteklabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753592Ab0J3NCP (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 30 Oct 2010 09:02:15 -0400
Received: from localhost (unknown [127.0.0.1])
	by mail.xteklabs.com (Postfix) with ESMTP id AD40A4058
	for <fio@vger.kernel.org>; Sat, 30 Oct 2010 12:53:28 +0000 (UTC)
Received: from mail.xteklabs.com ([127.0.0.1])
	by localhost (tesla.xteklabs.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KLY3S2F+vg6N for <fio@vger.kernel.org>;
	Sat, 30 Oct 2010 14:53:22 +0200 (CEST)
Received: from [10.0.200.200] (unknown [78.134.13.187])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.xteklabs.com (Postfix) with ESMTP id 5E36B4017
	for <fio@vger.kernel.org>; Sat, 30 Oct 2010 14:53:22 +0200 (CEST)
Message-ID: <4CCC1540.6090405@xmerlin.org>
Date: Sat, 30 Oct 2010 14:53:20 +0200
From: Christian Zoffoli <czoffoli@xmerlin.org>
MIME-Version: 1.0
Subject: fio: first direct IO errored
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi to all,
I'm testing a storage (14x300GB) with different RAID levels, volume
stripe sizes and different blocksizes and numjobs in fio ...but I've
found a problem testing it with disks in RAID6 configuration.

here is the command line I've used

-----
fio --filename=/dev/dm-0  --direct=1 --group_reporting  --rw=read
--bs=1k --numjobs=1 --runtime=60  --name="read-bs512-job1"
-----

and here is the error:

-----
read-bs512-job1: (g=0): rw=read, bs=1K-1K/1K-1K, ioengine=sync, iodepth=1
Starting 1 process
fio: first direct IO errored. File system may not support direct IO, or
iomem_align= is bad.
fio: pid=4898, err=22/file:engines/sync.c:62, func=xfer, error=Invalid
argument

read-bs512-job1: (groupid=0, jobs=1): err=22 (file:engines/sync.c:62,
func=xfer, error=Invalid argument): pid=4898
  cpu          : usr=0.00%, sys=0.00%, ctx=0, majf=0, minf=50
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%,
>=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%,
>=64=0.0%
     complete  : 0=50.0%, 4=50.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%,
>=64=0.0%
     issued r/w/d: total=1/0/0, short=0/0/0



Run status group 0 (all jobs):

Disk stats (read/write):
  dm-0: ios=0/0, merge=0/0, ticks=0/0, in_queue=0, util=-nan%,
aggrios=0/0, aggrmerge=0/0, aggrticks=0/0, aggrin_queue=0, aggrutil=0.00%
    sdb: ios=0/0, merge=0/0, ticks=0/0, in_queue=0, util=0.00%
    sdd: ios=0/0, merge=0/0, ticks=0/0, in_queue=0, util=0.00%
    sdc: ios=0/0, merge=0/0, ticks=0/0, in_queue=0, util=0.00%
    sde: ios=0/0, merge=0/0, ticks=0/0, in_queue=0, util=0.00

-----


testing the same volume with RAID10 works as expected.

Is it related to the size of the volume?
In RAID6 is 3.3TB and 2.1TB in RAID10.

I've tried also with --norandommap but without success.

and I've not understood what I have to put in iomem_align= to fix the
"alignment" problem.


Best regards,
Christian
-- 
Christian Zoffoli (XMerlin)

You never change things by fighting the existing reality. To change
something, build a new model that makes the existing model obsolete."
-- R. Buckminster Fuller
