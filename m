Return-Path: <prvs=464b1537e=Damien.LeMoal@wdc.com>
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH v3 1/6] zbd: Support zone capacity smaller than zone size
Date: Tue, 21 Jul 2020 09:51:37 +0000
Message-ID: 
 <CY4PR04MB37515AD57362875478035637E7780@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <20200717093637.139565-1-shinichiro.kawasaki@wdc.com>
 <20200717093637.139565-2-shinichiro.kawasaki@wdc.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc: Hans Holmberg <Hans.Holmberg@wdc.com>, Aravind Ramesh <Aravind.Ramesh@wdc.com>
List-ID: <fio@vger.kernel.org>

On 2020/07/17 18:36, Shin'ichiro Kawasaki wrote:=0A=
> NVMe ZNS specification defines zone capacity. The report zone interface=
=0A=
> of Linux kernel supports it. This patch adds support for this new=0A=
> interface.=0A=
> =0A=
> Modify configure to check availability of BLK_ZONE_REP_CAPACITY flag as=
=0A=
> well as blkzoned.h header only when target OS is Linux. If this flag is=
=0A=
> defined and set in the report zone, all sectors from the zone capacity up=
=0A=
> to the zone size are not accessible. Prevent read and write operations to=
=0A=
> these sectors by modifying zbd_adjust_block(). Of note is that this skips=
=0A=
> the region between zone capacity and zone size then reduces total I/O=0A=
> bytes of sequential workloads.=0A=
> =0A=
> Introduce helper functions zbd_zone_end() and zbd_zone_capacity_end() to=
=0A=
> improve readability of zone limit check code.=0A=
> =0A=
> Signed-off-by: Aravind Ramesh <aravind.ramesh@wdc.com>=0A=
> Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>=0A=
> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>=0A=
> ---=0A=
>  configure              | 19 +++++++++++=0A=
>  engines/libzbc.c       |  5 +++=0A=
>  oslib/linux-blkzoned.c | 11 +++++++=0A=
>  zbd.c                  | 74 +++++++++++++++++++++++++++++++++---------=
=0A=
>  zbd.h                  |  2 ++=0A=
>  zbd_types.h            |  1 +=0A=
>  6 files changed, 97 insertions(+), 15 deletions(-)=0A=
> =0A=
> diff --git a/configure b/configure=0A=
> index 6991393b..b079a2a5 100755=0A=
> --- a/configure=0A=
> +++ b/configure=0A=
> @@ -2390,6 +2390,7 @@ if compile_prog "" "" "valgrind_dev"; then=0A=
>  fi=0A=
>  print_config "Valgrind headers" "$valgrind_dev"=0A=
>  =0A=
> +if test "$targetos" =3D "Linux" ; then=0A=
>  ##########################################=0A=
>  # <linux/blkzoned.h> probe=0A=
>  if test "$linux_blkzoned" !=3D "yes" ; then=0A=
> @@ -2407,6 +2408,24 @@ if compile_prog "" "" "linux_blkzoned"; then=0A=
>  fi=0A=
>  print_config "Zoned block device support" "$linux_blkzoned"=0A=
>  =0A=
> +##########################################=0A=
> +# Check BLK_ZONE_REP_CAPACITY=0A=
> +cat > $TMPC << EOF=0A=
> +#include <linux/blkzoned.h>=0A=
> +int main(void)=0A=
> +{=0A=
> +  return BLK_ZONE_REP_CAPACITY;=0A=
> +}=0A=
> +EOF=0A=
> +if compile_prog "" "" "blkzoned report capacity"; then=0A=
> +  output_sym "CONFIG_HAVE_REP_CAPACITY"=0A=
> +  rep_capacity=3D"yes"=0A=
> +else=0A=
> +  rep_capacity=3D"no"=0A=
> +fi=0A=
> +print_config "Zoned block device capacity" "$rep_capacity"=0A=
> +fi=0A=
> +=0A=
>  ##########################################=0A=
>  # libzbc probe=0A=
>  if test "$libzbc" !=3D "yes" ; then=0A=
> diff --git a/engines/libzbc.c b/engines/libzbc.c=0A=
> index fdde8ca6..4b900233 100644=0A=
> --- a/engines/libzbc.c=0A=
> +++ b/engines/libzbc.c=0A=
> @@ -235,6 +235,11 @@ static int libzbc_report_zones(struct thread_data *t=
d, struct fio_file *f,=0A=
>  		zbdz->start =3D zones[i].zbz_start << 9;=0A=
>  		zbdz->len =3D zones[i].zbz_length << 9;=0A=
>  		zbdz->wp =3D zones[i].zbz_write_pointer << 9;=0A=
> +		/*=0A=
> +		 * ZBC/ZAC do not define zone capacity, so use the zone size as=0A=
> +		 * the zone capacity.=0A=
> +		 */=0A=
> +		zbdz->capacity =3D zbdz->len;=0A=
>  =0A=
>  		switch (zones[i].zbz_type) {=0A=
>  		case ZBC_ZT_CONVENTIONAL:=0A=
> diff --git a/oslib/linux-blkzoned.c b/oslib/linux-blkzoned.c=0A=
> index 1cf06363..6fe78b9c 100644=0A=
> --- a/oslib/linux-blkzoned.c=0A=
> +++ b/oslib/linux-blkzoned.c=0A=
> @@ -113,6 +113,16 @@ out:=0A=
>  	return 0;=0A=
>  }=0A=
>  =0A=
> +static uint64_t zone_capacity(struct blk_zone_report *hdr,=0A=
> +			      struct blk_zone *blkz)=0A=
> +{=0A=
> +#ifdef CONFIG_HAVE_REP_CAPACITY=0A=
> +	if (hdr->flags & BLK_ZONE_REP_CAPACITY)=0A=
> +		return blkz->capacity << 9;=0A=
> +#endif=0A=
> +	return blkz->len << 9;=0A=
> +}=0A=
> +=0A=
>  int blkzoned_report_zones(struct thread_data *td, struct fio_file *f,=0A=
>  			  uint64_t offset, struct zbd_zone *zones,=0A=
>  			  unsigned int nr_zones)=0A=
> @@ -149,6 +159,7 @@ int blkzoned_report_zones(struct thread_data *td, str=
uct fio_file *f,=0A=
>  		z->start =3D blkz->start << 9;=0A=
>  		z->wp =3D blkz->wp << 9;=0A=
>  		z->len =3D blkz->len << 9;=0A=
> +		z->capacity =3D zone_capacity(hdr, blkz);=0A=
>  =0A=
>  		switch (blkz->type) {=0A=
>  		case BLK_ZONE_TYPE_CONVENTIONAL:=0A=
> diff --git a/zbd.c b/zbd.c=0A=
> index cf2cded9..c738a58b 100644=0A=
> --- a/zbd.c=0A=
> +++ b/zbd.c=0A=
> @@ -140,6 +140,24 @@ static inline bool zbd_zone_swr(struct fio_zone_info=
 *z)=0A=
>  	return z->type =3D=3D ZBD_ZONE_TYPE_SWR;=0A=
>  }=0A=
>  =0A=
> +/**=0A=
> + * zbd_zone_end - Return zone end location=0A=
> + * @z: zone info pointer.=0A=
> + */=0A=
> +static inline uint64_t zbd_zone_end(const struct fio_zone_info *z)=0A=
> +{=0A=
> +	return (z+1)->start;=0A=
> +}=0A=
> +=0A=
> +/**=0A=
> + * zbd_zone_capacity_end - Return zone capacity limit end location=0A=
> + * @z: zone info pointer.=0A=
> + */=0A=
> +static inline uint64_t zbd_zone_capacity_end(const struct fio_zone_info =
*z)=0A=
> +{=0A=
> +	return z->start + z->capacity;=0A=
> +}=0A=
> +=0A=
>  /**=0A=
>   * zbd_zone_full - verify whether a minimum number of bytes remain in a =
zone=0A=
>   * @f: file pointer.=0A=
> @@ -154,7 +172,7 @@ static bool zbd_zone_full(const struct fio_file *f, s=
truct fio_zone_info *z,=0A=
>  	assert((required & 511) =3D=3D 0);=0A=
>  =0A=
>  	return zbd_zone_swr(z) &&=0A=
> -		z->wp + required > z->start + f->zbd_info->zone_size;=0A=
> +		z->wp + required > zbd_zone_capacity_end(z);=0A=
>  }=0A=
>  =0A=
>  static void zone_lock(struct thread_data *td, struct fio_file *f, struct=
 fio_zone_info *z)=0A=
> @@ -271,7 +289,7 @@ static bool zbd_verify_sizes(void)=0A=
>  			z =3D &f->zbd_info->zone_info[zone_idx];=0A=
>  			if ((f->file_offset !=3D z->start) &&=0A=
>  			    (td->o.td_ddir !=3D TD_DDIR_READ)) {=0A=
> -				new_offset =3D (z+1)->start;=0A=
> +				new_offset =3D zbd_zone_end(z);=0A=
>  				if (new_offset >=3D f->file_offset + f->io_size) {=0A=
>  					log_info("%s: io_size must be at least one zone\n",=0A=
>  						 f->file_name);=0A=
> @@ -384,6 +402,7 @@ static int init_zone_info(struct thread_data *td, str=
uct fio_file *f)=0A=
>  		p->wp =3D p->start;=0A=
>  		p->type =3D ZBD_ZONE_TYPE_SWR;=0A=
>  		p->cond =3D ZBD_ZONE_COND_EMPTY;=0A=
> +		p->capacity =3D zone_size;=0A=
>  	}=0A=
>  	/* a sentinel */=0A=
>  	p->start =3D nr_zones * zone_size;=0A=
> @@ -456,10 +475,11 @@ static int parse_zone_info(struct thread_data *td, =
struct fio_file *f)=0A=
>  			mutex_init_pshared_with_type(&p->mutex,=0A=
>  						     PTHREAD_MUTEX_RECURSIVE);=0A=
>  			p->start =3D z->start;=0A=
> +			p->capacity =3D z->capacity;=0A=
>  			switch (z->cond) {=0A=
>  			case ZBD_ZONE_COND_NOT_WP:=0A=
>  			case ZBD_ZONE_COND_FULL:=0A=
> -				p->wp =3D p->start + zone_size;=0A=
> +				p->wp =3D p->start + p->capacity;=0A=
>  				break;=0A=
>  			default:=0A=
>  				assert(z->start <=3D z->wp);=0A=
> @@ -707,7 +727,7 @@ static int zbd_reset_zone(struct thread_data *td, str=
uct fio_file *f,=0A=
>  	dprint(FD_ZBD, "%s: resetting wp of zone %u.\n", f->file_name,=0A=
>  		zbd_zone_nr(f->zbd_info, z));=0A=
>  =0A=
> -	return zbd_reset_range(td, f, z->start, (z+1)->start - z->start);=0A=
> +	return zbd_reset_range(td, f, z->start, zbd_zone_end(z) - z->start);=0A=
>  }=0A=
>  =0A=
>  /* The caller must hold f->zbd_info->mutex */=0A=
> @@ -1068,7 +1088,7 @@ found_candidate_zone:=0A=
>  	/* Both z->mutex and f->zbd_info->mutex are held. */=0A=
>  =0A=
>  examine_zone:=0A=
> -	if (z->wp + min_bs <=3D (z+1)->start) {=0A=
> +	if (z->wp + min_bs <=3D zbd_zone_capacity_end(z)) {=0A=
>  		pthread_mutex_unlock(&f->zbd_info->mutex);=0A=
>  		goto out;=0A=
>  	}=0A=
> @@ -1112,7 +1132,7 @@ examine_zone:=0A=
>  		z =3D &f->zbd_info->zone_info[zone_idx];=0A=
>  =0A=
>  		zone_lock(td, f, z);=0A=
> -		if (z->wp + min_bs <=3D (z+1)->start)=0A=
> +		if (z->wp + min_bs <=3D zbd_zone_capacity_end(z))=0A=
>  			goto out;=0A=
>  		pthread_mutex_lock(&f->zbd_info->mutex);=0A=
>  	}=0A=
> @@ -1143,9 +1163,9 @@ static struct fio_zone_info *zbd_replay_write_order=
(struct thread_data *td,=0A=
>  		assert(z);=0A=
>  	}=0A=
>  =0A=
> -	if (z->verify_block * min_bs >=3D f->zbd_info->zone_size)=0A=
> +	if (z->verify_block * min_bs >=3D z->capacity)=0A=
>  		log_err("%s: %d * %d >=3D %llu\n", f->file_name, z->verify_block,=0A=
> -			min_bs, (unsigned long long) f->zbd_info->zone_size);=0A=
> +			min_bs, (unsigned long long)z->capacity);=0A=
>  	io_u->offset =3D z->start + z->verify_block++ * min_bs;=0A=
>  	return z;=0A=
>  }=0A=
> @@ -1231,7 +1251,7 @@ static void zbd_queue_io(struct io_u *io_u, int q, =
bool success)=0A=
>  	switch (io_u->ddir) {=0A=
>  	case DDIR_WRITE:=0A=
>  		zone_end =3D min((uint64_t)(io_u->offset + io_u->buflen),=0A=
> -			       (z + 1)->start);=0A=
> +			       zbd_zone_capacity_end(z));=0A=
>  		pthread_mutex_lock(&zbd_info->mutex);=0A=
>  		/*=0A=
>  		 * z->wp > zone_end means that one or more I/O errors=0A=
> @@ -1327,6 +1347,26 @@ void setup_zbd_zone_mode(struct thread_data *td, s=
truct io_u *io_u)=0A=
>  	assert(td->o.zone_mode =3D=3D ZONE_MODE_ZBD);=0A=
>  	assert(td->o.zone_size);=0A=
>  =0A=
> +	zone_idx =3D zbd_zone_idx(f, f->last_pos[ddir]);=0A=
> +	z =3D &f->zbd_info->zone_info[zone_idx];=0A=
> +=0A=
> +	/*=0A=
> +	 * When the zone capacity is smaller than the zone size and the I/O is=
=0A=
> +	 * sequential write, skip to zone end if the latest position is at the=
=0A=
> +	 * zone capacity limit.=0A=
> +	 */=0A=
> +	if (z->capacity < f->zbd_info->zone_size && !td_random(td) &&=0A=
> +	    ddir =3D=3D DDIR_WRITE &&=0A=
> +	    f->last_pos[ddir] >=3D zbd_zone_capacity_end(z)) {=0A=
> +		dprint(FD_ZBD,=0A=
> +		       "%s: Jump from zone capacity limit to zone end:"=0A=
> +		       " (%lu -> %lu) for zone %u (%ld)\n",=0A=
> +		       f->file_name, f->last_pos[ddir], zbd_zone_end(z),=0A=
> +		       zbd_zone_nr(f->zbd_info, z), z->capacity);=0A=
> +		td->io_skip_bytes +=3D zbd_zone_end(z) - f->last_pos[ddir];=0A=
> +		f->last_pos[ddir] =3D zbd_zone_end(z);=0A=
> +	}=0A=
> +=0A=
>  	/*=0A=
>  	 * zone_skip is valid only for sequential workloads.=0A=
>  	 */=0A=
> @@ -1340,11 +1380,8 @@ void setup_zbd_zone_mode(struct thread_data *td, s=
truct io_u *io_u)=0A=
>  	 * - For reads with td->o.read_beyond_wp =3D=3D false, the last positio=
n=0A=
>  	 *   reached the zone write pointer.=0A=
>  	 */=0A=
> -	zone_idx =3D zbd_zone_idx(f, f->last_pos[ddir]);=0A=
> -	z =3D &f->zbd_info->zone_info[zone_idx];=0A=
> -=0A=
>  	if (td->zone_bytes >=3D td->o.zone_size ||=0A=
> -	    f->last_pos[ddir] >=3D (z+1)->start ||=0A=
> +	    f->last_pos[ddir] >=3D zbd_zone_end(z) ||=0A=
>  	    (ddir =3D=3D DDIR_READ &&=0A=
>  	     (!td->o.read_beyond_wp) && f->last_pos[ddir] >=3D z->wp)) {=0A=
>  		/*=0A=
> @@ -1530,6 +1567,13 @@ enum io_u_action zbd_adjust_block(struct thread_da=
ta *td, struct io_u *io_u)=0A=
>  			zb->reset_zone =3D 0;=0A=
>  			if (zbd_reset_zone(td, f, zb) < 0)=0A=
>  				goto eof;=0A=
> +=0A=
> +			if (zb->capacity < min_bs) {=0A=
> +				log_err("zone capacity %llu smaller than minimum block size %d\n",=
=0A=
> +					(unsigned long long)zb->capacity,=0A=
> +					min_bs);=0A=
> +				goto eof;=0A=
> +			}=0A=
>  		}=0A=
>  		/* Make writes occur at the write pointer */=0A=
>  		assert(!zbd_zone_full(f, zb, min_bs));=0A=
> @@ -1545,7 +1589,7 @@ enum io_u_action zbd_adjust_block(struct thread_dat=
a *td, struct io_u *io_u)=0A=
>  		 * small.=0A=
>  		 */=0A=
>  		new_len =3D min((unsigned long long)io_u->buflen,=0A=
> -			      (zb + 1)->start - io_u->offset);=0A=
> +			      zbd_zone_capacity_end(zb) - io_u->offset);=0A=
>  		new_len =3D new_len / min_bs * min_bs;=0A=
>  		if (new_len =3D=3D io_u->buflen)=0A=
>  			goto accept;=0A=
> @@ -1556,7 +1600,7 @@ enum io_u_action zbd_adjust_block(struct thread_dat=
a *td, struct io_u *io_u)=0A=
>  			goto accept;=0A=
>  		}=0A=
>  		log_err("Zone remainder %lld smaller than minimum block size %d\n",=0A=
> -			((zb + 1)->start - io_u->offset),=0A=
> +			(zbd_zone_capacity_end(zb) - io_u->offset),=0A=
>  			min_bs);=0A=
>  		goto eof;=0A=
>  	case DDIR_TRIM:=0A=
> diff --git a/zbd.h b/zbd.h=0A=
> index e942a7f6..021174c1 100644=0A=
> --- a/zbd.h=0A=
> +++ b/zbd.h=0A=
> @@ -23,6 +23,7 @@ enum io_u_action {=0A=
>   * struct fio_zone_info - information about a single ZBD zone=0A=
>   * @start: zone start location (bytes)=0A=
>   * @wp: zone write pointer location (bytes)=0A=
> + * @capacity: maximum size usable from the start of a zone (bytes)=0A=
>   * @verify_block: number of blocks that have been verified for this zone=
=0A=
>   * @mutex: protects the modifiable members in this structure=0A=
>   * @type: zone type (BLK_ZONE_TYPE_*)=0A=
> @@ -35,6 +36,7 @@ struct fio_zone_info {=0A=
>  	pthread_mutex_t		mutex;=0A=
>  	uint64_t		start;=0A=
>  	uint64_t		wp;=0A=
> +	uint64_t		capacity;=0A=
>  	uint32_t		verify_block;=0A=
>  	enum zbd_zone_type	type:2;=0A=
>  	enum zbd_zone_cond	cond:4;=0A=
> diff --git a/zbd_types.h b/zbd_types.h=0A=
> index d63c0d0a..5ed41aa0 100644=0A=
> --- a/zbd_types.h=0A=
> +++ b/zbd_types.h=0A=
> @@ -50,6 +50,7 @@ struct zbd_zone {=0A=
>  	uint64_t		start;=0A=
>  	uint64_t		wp;=0A=
>  	uint64_t		len;=0A=
> +	uint64_t		capacity;=0A=
>  	enum zbd_zone_type	type;=0A=
>  	enum zbd_zone_cond	cond;=0A=
>  };=0A=
> =0A=
=0A=
Looks good to me.=0A=
=0A=
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=

