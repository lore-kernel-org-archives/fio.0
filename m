Return-Path: <bruce@cran.org.uk>
MIME-Version: 1.0
From: Bruce Cran <bruce@cran.org.uk>
Date: Thu, 27 Jan 2011 01:51:59 -0700
Subject: Re: Recent changes
Message-ID: <20110127085159.0000478f@unknown>
References: <20110127050004.1AE9737A304@kernel.dk>
In-Reply-To: <20110127050004.1AE9737A304@kernel.dk>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
To: Jens Axboe <JAxboe@fusionio.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On Thu, 27 Jan 2011 06:00:04 +0100 (CET)
Jens Axboe <jaxboe@fusionio.com> wrote:

> +#define POSIX_MADV_DONTNEED	MADV_DONTNEED
> +#define POSIX_MADV_SEQUENTIAL	MADV_SEQUENTIAL
> +#define POSIX_MADV_RANDOM	MADV_RANDOM

These are already defined on OpenSolaris 2009.06 and cause redefinition
warnings.

--=20
Bruce Cran

