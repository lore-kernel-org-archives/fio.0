Return-Path: <prvs=460a6953b=Damien.LeMoal@wdc.com>
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH v2 2/6] options: Add zonecapacity option for zonemode=zbd
Date: Fri, 17 Jul 2020 01:48:54 +0000
Message-ID: 
 <CY4PR04MB37517835609975F256EB3E21E77C0@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <20200715064141.116415-1-shinichiro.kawasaki@wdc.com>
 <20200715064141.116415-3-shinichiro.kawasaki@wdc.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc: Hans Holmberg <Hans.Holmberg@wdc.com>, Aravind Ramesh <Aravind.Ramesh@wdc.com>
List-ID: <fio@vger.kernel.org>

On 2020/07/15 15:41, Shin'ichiro Kawasaki wrote:=0A=
> From: Hans Holmberg <hans.holmberg@wdc.com>=0A=
> =0A=
> To test zone capacity handling by fio using regular block devices, add=0A=
> zonecapacity option for zonemode=3Dzbd. It allows to specify zone capacit=
y=0A=
> common to all zones.=0A=
=0A=
Please better describe the option:=0A=
=0A=
This new option  allows specifying a zone capacity smaller than the zone si=
ze.=0A=
Similarly to the zonesize option, the zonecapacity defined value applies to=
 all=0A=
