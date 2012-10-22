Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:48749 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376Ab2JVIER (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 22 Oct 2012 04:04:17 -0400
Message-ID: <5084FDFE.20208@kernel.dk>
Date: Mon, 22 Oct 2012 10:04:14 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [PATCH 2/4] thread cpu resource statistics bug fix
References: <1350702712-5168-1-git-send-email-yufei.ren@stonybrook.edu> <1350702712-5168-3-git-send-email-yufei.ren@stonybrook.edu>
In-Reply-To: <1350702712-5168-3-git-send-email-yufei.ren@stonybrook.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Yufei Ren <yufei.ren@stonybrook.edu>
Cc: fio@vger.kernel.org, Yufei Ren <renyufei83@gmail.com>

On 2012-10-20 05:11, Yufei Ren wrote:
> From: Yufei Ren <renyufei83@gmail.com>
> 
> If `thread' option is enabled, resource usage should be thread
> based instead of process based. For the following job,
> 
> fio --ioengine=cpuio --cpuload=50 --time_based --runtime=10 --name=j0 --numjobs=4 --thread
> 
> before patch, each thread CPU statistics:
> ...
>   cpu          : usr=199.67%, sys=0.14%, ctx=1475, majf=0, minf=24
> ...
> 
> after patch:
> ...
>   cpu          : usr=49.80%, sys=0.00%, ctx=79, majf=0, minf=18446744073709538943
> ...
> ---
>  os/os-linux.h |    5 +++++
>  stat.c        |    4 ++++
>  2 files changed, 9 insertions(+), 0 deletions(-)
> 
> diff --git a/os/os-linux.h b/os/os-linux.h
> index 9b7ff29..2b35f34 100644
> --- a/os/os-linux.h
> +++ b/os/os-linux.h
> @@ -14,6 +14,7 @@
>  #include <linux/unistd.h>
>  #include <linux/raw.h>
>  #include <linux/major.h>
> +#include <linux/version.h>
>  #include <endian.h>
>  
>  #include "indirect.h"
> @@ -62,6 +63,10 @@
>  #define FIO_HAVE_FALLOC_ENG
>  #endif
>  
> +#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,26)
> +#define FIO_HAVE_RUSAGE_THREAD
> +#endif

I applied this, but I wonder if we should not just make this dependent
on

#ifdef RUSAGE_THREAD
...
#endif

instead?

-- 
Jens Axboe

