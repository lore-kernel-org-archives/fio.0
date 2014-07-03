Return-Path: <yyalex.wang@gmail.com>
MIME-Version: 1.0
In-Reply-To: <abec717a9a75459bb62620bddd00e424@BLUPR02MB453.namprd02.prod.outlook.com>
References: <CANyhEAuqB4Q2XphsGpn3FcGFhr02D2etUZBaD7j9w20Y44JXVg@mail.gmail.com>
	<53B462A3.8050402@kernel.dk>
	<CANyhEAvWNUonhYj1rpDP=o4g4199o1tZY-Oz=1qQJMFQEPpwGw@mail.gmail.com>
	<x49k37uwbug.fsf@segfault.boston.devel.redhat.com>
	<abec717a9a75459bb62620bddd00e424@BLUPR02MB453.namprd02.prod.outlook.com>
Date: Thu, 3 Jul 2014 14:31:18 -0400
Message-ID: <CANyhEAvw0oB2563q=xETKtWSXvieT9PeTBQF-FqdBzHy4wvWCA@mail.gmail.com>
Subject: Re: multiple block devices question
From: "Yuyang (Alex) Wang" <yyalex.wang@gmail.com>
Content-Type: text/plain; charset=UTF-8
To: "Hinson, Roger" <Roger_Hinson@intuit.com>
Cc: Jeff Moyer <jmoyer@redhat.com>, Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

Kudos Roger, that solves the problem.
I didn't realize one release behind, the filename parsing has this bug in it.

Thanks!

A.

On Thu, Jul 3, 2014 at 2:21 PM, Hinson, Roger <Roger_Hinson@intuit.com> wrote:
> It doesn't work properly with 2.1.7.  it only grabs the first name in filename.  I switched to 2.1.10 to fix that problem for me.
>
> Roger
>
>
> -----Original Message-----
> From: fio-owner@vger.kernel.org [mailto:fio-owner@vger.kernel.org] On Behalf Of Jeff Moyer
> Sent: Thursday, July 03, 2014 11:12 AM
> To: Yuyang (Alex) Wang
> Cc: Jens Axboe; fio@vger.kernel.org
> Subject: Re: multiple block devices question
>
> "Yuyang (Alex) Wang" <yyalex.wang@gmail.com> writes:
>
>> Jens, thanks for the reply.
>>
>> I also tried the following as the HOWTO suggested, and getting similar
>> results [devices]
>> filename=/dev/mapper/raid0:/dev/mapper/raid1
>>
>>
>> This may be silly part on me misreading the manual, what's correct way
>> of specifying multiple devices?
>
> That looks ok to me.  What happens if you double your queue depth?
>
> Cheers,
> Jeff
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in the body of a message to majordomo@vger.kernel.org More majordomo info at  http://vger.kernel.org/majordomo-info.html

