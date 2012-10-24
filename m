Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:55719 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933488Ab2JXGaA (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 24 Oct 2012 02:30:00 -0400
Message-ID: <50878AE4.7090900@kernel.dk>
Date: Wed, 24 Oct 2012 08:29:56 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [PATCH] Replace FIO_HAVE_RUSAGE_THREAD with RUSAGE_THREAD
References: <1350955778-27682-1-git-send-email-yufei.ren@stonybrook.edu>
In-Reply-To: <1350955778-27682-1-git-send-email-yufei.ren@stonybrook.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Yufei Ren <yufei.ren@stonybrook.edu>
Cc: fio@vger.kernel.org, Yufei Ren <renyufei83@gmail.com>

On 2012-10-23 03:29, Yufei Ren wrote:
> From: Yufei Ren <renyufei83@gmail.com>
> 
> RUSAGE_THREAD is a more clear macro to enable getrusage() thread support.
> ---
>  os/os-linux.h |    5 -----
>  stat.c        |    2 +-
>  2 files changed, 1 insertions(+), 6 deletions(-)
> 
> diff --git a/os/os-linux.h b/os/os-linux.h
> index 2b35f34..9b7ff29 100644
> --- a/os/os-linux.h
> +++ b/os/os-linux.h
> @@ -14,7 +14,6 @@
>  #include <linux/unistd.h>
>  #include <linux/raw.h>
>  #include <linux/major.h>
> -#include <linux/version.h>
>  #include <endian.h>
>  
>  #include "indirect.h"
> @@ -63,10 +62,6 @@
>  #define FIO_HAVE_FALLOC_ENG
>  #endif
>  
> -#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,26)
> -#define FIO_HAVE_RUSAGE_THREAD
> -#endif
> -
>  #ifdef SYNC_FILE_RANGE_WAIT_BEFORE
>  #define FIO_HAVE_SYNC_FILE_RANGE
>  #endif
> diff --git a/stat.c b/stat.c
> index af6e1f2..522901a 100644
> --- a/stat.c
> +++ b/stat.c
> @@ -16,7 +16,7 @@ void update_rusage_stat(struct thread_data *td)
>  {
>  	struct thread_stat *ts = &td->ts;
>  
> -#ifdef FIO_HAVE_RUSAGE_THREAD
> +#ifdef RUSAGE_THREAD
>  	getrusage(RUSAGE_THREAD, &td->ru_end);
>  #else
>  	getrusage(RUSAGE_SELF, &td->ru_end);
> 

Thanks, applied!

-- 
Jens Axboe

