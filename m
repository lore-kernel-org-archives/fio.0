Return-Path: <m.eaton82@gmail.com>
MIME-Version: 1.0
In-Reply-To: <5462B6B0.3010003@kernel.dk>
References: <54627C44.3080909@kernel.dk>
	<CAF+0mv=H9cauEbP+CMCup0aLUD0qE42Jz9WPzboAv0U757acYw@mail.gmail.com>
	<5462B6B0.3010003@kernel.dk>
Date: Wed, 12 Nov 2014 13:36:20 -0800
Message-ID: <CAF+0mvmhzfzvbp_OnXUQ8eEUCuf+_wh5xuOROe=xFXqzuKytaw@mail.gmail.com>
Subject: Re: Fio 2.1.14 released
From: Matthew Eaton <m.eaton82@gmail.com>
Content-Type: text/plain; charset=UTF-8
To: Jens Axboe <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

> It should all be as fast as it could be before. The issue fixed above is
> when we wanted the disk util thread to exit, we set a done flag and just
> waited for it to wakeup as, which it did a few times per second. Now we use
> regular condvars, so it'll wake and exit immediately. So disk_util=0 should
> not change more than a msec or so :-)
>
> That said, if you do find things where it seems to start or stop slower than
> it should, let me know. But as far as I know, it's all properly driven now.
>
> --
> Jens Axboe
>

Thanks!  Just to follow up, I wrote a test script looping 20
iterations of fio and tested 2.1.12 vs 2.1.14.

2.1.14 consistently finished ~2.7 seconds faster than 2.1.12, which I
think is great for only 20 iterations.

Just for kicks, I also tried setting disk_util=0, but could not
conclude that it made any difference.

