Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH 3/5] Refine packed annotations in stat.h
References: <20190813020136.15798-1-bvanassche@acm.org>
 <20190813020136.15798-4-bvanassche@acm.org>
 <cfaf773a-8fe0-ceaa-3b7d-bbfe7116e2bf@kernel.dk>
 <a5ab1f27-72b6-7d27-5eae-be61294df3f9@acm.org>
 <2ae2b675-2da9-c4a2-4b29-cb21afc19b1f@kernel.dk>
 <d0e9560f-2584-f439-fd27-e1ccfc768da8@acm.org>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <77dec459-8f07-abd6-d2e0-4089bccb380e@kernel.dk>
Date: Tue, 13 Aug 2019 15:04:28 -0600
MIME-Version: 1.0
In-Reply-To: <d0e9560f-2584-f439-fd27-e1ccfc768da8@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Bart Van Assche <bvanassche@acm.org>
Cc: fio@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>
List-ID: <fio@vger.kernel.org>

On 8/13/19 2:51 PM, Bart Van Assche wrote:
> On 8/13/19 1:25 PM, Jens Axboe wrote:
>> On 8/13/19 9:12 AM, Bart Van Assche wrote:
>>> On 8/12/19 7:53 PM, Jens Axboe wrote:
>>>> On 8/12/19 8:01 PM, Bart Van Assche wrote:
>>>>> Instead of declaring the whole structure packed, only declare non-aligned
>>>>> members packed. This patch is an alternative way to fix the following gcc 9
>>>>> compiler warnings:
>>>>>
>>>>> eta.c: In function 'calc_thread_status':
>>>>> eta.c:510:7: error: taking address of packed member of 'struct jobs_eta' may result in an unaligned pointer value [-Werror=address-of-packed-member]
>>>>>       510 |     je->rate);
>>>>>           |     ~~^~~~~~
>>>>> eta.c:522:66: error: taking address of packed member of 'struct jobs_eta' may result in an unaligned pointer value [-Werror=address-of-packed-member]
>>>>>       522 |  calc_rate(unified_rw_rep, disp_time, io_bytes, disp_io_bytes, je->rate);
>>>>>           |                                                                ~~^~~~~~
>>>>> eta.c:523:64: error: taking address of packed member of 'struct jobs_eta' may result in an unaligned pointer value [-Werror=address-of-packed-member]
>>>>>       523 |  calc_iops(unified_rw_rep, disp_time, io_iops, disp_io_iops, je->iops);
>>>>>           |
>>>>
>>>> This seems fragile. Not that we change the struct all the time, or even often,
>>>> but it'd be easy to add members and end up with different layout on 32-bit
>>>> vs 64-bit.
>>>>
>>>> How do we improve on that?
>>>
>>> Hi Jens,
>>>
>>> Do you agree that the "BUILD_BUG_ON(sizeof(struct jobs_eta) != 160)"
>>> statement added by the previous patch should catch such differences? 160
>>> bytes namely is the size of an entirely packed jobs_eta structure.
>>
>> I guess that's good enough, though it'd be nice to check for holes
>> explicitly. I wonder if there's an easy way to do that, though...
> 
> Hi Jens,
> 
> The pahole tool should be able to check for holes. Unfortunately that
> tool doesn't seem to work very well on Ubuntu:

I was more thinking at build time. It'd be nice if you could do
something ala:

struct bla {
	int a;
	long b;
};

struct bla b1;
struct bla b2 __attribute__((__packed__));

BUILD_BUG_ON(sizeof(b1) != sizeof(b2));

If we rely on external components to do this, we might as well not do
it.

-- 
Jens Axboe


