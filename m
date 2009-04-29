Return-Path: <fio-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:43473 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751580AbZD2FYE (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 29 Apr 2009 01:24:04 -0400
Date: Wed, 29 Apr 2009 07:24:03 +0200
From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Fix name of the slat log file
Message-ID: <20090429052403.GP4593@kernel.dk>
References: <66dfd3fe0904281439v72b661e5n1319025c8a9f8e6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <66dfd3fe0904281439v72b661e5n1319025c8a9f8e6@mail.gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Radha Ramachandran <radha@google.com>
Cc: fio@vger.kernel.org

On Tue, Apr 28 2009, Radha Ramachandran wrote:
> Fix the name of the latency log file:
> Currently the slat and clat logs go to the same clat log file when the
> latency log file is specified.

Bad copy'n paste error... Applied, thanks!


> 
> diff -up fio.c.orig fio.c
> --- fio.c.orig  2009-04-28 14:37:50.049570000 -0700
> +++ fio.c       2009-04-28 14:38:17.306291000 -0700
> @@ -1086,7 +1086,7 @@ static void *thread_main(void *data)
>         if (td->ts.slat_log) {
>                 if (td->o.lat_log_file) {
>                         finish_log_named(td, td->ts.slat_log,
> -                                               td->o.lat_log_file, "clat");
> +                                               td->o.lat_log_file, "slat");
>                 } else
>                         finish_log(td, td->ts.slat_log, "slat");
>         }
> 
> thanks
> -radha
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Jens Axboe

