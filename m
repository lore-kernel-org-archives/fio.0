Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:45454 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547Ab2GaUWX (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 31 Jul 2012 16:22:23 -0400
Message-ID: <50183E75.8040705@kernel.dk>
Date: Tue, 31 Jul 2012 22:22:13 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [PATCH] Fix fallocate erroneously returning ENOSYS on Linux systems
References: <20120731124922.18191l6yyd1pno4k@webmail.oregonstate.edu>
In-Reply-To: <20120731124922.18191l6yyd1pno4k@webmail.oregonstate.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: clinew@onid.orst.edu
Cc: fio@vger.kernel.org, kcastiglia@aereo.com

On 07/31/2012 09:49 PM, clinew@onid.orst.edu wrote:
> Currently, the helpers.c file provides a function defintion for Linux fallocate
> that sets errno to ENOSYS and returns failure; this is useful for a non-Linux
> OS. However, this definition will override the Linux implementation of
> fallocate when 'fallocate=keep' is set. Adding a preprocessor macro to check
> if Linux fallocate is defined fixes this issue.
> 
> Signed-off-by: Wade Cline <wcline@us.ibm.com>
> ---
>  helpers.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/helpers.c b/helpers.c
> index 9562567..714842e 100644
> --- a/helpers.c
> +++ b/helpers.c
> @@ -9,11 +9,13 @@
>  #include "arch/arch.h"
>  #include "os/os.h"
> 
> +#ifndef FIO_HAVE_LINUX_FALLOCATE
>  int _weak fallocate(int fd, int mode, off_t offset, off_t len)
>  {
>         errno = ENOSYS;
>         return -1;
>  }
> +#endif

Hmm, the purpose of the _weak would be to NOT override a fallocate() if
we have one. Why isn't this working?

-- 
Jens Axboe

