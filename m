Return-Path: <bvanassche@acm.org>
Subject: Re: [PATCH] zbd: Improve read randomness
References: <20180828053428.10143-1-damien.lemoal@wdc.com>
 <20180828053428.10143-2-damien.lemoal@wdc.com>
From: Bart Van Assche <bvanassche@acm.org>
Message-ID: <03ebc07e-092e-00ee-1b87-a5a693e4de5b@acm.org>
Date: Tue, 28 Aug 2018 07:38:35 -0700
MIME-Version: 1.0
In-Reply-To: <20180828053428.10143-2-damien.lemoal@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Damien Le Moal <damien.lemoal@wdc.com>, fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

On 08/27/18 22:34, Damien Le Moal wrote:
> With zonemode=zbd, for random read operations with read_beyond_wp=0,
> the zbd code will always adjust an I/O offset so that the I/O falls in
> a non empty zone. The adjustment however always sets the I/O offset to
> the start of the zone, resulting in a high device read cache hit rate
> if the device has very few zones written.
> 
> Fix this by improving the randomness of the I/Os by adjusting the I/O
> offset to a random value with the range of written data in the zone.
> 
> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
> ---
>  zbd.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/zbd.c b/zbd.c
> index 56197693..a985e022 100644
> --- a/zbd.c
> +++ b/zbd.c
> @@ -1179,7 +1179,15 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
>  				       io_u->buflen);
>  				goto eof;
>  			}
> -			io_u->offset = zb->start << 9;
> +			range = ((zb->wp - zb->start) << 9) - io_u->buflen;
> +			if (td_random(td) && range >= 0)
> +				io_u->offset = (zb->start << 9) +
> +					((io_u->offset - (zb->start << 9)) %
> +					 (range + 1)) / min_bs * min_bs;

This looks wrong to me: it is not guaranteed that io_u->offset >=
(zb->start << 9). Please use the original zb in that expression.
Additionally, since that expression is only evaluated if range >=0,
there is no need to add "+ 1" to "range".

Thanks,

Bart.


