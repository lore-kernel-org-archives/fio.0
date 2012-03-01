Return-Path: <dehrenberg@google.com>
MIME-Version: 1.0
In-Reply-To: <4F4F8A7E.1010206@kernel.dk>
References: <1330548842-31981-1-git-send-email-dehrenberg@google.com>
	<CAAK6Zt3fiTZpmkK6tyMVOAWAdL4FZgOTAa7SE2U6d80-tRanxg@mail.gmail.com>
	<4F4F8A7E.1010206@kernel.dk>
Date: Thu, 1 Mar 2012 11:23:57 -0800
Message-ID: <CAAK6Zt1G_7H3d=zrRwyZni=MkngZHpNFnAqOz=VvCqrDBEY=UQ@mail.gmail.com>
Subject: Re: [PATCH] fallocate: enable fallocate options on Linux
From: Daniel Ehrenberg <dehrenberg@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org, nauman@google.com, egouriou@google.com, tirea@google.com
List-ID: <fio@vger.kernel.org>

On Thu, Mar 1, 2012 at 6:41 AM, Jens Axboe <axboe@kernel.dk> wrote:
> On 02/29/2012 10:22 PM, Daniel Ehrenberg wrote:
>> Hi,
>>
>> I'd just like to clarify: I'm not sure if the patch I just sent is
>> exactly what we'd want. Maybe it is correct to set FIO_HAVE_FALLOCATE
>> on some Linux systems which aren't at least glibc version 2.8. I don't
>> know much about the history of these features, and if any fio users
>> are using an older system where they do still want fallocate
>> capabilities, I'd appreciate input here.
>
> There is something a bit wonky there. We should be able to use
> posix_fallocate() from 2.6 and on, but only the linux fallocate from 2.8
> and up.
>
> Something like the below.
>
> diff --git a/os/os-linux.h b/os/os-linux.h
> index 3bf6bd9..d5c3f76 100644
> --- a/os/os-linux.h
> +++ b/os/os-linux.h
> @@ -50,6 +50,9 @@
> =A0* Can only enable this for newer glibcs, or the header and defines are
> =A0* missing
> =A0*/
> +#if __GLIBC__ >=3D 2 && __GLIBC_MINOR__ >=3D 6
> +#define FIO_HAVE_FALLOCATE
> +#endif
> =A0#if __GLIBC__ >=3D 2 && __GLIBC_MINOR__ >=3D 8
> =A0#define FIO_HAVE_LINUX_FALLOCATE
> =A0#endif
>
> --
> Jens Axboe
>

That looks good to me. Thanks for the revision.

