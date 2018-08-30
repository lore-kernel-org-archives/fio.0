Return-Path: <bvanassche@acm.org>
Subject: Re: [PATCH v2 1/5] zbd: Improve read randomness
References: <20180830041531.20963-1-damien.lemoal@wdc.com>
 <20180830041531.20963-2-damien.lemoal@wdc.com>
From: Bart Van Assche <bvanassche@acm.org>
Message-ID: <4061532e-b0d2-8594-c1a3-4498ae067a07@acm.org>
Date: Thu, 30 Aug 2018 07:49:04 -0700
MIME-Version: 1.0
In-Reply-To: <20180830041531.20963-2-damien.lemoal@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Damien Le Moal <damien.lemoal@wdc.com>, fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

On 08/29/18 21:15, Damien Le Moal wrote:
> With zonemode=zbd, for random read operations with read_beyond_wp=0,
> the zbd code will always adjust an I/O offset so that the I/O hits a
> non empty zone. However, the adjustment always sets the I/O offset to
> the start of the zone, resulting in a high device read cache hit rate
> if the device has few zones written.
> 
> Improve randomness of read I/Os by adjusting the I/O offset to a random
> value within the range of written data of the chosen zone. Also ensure
> that the modified I/O does not cross over the zone wp position by
> adjusting its size.
> 
> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
> ---
>  zbd.c | 35 +++++++++++++++++++++++++++++++++--
>  1 file changed, 33 insertions(+), 2 deletions(-)
> 
> diff --git a/zbd.c b/zbd.c
> index 56197693..19511454 100644
> --- a/zbd.c
> +++ b/zbd.c
> @@ -1122,7 +1122,7 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
>  	struct fio_zone_info *zb, *zl;
>  	uint32_t orig_len = io_u->buflen;
>  	uint32_t min_bs = td->o.min_bs[io_u->ddir];
> -	uint64_t new_len;
> +	uint64_t new_len, zofst;
>  	int64_t range;
>  
>  	if (!f->zbd_info)
> @@ -1168,6 +1168,8 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
>  		}
>  		if (zb->cond == BLK_ZONE_COND_OFFLINE ||
>  		    (io_u->offset + io_u->buflen) >> 9 > zb->wp) {
> +			struct fio_zone_info *orig_zb = zb;
> +
>  			pthread_mutex_unlock(&zb->mutex);
>  			zl = &f->zbd_info->zone_info[zbd_zone_idx(f,
>  						f->file_offset + f->io_size)];
> @@ -1179,7 +1181,36 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
>  				       io_u->buflen);
>  				goto eof;
>  			}
> -			io_u->offset = zb->start << 9;
> +			/*
> +			 * zbd_find_zone() returned a zone with a range of at
> +			 * least min_bs, but range may be less than the I/O
> +			 * size. Handle this case here and also make sure that
> +			 * the I/O does not the cross the zone wp.
> +			 */
> +			range = ((zb->wp - zb->start) << 9) / min_bs * min_bs;
> +			if ((!td_random(td)) || range <= io_u->buflen) {
> +				io_u->offset = zb->start << 9;
> +			} else {
> +				zofst = ((io_u->offset - (orig_zb->start << 9)) %
> +					 range) / min_bs * min_bs;
> +				if (zofst >= range)
> +					io_u->offset =
> +						((zb->wp << 9) / min_bs - 1) *
> +						min_bs;
> +				else
> +					io_u->offset = (zb->start << 9) + zofst;

The "zofst >= range" test doesn't make sense to me. Since "zofst" is the
result of rounding down the result of a "% range" operation it is
guaranteed that zofst < range.

> +			}
> +			new_len = min((unsigned long long)io_u->buflen,
> +				      (unsigned long long)(zb->wp << 9) -
> +				      io_u->offset);
> +			new_len = new_len / min_bs * min_bs;
> +			if (new_len < io_u->buflen) {
> +				io_u->buflen = new_len;
> +				dprint(FD_IO, "Changed length from %u into %llu\n",
> +				       orig_len, io_u->buflen);
> +			}
> +			assert(zb->start << 9 <= io_u->offset);
> +			assert(io_u->offset + io_u->buflen <= zb->wp << 9);
>  		}
>  		if ((io_u->offset + io_u->buflen) >> 9 > zb->wp) {
>  			dprint(FD_ZBD, "%s: %lld + %lld > %" PRIu64 "\n",
> 

The approach of this patch does not make sense to me: with this patch
applied, if the read request doesn't fit below the write pointer, a new
zone is selected and if the read request doesn't fit in that zone buflen
is reduced. Wouldn't it be better to shrink the request if zone *zb is
not empty and only to call zbd_find_zone() if zone *zb is empty?

Bart.


