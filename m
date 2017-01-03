Return-Path: <axboe@kernel.dk>
Date: Mon, 2 Jan 2017 18:20:58 -0700
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: t/stest - OOM due to "smalloc bug, commit 271067a6"
Message-ID: <20170103012058.GC20992@kernel.dk>
References: <36842b7c-5273-70a8-ef12-c3e156982d52@bluestop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <36842b7c-5273-70a8-ef12-c3e156982d52@bluestop.org>
To: Rebecca Cran <rebecca@bluestop.org>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On Wed, Dec 21 2016, Rebecca Cran wrote:
> I don't remember seeing this before, but running t/stest reports an OOM
> condition just before finishing, due to the code:
> 
>         /* smalloc bug, commit 271067a6 */
>         do_specific_alloc(671386584);
> 
> Is that a regression, or is it expected?

It's expected with the current setup, I'll that check. Thanks for
letting me know.

-- 
Jens Axboe


