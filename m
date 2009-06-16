Return-Path: <fio-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:60437 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751121AbZFPGaU (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 16 Jun 2009 02:30:20 -0400
Date: Tue, 16 Jun 2009 08:30:22 +0200
From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Alter the order of checking time exceeded vs getting an io_u
Message-ID: <20090616063022.GJ11363@kernel.dk>
References: <66dfd3fe0906151618r472be916ubfb771d714cc851f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <66dfd3fe0906151618r472be916ubfb771d714cc851f@mail.gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Radha Ramachandran <radha@google.com>
Cc: fio@vger.kernel.org

On Mon, Jun 15 2009, Radha Ramachandran wrote:
> Hi,
> I was hitting a case where fio would loop for ever even though the
> runtime was exceeded if it had difficulty getting the io_u struct, so
> I suggest this change to the code so it wld not loop forever:

Looks sane, applied. Thanks!

> 
> >git diff
> diff --git a/fio.c b/fio.c
> index bb26062..4927f1c 100644
> --- a/fio.c
> +++ b/fio.c
> @@ -442,18 +442,17 @@ static void do_verify(struct thread_data *td)
>         while (!td->terminate) {
>                 int ret2, full;
> 
> -               io_u = __get_io_u(td);
> -               if (!io_u)
> -                       break;
> -
>                 update_tv_cache(td);
> 
>                 if (runtime_exceeded(td, &td->tv_cache)) {
> -                       put_io_u(td, io_u);
>                         td->terminate = 1;
>                         break;
>                 }
> 
> +               io_u = __get_io_u(td);
> +               if (!io_u)
> +                       break;
> +
>                 if (get_next_verify(td, io_u)) {
>                         put_io_u(td, io_u);
>                         break;
> @@ -580,18 +579,17 @@ static void do_io(struct thread_data *td)
>                 if (td->terminate)
>                         break;
> 
> -               io_u = get_io_u(td);
> -               if (!io_u)
> -                       break;
> -
>                 update_tv_cache(td);
> 
>                 if (runtime_exceeded(td, &td->tv_cache)) {
> -                       put_io_u(td, io_u);
>                         td->terminate = 1;
>                         break;
>                 }
> 
> +               io_u = get_io_u(td);
> +               if (!io_u)
> +                       break;
> +
>                 /*
>                  * Add verification end_io handler, if asked to verify
>                  * a previously written file.
> 
> 
> thanks
> -radha
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Jens Axboe

