Return-Path: <yufei.ren@stonybrook.edu>
MIME-Version: 1.0
In-Reply-To: <5084FDFE.20208@kernel.dk>
References: <1350702712-5168-1-git-send-email-yufei.ren@stonybrook.edu>
 <1350702712-5168-3-git-send-email-yufei.ren@stonybrook.edu> <5084FDFE.20208@kernel.dk>
From: Yufei Ren <yufei.ren@stonybrook.edu>
Date: Mon, 22 Oct 2012 12:33:02 -0400
Message-ID: <CAG5pYQdz1TxMDVTaBmL0iOhztRdQL9Y4jQMNinXGwqXqh_6_dQ@mail.gmail.com>
Subject: Re: [PATCH 2/4] thread cpu resource statistics bug fix
Content-Type: text/plain; charset=ISO-8859-1
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

Hi Jens,

>
> I applied this, but I wonder if we should not just make this dependent
> on
>
> #ifdef RUSAGE_THREAD
> ...
> #endif
>
> instead?
>

Yes, that would more clear. Should I send you another patch instead of this?

Thanks

Yufei

> --
> Jens Axboe
>

