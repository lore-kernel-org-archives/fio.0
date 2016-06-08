Return-Path: <axboe@kernel.dk>
Subject: Re: computing percentiles from fio data
References: <CAJ9yE1BYp_jqjwVVap1U-zjYfGT6bsOuXbOMcJV0r8Mz-5LQBQ@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <5757A8C3.4000704@kernel.dk>
Date: Tue, 7 Jun 2016 23:10:27 -0600
MIME-Version: 1.0
In-Reply-To: <CAJ9yE1BYp_jqjwVVap1U-zjYfGT6bsOuXbOMcJV0r8Mz-5LQBQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Karl Cronburg <kcronbur@redhat.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 06/06/2016 03:00 PM, Karl Cronburg wrote:
> Hello,
>
> In benchmarking ceph I've been using fio / fiologparser, and want to
> get out the sort of stats & percentiles fiologparser currently gives
> (min, avg, max, percentiles). However I'm concerned the data coming
> out of fio is insufficient when I pass it the log_avg_msec argument.
> Namely using the average of a possibly asymmetric sample distribution
> (the set of I/O request samples over which fio is averaging when I
> pass it this argument) will not give accurate percentiles.

The normal stats like percentiles and min/max/avg etc values are not 
averaged, even if log_avg_msec is set. That's only true for the logging, 
if you specify any of the latency (or iops/bw) logging. The stats that 
fio outputs at the end of a run in the normal output is not averaged.

So which problem are you attacking? If you want to improve the logged 
values, then that could be useful. You want to look at 
stat.c:add_log_sample() for that code.

> Something like this argument is necessary though to keep the log files
> a reasonable size. Would it be a good idea to push the sort of
> statistics done in the log parser directly into fio? I'm considering
> writing some code to compute the quantiles directly in fio, either
> brute-force by maintaining a sorted list or implementing something
> like the algorithm described here:
>
> http://www.cs.rutgers.edu/~muthu/bquant.pdf
>
> with some acceptable user-defined level of error given to fio when
> asked to compute the percentiles on long-running / large data sets.

I still don't quite follow this... You already have the percentiles. If 
you re-compute them from a latency log with log_avg_msec set, then yes, 
it won't be completely accurate. But why not just use the percentiles 
directly?

> Is there any interest in having this added directly into fio? If so
> where in the code should I be looking?

It might be, if I know exactly what problem we are trying to solve here: :-)

-- 
Jens Axboe


