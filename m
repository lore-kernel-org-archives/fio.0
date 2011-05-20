Return-Path: <fio-owner@vger.kernel.org>
Received: from mtagate7.uk.ibm.com ([194.196.100.167]:33712 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933664Ab1ETOmo (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 20 May 2011 10:42:44 -0400
Received: from d06nrmr1507.portsmouth.uk.ibm.com (d06nrmr1507.portsmouth.uk.ibm.com [9.149.38.233])
	by mtagate7.uk.ibm.com (8.13.1/8.13.1) with ESMTP id p4KEggU7002822
	for <fio@vger.kernel.org>; Fri, 20 May 2011 14:42:42 GMT
Received: from d06av01.portsmouth.uk.ibm.com (d06av01.portsmouth.uk.ibm.com [9.149.37.212])
	by d06nrmr1507.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p4KEgg0a2302014
	for <fio@vger.kernel.org>; Fri, 20 May 2011 15:42:42 +0100
Received: from d06av01.portsmouth.uk.ibm.com (loopback [127.0.0.1])
	by d06av01.portsmouth.uk.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p4KEgflb029614
	for <fio@vger.kernel.org>; Fri, 20 May 2011 08:42:41 -0600
Received: from d12mc302.megacenter.de.ibm.com (d12mc302.megacenter.de.ibm.com [9.149.170.82])
	by d06av01.portsmouth.uk.ibm.com (8.14.4/8.13.1/NCO v10.0 AVin) with ESMTP id p4KEgfWc029536
	for <fio@vger.kernel.org>; Fri, 20 May 2011 08:42:41 -0600
Subject: fadvise and small random reads
Message-ID: <OFEB35B0EC.DA0CC6A8-ONC1257896.004DEE8A-C1257896.0050CE26@ch.ibm.com>
From: Animesh K Trivedi1 <ATR@zurich.ibm.com>
Date: Fri, 20 May 2011 16:42:36 +0200
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org


Hi all,

I'm running the random read test on a 64MB file with 4K block size. The
file is small enough to fit in the buffer cache of the system (8 GB DRAM).
But default fadvise calls to OS pass two flags (POSIX_FADV_DONTNEED, and
POSIX_FADV_RANDOM). With these two settings OS does not try to cache any
reads and they all go to the disk. I get ~280 IOPS with 99% disk
utilization. And that is fine. But even when I turn fadvise_hint=0, it
shows the similar behaviour. Upon further investigation I noticed that
irrespective of settings, POSIX_FADV_DONTNEED is always passed to OS
(filesetup.c, line 361). Should not it also be restricted when
--fadvise_hint is set to zero ?

If I don't pass any hint to OS, then after stabilizing whole  file is
cached in the buffer and IOPS reaches upto 700+K (which I was expecting for
small file sizes). Here is the snipped sample output :

fio --fadvise_hint=0 --ioengine=psync --direct=0 --rw=randread --bs=4K
--size=64M --numjob=1 --runtime=60 --time_based --group_reporting
--name=file
file: (g=0): rw=randread, bs=4K-4K/4K-4K, ioengine=psync, iodepth=1
fio 1.54
Starting 1 process
Jobs: 1 (f=1): [r] [100.0% done] [3043M/0K /s] [761K/0  iops] [eta 00m:00s]
file: (groupid=0, jobs=1): err= 0: pid=3820
  read : io=121156MB, bw=2019.3MB/s, iops=516931 , runt= 60000msec
......
Disk stats (read/write):
  sda: ios=7742/82, merge=0/4060, ticks=34608/9112, in_queue=43712,
util=32.27%

Am I missing something ?

cheers,
--
Animesh

PS ~  I am not on the list so please cc me in the reply.

