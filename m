Return-Path: <fio-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:43866 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752209AbZD1Fvm (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 28 Apr 2009 01:51:42 -0400
Date: Tue, 28 Apr 2009 07:51:42 +0200
From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Populating the io_u before the I/O
Message-ID: <20090428055142.GG4593@kernel.dk>
References: <66dfd3fe0904271558s6b8c3faamdc6ebb7f8fb95054@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <66dfd3fe0904271558s6b8c3faamdc6ebb7f8fb95054@mail.gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Radha Ramachandran <radha@google.com>
Cc: fio@vger.kernel.org

On Mon, Apr 27 2009, Radha Ramachandran wrote:
> Hi,
> I was seeing some performance drop during the read verification phase
> of a test, and from the code in io_u.c in get_io_u function, we
> prepare/populate the buffer in the io_u structure based on the verify
> patterns/options.
> This makes sense when we are doing writes, but I dont understand why
> we do this for the read phase when this data is going to be
> overwritten anyways(and in case of truncated reads, we do modify the
> buf_len).
> So based on that I changed the code to populate the buffer(io_u->buf)
> only if its a write with verify enabled.
> This works for my tests, but I do not know if there was a reason why
> this was populated for reads as well to begin with.
> My change:
> 
>  diff -up io_u.c.orig io_u.c
> --- io_u.c.orig 2009-04-27 15:42:11.213724000 -0700
> +++ io_u.c      2009-04-27 15:51:34.881647000 -0700
> @@ -838,7 +838,7 @@ struct io_u *get_io_u(struct thread_data
> 
>                 f->last_pos = io_u->offset + io_u->buflen;
> 
> -               if (td->o.verify != VERIFY_NONE)
> +               if (td->o.verify != VERIFY_NONE && io_u->ddir == DDIR_WRITE)
>                         populate_verify_io_u(td, io_u);
>                 else if (td->o.refill_buffers && io_u->ddir == DDIR_WRITE)
>                         io_u_fill_buffer(td, io_u, io_u->xfer_buflen);

Most likely to scrub the contents, but a memset() would have sufficed
there. Still pretty pointless, I see no reason why we can't apply your
patch (done).

-- 
Jens Axboe

