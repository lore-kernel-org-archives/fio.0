Return-Path: <fio-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:52047
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752056Ab3AAJ5R (ORCPT
	<rfc822;fio@vger.kernel.org>); Tue, 1 Jan 2013 04:57:17 -0500
Message-ID: <50E2B2F4.2010508@kernel.dk>
Date: Tue, 01 Jan 2013 10:57:08 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [PATCH] implement get_cpu_clock() for s390/s390x
References: <1356905016-48651-1-git-send-email-dan@danny.cz>
In-Reply-To: <1356905016-48651-1-git-send-email-dan@danny.cz>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: =?ISO-8859-1?Q?Dan_Hor=E1k?= <dan@danny.cz>
Cc: fio@vger.kernel.org

On 2012-12-30 23:03, Dan Hor=EF=BF=BDk wrote:
> ---
>  arch/arch-s390.h |   18 ++++++++++++++++++
>  1 files changed, 18 insertions(+), 0 deletions(-)
>=20
> diff --git a/arch/arch-s390.h b/arch/arch-s390.h
> index fe51791..bcd9163 100644
> --- a/arch/arch-s390.h
> +++ b/arch/arch-s390.h
> @@ -22,4 +22,22 @@
>  #define read_barrier()	asm volatile("bcr 15,0" : : : "memory")
>  #define write_barrier()	asm volatile("bcr 15,0" : : : "memory")
> =20
> +static inline unsigned long long get_cpu_clock(void)
> +{
> +	unsigned long long clk;
> +
> +	__asm__ __volatile__("stck %0" : "=3DQ" (clk) : : "cc");
> +	return clk;
> +}
> +
> +#define ARCH_HAVE_INIT
> +extern int tsc_reliable;
> +static inline int arch_init(char *envp[])
> +{
> +	tsc_reliable =3D 1;
> +	return 0;
> +}
> +
> +#define ARCH_HAVE_CPU_CLOCK
> +
>  #endif

Thanks, Dan! Applied.

--=20
Jens Axboe

