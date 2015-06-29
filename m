Return-Path: <fio-owner@vger.kernel.org>
Received: from muon.bluestop.org ([204.109.60.166]:27512 "EHLO
	muon.cran.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159AbbF2XVQ (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 29 Jun 2015 19:21:16 -0400
Received: from muon.bluestop.org (localhost [127.0.0.1])
	by muon.cran.org.uk (Postfix) with ESMTP id EFA2927334A
	for <fio@vger.kernel.org>; Mon, 29 Jun 2015 17:21:15 -0600 (MDT)
Received: from muon.cran.org.uk ([127.0.0.1])
	by muon.bluestop.org (muon.bluestop.org [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id R7aKHgSEWz_Q for <fio@vger.kernel.org>;
	Mon, 29 Jun 2015 17:21:15 -0600 (MDT)
Received: from [10.50.3.54] (63-158-132-10.dia.static.qwest.net [63.158.132.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by muon.cran.org.uk (Postfix) with ESMTPSA
	for <fio@vger.kernel.org>; Mon, 29 Jun 2015 17:21:15 -0600 (MDT)
Message-ID: <5591D2EB.8050309@cran.org.uk>
Date: Mon, 29 Jun 2015 17:21:15 -0600
From: Bruce Cran <bruce@cran.org.uk>
MIME-Version: 1.0
Subject: Percentage/ETA progress indicator faulty with examples/tiobench-example.fio
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

On Linux, using the latest fio sources, "fio 
examples/tiobench-example.fio" results in the progress indicator 
(percentage and ETA) displaying odd values.  Percentage rises to about 
70% before dropping to 20%, getting to 25% and then the test finishes.  
The ETA starts out about 4 minutes, falls to 1m and then jumps to 12.

$ ./fio examples/tiobench-example.fio
[snip]
f4: Laying out IO file(s) (1 file(s) / 512MB)
Jobs: 4 (f=4): [_(12),r(4)] [25.1% done] [887KB/0KB/0KB /s] [221/0/0 
iops] [eta 12m:00s]
f1: (groupid=0, jobs=1): err= 0: pid=9730: Mon Jun 29 17:17:01 2015
   write: io=388340KB, bw=6453.7KB/s, iops=1613, runt= 60174msec
     clat (usec): min=144, max=704183, avg=616.69, stdev=7110.74
      lat (usec): min=145, max=704184, avg=617.10, stdev=7110.74
     clat percentiles (usec):
      |  1.00th=[  354],  5.00th=[  378], 10.00th=[  394], 20.00th=[ 410],
      | 30.00th=[  422], 40.00th=[  434], 50.00th=[  442], 60.00th=[ 450],
      | 70.00th=[  466], 80.00th=[  478], 90.00th=[  506], 95.00th=[ 564],
      | 99.00th=[ 1416], 99.50th=[ 1448], 99.90th=[24960], 99.95th=[56576],
      | 99.99th=[544768]
     bw (KB  /s): min= 2067, max= 9432, per=26.50%, avg=6839.64, 
stdev=1755.81
     lat (usec) : 250=0.01%, 500=88.36%, 750=7.53%, 1000=0.02%
     lat (msec) : 2=3.91%, 4=0.03%, 10=0.01%, 20=0.01%, 50=0.06%
     lat (msec) : 100=0.03%, 250=0.01%, 750=0.01%
[...]

-- 
Bruce
