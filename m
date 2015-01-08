Return-Path: <mark.a.nelson@gmail.com>
Return-Path: <mark.a.nelson@gmail.com>
Message-ID: <54AE84AF.4010001@gmail.com>
Date: Thu, 08 Jan 2015 07:22:55 -0600
From: Mark Nelson <mark.a.nelson@gmail.com>
MIME-Version: 1.0
Subject: Re: Non-uniform randomness with drifting
References: <54ADC21F.10207@kernel.dk>
In-Reply-To: <54ADC21F.10207@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 01/07/2015 05:32 PM, Jens Axboe wrote:
> Hi,
>
> If you boil it down, fio can basically do two types of random
> distributions (random_distribution=):
>
> - Uniform, meaning we scatter evenly across the IO range.
> - Or zipf/pareto, meaning that we have some notion of hotness of
>    offsets that are hit more often than others.
>
> zipf/pareto are often used to simulate real world access patterns,
> where, eg, 5% of the dataset is hit 95% of the time, and having a long
> tail of rarely accessed data.
>
> Something that's bothered me for a while is that a zipf/pareto
> distribution remains static over the runtime of the job. Real world
> workloads would often see a shift in what appears hot/cold and what
> isn't. So the attached patch is a first crude attempt at implementing
> that, and I'm posting it here to solicit ideas on how best to express
> such a shift in access patterns. The patch attached defines the
> following options:
>
> random_drift    none, meaning the current behavior (static)
>          sudden, meaning a sudden shift in the hot data
>          gradual, meaning a gradual shift in the hot data
>
> random_drift_start_percentage    0..100%. For example, if set to 50%, the
>          hot/cold distribution would remain static until 50% of
>          data has been accessed.
>
> random_drift_percentage        0..100% For example, if set to 10%, the
>          hot/cold distribution would shift 10% of the total size
>          for every 10% of the workload accessed.
>
> I'm thinking that random_drift_percentage should be split in two, so
> that we could say "shift X percent every time Y percent of the data has
> been accessed". But apart from that, any input on this? I'm open to
> suggestions on how to improve this, I think it's a feature that people
> evaluating caching solutions would be interested in in using.
>
> An example job file would contain:
>
> random_distribution=zipf
> random_drift=gradual
> random_drift_start_percentage=50
> random_drift_percentage=10
>

This is fantastic Jens!  We use zipf for testing our cache tiering 
implementation in Ceph.  I suspect that you are absolutely right that a 
slowly shifting distribution would be more accurate (and probably slower 
for us sadly).  I don't think I really have anything to add as it seems 
like you've got the things I'd want covered.  Good Job!

Thanks,
Mark

