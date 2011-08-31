Return-Path: <fio-owner@vger.kernel.org>
Received: from 87-104-106-3-dynamic-customer.profibernet.dk ([87.104.106.3]:37858
	"EHLO kernel.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754482Ab1HaA5x (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 30 Aug 2011 20:57:53 -0400
Message-ID: <4E5D870B.8050108@kernel.dk>
Date: Tue, 30 Aug 2011 18:57:47 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [PATCH v2] Adding userspace_libaio_reap option
References: <1314751823-17972-1-git-send-email-dehrenberg@google.com>
In-Reply-To: <1314751823-17972-1-git-send-email-dehrenberg@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Dan Ehrenberg <dehrenberg@google.com>
Cc: fio@vger.kernel.org

On 2011-08-30 18:50, Dan Ehrenberg wrote:
> @@ -66,7 +107,16 @@ static int fio_libaio_getevents(struct thread_data *td, unsigned int min,
>  	int r, events = 0;
>  
>  	do {
> -		r = io_getevents(ld->aio_ctx, actual_min, max, ld->aio_events + events, t);
> +		if (td->o.userspace_libaio_reap == 1
> +		    && actual_min == 0
> +		    && ((struct aio_ring *)(ld->aio_ctx))->magic
> +				== AIO_RING_MAGIC) {
> +			r = user_io_getevents(ld->aio_ctx, max,
> +				ld->aio_events + events);
> +		} else {
> +			r = io_getevents(ld->aio_ctx, actual_min,
> +				max, ld->aio_events + events, t);
> +		}

One question here - why depend on actual_min == 0? The check is
practically free, would not hurt to do the user_io_getevents() first and
punt to io_getevents() afterwards if need be.

-- 
Jens Axboe

