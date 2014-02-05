Return-Path: <axboe@kernel.dk>
Date: Wed, 5 Feb 2014 12:32:14 -0700
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: Rip out verify_backlog support?
Message-ID: <20140205193214.GI27534@kernel.dk>
References: <CANEJEGuqYiSQnyw2bVNFa3CKqmZK6+-3y5dDT4h3iccU-n0cAA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANEJEGuqYiSQnyw2bVNFa3CKqmZK6+-3y5dDT4h3iccU-n0cAA@mail.gmail.com>
To: Grant Grundler <grundler@chromium.org>
Cc: FIO_list <fio@vger.kernel.org>, Puthikorn Voravootivat <puthik@chromium.org>
List-ID: <fio@vger.kernel.org>

On Wed, Feb 05 2014, Grant Grundler wrote:
> Today, fio has two distinct phases of operation: workload and then verify.
> 
> But there is this hack which is in-between those two: verify_backlog
> which makes things a lot more complicated. This hack was added to
> limit the amount of memory needed to track the IOs that needed to be
> verify. I'm going to argue "verify_each_loop" could do the same thing
> and keep fio internals simpler (strictly two phases). If the goal is
> to have longer running, well defined workloads that can be verified,
> then verifying after each iteration makes more sense.  In other words,
> the jobs should define a workload limit (amount of IO or time) and
> then iterate that constraint as many times as they want to reach the
> duration they want.
> 
> Thoughts?

We've actually caught actual bugs with the verify_backlog in the past,
where you want verify closer to when the write has happened. So I'd
prefer if we fix those up instead.

For memory reduction, I think the experimental_verify is the way to go.
Basically have roll back support for any of the generated offsets etc,
so we don't need to track it at all.

-- 
Jens Axboe


