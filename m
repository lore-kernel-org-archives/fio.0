Return-Path: <axboe@kernel.dk>
Subject: Re: computing percentiles from fio data
References: <CAJ9yE1BYp_jqjwVVap1U-zjYfGT6bsOuXbOMcJV0r8Mz-5LQBQ@mail.gmail.com>
 <5757A8C3.4000704@kernel.dk>
 <CAJ9yE1BFu+wXKu26OuRvh6Xmw1AY+eYsAaPZD_=G0CvLujAd+w@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <575839BC.9060500@kernel.dk>
Date: Wed, 8 Jun 2016 09:29:00 -0600
MIME-Version: 1.0
In-Reply-To: <CAJ9yE1BFu+wXKu26OuRvh6Xmw1AY+eYsAaPZD_=G0CvLujAd+w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Karl Cronburg <kcronbur@redhat.com>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 06/08/2016 09:21 AM, Karl Cronburg wrote:
> On Wed, Jun 8, 2016 at 1:10 AM, Jens Axboe <axboe@kernel.dk> wrote:
>> On 06/06/2016 03:00 PM, Karl Cronburg wrote:
>>>
>>> Hello,
>>>
>>> In benchmarking ceph I've been using fio / fiologparser, and want to
>>> get out the sort of stats & percentiles fiologparser currently gives
>>> (min, avg, max, percentiles). However I'm concerned the data coming
>>> out of fio is insufficient when I pass it the log_avg_msec argument.
>>> Namely using the average of a possibly asymmetric sample distribution
>>> (the set of I/O request samples over which fio is averaging when I
>>> pass it this argument) will not give accurate percentiles.
>>
>>
>> The normal stats like percentiles and min/max/avg etc values are not
>> averaged, even if log_avg_msec is set. That's only true for the logging, if
>> you specify any of the latency (or iops/bw) logging. The stats that fio
>> outputs at the end of a run in the normal output is not averaged.
>>
>> So which problem are you attacking? If you want to improve the logged
>> values, then that could be useful. You want to look at
>> stat.c:add_log_sample() for that code.
>
> I'm looking to:
> 1) Have a log file with min/avg/max and percentiles for each time interval,
> 2) Be able to (accurately) merge these statistics across threads, and
> 3) Massage the data into uniform time intervals
>
> So basically what Mark has been trying to do in post-processing with
> fiologparser, but directly in fio to both reduce logging overhead of fio
> (because I would only need to output a log entry say every second)
> and to leverage the finer granularity of the data.
>
> I see you use a buckets / histogram method to maintain and subsequently
> compute the percentiles at the end for each thread. Would solving (1) above
> be a simple matter of querying this histogram over time?

Right, you could solve it that way. Basically you would have two sets of 
states, one for the entire run (what we have now), and one that gets 
cleared for every log_avg_msec. That would solve #1 without needing to 
add any new algorithms.

Merging/summing the percentiles is trivial, so #2 is solvable too 
without much work.

-- 
Jens Axboe


