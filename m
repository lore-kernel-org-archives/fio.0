Return-Path: <fio-owner@vger.kernel.org>
Received: from 87-104-106-3-dynamic-customer.profibernet.dk ([87.104.106.3]:60589
	"EHLO kernel.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753722Ab1H3NpY (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 30 Aug 2011 09:45:24 -0400
Message-ID: <4E5CE96D.3000905@kernel.dk>
Date: Tue, 30 Aug 2011 07:45:17 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [PATCH] Adding userspace_libaio_reap option
References: <1314664153-21134-1-git-send-email-dehrenberg@google.com>
In-Reply-To: <1314664153-21134-1-git-send-email-dehrenberg@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Dan Ehrenberg <dehrenberg@google.com>
Cc: fio@vger.kernel.org

On 2011-08-29 18:29, Dan Ehrenberg wrote:
> When a single thread is reading from a libaio io_context_t object
> in a non-blocking polling manner (that is, with the minimum number
> of events to return being 0), then it is possible to safely read
> events directly from user-space, taking advantage of the fact that
> the io_context_t object is a pointer to memory with a certain layout.
> This patch adds an option, userspace_libaio_reap, which allows
> reading events in this manner when the libaio engine is used.
> 
> You can observe its effect by setting iodepth_batch_complete=0
> and seeing the change in distribution of system/user time based on
> whether this new flag is set. If userspace_libaio_reap=1, then
> busy polling takes place in userspace, and there is a larger amount of
> usr CPU. If userspace_libaio_reap=0 (the default), then there is a
> larger amount of sys CPU from the polling in the kernel.
> 
> Polling from a queue in this manner is several times faster. In my
> testing, it took less than an eighth as much time to execute a
> polling operation in user-space than with the io_getevents syscall.

Good stuff! The libaio side looks good, but I think we should add engine
specific options under the specific engine. With all the
commands/options that fio has, it quickly becomes a bit unwieldy. So,
idea would be to have:

ioengine=libaio:userspace_reap

I'll look into that.

One question on the code:

> +static int user_io_getevents(io_context_t aio_ctx, unsigned int max,
> +			struct io_event *events)
> +{
> +	long i = 0;
> +	unsigned head;
> +	struct aio_ring *ring = (struct aio_ring*)aio_ctx;
> +
> +	while (i < max) {
> +		head = ring->head;
> +
> +		if (head == ring->tail) {
> +			/* There are no more completions */
> +			break;
> +		} else {
> +			/* There is another completion to reap */
> +			events[i] = ring->events[head];
> +    			ring->head = (head + 1) % ring->nr;
> +			i++;
> +		}
> +	}

Don't we need a read barrier here before reading the head/tail?

-- 
Jens Axboe

