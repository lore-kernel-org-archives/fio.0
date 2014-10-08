Return-Path: <axboe@kernel.dk>
Message-ID: <5435460A.1040902@kernel.dk>
Date: Wed, 08 Oct 2014 08:11:22 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Recent changes (master)
References: <20141008120003.6C0CC40162@lyth.info> <CANvN+em8Eit_FG_S7QXh+Meej1dvmUKCGC+tsZtCz48BwF1yrw@mail.gmail.com>
In-Reply-To: <CANvN+em8Eit_FG_S7QXh+Meej1dvmUKCGC+tsZtCz48BwF1yrw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 10/08/2014 07:52 AM, Andrey Kuzmin wrote:
> Recent libaio fix could be further strengthened with the following
> addition that addresses a latent tight loop bug on zero events being
> returned:
> 
> index 7c3a42a..7760fb8 100644
> --- a/engines/libaio.c
> +++ b/engines/libaio.c
> @@ -165,9 +165,9 @@ static int fio_libaio_getevents(struct thread_data
> *td, unsigned int min,
>                         r = io_getevents(ld->aio_ctx, actual_min,
>                                 max, ld->aio_events + events, lt);
>                 }
> -               if (r >= 0)
> +               if (r > 0)
>                         events += r;
> -               else if (r == -EAGAIN) {
> +               else if (r == 0 || r == -EAGAIN) {
>                         fio_libaio_commit(td);
>                         usleep(100);
>                 } else if (r != -EINTR)

This will break min == 0 being passed in, for the opportunistic check.
We don't want to commit/sleep for that case.

-- 
Jens Axboe


