Return-Path: <grundler@google.com>
MIME-Version: 1.0
Sender: grundler@google.com
In-Reply-To: <20140205193214.GI27534@kernel.dk>
References: <CANEJEGuqYiSQnyw2bVNFa3CKqmZK6+-3y5dDT4h3iccU-n0cAA@mail.gmail.com>
	<20140205193214.GI27534@kernel.dk>
Date: Wed, 5 Feb 2014 11:44:13 -0800
Message-ID: <CANEJEGs-KdsMC3fE3SvOUkkbJESXXvUHwRVq5OjWTfKyf-ooEA@mail.gmail.com>
Subject: Re: Rip out verify_backlog support?
From: Grant Grundler <grundler@chromium.org>
Content-Type: text/plain; charset=UTF-8
To: Jens Axboe <axboe@kernel.dk>
Cc: Grant Grundler <grundler@chromium.org>, FIO_list <fio@vger.kernel.org>, Puthikorn Voravootivat <puthik@chromium.org>
List-ID: <fio@vger.kernel.org>

On Wed, Feb 5, 2014 at 11:32 AM, Jens Axboe <axboe@kernel.dk> wrote:
> On Wed, Feb 05 2014, Grant Grundler wrote:
>> Today, fio has two distinct phases of operation: workload and then verify.
>>
>> But there is this hack which is in-between those two: verify_backlog
>> which makes things a lot more complicated. This hack was added to
>> limit the amount of memory needed to track the IOs that needed to be
>> verify. I'm going to argue "verify_each_loop" could do the same thing
>> and keep fio internals simpler (strictly two phases). If the goal is
>> to have longer running, well defined workloads that can be verified,
>> then verifying after each iteration makes more sense.  In other words,
>> the jobs should define a workload limit (amount of IO or time) and
>> then iterate that constraint as many times as they want to reach the
>> duration they want.
>>
>> Thoughts?
>
> We've actually caught actual bugs with the verify_backlog in the past,
> where you want verify closer to when the write has happened.

Couldn't one shorten the defined workload and use bigger loop= instead?

> So I'd prefer if we fix those up instead.

Ok.

> For memory reduction, I think the experimental_verify is the way to go.
> Basically have roll back support for any of the generated offsets etc,
> so we don't need to track it at all.

But in order to have strong verification without tracking IOs we need
to log the order that the IOs are issued, not the order they complete.
Verify_backlog today requires logging IO in the order they are
completed. The problem is synchronizing the thread(s) that perform IO
vs the thread(s) that perform verification so verification isn't
attempted on IO that isn't complete (but is "issued" and thus logged
"in order issued"). The complication is IOs generally don't complete
in the order issued.

Make more sense why I don't like verify backlog?

And if we get "verify backlog" working correctly, then we don't need
two distinct phases anymore. So perhaps remove that instead.

thanks,
grant

