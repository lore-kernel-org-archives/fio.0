Return-Path: <fio-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:35205 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750743AbZDUTPq (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 21 Apr 2009 15:15:46 -0400
Date: Tue, 21 Apr 2009 21:15:45 +0200
From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Recent changes
Message-ID: <20090421191545.GO4593@kernel.dk>
References: <20090421074720.GC4593@kernel.dk> <309802.6143.qm@web63808.mail.re1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <309802.6143.qm@web63808.mail.re1.yahoo.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Girish Satihal <girish.satihal@yahoo.com>
Cc: fio@vger.kernel.org

On Tue, Apr 21 2009, Girish Satihal wrote:
> Hi Jens,
> I guess I did not understand your question for which I am very sorry.

Don't apologize for that. But if there's something I write you don't
understand, do just ask for an explanation.

> As per my understanding I have sent you the job file which was
> input file to fio for the performance testing.  As only the problem
> with Seqential Writes, I have cut down the job file to only Write
> parameters where the issue is being seen. The problem is seen with all
> block size and IO depths of Sequential Writes.  Please let me know
> if this would help you or still you arelooking for anything else.

So my current question is why you are mentioning ext3? The test case you
provided is reading and writing directly to the CCISS device, not a file
inside a file system hosted on that device.

Also, please try a make clean && make && make install in your fio
directory. Sometimes things get hosed when updates are pulled, which may
explain why yours is acting up.

-- 
Jens Axboe

