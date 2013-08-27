Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:38510 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751465Ab3H0RAm (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 27 Aug 2013 13:00:42 -0400
Message-ID: <521CDB2D.4040708@kernel.dk>
Date: Tue, 27 Aug 2013 11:00:29 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [PATCH] Fix spelling error in fio manpage.
References: <1377613600-7322-1-git-send-email-ms@teamix.de>
In-Reply-To: <1377613600-7322-1-git-send-email-ms@teamix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Martin Steigerwald <ms@teamix.de>
Cc: fio@vger.kernel.org

On 08/27/2013 08:26 AM, Martin Steigerwald wrote:
> ---
>  fio.1 | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fio.1 b/fio.1
> index e35bd93..b8082af 100644
> --- a/fio.1
> +++ b/fio.1
> @@ -321,7 +321,7 @@ are likely to be issued. Default: true.
>  .TP
>  .BI size \fR=\fPint
>  Total size of I/O for this job.  \fBfio\fR will run until this many bytes have
> -been transfered, unless limited by other options (\fBruntime\fR, for instance).
> +been transferred, unless limited by other options (\fBruntime\fR, for instance).
>  Unless \fBnrfiles\fR and \fBfilesize\fR options are given, this amount will be
>  divided between the available files for the job. If not set, fio will use the
>  full size of the given files or devices. If the the files do not exist, size
> 

Applied, thanks.


-- 
Jens Axboe

