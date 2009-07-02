Return-Path: <fio-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:52618 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750849AbZGBG27 (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 2 Jul 2009 02:28:59 -0400
Date: Thu, 2 Jul 2009 08:29:02 +0200
From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Fix issue related to continue_on_error option
Message-ID: <20090702062901.GM23611@kernel.dk>
References: <66dfd3fe0907011829i50ac24b3s787f33c77287a7d9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <66dfd3fe0907011829i50ac24b3s787f33c77287a7d9@mail.gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Radha Ramachandran <radha@google.com>
Cc: fio@vger.kernel.org

On Wed, Jul 01 2009, Radha Ramachandran wrote:
> Hi,
> I added a change so when both the continue_on_error and fill_device
> option is on, when it hits ENOSPC issue the code ignores the error.
> 
> >git diff
> diff --git a/fio.c b/fio.c
> index fa5deab..3365bb1 100644
> --- a/fio.c
> +++ b/fio.c
> @@ -388,21 +388,29 @@ static int break_on_this_error(struct
> thread_data *td, int *retptr)
>                 else
>                         err = td->error;
> 
> -               update_error_count(td, err);
> -
>                 if (td_non_fatal_error(err)) {
>                         /*
>                          * Continue with the I/Os in case of
>                          * a non fatal error.
>                          */
> +                       update_error_count(td, err);
>                         td_clear_error(td);
>                         *retptr = 0;
>                         return 0;
> +               } else if (td->o.fill_device && err == ENOSPC) {
> +                       /*
> +                        * We expect to hit this error if
> +                        * fill_device option is set.
> +                        */
> +                       td_clear_error(td);
> +                       td->terminate = 1;
> +                       return 1;
>                 } else {
>                         /*
>                          * Stop the I/O in case of a fatal
>                          * error.
>                          */
> +                       update_error_count(td, err);
>                         return 1;
>                 }
>         }

Looks good, applied. Thanks!

-- 
Jens Axboe

