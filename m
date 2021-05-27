Return-Path: <prvs=774163301=Damien.LeMoal@wdc.com>
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH v2 2/2] zbd: add a new --ignore_zone_limits option
Date: Thu, 27 May 2021 10:58:52 +0000
Message-ID: 
 <DM6PR04MB7081010E470E34AFB9D8FC0CE7239@DM6PR04MB7081.namprd04.prod.outlook.com>
References: <20210524144109.12127-1-Niklas.Cassel@wdc.com>
 <20210524144109.12127-2-Niklas.Cassel@wdc.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Niklas Cassel <Niklas.Cassel@wdc.com>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 2021/05/24 23:41, Niklas Cassel wrote:=0A=
> From: Niklas Cassel <niklas.cassel@wdc.com>=0A=
> =0A=
> In commit d2f442bc0bd5 ("ioengines: add get_max_open_zones zoned block=0A=
> device operation") we added a check that verifies that the specified=0A=
> --max_open_zones value is lower than the max value reported by the device=
.=0A=
> =0A=
> For ZNS devices there is a max open zones and a max active zones limit.=
=0A=
> For ZAC/ZBC devices there is only a max open zones limit.=0A=
> =0A=
> On ZAC/ZBC, there is thus no limit on the amount of zones that can be=0A=
> in zone state closed.=0A=
> When doing a write to an empty or closed zone, a ZAC/ZBC drive will=0A=
> close an arbitrary implicit open zone in order in order to handle the=0A=
=0A=
one "in order" too much :)=0A=
=0A=
> write.=0A=
> =0A=
> The ZNS specification has no requirement on closing a zone in order to=0A=
> handle a write to an empty or closed zone. The drive is free to return=0A=
> an error.=0A=
> =0A=
> Even on ZAC/ZBC, you do not want to exceed the max open zones limit,=0A=
> since it will lead to additional implicit close zone and implicit open=0A=
> zone operations, which will degrade performance.=0A=
=0A=
s/will/may=0A=
=0A=
> However, it seems that this is sometimes done on purpose, in order to=0A=
> measure the overhead of these additional operations. Therefore, add=0A=
> an option that allows the user to ignore the reported device limits.=0A=
> =0A=
> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>=0A=
> ---=0A=
> Changes since V1:=0A=
> - Added option to thread_options_pack and fixed missing cconv support.=0A=
> - Bumped server version.=0A=
> - Changed from bool to unsigned int in thread_options.h while still=0A=
>   being defined as bool in options.c. This matches how it's done for=0A=
>   other bool options, e.g. do_verify.=0A=
> =0A=
>  cconv.c          |  2 ++=0A=
>  fio.1            |  5 +++++=0A=
>  options.c        | 10 ++++++++++=0A=
>  server.h         |  2 +-=0A=
>  thread_options.h |  2 ++=0A=
>  zbd.c            |  2 +-=0A=
>  6 files changed, 21 insertions(+), 2 deletions(-)=0A=
> =0A=
> diff --git a/cconv.c b/cconv.c=0A=
> index d4dfb81b..74c24106 100644=0A=
> --- a/cconv.c=0A=
> +++ b/cconv.c=0A=
> @@ -232,6 +232,7 @@ void convert_thread_options_to_cpu(struct thread_opti=
ons *o,=0A=
>  	o->zone_skip =3D le64_to_cpu(top->zone_skip);=0A=
>  	o->zone_mode =3D le32_to_cpu(top->zone_mode);=0A=
>  	o->max_open_zones =3D __le32_to_cpu(top->max_open_zones);=0A=
> +	o->ignore_zone_limits =3D le32_to_cpu(top->ignore_zone_limits);=0A=
>  	o->lockmem =3D le64_to_cpu(top->lockmem);=0A=
>  	o->offset_increment_percent =3D le32_to_cpu(top->offset_increment_perce=
nt);=0A=
>  	o->offset_increment =3D le64_to_cpu(top->offset_increment);=0A=
> @@ -575,6 +576,7 @@ void convert_thread_options_to_net(struct thread_opti=
ons_pack *top,=0A=
>  	top->zone_skip =3D __cpu_to_le64(o->zone_skip);=0A=
>  	top->zone_mode =3D __cpu_to_le32(o->zone_mode);=0A=
>  	top->max_open_zones =3D __cpu_to_le32(o->max_open_zones);=0A=
> +	top->ignore_zone_limits =3D cpu_to_le32(o->ignore_zone_limits);=0A=
>  	top->lockmem =3D __cpu_to_le64(o->lockmem);=0A=
>  	top->ddir_seq_add =3D __cpu_to_le64(o->ddir_seq_add);=0A=
>  	top->file_size_low =3D __cpu_to_le64(o->file_size_low);=0A=
> diff --git a/fio.1 b/fio.1=0A=
> index ab08cb01..3519797a 100644=0A=
> --- a/fio.1=0A=
> +++ b/fio.1=0A=
> @@ -835,6 +835,11 @@ threads/processes.=0A=
>  .BI job_max_open_zones \fR=3D\fPint=0A=
>  Limit on the number of simultaneously opened zones per single thread/pro=
cess.=0A=
>  .TP=0A=
> +.BI ignore_zone_limits \fR=3D\fPbool=0A=
> +If this isn't set, fio will query the max open zones limit from the zone=
d block=0A=
> +device, and exit if the specified \fBmax_open_zones\fR value is larger t=
han the=0A=
> +max value reported by the device. Default: false.=0A=
=0A=
s/max/maximum or s/max value/limit=0A=
=0A=
> +.TP=0A=
>  .BI zone_reset_threshold \fR=3D\fPfloat=0A=
>  A number between zero and one that indicates the ratio of logical blocks=
 with=0A=
>  data to the total number of logical blocks in the test above which zones=
=0A=
> diff --git a/options.c b/options.c=0A=
> index b82a10aa..a8986d11 100644=0A=
> --- a/options.c=0A=
> +++ b/options.c=0A=
> @@ -3492,6 +3492,16 @@ struct fio_option fio_options[FIO_MAX_OPTS] =3D {=
=0A=
>  		.category =3D FIO_OPT_C_IO,=0A=
>  		.group	=3D FIO_OPT_G_INVALID,=0A=
>  	},=0A=
> +	{=0A=
> +		.name	=3D "ignore_zone_limits",=0A=
> +		.lname	=3D "Ignore zone resource limits",=0A=
> +		.type	=3D FIO_OPT_BOOL,=0A=
> +		.off1	=3D offsetof(struct thread_options, ignore_zone_limits),=0A=
> +		.def	=3D "0",=0A=
> +		.help	=3D "Ignore the zone resource limits (max open/active zones) rep=
orted by the device",=0A=
> +		.category =3D FIO_OPT_C_IO,=0A=
> +		.group	=3D FIO_OPT_G_INVALID,=0A=
> +	},=0A=
>  	{=0A=
>  		.name	=3D "zone_reset_threshold",=0A=
>  		.lname	=3D "Zone reset threshold",=0A=
> diff --git a/server.h b/server.h=0A=
> index 8cf3a60b..c128df28 100644=0A=
> --- a/server.h=0A=
> +++ b/server.h=0A=
> @@ -48,7 +48,7 @@ struct fio_net_cmd_reply {=0A=
>  };=0A=
>  =0A=
>  enum {=0A=
> -	FIO_SERVER_VER			=3D 90,=0A=
> +	FIO_SERVER_VER			=3D 91,=0A=
>  =0A=
>  	FIO_SERVER_MAX_FRAGMENT_PDU	=3D 1024,=0A=
>  	FIO_SERVER_MAX_CMD_MB		=3D 2048,=0A=
> diff --git a/thread_options.h b/thread_options.h=0A=
> index 4d48e462..05c2d138 100644=0A=
> --- a/thread_options.h=0A=
> +++ b/thread_options.h=0A=
> @@ -355,6 +355,7 @@ struct thread_options {=0A=
>  	unsigned int read_beyond_wp;=0A=
>  	int max_open_zones;=0A=
>  	unsigned int job_max_open_zones;=0A=
> +	unsigned int ignore_zone_limits;=0A=
>  	fio_fp64_t zrt;=0A=
>  	fio_fp64_t zrf;=0A=
>  };=0A=
> @@ -657,6 +658,7 @@ struct thread_options_pack {=0A=
>  =0A=
>  	uint32_t zone_mode;=0A=
>  	int32_t max_open_zones;=0A=
> +	uint32_t ignore_zone_limits;=0A=
>  } __attribute__((packed));=0A=
>  =0A=
>  extern void convert_thread_options_to_cpu(struct thread_options *o, stru=
ct thread_options_pack *top);=0A=
> diff --git a/zbd.c b/zbd.c=0A=
> index 68cd58e1..5d9e331a 100644=0A=
> --- a/zbd.c=0A=
> +++ b/zbd.c=0A=
> @@ -588,7 +588,7 @@ static int zbd_set_max_open_zones(struct thread_data =
*td, struct fio_file *f)=0A=
>  	unsigned int max_open_zones;=0A=
>  	int ret;=0A=
>  =0A=
> -	if (zbd->model !=3D ZBD_HOST_MANAGED) {=0A=
> +	if (zbd->model !=3D ZBD_HOST_MANAGED || td->o.ignore_zone_limits) {=0A=
>  		/* Only host-managed devices have a max open limit */=0A=
>  		zbd->max_open_zones =3D td->o.max_open_zones;=0A=
>  		goto out;=0A=
> =0A=
=0A=
With the nits above corrected,=0A=
=0A=
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=

