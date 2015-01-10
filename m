Return-Path: <andrey.v.kuzmin@gmail.com>
MIME-Version: 1.0
In-Reply-To: <54ADC21F.10207@kernel.dk>
References: <54ADC21F.10207@kernel.dk>
From: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Date: Sat, 10 Jan 2015 12:26:36 +0300
Message-ID: <CANvN+enbhOSjoVWYvAE0LQZhC7K+=pm1u7OkebB6trDh-GvZdw@mail.gmail.com>
Subject: Re: Non-uniform randomness with drifting
Content-Type: text/plain; charset=UTF-8
To: Jens Axboe <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On Thu, Jan 8, 2015 at 2:32 AM, Jens Axboe <axboe@kernel.dk> wrote:
> Hi,
>
> If you boil it down, fio can basically do two types of random distributions
> (random_distribution=):
>
> - Uniform, meaning we scatter evenly across the IO range.
> - Or zipf/pareto, meaning that we have some notion of hotness of
>   offsets that are hit more often than others.
>
> zipf/pareto are often used to simulate real world access patterns, where,
> eg, 5% of the dataset is hit 95% of the time, and having a long tail of
> rarely accessed data.
>
> Something that's bothered me for a while is that a zipf/pareto distribution
> remains static over the runtime of the job. Real world workloads would often
> see a shift in what appears hot/cold and what isn't. So the attached patch
> is a first crude attempt at implementing that, and I'm posting it here to
> solicit ideas on how best to express such a shift in access patterns. The
> patch attached defines the following options:
>
> random_drift    none, meaning the current behavior (static)
>                 sudden, meaning a sudden shift in the hot data
>                 gradual, meaning a gradual shift in the hot data
>
> random_drift_start_percentage   0..100%. For example, if set to 50%, the
>                 hot/cold distribution would remain static until 50% of
>                 data has been accessed.
>
> random_drift_percentage         0..100% For example, if set to 10%, the
>                 hot/cold distribution would shift 10% of the total size
>                 for every 10% of the workload accessed.
>
> I'm thinking that random_drift_percentage should be split in two, so that we
> could say "shift X percent every time Y percent of the data has been
> accessed". But apart from that, any input on this? I'm open to suggestions
> on how to improve this, I think it's a feature that people evaluating
> caching solutions would be interested in in using.

Great start to me, with a lot of use cases out-of-the-box. A concern,
probably a minor one, is that drift is global and applies to all data
directions and threads, while one might be interested to model
read/write or per thread behavior differently in this regard.

Further down the line, I'd give a thought to turning the base of the
distribution in use into a (say, uniform) random variable.
start_percentage and percentage then become the moments of the
distribution that models the base offset evolution in time (expressed
in either units of time or data volume accessed). An obvious use case
is modelling multiple clients with zipf distribution, with each zipf's
base independently evolving in a random fashion (a realistic model of
a file server load with multiple clients, each with a randomly moving
hotspot).

Regards,
Andrey

>
> An example job file would contain:
>
> random_distribution=zipf
> random_drift=gradual
> random_drift_start_percentage=50
> random_drift_percentage=10
>
> --
> Jens Axboe
>

