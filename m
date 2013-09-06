Return-Path: <jcasse@google.com>
MIME-Version: 1.0
In-Reply-To: <5229EACA.7090009@kernel.dk>
References: <1378437152-11128-1-git-send-email-jcasse@chromium.org>
	<5229EACA.7090009@kernel.dk>
Date: Fri, 6 Sep 2013 16:31:55 -0700
Message-ID: <CAPet_21-oPZ2bEQw_Uwq2GdM4T5HNUcN2eqTPifqRpCSEE-_cA@mail.gmail.com>
Subject: Re: [PATCH] Adds verify_only option.
From: Juan Casse <jcasse@google.com>
Content-Type: text/plain; charset=ISO-8859-1
To: Jens Axboe <axboe@kernel.dk>
Cc: Juan Casse <jcasse@chromium.org>, Grant Grundler <grundler@chromium.org>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On Fri, Sep 6, 2013 at 7:46 AM, Jens Axboe <axboe@kernel.dk> wrote:
...
> Please take a look at how this is done for the experimental_verify. The
> writes are skipped much sooner and generically, there's no need to
> enforce any sort of specific IO engine or verify type.

From your reply I understood that you want to skip do_io() all
together and call a function that will somehow replicate the workload
and compute the numberio for each block. Is that what you meant?

My patch uses do_io() to initialize the vhdr_meta data structures. I
can try to replicate that in do_verify() instead, but that seems more
fragile.

Juan

