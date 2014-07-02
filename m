Return-Path: <yyalex.wang@gmail.com>
MIME-Version: 1.0
In-Reply-To: <53B462A3.8050402@kernel.dk>
References: <CANyhEAuqB4Q2XphsGpn3FcGFhr02D2etUZBaD7j9w20Y44JXVg@mail.gmail.com>
	<53B462A3.8050402@kernel.dk>
Date: Wed, 2 Jul 2014 16:36:17 -0400
Message-ID: <CANyhEAvWNUonhYj1rpDP=o4g4199o1tZY-Oz=1qQJMFQEPpwGw@mail.gmail.com>
Subject: Re: multiple block devices question
From: "Yuyang (Alex) Wang" <yyalex.wang@gmail.com>
Content-Type: text/plain; charset=UTF-8
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

Jens, thanks for the reply.

I also tried the following as the HOWTO suggested, and getting similar results
[devices]
filename=/dev/mapper/raid0:/dev/mapper/raid1


This may be silly part on me misreading the manual, what's correct way
of specifying multiple devices?

thanks

Alex





On Wed, Jul 2, 2014 at 3:50 PM, Jens Axboe <axboe@kernel.dk> wrote:
> On 07/02/2014 01:42 PM, Yuyang (Alex) Wang wrote:
>> hi all,
>>
>> I am using FIO (2.1.7) to profile block level performance of multiple
>> RAID devices. (see config file below). The test is done on a capable
>> 16-core server. With a sigle raid device, I am getting roughly
>> 1.4GB/s, with two devices in place, I am still getting around 1.4GB/s,
>> which is weird. Another in-house developed benchmark tool, running
>> SINGLE-thread suggested we can almost double. I could get double the
>> performance through FIO by configuring two jobs, with each job
>> handling one device only. However, it still puzzles me as to why a
>> single process FIO can't drive the performance of two devices. Did I
>> do anything wrong as to the configure file?
>>
>> Thanks
>>
>> Alex.
>>
>>
>> [globals]
>>
>> rw=write
>> ioengine=libaio
>> iodepth=16
>> direct=1
>> blocksize=1m
>> runtime=30
>>
>> [devices]
>> filename=/dev/mapper/raid-0
>> filename=/dev/mapper/raid-1
>
> You are overwriting filename here, hence running with just one device.
>
> --
> Jens Axboe
>

