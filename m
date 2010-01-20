Return-Path: <whalajam@yahoo.com>
Message-ID: <525972.64557.qm@web55004.mail.re4.yahoo.com>
Date: Wed, 20 Jan 2010 15:57:11 -0800 (PST)
From: john smith <whalajam@yahoo.com>
Subject: Re: io scheduler merges control
In-Reply-To: <1264004335.2767.7.camel@cail>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Jens Axboe <jens.axboe@oracle.com>, "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

Alan,

Your patch worked, didn't see any other problems, thanks.

If you get a chance, I'd like to understand why/how the block device driver speed influences the number of merges,

thanks,
John

--- On Wed, 1/20/10, Alan D. Brunelle <Alan.Brunelle@hp.com> wrote:

> From: Alan D. Brunelle <Alan.Brunelle@hp.com>
> Subject: Re: io scheduler merges control
> To: "Jens Axboe" <jens.axboe@oracle.com>
> Cc: "john smith" <whalajam@yahoo.com>, fio@vger.kernel.org
> Date: Wednesday, January 20, 2010, 8:18 AM
> On Mon, 2010-01-11 at 14:54 +0100,
> Jens Axboe wrote:
> > On Tue, Jan 05 2010, Alan D. Brunelle wrote:
> > > On Mon, 2010-01-04 at 17:53 -0800, john smith
> wrote:
> > > > Alan,
> > > > 
> > > > I've tried 'echo "1">
> /sys/block/<dsf>/queue/nomerges' but
> > > > fio/sequential-reads merges still occur and
> apparently they are only
> > > > the simple ones that can't be disabled.
> > > > 
> > > > 1) What can I change in the kernel to
> disable ALL the merges
> > > > (including the simple ones)?
> > > > (I tried setting
> iosched_cfq.ops.elevator_merge_fn,
> > > > elevator_merged_fn, elevator_merge_req_fn,
> elevator_allow_merge_fn = 0
> > > > but still fio reported merges)
> > > 
> > > Unfortunately, the "simple" ones were left in
> precisely because they
> > > were (a) easy to do, and (b) were expected to
> happen often enough to
> > > keep them in. Jens may be able to comment
> further.
> > 
> > Right, they are both cheap and easy so they were kept.
> The goal with the
> > nomerges switch was to save CPU, so it'll still do
> cheap merges. I don't
> > think there's a use for disabling merges completely
> outside of device
> > testing and benchmarking, it's not a real world
> problem. That said, I do
> > occasionally hack that up as well for testing
> purposes. Perhaps we could
> > tweak nomerges to accept a '2' value as well,
> indicating that we don't
> > want any merges at all.
> > 
> 
> John (& Jens) - 
> 
> Please find attached a patch that does this - new
> documentation
> for /sys/block/*/queue/nomerges:
> 
> +This enables the user to disable the lookup logic involved
> with IO
> +merging requests in the block layer. By default (0) all
> merges are
> +enabled. When set to 1 only simple one-hit merges will be
> tried. When
> +set to 2 no merge algorithms will be tried (including
> one-hit or more
> +complex tree/hash lookups).
> 
> John: let me know if this does what you'd think - then I'll
> go post to
> LKML.
> 
> Regards,
> Alan
> 


      

