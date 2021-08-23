Return-Path: <prvs=8624f6c1e=Damien.LeMoal@wdc.com>
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH] options: Add thinktime_iotime option
Date: Mon, 23 Aug 2021 01:10:14 +0000
Message-ID: 
 <DM6PR04MB70819EEF6D7109B5EF691BCBE7C49@DM6PR04MB7081.namprd04.prod.outlook.com>
References: <20210820112542.1489147-1-shinichiro.kawasaki@wdc.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

On 2021/08/20 20:25, Shin'ichiro Kawasaki wrote:=0A=
> The thinktime option allows stalling a job for a specified amount of=0A=
> time. Using the thinktime_blocks option, periodic stalls can be added=0A=
> every thinktime_blocks IOs. However, with this option, the periodic=0A=
> stall may not be repeated at equal time intervals as the time to execute=
=0A=
> thinktime_blocks IOs may vary.=0A=
> =0A=
> To control the thinktime interval by time, introduce the option=0A=
> thinktime_iotime. With this new option, the thinktime stall is repeated=
=0A=
> after IOs are executed for thinktime_iotime. If this option is used=0A=
> together with the thinktime_blocks option, the thinktime pause is=0A=
> repeated after thinktime_iotime or after thinktime_blocks IOs, whichever=
=0A=
> happens first.=0A=
> =0A=
> To track the time and IO block count at the last stall, add=0A=
> last_thinktime variable and last_thinktime_blocks variable to struct=0A=
> thread_data. Also, introduce the helper function init_thinktime()=0A=
> to group thinktime related preparations.=0A=
> =0A=
> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>=0A=
> ---=0A=
>  HOWTO            |  9 ++++++++-=0A=
>  backend.c        | 45 +++++++++++++++++++++++++++++++++++++++------=0A=
>  cconv.c          |  2 ++=0A=
>  fio.1            |  7 ++++++-=0A=
>  fio.h            |  2 ++=0A=
>  options.c        | 14 ++++++++++++++=0A=
>  server.h         |  2 +-=0A=
>  thread_options.h |  3 +++=0A=
>  8 files changed, 75 insertions(+), 9 deletions(-)=0A=
> =0A=
> diff --git a/HOWTO b/HOWTO=0A=
> index 9bfd38b4..cfb278ef 100644=0A=
> --- a/HOWTO=0A=
> +++ b/HOWTO=0A=
> @@ -2710,7 +2710,7 @@ I/O rate=0A=
>  	Stall the job for the specified period of time after an I/O has complet=
ed before issuing the=0A=
>  	next. May be used to simulate processing being done by an application.=
=0A=
>  	When the unit is omitted, the value is interpreted in microseconds.  Se=
e=0A=
> -	:option:`thinktime_blocks` and :option:`thinktime_spin`.=0A=
> +	:option:`thinktime_blocks`, :option:`thinktime_iotime` and :option:`thi=
nktime_spin`.=0A=
>  =0A=
>  .. option:: thinktime_spin=3Dtime=0A=
>  =0A=
> @@ -2735,6 +2735,13 @@ I/O rate=0A=
>  	:option:`thinktime_blocks` blocks. If this is set to `issue`, then the =
trigger happens=0A=
>  	at the issue side.=0A=
>  =0A=
> +.. option:: thinktime_iotime=3Dtime=0A=
> +=0A=
> +	Only valid if :option:`thinktime` is set - Repeat job stall for=0A=
> +	:option:`thinktime` after executing I/Os for `thinktime_iotime`. When=
=0A=
> +	the unit is omitted, :option:`thinktime_iotime` is interpreted as a=0A=
> +	number of seconds.=0A=
> +=0A=
>  .. option:: rate=3Dint[,int][,int]=0A=
>  =0A=
>  	Cap the bandwidth used by this job. The number is in bytes/sec, the nor=
mal=0A=
> diff --git a/backend.c b/backend.c=0A=
> index 808e4362..5cdb8124 100644=0A=
> --- a/backend.c=0A=
> +++ b/backend.c=0A=
> @@ -858,15 +858,47 @@ static long long usec_for_io(struct thread_data *td=
, enum fio_ddir ddir)=0A=
>  	return 0;=0A=
>  }=0A=
>  =0A=
> +static void init_thinktime(struct thread_data *td)=0A=
> +{=0A=
> +	if (td->o.thinktime_blocks_type =3D=3D THINKTIME_BLOCKS_TYPE_COMPLETE)=
=0A=
> +		td->thinktime_blocks_counter =3D td->io_blocks;=0A=
> +	else=0A=
> +		td->thinktime_blocks_counter =3D td->io_issues;=0A=
> +	td->last_thinktime =3D td->epoch;=0A=
> +	td->last_thinktime_blocks =3D 0;=0A=
> +}=0A=
> +=0A=
>  static void handle_thinktime(struct thread_data *td, enum fio_ddir ddir,=
=0A=
>  			     struct timespec *time)=0A=
>  {=0A=
>  	unsigned long long b;=0A=
>  	uint64_t total;=0A=
>  	int left;=0A=
> +	struct timespec now;=0A=
> +	bool stall =3D false;=0A=
> +=0A=
> +	if (td->o.thinktime_iotime) {=0A=
> +		fio_gettime(&now, NULL);=0A=
> +		if (utime_since(&td->last_thinktime, &now)=0A=
> +		    >=3D td->o.thinktime_iotime + td->o.thinktime) {=0A=
> +			stall =3D true;=0A=
> +		} else if (!fio_option_is_set(&td->o, thinktime_blocks)) {=0A=
> +			/*=0A=
> +			 * When thinktime_iotime is set and thinktime_blocks is=0A=
> +			 * not set, skip the thinktime_blocks check, since=0A=
> +			 * thinktime_blocks default value 1 does not work=0A=
> +			 * together with thinktime_iotime.=0A=
> +			 */=0A=
> +			return;=0A=
> +		}=0A=
> +=0A=
> +	}=0A=
>  =0A=
>  	b =3D ddir_rw_sum(td->thinktime_blocks_counter);=0A=
> -	if (b % td->o.thinktime_blocks || !b)=0A=
> +	if (b >=3D td->last_thinktime_blocks + td->o.thinktime_blocks)=0A=
> +		stall =3D true;=0A=
> +=0A=
> +	if (!stall)=0A=
>  		return;=0A=
>  =0A=
>  	io_u_quiesce(td);=0A=
> @@ -902,6 +934,10 @@ static void handle_thinktime(struct thread_data *td,=
 enum fio_ddir ddir,=0A=
>  =0A=
>  	if (time && should_check_rate(td))=0A=
>  		fio_gettime(time, NULL);=0A=
> +=0A=
> +	td->last_thinktime_blocks =3D b;=0A=
> +	if (td->o.thinktime_iotime)=0A=
> +		td->last_thinktime =3D now;=0A=
>  }=0A=
>  =0A=
>  /*=0A=
> @@ -1791,17 +1827,14 @@ static void *thread_main(void *data)=0A=
>  	if (rate_submit_init(td, sk_out))=0A=
>  		goto err;=0A=
>  =0A=
> -	if (td->o.thinktime_blocks_type =3D=3D THINKTIME_BLOCKS_TYPE_COMPLETE)=
=0A=
> -		td->thinktime_blocks_counter =3D td->io_blocks;=0A=
> -	else=0A=
> -		td->thinktime_blocks_counter =3D td->io_issues;=0A=
> -=0A=
>  	set_epoch_time(td, o->log_unix_epoch);=0A=
>  	fio_getrusage(&td->ru_start);=0A=
>  	memcpy(&td->bw_sample_time, &td->epoch, sizeof(td->epoch));=0A=
>  	memcpy(&td->iops_sample_time, &td->epoch, sizeof(td->epoch));=0A=
>  	memcpy(&td->ss.prev_time, &td->epoch, sizeof(td->epoch));=0A=
>  =0A=
> +	init_thinktime(td);=0A=
> +=0A=
>  	if (o->ratemin[DDIR_READ] || o->ratemin[DDIR_WRITE] ||=0A=
>  			o->ratemin[DDIR_TRIM]) {=0A=
>  	        memcpy(&td->lastrate[DDIR_READ], &td->bw_sample_time,=0A=
> diff --git a/cconv.c b/cconv.c=0A=
> index e3a8c27c..92491ddb 100644=0A=
> --- a/cconv.c=0A=
> +++ b/cconv.c=0A=
> @@ -213,6 +213,7 @@ void convert_thread_options_to_cpu(struct thread_opti=
ons *o,=0A=
>  	o->thinktime_spin =3D le32_to_cpu(top->thinktime_spin);=0A=
>  	o->thinktime_blocks =3D le32_to_cpu(top->thinktime_blocks);=0A=
>  	o->thinktime_blocks_type =3D le32_to_cpu(top->thinktime_blocks_type);=
=0A=
> +	o->thinktime_iotime =3D le32_to_cpu(top->thinktime_iotime);=0A=
>  	o->fsync_blocks =3D le32_to_cpu(top->fsync_blocks);=0A=
>  	o->fdatasync_blocks =3D le32_to_cpu(top->fdatasync_blocks);=0A=
>  	o->barrier_blocks =3D le32_to_cpu(top->barrier_blocks);=0A=
> @@ -438,6 +439,7 @@ void convert_thread_options_to_net(struct thread_opti=
ons_pack *top,=0A=
>  	top->thinktime_spin =3D cpu_to_le32(o->thinktime_spin);=0A=
>  	top->thinktime_blocks =3D cpu_to_le32(o->thinktime_blocks);=0A=
>  	top->thinktime_blocks_type =3D __cpu_to_le32(o->thinktime_blocks_type);=
=0A=
> +	top->thinktime_iotime =3D __cpu_to_le32(o->thinktime_iotime);=0A=
>  	top->fsync_blocks =3D cpu_to_le32(o->fsync_blocks);=0A=
>  	top->fdatasync_blocks =3D cpu_to_le32(o->fdatasync_blocks);=0A=
>  	top->barrier_blocks =3D cpu_to_le32(o->barrier_blocks);=0A=
> diff --git a/fio.1 b/fio.1=0A=
> index 382cebfc..3cae15b3 100644=0A=
> --- a/fio.1=0A=
> +++ b/fio.1=0A=
> @@ -2471,7 +2471,7 @@ problem). Note that this option cannot reliably be =
used with async IO engines.=0A=
>  Stall the job for the specified period of time after an I/O has complete=
d before issuing the=0A=
>  next. May be used to simulate processing being done by an application.=
=0A=
>  When the unit is omitted, the value is interpreted in microseconds. See=
=0A=
> -\fBthinktime_blocks\fR and \fBthinktime_spin\fR.=0A=
> +\fBthinktime_blocks\fR, \fBthinktime_iotime\fR and \fBthinktime_spin\fR.=
=0A=
>  .TP=0A=
>  .BI thinktime_spin \fR=3D\fPtime=0A=
>  Only valid if \fBthinktime\fR is set - pretend to spend CPU time doing=
=0A=
> @@ -2493,6 +2493,11 @@ The default is `complete', which triggers \fBthink=
time\fR when fio completes=0A=
>  \fBthinktime_blocks\fR blocks. If this is set to `issue', then the trigg=
er happens=0A=
>  at the issue side.=0A=
>  .TP=0A=
> +.BI thinktime_iotime \fR=3D\fPtime=0A=
> +Only valid if \fBthinktime\fR is set - Repeat job stall for \fBthinktime=
\fR=0A=
> +after executing I/Os for \fBthinktime_iotime\fR. When the unit is omitte=
d,=0A=
> +\fBthinktime_iotime\fR is interpreted as a number of seconds.=0A=
> +.TP=0A=
>  .BI rate \fR=3D\fPint[,int][,int]=0A=
>  Cap the bandwidth used by this job. The number is in bytes/sec, the norm=
al=0A=
>  suffix rules apply. Comma-separated values may be specified for reads,=
=0A=
> diff --git a/fio.h b/fio.h=0A=
> index 6f6b211b..85ed60fc 100644=0A=
> --- a/fio.h=0A=
> +++ b/fio.h=0A=
> @@ -365,6 +365,8 @@ struct thread_data {=0A=
>  	uint64_t bytes_done[DDIR_RWDIR_CNT];=0A=
>  =0A=
>  	uint64_t *thinktime_blocks_counter;=0A=
> +	struct timespec last_thinktime;=0A=
> +	uint64_t last_thinktime_blocks;=0A=
>  =0A=
>  	/*=0A=
>  	 * State for random io, a bitmap of blocks done vs not done=0A=
> diff --git a/options.c b/options.c=0A=
> index 8c2ab7cc..3fe1e6bd 100644=0A=
> --- a/options.c=0A=
> +++ b/options.c=0A=
> @@ -3688,6 +3688,20 @@ struct fio_option fio_options[FIO_MAX_OPTS] =3D {=
=0A=
>  		},=0A=
>  		.parent =3D "thinktime",=0A=
>  	},=0A=
> +	{=0A=
> +		.name	=3D "thinktime_iotime",=0A=
> +		.lname	=3D "Thinktime interval",=0A=
> +		.type	=3D FIO_OPT_INT,=0A=
> +		.off1	=3D offsetof(struct thread_options, thinktime_iotime),=0A=
> +		.help	=3D "IO time interval between 'thinktime'",=0A=
> +		.is_time =3D 1,=0A=
> +		.is_seconds =3D 1,=0A=
> +		.def	=3D "0",=0A=
> +		.parent	=3D "thinktime",=0A=
> +		.hide	=3D 1,=0A=
> +		.category =3D FIO_OPT_C_IO,=0A=
> +		.group	=3D FIO_OPT_G_THINKTIME,=0A=
> +	},=0A=
>  	{=0A=
>  		.name	=3D "rate",=0A=
>  		.lname	=3D "I/O rate",=0A=
> diff --git a/server.h b/server.h=0A=
> index daed057a..7ce2ddb1 100644=0A=
> --- a/server.h=0A=
> +++ b/server.h=0A=
> @@ -48,7 +48,7 @@ struct fio_net_cmd_reply {=0A=
>  };=0A=
>  =0A=
>  enum {=0A=
> -	FIO_SERVER_VER			=3D 92,=0A=
> +	FIO_SERVER_VER			=3D 93,=0A=
>  =0A=
>  	FIO_SERVER_MAX_FRAGMENT_PDU	=3D 1024,=0A=
>  	FIO_SERVER_MAX_CMD_MB		=3D 2048,=0A=
> diff --git a/thread_options.h b/thread_options.h=0A=
> index 4b4ecfe1..6fe1cad7 100644=0A=
> --- a/thread_options.h=0A=
> +++ b/thread_options.h=0A=
> @@ -189,6 +189,7 @@ struct thread_options {=0A=
>  	unsigned int thinktime_spin;=0A=
>  	unsigned int thinktime_blocks;=0A=
>  	unsigned int thinktime_blocks_type;=0A=
> +	unsigned int thinktime_iotime;=0A=
>  	unsigned int fsync_blocks;=0A=
>  	unsigned int fdatasync_blocks;=0A=
>  	unsigned int barrier_blocks;=0A=
> @@ -500,6 +501,8 @@ struct thread_options_pack {=0A=
>  	uint32_t thinktime_spin;=0A=
>  	uint32_t thinktime_blocks;=0A=
>  	uint32_t thinktime_blocks_type;=0A=
> +	uint32_t thinktime_iotime;=0A=
> +	uint32_t pad6;=0A=
=0A=
Why is this needed ? Some alignement warning ? If yes, have you tried movin=
g=0A=
this declaration in the struct ?=0A=
=0A=
>  	uint32_t fsync_blocks;=0A=
>  	uint32_t fdatasync_blocks;=0A=
>  	uint32_t barrier_blocks;=0A=
> =0A=
=0A=
Apart from the question above, this looks good to me.=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=

