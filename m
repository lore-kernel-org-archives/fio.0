Return-Path: <fio-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:55570 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751195AbZHSJDQ (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 19 Aug 2009 05:03:16 -0400
Date: Wed, 19 Aug 2009 11:03:17 +0200
From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Large numbers of devices...
Message-ID: <20090819090317.GW12579@kernel.dk>
References: <1250530429.5341.98.camel@cail>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1250530429.5341.98.camel@cail>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Cc: fio@vger.kernel.org

On Mon, Aug 17 2009, Alan D. Brunelle wrote:
> Before I start diving into the code, has anybody else out there had
> problems with 'fio' not being able to scale well with large numbers of
> devices (files) being used? I have a system w/ 32-cpus, 256GB RAM, plus
> 11 dual-ported FC HBAs connected to 44 HP MSA1000 FC controllers. (the
> 44 MSAs are spread out 4 per FC HBA). I'd like to use 'fio' to gather &
> produce scaling results, but I seem to run into inconsistencies once I
> get above using 26 or 27 of the 44 MSAs. I have noticed similar things
> in the past, but it hasn't been so bothersome. I have a locally crafted
> tool (much more limited than 'fio') called 'aiod' that /is/ able to
> scale up past 35 or 36 of the MSAs doing what I /believe/ is something
> similar. [Once past 35 or 36 devices we run into system issues which
> reduce scaling opportunities.]
> 
> In any event, an example fio job-file can be found at:
> 
> http://free.linux.hp.com/~adb/2009-08-17/044_disk_1_parts.txt
> 
> The graph showing the noise in the graph for fio can be found at:
> 
> http://free.linux.hp.com/~adb/2009-08-17/fio.png
> 
> And the "better" graph w/ aiod can be found at:
> 
> http://free.linux.hp.com/~adb/2009-08-17/aiod.png
> 
> The test uses between 1 and 4 partitions per LUN exported by each MSA
> (each LUN is crafted from 4 physical devices striped together.) You'll
> see in the latter graph the continued scaling up through almost 37
> devices, and much tighter results after that (even with the tail-off at
> the end above 40 devices.)
> 
> Anyways, if there is something I'm missing in the fio job-file to help
> it scale better let me know, otherwise I'll go through the aiod code to
> see if there were any applicable scaling improvements there than can be
> applied to fio...

Alan, I haven't run with that many files, so it's indeed possible that
there's an inherent limitiation in the file selection in fio. It's not
my best code, that part... If you have the time and inclination to jump
in there and find out what is going on, then that would be great!

-- 
Jens Axboe

