Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:48440 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101Ab2BTJTm (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 20 Feb 2012 04:19:42 -0500
Message-ID: <4F420FD6.10907@kernel.dk>
Date: Mon, 20 Feb 2012 10:18:14 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Something odd with the fio random offset generator & time_based
 runs
References: <CAAUT-yOi26hzpOdzCbSDTS9AE_y96USLK25LVYvfzCFP5skJ4g@mail.gmail.com> <CAAUT-yOd-gnfN-tEC3SY-RcBON5tYqOz6DyRqXfwNyGq71mPgA@mail.gmail.com>
In-Reply-To: <CAAUT-yOd-gnfN-tEC3SY-RcBON5tYqOz6DyRqXfwNyGq71mPgA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Steven Lang <tirea@google.com>
Cc: fio@vger.kernel.org

On 02/18/2012 02:31 AM, Steven Lang wrote:
> Looking into it more, what seems to be going on is that after writing
> td->o.size bytes, a time_based job silently closes all open files,
> resets, and starts over.  Part of the process of resetting involves
> re-seeding all the random numbers.
> 
> It seems like there are other implications to the reset as well.  For
> example, in async ioengines it drains all the remaining IO, which
> results in less throughput.  Potentially latency numbers could be
> effected as well, either positively or negatively.
> 
> Would it make sense, for time_based runs, to not break out of the loop
> in do_io() so the state doesn't get reset?  This would also allow the
> removal of the check in keep_running() for time_based, which would
> then allow "time_based" and "loops" to be used together in a
> meaningful way.
> 
> At first blush, this would probably just be a case of adding "||
> (td->o.time_based)" to the loop condition in do_io(), and that
> certainly addressed the case of random IO whe norandommap I initially
> saw.  But the same performance issues could apply to sequential loads
> and random mapped loads, and just changing the loop condition didn't
> have any effect on that.  There is something else which is determining
> that the end condition is met for sequential loads, read_iolog loads,
> and randommap loads.  (For read_iolog loads, time_based and loops have
> no effect, so I'm not sure the value of changing that.)
> 
> Would it be difficult to change the behavior so only loops= causes
> do_io() to be called repeatedly like that?

I agree that the correct solution would be to NOT jump out of the loop
and just keep going for time_based. As you point out, it might need
another change or two to ensure that we handle every condition. For
things like random map, we do need to clear it when it's full (or close
to), but that need not reset everything.

Do you have any time to hunt this further?

-- 
Jens Axboe

