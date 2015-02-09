Return-Path: <andrey.v.kuzmin@gmail.com>
MIME-Version: 1.0
In-Reply-To: <1423454000-7730-1-git-send-email-gwendal@chromium.org>
References: <1423454000-7730-1-git-send-email-gwendal@chromium.org>
From: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Date: Mon, 9 Feb 2015 13:39:11 +0400
Message-ID: <CANvN+emftqHL8e9NUyYvCQQbKPgxhOWsZNZvNgz-txgW-Qpkdg@mail.gmail.com>
Subject: Re: [PATCH] verify: Fix latency log for verify commands.
Content-Type: text/plain; charset=UTF-8
To: Gwendal Grignou <gwendal@chromium.org>
Cc: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On Mon, Feb 9, 2015 at 6:53 AM, Gwendal Grignou <gwendal@chromium.org> wrote:
> When commands when requeued for the verify operation,
> their start time was not reset, resulting in bogus latency graphs.

Does it really make sense to account for the verification pass in the
latency profile?

Regards,
Andrey

>
> Signed-off-by: Gwendal Grignou <gwendal@chromium.org>
> ---
>  backend.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/backend.c b/backend.c
> index 7ec8d2a..0f6e425 100644
> --- a/backend.c
> +++ b/backend.c
> @@ -565,6 +565,8 @@ static void do_verify(struct thread_data *td, uint64_t verify_bytes)
>                         io_u->end_io = verify_io_u;
>
>                 ddir = io_u->ddir;
> +               if (!td->o.disable_slat)
> +                       fio_gettime(&io_u->start_time, NULL);
>
>                 ret = td_io_queue(td, io_u);
>                 switch (ret) {
> --
> 2.2.0.rc0.207.ga3a616c
>
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

