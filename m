Return-Path: <yyalex.wang@gmail.com>
MIME-Version: 1.0
In-Reply-To: <A7A1D348E34E024BBC74480FB93A2EAB1089E003@DAGN05A-E6.exg6.exghost.com>
References: <CANyhEAuqB4Q2XphsGpn3FcGFhr02D2etUZBaD7j9w20Y44JXVg@mail.gmail.com>
	<53B462A3.8050402@kernel.dk>
	<CANyhEAvWNUonhYj1rpDP=o4g4199o1tZY-Oz=1qQJMFQEPpwGw@mail.gmail.com>
	<A7A1D348E34E024BBC74480FB93A2EAB1089E003@DAGN05A-E6.exg6.exghost.com>
Date: Thu, 3 Jul 2014 13:28:20 -0400
Message-ID: <CANyhEAuEDLvwdShA4gXoP_6_sHdEs-b7PSGymp6=H_5Bms349g@mail.gmail.com>
Subject: Re: multiple block devices question
From: "Yuyang (Alex) Wang" <yyalex.wang@gmail.com>
Content-Type: text/plain; charset=UTF-8
To: Carl Zwanzig <cpz@coraid.com>
Cc: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

Carl,

Specifying them as separate jobs will do what I expect. However, in
this case, I am seeking to know how much performance and how many
devices can a __single__ FIO process can drive. If my above
configuration is correct, then, for some reason, the single process
doesn't increase with more devices at its disposal, not as I have seen
from another benchmark tool - which is puzzling. I am curious to
understand why.

Best,

A.

On Wed, Jul 2, 2014 at 7:38 PM, Carl Zwanzig <cpz@coraid.com> wrote:
>> From: fio-owner@vger.kernel.org [mailto:fio-owner@vger.kernel.org] On
>> Behalf Of Yuyang (Alex) Wang
>> Sent: Wednesday, July 02, 2014 1:36 PM
>
>> I also tried the following as the HOWTO suggested, and getting similar
>> results
>> [devices]
>> filename=/dev/mapper/raid0:/dev/mapper/raid1
>
> I specify them as separate jobs:
> [devices0]
> filename=/dev/mapper/raid0
> [devices1]
> filename=/dev/mapper/raid1
>
> without the "stonewall" directive, the jobs will run simultaneously.
>
> z!
>

