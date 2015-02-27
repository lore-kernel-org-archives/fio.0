Return-Path: <axboe@kernel.dk>
Message-ID: <54F08B3C.1080102@kernel.dk>
Date: Fri, 27 Feb 2015 08:20:28 -0700
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [PATCH] fio: fix cycles_start build issue
References: <54F02B6C.8080506@linux.vnet.ibm.com>
In-Reply-To: <54F02B6C.8080506@linux.vnet.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 02/27/2015 01:31 AM, Christian Ehrhardt wrote:
> Hi,
> a recent checkout of fio-git revealed a build issue on s390.
> For whatever reason my git send-email setup is broken so I paste it in
> the mail and hope it doesn't get mangled, let me know if that fails.

It mangled it horribly, but I just hand applied it. One issue, though:

> diff --git a/arch/arch-generic.h b/arch/arch-generic.h
> index a0b71f8..825a829 100644
> --- a/arch/arch-generic.h
> +++ b/arch/arch-generic.h
> @@ -2,6 +2,7 @@
>   #define ARCH_GENERIC_H
>
>   #define FIO_ARCH    (arch_generic)
> +#define ARCH_CPU_CLOCK_WRAPS

This wont work like I suspect you think it does. This define needs to go 
in the arch.h header, if you want all archs to catch it.

-- 
Jens Axboe


