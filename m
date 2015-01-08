Return-Path: <haghdoost@gmail.com>
MIME-Version: 1.0
In-Reply-To: <54AEA176.7070008@kernel.dk>
References: <54ADC21F.10207@kernel.dk> <CAB-428nDc67PJZ+imqBgqAqtgriCkkUJZNS6kO2xgYBGkgpcYg@mail.gmail.com>
 <54AEA176.7070008@kernel.dk>
From: Alireza Haghdoost <haghdoost@gmail.com>
Date: Thu, 8 Jan 2015 10:07:08 -0600
Message-ID: <CAB-428nMhwZECyWAxUNjhbpzdb3aoxzks3=H1O9v7pfLGNLc9A@mail.gmail.com>
Subject: Re: Non-uniform randomness with drifting
Content-Type: text/plain; charset=ISO-8859-1
To: Jens Axboe <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

> In other words, the distribution is identical, it's just a different set of
> blocks in the range. Fio hashes the linear blocks, so it won't be 0 as the
> hottest, 1 as the next hottest, etc. That's just for simplicity in this
> example.

Thanks for describing the idea in the second example. I get a sense of
what you proposing now. I am just now sure about the application of
such a workload. From the caching point of view, it does not really
matter which LBA ranges are in 95% hit range. Specially these days
that caches are all fully associative and based on key-value store.
That is my impression that might be wrong. I think am not convinced
that 95% hit on 0-4 LBA range would have different caching behavior
compared with 27-29 and 0-1 range.

I agree with you that this LBA drift does not change zipf
distribution. But only if we look at certain portion of the workload.
For example, in the first portion of workload, it was a zipf:1.2 and
95% hit on 0-4 range, in the second phase it is still zipf:1.2 with
95% hit on the other range. Therefore, if we look at the workload as a
whole not just a portion of the workload, it would be a zipf that
receive less than 95% hit on the 0-4 range because the hot range has
been drifted in the second portion of the workload. Therefore, the
workload as a whole does not maintain the original zipf:1.2
distribution since original 95% hit on 0-4 range has been distributed
to other LBA ranges.

>
> I would not be adverse to drifting the zipf or pareto values, but I think
> it's orthogonal to this issue. You could imagine workloads where that is all
> you drift, or workloads where you both drift the LBA space and the zipf
> theta, for instance. Drifting between different distribution types (from
> zipf to pareto, or from pareto to uniform) is likely never going to be
> implemented, however.

Would it be possible to define 4 workers and associate each one to a
certain distribution then execute them in a sequence ? For example,
worker 1 with zipf:1.2 start from beginning to 25% of workload, worker
2 with zipf:1.4 start from the 25% to 50% of workload time, worker 3
with pareto start from 50% to 75% of the workload time and finally
worker 4 with uniform distribution start from 75% to the end of
workload time.

My point is that for caching workload, change in hot LBA range is less
important that change in distribution of requests to hot LBAs. For
example, a VDI workload expose a great temporal locality in the
morning during boot storm, then its temporal locality would reduce
since all virtual desktops are running with different applications
during normal business hours. Finally the temporal locality would
reduce to zero or uniform distribution over the night since most of
the clients are turned off or hybernated.

