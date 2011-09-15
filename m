Return-Path: <tai@rakugaki.org>
MIME-Version: 1.0
In-Reply-To: <4E71DE1B.4010800@kernel.dk>
References: <4E69A048.6050509@rakugaki.org> <4E69D04E.3090705@kernel.dk>
 <CAM8qCPLxw2zSS1tQudnurDSMZcugrc_Cf=9MLfK2D_RphmMn9A@mail.gmail.com> <4E71DE1B.4010800@kernel.dk>
From: Taisuke Yamada <tai@rakugaki.org>
Date: Thu, 15 Sep 2011 20:40:58 +0900
Message-ID: <CAM8qCP+ybHOmenoutbdRfZgGZ2keyVF6TOz3v+ib-1YRW+4Lcg@mail.gmail.com>
Subject: Re: [PATCH 1/2] Added replay_rebase option to run multi-threaded log
 replay on different disk sectors.
Content-Type: text/plain; charset=ISO-8859-1
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

> On patch 1, I don't know, it seems a bit weird to me. The fact that the
> option offset is multiplied by the job number makes sense for ease of
> handling job files (since you can just do numjobs=X and be done with
> it), but logically it's odd since you have to know that they are
> numbered sequentially and do the math to see where it ends up on the
> disk.
>
> What is the intended use case for this? I'd much rather see the offset
> be absolute, at the cost of a bit more complex job file.

My intention (and usecase) is just to put more replay I/O load, so
multiplication is purely for ease of use. So yes, I can live perfectly
fine with per-thread(job) absolute offset configuration.
In fact, it may be better as offset can be chosen to access disk more
evenly/randomly.

Do you want me to submit a new patch without multiplication?

