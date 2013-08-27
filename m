Return-Path: <grundler@google.com>
MIME-Version: 1.0
Sender: grundler@google.com
In-Reply-To: <1377623232-3962-1-git-send-email-jcasse@chromium.org>
References: <1377623232-3962-1-git-send-email-jcasse@chromium.org>
Date: Tue, 27 Aug 2013 11:15:06 -0700
Message-ID: <CANEJEGuH6DWu3vwTSea8PteKfD8eaLMcp_z4rJ-PDhzdZayqqw@mail.gmail.com>
Subject: Re: [PATCH] Adds data_retention_check option.
From: Grant Grundler <grundler@chromium.org>
Content-Type: text/plain; charset=UTF-8
To: Juan Casse <jcasse@chromium.org>
Cc: Jens Axboe <axboe@kernel.dk>, Grant Grundler <grundler@chromium.org>, FIO_list <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On Tue, Aug 27, 2013 at 10:07 AM, Juan Casse <jcasse@chromium.org> wrote:
> This patch depends on the patch that adds check for numberio (patch 1).
> This option allows verification of data written to disk by a previous run
> of fio. This is accomplished by running the workload without actually
> writing to disk. So, the verify phase will be actually checking data
> alredy on disk previous to this run.
>
> Signed-off-by: Juan Casse <jcasse@chromium.org>
> Reviewed-by: Grant Grundler <grundler@chromium.org>
> ---
>  backend.c        | 3 ++-
>  engines/sync.c   | 8 ++++++--
>  init.c           | 8 +++++++-
>  options.c        | 9 +++++++++
>  thread_options.h | 1 +
>  5 files changed, 25 insertions(+), 4 deletions(-)
>
> diff --git a/backend.c b/backend.c
> index b9c1c12..6c0a794 100644
> --- a/backend.c
> +++ b/backend.c
> @@ -1340,7 +1340,8 @@ static void *thread_main(void *data)
>
>                 fio_gettime(&td->start, NULL);
>
> -               do_verify(td, verify_bytes);
> +               if (!o->data_retention_check || o->loops == 0)
> +                       do_verify(td, verify_bytes);
>
>                 td->ts.runtime[DDIR_READ] += utime_since_now(&td->start);
>
> diff --git a/engines/sync.c b/engines/sync.c
> index 1329946..e56db59 100644
> --- a/engines/sync.c
> +++ b/engines/sync.c
> @@ -125,8 +125,12 @@ static int fio_syncio_queue(struct thread_data *td, struct io_u *io_u)
>
>         if (io_u->ddir == DDIR_READ)
>                 ret = read(f->fd, io_u->xfer_buf, io_u->xfer_buflen);
> -       else if (io_u->ddir == DDIR_WRITE)
> -               ret = write(f->fd, io_u->xfer_buf, io_u->xfer_buflen);
> +       else if (io_u->ddir == DDIR_WRITE) {
> +               if (!td->o.data_retention_check)
> +                       ret = write(f->fd, io_u->xfer_buf, io_u->xfer_buflen);
> +               else
> +                       ret = io_u->xfer_buflen;
> +       }
>         else if (io_u->ddir == DDIR_TRIM) {
>                 do_io_u_trim(td, io_u);
>                 return FIO_Q_COMPLETED;
> diff --git a/init.c b/init.c
> index 8e2e1ae..fa2e6e2 100644
> --- a/init.c
> +++ b/init.c
> @@ -918,6 +918,12 @@ static char *make_filename(char *buf, struct thread_options *o,
>
>  int data_integrity_ini(struct thread_data *td)
>  {
> +       if (!td->o.data_integrity_check) {
> +               log_err("Option data_retention_check requires option "
> +                       "data_integrity_check\n");

This doesn't need to be an error. Just set data_integrity_check option
and continue.

> +               return 1;
> +       }
> +
>         if (td->o.td_ddir != TD_DDIR_WRITE &&
>                 td->o.td_ddir != TD_DDIR_RW &&
>                 td->o.td_ddir != TD_DDIR_RANDRW &&
> @@ -973,7 +979,7 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num,
>                 return 0;
>         }
>
> -       if (o->data_integrity_check)
> +       if (o->data_integrity_check || o->data_retention_check)
>                 if (data_integrity_ini(td))
>                         goto err;
>
> diff --git a/options.c b/options.c
> index 569cdf7..e5ca3cb 100644
> --- a/options.c
> +++ b/options.c
> @@ -1944,6 +1944,15 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
>                 .group  = FIO_OPT_G_RUNTIME,
>         },
>         {
> +               .name   = "data_retention_check",
> +               .lname  = "Data retention check",
> +               .type   = FIO_OPT_STR_SET,
> +               .off1   = td_var_offset(data_retention_check),
> +               .help   = "Executes workload without actually writing data",

Hrm...this might be better for help:
"Verifies previously written data is still valid."

Can you make the two changes and resend the patch with "V2" in the subject line?

thanks,
grant

> +               .category = FIO_OPT_C_GENERAL,
> +               .group  = FIO_OPT_G_RUNTIME,
> +       },
> +       {
>                 .name   = "ramp_time",
>                 .lname  = "Ramp time",
>                 .type   = FIO_OPT_STR_VAL_TIME,
> diff --git a/thread_options.h b/thread_options.h
> index 8666cd1..1bcae7a 100644
> --- a/thread_options.h
> +++ b/thread_options.h
> @@ -108,6 +108,7 @@ struct thread_options {
>         unsigned int bs_is_seq_rand;
>
>         unsigned int data_integrity_check;
> +       unsigned int data_retention_check;
>
>         unsigned int random_distribution;
>
> --
> 1.7.12.4
>

