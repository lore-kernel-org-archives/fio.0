Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:48783 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848Ab2JVIHH (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 22 Oct 2012 04:07:07 -0400
Message-ID: <5084FE8B.6090608@kernel.dk>
Date: Mon, 22 Oct 2012 10:06:35 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [PATCH 3/4] rdma ioengine improvement
References: <1350702712-5168-1-git-send-email-yufei.ren@stonybrook.edu> <1350702712-5168-4-git-send-email-yufei.ren@stonybrook.edu>
In-Reply-To: <1350702712-5168-4-git-send-email-yufei.ren@stonybrook.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Yufei Ren <yufei.ren@stonybrook.edu>
Cc: fio@vger.kernel.org, Yufei Ren <renyufei83@gmail.com>

On 2012-10-20 05:11, Yufei Ren wrote:
> From: Yufei Ren <renyufei83@gmail.com>

This one needs a bit of explaining. What is the point of using a
re-entrant variant of rand(), if you are using a shared static variable
anyway?

Would it be better to use the fio shipped rand, now we're in there
anyway?

> @@ -790,6 +792,13 @@ static int fio_rdmaio_connect(struct thread_data *td, struct fio_file *f)
>  	/* wait for remote MR info from server side */
>  	rdma_poll_wait(td, IBV_WC_RECV);
>  
> +	/* In SEND/RECV test, iodepth in RECV side is deeper
> +	 * in SEND side. RECV needs more time to construct the
> +	 * buffer blocks, so the server side may need to stop
> +	 * some time before transfer data.
> +	 */
> +	usleep(500000);
> +
>  	return 0;

Hmm?

-- 
Jens Axboe

