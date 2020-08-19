Return-Path: <prvs=4933047f4=Damien.LeMoal@wdc.com>
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH] zbd: remove reset_zone flag from fio_zone_info
Date: Wed, 19 Aug 2020 04:59:40 +0000
Message-ID: 
 <CY4PR04MB375194631690AD357CD2565DE75D0@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <20200818000250.20820-1-dmitry.fomichev@wdc.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Dmitry Fomichev <Dmitry.Fomichev@wdc.com>, Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
Cc: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
List-ID: <fio@vger.kernel.org>

On 2020/08/18 9:02, Dmitry Fomichev wrote:=0A=
> The reset_zone flag that is defined in fio_zone_info structure is=0A=
> only referenced in zbd_adjust_block() function. Convert this flag=0A=
> to a local variable and save some room in zbd_info array which can=0A=
> be pretty large when running fio against high capacity zoned devices.=0A=
> =0A=
> Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>=0A=
> ---=0A=
>  zbd.c | 7 ++++---=0A=
>  zbd.h | 2 --=0A=
>  2 files changed, 4 insertions(+), 5 deletions(-)=0A=
> =0A=
> diff --git a/zbd.c b/zbd.c=0A=
> index 5af8af4a..a7a48d27 100644=0A=
> --- a/zbd.c=0A=
> +++ b/zbd.c=0A=
> @@ -1438,6 +1438,7 @@ enum io_u_action zbd_adjust_block(struct thread_dat=
a *td, struct io_u *io_u)=0A=
>  	uint32_t min_bs =3D td->o.min_bs[io_u->ddir];=0A=
>  	uint64_t new_len;=0A=
>  	int64_t range;=0A=
> +	bool reset_zone;=0A=
>  =0A=
>  	if (!f->zbd_info)=0A=
>  		return io_u_accept;=0A=
> @@ -1536,15 +1537,16 @@ enum io_u_action zbd_adjust_block(struct thread_d=
ata *td, struct io_u *io_u)=0A=
>  			zone_idx_b =3D zb - f->zbd_info->zone_info;=0A=
>  		}=0A=
>  		/* Check whether the zone reset threshold has been exceeded */=0A=
> +		reset_zone =3D false;=0A=
>  		if (td->o.zrf.u.f) {=0A=
>  			if (f->zbd_info->sectors_with_data >=3D=0A=
>  			    f->io_size * td->o.zrt.u.f &&=0A=
>  			    zbd_dec_and_reset_write_cnt(td, f)) {=0A=
> -				zb->reset_zone =3D 1;=0A=
> +				reset_zone =3D true;=0A=
>  			}=0A=
>  		}=0A=
>  		/* Reset the zone pointer if necessary */=0A=
> -		if (zb->reset_zone || zbd_zone_full(f, zb, min_bs)) {=0A=
> +		if (reset_zone || zbd_zone_full(f, zb, min_bs)) {=0A=
>  			assert(td->o.verify =3D=3D VERIFY_NONE);=0A=
>  			/*=0A=
>  			 * Since previous write requests may have been submitted=0A=
> @@ -1554,7 +1556,6 @@ enum io_u_action zbd_adjust_block(struct thread_dat=
a *td, struct io_u *io_u)=0A=
>  			 * zone reset.=0A=
>  			 */=0A=
>  			io_u_quiesce(td);=0A=
> -			zb->reset_zone =3D 0;=0A=
>  			if (zbd_reset_zone(td, f, zb) < 0)=0A=
>  				goto eof;=0A=
>  =0A=
> diff --git a/zbd.h b/zbd.h=0A=
> index 021174c1..fe04d4ad 100644=0A=
> --- a/zbd.h=0A=
> +++ b/zbd.h=0A=
> @@ -30,7 +30,6 @@ enum io_u_action {=0A=
>   * @cond: zone state (BLK_ZONE_COND_*)=0A=
>   * @open: whether or not this zone is currently open. Only relevant if=
=0A=
>   *		max_open_zones > 0.=0A=
> - * @reset_zone: whether or not this zone should be reset before writing =
to it=0A=
>   */=0A=
>  struct fio_zone_info {=0A=
>  	pthread_mutex_t		mutex;=0A=
> @@ -41,7 +40,6 @@ struct fio_zone_info {=0A=
>  	enum zbd_zone_type	type:2;=0A=
>  	enum zbd_zone_cond	cond:4;=0A=
>  	unsigned int		open:1;=0A=
> -	unsigned int		reset_zone:1;=0A=
>  };=0A=
>  =0A=
>  /**=0A=
> =0A=
=0A=
Looks good to me.=0A=
=0A=
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=

