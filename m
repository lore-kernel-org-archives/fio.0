Return-Path: <prvs=383ebf04e=Damien.LeMoal@wdc.com>
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH 3/7] zbd: introduce per-device "max_open_zones" limit
Date: Fri, 1 May 2020 01:34:32 +0000
Message-ID: 
 <BY5PR04MB690042CF7A2990BE21B0DBCDE7AB0@BY5PR04MB6900.namprd04.prod.outlook.com>
References: <20200430124050.20146-1-adobriyan@gmail.com>
 <20200430124050.20146-3-adobriyan@gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 2020/04/30 21:41, Alexey Dobriyan wrote:=0A=
> It is not possible to maintain equal per-thread iodepth. The way code=0A=
> is written, "max_open_zones" acts as a global limit, and one thread=0A=
> opens all "max_open_zones" for itself and others starve for available=0A=
> zones and _exit_ prematurely.=0A=
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
> Patch introduces "global_max_open_zones" which is per-device config=0A=
> option. "max_open_zones" becomes per-thread limit. Both limits are=0A=
> checked for each open zone so one thread can't starve others.=0A=
=0A=
It makes sense. Nice one.=0A=
=0A=
But the change as is will break existing test scripts (e.g. lots of SMR dri=
ves=0A=
are being tested with this). I think we can avoid this breakage simply: lea=
ve=0A=
max_open_zones option definition as is and add "job_max_open_zones" or=0A=
"thread_max_open_zones" option (no strong feelings about the name here, as =
long=0A=
as it is explicit) to define the per thread maximum number of open zones. T=
his=0A=
new option could actually default to max_open_zones / numjobs if that is no=
t 0.=0A=
=0A=
> =0A=
> Signed-off-by: Alexey Dobriyan (SK hynix) <adobriyan@gmail.com>=0A=
> ---=0A=
>  fio.1            |  6 +++++-=0A=
>  fio.h            |  1 +=0A=
>  options.c        | 14 ++++++++++++--=0A=
>  thread_options.h |  1 +=0A=
>  zbd.c            | 37 +++++++++++++++++++++++++++++++++----=0A=
>  zbd.h            |  3 +++=0A=
>  6 files changed, 55 insertions(+), 7 deletions(-)=0A=
> =0A=
> diff --git a/fio.1 b/fio.1=0A=
> index a2379f98..1c04a3af 100644=0A=
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
> +defined as the number of zones to which write commands are issued by one=
=0A=
> +thread/process.=0A=
> +.TP=0A=
> +.BI global_max_open_zones \fR=3D\fPint=0A=
> +Global limit on the number of simultaneously opened zones per block devi=
ce.=0A=
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
> index 2372c042..306874ea 100644=0A=
> --- a/options.c=0A=
> +++ b/options.c=0A=
> @@ -3364,8 +3364,18 @@ struct fio_option fio_options[FIO_MAX_OPTS] =3D {=
=0A=
>  		.type	=3D FIO_OPT_INT,=0A=
>  		.off1	=3D offsetof(struct thread_options, max_open_zones),=0A=
>  		.maxval	=3D ZBD_MAX_OPEN_ZONES,=0A=
> -		.help	=3D "Limit random writes to SMR drives to the specified"=0A=
> -			  " number of sequential zones",=0A=
> +		.help	=3D "Thread/process limit on the number of simultaneously opened=
 sequential write zones in SMR/ZNS drives",=0A=
> +		.def	=3D "0",=0A=
> +		.category =3D FIO_OPT_C_IO,=0A=
> +		.group	=3D FIO_OPT_G_INVALID,=0A=
> +	},=0A=
> +	{=0A=
> +		.name	=3D "global_max_open_zones",=0A=
> +		.lname	=3D "Global maximum number of open zones",=0A=
> +		.type	=3D FIO_OPT_INT,=0A=
> +		.off1	=3D offsetof(struct thread_options, global_max_open_zones),=0A=
> +		.maxval	=3D ZBD_MAX_OPEN_ZONES,=0A=
> +		.help	=3D "Block device limit on the number of simultaneously opened s=
equential write zones in SMR/ZNS drives",=0A=
>  		.def	=3D "0",=0A=
>  		.category =3D FIO_OPT_C_IO,=0A=
>  		.group	=3D FIO_OPT_G_INVALID,=0A=
> diff --git a/thread_options.h b/thread_options.h=0A=
> index c78ed43d..4078d46f 100644=0A=
> --- a/thread_options.h=0A=
> +++ b/thread_options.h=0A=
> @@ -342,6 +342,7 @@ struct thread_options {=0A=
>  	/* Parameters that affect zonemode=3Dzbd */=0A=
>  	unsigned int read_beyond_wp;=0A=
>  	int max_open_zones;=0A=
> +	unsigned int global_max_open_zones;=0A=
>  	fio_fp64_t zrt;=0A=
>  	fio_fp64_t zrf;=0A=
>  };=0A=
> diff --git a/zbd.c b/zbd.c=0A=
> index e8f0a4d8..a517349a 100644=0A=
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
> +		f->zbd_info->max_open_zones =3D td->o.global_max_open_zones;=0A=
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
> +=0A=
> +		if (td->o.global_max_open_zones &&=0A=
> +		    zbd->max_open_zones !=3D td->o.global_max_open_zones) {=0A=
> +			log_err("Different 'global_max_open_zones' values\n");=0A=
> +			return 1;=0A=
> +		}=0A=
> +		if (zbd->max_open_zones > ZBD_MAX_OPEN_ZONES) {=0A=
> +			log_err("'global_max_open_zones' value is limited by %u\n", ZBD_MAX_O=
PEN_ZONES);=0A=
> +			return 1;=0A=
> +		}=0A=
> +	}=0A=
> +=0A=
>  	return 0;=0A=
>  }=0A=
>  =0A=
> @@ -714,6 +737,7 @@ static void zbd_close_zone(struct thread_data *td, co=
nst struct fio_file *f,=0A=
>  		(ZBD_MAX_OPEN_ZONES - (open_zone_idx + 1)) *=0A=
>  		sizeof(f->zbd_info->open_zones[0]));=0A=
>  	f->zbd_info->num_open_zones--;=0A=
> +	td->num_open_zones--;=0A=
>  	f->zbd_info->zone_info[zone_idx].open =3D 0;=0A=
>  }=0A=
>  =0A=
> @@ -895,8 +919,10 @@ static bool is_zone_open(const struct thread_data *t=
d, const struct fio_file *f,=0A=
>  	struct zoned_block_device_info *zbdi =3D f->zbd_info;=0A=
>  	int i;=0A=
>  =0A=
> -	assert(td->o.max_open_zones <=3D ARRAY_SIZE(zbdi->open_zones));=0A=
> -	assert(zbdi->num_open_zones <=3D td->o.max_open_zones);=0A=
> +	assert(td->o.max_open_zones =3D=3D 0 || td->num_open_zones <=3D td->o.m=
ax_open_zones);=0A=
> +=0A=
> +	assert(td->o.max_open_zones <=3D zbdi->max_open_zones);=0A=
> +	assert(zbdi->num_open_zones <=3D zbdi->max_open_zones);=0A=
>  =0A=
>  	for (i =3D 0; i < zbdi->num_open_zones; i++)=0A=
>  		if (zbdi->open_zones[i] =3D=3D zone_idx)=0A=
> @@ -937,10 +963,13 @@ static bool zbd_open_zone(struct thread_data *td, c=
onst struct io_u *io_u,=0A=
>  	if (is_zone_open(td, f, zone_idx))=0A=
>  		goto out;=0A=
>  	res =3D false;=0A=
> -	if (f->zbd_info->num_open_zones >=3D td->o.max_open_zones)=0A=
> +	if (td->num_open_zones >=3D td->o.max_open_zones)=0A=
> +		goto out;=0A=
> +	if (f->zbd_info->num_open_zones >=3D f->zbd_info->max_open_zones)=0A=
>  		goto out;=0A=
>  	dprint(FD_ZBD, "%s: opening zone %d\n", f->file_name, zone_idx);=0A=
>  	f->zbd_info->open_zones[f->zbd_info->num_open_zones++] =3D zone_idx;=0A=
> +	td->num_open_zones++;=0A=
>  	z->open =3D 1;=0A=
>  	res =3D true;=0A=
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
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=

