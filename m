Return-Path: <kcronbur@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20160707183605.GB8567@kernel.dk>
References: <CAJ9yE1DPWmV0Hx_AAS5cKZR5qSFeqmqJVg7dgikQK=ZBje-e3A@mail.gmail.com>
 <20160707183605.GB8567@kernel.dk>
From: Karl Cronburg <kcronbur@redhat.com>
Date: Thu, 7 Jul 2016 15:46:32 -0400
Message-ID: <CAJ9yE1Ayvzkq5iNYCWEfhzunA7pLoJrS-YBb9TtBR3RM1xyWDg@mail.gmail.com>
Subject: Re: what is the sample logger doing when the buffer fills up?
Content-Type: text/plain; charset=UTF-8
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

Yes, my patch fixed the dropping of entries I was seeing.

On Thu, Jul 7, 2016 at 2:36 PM, Jens Axboe <axboe@kernel.dk> wrote:
> On Wed, Jul 06 2016, Karl Cronburg wrote:
>> Hello all,
>>
>> When I change add_clat_sample() in stat.c to call add_log_sample() seven times
>> instead of once, and I set DEF_LOG_ENTRIES=4096, I get the following in the clat
>> log file (note first column is line number in the file):
>>
>>   4089 143, 9832, 0, 131072
>>   4090 143, 9832, 0, 131072
>>   4091 143, 9832, 0, 131072
>>   4092 143, 9832, 0, 131072
>>   4093 143, 9832, 0, 131072
>>   4094 143, 9832, 0, 131072
>>   4095 143, 9832, 0, 131072
>>   4096 143, 9834, 0, 131072
>>   4097 170, 15982, 0, 131072
>>   4098 170, 15982, 0, 131072
>>   4099 170, 15982, 0, 131072
>>   4100 170, 15982, 0, 131072
>>   4101 170, 15982, 0, 131072
>>   4102 170, 15982, 0, 131072
>>   4103 170, 15982, 0, 131072
>>   4104 170, 15985, 0, 131072
>>   4105 170, 15985, 0, 131072
>>
>> Notice the lonely '9834' value in the center, which should have 7
>> exact copies of itself
>> but gets cut off right at the buffer size of 4096 entries.
>>
>> So if I'm interpreting this correctly, samples get silently dropped
>> (or not properly printed?)
>> when the buffer fills up. Is this a bug? Am I misinterpreting what the
>> doubly linked list is
>> for? I was under the impression that a new sample buffer should be
>> added to the linked
>> list when the current one fills up.
>
> Fair to assume this is what your patch fixed, correct? Just wanted to
> ensure that it's already fixed.
>
> --
> Jens Axboe
>

