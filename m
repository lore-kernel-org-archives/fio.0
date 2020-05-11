Return-Path: <prvs=393ca294f=Damien.LeMoal@wdc.com>
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH 4/9] zbd: introduce per job maximum open zones limit
Date: Mon, 11 May 2020 01:09:52 +0000
Message-ID: 
 <BY5PR04MB69006259D86495C3375B066AE7A10@BY5PR04MB6900.namprd04.prod.outlook.com>
References: <20200505175634.2517-1-adobriyan@gmail.com>
 <20200505175634.2517-4-adobriyan@gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 2020/05/06 2:57, Alexey Dobriyan wrote:=0A=
> It is not possible to maintain sustained per-thread iodepth in ZBD mode.=
=0A=
> The way code is written, "max_open_zones" acts as a global limit, and=0A=
> once one or few threads open all "max_open_zones" zones, other threads=0A=
> can't open anything and _exit_ prematurely.=0A=
> =0A=
> This config is guaranteed to make equal number of zone resets/IO now:=0A=
> each thread generates identical pattern and doesn't intersect with other=
=0A=
> threads:=0A=
> =0A=
> 	zonemode=3Dzbd=0A=
> 	zonesize=3D...=0A=
> 	rw=3Dwrite=0A=
> =0A=
> 	numjobs=3DN=0A=
> 	offset_increment=3DM*zonesize=0A=
> =0A=
> 	[j]=0A=
> 	size=3DM*zonesize=0A=
> =0A=
> Patch introduces "job_max_open_zones" which is per-thread/process limit.=
=0A=
> "max_open_zones" remains per file/device limit. Both limits are checked=
=0A=
> for each open zone so one thread can't kick out others.=0A=
> =0A=
> Signed-off-by: Alexey Dobriyan (SK hynix) <adobriyan@gmail.com>=0A=
> ---=0A=
>  fio.1            |  6 +++++-=0A=
>  fio.h            |  1 +=0A=
>  options.c        | 16 +++++++++++++---=0A=
>  thread_options.h |  1 +=0A=
>  zbd.c            | 49 +++++++++++++++++++++++++++++++++++++-----------=
=0A=
>  zbd.h            |  3 +++=0A=
>  6 files changed, 61 insertions(+), 15 deletions(-)=0A=
> =0A=
> diff --git a/fio.1 b/fio.1=0A=
> index a2379f98..c0f2e7cf 100644=0A=
> --- a/fio.1=0A=
> +++ b/fio.1=0A=
> @@ -804,7 +804,11 @@ so. Default: false.=0A=
>  When running a random write test across an entire drive many more zones =
will be=0A=
>  open than in a typical application workload. Hence this command line opt=
ion=0A=
>  that allows to limit the number of open zones. The number of open zones =
is=0A=
> -defined as the number of zones to which write commands are issued.=0A=
> +defined as the number of zones to which write commands are issued by all=
=0A=
> +threads/processes.=0A=
> +.TP=0A=
> +.BI job_max_open_zones \fR=3D\fPint=0A=
> +Limit on the number of simultaneously opened zones per single thread/pro=
cess.=0A=
>  .TP=0A=
>  .BI zone_reset_threshold \fR=3D\fPfloat=0A=
>  A number between zero and one that indicates the ratio of logical blocks=
 with=0A=
