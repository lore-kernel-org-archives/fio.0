Return-Path: <prvs=4705a5bd9=Damien.LeMoal@wdc.com>
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH 2/3] zbd: simplify zone reset code
Date: Mon, 27 Jul 2020 05:07:03 +0000
Message-ID: 
 <CY4PR04MB37516FEB528EA3FEA138055AE7720@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <20200727031638.28264-1-dmitry.fomichev@wdc.com>
 <20200727031638.28264-3-dmitry.fomichev@wdc.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Dmitry Fomichev <Dmitry.Fomichev@wdc.com>, Jens Axboe <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
List-ID: <fio@vger.kernel.org>

On 2020/07/27 12:16, Dmitry Fomichev wrote:=0A=
> zbd_reset_range() function is only called once from zbd_reset_zone()=0A=
> and it is always called for an individual zone, not a range.=0A=
> =0A=
> Make zone reset flow simpler by moving all the code needed=0A=
> to reset a single zone from zbd_reset_range() to zbd_reset_zone().=0A=
> Therefore, zbd_reset_range() is now dropped.=0A=
> =0A=
> No functional change.=0A=
> =0A=
> Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>=0A=
> ---=0A=
>  zbd.c | 76 +++++++++++++++++++++--------------------------------------=
=0A=
>  1 file changed, 27 insertions(+), 49 deletions(-)=0A=
> =0A=
> diff --git a/zbd.c b/zbd.c=0A=
> index 3eac5df3..f6ccf299 100644=0A=
> --- a/zbd.c=0A=
> +++ b/zbd.c=0A=
> @@ -670,54 +670,6 @@ int zbd_setup_files(struct thread_data *td)=0A=
>  	return 0;=0A=
>  }=0A=
>  =0A=
> -/**=0A=
> - * zbd_reset_range - reset zones for a range of sectors=0A=
> - * @td: FIO thread data.=0A=
> - * @f: Fio file for which to reset zones=0A=
> - * @sector: Starting sector in units of 512 bytes=0A=
> - * @nr_sectors: Number of sectors in units of 512 bytes=0A=
> - *=0A=
> - * Returns 0 upon success and a negative error code upon failure.=0A=
> - */=0A=
> -static int zbd_reset_range(struct thread_data *td, struct fio_file *f,=
=0A=
> -			   uint64_t offset, uint64_t length)=0A=
> -{=0A=
> -	uint32_t zone_idx_b, zone_idx_e;=0A=
> -	struct fio_zone_info *zb, *ze, *z;=0A=
> -	int ret =3D 0;=0A=
> -=0A=
> -	assert(is_valid_offset(f, offset + length - 1));=0A=
> -=0A=
> -	switch (f->zbd_info->model) {=0A=
> -	case ZBD_HOST_AWARE:=0A=
> -	case ZBD_HOST_MANAGED:=0A=
> -		ret =3D zbd_reset_wp(td, f, offset, length);=0A=
> -		if (ret < 0)=0A=
> -			return ret;=0A=
> -		break;=0A=
> -	default:=0A=
> -		break;=0A=
> -	}=0A=
> -=0A=
> -	zone_idx_b =3D zbd_zone_idx(f, offset);=0A=
> -	zb =3D &f->zbd_info->zone_info[zone_idx_b];=0A=
> -	zone_idx_e =3D zbd_zone_idx(f, offset + length);=0A=
> -	ze =3D &f->zbd_info->zone_info[zone_idx_e];=0A=
> -	for (z =3D zb; z < ze; z++) {=0A=
> -		pthread_mutex_lock(&z->mutex);=0A=
> -		pthread_mutex_lock(&f->zbd_info->mutex);=0A=
> -		f->zbd_info->sectors_with_data -=3D z->wp - z->start;=0A=
> -		pthread_mutex_unlock(&f->zbd_info->mutex);=0A=
> -		z->wp =3D z->start;=0A=
> -		z->verify_block =3D 0;=0A=
> -		pthread_mutex_unlock(&z->mutex);=0A=
> -	}=0A=
> -=0A=
> -	td->ts.nr_zone_resets +=3D ze - zb;=0A=
> -=0A=
> -	return ret;=0A=
> -}=0A=
> -=0A=
>  static unsigned int zbd_zone_nr(struct zoned_block_device_info *zbd_info=
,=0A=
>  				struct fio_zone_info *zone)=0A=
>  {=0A=
> @@ -735,10 +687,36 @@ static unsigned int zbd_zone_nr(struct zoned_block_=
device_info *zbd_info,=0A=
>  static int zbd_reset_zone(struct thread_data *td, struct fio_file *f,=0A=
>  			  struct fio_zone_info *z)=0A=
>  {=0A=
> +	uint64_t offset =3D z->start;=0A=
> +	uint64_t length =3D (z+1)->start - offset;=0A=
> +	int ret =3D 0;=0A=
> +=0A=
> +	assert(is_valid_offset(f, offset + length - 1));=0A=
> +=0A=
>  	dprint(FD_ZBD, "%s: resetting wp of zone %u.\n", f->file_name,=0A=
>  		zbd_zone_nr(f->zbd_info, z));=0A=
> +	switch (f->zbd_info->model) {=0A=
> +	case ZBD_HOST_AWARE:=0A=
> +	case ZBD_HOST_MANAGED:=0A=
> +		ret =3D zbd_reset_wp(td, f, offset, length);=0A=
> +		if (ret < 0)=0A=
> +			return ret;=0A=
> +		break;=0A=
> +	default:=0A=
> +		break;=0A=
> +	}=0A=
>  =0A=
> -	return zbd_reset_range(td, f, z->start, zbd_zone_end(z) - z->start);=0A=
> +	pthread_mutex_lock(&z->mutex);=0A=
=0A=
Your change is not affecting the locking model, but I wonder if it would no=
t be=0A=
better to lock the zone before calling zbd_reset_wp() so that the device si=
de=0A=
zone reset and the update "z->wp =3D z->start" are atomically executed...=
=0A=
=0A=
> +	pthread_mutex_lock(&f->zbd_info->mutex);=0A=
> +	f->zbd_info->sectors_with_data -=3D z->wp - z->start;=0A=
> +	pthread_mutex_unlock(&f->zbd_info->mutex);=0A=
> +	z->wp =3D z->start;=0A=
> +	z->verify_block =3D 0;=0A=
> +	pthread_mutex_unlock(&z->mutex);=0A=
> +=0A=
> +	td->ts.nr_zone_resets++;=0A=
> +=0A=
> +	return ret;=0A=
>  }=0A=
>  =0A=
>  /* The caller must hold f->zbd_info->mutex */=0A=
> =0A=
=0A=
Anyway, since there does not seem to be any problem with the current lockin=
g=0A=
scheme, looks good.=0A=
=0A=
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=

