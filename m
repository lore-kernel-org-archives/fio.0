Return-Path: <axboe@kernel.dk>
Date: Wed, 5 Feb 2014 14:28:12 -0700
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: Rip out verify_backlog support?
Message-ID: <20140205212812.GC20626@kernel.dk>
References: <CANEJEGuqYiSQnyw2bVNFa3CKqmZK6+-3y5dDT4h3iccU-n0cAA@mail.gmail.com>
 <20140205193214.GI27534@kernel.dk>
 <CANEJEGs-KdsMC3fE3SvOUkkbJESXXvUHwRVq5OjWTfKyf-ooEA@mail.gmail.com>
 <20140205195317.GK27534@kernel.dk>
 <CANEJEGsqwKQssFqZPEycWR-ccqcVjWGQA=EtLtDsdxg5D1-c_g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANEJEGsqwKQssFqZPEycWR-ccqcVjWGQA=EtLtDsdxg5D1-c_g@mail.gmail.com>
To: Grant Grundler <grundler@chromium.org>
Cc: FIO_list <fio@vger.kernel.org>, Puthikorn Voravootivat <puthik@chromium.org>
List-ID: <fio@vger.kernel.org>

On Wed, Feb 05 2014, Grant Grundler wrote:
> On Wed, Feb 5, 2014 at 11:53 AM, Jens Axboe <axboe@kernel.dk> wrote:
> ...
> >> Couldn't one shorten the defined workload and use bigger loop= instead?
> >
> > That's not really the same, typically you'd end up re-running the same
> > thing over and over then.
> 
> Yes...unless we use a different seed on each loop. Or don't even
> attempt to loop in FIO - but rather outside of FIO by the test
> framework - e.g. autotest or other scripting language.

Lots of stuff happens at setup/teardown. It's a lot more efficient to
handle it internally.

So, to summarize, I'd much rather get rid of do_verify() and handle
everything in do_io(), which is what the verify_backlog does. The fact
that fio has two nearly identical loops for IO is weird and fragile. A
"normal" verify_backlog=0 is just a variant of verify_backlog=x with
unlimited backlog, it should fall out nicely. Lets move in that
direction, not kill verify_backlog.

> >> But in order to have strong verification without tracking IOs we need
> >> to log the order that the IOs are issued, not the order they complete.
> >
> > My point is that you don't need to log it at all. Lets say you have a
> > backlog of 500. After you have issued 500 writes, you simply reset your
> > LFSR (or random generators) and re-run the same sequence as reads.
> 
> This is effectively "logging in the order issued" - just don't need to
> record the LBA. We still need to track when the IO was issued and
> completed. Once those stats are recorded elsewhere, we don't need to
> remember the "order" since it can be reproduced.
> 
> >> Verify_backlog today requires logging IO in the order they are
> >> completed. The problem is synchronizing the thread(s) that perform IO
> >> vs the thread(s) that perform verification so verification isn't
> >> attempted on IO that isn't complete (but is "issued" and thus logged
> >> "in order issued"). The complication is IOs generally don't complete
> >> in the order issued.
> >
> > For verify_backlog, obviously we cannot rollback the generators without
> > having other synchronization between the writers and readers. So logging
> > still makes more sense for that, I think. We'll just have them log in
> > issue order, that doesn't seem like a big deal.
> 
> Agreed - but that synchronization doesn't exist today AFAICT.

It does - that's the log_io_piece() mechanism. The writer will generate
on, and verify will read those and verify. We just have to ensure that
it is correct in the way that it is logged. The alternative would be to
rely purely on the generator rollback, and for that you would then need
some specific notification on how far the reader could proceed, if async
verify_backlog is used.

-- 
Jens Axboe


