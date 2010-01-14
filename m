Return-Path: <whalajam@yahoo.com>
Message-ID: <695931.70527.qm@web55001.mail.re4.yahoo.com>
Date: Thu, 14 Jan 2010 10:37:39 -0800 (PST)
From: john smith <whalajam@yahoo.com>
Subject: Re: io scheduler merges control
In-Reply-To: <20100111135455.GN4489@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: "Alan D. Brunelle" <Alan.Brunelle@hp.com>, Jens Axboe <jens.axboe@oracle.com>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

Jens,

--- On Mon, 1/11/10, Jens Axboe <jens.axboe@oracle.com> wrote:

> From: Jens Axboe <jens.axboe@oracle.com>
> Subject: Re: io scheduler merges control
> To: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
> Cc: "john smith" <whalajam@yahoo.com>, fio@vger.kernel.org
> Date: Monday, January 11, 2010, 5:54 AM
> On Tue, Jan 05 2010, Alan D. Brunelle
> wrote:
> > On Mon, 2010-01-04 at 17:53 -0800, john smith wrote:
> > > Alan,
> > > 
> > > I've tried 'echo "1">
> /sys/block/<dsf>/queue/nomerges' but
> > > fio/sequential-reads merges still occur and
> apparently they are only
> > > the simple ones that can't be disabled.
> > > 
> > > 1) What can I change in the kernel to disable ALL
> the merges
> > > (including the simple ones)?
> > > (I tried setting
> iosched_cfq.ops.elevator_merge_fn,
> > > elevator_merged_fn, elevator_merge_req_fn,
> elevator_allow_merge_fn = 0
> > > but still fio reported merges)
> > 
> > Unfortunately, the "simple" ones were left in
> precisely because they
> > were (a) easy to do, and (b) were expected to happen
> often enough to
> > keep them in. Jens may be able to comment further.
> 
> Right, they are both cheap and easy so they were kept. The
> goal with the
> nomerges switch was to save CPU, so it'll still do cheap
> merges. I don't
> think there's a use for disabling merges completely outside
> of device
> testing and benchmarking, it's not a real world problem.
> That said, I do
> occasionally hack that up as well for testing purposes.
> Perhaps we could
> tweak nomerges to accept a '2' value as well, indicating
> that we don't
> want any merges at all.
 
That would be useful, I'd like to have a way to monitor this (nomerges='2') addition.

I have one more question that you can shed some light on: 
how is that there are more merges for a faster driver than for a slower one (giving the same IO patern)?

I would think that, given that both drivers have the same queue depth, the slower the driver (the higher completion latency), the more merges can be done by the elevator (I'm sure is more complex than that).

Probably there is a description of this process somewhere, just couldn't find it, and biodoc.txt wasn't clear about it.

Thanks,
John


> -- 
> Jens Axboe
> 
> 


      

