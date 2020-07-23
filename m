Return-Path: <adobriyan@gmail.com>
Return-Path: <adobriyan@gmail.com>
Date: Thu, 23 Jul 2020 17:32:45 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH 1/4] Add Zone Append command support for NVMe Zoned
 Namespaces (ZNS)
Message-ID: <20200723143245.GA1866332@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
To: krish.reddy@samsung.com
Cc: damien.lemoal@wdc.com, axboe@kernel.dk, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

> +.. option:: zone_append=bool

This forces 1 thread into either write or append.
I'm 99% sure this what everyone will benchmark, but still...

We're using different scheme, but it 100% rewrites I/O generation path. :-\

> +.BI zone_append
> +For \fBzonemode\fR =zbd and for \fBrw\fR=write or \fBrw\fR=randwrite, if
> +zone_append is enabled, the io_u points to the starting offset of a zone. On
> +successful completion the multiple of sectors relative to the zone's starting
> +offset is returned.

io_u->offset is a techicality, no user cares about. This should be rewritten in
user friendly language like "issue Zone Append command instead of Write".

I also think that io_u->offset should have normal value before ioengine
for debugging and detecting reordering.

>	struct io_u {
>	 	/*
>		 * for zone append this is the start offset of the zone.
>		 */
>		unsigned long long zone_start_offset;

> +	if (td->o.zone_append) {
> +		pthread_mutex_lock(&z->mutex);
> +		if (z->pending_ios > 0) {
> +			z->pending_ios--;
> +			/*
> +			 * Other threads may be waiting for pending I/O's to
> +			 * complete for this zone. Notify them.
> +			 */
> +			if (!z->pending_ios)
> +				pthread_cond_broadcast(&z->reset_cond);
> +		}
> +	}

You can do

	if (--z->pending_ios == 0) {
		pthread_cond_broadcast(&z->reset_cond);
	}

This is probably wrong (see spurious wakeups):

> +				 * Wait for the pending requests to be completed
> +				 * else we are ok to reset this zone.
> +				 */
> +				if (zb->pending_ios) {
> +					pthread_cond_wait(&zb->reset_cond, &zb->mutex);
> +					goto proceed;
> +				}

