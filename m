Return-Path: <grundler@google.com>
MIME-Version: 1.0
Sender: grundler@google.com
In-Reply-To: <521CDB91.40207@kernel.dk>
References: <1377552162-31741-1-git-send-email-jcasse@chromium.org>
	<1377552162-31741-2-git-send-email-jcasse@chromium.org>
	<CANEJEGuKzZeLfCoNX12Pp_4_Uj8iHjLX221c+qpYzgpWYgA-Pg@mail.gmail.com>
	<521CDB91.40207@kernel.dk>
Date: Tue, 27 Aug 2013 10:25:34 -0700
Message-ID: <CANEJEGsDcnk51B=1ALR8vVQm+-nu2n8XmR9+wuc57GK-M8WR6Q@mail.gmail.com>
Subject: Re: [PATCH 2/2] Adds check for rand_seed during verify phase.
From: Grant Grundler <grundler@chromium.org>
Content-Type: text/plain; charset=UTF-8
To: Jens Axboe <axboe@kernel.dk>
Cc: Grant Grundler <grundler@chromium.org>, Juan Casse <jcasse@chromium.org>, FIO_list <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On Tue, Aug 27, 2013 at 10:02 AM, Jens Axboe <axboe@kernel.dk> wrote:
...
> Right now fio will return EILSEQ for any verification failure. If you
> time out, then no, you should not get that. If we do more fine grained
> errors for verify failures, then we would have to get creative on what
> to use. And not sure I'm a huge fan of that.

I'm not a fan of that either since it's "open ended". Using EILSEQ is
probably fine.

> If you do get a
> verification failure, though, at least the runtime log should tell you
> EXACTLY what it was.

Ah ok - I didn't think of that and the test can look there to
disambiguate the return code.

thanks!
grant

