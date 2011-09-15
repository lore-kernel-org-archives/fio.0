Return-Path: <fio-owner@vger.kernel.org>
Received: from 87-104-106-3-dynamic-customer.profibernet.dk ([87.104.106.3]:48903
	"EHLO kernel.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933075Ab1IOLmJ (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 15 Sep 2011 07:42:09 -0400
Message-ID: <4E71E48E.30104@kernel.dk>
Date: Thu, 15 Sep 2011 13:42:06 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [PATCH 1/2] Added replay_rebase option to run multi-threaded
 log replay on different disk sectors.
References: <4E69A048.6050509@rakugaki.org> <4E69D04E.3090705@kernel.dk> <CAM8qCPLxw2zSS1tQudnurDSMZcugrc_Cf=9MLfK2D_RphmMn9A@mail.gmail.com> <4E71DE1B.4010800@kernel.dk> <CAM8qCP+ybHOmenoutbdRfZgGZ2keyVF6TOz3v+ib-1YRW+4Lcg@mail.gmail.com>
In-Reply-To: <CAM8qCP+ybHOmenoutbdRfZgGZ2keyVF6TOz3v+ib-1YRW+4Lcg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Taisuke Yamada <tai@rakugaki.org>
Cc: fio@vger.kernel.org

On 2011-09-15 13:40, Taisuke Yamada wrote:
>> On patch 1, I don't know, it seems a bit weird to me. The fact that the
>> option offset is multiplied by the job number makes sense for ease of
>> handling job files (since you can just do numjobs=X and be done with
>> it), but logically it's odd since you have to know that they are
>> numbered sequentially and do the math to see where it ends up on the
>> disk.
>>
>> What is the intended use case for this? I'd much rather see the offset
>> be absolute, at the cost of a bit more complex job file.
> 
> My intention (and usecase) is just to put more replay I/O load, so
> multiplication is purely for ease of use. So yes, I can live perfectly
> fine with per-thread(job) absolute offset configuration.
> In fact, it may be better as offset can be chosen to access disk more
> evenly/randomly.
> 
> Do you want me to submit a new patch without multiplication?

Yeah, please do one without the multiplier and I guess we can put it in.

-- 
Jens Axboe

