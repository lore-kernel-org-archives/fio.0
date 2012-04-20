Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:48260 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757010Ab2DTRWy (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 20 Apr 2012 13:22:54 -0400
Message-ID: <4F919B6B.1050607@kernel.dk>
Date: Fri, 20 Apr 2012 19:22:51 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: segfault runninng fio against 2048 jobs
References: <0FEAAA2D70C89D49A62173478A6C4A5D02DECC2A@XYUS-EX22.xyus.xyratex.com> <4F8E6BFD.10408@kernel.dk> <0FEAAA2D70C89D49A62173478A6C4A5D02DECCB6@XYUS-EX22.xyus.xyratex.com> <4F8F0A62.80101@kernel.dk> <0FEAAA2D70C89D49A62173478A6C4A5D02DECCD7@XYUS-EX22.xyus.xyratex.com> <4F9104F9.2060308@kernel.dk> <0FEAAA2D70C89D49A62173478A6C4A5D02DECDC6@XYUS-EX22.xyus.xyratex.com> <4F917240.6030003@kernel.dk> <CAAUT-yMY-xK8HRYdN7Fe8KOuqqt2LyDp7OAX43-mikpU055rhQ@mail.gmail.com>
In-Reply-To: <CAAUT-yMY-xK8HRYdN7Fe8KOuqqt2LyDp7OAX43-mikpU055rhQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Steven Lang <tirea@google.com>
Cc: fio@vger.kernel.org

On 2012-04-20 18:22, Steven Lang wrote:
> It seems like a lot of what is in the thread_data structure does not
> need to be in shared memory; the configuration information is static
> (And in fact some of it is just pointers into process memory) and much
> of it is just used for the running job, such as anything referencing
> files or io_u.  If instead of the whole structure, just necessarily
> shared parts were put in the shared segment, even OSs with limited
> shared segment sizes could better make use of shared memory and run
> more jobs.
> 
> Not to mention that any job which runs in a thread rather than a
> process doesn't need to be in shared memory at all.

That is completely true, but that would require a much more invasive
change. Given that fio isn't _that_ heavy on the shm side (14KB per
process), my lazy side just thought that it would be easier just to have
a few segments for the unlikely cases where somebody did want to run
more than 2000 processes.

The options are around ~13% of the thread_data, so while moving just
that would be a bit easier (and mechanical), it would not be worth it
alone.

And yes, it's not needed for threads. The threads don't attach to it as
it is, so if you only run threads, it need not even be set up.

-- 
Jens Axboe

