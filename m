Return-Path: <tai@rakugaki.org>
MIME-Version: 1.0
In-Reply-To: <4E71DD1C.1060708@kernel.dk>
References: <4E69A048.6050509@rakugaki.org> <4E69D04E.3090705@kernel.dk>
 <CAM8qCPLxw2zSS1tQudnurDSMZcugrc_Cf=9MLfK2D_RphmMn9A@mail.gmail.com> <4E71DD1C.1060708@kernel.dk>
From: Taisuke Yamada <tai@rakugaki.org>
Date: Thu, 15 Sep 2011 20:52:56 +0900
Message-ID: <CAM8qCPJf0abNa=Lba73=7rASPOrf=iCmcPb3jCBZDstSE6AoHw@mail.gmail.com>
Subject: Re: [PATCH 1/2] Added replay_rebase option to run multi-threaded log
 replay on different disk sectors.
Content-Type: text/plain; charset=ISO-8859-1
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

>> I believe #2 patch is also worth adding to fio, but not sure if I should make
>> it optional feature (/w doc) or not. By wraparounding offset address, it'll
>> probably make benchmark result look better than actual for rotational disk
>> drives. OTOH, it's better than failing to run just because trace-generating
>> device was larger than replaying device.
>
> I worry about the 2nd patch, it's a bit of a hack. You could make it an
> option and turn it on unconditionally for replay_rebase, or at least
> make it conditional on that.

Sure. I'll make it an option ("wraparound=bool"), and submit one as well as #1.

