Return-Path: <axboe@kernel.dk>
Message-ID: <54AEA176.7070008@kernel.dk>
Date: Thu, 08 Jan 2015 08:25:42 -0700
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Non-uniform randomness with drifting
References: <54ADC21F.10207@kernel.dk> <CAB-428nDc67PJZ+imqBgqAqtgriCkkUJZNS6kO2xgYBGkgpcYg@mail.gmail.com>
In-Reply-To: <CAB-428nDc67PJZ+imqBgqAqtgriCkkUJZNS6kO2xgYBGkgpcYg@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
To: Alireza Haghdoost <haghdoost@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 01/08/2015 08:02 AM, Alireza Haghdoost wrote:
> On Wed, Jan 7, 2015 at 5:32 PM, Jens Axboe <axboe@kernel.dk> wrote:
>> An example job file would contain:
>>
>> random_distribution=zipf
>> random_drift=gradual
>> random_drift_start_percentage=50
>> random_drift_percentage=10
>
> Jens,
>
> This is an interesting proposal. Just to make sure if I understand
> your example correctly, in this example you are proposing Gradual
> shift  in hot/cold Blocks after 50% of workload is generated. This
> shift then would be 10% total distribution for every 10% of remaining
> workload access. It that correct ?

That is correct.

> If I understand this correctly, the workload randomness distribution
> would change after drift. For example if I start with zipf:1.2
> initially, I would have different distribution after the drift which
> is hard to describe. Would it be still Zipf with what theta parameter
> ?

After the drift, the zipf distribution would still be 1.2, it would just 
be a different set of blocks in the bands. The way it's implemented, it 
basically just shifts the logical offset in the drift. An example - lets 
say we have set the zipf to have the following distribution, using a 
small range for ease of representation:

0..4	95% of hits
5..9	5% of hits
10..14	2%
15..19	1%
20..24	1%
25..29	0.5%

We'll use the drift parameters from above, so once we've done 50% of the 
workload, we'll drift 10%. Since N is 30 here, that's a drift of 3. When 
that 10% drift is done, the distribution will look like this:

27..29 and 0..1		95% of hits
2..6			5% of hits
7..11			2%
12..16			1%
17..21			1%
22..26			0.5%

In other words, the distribution is identical, it's just a different set 
of blocks in the range. Fio hashes the linear blocks, so it won't be 0 
as the hottest, 1 as the next hottest, etc. That's just for simplicity 
in this example.

If you graph the distribution from 0..N, after the shift, the graph 
would look the same. It would just be offset to the right, with the long 
tail wrapped around.

> Having said that, It would be more interesting and practical if we can
> set specific distribution parameter for the drifted workload phases.
> For example, Would be nice to divide the workload into 4 phases, phase
> 1: workload start with zipf:1.2, phase 2: workload drift to zipf:1.4,
> phase 3: workload drift to pareto, phase 4:workload drift to uniform
> distribution.

I would not be adverse to drifting the zipf or pareto values, but I 
think it's orthogonal to this issue. You could imagine workloads where 
that is all you drift, or workloads where you both drift the LBA space 
and the zipf theta, for instance. Drifting between different 
distribution types (from zipf to pareto, or from pareto to uniform) is 
likely never going to be implemented, however.

> With this approach, we have more control on the workload randomness
> distribution parameters for each gradual drift. Moreover, it would be
> more practical to characterize a real workload and extract
> distribution parameters for these phases and then feed them to fio for
> synthetic re-generation of such a workload.

Definitely, the better you understand the workload, the better you can 
model. The above description is a linear (or sudden) drift of hotness, 
and an easy implementation of zipf theta drift would also be linear. 
Since we do have support for evaluating math, it would not be impossible 
to support having a functional description of the drift. But I think we 
should just keep it simple and support linear shifts.

-- 
Jens Axboe


