Return-Path: <jmoyer@redhat.com>
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: multiple block devices question
References: <CANyhEAuqB4Q2XphsGpn3FcGFhr02D2etUZBaD7j9w20Y44JXVg@mail.gmail.com>
	<53B462A3.8050402@kernel.dk>
	<CANyhEAvWNUonhYj1rpDP=o4g4199o1tZY-Oz=1qQJMFQEPpwGw@mail.gmail.com>
Date: Thu, 03 Jul 2014 14:12:23 -0400
In-Reply-To: <CANyhEAvWNUonhYj1rpDP=o4g4199o1tZY-Oz=1qQJMFQEPpwGw@mail.gmail.com>
	(Yuyang Wang's message of "Wed, 2 Jul 2014 16:36:17 -0400")
Message-ID: <x49k37uwbug.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
To: "Yuyang (Alex) Wang" <yyalex.wang@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

"Yuyang (Alex) Wang" <yyalex.wang@gmail.com> writes:

> Jens, thanks for the reply.
>
> I also tried the following as the HOWTO suggested, and getting similar results
> [devices]
> filename=/dev/mapper/raid0:/dev/mapper/raid1
>
>
> This may be silly part on me misreading the manual, what's correct way
> of specifying multiple devices?

That looks ok to me.  What happens if you double your queue depth?

Cheers,
Jeff

