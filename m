Return-Path: <kcronbur@redhat.com>
MIME-Version: 1.0
In-Reply-To: <5757A8C3.4000704@kernel.dk>
References: <CAJ9yE1BYp_jqjwVVap1U-zjYfGT6bsOuXbOMcJV0r8Mz-5LQBQ@mail.gmail.com>
	<5757A8C3.4000704@kernel.dk>
Date: Wed, 8 Jun 2016 11:21:24 -0400
Message-ID: <CAJ9yE1BFu+wXKu26OuRvh6Xmw1AY+eYsAaPZD_=G0CvLujAd+w@mail.gmail.com>
Subject: Re: computing percentiles from fio data
From: Karl Cronburg <kcronbur@redhat.com>
Content-Type: text/plain; charset=UTF-8
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On Wed, Jun 8, 2016 at 1:10 AM, Jens Axboe <axboe@kernel.dk> wrote:
> On 06/06/2016 03:00 PM, Karl Cronburg wrote:
>>
>> Hello,
>>
>> In benchmarking ceph I've been using fio / fiologparser, and want to
>> get out the sort of stats & percentiles fiologparser currently gives
>> (min, avg, max, percentiles). However I'm concerned the data coming
>> out of fio is insufficient when I pass it the log_avg_msec argument.
>> Namely using the average of a possibly asymmetric sample distribution
>> (the set of I/O request samples over which fio is averaging when I
>> pass it this argument) will not give accurate percentiles.
>
>
> The normal stats like percentiles and min/max/avg etc values are not
> averaged, even if log_avg_msec is set. That's only true for the logging, if
> you specify any of the latency (or iops/bw) logging. The stats that fio
> outputs at the end of a run in the normal output is not averaged.
>
> So which problem are you attacking? If you want to improve the logged
> values, then that could be useful. You want to look at
> stat.c:add_log_sample() for that code.

I'm looking to:
1) Have a log file with min/avg/max and percentiles for each time interval,
2) Be able to (accurately) merge these statistics across threads, and
3) Massage the data into uniform time intervals

So basically what Mark has been trying to do in post-processing with
fiologparser, but directly in fio to both reduce logging overhead of fio
(because I would only need to output a log entry say every second)
and to leverage the finer granularity of the data.

I see you use a buckets / histogram method to maintain and subsequently
compute the percentiles at the end for each thread. Would solving (1) above
be a simple matter of querying this histogram over time?

>
>> Something like this argument is necessary though to keep the log files
>> a reasonable size. Would it be a good idea to push the sort of
>> statistics done in the log parser directly into fio? I'm considering
>> writing some code to compute the quantiles directly in fio, either
>> brute-force by maintaining a sorted list or implementing something
>> like the algorithm described here:
>>
>> http://www.cs.rutgers.edu/~muthu/bquant.pdf
>>
>> with some acceptable user-defined level of error given to fio when
>> asked to compute the percentiles on long-running / large data sets.
>
>
> I still don't quite follow this... You already have the percentiles. If you
> re-compute them from a latency log with log_avg_msec set, then yes, it won't
> be completely accurate. But why not just use the percentiles directly?
>
>> Is there any interest in having this added directly into fio? If so
>> where in the code should I be looking?
>
>
> It might be, if I know exactly what problem we are trying to solve here: :-)
>
> --
> Jens Axboe
>

