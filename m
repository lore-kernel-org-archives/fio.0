Return-Path: <fio-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:36826
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751129Ab2LTIPe (ORCPT
	<rfc822;fio@vger.kernel.org>); Thu, 20 Dec 2012 03:15:34 -0500
Message-ID: <50D2C8FD.2070901@kernel.dk>
Date: Thu, 20 Dec 2012 09:14:53 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [PATCH] gettime: minimize integer division
References: <50D26157.5020802@micron.com>
In-Reply-To: <50D26157.5020802@micron.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sam Bradshaw <sbradshaw@micron.com>
Cc: fio@vger.kernel.org

On 2012-12-20 01:52, Sam Bradshaw wrote:
> 
> This patch generally converts a division to a subtraction in fio_gettime().
> 
> Shows ~1% better iops with synthetic benchmarking at roughly the same cpu 
> time spent in fio_gettime().
> 
> Signed-off-by: Sam Bradshaw <sbradshaw@micron.com>
> 
> diff --git a/gettime.c b/gettime.c
> index 248f146..e2a6241 100644
> --- a/gettime.c
> +++ b/gettime.c
> @@ -163,17 +163,23 @@ void fio_gettime(struct timeval *tp, void fio_unused *caller)
>  		}
>  #ifdef ARCH_HAVE_CPU_CLOCK
>  	case CS_CPUCLOCK: {
> -		unsigned long long usecs, t;
> +		unsigned long long usecs, t, delta = 0;
> 
>  		t = get_cpu_clock();
>  		if (tv && t < tv->last_cycles) {
>  			dprint(FD_TIME, "CPU clock going back in time\n");
>  			t = tv->last_cycles;
> -		} else if (tv)
> +		} else if (tv) {
> +			if (tv->last_tv_valid)
> +				delta = t - tv->last_cycles;
>  			tv->last_cycles = t;
> +		}
> 
>  		usecs = t / cycles_per_usec;
> -		tp->tv_sec = usecs / 1000000;
> +		if (delta > 1000000)
> +			tp->tv_sec = tv->last_tv.tv_sec;
> +		else
> +			tp->tv_sec = usecs / 1000000;

Shouldn't that be delta < 1000000? What am I missing? If the diff is
more than 1M usecs, then do the division. If not, we can reuse the
seconds from the last one.

-- 
Jens Axboe

