Return-Path: <axboe@kernel.dk>
Message-ID: <543740CF.3000501@kernel.dk>
Date: Thu, 09 Oct 2014 20:13:35 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Recent changes (master)
References: <20141008120003.6C0CC40162@lyth.info> <CANvN+em8Eit_FG_S7QXh+Meej1dvmUKCGC+tsZtCz48BwF1yrw@mail.gmail.com> <5435460A.1040902@kernel.dk> <CANvN+e=nN=a4rBtPMEfKk802fzMZUTgc9Prt5sVE09+LpH2Gvw@mail.gmail.com>
In-Reply-To: <CANvN+e=nN=a4rBtPMEfKk802fzMZUTgc9Prt5sVE09+LpH2Gvw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 2014-10-09 09:20, Andrey Kuzmin wrote:
> And how about this one?
>
> index 7c3a42a..12f3b36 100644
> --- a/engines/libaio.c
> +++ b/engines/libaio.c
> @@ -165,9 +165,9 @@ static int fio_libaio_getevents(struct thread_data
> *td, unsigned int min,
>                          r = io_getevents(ld->aio_ctx, actual_min,
>                                  max, ld->aio_events + events, lt);
>                  }
> -               if (r >= 0)
> +               if (r > 0)
>                          events += r;
> -               else if (r == -EAGAIN) {
> +               else if ((min && r == 0) || r == -EAGAIN) {
>                          fio_libaio_commit(td);
>                          usleep(100);
>                  } else if (r != -EINTR)

Yeah, this looks better.

-- 
Jens Axboe


