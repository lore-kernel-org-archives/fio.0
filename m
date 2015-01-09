Return-Path: <fio-owner@vger.kernel.org>
Received: from g4t3426.houston.hp.com ([15.201.208.54]:54653 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752795AbbAIWvE convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Fri, 9 Jan 2015 17:51:04 -0500
Received: from G9W0364.americas.hpqcorp.net (g9w0364.houston.hp.com [16.216.193.45])
	(using TLSv1 with cipher AES128-SHA (128/128 bits))
	(No client certificate requested)
	by g4t3426.houston.hp.com (Postfix) with ESMTPS id 2993A117
	for <fio@vger.kernel.org>; Fri,  9 Jan 2015 22:51:03 +0000 (UTC)
From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: REPORT: FIO random read performance degradation without
 "norandommap" option
Date: Fri, 9 Jan 2015 22:49:08 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B40295A72F566@G9W0745.americas.hpqcorp.net>
References: <D0D596A1.FF42%andrey.o.kudryavtsev@intel.com>
In-Reply-To: <D0D596A1.FF42%andrey.o.kudryavtsev@intel.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Kudryavtsev, Andrey O" <andrey.o.kudryavtsev@intel.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>


> -----Original Message-----
> From: fio-owner@vger.kernel.org [mailto:fio-owner@vger.kernel.org] On
> Behalf Of Kudryavtsev, Andrey O
> Sent: Friday, 09 January, 2015 4:42 PM
> To: fio@vger.kernel.org
> Subject: REPORT: FIO random read performance degradation without
> "norandommap" option
> 
> Colleagues,
> I executed 2-hour runs of 4KRR to understand performance changes across
> the time on the specific very fast NVMe SSD with 1.6TB capacity.
> I noticed the side effect of "norandommap" parameter performing full span
> test on the block device.
> Here is the example of the result with random map (I.e. without
> "norandommap" option) within 120 minutes windows.
> [cid:E6872B64-35D1-4447-A0CF-32E6411D9BDB]
> (IOPS in blue)
> 
> As soon as I enabled "norandommap" option the curve has changed into the
> straight line as expected.

It takes resources to maintain the random map table.  I always run with
norandommap unless using verify, which has to remember which ones have
been accessed.

Here's a description I gave someone a while back:
With a huge device (e.g., 5.8 TB from RAID-0 made from 16 SSDs),
if you do not use "norandommap", fio allocates a bitmap for all
the disk blocks to keep track of where it has read or written.
It uses this to avoid accessing the same blocks until all
the blocks have been accessed, and to know which blocks it
needs to verify if verify=<something> is enabled.

For 5.8 TB, that is 1562714136 = 1.5 GB.  Not many of those
huge allocations work, so it 
* hangs the system for a while
* generates estimates like
	[eta 1158050440d:06h:50m:22s]
* and eventually reports
	smalloc: failed adding pool
	fio: failed allocating random map. If running a large number of jobs, try the 'norandommap' option or set 'softrandommap'. Or give a larger --alloc-size to fio.

fio continues to run after that; I think it verifies only
the devices for which the allocation worked and ignores
the rest.


---
Rob Elliott    HP Server Storage