emulated zones of the device.=0A=
=0A=
> =0A=
> Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>=0A=
> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>=0A=
> ---=0A=
>  HOWTO            | 18 +++++++++++++++---=0A=
>  cconv.c          |  2 ++=0A=
>  fio.1            | 13 +++++++++++--=0A=
>  options.c        | 11 +++++++++++=0A=
>  thread_options.h |  2 ++=0A=
>  zbd.c            | 13 ++++++++++++-=0A=
>  6 files changed, 53 insertions(+), 6 deletions(-)=0A=
> =0A=
> diff --git a/HOWTO b/HOWTO=0A=
> index 8cf8d650..35ead0cb 100644=0A=
> --- a/HOWTO=0A=
> +++ b/HOWTO=0A=
> @@ -970,14 +970,15 @@ Target file/device=0A=
>  	Accepted values are:=0A=
>  =0A=
>  		**none**=0A=
> -				The :option:`zonerange`, :option:`zonesize` and=0A=
> -				:option:`zoneskip` parameters are ignored.=0A=
> +				The :option:`zonerange`, :option:`zonesize`,=0A=
> +				:option `zonecapacity` and option:`zoneskip`=0A=
> +				parameters are ignored.=0A=
>  		**strided**=0A=
>  				I/O happens in a single zone until=0A=
>  				:option:`zonesize` bytes have been transferred.=0A=
>  				After that number of bytes has been=0A=
>  				transferred processing of the next zone=0A=
> -				starts.=0A=
> +				starts. :option `zonecapacity` is ignored.=0A=
>  		**zbd**=0A=
>  				Zoned block device mode. I/O happens=0A=
>  				sequentially in each zone, even if random I/O=0A=
> @@ -1004,6 +1005,17 @@ Target file/device=0A=
>  	For :option:`zonemode` =3Dzbd, this is the size of a single zone. The=
=0A=
>  	:option:`zonerange` parameter is ignored in this mode.=0A=
>  =0A=
> +=0A=
> +.. option:: zonecapacity=3Dint=0A=
> +=0A=
> +	For :option:`zonemode` =3Dzbd, this defines the capacity of a single zo=
ne,=0A=
> +	which is the accessible area starting from the zone start address.=0A=
> +	This parameter only applies when using :option:`zonemode` =3Dzbd in=0A=
> +	combination with regular block devices. If not specified it defaults to=
=0A=
> +	the zone size. If the target device is a zoned block device, the zone=
=0A=
> +	capacity is obtained from the device information and this option is=0A=
> +	ignored.=0A=
> +=0A=
>  .. option:: zoneskip=3Dint=0A=
>  =0A=
>  	For :option:`zonemode` =3Dstrided, the number of bytes to skip after=0A=
> diff --git a/cconv.c b/cconv.c=0A=
> index 449bcf7b..2469389b 100644=0A=
> --- a/cconv.c=0A=
> +++ b/cconv.c=0A=
> @@ -223,6 +223,7 @@ void convert_thread_options_to_cpu(struct thread_opti=
ons *o,=0A=
>  	o->ss_limit.u.f =3D fio_uint64_to_double(le64_to_cpu(top->ss_limit.u.i)=
);=0A=
>  	o->zone_range =3D le64_to_cpu(top->zone_range);=0A=
>  	o->zone_size =3D le64_to_cpu(top->zone_size);=0A=
> +	o->zone_capacity =3D le64_to_cpu(top->zone_capacity);=0A=
>  	o->zone_skip =3D le64_to_cpu(top->zone_skip);=0A=
>  	o->zone_mode =3D le32_to_cpu(top->zone_mode);=0A=
>  	o->lockmem =3D le64_to_cpu(top->lockmem);=0A=
> @@ -563,6 +564,7 @@ void convert_thread_options_to_net(struct thread_opti=
ons_pack *top,=0A=
>  	top->ss_limit.u.i =3D __cpu_to_le64(fio_double_to_uint64(o->ss_limit.u.=
f));=0A=
>  	top->zone_range =3D __cpu_to_le64(o->zone_range);=0A=
>  	top->zone_size =3D __cpu_to_le64(o->zone_size);=0A=
> +	top->zone_capacity =3D __cpu_to_le64(o->zone_capacity);=0A=
>  	top->zone_skip =3D __cpu_to_le64(o->zone_skip);=0A=
>  	top->zone_mode =3D __cpu_to_le32(o->zone_mode);=0A=
>  	top->lockmem =3D __cpu_to_le64(o->lockmem);=0A=
> diff --git a/fio.1 b/fio.1=0A=
> index f134e0bf..68aeb21f 100644=0A=
> --- a/fio.1=0A=
> +++ b/fio.1=0A=
> @@ -738,12 +738,13 @@ Accepted values are:=0A=
>  .RS=0A=
>  .TP=0A=
>  .B none=0A=
> -The \fBzonerange\fR, \fBzonesize\fR and \fBzoneskip\fR parameters are ig=
nored.=0A=
> +The \fBzonerange\fR, \fBzonesize\fR \fBzonecapacity and \fBzoneskip\fR=
=0A=
=0A=
Missing \fR after \fBzonecapacity.=0A=
=0A=
> +parameters are ignored.=0A=
>  .TP=0A=
>  .B strided=0A=
>  I/O happens in a single zone until \fBzonesize\fR bytes have been transf=
erred.=0A=
>  After that number of bytes has been transferred processing of the next z=
one=0A=
> -starts.=0A=
> +starts. The \fBzonecapacity parameter is ignored.=0A=
=0A=
Same here too.=0A=
=0A=
>  .TP=0A=
>  .B zbd=0A=
>  Zoned block device mode. I/O happens sequentially in each zone, even if =
random=0A=
> @@ -771,6 +772,14 @@ zoned block device, the specified \fBzonesize\fR mus=
t be 0 or equal to the=0A=
>  device zone size. For a regular block device or file, the specified=0A=
>  \fBzonesize\fR must be at least 512B.=0A=
>  .TP=0A=
> +.BI zonecapacity \fR=3D\fPint=0A=
> +For \fBzonemode\fR=3Dzbd, this defines the capacity of a single zone, wh=
ich is=0A=
> +the accessible area starting from the zone start address. This parameter=
 only=0A=
> +applies when using \fBzonemode\fR=3Dzbd in combination with regular bloc=
k devices.=0A=
> +If not specified it defaults to the zone size. If the target device is a=
 zoned=0A=
> +block device, the zone capacity is obtained from the device information =
and this=0A=
> +option is ignored.=0A=
> +.TP=0A=
>  .BI zoneskip \fR=3D\fPint=0A=
>  For \fBzonemode\fR=3Dstrided, the number of bytes to skip after \fBzones=
ize\fR=0A=
>  bytes of data have been transferred.=0A=
> diff --git a/options.c b/options.c=0A=
> index 85a0f490..251ad2c1 100644=0A=
> --- a/options.c=0A=
> +++ b/options.c=0A=
> @@ -3327,6 +3327,17 @@ struct fio_option fio_options[FIO_MAX_OPTS] =3D {=
=0A=
>  		.category =3D FIO_OPT_C_IO,=0A=
>  		.group	=3D FIO_OPT_G_ZONE,=0A=
>  	},=0A=
> +	{=0A=
> +		.name	=3D "zonecapacity",=0A=
> +		.lname	=3D "Zone capacity",=0A=
> +		.type	=3D FIO_OPT_STR_VAL,=0A=
> +		.off1	=3D offsetof(struct thread_options, zone_capacity),=0A=
> +		.help	=3D "Capacity per zone",=0A=
> +		.def	=3D "0",=0A=
> +		.interval =3D 1024 * 1024,=0A=
> +		.category =3D FIO_OPT_C_IO,=0A=
> +		.group	=3D FIO_OPT_G_ZONE,=0A=
> +	},=0A=
>  	{=0A=
>  		.name	=3D "zonerange",=0A=
>  		.lname	=3D "Zone range",=0A=
> diff --git a/thread_options.h b/thread_options.h=0A=
> index 968ea0ab..3fe48ecc 100644=0A=
> --- a/thread_options.h=0A=
> +++ b/thread_options.h=0A=
> @@ -193,6 +193,7 @@ struct thread_options {=0A=
>  	unsigned int loops;=0A=
>  	unsigned long long zone_range;=0A=
>  	unsigned long long zone_size;=0A=
> +	unsigned long long zone_capacity;=0A=
>  	unsigned long long zone_skip;=0A=
>  	enum fio_zone_mode zone_mode;=0A=
>  	unsigned long long lockmem;=0A=
> @@ -487,6 +488,7 @@ struct thread_options_pack {=0A=
>  	uint32_t loops;=0A=
>  	uint64_t zone_range;=0A=
>  	uint64_t zone_size;=0A=
> +	uint64_t zone_capacity;=0A=
>  	uint64_t zone_skip;=0A=
>  	uint64_t lockmem;=0A=
>  	uint32_t mem_type;=0A=
> diff --git a/zbd.c b/zbd.c=0A=
> index c738a58b..85478aa5 100644=0A=
> --- a/zbd.c=0A=
> +++ b/zbd.c=0A=
> @@ -371,6 +371,7 @@ static int init_zone_info(struct thread_data *td, str=
uct fio_file *f)=0A=
>  	uint32_t nr_zones;=0A=
>  	struct fio_zone_info *p;=0A=
>  	uint64_t zone_size =3D td->o.zone_size;=0A=
> +	uint64_t zone_capacity =3D td->o.zone_capacity;=0A=
>  	struct zoned_block_device_info *zbd_info =3D NULL;=0A=
>  	int i;=0A=
>  =0A=
> @@ -386,6 +387,16 @@ static int init_zone_info(struct thread_data *td, st=
ruct fio_file *f)=0A=
>  		return 1;=0A=
>  	}=0A=
>  =0A=
> +	if (zone_capacity =3D=3D 0)=0A=
> +		zone_capacity =3D zone_size;=0A=
> +=0A=
> +	if (zone_capacity > zone_size) {=0A=
> +		log_err("%s: job parameter zonecapacity %llu is larger than zone size =
%llu\n",=0A=
> +			f->file_name, (unsigned long long) td->o.zone_capacity,=0A=
> +			(unsigned long long) td->o.zone_size);=0A=
> +		return 1;=0A=
> +	}=0A=
> +=0A=
>  	nr_zones =3D (f->real_file_size + zone_size - 1) / zone_size;=0A=
>  	zbd_info =3D scalloc(1, sizeof(*zbd_info) +=0A=
>  			   (nr_zones + 1) * sizeof(zbd_info->zone_info[0]));=0A=
> @@ -402,7 +413,7 @@ static int init_zone_info(struct thread_data *td, str=
uct fio_file *f)=0A=
>  		p->wp =3D p->start;=0A=
>  		p->type =3D ZBD_ZONE_TYPE_SWR;=0A=
>  		p->cond =3D ZBD_ZONE_COND_EMPTY;=0A=
> -		p->capacity =3D zone_size;=0A=
> +		p->capacity =3D zone_capacity;=0A=
>  	}=0A=
>  	/* a sentinel */=0A=
>  	p->start =3D nr_zones * zone_size;=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=

