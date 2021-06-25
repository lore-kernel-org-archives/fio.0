Return-Path: <prvs=80344d991=Damien.LeMoal@wdc.com>
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH 1/3] zbd: create a local zbdi variable for f->zbd_info
Date: Fri, 25 Jun 2021 07:07:50 +0000
Message-ID: 
 <DM6PR04MB7081ED0BF2182F27B43D3C9DE7069@DM6PR04MB7081.namprd04.prod.outlook.com>
References: <20210624172256.37177-1-Niklas.Cassel@wdc.com>
 <20210624172256.37177-2-Niklas.Cassel@wdc.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Niklas Cassel <Niklas.Cassel@wdc.com>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, "adobriyan@gmail.com" <adobriyan@gmail.com>
List-ID: <fio@vger.kernel.org>

On 2021/06/25 2:23, Niklas Cassel wrote:=0A=
> From: Niklas Cassel <niklas.cassel@wdc.com>=0A=
> =0A=
> Create a local zbdi variable for f->zbd_info for the following functions:=
=0A=
> zbd_open_zone(), zbd_convert_to_open_zone(), and zbd_adjust_block().=0A=
> =0A=
> This avoids unnecessary indirections.=0A=
> =0A=
> No functional change intended.=0A=
> =0A=
> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>=0A=
> ---=0A=
>  zbd.c | 69 +++++++++++++++++++++++++++++++----------------------------=
=0A=
>  1 file changed, 36 insertions(+), 33 deletions(-)=0A=
> =0A=
> diff --git a/zbd.c b/zbd.c=0A=
> index 8e99eb95..f09b0ee6 100644=0A=
> --- a/zbd.c=0A=
> +++ b/zbd.c=0A=
> @@ -1114,6 +1114,7 @@ static bool zbd_open_zone(struct thread_data *td, c=
onst struct fio_file *f,=0A=
>  			  uint32_t zone_idx)=0A=
>  {=0A=
>  	const uint32_t min_bs =3D td->o.min_bs[DDIR_WRITE];=0A=
> +	struct zoned_block_device_info *zbdi =3D f->zbd_info;=0A=
>  	struct fio_zone_info *z =3D get_zone(f, zone_idx);=0A=
>  	bool res =3D true;=0A=
>  =0A=
> @@ -1127,7 +1128,7 @@ static bool zbd_open_zone(struct thread_data *td, c=
onst struct fio_file *f,=0A=
>  	if (td->o.verify !=3D VERIFY_NONE && zbd_zone_full(f, z, min_bs))=0A=
>  		return false;=0A=
>  =0A=
> -	pthread_mutex_lock(&f->zbd_info->mutex);=0A=
> +	pthread_mutex_lock(&zbdi->mutex);=0A=
>  	if (is_zone_open(td, f, zone_idx)) {=0A=
>  		/*=0A=
>  		 * If the zone is already open and going to be full by writes=0A=
> @@ -1142,16 +1143,16 @@ static bool zbd_open_zone(struct thread_data *td,=
 const struct fio_file *f,=0A=
>  	if (td->o.job_max_open_zones > 0 &&=0A=
>  	    td->num_open_zones >=3D td->o.job_max_open_zones)=0A=
>  		goto out;=0A=
> -	if (f->zbd_info->num_open_zones >=3D f->zbd_info->max_open_zones)=0A=
> +	if (zbdi->num_open_zones >=3D zbdi->max_open_zones)=0A=
>  		goto out;=0A=
>  	dprint(FD_ZBD, "%s: opening zone %d\n", f->file_name, zone_idx);=0A=
> -	f->zbd_info->open_zones[f->zbd_info->num_open_zones++] =3D zone_idx;=0A=
> +	zbdi->open_zones[zbdi->num_open_zones++] =3D zone_idx;=0A=
>  	td->num_open_zones++;=0A=
>  	z->open =3D 1;=0A=
>  	res =3D true;=0A=
>  =0A=
>  out:=0A=
> -	pthread_mutex_unlock(&f->zbd_info->mutex);=0A=
> +	pthread_mutex_unlock(&zbdi->mutex);=0A=
>  	return res;=0A=
>  }=0A=
>  =0A=
> @@ -1175,6 +1176,7 @@ static struct fio_zone_info *zbd_convert_to_open_zo=
ne(struct thread_data *td,=0A=
>  {=0A=
>  	const uint32_t min_bs =3D td->o.min_bs[io_u->ddir];=0A=
>  	struct fio_file *f =3D io_u->file;=0A=
> +	struct zoned_block_device_info *zbdi =3D f->zbd_info;=0A=
>  	struct fio_zone_info *z;=0A=
>  	unsigned int open_zone_idx =3D -1;=0A=
>  	uint32_t zone_idx, new_zone_idx;=0A=
> @@ -1185,10 +1187,10 @@ static struct fio_zone_info *zbd_convert_to_open_=
zone(struct thread_data *td,=0A=
>  =0A=
>  	if (td->o.max_open_zones || td->o.job_max_open_zones) {=0A=
>  		/*=0A=
> -		 * This statement accesses f->zbd_info->open_zones[] on purpose=0A=
> +		 * This statement accesses zbdi->open_zones[] on purpose=0A=
>  		 * without locking.=0A=
>  		 */=0A=
> -		zone_idx =3D f->zbd_info->open_zones[pick_random_zone_idx(f, io_u)];=
=0A=
> +		zone_idx =3D zbdi->open_zones[pick_random_zone_idx(f, io_u)];=0A=
>  	} else {=0A=
>  		zone_idx =3D zbd_zone_idx(f, io_u->offset);=0A=
>  	}=0A=
> @@ -1200,9 +1202,9 @@ static struct fio_zone_info *zbd_convert_to_open_zo=
ne(struct thread_data *td,=0A=
>  	       __func__, f->file_name, zone_idx, io_u->offset, io_u->buflen);=
=0A=
>  =0A=
>  	/*=0A=
> -	 * Since z->mutex is the outer lock and f->zbd_info->mutex the inner=0A=
> +	 * Since z->mutex is the outer lock and zbdi->mutex the inner=0A=
>  	 * lock it can happen that the state of the zone with index zone_idx=0A=
> -	 * has changed after 'z' has been assigned and before f->zbd_info->mute=
x=0A=
> +	 * has changed after 'z' has been assigned and before zbdi->mutex=0A=
>  	 * has been obtained. Hence the loop.=0A=
>  	 */=0A=
>  	for (;;) {=0A=
> @@ -1211,12 +1213,12 @@ static struct fio_zone_info *zbd_convert_to_open_=
zone(struct thread_data *td,=0A=
>  		z =3D get_zone(f, zone_idx);=0A=
>  		if (z->has_wp)=0A=
>  			zone_lock(td, f, z);=0A=
> -		pthread_mutex_lock(&f->zbd_info->mutex);=0A=
> +		pthread_mutex_lock(&zbdi->mutex);=0A=
>  		if (z->has_wp) {=0A=
>  			if (z->cond !=3D ZBD_ZONE_COND_OFFLINE &&=0A=
>  			    td->o.max_open_zones =3D=3D 0 && td->o.job_max_open_zones =3D=3D =
0)=0A=
>  				goto examine_zone;=0A=
> -			if (f->zbd_info->num_open_zones =3D=3D 0) {=0A=
> +			if (zbdi->num_open_zones =3D=3D 0) {=0A=
>  				dprint(FD_ZBD, "%s(%s): no zones are open\n",=0A=
>  				       __func__, f->file_name);=0A=
>  				goto open_other_zone;=0A=
> @@ -1230,14 +1232,14 @@ static struct fio_zone_info *zbd_convert_to_open_=
zone(struct thread_data *td,=0A=
>  		 */=0A=
>  		open_zone_idx =3D pick_random_zone_idx(f, io_u);=0A=
>  		assert(!open_zone_idx ||=0A=
> -		       open_zone_idx < f->zbd_info->num_open_zones);=0A=
> +		       open_zone_idx < zbdi->num_open_zones);=0A=
>  		tmp_idx =3D open_zone_idx;=0A=
> -		for (i =3D 0; i < f->zbd_info->num_open_zones; i++) {=0A=
> +		for (i =3D 0; i < zbdi->num_open_zones; i++) {=0A=
>  			uint32_t tmpz;=0A=
>  =0A=
> -			if (tmp_idx >=3D f->zbd_info->num_open_zones)=0A=
> +			if (tmp_idx >=3D zbdi->num_open_zones)=0A=
>  				tmp_idx =3D 0;=0A=
> -			tmpz =3D f->zbd_info->open_zones[tmp_idx];=0A=
> +			tmpz =3D zbdi->open_zones[tmp_idx];=0A=
>  			if (f->min_zone <=3D tmpz && tmpz < f->max_zone) {=0A=
>  				open_zone_idx =3D tmp_idx;=0A=
>  				goto found_candidate_zone;=0A=
> @@ -1248,39 +1250,39 @@ static struct fio_zone_info *zbd_convert_to_open_=
zone(struct thread_data *td,=0A=
>  =0A=
>  		dprint(FD_ZBD, "%s(%s): no candidate zone\n",=0A=
>  			__func__, f->file_name);=0A=
> -		pthread_mutex_unlock(&f->zbd_info->mutex);=0A=
> +		pthread_mutex_unlock(&zbdi->mutex);=0A=
>  		if (z->has_wp)=0A=
>  			zone_unlock(z);=0A=
>  		return NULL;=0A=
>  =0A=
>  found_candidate_zone:=0A=
> -		new_zone_idx =3D f->zbd_info->open_zones[open_zone_idx];=0A=
> +		new_zone_idx =3D zbdi->open_zones[open_zone_idx];=0A=
>  		if (new_zone_idx =3D=3D zone_idx)=0A=
>  			break;=0A=
>  		zone_idx =3D new_zone_idx;=0A=
> -		pthread_mutex_unlock(&f->zbd_info->mutex);=0A=
> +		pthread_mutex_unlock(&zbdi->mutex);=0A=
>  		if (z->has_wp)=0A=
>  			zone_unlock(z);=0A=
>  	}=0A=
>  =0A=
> -	/* Both z->mutex and f->zbd_info->mutex are held. */=0A=
> +	/* Both z->mutex and zbdi->mutex are held. */=0A=
>  =0A=
>  examine_zone:=0A=
>  	if (z->wp + min_bs <=3D zbd_zone_capacity_end(z)) {=0A=
> -		pthread_mutex_unlock(&f->zbd_info->mutex);=0A=
> +		pthread_mutex_unlock(&zbdi->mutex);=0A=
>  		goto out;=0A=
>  	}=0A=
>  =0A=
>  open_other_zone:=0A=
>  	/* Check if number of open zones reaches one of limits. */=0A=
>  	wait_zone_close =3D=0A=
> -		f->zbd_info->num_open_zones =3D=3D f->max_zone - f->min_zone ||=0A=
> +		zbdi->num_open_zones =3D=3D f->max_zone - f->min_zone ||=0A=
>  		(td->o.max_open_zones &&=0A=
> -		 f->zbd_info->num_open_zones =3D=3D td->o.max_open_zones) ||=0A=
> +		 zbdi->num_open_zones =3D=3D td->o.max_open_zones) ||=0A=
>  		(td->o.job_max_open_zones &&=0A=
>  		 td->num_open_zones =3D=3D td->o.job_max_open_zones);=0A=
>  =0A=
> -	pthread_mutex_unlock(&f->zbd_info->mutex);=0A=
> +	pthread_mutex_unlock(&zbdi->mutex);=0A=
>  =0A=
>  	/* Only z->mutex is held. */=0A=
>  =0A=
> @@ -1295,7 +1297,7 @@ open_other_zone:=0A=
>  	}=0A=
>  =0A=
>  	/* Zone 'z' is full, so try to open a new zone. */=0A=
> -	for (i =3D f->io_size / f->zbd_info->zone_size; i > 0; i--) {=0A=
> +	for (i =3D f->io_size / zbdi->zone_size; i > 0; i--) {=0A=
>  		zone_idx++;=0A=
>  		if (z->has_wp)=0A=
>  			zone_unlock(z);=0A=
> @@ -1318,12 +1320,12 @@ open_other_zone:=0A=
>  	/* Only z->mutex is held. */=0A=
>  =0A=
>  	/* Check whether the write fits in any of the already opened zones. */=
=0A=
> -	pthread_mutex_lock(&f->zbd_info->mutex);=0A=
> -	for (i =3D 0; i < f->zbd_info->num_open_zones; i++) {=0A=
> -		zone_idx =3D f->zbd_info->open_zones[i];=0A=
> +	pthread_mutex_lock(&zbdi->mutex);=0A=
> +	for (i =3D 0; i < zbdi->num_open_zones; i++) {=0A=
> +		zone_idx =3D zbdi->open_zones[i];=0A=
>  		if (zone_idx < f->min_zone || zone_idx >=3D f->max_zone)=0A=
>  			continue;=0A=
> -		pthread_mutex_unlock(&f->zbd_info->mutex);=0A=
> +		pthread_mutex_unlock(&zbdi->mutex);=0A=
>  		zone_unlock(z);=0A=
>  =0A=
>  		z =3D get_zone(f, zone_idx);=0A=
> @@ -1331,9 +1333,9 @@ open_other_zone:=0A=
>  		zone_lock(td, f, z);=0A=
>  		if (z->wp + min_bs <=3D zbd_zone_capacity_end(z))=0A=
>  			goto out;=0A=
> -		pthread_mutex_lock(&f->zbd_info->mutex);=0A=
> +		pthread_mutex_lock(&zbdi->mutex);=0A=
>  	}=0A=
> -	pthread_mutex_unlock(&f->zbd_info->mutex);=0A=
> +	pthread_mutex_unlock(&zbdi->mutex);=0A=
>  	zone_unlock(z);=0A=
>  	dprint(FD_ZBD, "%s(%s): did not open another zone\n", __func__,=0A=
>  	       f->file_name);=0A=
> @@ -1683,6 +1685,7 @@ enum fio_ddir zbd_adjust_ddir(struct thread_data *t=
d, struct io_u *io_u,=0A=
>  enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *i=
o_u)=0A=
>  {=0A=
>  	struct fio_file *f =3D io_u->file;=0A=
> +	struct zoned_block_device_info *zbdi =3D f->zbd_info;=0A=
>  	uint32_t zone_idx_b;=0A=
>  	struct fio_zone_info *zb, *zl, *orig_zb;=0A=
>  	uint32_t orig_len =3D io_u->buflen;=0A=
> @@ -1690,7 +1693,7 @@ enum io_u_action zbd_adjust_block(struct thread_dat=
a *td, struct io_u *io_u)=0A=
>  	uint64_t new_len;=0A=
>  	int64_t range;=0A=
>  =0A=
> -	assert(f->zbd_info);=0A=
> +	assert(zbdi);=0A=
>  	assert(min_bs);=0A=
>  	assert(is_valid_offset(f, io_u->offset));=0A=
>  	assert(io_u->buflen);=0A=
> @@ -1802,12 +1805,12 @@ enum io_u_action zbd_adjust_block(struct thread_d=
ata *td, struct io_u *io_u)=0A=
>  		assert(io_u->offset + io_u->buflen <=3D zb->wp);=0A=
>  		goto accept;=0A=
>  	case DDIR_WRITE:=0A=
> -		if (io_u->buflen > f->zbd_info->zone_size) {=0A=
> +		if (io_u->buflen > zbdi->zone_size) {=0A=
>  			td_verror(td, EINVAL, "I/O buflen exceeds zone size");=0A=
>  			dprint(FD_IO,=0A=
>  			       "%s: I/O buflen %llu exceeds zone size %llu\n",=0A=
>  			       f->file_name, io_u->buflen,=0A=
> -			       (unsigned long long) f->zbd_info->zone_size);=0A=
> +			       (unsigned long long) zbdi->zone_size);=0A=
>  			goto eof;=0A=
>  		}=0A=
>  		if (!zbd_open_zone(td, f, zone_idx_b)) {=0A=
> @@ -1822,7 +1825,7 @@ enum io_u_action zbd_adjust_block(struct thread_dat=
a *td, struct io_u *io_u)=0A=
>  		}=0A=
>  		/* Check whether the zone reset threshold has been exceeded */=0A=
>  		if (td->o.zrf.u.f) {=0A=
> -			if (f->zbd_info->wp_sectors_with_data >=3D=0A=
> +			if (zbdi->wp_sectors_with_data >=3D=0A=
>  			    f->io_size * td->o.zrt.u.f &&=0A=
>  			    zbd_dec_and_reset_write_cnt(td, f)) {=0A=
>  				zb->reset_zone =3D 1;=0A=
> =0A=
=0A=
Looks good.=0A=
=0A=
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=

