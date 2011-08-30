Return-Path: <fio-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:12929 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756672Ab1H3VOf (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 30 Aug 2011 17:14:35 -0400
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH] Adding userspace_libaio_reap option
References: <1314664153-21134-1-git-send-email-dehrenberg@google.com>
	<x4962lfkn74.fsf@segfault.boston.devel.redhat.com>
	<CAAK6Zt0uPgY1V1tJihUwKxbjtNVNUqMZu0UDmUtRdJY4k_Lkmw@mail.gmail.com>
	<CAAK6Zt3iVsTS9=YGSJ3dTvY3vSYBygQYR9HeJwh8Zivmkfa7dg@mail.gmail.com>
Date: Tue, 30 Aug 2011 17:14:33 -0400
In-Reply-To: <CAAK6Zt3iVsTS9=YGSJ3dTvY3vSYBygQYR9HeJwh8Zivmkfa7dg@mail.gmail.com>
	(Daniel Ehrenberg's message of "Tue, 30 Aug 2011 10:35:45 -0700")
Message-ID: <x49obz6k3eu.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Daniel Ehrenberg <dehrenberg@google.com>
Cc: fio@vger.kernel.org

Daniel Ehrenberg <dehrenberg@google.com> writes:

> On Tuesday, August 30, 2011, Jeff Moyer <jmoyer@redhat.com> wrote:
>> Dan Ehrenberg <dehrenberg@google.com> writes:
>>
>>> When a single thread is reading from a libaio io_context_t object
>>> in a non-blocking polling manner (that is, with the minimum number
>>> of events to return being 0), then it is possible to safely read
>>> events directly from user-space, taking advantage of the fact that
>>> the io_context_t object is a pointer to memory with a certain layout.
>>> This patch adds an option, userspace_libaio_reap, which allows
>>> reading events in this manner when the libaio engine is used.
>>
>> I haven't yet tried to poke holes in your code, but I'm pretty sure I
>> can find some.  I have patches for the kernel and libaio which allow
>> user-space reaping of events.  Why don't I dust those off and post them,
>> and then fio won't have to change at all?  That seems like to proper
>> approach to solving the problem.
>>
>> Cheers,
>> Jeff
>>
>
> Ken Chen posted some patches which accomplish this in 2007. However, I was a
> little concerned about his lock-free queue structure--it seems like an
> integer overflow might cause events to be lost; on the other hand this is
> very unlikely. Are you talking about Ken's patchset or another one?

I'm talking about another one, since I completely forgot about Ken's
patches.  Thanks for reminding me!

I'm not sure your approach will work on all architectures without kernel
modification.  I think at least a flush_dcache_page may be required.
More importantly, though, I'd like to discourage peeking into the
internals outside of the libaio library.  Doing this makes it really
hard to change things moving forward.

Cheers,
Jeff
