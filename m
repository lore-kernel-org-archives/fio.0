Return-Path: <yyalex.wang@gmail.com>
MIME-Version: 1.0
In-Reply-To: <53B596CA.9010407@nellans.org>
References: <CANyhEAuqB4Q2XphsGpn3FcGFhr02D2etUZBaD7j9w20Y44JXVg@mail.gmail.com>
	<53B462A3.8050402@kernel.dk>
	<CANyhEAvWNUonhYj1rpDP=o4g4199o1tZY-Oz=1qQJMFQEPpwGw@mail.gmail.com>
	<A7A1D348E34E024BBC74480FB93A2EAB1089E003@DAGN05A-E6.exg6.exghost.com>
	<CANyhEAuEDLvwdShA4gXoP_6_sHdEs-b7PSGymp6=H_5Bms349g@mail.gmail.com>
	<53B596CA.9010407@nellans.org>
Date: Thu, 3 Jul 2014 13:52:10 -0400
Message-ID: <CANyhEAvgdMTOhWSv_CGEudZjfPjYJgzh8d+SrWW7XkdHWie4pQ@mail.gmail.com>
Subject: Re: multiple block devices question
From: "Yuyang (Alex) Wang" <yyalex.wang@gmail.com>
Content-Type: text/plain; charset=UTF-8
To: David Nellans <david@nellans.org>
Cc: Carl Zwanzig <cpz@coraid.com>, Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

I get it and agree with you that FIO shouldn't be the limiting factor,
but I don't get it why I am not getting sensible numbers when I
increase the number of devices. Apparently, I am only interested in
actual throughput FIO can drive my raid array, rather than ramdisk in
this case.

Thanks

A.

On Thu, Jul 3, 2014 at 1:45 PM, David Nellans <david@nellans.org> wrote:
> On 07/03/2014 12:28 PM, Yuyang (Alex) Wang wrote:
>>
>> Carl,
>>
>> Specifying them as separate jobs will do what I expect. However, in
>> this case, I am seeking to know how much performance and how many
>> devices can a __single__ FIO process can drive. If my above
>> configuration is correct, then, for some reason, the single process
>> doesn't increase with more devices at its disposal, not as I have seen
>> from another benchmark tool - which is puzzling. I am curious to
>> understand why.
>>
>> Best,
>>
>> A.
>
> If you want to benchmark fio throughput or the block layer, not your actual
> raid array,
> then use a ramdisk.  There are lots of flash devices out there now which
> will push far
> more than 1.4GB/s from a single device,  rest assured fio isn't your
> limitation here.
> 1.4 GB/s with 1M block sizes isn't even 2k IOPS.  fio pushes 500k IOPS
> through the block layer
> without issue, its not your limiting factor.

