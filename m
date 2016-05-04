Return-Path: <mark.a.nelson@gmail.com>
Return-Path: <mark.a.nelson@gmail.com>
Subject: Re: Missing log entries and other questions
References: <eBGJ1s00E1TeosZ01BGKGG> <036a01d19f62$717af530$5470df90$@cox.net>
 <20160427203823.GB25397@kernel.dk> <572A02B9.1040902@kernel.dk>
 <572A24AC.5090106@kernel.dk>
From: Mark Nelson <mark.a.nelson@gmail.com>
Message-ID: <c85dc095-f2d2-851b-7246-8530230e997c@gmail.com>
Date: Wed, 4 May 2016 12:43:44 -0500
MIME-Version: 1.0
In-Reply-To: <572A24AC.5090106@kernel.dk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>, Paul Alcorn <paullie1@cox.net>
Cc: 'Mihkal Dunfjeld' <mihkal.dunfjeld@stud.ntnu.no>, fio@vger.kernel.org, birger.lunstoeng@stud.ntnu.no
List-ID: <fio@vger.kernel.org>

On 05/04/2016 11:34 AM, Jens Axboe wrote:
> On 05/04/2016 08:10 AM, Jens Axboe wrote:
>> On 04/27/2016 02:38 PM, Jens Axboe wrote:
>>> I'll try and see if I can reproduce this.
>>
>> So I took a look at your logged output. The way that fio logs is that it
>> does it on IO completion. You have set 1s intervals, so it checks, when
>> an IO completes, if we're due for logging the previous interval IOPS:
>>
>> spent = mtime_since(&td->iops_sample_time, t);
>> if (spent < td->o.iops_avg_time)
>>          return;
>>
>> If you are doing lots of IO, it matches pretty evenly. But for slow
>> workloads, it will end up being skewed a bit. It won't be too hard to
>> fix the drift, though, but it still won't make it clock precise at exact
>> 1s intervals.
>>
>> We could move this part into the main thread, and out of the workers.
>> Then we could make it more precise. Might not be a bad idea in general,
>> since it'll move some of this code out of the fast path.
>>
>> I'll take a stab at it.
>
> Can you try the below patch?

I'll also try to take a look at this as we've seen a fair amount of skew 
in the logs doing fio librbd upstream ceph testing.  I actually wrote a 
first stab at a parser to aggregate logs from multiple fio processes 
with the assumption of non-uniform sampling:

https://github.com/ceph/cbt/blob/master/tools/fiologpaser.py

The idea is you have say 8 fio bw logs in a directory you can do:

fiologparser.py -f *bw*

which will return average values from the logs over user defined 
intervals by taking weighted scores from samples that overlap.  You can 
also look at per-interval averages, sums, or just a global average.

various option flags:

-i <interval time in ms>
-d <divide results by d (say if you want a different unit of output)
-f <show full interval data>
-a <show average interval data across logs>
-s <show sums for interval data across logs>

Mark

