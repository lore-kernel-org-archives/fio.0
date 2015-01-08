Return-Path: <axboe@kernel.dk>
Message-ID: <54AEB3E9.3010009@kernel.dk>
Date: Thu, 08 Jan 2015 09:44:25 -0700
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Non-uniform randomness with drifting
References: <54ADC21F.10207@kernel.dk> <CAB-428nDc67PJZ+imqBgqAqtgriCkkUJZNS6kO2xgYBGkgpcYg@mail.gmail.com> <54AEA176.7070008@kernel.dk> <CAB-428nMhwZECyWAxUNjhbpzdb3aoxzks3=H1O9v7pfLGNLc9A@mail.gmail.com>
In-Reply-To: <CAB-428nMhwZECyWAxUNjhbpzdb3aoxzks3=H1O9v7pfLGNLc9A@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
To: Alireza Haghdoost <haghdoost@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 01/08/2015 09:07 AM, Alireza Haghdoost wrote:
>> In other words, the distribution is identical, it's just a different set of
>> blocks in the range. Fio hashes the linear blocks, so it won't be 0 as the
>> hottest, 1 as the next hottest, etc. That's just for simplicity in this
>> example.
>
> Thanks for describing the idea in the second example. I get a sense of
> what you proposing now. I am just now sure about the application of
> such a workload. From the caching point of view, it does not really
> matter which LBA ranges are in 95% hit range. Specially these days
> that caches are all fully associative and based on key-value store.
> That is my impression that might be wrong. I think am not convinced
> that 95% hit on 0-4 LBA range would have different caching behavior
> compared with 27-29 and 0-1 range.

Lets take a classic example of having some slow big storage, with 5% of 
that capacity fronted by a much faster device. For that to be effective, 
you would assume that almost all the hot data access hits the faster 
caching device. If we drift the values that are accessed often, then we 
exercise the ability of the cache to adapt to the new working set.

> I agree with you that this LBA drift does not change zipf
> distribution. But only if we look at certain portion of the workload.
> For example, in the first portion of workload, it was a zipf:1.2 and
> 95% hit on 0-4 range, in the second phase it is still zipf:1.2 with
> 95% hit on the other range. Therefore, if we look at the workload as a
> whole not just a portion of the workload, it would be a zipf that
> receive less than 95% hit on the 0-4 range because the hot range has
> been drifted in the second portion of the workload. Therefore, the
> workload as a whole does not maintain the original zipf:1.2
> distribution since original 95% hit on 0-4 range has been distributed
> to other LBA ranges.

Yes, that is definitely true. Lets say we use the same 10% drift for 
each time period, t. And lets say we have drifted 10 times, through 
periods t1..t10. Graphing the access pattern for the entire period of 
t1..t10 would yield a flat equal distribution, and that surely isn't 
zipf:1.2. That is unavoidable with a drift like that. The point is that 
the distribution for the time period t1 would be zipf:1.2, and the 
distribution for t2 would also be zipf:1.2, they would just not be the 
same sets of data. The distribution of data only makes sense within the 
defined period of time, and that is also true of the performance seen. 
You can't drift too quickly, or they would be no point in doing so, you 
might as well just do uniformly random IO at that point.

>> I would not be adverse to drifting the zipf or pareto values, but I think
>> it's orthogonal to this issue. You could imagine workloads where that is all
>> you drift, or workloads where you both drift the LBA space and the zipf
>> theta, for instance. Drifting between different distribution types (from
>> zipf to pareto, or from pareto to uniform) is likely never going to be
>> implemented, however.
>
> Would it be possible to define 4 workers and associate each one to a
> certain distribution then execute them in a sequence ? For example,
> worker 1 with zipf:1.2 start from beginning to 25% of workload, worker
> 2 with zipf:1.4 start from the 25% to 50% of workload time, worker 3
> with pareto start from 50% to 75% of the workload time and finally
> worker 4 with uniform distribution start from 75% to the end of
> workload time.

Sure, you could do that right now, just define the 4 jobs with the 
desired settings, and have them execute serially by placing a stonewall 
between them.

> My point is that for caching workload, change in hot LBA range is less
> important that change in distribution of requests to hot LBAs. For

I don't think that is generally true. It's true for some types of 
caching workloads, like the VDI you describe below. If you're caching 
for a database workload, with the database holding store items or 
similar, a drift would more closely match. It's not quite perfect, but 
I'm not aiming for perfection here or we'd never get done. The drift 
expires everything in the hot end of the spectrum. For natural 
workloads, I would expect a decay of some of the hotter items, but some 
of them would likely persist over much longer intervals.

> example, a VDI workload expose a great temporal locality in the
> morning during boot storm, then its temporal locality would reduce
> since all virtual desktops are running with different applications
> during normal business hours. Finally the temporal locality would
> reduce to zero or uniform distribution over the night since most of
> the clients are turned off or hybernated.

A workload like that isn't really something you'd model with a drift. 
That's essentially three separate phases of the workload. Phase 1, boot 
storm, could be described with a zipf/pareto distribution, fairly 
closely. Phase 2 is probably more uniformly random, data set is a lot 
larger, though some locality would still be expected (I bet they all run 
Office, for instance, but they save/open different files). So perhaps 
phase 2 would work as zipf/pareto as well, just with a different input 
value. Phase 3 is basically idle, systems are off outside of the few sad 
souls burning the midnight oil.

-- 
Jens Axboe


