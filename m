Return-Path: <fio-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:38084 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752199AbZDWLrP (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 23 Apr 2009 07:47:15 -0400
Date: Thu, 23 Apr 2009 13:47:14 +0200
From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] fio: Include support for ARM.
Message-ID: <20090423114714.GD4593@kernel.dk>
References: <1240486694-30324-1-git-send-email-kedars@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1240486694-30324-1-git-send-email-kedars@marvell.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Kedar Sovani <kedars@marvell.com>
Cc: fio@vger.kernel.org

On Thu, Apr 23 2009, Kedar Sovani wrote:
> Resending to the new list.
> Assembly instructions picked from include/asm-arm/system.h

Excellent, thanks a lot!

> Please consider for inclusion.

Added.

> 
> Signed-off-by: Kedar Sovani <kedars@marvell.com>
> diff -urp fio.orig/arch/arch.h fio/arch/arch.h
> --- fio.orig/arch/arch.h	2008-11-18 13:22:55.000000000 -0500
> +++ fio/arch/arch.h	2009-04-23 13:37:46.000000000 -0400
> @@ -10,6 +10,7 @@ enum {
>  	arch_alpha,
>  	arch_sparc,
>  	arch_sparc64,
> +	arch_arm,
>  };
>  
>  #if defined(__i386__)
> @@ -28,6 +29,8 @@ enum {
>  #include "arch-sparc.h"
>  #elif defined(__sparc64__)
>  #include "arch-sparc64.h"
> +#elif defined(__arm__)
> +#include "arch-arm.h"
>  #else
>  #error "Unsupported arch"
>  #endif
> diff -Nurp fio.orig/arch/arch-arm.h fio/arch/arch-arm.h
> --- fio.orig/arch/arch-arm.h	1969-12-31 19:00:00.000000000 -0500
> +++ fio/arch/arch-arm.h	2009-04-23 14:20:32.000000000 -0400
> @@ -0,0 +1,27 @@
> +#ifndef ARCH_ARM_H
> +#define ARCH_ARM_H
> +
> +#define ARCH	(arch_arm)
> +
> +#ifndef __NR_ioprio_set
> +#define __NR_ioprio_set		314
> +#define __NR_ioprio_get		315
> +#endif
> +
> +#ifndef __NR_fadvise64
> +#define __NR_fadvise64		270
> +#endif
> +
> +#ifndef __NR_sys_splice
> +#define __NR_sys_splice		340
> +#define __NR_sys_tee		342
> +#define __NR_sys_vmsplice	343
> +#endif
> +
> +#if defined (__ARM_ARCH_4__) || defined (__ARM_ARCH_4T__) || defined (__ARM_ARCH_5__) || defined (__ARM_ARCH_5T__) || defined (__ARM_ARCH_5TE__) || defined (__ARM_ARCH_5TEJ__)
> +#define nop             __asm__ __volatile__("mov\tr0,r0\t@ nop\n\t")
> +#define read_barrier()	__asm__ __volatile__ ("" : : : "memory")
> +#define write_barrier()	__asm__ __volatile__ ("" : : : "memory")
> +#endif
> +
> +#endif
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Jens Axboe

