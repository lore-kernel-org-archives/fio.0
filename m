Return-Path: <fio-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:51618 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753429Ab2BBItd (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 2 Feb 2012 03:49:33 -0500
Message-ID: <4F2A4DE7.7020409@fusionio.com>
Date: Thu, 2 Feb 2012 09:48:39 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
Subject: Re: [PATCH] Optimize pattern filling by limiting small calls to memcpy.
References: <CAAUT-yOCgVD61WtQB4CtY86zzYFCBfN4G=F=QCd4kvqFb4zx+Q@mail.gmail.com>
In-Reply-To: <CAAUT-yOCgVD61WtQB4CtY86zzYFCBfN4G=F=QCd4kvqFb4zx+Q@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Steven Lang <tirea@google.com>
Cc: fio@vger.kernel.org

On 02/02/2012 02:39 AM, Steven Lang wrote:
> In looking at profiling the speed of fill_pattern(), it calls memcpy()
> for the fill pattern repeatedly for multibyte patterns.  So for a 4
> byte pattern with 8k IO, it calls memcpy() 2048 times.
> 
> Since there is already 512 bytes reserved for the pattern, I figured a
> simple solution was to use it.  This patch replicates short patterns
> so they can be more efficiently copied.  (Single byte patterns are
> left alone since they can make use of the much more efficient memset()
> call.)
> 
> The result is a 10x performance improvement on pattern filling.  (With
> this patch, it's still 3x slower than when it re-uses the already
> filled pattern.)
> 
> ---
>  options.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/options.c b/options.c
> index f9bd1a4..b6989d4 100644
> --- a/options.c
> +++ b/options.c
> @@ -689,6 +689,10 @@ static int str_verify_pattern_cb(void *data,
> const char *input)
>  			}
>  		}
>  	}
> +	while (i > 1 && i * 2 <= MAX_PATTERN_SIZE) {
> +		memcpy(&td->o.verify_pattern[i], &td->o.verify_pattern[0], i);
> +		i *= 2;
> +	}
>  	td->o.verify_pattern_bytes = i;
>  	/*
>  	 * VERIFY_META could already be set

Looks like you are missing the interesting part of this patch :-)
But the idea definitely sounds good.

-- 
Jens Axboe

