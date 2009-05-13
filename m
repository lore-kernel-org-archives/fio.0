Return-Path: <fio-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:43050 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753167AbZEMFuM (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 13 May 2009 01:50:12 -0400
Date: Wed, 13 May 2009 07:50:13 +0200
From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [patch] fio docs corrections
Message-ID: <20090513055013.GY4140@kernel.dk>
References: <4A09F87F.9060801@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A09F87F.9060801@oracle.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: fio@vger.kernel.org

On Tue, May 12 2009, Randy Dunlap wrote:
> 
> Correct fio mailing list address and unit of time for cpuchunks.

Applied

> ---
> 
>  HOWTO          |    2 +-
>  REPORTING-BUGS |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff -Naurp fio-1.26.2/REPORTING-BUGS~update2 fio-1.26.2/REPORTING-BUGS
> --- fio-1.26.2/REPORTING-BUGS~update2	2009-05-11 01:37:33.000000000 -0700
> +++ fio-1.26.2/REPORTING-BUGS	2009-05-12 15:26:15.000000000 -0700
> @@ -2,7 +2,7 @@ Reporting a bug
>  ---------------
>  
>  If you notice anything that seems like a fio bug, please do send email
> -to the list (fio-devel@kernel.dk, see README) about it. You'll need
> +to the list (fio@vger.kernel.org, see README) about it. You'll need
>  to report at least:
>  
>  1) A description of what you think the bug is
> diff -Naurp fio-1.26.2/HOWTO~update2 fio-1.26.2/HOWTO
> --- fio-1.26.2/HOWTO~update2	2009-05-11 01:37:33.000000000 -0700
> +++ fio-1.26.2/HOWTO	2009-05-12 15:27:19.000000000 -0700
> @@ -874,7 +874,7 @@ cpuload=int	If the job is a CPU cycle ea
>  		percentage of CPU cycles.
>  
>  cpuchunks=int	If the job is a CPU cycle eater, split the load into
> -		cycles of the given time. In milliseconds.
> +		cycles of the given time. In microseconds.
>  
>  disk_util=bool	Generate disk utilization statistics, if the platform
>  		supports it. Defaults to on.
> 
> 
> 
> -- 
> ~Randy
> LPC 2009, Sept. 23-25, Portland, Oregon
> http://linuxplumbersconf.org/2009/
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Jens Axboe

