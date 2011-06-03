Return-Path: <fio-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:51636 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751553Ab1FCTQU (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 3 Jun 2011 15:16:20 -0400
Message-ID: <4DE932FF.4040008@fusionio.com>
Date: Fri, 3 Jun 2011 21:16:15 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
Subject: Re: Small cleanup patch
References: <BANLkTi=qFqUv00QCh5yBV9_7jCg07E4qZ3mE7uAm_tugns7dow@mail.gmail.com>
In-Reply-To: <BANLkTi=qFqUv00QCh5yBV9_7jCg07E4qZ3mE7uAm_tugns7dow@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Steven Lang <tirea@google.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 2011-06-03 21:14, Steven Lang wrote:
> The wrong ddir enum was being used here, which trips up compilers
> which want to strictly check enum usage.
> 
> diff --git a/fio.c b/fio.c
> index 76c6ebd..34956e9 100644
> --- a/fio.c
> +++ b/fio.c
> @@ -180,7 +180,7 @@ static void set_sig_handlers(void)
>   * Check if we are above the minimum rate given.
>   */
>  static int __check_min_rate(struct thread_data *td, struct timeval *now,
> -			    enum td_ddir ddir)
> +			    enum fio_ddir ddir)
>  {
>  	unsigned long long bytes = 0;
>  	unsigned long iops = 0;

Oops, thanks and applied.

-- 
Jens Axboe

