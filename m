Return-Path: <fio-owner@vger.kernel.org>
Received: from g4t0017.houston.hp.com ([15.201.24.20]:44429 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754281AbZHQRdt (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 17 Aug 2009 13:33:49 -0400
Received: from g5t0030.atlanta.hp.com (g5t0030.atlanta.hp.com [16.228.8.142])
	by g4t0017.houston.hp.com (Postfix) with ESMTP id 755D338417
	for <fio@vger.kernel.org>; Mon, 17 Aug 2009 17:33:51 +0000 (UTC)
Subject: Large numbers of devices...
From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Content-Type: text/plain
Date: Mon, 17 Aug 2009 13:33:49 -0400
Message-Id: <1250530429.5341.98.camel@cail>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Before I start diving into the code, has anybody else out there had
problems with 'fio' not being able to scale well with large numbers of
devices (files) being used? I have a system w/ 32-cpus, 256GB RAM, plus
11 dual-ported FC HBAs connected to 44 HP MSA1000 FC controllers. (the
44 MSAs are spread out 4 per FC HBA). I'd like to use 'fio' to gather &
produce scaling results, but I seem to run into inconsistencies once I
get above using 26 or 27 of the 44 MSAs. I have noticed similar things
in the past, but it hasn't been so bothersome. I have a locally crafted
tool (much more limited than 'fio') called 'aiod' that /is/ able to
scale up past 35 or 36 of the MSAs doing what I /believe/ is something
similar. [Once past 35 or 36 devices we run into system issues which
reduce scaling opportunities.]

In any event, an example fio job-file can be found at:

http://free.linux.hp.com/~adb/2009-08-17/044_disk_1_parts.txt

The graph showing the noise in the graph for fio can be found at:

http://free.linux.hp.com/~adb/2009-08-17/fio.png

And the "better" graph w/ aiod can be found at:

http://free.linux.hp.com/~adb/2009-08-17/aiod.png

The test uses between 1 and 4 partitions per LUN exported by each MSA
(each LUN is crafted from 4 physical devices striped together.) You'll
see in the latter graph the continued scaling up through almost 37
devices, and much tighter results after that (even with the tail-off at
the end above 40 devices.)

Anyways, if there is something I'm missing in the fio job-file to help
it scale better let me know, otherwise I'll go through the aiod code to
see if there were any applicable scaling improvements there than can be
applied to fio...

Alan D. Brunelle
Hewlett-Packard

