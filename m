Return-Path: <fio-owner@vger.kernel.org>
Received: from 87-104-106-3-dynamic-customer.profibernet.dk ([87.104.106.3]:48796
	"EHLO kernel.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933075Ab1IOLKV (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 15 Sep 2011 07:10:21 -0400
Message-ID: <4E71DD1C.1060708@kernel.dk>
Date: Thu, 15 Sep 2011 13:10:20 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [PATCH 1/2] Added replay_rebase option to run multi-threaded
 log replay on different disk sectors.
References: <4E69A048.6050509@rakugaki.org> <4E69D04E.3090705@kernel.dk> <CAM8qCPLxw2zSS1tQudnurDSMZcugrc_Cf=9MLfK2D_RphmMn9A@mail.gmail.com>
In-Reply-To: <CAM8qCPLxw2zSS1tQudnurDSMZcugrc_Cf=9MLfK2D_RphmMn9A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Taisuke Yamada <tai@rakugaki.org>
Cc: fio@vger.kernel.org

On 2011-09-15 08:23, Taisuke Yamada wrote:
>>> [snip], I added "replay_rebase" option to shift offset of IO request for
>>> each thread.
>>
>> Thanks, I can see this being handy. I can apply this, but I would much
>> prefer if you resend it with the proper updates to HOWTO and fio.1
>> adding the new option. Otherwise nobody is going to learn about it.
> 
> Just in case you have missed (I had to break In-Reply-To chain as git
> format-patch did not respect it). I'm re-posting updated patch with docs.
> Please apply #1 and #2 if it seems acceptable.
> 
> I believe #2 patch is also worth adding to fio, but not sure if I should make
> it optional feature (/w doc) or not. By wraparounding offset address, it'll
> probably make benchmark result look better than actual for rotational disk
> drives. OTOH, it's better than failing to run just because trace-generating
> device was larger than replaying device.

I worry about the 2nd patch, it's a bit of a hack. You could make it an
option and turn it on unconditionally for replay_rebase, or at least
make it conditional on that.

-- 
Jens Axboe

