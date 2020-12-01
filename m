Return-Path: <prvs=597c5125a=Damien.LeMoal@wdc.com>
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH 8/9] Support copy operation for zoned block devices.
Date: Tue, 1 Dec 2020 12:11:48 +0000
Message-ID: 
 <CH2PR04MB652259B2F0ACC87F5491111CE7F40@CH2PR04MB6522.namprd04.prod.outlook.com>
References: <20201201114034.8307-1-krish.reddy@samsung.com>
 <CGME20201201114110epcas5p34032161c14f467576734346712d0c3db@epcas5p3.samsung.com>
 <20201201114034.8307-9-krish.reddy@samsung.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Krishna Kanth Reddy <krish.reddy@samsung.com>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Ankit Kumar <ankit.kumar@samsung.com>
List-ID: <fio@vger.kernel.org>

On 2020/12/01 20:44, Krishna Kanth Reddy wrote:=0A=
> From: Ankit Kumar <ankit.kumar@samsung.com>=0A=
> =0A=
> Added a check so that source and destination zones don't overlap.=0A=
> Source and destination offsets are aligned to zone start.=0A=
> The source range zone data is copied sequentially to the destination=0A=
> zones.=0A=
> Added a function to reset the destination zones. Source zones won't=0A=
> be reset.=0A=
=0A=
I do not see how this can work correctly without relying on the zone lockin=
g=0A=
mechanism. Other jobs may be writing to the same zones too. That will eithe=
r=0A=
result in the copy failing or the writes failing due to the zone wp unexpec=
tedly=0A=
changing.=0A=
=0A=
> =0A=
> Signed-off-by: Krishna Kanth Reddy <krish.reddy@samsung.com>=0A=
> ---=0A=
>  file.h      |  4 +++=0A=
>  filesetup.c | 18 +++++++++++=0A=
>  init.c      |  5 +++=0A=
>  io_u.c      |  2 +-=0A=
>  zbd.c       | 88 ++++++++++++++++++++++++++++++++++++++++++++++++-----=
=0A=
>  5 files changed, 109 insertions(+), 8 deletions(-)=0A=
> =0A=
> diff --git a/file.h b/file.h=0A=
> index f5a794e4..23012753 100644=0A=
> --- a/file.h=0A=
> +++ b/file.h=0A=
> @@ -110,6 +110,10 @@ struct fio_file {=0A=
>  	uint32_t min_zone;	/* inclusive */=0A=
>  	uint32_t max_zone;	/* exclusive */=0A=
>  =0A=
> +	/* zonemode=3Dzbd copy destination working area */=0A=
> +	uint32_t min_dest_zone;	/* inclusive */=0A=
> +	uint32_t max_dest_zone;	/* exclusive */=0A=
> +=0A=
>  	/*=0A=
>  	 * Track last end and last start of IO for a given data direction=0A=
>  	 */=0A=
> diff --git a/filesetup.c b/filesetup.c=0A=
> index 68a21fac..54752511 100644=0A=
> --- a/filesetup.c=0A=
> +++ b/filesetup.c=0A=
> @@ -1231,6 +1231,24 @@ int setup_files(struct thread_data *td)=0A=
>  =0A=
>  		if (td_copy(td))=0A=
>  			f->file_dest_offset =3D get_dest_offset(td, f);=0A=
> +=0A=
> +		if (td_copy(td) && (td->o.zone_mode =3D=3D ZONE_MODE_ZBD)) {=0A=
> +			if (f->file_offset > f->file_dest_offset) {=0A=
> +				if (f->file_offset - f->file_dest_offset < f->io_size) {=0A=
> +					log_err("%s: For copy operation on ZBD device "=0A=
> +						 "source and destination area shouldn't overlap\n",=0A=
> +						 o->name);=0A=
> +					goto err_out;=0A=
> +				}=0A=
> +			} else {=0A=
> +				if (f->file_dest_offset - f->file_offset < f->io_size) {=0A=
> +					log_err("%s: For copy operation on ZBD device "=0A=
> +						 "source and destination area shouldn't overlap\n",=0A=
> +						 o->name);=0A=
> +					goto err_out;=0A=
> +				}=0A=
> +			}=0A=
> +		}=0A=
>  	}=0A=
>  =0A=
>  	if (td->o.block_error_hist) {=0A=
> diff --git a/init.c b/init.c=0A=
> index e5835b7b..b5db65af 100644=0A=
> --- a/init.c=0A=
> +++ b/init.c=0A=
> @@ -671,6 +671,11 @@ static int fixup_options(struct thread_data *td)=0A=
>  	if (o->zone_mode =3D=3D ZONE_MODE_STRIDED && !o->zone_range)=0A=
>  		o->zone_range =3D o->zone_size;=0A=
>  =0A=
> +	if (o->zone_mode =3D=3D ZONE_MODE_ZBD && td_copy(td) && td_random(td)) =
{=0A=
> +		log_err("fio: --zonemode=3Dzbd supports copy operation only in sequent=
ial mode.\n");=0A=
> +		ret |=3D 1;=0A=
> +	}=0A=
> +=0A=
>  	/*=0A=
>  	 * Reads and copies can do overwrites, we always need to pre-create the=
 file=0A=
>  	 */=0A=
> diff --git a/io_u.c b/io_u.c=0A=
> index 83c7960a..2de91f2a 100644=0A=
> --- a/io_u.c=0A=
> +++ b/io_u.c=0A=
> @@ -1003,7 +1003,7 @@ static int fill_io_u(struct thread_data *td, struct=
 io_u *io_u)=0A=
>  		offset =3D io_u->offset;=0A=
>  	}=0A=
>  =0A=
> -	if (td->o.zone_mode =3D=3D ZONE_MODE_ZBD) {=0A=
> +	if ((td->o.zone_mode =3D=3D ZONE_MODE_ZBD) && !(td_copy(td))) {=0A=
>  		ret =3D zbd_adjust_block(td, io_u);=0A=
>  		if (ret =3D=3D io_u_eof)=0A=
>  			return 1;=0A=
> diff --git a/zbd.c b/zbd.c=0A=
> index 58fed98e..8201665b 100644=0A=
> --- a/zbd.c=0A=
> +++ b/zbd.c=0A=
> @@ -246,11 +246,11 @@ static bool zbd_is_seq_job(struct fio_file *f)=0A=
>   */=0A=
>  static bool zbd_verify_sizes(void)=0A=
>  {=0A=
> -	const struct fio_zone_info *z;=0A=
> +	const struct fio_zone_info *z, *zd;=0A=
>  	struct thread_data *td;=0A=
>  	struct fio_file *f;=0A=
>  	uint64_t new_offset, new_end;=0A=
> -	uint32_t zone_idx;=0A=
> +	uint32_t zone_idx, zone_didx;=0A=
>  	int i, j;=0A=
>  =0A=
>  	for_each_td(td, i) {=0A=
> @@ -259,6 +259,9 @@ static bool zbd_verify_sizes(void)=0A=
>  				continue;=0A=
>  			if (f->file_offset >=3D f->real_file_size)=0A=
>  				continue;=0A=
> +			if ((td->o.td_ddir =3D=3D TD_DDIR_COPY) &&=0A=
> +			    (f->file_dest_offset >=3D f->real_file_size))=0A=
> +				continue;=0A=
>  			if (!zbd_is_seq_job(f))=0A=
>  				continue;=0A=
>  =0A=
> @@ -301,6 +304,15 @@ static bool zbd_verify_sizes(void)=0A=
>  				f->io_size -=3D (new_offset - f->file_offset);=0A=
>  				f->file_offset =3D new_offset;=0A=
>  			}=0A=
> +			if (td->o.td_ddir =3D=3D TD_DDIR_COPY) {=0A=
> +				zone_didx =3D zbd_zone_idx(f, f->file_dest_offset);=0A=
> +				zd =3D &f->zbd_info->zone_info[zone_didx];=0A=
> +				if (f->file_dest_offset !=3D zd->start) {=0A=
> +					new_offset =3D zbd_zone_end(zd);=0A=
> +					f->file_dest_offset =3D new_offset;=0A=
> +				}=0A=
> +			}=0A=
> +=0A=
>  			zone_idx =3D zbd_zone_idx(f, f->file_offset + f->io_size);=0A=
>  			z =3D &f->zbd_info->zone_info[zone_idx];=0A=
>  			new_end =3D z->start;=0A=
> @@ -320,6 +332,12 @@ static bool zbd_verify_sizes(void)=0A=
>  			f->min_zone =3D zbd_zone_idx(f, f->file_offset);=0A=
>  			f->max_zone =3D zbd_zone_idx(f, f->file_offset + f->io_size);=0A=
>  			assert(f->min_zone < f->max_zone);=0A=
> +=0A=
> +			if (td->o.td_ddir =3D=3D TD_DDIR_COPY) {=0A=
> +				f->min_dest_zone =3D zbd_zone_idx(f, f->file_dest_offset);=0A=
> +				f->max_dest_zone =3D zbd_zone_idx(f, f->file_dest_offset + f->io_siz=
e);=0A=
> +				assert(f->min_dest_zone < f->max_dest_zone);=0A=
> +			}=0A=
>  		}=0A=
>  	}=0A=
>  =0A=
> @@ -823,6 +841,42 @@ static int zbd_reset_zones(struct thread_data *td, s=
truct fio_file *f,=0A=
>  	return res;=0A=
>  }=0A=
>  =0A=
> +/*=0A=
> + * Reset a range of zones.=0A=
> + * @td: fio thread data.=0A=
> + * @f: fio file for which to reset zones=0A=
> + */=0A=
> +static void zbd_reset_dest_zones(struct thread_data *td, struct fio_file=
 *f)=0A=
> +{=0A=
> +	struct fio_zone_info *z, *zb, *ze;=0A=
> +	int ret =3D 0;=0A=
> +	uint64_t offset, length;=0A=
> +=0A=
> +	zb =3D &f->zbd_info->zone_info[f->min_dest_zone];=0A=
> +	ze =3D &f->zbd_info->zone_info[f->max_dest_zone];=0A=
> +=0A=
> +	for (z =3D zb; z < ze; z++) {=0A=
> +		offset =3D z->start;=0A=
> +		length =3D (z+1)->start - offset;=0A=
> +=0A=
> +		dprint(FD_ZBD, "%s: resetting wp of zone %u.\n", f->file_name,=0A=
> +		       zbd_zone_nr(f->zbd_info, z));=0A=
> +		switch (f->zbd_info->model) {=0A=
> +		case ZBD_HOST_AWARE:=0A=
> +		case ZBD_HOST_MANAGED:=0A=
> +			ret =3D zbd_reset_wp(td, f, offset, length);=0A=
> +			break;=0A=
> +		default:=0A=
> +			break;=0A=
> +		}=0A=
> +=0A=
> +		if (ret < 0)=0A=
> +			continue;=0A=
> +=0A=
> +		td->ts.nr_zone_resets++;=0A=
> +	}=0A=
> +}=0A=
> +=0A=
>  /*=0A=
>   * Reset zbd_info.write_cnt, the counter that counts down towards the ne=
xt=0A=
>   * zone reset.=0A=
> @@ -924,9 +978,14 @@ void zbd_file_reset(struct thread_data *td, struct f=
io_file *f)=0A=
>  {=0A=
>  	struct fio_zone_info *zb, *ze;=0A=
>  =0A=
> -	if (!f->zbd_info || !td_write(td))=0A=
> +	if (!f->zbd_info || !(td_write(td) || td_copy(td)))=0A=
>  		return;=0A=
>  =0A=
> +	if (td_copy(td)) {=0A=
> +		zbd_reset_dest_zones(td, f);=0A=
> +		return;=0A=
> +	}=0A=
> +=0A=
>  	zb =3D &f->zbd_info->zone_info[f->min_zone];=0A=
>  	ze =3D &f->zbd_info->zone_info[f->max_zone];=0A=
>  	zbd_init_swd(f);=0A=
> @@ -1410,8 +1469,8 @@ void setup_zbd_zone_mode(struct thread_data *td, st=
ruct io_u *io_u)=0A=
>  {=0A=
>  	struct fio_file *f =3D io_u->file;=0A=
>  	enum fio_ddir ddir =3D io_u->ddir;=0A=
> -	struct fio_zone_info *z;=0A=
> -	uint32_t zone_idx;=0A=
> +	struct fio_zone_info *z, *zd;=0A=
> +	uint32_t zone_idx, zone_didx;=0A=
>  =0A=
>  	assert(td->o.zone_mode =3D=3D ZONE_MODE_ZBD);=0A=
>  	assert(td->o.zone_size);=0A=
> @@ -1419,13 +1478,18 @@ void setup_zbd_zone_mode(struct thread_data *td, =
struct io_u *io_u)=0A=
>  	zone_idx =3D zbd_zone_idx(f, f->last_pos[ddir]);=0A=
>  	z =3D &f->zbd_info->zone_info[zone_idx];=0A=
>  =0A=
> +	if (ddir =3D=3D DDIR_COPY) {=0A=
> +		zone_didx =3D zbd_zone_idx(f, f->last_pos_dest[ddir]);=0A=
> +		zd =3D &f->zbd_info->zone_info[zone_didx];=0A=
> +	}=0A=
> +=0A=
>  	/*=0A=
>  	 * When the zone capacity is smaller than the zone size and the I/O is=
=0A=
> -	 * sequential write, skip to zone end if the latest position is at the=
=0A=
> +	 * sequential write or copy, skip to zone end if the latest position is=
 at the=0A=
>  	 * zone capacity limit.=0A=
>  	 */=0A=
>  	if (z->capacity < f->zbd_info->zone_size && !td_random(td) &&=0A=
> -	    ddir =3D=3D DDIR_WRITE &&=0A=
> +	    (ddir =3D=3D DDIR_WRITE || ddir =3D=3D DDIR_COPY) &&=0A=
>  	    f->last_pos[ddir] >=3D zbd_zone_capacity_end(z)) {=0A=
>  		dprint(FD_ZBD,=0A=
>  		       "%s: Jump from zone capacity limit to zone end:"=0A=
> @@ -1436,6 +1500,8 @@ void setup_zbd_zone_mode(struct thread_data *td, st=
ruct io_u *io_u)=0A=
>  		       (unsigned long long) z->capacity);=0A=
>  		td->io_skip_bytes +=3D zbd_zone_end(z) - f->last_pos[ddir];=0A=
>  		f->last_pos[ddir] =3D zbd_zone_end(z);=0A=
> +		if (ddir =3D=3D DDIR_COPY)=0A=
> +			f->last_pos_dest[ddir] =3D zbd_zone_end(zd);=0A=
>  	}=0A=
>  =0A=
>  	/*=0A=
> @@ -1461,13 +1527,21 @@ void setup_zbd_zone_mode(struct thread_data *td, =
struct io_u *io_u)=0A=
>  		td->zone_bytes =3D 0;=0A=
>  		f->file_offset +=3D td->o.zone_size + td->o.zone_skip;=0A=
>  =0A=
> +		if (ddir =3D=3D DDIR_COPY)=0A=
> +			f->file_dest_offset +=3D td->o.zone_size + td->o.zone_skip;=0A=
>  		/*=0A=
>  		 * Wrap from the beginning, if we exceed the file size=0A=
>  		 */=0A=
>  		if (f->file_offset >=3D f->real_file_size)=0A=
>  			f->file_offset =3D get_start_offset(td, f);=0A=
>  =0A=
> +		if ((ddir =3D=3D DDIR_COPY) && f->file_dest_offset >=3D f->real_file_s=
ize)=0A=
> +			f->file_dest_offset =3D get_dest_offset(td, f);=0A=
> +=0A=
>  		f->last_pos[ddir] =3D f->file_offset;=0A=
> +		if (ddir =3D=3D DDIR_COPY)=0A=
> +			f->last_pos_dest[io_u->ddir] =3D f->file_dest_offset;=0A=
> +=0A=
>  		td->io_skip_bytes +=3D td->o.zone_skip;=0A=
>  	}=0A=
>  }=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=

