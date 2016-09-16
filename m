Return-Path: <rstiles.org@gmail.com>
MIME-Version: 1.0
In-Reply-To: <c11934e9-904b-a976-a7a6-c156f035d45d@kernel.dk>
References: <CACDTvf5PhEZ55+CYQV6JpBAr7=KDQQSiWySA=EZWJiE0f42KSQ@mail.gmail.com>
 <c11934e9-904b-a976-a7a6-c156f035d45d@kernel.dk>
From: Ryan Stiles <rstiles.org@gmail.com>
Date: Fri, 16 Sep 2016 16:34:21 -0700
Message-ID: <CACDTvf7iukwi2ALxsPRRxhjqHQ3D5N0Zcs+cj=BGsUC58aom-g@mail.gmail.com>
Subject: Re: bssplit functionality seems broken in 2.13
Content-Type: text/plain; charset=UTF-8
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

Thanks for the patch Jens,

without the patch:
[0.0% done] [399.2MB/933.2MB/0KB /s] [102K/239K/0 iops]

with the patch:
[0.0% done] [2629MB/6158MB/0KB /s] [30.3K/70.7K/0 iops]


This looks like it corrected the issue.

Thank you for your time and support, have a great weekend!
Ryan


On Fri, Sep 16, 2016 at 8:14 AM, Jens Axboe <axboe@kernel.dk> wrote:
> On 09/15/2016 11:01 AM, Ryan Stiles wrote:
>>
>> Good day,
>>
>> We have automation that uses the "bssplit" function to get a wide
>> variety of IO patterns, I have noticed that in 2.13 (compiled with
>> no-shared-mem).  The bsssplit only takes the first variable, meaning:
>>
>> bssplit=1k/50:128k/50
>>
>> will yield a 100% 1k workload.
>>
>> This is the workload:
>> [global]
>> random_generator=tausworthe64
>> direct=1
>> loops=1
>> ioengine=libaio
>> iodepth=16
>> group_reporting
>> filename=/dev/disk/by-uuid/27602b49-4a18-4dca-a896-e2fc86746015
>>
>> [workload]
>> rw=randread
>> bssplit=1k/50:128k/50
>
>
> What's causing this issue is the use of the 64-bit random generator.
> There's a bug in the bssplit calculation code that overflows for that
> case. I've pushed a fix out for it:
>
> http://git.kernel.dk/cgit/fio/commit/?id=3dd29f7c21538c164fcbd078c3f2e532a9193a04
>
> With that fix, you should see better behavior. Note that to truly have a
> 50/50 split for this, you'd want to set 'norandommap' as well. Otherwise
> fio will fit the block size to avoid overlapped IO. When that happens,
> you'll have 50% 1k random reads, but the other 50% will be between 1k
> and 128k. If a 128k random read would overlap at the generated offset,
> fio would adjust it down.
>
> --
> Jens Axboe
>

