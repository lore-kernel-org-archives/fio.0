Return-Path: <fio-owner@vger.kernel.org>
Received: from [95.166.99.235] ([95.166.99.235]:58942 "EHLO kernel.dk"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756876AbZKDTgR (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 4 Nov 2009 14:36:17 -0500
Date: Wed, 4 Nov 2009 20:36:22 +0100
From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Add extra_buff_count flag
Message-ID: <20091104193622.GJ8742@kernel.dk>
References: <66dfd3fe0911031633s5bef0621g99b4164c2dd174d9@mail.gmail.com> <20091104073525.GQ8742@kernel.dk> <66dfd3fe0911040912s377b8b0eqb81fa3cad3db2d2f@mail.gmail.com> <20091104172932.GD8742@kernel.dk> <66dfd3fe0911040939w7629a514l393e3a6360430b54@mail.gmail.com> <20091104174123.GG8742@kernel.dk> <20091104192230.GI8742@kernel.dk> <66dfd3fe0911041131qcd032dem89f3cdfada112989@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <66dfd3fe0911041131qcd032dem89f3cdfada112989@mail.gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Radha Ramachandran <radha@google.com>
Cc: fio@vger.kernel.org

On Wed, Nov 04 2009, Radha Ramachandran wrote:
> Thank you for the documentation update.

I haven't updated it, it was already there :-)

> You also mentioned that you saw some kind of a race on io_u->flags
> today, do you by any chance know if you were using iodepth_low or
> iodepth_batch_complete or libaio engine options.
> I think I see an issue when using them and understand why it happens,
> but dont have a clean fix yet, will hopefully have one soon. I was
> wondering if its the same issue you are seeing.
> Basically the issue is we might think the queue is full (because we
> cannot allocate any more io_u (they are probably doing async verify)),
> but the code assumes that if the queue is full, then there is atleast
> one I/O that we can do "io_getevents" on. And that will cause a hang
> in the code.

I didn't use libaio, I can reproduce it with the sync engine directly
and much easier if using fast "null" verifies. It triggers this assert
in put_io_u():

        assert((io_u->flags & IO_U_F_FREE) == 0);

and this in __get_io_u():

                assert(io_u->flags & IO_U_F_FREE);

The former I think is just a bug, it's likely a reput or something, but
not sure yet. The latter looks like a race on the flags, since it isn't
always locked down when manipulated.

So it sounds like it's two separate issues, I'd urge you to continue
debugging yours and I'll fix this one tomorrow.

-- 
Jens Axboe

