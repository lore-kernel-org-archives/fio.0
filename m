Return-Path: <prvs=497764fc3=Dmitry.Fomichev@wdc.com>
From: Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
Subject: RE: [PATCH v2 3/7] zbd: Initialize open zones list referring zone
 status at fio start
Date: Sun, 23 Aug 2020 00:17:45 +0000
Message-ID: 
 <MN2PR04MB595132C0DB6CC1315C4ECF16E1590@MN2PR04MB5951.namprd04.prod.outlook.com>
References: <20200821063739.390353-1-shinichiro.kawasaki@wdc.com>
 <20200821063739.390353-4-shinichiro.kawasaki@wdc.com>
In-Reply-To: <20200821063739.390353-4-shinichiro.kawasaki@wdc.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
List-ID: <fio@vger.kernel.org>



> -----Original Message-----
> From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> Sent: Friday, August 21, 2020 2:38 AM
> To: fio@vger.kernel.org; Jens Axboe <axboe@kernel.dk>
> Cc: Damien Le Moal <Damien.LeMoal@wdc.com>; Dmitry Fomichev
> <Dmitry.Fomichev@wdc.com>; Shinichiro Kawasaki
> <shinichiro.kawasaki@wdc.com>
> Subject: [PATCH v2 3/7] zbd: Initialize open zones list referring zone st=
atus at
> fio start
>=20
> When fio starts write workloads to zones with open status, fio does not
> reflect the zone status to open zone list. This results in inconsistent
> open zone accounting.
>=20
> To avoid this inconsistency, initialize the open zone list referring the
> zone status before workload start. If a zone in target range have open
> status, call zbd_open_zone() function to build up the open zone list.
> Since io_u is not available at that timing, make the function independent
> from io_u. If the number of open zones exceeds maximum open zones
> limits,
> reset the exceeding open zone by calling zbd_reset_zone().
>=20
> Of note is that fio counts open zones within the write target range.
> Open zones out of the range are not counted or checked.
>=20
> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> ---
>  zbd.c | 33 ++++++++++++++++++++++++++++-----
>  1 file changed, 28 insertions(+), 5 deletions(-)
>=20
> diff --git a/zbd.c b/zbd.c
> index 82d9af62..255a2f60 100644
> --- a/zbd.c
> +++ b/zbd.c
> @@ -628,6 +628,11 @@ static int zbd_init_zone_info(struct thread_data *td=
,
> struct fio_file *file)
>  	return ret;
>  }
>=20
> +static bool zbd_open_zone(struct thread_data *td, const struct fio_file =
*f,
> +			  uint32_t zone_idx);
> +static int zbd_reset_zone(struct thread_data *td, struct fio_file *f,
> +			  struct fio_zone_info *z);
> +
>  int zbd_setup_files(struct thread_data *td)
>  {
>  	struct fio_file *f;
> @@ -651,6 +656,8 @@ int zbd_setup_files(struct thread_data *td)
>=20
>  	for_each_file(td, f, i) {
>  		struct zoned_block_device_info *zbd =3D f->zbd_info;
> +		struct fio_zone_info *z;
> +		int zi;
>=20
>  		if (!zbd)
>  			continue;
> @@ -666,6 +673,23 @@ int zbd_setup_files(struct thread_data *td)
>  			log_err("'max_open_zones' value is limited by
> %u\n", ZBD_MAX_OPEN_ZONES);
>  			return 1;
>  		}
> +
> +		for (zi =3D f->min_zone; zi < f->max_zone; zi++) {
> +			z =3D &zbd->zone_info[zi];
> +			if (z->cond !=3D ZBD_ZONE_COND_IMP_OPEN &&
> +			    z->cond !=3D ZBD_ZONE_COND_EXP_OPEN)
> +				continue;
> +			if (zbd_open_zone(td, f, zi))
> +				continue;
> +			/*
> +			 * If the number of open zones exceeds specified
> limits,
> +			 * reset and close the exceeding open zones.

Can simply say "reset all extra open zones" here.
Anyway,
Reviewed-by: Dmitry Fomichev: <dmitry.fomichev@wdc.com>

> +			 */
> +			if (zbd_reset_zone(td, f, z) < 0) {
> +				log_err("Failed to reest zone %d\n", zi);
> +				return 1;
> +			}
> +		}
>  	}
>=20
>  	return 0;
> @@ -937,11 +961,10 @@ static bool is_zone_open(const struct thread_data
> *td, const struct fio_file *f,
>   * was not yet open and opening a new zone would cause the zone limit to
> be
>   * exceeded.
>   */
> -static bool zbd_open_zone(struct thread_data *td, const struct io_u *io_=
u,
> +static bool zbd_open_zone(struct thread_data *td, const struct fio_file =
*f,
>  			  uint32_t zone_idx)
>  {
>  	const uint32_t min_bs =3D td->o.min_bs[DDIR_WRITE];
> -	const struct fio_file *f =3D io_u->file;
>  	struct fio_zone_info *z =3D &f->zbd_info->zone_info[zone_idx];
>  	bool res =3D true;
>=20
> @@ -1129,7 +1152,7 @@ open_other_zone:
>  		zone_lock(td, f, z);
>  		if (z->open)
>  			continue;
> -		if (zbd_open_zone(td, io_u, zone_idx))
> +		if (zbd_open_zone(td, f, zone_idx))
>  			goto out;
>  	}
>=20
> @@ -1172,7 +1195,7 @@ static struct fio_zone_info
> *zbd_replay_write_order(struct thread_data *td,
>  	const struct fio_file *f =3D io_u->file;
>  	const uint32_t min_bs =3D td->o.min_bs[DDIR_WRITE];
>=20
> -	if (!zbd_open_zone(td, io_u, z - f->zbd_info->zone_info)) {
> +	if (!zbd_open_zone(td, f, z - f->zbd_info->zone_info)) {
>  		pthread_mutex_unlock(&z->mutex);
>  		z =3D zbd_convert_to_open_zone(td, io_u);
>  		assert(z);
> @@ -1582,7 +1605,7 @@ enum io_u_action zbd_adjust_block(struct
> thread_data *td, struct io_u *io_u)
>  	case DDIR_WRITE:
>  		if (io_u->buflen > f->zbd_info->zone_size)
>  			goto eof;
> -		if (!zbd_open_zone(td, io_u, zone_idx_b)) {
> +		if (!zbd_open_zone(td, f, zone_idx_b)) {
>  			pthread_mutex_unlock(&zb->mutex);
>  			zb =3D zbd_convert_to_open_zone(td, io_u);
>  			if (!zb)
> --
> 2.26.2


