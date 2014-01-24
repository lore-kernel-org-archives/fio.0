Return-Path: <grundler@google.com>
MIME-Version: 1.0
Sender: grundler@google.com
In-Reply-To: <1379451974-16100-3-git-send-email-jcasse@chromium.org>
References: <1379451974-16100-1-git-send-email-jcasse@chromium.org>
	<1379451974-16100-3-git-send-email-jcasse@chromium.org>
Date: Fri, 24 Jan 2014 10:35:02 -0800
Message-ID: <CANEJEGsmLgT7dtVQ90EfTDZs-QtLrHGeq-9qeCRGJuqwP5y4zg@mail.gmail.com>
Subject: Re: [PATCH] Adds check for rand_seed during verify phase.
From: Grant Grundler <grundler@chromium.org>
Content-Type: text/plain; charset=UTF-8
To: Juan Casse <jcasse@chromium.org>
Cc: Jens Axboe <axboe@kernel.dk>, Grant Grundler <grundler@chromium.org>, FIO_list <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

Jens,
Ping?

Still able to integrate this patch?

thanks,
grant

On Tue, Sep 17, 2013 at 2:06 PM, Juan Casse <jcasse@chromium.org> wrote:
> Improve data integrity checking of header (meta) data.
> verify_header() will now return an additional error:
> "verify: bad header rand seed ..."
> The addition of the check of rand_seed helps detect stale data from
> previous fio runs.
> This patch also disambiguates the different data mismatches by returning
> different error codes from verify_header().
>
> Signed-off-by: Juan Casse <jcasse@chromium.org>
> Reviewed-by: Grant Grundler <grundler@chromium.org>
> ---
>  verify.c | 45 ++++++++++++++++++++++++++++++++++++---------
>  1 file changed, 36 insertions(+), 9 deletions(-)
>
> diff --git a/verify.c b/verify.c
> index 9e88d61..957613c 100644
> --- a/verify.c
> +++ b/verify.c
> @@ -644,18 +644,17 @@ static int verify_header(struct io_u *io_u, struct verify_header *hdr)
>         uint32_t crc;
>
>         if (hdr->magic != FIO_HDR_MAGIC)
> -               return 0;
> -       if (hdr->len > io_u->buflen) {
> -               log_err("fio: verify header exceeds buffer length (%u > %lu)\n", hdr->len, io_u->buflen);
> -               return 0;
> -       }
> +               return 1;
> +       if (hdr->len > io_u->buflen)
> +               return 2;
> +       if (hdr->rand_seed != io_u->rand_seed)
> +               return 3;
>
>         crc = fio_crc32c(p, offsetof(struct verify_header, crc32));
>         if (crc == hdr->crc32)
> -               return 1;
> -
> +               return 0;
>         log_err("fio: verify header crc %x, calculated %x\n", hdr->crc32, crc);
> -       return 0;
> +       return 4;
>  }
>
>  int verify_io_u(struct thread_data *td, struct io_u *io_u)
> @@ -692,13 +691,41 @@ int verify_io_u(struct thread_data *td, struct io_u *io_u)
>                         memswp(p, p + td->o.verify_offset, header_size);
>                 hdr = p;
>
> -               if (!verify_header(io_u, hdr)) {
> +               ret = verify_header(io_u, hdr);
> +               switch (ret) {
> +               case 0:
> +                       break;
> +               case 1:
>                         log_err("verify: bad magic header %x, wanted %x at "
>                                 "file %s offset %llu, length %u\n",
>                                 hdr->magic, FIO_HDR_MAGIC,
>                                 io_u->file->file_name,
>                                 io_u->offset + hdr_num * hdr->len, hdr->len);
>                         return EILSEQ;
> +                       break;
> +               case 2:
> +                       log_err("fio: verify header exceeds buffer length (%u "
> +                               "> %lu)\n", hdr->len, io_u->buflen);
> +                       return EILSEQ;
> +                       break;
> +               case 3:
> +                       log_err("verify: bad header rand_seed %"PRIu64
> +                               ", wanted %"PRIu64" at file %s offset %llu, "
> +                               "length %u\n",
> +                               hdr->rand_seed, io_u->rand_seed,
> +                               io_u->file->file_name,
> +                               io_u->offset + hdr_num * hdr->len, hdr->len);
> +                       return EILSEQ;
> +                       break;
> +               case 4:
> +                       return EILSEQ;
> +                       break;
> +               default:
> +                       log_err("verify: unknown header error at file %s "
> +                       "offset %llu, length %u\n",
> +                       io_u->file->file_name,
> +                       io_u->offset + hdr_num * hdr->len, hdr->len);
> +                       return EILSEQ;
>                 }
>
>                 if (td->o.verify != VERIFY_NONE)
> --
> 1.7.12.4
>