> diff --git a/fio.h b/fio.h=0A=
> index bbf057c1..20ca80e2 100644=0A=
> --- a/fio.h=0A=
> +++ b/fio.h=0A=
> @@ -260,6 +260,7 @@ struct thread_data {=0A=
>  	struct frand_state prio_state;=0A=
>  =0A=
>  	struct zone_split_index **zone_state_index;=0A=
> +	unsigned int num_open_zones;=0A=
>  =0A=
>  	unsigned int verify_batch;=0A=
>  	unsigned int trim_batch;=0A=
> diff --git a/options.c b/options.c=0A=
> index 2372c042..47b3b765 100644=0A=
> --- a/options.c=0A=
> +++ b/options.c=0A=
> @@ -3360,12 +3360,22 @@ struct fio_option fio_options[FIO_MAX_OPTS] =3D {=
=0A=
>  	},=0A=
>  	{=0A=
>  		.name	=3D "max_open_zones",=0A=
> -		.lname	=3D "Maximum number of open zones",=0A=
> +		.lname	=3D "Global maximum number of open zones",=0A=
=0A=
Instead of "Global", may be use "Per device file" ? Jobs operating on diffe=
rent=0A=
files can each define a different value for max_open_zones, which really in=
 that=0A=
use case, make it a per device file limit.=0A=
=0A=
>  		.type	=3D FIO_OPT_INT,=0A=
>  		.off1	=3D offsetof(struct thread_options, max_open_zones),=0A=
>  		.maxval	=3D ZBD_MAX_OPEN_ZONES,=0A=
> -		.help	=3D "Limit random writes to SMR drives to the specified"=0A=
> -			  " number of sequential zones",=0A=
> +		.help	=3D "Limit on the number of simultaneously opened sequential wri=
te zones in SMR/ZNS drives",=0A=
=0A=
Please change "in SMR/ZNS drives" to "with zonemode=3Dzbd" since we can use=
=0A=
regular disks with emulated zones too.=0A=
=0A=
> +		.def	=3D "0",=0A=
> +		.category =3D FIO_OPT_C_IO,=0A=
> +		.group	=3D FIO_OPT_G_INVALID,=0A=
> +	},=0A=
> +	{=0A=
> +		.name	=3D "job_max_open_zones",=0A=
> +		.lname	=3D "Job maximum number of open zones",=0A=
> +		.type	=3D FIO_OPT_INT,=0A=
> +		.off1	=3D offsetof(struct thread_options, job_max_open_zones),=0A=
> +		.maxval	=3D ZBD_MAX_OPEN_ZONES,=0A=
> +		.help	=3D "Limit on the number of simultaneously opened sequential wri=
te zones in SMR/ZNS drives by one thread/process",=0A=
=0A=
Same here.=0A=
=0A=
>  		.def	=3D "0",=0A=
>  		.category =3D FIO_OPT_C_IO,=0A=
>  		.group	=3D FIO_OPT_G_INVALID,=0A=
> diff --git a/thread_options.h b/thread_options.h=0A=
> index c78ed43d..b0b493e4 100644=0A=
> --- a/thread_options.h=0A=
> +++ b/thread_options.h=0A=
> @@ -342,6 +342,7 @@ struct thread_options {=0A=
>  	/* Parameters that affect zonemode=3Dzbd */=0A=
>  	unsigned int read_beyond_wp;=0A=
>  	int max_open_zones;=0A=
> +	unsigned int job_max_open_zones;=0A=
>  	fio_fp64_t zrt;=0A=
>  	fio_fp64_t zrf;=0A=
>  };=0A=
> diff --git a/zbd.c b/zbd.c=0A=
> index 76771f2e..b34ceb34 100644=0A=
> --- a/zbd.c=0A=
> +++ b/zbd.c=0A=
> @@ -546,8 +546,10 @@ static int zbd_create_zone_info(struct thread_data *=
td, struct fio_file *f)=0A=
>  		return -EINVAL;=0A=
>  	}=0A=
>  =0A=
> -	if (ret =3D=3D 0)=0A=
> +	if (ret =3D=3D 0) {=0A=
>  		f->zbd_info->model =3D zbd_model;=0A=
> +		f->zbd_info->max_open_zones =3D td->o.max_open_zones;=0A=
> +	}=0A=
>  	return ret;=0A=
>  }=0A=
>  =0A=
> @@ -622,6 +624,27 @@ int zbd_init(struct thread_data *td)=0A=
>  	if (!zbd_verify_bs())=0A=
>  		return 1;=0A=
>  =0A=
> +	for_each_file(td, f, i) {=0A=
> +		struct zoned_block_device_info *zbd =3D f->zbd_info;=0A=
> +=0A=
> +		if (!zbd)=0A=
> +			continue;=0A=
> +=0A=
> +		if (zbd->max_open_zones =3D=3D 0) {=0A=
> +			zbd->max_open_zones =3D ZBD_MAX_OPEN_ZONES;=0A=
> +		}=0A=
=0A=
No need for the "{}" brackets here.=0A=
=0A=
> +=0A=
> +		if (td->o.max_open_zones > 0 &&=0A=
> +		    zbd->max_open_zones !=3D td->o.max_open_zones) {=0A=
> +			log_err("Different 'max_open_zones' values\n");=0A=
> +			return 1;=0A=
> +		}=0A=
> +		if (zbd->max_open_zones > ZBD_MAX_OPEN_ZONES) {=0A=
> +			log_err("'max_open_zones' value is limited by %u\n", ZBD_MAX_OPEN_ZON=
ES);=0A=
> +			return 1;=0A=
> +		}=0A=
> +	}=0A=
> +=0A=
>  	return 0;=0A=
>  }=0A=
>  =0A=
> @@ -709,6 +732,7 @@ static void zbd_close_zone(struct thread_data *td, co=
nst struct fio_file *f,=0A=
>  		(ZBD_MAX_OPEN_ZONES - (open_zone_idx + 1)) *=0A=
>  		sizeof(f->zbd_info->open_zones[0]));=0A=
>  	f->zbd_info->num_open_zones--;=0A=
> +	td->num_open_zones--;=0A=
>  	f->zbd_info->zone_info[zone_idx].open =3D 0;=0A=
>  }=0A=
>  =0A=
> @@ -888,8 +912,10 @@ static bool is_zone_open(const struct thread_data *t=
d, const struct fio_file *f,=0A=
>  	struct zoned_block_device_info *zbdi =3D f->zbd_info;=0A=
>  	int i;=0A=
>  =0A=
> -	assert(td->o.max_open_zones <=3D ARRAY_SIZE(zbdi->open_zones));=0A=
> -	assert(zbdi->num_open_zones <=3D td->o.max_open_zones);=0A=
> +	assert(td->o.job_max_open_zones =3D=3D 0 || td->num_open_zones <=3D td-=
>o.job_max_open_zones);=0A=
> +=0A=
=0A=
I do not think that this white line is needed.=0A=
=0A=
> +	assert(td->o.job_max_open_zones <=3D zbdi->max_open_zones);=0A=
> +	assert(zbdi->num_open_zones <=3D zbdi->max_open_zones);=0A=
>  =0A=
>  	for (i =3D 0; i < zbdi->num_open_zones; i++)=0A=
>  		if (zbdi->open_zones[i] =3D=3D zone_idx)=0A=
> @@ -922,18 +948,19 @@ static bool zbd_open_zone(struct thread_data *td, c=
onst struct io_u *io_u,=0A=
>  	if (td->o.verify !=3D VERIFY_NONE && zbd_zone_full(f, z, min_bs))=0A=
>  		return false;=0A=
>  =0A=
> -	/* Zero means no limit */=0A=
> -	if (!td->o.max_open_zones)=0A=
> -		return true;=0A=
> -=0A=
>  	pthread_mutex_lock(&f->zbd_info->mutex);=0A=
>  	if (is_zone_open(td, f, zone_idx))=0A=
>  		goto out;=0A=
>  	res =3D false;=0A=
> -	if (f->zbd_info->num_open_zones >=3D td->o.max_open_zones)=0A=
> +	/* Zero means no limit */=0A=
> +	if (td->o.job_max_open_zones > 0 &&=0A=
> +	    td->num_open_zones >=3D td->o.job_max_open_zones)=0A=
> +		goto out;=0A=
> +	if (f->zbd_info->num_open_zones >=3D f->zbd_info->max_open_zones)=0A=
>  		goto out;=0A=
>  	dprint(FD_ZBD, "%s: opening zone %d\n", f->file_name, zone_idx);=0A=
>  	f->zbd_info->open_zones[f->zbd_info->num_open_zones++] =3D zone_idx;=0A=
> +	td->num_open_zones++;=0A=
>  	z->open =3D 1;=0A=
>  	res =3D true;=0A=
>  =0A=
> @@ -968,7 +995,7 @@ static struct fio_zone_info *zbd_convert_to_open_zone=
(struct thread_data *td,=0A=
>  =0A=
>  	assert(is_valid_offset(f, io_u->offset));=0A=
>  =0A=
> -	if (td->o.max_open_zones) {=0A=
> +	if (td->o.job_max_open_zones) {=0A=
>  		/*=0A=
>  		 * This statement accesses f->zbd_info->open_zones[] on purpose=0A=
>  		 * without locking.=0A=
> @@ -997,7 +1024,7 @@ static struct fio_zone_info *zbd_convert_to_open_zon=
e(struct thread_data *td,=0A=
>  =0A=
>  		zone_lock(td, f, z);=0A=
>  		pthread_mutex_lock(&f->zbd_info->mutex);=0A=
> -		if (td->o.max_open_zones =3D=3D 0)=0A=
> +		if (td->o.job_max_open_zones =3D=3D 0)=0A=
>  			goto examine_zone;=0A=
>  		if (f->zbd_info->num_open_zones =3D=3D 0) {=0A=
>  			pthread_mutex_unlock(&f->zbd_info->mutex);=0A=
> @@ -1053,7 +1080,7 @@ examine_zone:=0A=
>  	}=0A=
>  	dprint(FD_ZBD, "%s(%s): closing zone %d\n", __func__, f->file_name,=0A=
>  	       zone_idx);=0A=
> -	if (td->o.max_open_zones)=0A=
> +	if (td->o.job_max_open_zones)=0A=
>  		zbd_close_zone(td, f, open_zone_idx);=0A=
>  	pthread_mutex_unlock(&f->zbd_info->mutex);=0A=
>  =0A=
> diff --git a/zbd.h b/zbd.h=0A=
> index 5a660399..fb39fb82 100644=0A=
> --- a/zbd.h=0A=
> +++ b/zbd.h=0A=
> @@ -45,6 +45,8 @@ struct fio_zone_info {=0A=
>  /**=0A=
>   * zoned_block_device_info - zoned block device characteristics=0A=
>   * @model: Device model.=0A=
> + * @max_open_zones: global limit on the number of simultaneously opened=
=0A=
> + *	sequential write zones.=0A=
>   * @mutex: Protects the modifiable members in this structure (refcount a=
nd=0A=
>   *		num_open_zones).=0A=
>   * @zone_size: size of a single zone in units of 512 bytes=0A=
> @@ -65,6 +67,7 @@ struct fio_zone_info {=0A=
>   */=0A=
>  struct zoned_block_device_info {=0A=
>  	enum zbd_zoned_model	model;=0A=
> +	uint32_t		max_open_zones;=0A=
>  	pthread_mutex_t		mutex;=0A=
>  	uint64_t		zone_size;=0A=
>  	uint64_t		sectors_with_data;=0A=
> =0A=
=0A=
Apart from the nits above, it looks good.=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=

