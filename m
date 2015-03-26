Return-Path: <fio-owner@vger.kernel.org>
Received: from [68.232.142.33] ([68.232.142.33]:13335 "EHLO
	esa1.cray.iphmx.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751900AbbCZWgr convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Thu, 26 Mar 2015 18:36:47 -0400
From: Andy Moe <moea@cray.com>
Subject: FIO still returning 0 and writing file after bogus arguments
Date: Thu, 26 Mar 2015 22:20:06 +0000
Message-ID: <C0788AB690B48C4C8D95FA764A79D177240EE862@CFWEX01.americas.cray.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

### Description:
FIO still seems to be returning zero and writing a file after bogus arguments have been provided.  In my particular case, it's returning zero when I try to write data to a file with the 'sg' engine.

### Environment:
CentOS release 6.4 (Final)
Linux iosr80-0.us.cray.com 2.6.32-358.el6.x86_64 #1 SMP Fri Feb 22 00:31:26 UTC 2013 x86_64 x86_64 x86_64 GNU/Linux

### FIO version:
fio-2.2.6-15-g3765

### How to reproduce:
Here is output demonstrating what I'm finding.

[moea@iosr80-0 dev-tests]$ ls -l | grep outfile0
[moea@iosr80-0 dev-tests]$ fio --filename outfile0 --rw=readwrite --ioengine=sg --blocksize=8m --size=128m --name=job0
job0: (g=0): rw=rw, bs=8M-8M/8M-8M/8M-8M, ioengine=sg, iodepth=1
fio-2.2.6-15-g3765
Starting 1 process
job0: Laying out IO file(s) (1 file(s) / 128MB)
ioengine sg only works on block devices


Run status group 0 (all jobs):

Disk stats (read/write):
    dm-3: ios=0/0, merge=0/0, ticks=0/0, in_queue=0, util=0.00%, aggrios=0/0, aggrmerge=0/0, aggrticks=0/0, aggrin_queue=0, aggrutil=0.00%
  sda: ios=0/0, merge=0/0, ticks=0/0, in_queue=0, util=0.00%
[moea@iosr80-0 dev-tests]$ echo $?
0
[moea@iosr80-0 dev-tests]$ ls -l outfile0 
-rw-r--r--. 1 moea moea 134217728 Mar 26 17:06 outfile0

========================
Andrew Moe
I/O Device Test Engineer
Cray, Inc.
Saint Paul, MN
(phone) 651-605-8870
========================


