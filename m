Return-Path: <Roger_Hinson@intuit.com>
From: "Hinson, Roger" <Roger_Hinson@intuit.com>
Subject: RE: multiple block devices question
Date: Thu, 3 Jul 2014 18:21:58 +0000
Message-ID: <abec717a9a75459bb62620bddd00e424@BLUPR02MB453.namprd02.prod.outlook.com>
References: <CANyhEAuqB4Q2XphsGpn3FcGFhr02D2etUZBaD7j9w20Y44JXVg@mail.gmail.com>
	<53B462A3.8050402@kernel.dk>
	<CANyhEAvWNUonhYj1rpDP=o4g4199o1tZY-Oz=1qQJMFQEPpwGw@mail.gmail.com>
 <x49k37uwbug.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x49k37uwbug.fsf@segfault.boston.devel.redhat.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Return-Path: Roger_Hinson@intuit.com
To: Jeff Moyer <jmoyer@redhat.com>, "Yuyang (Alex) Wang" <yyalex.wang@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

It doesn't work properly with 2.1.7.  it only grabs the first name in filen=
ame.  I switched to 2.1.10 to fix that problem for me.

Roger


-----Original Message-----
From: fio-owner@vger.kernel.org [mailto:fio-owner@vger.kernel.org] On Behal=
f Of Jeff Moyer
Sent: Thursday, July 03, 2014 11:12 AM
To: Yuyang (Alex) Wang
Cc: Jens Axboe; fio@vger.kernel.org
Subject: Re: multiple block devices question

"Yuyang (Alex) Wang" <yyalex.wang@gmail.com> writes:

> Jens, thanks for the reply.
>
> I also tried the following as the HOWTO suggested, and getting similar=20
> results [devices]
> filename=3D/dev/mapper/raid0:/dev/mapper/raid1
>
>
> This may be silly part on me misreading the manual, what's correct way=20
> of specifying multiple devices?

That looks ok to me.  What happens if you double your queue depth?

Cheers,
Jeff
--
To unsubscribe from this list: send the line "unsubscribe fio" in the body =
of a message to majordomo@vger.kernel.org More majordomo info at  http://vg=
er.kernel.org/majordomo-info.html

