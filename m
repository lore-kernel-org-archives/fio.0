Return-Path: <fio-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:57217 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757216AbZIDSxR (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 4 Sep 2009 14:53:17 -0400
Date: Fri, 4 Sep 2009 20:53:19 +0200
From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Proper use of "--verify" switch
Message-ID: <20090904185319.GC18599@kernel.dk>
References: <f3177b9e0909041140nb792fdav610cec98f69c2836@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f3177b9e0909041140nb792fdav610cec98f69c2836@mail.gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Chris Worley <worleys@gmail.com>
Cc: fio@vger.kernel.org

On Fri, Sep 04 2009, Chris Worley wrote:
> Are there example uses, specifically for mixed read/write cases?
> 
> I've found I can do sequential writes followed by sequential reads w/o
> issue, but have errors in other cases.
> 
> Just some usage hints would be nice.

I think the major issue here is that fio can be used to verify a
previously written file, so it'll attach a verify handler to the IO
piece even for the reads in a mixed workload. Not sure how best to
handle that, the below patch will disable that 'feature' if we are doing
a mixed read/write workload. Which probably does make sense, since it's
fairly nonsensical to expect partial read verifies from a previous file
while overwriting other parts of it...

Does it work?

diff --git a/fio.c b/fio.c
index dfd15e0..3a9a3ba 100644
--- a/fio.c
+++ b/fio.c
@@ -606,7 +606,8 @@ static void do_io(struct thread_data *td)
 		 * Add verification end_io handler, if asked to verify
 		 * a previously written file.
 		 */
-		if (td->o.verify != VERIFY_NONE && io_u->ddir == DDIR_READ) {
+		if (td->o.verify != VERIFY_NONE && io_u->ddir == DDIR_READ &&
+		    !td_rw(td)) {
 			if (td->o.verify_async)
 				io_u->end_io = verify_io_u_async;
 			else

-- 
Jens Axboe

