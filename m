Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:44298 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460Ab3IFOqn (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 6 Sep 2013 10:46:43 -0400
Message-ID: <5229EACA.7090009@kernel.dk>
Date: Fri, 06 Sep 2013 08:46:34 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [PATCH] Adds verify_only option.
References: <1378437152-11128-1-git-send-email-jcasse@chromium.org>
In-Reply-To: <1378437152-11128-1-git-send-email-jcasse@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Juan Casse <jcasse@chromium.org>
Cc: Grant Grundler <grundler@chromium.org>, fio@vger.kernel.org

On 09/05/2013 09:12 PM, Juan Casse wrote:
> The verify_only option allows to correctly verify the numberio in each
> block header that was written in a previous run of fio.

Comments inline.

> diff --git a/engines/sync.c b/engines/sync.c
> index 1329946..9dbd857 100644
> --- a/engines/sync.c
> +++ b/engines/sync.c
> @@ -125,8 +125,12 @@ static int fio_syncio_queue(struct thread_data *td, struct io_u *io_u)
>  
>  	if (io_u->ddir == DDIR_READ)
>  		ret = read(f->fd, io_u->xfer_buf, io_u->xfer_buflen);
> -	else if (io_u->ddir == DDIR_WRITE)
> -		ret = write(f->fd, io_u->xfer_buf, io_u->xfer_buflen);
> +	else if (io_u->ddir == DDIR_WRITE) {
> +		if (!td->o.verify_only)
> +			ret = write(f->fd, io_u->xfer_buf, io_u->xfer_buflen);
> +		else
> +			ret = io_u->xfer_buflen;
> +	}

Ugh what? This is completely the wrong place to do this. The fact that
you are also doing this:


> +	/*
> +	 * The verify_only option implies that we want to do a verify of the
> +	 * meta data in each block written in a previous run using the
> +	 * same workload. We still need to simulate the workload
> +	 * (without actually writing) in order to compute the numberio that
> +	 * would have been written to the meta section of each block.
> +	 * We revert to the the synchronous io engine because there is already
> +	 * code in place for the synchronous engine to compute the numberio
> +	 * without writing to disk.
> +	 */
> +	if (o->verify_only) {
> +		o->do_verify = 1;
> +		o->verify = VERIFY_META;
> +		strcpy(o->ioengine, "sync");
> +	}

Should be a clear warning sign! You are hard coding the verify type and
the engine, why??

Please take a look at how this is done for the experimental_verify. The
writes are skipped much sooner and generically, there's no need to
enforce any sort of specific IO engine or verify type.

-- 
Jens Axboe

