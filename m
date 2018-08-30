Return-Path: <bvanassche@acm.org>
Subject: Re: [PATCH v2 4/5] zbd: Fix zbd_zone_idx()
References: <20180830041531.20963-1-damien.lemoal@wdc.com>
 <20180830041531.20963-5-damien.lemoal@wdc.com>
From: Bart Van Assche <bvanassche@acm.org>
Message-ID: <868db610-62ee-bf38-29cb-48c46b36dc35@acm.org>
Date: Thu, 30 Aug 2018 07:54:36 -0700
MIME-Version: 1.0
In-Reply-To: <20180830041531.20963-5-damien.lemoal@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Damien Le Moal <damien.lemoal@wdc.com>, fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

On 08/29/18 21:15, Damien Le Moal wrote:
> For a zone size that is not a power of 2 number of sectors,
                                           ^^^^^^^^^^^^^^^^^^

That sentence looks weird. Should "number of sectors" perhaps be left out?

> f->zbd_info->zone_size_log2 is set to -1. So use bit shift in
> zbd_zone_idx() only if zone_size_log2 is not negative.
> 
> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
> ---
>  zbd.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/zbd.c b/zbd.c
> index e98c5a50..3aea8052 100644
> --- a/zbd.c
> +++ b/zbd.c
> @@ -31,7 +31,7 @@ static uint32_t zbd_zone_idx(const struct fio_file *f, uint64_t offset)
>  {
>  	uint32_t zone_idx;
>  
> -	if (f->zbd_info->zone_size_log2)
> +	if (f->zbd_info->zone_size_log2 > 0)
>  		zone_idx = offset >> f->zbd_info->zone_size_log2;
>  	else
>  		zone_idx = (offset >> 9) / f->zbd_info->zone_size;
> 

Otherwise this patch looks fine to me, hence:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

