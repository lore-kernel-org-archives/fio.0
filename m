Return-Path: <prvs=383ebf04e=Damien.LeMoal@wdc.com>
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH 2/7] zbd: don't lock zones outside working area
Date: Fri, 1 May 2020 01:27:51 +0000
Message-ID: 
 <BY5PR04MB6900E1AF662357DF5435CA49E7AB0@BY5PR04MB6900.namprd04.prod.outlook.com>
References: <20200430124050.20146-1-adobriyan@gmail.com>
 <20200430124050.20146-2-adobriyan@gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 2020/04/30 21:41, Alexey Dobriyan wrote:=0A=
> Currently threads tap into each other zones even if their working areas=
=0A=
> as defined by [f->file_offset, f->file_offset + f->io_size) don't interse=
ct.=0A=
=0A=
You are only stating the current problem. Please add a short description of=
 what=0A=
this patch does to resolve it.=0A=
=0A=
> =0A=
> This should remove unnecessary quiescing.=0A=
> =0A=
> Signed-off-by: Alexey Dobriyan (SK hynix) <adobriyan@gmail.com>=0A=
> ---=0A=
>  file.h |  3 +++=0A=
>  zbd.c  | 35 +++++++++++++++++++++++++----------=0A=
>  2 files changed, 28 insertions(+), 10 deletions(-)=0A=
> =0A=
> diff --git a/file.h b/file.h=0A=
> index ae0e6fc8..375bbfd3 100644=0A=
> --- a/file.h=0A=
> +++ b/file.h=0A=
> @@ -104,6 +104,9 @@ struct fio_file {=0A=
>  	 * Zoned block device information. See also zonemode=3Dzbd.=0A=
>  	 */=0A=
>  	struct zoned_block_device_info *zbd_info;=0A=
> +	/* zonemode=3Dzbd working area */=0A=
> +	uint32_t min_zone;	/* inclusive */=0A=
> +	uint32_t max_zone;	/* exclusive */=0A=
>  =0A=
>  	/*=0A=
>  	 * Track last end and last start of IO for a given data direction=0A=
> diff --git a/zbd.c b/zbd.c=0A=
> index 9f5a89ed..e8f0a4d8 100644=0A=
> --- a/zbd.c=0A=
> +++ b/zbd.c=0A=
> @@ -156,8 +156,14 @@ static bool zbd_zone_full(const struct fio_file *f, =
struct fio_zone_info *z,=0A=
>  		z->wp + required > z->start + f->zbd_info->zone_size;=0A=
>  }=0A=
>  =0A=
> -static void zone_lock(struct thread_data *td, struct fio_zone_info *z)=
=0A=
> +static void zone_lock(struct thread_data *td, struct fio_file *f, struct=
 fio_zone_info *z)=0A=
>  {=0A=
> +	struct zoned_block_device_info *zbd =3D f->zbd_info;=0A=
> +	uint32_t nz =3D z - zbd->zone_info;=0A=
> +=0A=
> +	/* Thread should never lock zones outside its working area. */=0A=
=0A=
	/* A thread should never lock zones outside its working area. */=0A=
=0A=
> +	assert(f->min_zone <=3D nz && nz < f->max_zone);=0A=
> +=0A=
>  	/*=0A=
>  	 * Lock the io_u target zone. The zone will be unlocked if io_u offset=
=0A=
>  	 * is changed or when io_u completes and zbd_put_io() executed.=0A=
> @@ -289,6 +295,9 @@ static bool zbd_verify_sizes(void)=0A=
>  					 (unsigned long long) new_end - f->file_offset);=0A=
>  				f->io_size =3D new_end - f->file_offset;=0A=
>  			}=0A=
> +=0A=
> +			f->min_zone =3D zbd_zone_idx(f, f->file_offset);=0A=
> +			f->max_zone =3D zbd_zone_idx(f, f->file_offset + f->io_size);=0A=
>  		}=0A=
>  	}=0A=
>  =0A=
> @@ -735,7 +744,7 @@ static int zbd_reset_zones(struct thread_data *td, st=
ruct fio_file *f,=0A=
>  =0A=
>  		if (!zbd_zone_swr(z))=0A=
>  			continue;=0A=
> -		zone_lock(td, z);=0A=
> +		zone_lock(td, f, z);=0A=
>  		if (all_zones) {=0A=
>  			unsigned int i;=0A=
>  =0A=
> @@ -958,7 +967,7 @@ static struct fio_zone_info *zbd_convert_to_open_zone=
(struct thread_data *td,=0A=
>  						      struct io_u *io_u)=0A=
>  {=0A=
>  	const uint32_t min_bs =3D td->o.min_bs[io_u->ddir];=0A=
> -	const struct fio_file *f =3D io_u->file;=0A=
> +	struct fio_file *f =3D io_u->file;=0A=
>  	struct fio_zone_info *z;=0A=
>  	unsigned int open_zone_idx =3D -1;=0A=
>  	uint32_t zone_idx, new_zone_idx;=0A=
> @@ -975,6 +984,11 @@ static struct fio_zone_info *zbd_convert_to_open_zon=
e(struct thread_data *td,=0A=
>  	} else {=0A=
>  		zone_idx =3D zbd_zone_idx(f, io_u->offset);=0A=
>  	}=0A=
> +	if (zone_idx < f->min_zone) {=0A=
> +		zone_idx =3D f->min_zone;=0A=
> +	} else if (zone_idx >=3D f->max_zone) {=0A=
> +		zone_idx =3D f->max_zone - 1;=0A=
> +	}=0A=
=0A=
No need for the {} brackets.=0A=
=0A=
>  	dprint(FD_ZBD, "%s(%s): starting from zone %d (offset %lld, buflen %lld=
)\n",=0A=
>  	       __func__, f->file_name, zone_idx, io_u->offset, io_u->buflen);=
=0A=
>  =0A=
> @@ -989,7 +1003,7 @@ static struct fio_zone_info *zbd_convert_to_open_zon=
e(struct thread_data *td,=0A=
>  =0A=
>  		z =3D &f->zbd_info->zone_info[zone_idx];=0A=
>  =0A=
> -		zone_lock(td, z);=0A=
> +		zone_lock(td, f, z);=0A=
>  		pthread_mutex_lock(&f->zbd_info->mutex);=0A=
>  		if (td->o.max_open_zones =3D=3D 0)=0A=
>  			goto examine_zone;=0A=
> @@ -1015,8 +1029,7 @@ static struct fio_zone_info *zbd_convert_to_open_zo=
ne(struct thread_data *td,=0A=
>  			if (tmp_idx >=3D f->zbd_info->num_open_zones)=0A=
>  				tmp_idx =3D 0;=0A=
>  			tmpz =3D f->zbd_info->open_zones[tmp_idx];=0A=
> -=0A=
> -			if (is_valid_offset(f, f->zbd_info->zone_info[tmpz].start)) {=0A=
> +			if (f->min_zone <=3D tmpz && tmpz < f->max_zone) {=0A=
>  				open_zone_idx =3D tmp_idx;=0A=
>  				goto found_candidate_zone;=0A=
>  			}=0A=
> @@ -1061,11 +1074,11 @@ examine_zone:=0A=
>  		z++;=0A=
>  		if (!is_valid_offset(f, z->start)) {=0A=
>  			/* Wrap-around. */=0A=
> -			zone_idx =3D zbd_zone_idx(f, f->file_offset);=0A=
> +			zone_idx =3D f->min_zone;=0A=
>  			z =3D &f->zbd_info->zone_info[zone_idx];=0A=
>  		}=0A=
>  		assert(is_valid_offset(f, z->start));=0A=
> -		zone_lock(td, z);=0A=
> +		zone_lock(td, f, z);=0A=
>  		if (z->open)=0A=
>  			continue;=0A=
>  		if (zbd_open_zone(td, io_u, zone_idx))=0A=
> @@ -1078,12 +1091,14 @@ examine_zone:=0A=
>  	pthread_mutex_lock(&f->zbd_info->mutex);=0A=
>  	for (i =3D 0; i < f->zbd_info->num_open_zones; i++) {=0A=
>  		zone_idx =3D f->zbd_info->open_zones[i];=0A=
> +		if (zone_idx < f->min_zone || zone_idx >=3D f->max_zone)=0A=
> +			continue;=0A=
>  		pthread_mutex_unlock(&f->zbd_info->mutex);=0A=
>  		pthread_mutex_unlock(&z->mutex);=0A=
>  =0A=
>  		z =3D &f->zbd_info->zone_info[zone_idx];=0A=
>  =0A=
> -		zone_lock(td, z);=0A=
> +		zone_lock(td, f, z);=0A=
>  		if (z->wp + min_bs <=3D (z+1)->start)=0A=
>  			goto out;=0A=
>  		pthread_mutex_lock(&f->zbd_info->mutex);=0A=
> @@ -1409,7 +1424,7 @@ enum io_u_action zbd_adjust_block(struct thread_dat=
a *td, struct io_u *io_u)=0A=
>  =0A=
>  	zbd_check_swd(f);=0A=
>  =0A=
> -	zone_lock(td, zb);=0A=
> +	zone_lock(td, f, zb);=0A=
>  =0A=
>  	switch (io_u->ddir) {=0A=
>  	case DDIR_READ:=0A=
> =0A=
=0A=
With the above nits fixed, feel free to add:=0A=
=0A=
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=

