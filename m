Return-Path: <grundler@google.com>
MIME-Version: 1.0
Sender: grundler@google.com
In-Reply-To: <1377552162-31741-2-git-send-email-jcasse@chromium.org>
References: <1377552162-31741-1-git-send-email-jcasse@chromium.org>
	<1377552162-31741-2-git-send-email-jcasse@chromium.org>
Date: Mon, 26 Aug 2013 15:11:57 -0700
Message-ID: <CANEJEGuKzZeLfCoNX12Pp_4_Uj8iHjLX221c+qpYzgpWYgA-Pg@mail.gmail.com>
Subject: Re: [PATCH 2/2] Adds check for rand_seed during verify phase.
From: Grant Grundler <grundler@chromium.org>
Content-Type: text/plain; charset=UTF-8
To: Juan Casse <jcasse@chromium.org>
Cc: Jens Axboe <axboe@kernel.dk>, Grant Grundler <grundler@chromium.org>, FIO_list <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

Jens, et al,

In general I'm ok with this patch...just one issue I'd like to get an
opinion on...

On Mon, Aug 26, 2013 at 2:22 PM, Juan Casse <jcasse@chromium.org> wrote:
> Improve data integrity checking and detect stale blocks from previous
> runs.
>
> Signed-off-by: Juan Casse <jcasse@chromium.org>
> Reviewed-by: Grant Grundler <grundler@chromium.org>
> ---
>  verify.c | 45 ++++++++++++++++++++++++++++++++++++---------
>  1 file changed, 36 insertions(+), 9 deletions(-)
>
> diff --git a/verify.c b/verify.c
> index 83c5735..deabf76 100644
> --- a/verify.c
> +++ b/verify.c
> @@ -648,18 +648,17 @@ static int verify_header(struct io_u *io_u, struct verify_header *hdr)
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
> @@ -696,13 +695,41 @@ int verify_io_u(struct thread_data *td, struct io_u *io_u)
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

Should we return different error values for each different possible mismatch?

I think we should but don't know which error values would be preferred here.

The reason is automated testing will log a failure and I want a
different failure code for each possible failure mode. That way, I can
easily tell if a different data integrity check fails and which
systems are reporting a particular error code.

I understand, some error codes may have many different root causes.
But I should be able to tell the difference between "magic number is
wrong", "IO Timed out", and "generation number is wrong" at the first
cut.

thanks,
grant

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

