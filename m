Return-Path: <fio-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:39252 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756588Ab1GKGc7 (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 11 Jul 2011 02:32:59 -0400
Message-ID: <4E1A9915.2030000@fusionio.com>
Date: Mon, 11 Jul 2011 08:32:53 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
Subject: Re: IO engine flags: FIO_RAWIO vs FIO_MEMALIGN
References: <CAAUT-yO47O=7fqVybxTzyra0RL0i_+q5vtyTj8KSd5RPvNZZ1Q@mail.gmail.com>
In-Reply-To: <CAAUT-yO47O=7fqVybxTzyra0RL0i_+q5vtyTj8KSd5RPvNZZ1Q@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Steven Lang <tirea@google.com>
Cc: fio@vger.kernel.org

On 2011-07-02 03:11, Steven Lang wrote:
> Hello,
> 
> What is the intended difference between these two flags?  The former
> seems to carry some specific semantic meaning while the latter seems
> like it is merely a statement of requirement.  However, within the
> code they seem to be used synonymously, to the point that if an IO
> engine uses FIO_RAWIO and not FIO_MEMALIGN it would potentially crash.
> 
> From memory.c:196
>         if (td->o.odirect || td->o.mem_align ||
>             (td->io_ops->flags & FIO_MEMALIGN)) {
>                 total_mem += page_mask;
>                 if (td->o.mem_align && td->o.mem_align > page_size)
>                         total_mem += td->o.mem_align - page_size;
>         }
> 
> From fio.c:830
>         if (td->o.odirect || td->o.mem_align ||
>             (td->io_ops->flags & FIO_RAWIO))
>                 p = PAGE_ALIGN(td->orig_buffer) + td->o.mem_align;
> 
> These two pieces of code seem like they are a pair that should always
> execute together, yet they have slightly different conditions.  The
> result seems like if FIO_RAWIO is used without FIO_MEMALIGN, it will
> try to page align the buffer (Which of course involves just padding it
> to the next alignment) without the actual memory available to do so,
> resulting in the IO buffer overwriting other parts of the heap.
> 
> If this is changed one way or the other, however, it would result in
> an unused flag.  The condition in memory.c is the only place
> FIO_MEMALIGN appears, and FIO_RAWIO only makes two other
> appearances...
> 
> From init.c:320
>         if (o->bs_unaligned && (o->odirect || td->io_ops->flags & FIO_RAWIO))
>                 log_err("fio: bs_unaligned may not work with raw io\n");
> From init.c:585
>         if (td->o.odirect)
>                 td->io_ops->flags |= FIO_RAWIO;
> 
> The former doesn't actually do anything but print a message and run
> anyway (And should probably use the same form of the flag as the other
> two anyway), and the latter is redundant since the same check for
> FIO_RAWIO/FIO_MEMALIGN also checks for o.direct.

Sorry for missing this email. Yes, the two flags are a bit of a mix. I
think what used to be the case was that there used to be other
differences. But your analysis looks correct, FIO_RAWIO without MEMALIGN
would be buggy at this point.

Feel free to send a patch to unify and cleanup those flags.

-- 
Jens Axboe

