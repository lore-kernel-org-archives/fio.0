Return-Path: <jmoyer@redhat.com>
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH] Adding userspace_libaio_reap option
References: <1314664153-21134-1-git-send-email-dehrenberg@google.com>
Date: Tue, 30 Aug 2011 10:07:11 -0400
In-Reply-To: <1314664153-21134-1-git-send-email-dehrenberg@google.com> (Dan
	Ehrenberg's message of "Mon, 29 Aug 2011 17:29:13 -0700")
Message-ID: <x4962lfkn74.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Dan Ehrenberg <dehrenberg@google.com>
Cc: Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

Dan Ehrenberg <dehrenberg@google.com> writes:

> When a single thread is reading from a libaio io_context_t object
> in a non-blocking polling manner (that is, with the minimum number
> of events to return being 0), then it is possible to safely read
> events directly from user-space, taking advantage of the fact that
> the io_context_t object is a pointer to memory with a certain layout.
> This patch adds an option, userspace_libaio_reap, which allows
> reading events in this manner when the libaio engine is used.

I haven't yet tried to poke holes in your code, but I'm pretty sure I
can find some.  I have patches for the kernel and libaio which allow
user-space reaping of events.  Why don't I dust those off and post them,
and then fio won't have to change at all?  That seems like to proper
approach to solving the problem.

Cheers,
Jeff

