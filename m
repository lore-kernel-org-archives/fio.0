Return-Path: <dehrenberg@google.com>
MIME-Version: 1.0
In-Reply-To: <1330548842-31981-1-git-send-email-dehrenberg@google.com>
References: <1330548842-31981-1-git-send-email-dehrenberg@google.com>
Date: Wed, 29 Feb 2012 13:22:43 -0800
Message-ID: <CAAK6Zt3fiTZpmkK6tyMVOAWAdL4FZgOTAa7SE2U6d80-tRanxg@mail.gmail.com>
Subject: Re: [PATCH] fallocate: enable fallocate options on Linux
From: Daniel Ehrenberg <dehrenberg@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
To: fio@vger.kernel.org, axboe@kernel.dk
Cc: nauman@google.com, egouriou@google.com, tirea@google.com, Dan Ehrenberg <dehrenberg@google.com>
List-ID: <fio@vger.kernel.org>

Hi,

I'd just like to clarify: I'm not sure if the patch I just sent is
exactly what we'd want. Maybe it is correct to set FIO_HAVE_FALLOCATE
on some Linux systems which aren't at least glibc version 2.8. I don't
know much about the history of these features, and if any fio users
are using an older system where they do still want fallocate
capabilities, I'd appreciate input here.

Thanks,
Dan

On Wed, Feb 29, 2012 at 12:54 PM, Dan Ehrenberg <dehrenberg@google.com> wro=
te:
> Simple bug fix to ensure that fallocate-related options are
> once again enabled on Linux systems with the right headers present.
> A previous patch gated the FIO_HAVE_LINUX_FALLOCATE flag on
> header versions but failed to enable FIO_HAVE_FALLOCATE in this
> case.
> ---
> =A0os/os-linux.h | =A0 =A01 +
> =A01 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/os/os-linux.h b/os/os-linux.h
> index 3bf6bd9..b911753 100644
> --- a/os/os-linux.h
> +++ b/os/os-linux.h
> @@ -51,6 +51,7 @@
> =A0* missing
> =A0*/
> =A0#if __GLIBC__ >=3D 2 && __GLIBC_MINOR__ >=3D 8
> +#define FIO_HAVE_FALLOCATE
> =A0#define FIO_HAVE_LINUX_FALLOCATE
> =A0#endif
>
> --
> 1.7.7.3
>

