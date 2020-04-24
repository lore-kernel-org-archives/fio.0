Return-Path: <prvs=3768a085d=Damien.LeMoal@wdc.com>
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH] zbd: don't lock zones outside working area
Date: Fri, 24 Apr 2020 08:17:25 +0000
Message-ID: 
 <BY5PR04MB6900E41CFD6CBA366F4232E2E7D00@BY5PR04MB6900.namprd04.prod.outlook.com>
References: <20200423213834.GA22728@avx2>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 2020/04/24 6:38, Alexey Dobriyan wrote:=0A=
> Currently threads tap into each other zones even if their working areas=
=0A=
> as defined by [f->file_offset, f->file_offset + f->io_size) don't interse=
ct.=0A=
> =0A=
> This should remove unnecessary quiescing in iodepth > 1 workloads.=0A=
> =0A=
> Signed-off-by: Alexey Dobriyan (SK hynix) <adobriyan@gmail.com>=0A=
> ---=0A=
> =0A=
>  file.h |    3 +++=0A=
>  zbd.c  |   42 ++++++++++++++++++++++++++++++++----------=0A=
>  2 files changed, 35 insertions(+), 10 deletions(-)=0A=
> =0A=
> --- a/file.h=0A=
> +++ b/file.h=0A=
> @@ -104,6 +104,9 @@ struct fio_file {=0A=
>  	 * Zoned block device information. See also zonemode=3Dzbd.=0A=
>  	 */=0A=
>  	struct zoned_block_device_info *zbd_info;=0A=
> +	/* zonemode=3Dzbd working area */=0A=
> +	uint32_t min_zone;	/* inclusive */=0A=
> +	uint32_t max_zone;	/* exclusive */=0A=
=0A=
For simplicity, what about having both inclusive ?=0A=
=0A=
>  =0A=
>  	/*=0A=
>  	 * Track last end and last start of IO for a given data direction=0A=
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
=0A=
"- 1" to make it inclusive ?=0A=
=0A=
>  		}=0A=
>  	}=0A=
>  =0A=
> @@ -332,6 +341,17 @@ static int ilog2(uint64_t i)=0A=
>  	return log;=0A=
>  }=0A=
>  =0A=
> +static uint32_t clamp_u32(uint32_t x, uint32_t min, uint32_t max)=0A=
> +{=0A=
> +	if (x < min) {=0A=
> +		return min;=0A=
> +	} else if (x > max) {=0A=
> +		return max;=0A=
> +	} else {=0A=
> +		return x;=0A=
> +	}=0A=
> +}=0A=
=0A=
See below comment.=0A=
=0A=
> +=0A=
>  /*=0A=
>   * Initialize f->zbd_info for devices that are not zoned block devices. =
This=0A=
>   * allows to execute a ZBD workload against a non-ZBD device.=0A=
> @@ -735,7 +755,7 @@ static int zbd_reset_zones(struct thread_data *td, st=
ruct fio_file *f,=0A=
>  =0A=
>  		if (!zbd_zone_swr(z))=0A=
>  			continue;=0A=
> -		zone_lock(td, z);=0A=
> +		zone_lock(td, f, z);=0A=
>  		if (all_zones) {=0A=
>  			unsigned int i;=0A=
>  =0A=
> @@ -958,7 +978,7 @@ static struct fio_zone_info *zbd_convert_to_open_zone=
(struct thread_data *td,=0A=
>  						      struct io_u *io_u)=0A=
>  {=0A=
>  	const uint32_t min_bs =3D td->o.min_bs[io_u->ddir];=0A=
> -	const struct fio_file *f =3D io_u->file;=0A=
> +	struct fio_file *f =3D io_u->file;=0A=
>  	struct fio_zone_info *z;=0A=
>  	unsigned int open_zone_idx =3D -1;=0A=
>  	uint32_t zone_idx, new_zone_idx;=0A=
> @@ -975,6 +995,7 @@ static struct fio_zone_info *zbd_convert_to_open_zone=
(struct thread_data *td,=0A=
>  	} else {=0A=
>  		zone_idx =3D zbd_zone_idx(f, io_u->offset);=0A=
>  	}=0A=
> +	zone_idx =3D clamp_u32(zone_idx, f->min_zone, f->max_zone - 1);=0A=
=0A=
Since this is the only place clamp_u32 is used, I think you could just open=
 code=0A=
it here. That plus a comment would make it easier to follow what is going o=
n.=0A=
E.g.:=0A=
=0A=
	/*=0A=
	 * Limit candidate zones to those contained in the thread working area.=0A=
	 */=0A=
	if (zone_idx < f->min_zone)=0A=
		zone_idx =3D f->min_zone;=0A=
	else if (zone_idx > f->max_zone)=0A=
		zone_idx =3D f->max_zone;=0A=
=0A=
=0A=
>  	dprint(FD_ZBD, "%s(%s): starting from zone %d (offset %lld, buflen %lld=
)\n",=0A=
>  	       __func__, f->file_name, zone_idx, io_u->offset, io_u->buflen);=
=0A=
>  =0A=
> @@ -989,7 +1010,7 @@ static struct fio_zone_info *zbd_convert_to_open_zon=
e(struct thread_data *td,=0A=
>  =0A=
>  		z =3D &f->zbd_info->zone_info[zone_idx];=0A=
>  =0A=
> -		zone_lock(td, z);=0A=
> +		zone_lock(td, f, z);=0A=
>  		pthread_mutex_lock(&f->zbd_info->mutex);=0A=
>  		if (td->o.max_open_zones =3D=3D 0)=0A=
>  			goto examine_zone;=0A=
> @@ -1015,8 +1036,7 @@ static struct fio_zone_info *zbd_convert_to_open_zo=
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
> @@ -1061,11 +1081,11 @@ examine_zone:=0A=
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
> @@ -1078,12 +1098,14 @@ examine_zone:=0A=
>  	pthread_mutex_lock(&f->zbd_info->mutex);=0A=
>  	for (i =3D 0; i < f->zbd_info->num_open_zones; i++) {=0A=
>  		zone_idx =3D f->zbd_info->open_zones[i];=0A=
> +		if (!(f->min_zone <=3D zone_idx && zone_idx < f->max_zone))=0A=
> +			continue;=0A=
=0A=
		if (zone_idx < f->min_zone || zone_idx >=3D f->max_zone))=0A=
			continue;=0A=
=0A=
is I think easier to read.=0A=
=0A=
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
> @@ -1409,7 +1431,7 @@ enum io_u_action zbd_adjust_block(struct thread_dat=
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
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=

