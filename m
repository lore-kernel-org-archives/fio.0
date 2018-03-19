Return-Path: <axboe@kernel.dk>
Subject: Re: [RFC PATCH] doc: add comments for the difference between iodepth
 and blkdev's inflight
References: <20180129164548.GA7056@localhost.didichuxing.com>
 <CALjAwxgNXU41zLyXsSrZ+JxDdx1Td=_1ju5v73O8wdm5sPKBqA@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <6ab36d79-30d7-46b6-25cc-de96e48721ec@kernel.dk>
Date: Mon, 19 Mar 2018 10:13:23 -0600
MIME-Version: 1.0
In-Reply-To: <CALjAwxgNXU41zLyXsSrZ+JxDdx1Td=_1ju5v73O8wdm5sPKBqA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Sitsofe Wheeler <sitsofe@gmail.com>, weiping zhang <zhangweiping@didichuxing.com>
Cc: fio <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 3/17/18 2:44 AM, Sitsofe Wheeler wrote:
> (I know this one is old but I seem to have had a reply rolling around
> in my draft folder for a while)
> 
> On 29 January 2018 at 16:45, weiping zhang <zhangweiping@didichuxing.com> wrote:
>> If user want control the inflight IOs for the tested block device, for
>> example set iodepth=16, and we can get result like following:
>>
>> IO depths: 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=100.0%, 32=0.0%, >=64=0.0%
>>
>> this result only means (16~31) IOs inflight, don't means requests inflight,
>> if max_sectors_kb = 64KB, and we set bs=256KB, the number of inflight
>> requests may reach to 64(if nr_request allow). So for user want to control
>> the number of inflight requests, bs should less than max_sectors_kb.
> 
> You have a point but that's very Linux platform specific information
> (then again so is the libaio warning so there's a precedent there
> already). Additionally, dependent on a device's I/O scheduler and its
> options etc. just because you submitted smaller blocks doesn't mean those
> I/Os won't be merged together thus the amount of requests inflight down to
> a device can still be different to what fio is submitting to the
> kernel. Further, there may also be different layers in the strack
> between userspace and the device that transform the I/Os (e.g. md RAID
> etc.) before they turn into device requests so there are lots of
> caveats.

I'm certain that this can happen on other platforms too, if the
application IO size is bigger than what the hardware can support.
The numbers that fio list are viewed from the application side,
an application has no real way of knowing what the depth on the
hardware side will be. This is true even if IOs aren't being
split, if an IO scheduler decides to limit the depth, for
example.

For most cases, the two numbers are roughly identical, however.
So stating that "the iodepth is not same as block device's inflight"
is misleading, as it will often be the same.

If anything, the documentation should just reflect that it's
application queue depth. That's platform agnostic.

-- 
Jens Axboe


