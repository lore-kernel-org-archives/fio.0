Return-Path: <fio-owner@vger.kernel.org>
Received: from 87-104-106-3-dynamic-customer.profibernet.dk ([87.104.106.3]:48808
	"EHLO kernel.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933264Ab1IOLOg (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 15 Sep 2011 07:14:36 -0400
Message-ID: <4E71DE1B.4010800@kernel.dk>
Date: Thu, 15 Sep 2011 13:14:35 +0200
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

On patch 1, I don't know, it seems a bit weird to me. The fact that the
option offset is multiplied by the job number makes sense for ease of
handling job files (since you can just do numjobs=X and be done with
it), but logically it's odd since you have to know that they are
numbered sequentially and do the math to see where it ends up on the
disk.

What is the intended use case for this? I'd much rather see the offset
be absolute, at the cost of a bit more complex job file.

-- 
Jens Axboe

