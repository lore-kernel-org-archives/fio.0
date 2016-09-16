Return-Path: <axboe@kernel.dk>
Subject: Re: bssplit functionality seems broken in 2.13
References: <CACDTvf5PhEZ55+CYQV6JpBAr7=KDQQSiWySA=EZWJiE0f42KSQ@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <c11934e9-904b-a976-a7a6-c156f035d45d@kernel.dk>
Date: Fri, 16 Sep 2016 09:14:14 -0600
MIME-Version: 1.0
In-Reply-To: <CACDTvf5PhEZ55+CYQV6JpBAr7=KDQQSiWySA=EZWJiE0f42KSQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Ryan Stiles <rstiles.org@gmail.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 09/15/2016 11:01 AM, Ryan Stiles wrote:
> Good day,
>
> We have automation that uses the "bssplit" function to get a wide
> variety of IO patterns, I have noticed that in 2.13 (compiled with
> no-shared-mem).  The bsssplit only takes the first variable, meaning:
>
> bssplit=1k/50:128k/50
>
> will yield a 100% 1k workload.
>
> This is the workload:
> [global]
> random_generator=tausworthe64
> direct=1
> loops=1
> ioengine=libaio
> iodepth=16
> group_reporting
> filename=/dev/disk/by-uuid/27602b49-4a18-4dca-a896-e2fc86746015
>
> [workload]
> rw=randread
> bssplit=1k/50:128k/50

What's causing this issue is the use of the 64-bit random generator.
There's a bug in the bssplit calculation code that overflows for that
case. I've pushed a fix out for it:

http://git.kernel.dk/cgit/fio/commit/?id=3dd29f7c21538c164fcbd078c3f2e532a9193a04

With that fix, you should see better behavior. Note that to truly have a
50/50 split for this, you'd want to set 'norandommap' as well. Otherwise
fio will fit the block size to avoid overlapped IO. When that happens,
you'll have 50% 1k random reads, but the other 50% will be between 1k
and 128k. If a 128k random read would overlap at the generated offset,
fio would adjust it down.

-- 
Jens Axboe


