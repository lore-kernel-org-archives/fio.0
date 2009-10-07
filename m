Return-Path: <fio-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:41726 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759969AbZJGUCF (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 7 Oct 2009 16:02:05 -0400
Date: Wed, 7 Oct 2009 22:01:28 +0200
From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: "Fix wrong clock source in mutex" broke fio for me
Message-ID: <20091007200128.GK8703@kernel.dk>
References: <ada1vlfqan3.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ada1vlfqan3.fsf@cisco.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Roland Dreier <rdreier@cisco.com>
Cc: fio@vger.kernel.org

On Tue, Oct 06 2009, Roland Dreier wrote:
> With the latest fio git tree, I get:
> 
>     fio: job startup hung? exiting.
> 
> on startup, and it looks like the latest commit, 69a852f5 ("Fix wrong
> clock source in mutex") breaks things for me (Ubuntu 9.10 beta).  My
> system seems to use CLOCK_REALTIME for pthread_cond_timedwait() by
> default.

Woops, how did I miss that?

> The cleanest solution seems to be to explicitly set which clock to use
> in pthread_cond_timedwait() via pthread_condattr_setclock() when
> initializing the condition variable, although I'm not sure how portable
> this is away from modern Linux (ie do all platforms that fio cares about
> have pthread_condattr_setclock()?).

I did a quick check, and at least newer revisions have it. Hmm I'm a bit
torn on this, perhaps the safer option is just to revert the bad commit.

OK, what I'll do is apply this and then we can worry about older
platforms later. I usually try and test FreeBSD and Solaris
occasionally, to ensure that full releases at least work.

Thanks for reporting and fixing this, Roland!

-- 
Jens Axboe

