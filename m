Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH RFC] gauss.c: correct the stddev initializtion
References: <20200317125331.6799-1-feng.tang@intel.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <dab7e008-2fff-62d8-28f6-cc08a5388738@kernel.dk>
Date: Tue, 17 Mar 2020 08:34:48 -0600
MIME-Version: 1.0
In-Reply-To: <20200317125331.6799-1-feng.tang@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Feng Tang <feng.tang@intel.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 3/17/20 6:53 AM, Feng Tang wrote:
> Signed-off-by: Feng Tang <feng.tang@intel.com>
> ---
>  lib/gauss.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/lib/gauss.c b/lib/gauss.c
> index 1d24e187..3f84dbc6 100644
> --- a/lib/gauss.c
> +++ b/lib/gauss.c
> @@ -51,7 +51,7 @@ void gauss_init(struct gauss_state *gs, unsigned long nranges, double dev,
>  	gs->nranges = nranges;
>  
>  	if (dev != 0.0) {
> -		gs->stddev = ceil((double) (nranges * 100.0) / dev);
> +		gs->stddev = ceil((double)(nranges * dev) / 100.0);
>  		if (gs->stddev > nranges / 2)
>  			gs->stddev = nranges / 2;
>  	}

Looks like I very helpfully did not include a reference to to where
this is from... Can you expand on the need for the patch?

-- 
Jens Axboe


