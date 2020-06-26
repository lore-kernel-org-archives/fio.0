Return-Path: <prvs=4391c0654=Damien.LeMoal@wdc.com>
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH 1/4] Add Zone Append command support for NVMe Zoned
 Namespaces (ZNS)
Date: Fri, 26 Jun 2020 05:33:01 +0000
Message-ID: 
 <CY4PR04MB3751CE408523493A3DF02390E7930@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <1593106733-19596-1-git-send-email-krish.reddy@samsung.com>
 <CGME20200625174124epcas5p18e4fbc502c9cf1fef7e84ba5cefba945@epcas5p1.samsung.com>
 <1593106733-19596-2-git-send-email-krish.reddy@samsung.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Krishna Kanth Reddy <krish.reddy@samsung.com>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Ankit Kumar <ankit.kumar@samsung.com>
List-ID: <fio@vger.kernel.org>

On 2020/06/26 2:41, Krishna Kanth Reddy wrote:=0A=
> From: Ankit Kumar <ankit.kumar@samsung.com>=0A=
> =0A=
> defined in NVM Express TP4053. Added a new FIO option zone_append.=0A=
> When zone_append option is enabled, the existing write path will=0A=
> send Zone Append command with offset as start of the Zone.=0A=
=0A=
Zone append is supported by SCSI disks too through emulation and will be fo=
r=0A=
nullblk too, so please generalize this patch title and commit message. This=
 is=0A=
not for NVMe ZNS devices only.=0A=
=0A=
> =0A=
> Signed-off-by: Krishna Kanth Reddy <krish.reddy@samsung.com>=0A=
> ---=0A=
>  HOWTO            |  7 +++++=0A=
>  fio.1            |  7 +++++=0A=
>  io_u.c           |  4 +--=0A=
>  io_u.h           | 10 +++++--=0A=
>  ioengines.c      |  4 +--=0A=
>  options.c        | 10 +++++++=0A=
>  thread_options.h |  2 ++=0A=
>  zbd.c            | 90 ++++++++++++++++++++++++++++++++++++++++++++++++++=
++----=0A=
>  zbd.h            | 13 +++++---=0A=
>  9 files changed, 131 insertions(+), 16 deletions(-)=0A=
> =0A=
> diff --git a/HOWTO b/HOWTO=0A=
> index 8cf8d65..62b5ac8 100644=0A=
> --- a/HOWTO=0A=
> +++ b/HOWTO=0A=
> @@ -1010,6 +1010,13 @@ Target file/device=0A=
>  	:option:`zonesize` bytes of data have been transferred. This parameter=
=0A=
>  	must be zero for :option:`zonemode` =3Dzbd.=0A=
>  =0A=
> +.. option:: zone_append=3Dbool=0A=
> +=0A=
> +	For :option:`zonemode` =3Dzbd and for :option:`rw` =3Dwrite or :option:=
=0A=
> +	`rw` =3Drandwrite, if zone_append is enabled, the the io_u points to th=
e=0A=
=0A=
s/the the io_u/the io_u=0A=
=0A=
> +	starting offset of a zone. On successful completion the multiple of=0A=
> +	sectors relative to the zone's starting offset is returned.=0A=
=0A=
You are describing this option effect from the code perspective. That is no=
t=0A=
helpful for a user who does not know fio internals. Please describe this fr=
om=0A=
the user perspective, from high level, what the option does, which is, to u=
se=0A=
zone append write command instead of regular write command.=0A=
=0A=
> +=0A=
>  .. option:: read_beyond_wp=3Dbool=0A=
>  =0A=
>  	This parameter applies to :option:`zonemode` =3Dzbd only.=0A=
> diff --git a/fio.1 b/fio.1=0A=
> index f134e0b..09add8f 100644=0A=
> --- a/fio.1=0A=
> +++ b/fio.1=0A=
> @@ -782,6 +782,13 @@ sequential workloads and ignored for random workload=
s. For read workloads,=0A=
>  see also \fBread_beyond_wp\fR.=0A=
>  =0A=
>  .TP=0A=
> +.BI zone_append=0A=
> +For \fBzonemode\fR =3Dzbd and for \fBrw\fR=3Dwrite or \fBrw\fR=3Drandwri=
te, if=0A=
> +zone_append is enabled, the io_u points to the starting offset of a zone=
. On=0A=
> +successful completion the multiple of sectors relative to the zone's sta=
rting=0A=
> +offset is returned.=0A=
=0A=
Same comment here.=0A=
=0A=
> +=0A=
> +.TP=0A=
>  .BI read_beyond_wp \fR=3D\fPbool=0A=
>  This parameter applies to \fBzonemode=3Dzbd\fR only.=0A=
>  =0A=
> diff --git a/io_u.c b/io_u.c=0A=
> index 7f50906..b891a9b 100644=0A=
> --- a/io_u.c=0A=
> +++ b/io_u.c=0A=
> @@ -778,7 +778,7 @@ void put_io_u(struct thread_data *td, struct io_u *io=
_u)=0A=
>  {=0A=
>  	const bool needs_lock =3D td_async_processing(td);=0A=
>  =0A=
> -	zbd_put_io_u(io_u);=0A=
> +	zbd_put_io_u(td, io_u);=0A=
>  =0A=
>  	if (td->parent)=0A=
>  		td =3D td->parent;=0A=
> @@ -1342,7 +1342,7 @@ static long set_io_u_file(struct thread_data *td, s=
truct io_u *io_u)=0A=
>  		if (!fill_io_u(td, io_u))=0A=
>  			break;=0A=
>  =0A=
> -		zbd_put_io_u(io_u);=0A=
> +		zbd_put_io_u(td, io_u);=0A=
>  =0A=
>  		put_file_log(td, f);=0A=
>  		td_io_close_file(td, f);=0A=
> diff --git a/io_u.h b/io_u.h=0A=
> index 87c2920..f5b24fd 100644=0A=
> --- a/io_u.h=0A=
> +++ b/io_u.h=0A=
> @@ -94,19 +94,25 @@ struct io_u {=0A=
>  	};=0A=
>  =0A=
>  	/*=0A=
> +	 * for zone append this is the start offset of the zone.=0A=
> +	 */=0A=
> +	unsigned long long zone_start_offset;=0A=
=0A=
This is not necessary. This value can be calculated from any io_u offset.=
=0A=
=0A=
> +=0A=
> +	/*=0A=
>  	 * ZBD mode zbd_queue_io callback: called after engine->queue operation=
=0A=
>  	 * to advance a zone write pointer and eventually unlock the I/O zone.=
=0A=
>  	 * @q indicates the I/O queue status (busy, queued or completed).=0A=
>  	 * @success =3D=3D true means that the I/O operation has been queued or=
=0A=
>  	 * completed successfully.=0A=
>  	 */=0A=
> -	void (*zbd_queue_io)(struct io_u *, int q, bool success);=0A=
> +	void (*zbd_queue_io)(struct thread_data *, struct io_u *, int q,=0A=
> +			     bool success);=0A=
>  =0A=
>  	/*=0A=
>  	 * ZBD mode zbd_put_io callback: called in after completion of an I/O=
=0A=
>  	 * or commit of an async I/O to unlock the I/O target zone.=0A=
>  	 */=0A=
> -	void (*zbd_put_io)(const struct io_u *);=0A=
> +	void (*zbd_put_io)(struct thread_data *, const struct io_u *);=0A=
>  =0A=
>  	/*=0A=
>  	 * Callback for io completion=0A=
> diff --git a/ioengines.c b/ioengines.c=0A=
> index 2c7a0df..81ac846 100644=0A=
> --- a/ioengines.c=0A=
> +++ b/ioengines.c=0A=
> @@ -328,7 +328,7 @@ enum fio_q_status td_io_queue(struct thread_data *td,=
 struct io_u *io_u)=0A=
>  	}=0A=
>  =0A=
>  	ret =3D td->io_ops->queue(td, io_u);=0A=
> -	zbd_queue_io_u(io_u, ret);=0A=
> +	zbd_queue_io_u(td, io_u, ret);=0A=
>  =0A=
>  	unlock_file(td, io_u->file);=0A=
>  =0A=
> @@ -370,7 +370,7 @@ enum fio_q_status td_io_queue(struct thread_data *td,=
 struct io_u *io_u)=0A=
>  	if (!td->io_ops->commit) {=0A=
>  		io_u_mark_submit(td, 1);=0A=
>  		io_u_mark_complete(td, 1);=0A=
> -		zbd_put_io_u(io_u);=0A=
> +		zbd_put_io_u(td, io_u);=0A=
>  	}=0A=
>  =0A=
>  	if (ret =3D=3D FIO_Q_COMPLETED) {=0A=
> diff --git a/options.c b/options.c=0A=
> index 85a0f49..d54da81 100644=0A=
> --- a/options.c=0A=
> +++ b/options.c=0A=
> @@ -3317,6 +3317,16 @@ struct fio_option fio_options[FIO_MAX_OPTS] =3D {=
=0A=
>  		},=0A=
>  	},=0A=
>  	{=0A=
> +		.name	=3D "zone_append",=0A=
> +		.lname	=3D "zone_append",=0A=
> +		.type	=3D FIO_OPT_BOOL,=0A=
> +		.off1	=3D offsetof(struct thread_options, zone_append),=0A=
> +		.help	=3D "Use Zone Append for Zone block device",=0A=
=0A=
"Use zone append for writing zones of a zoned block device"=0A=
=0A=
may be better as it points out that this has an effect on writes only.=0A=
=0A=
> +		.def	=3D "0",=0A=
> +		.category =3D FIO_OPT_C_IO,=0A=
> +		.group	=3D FIO_OPT_G_ZONE,=0A=
> +	},=0A=
> +	{=0A=
>  		.name	=3D "zonesize",=0A=
>  		.lname	=3D "Zone size",=0A=
>  		.type	=3D FIO_OPT_STR_VAL,=0A=
> diff --git a/thread_options.h b/thread_options.h=0A=
> index 968ea0a..45c5ef8 100644=0A=
> --- a/thread_options.h=0A=
> +++ b/thread_options.h=0A=
> @@ -195,6 +195,7 @@ struct thread_options {=0A=
>  	unsigned long long zone_size;=0A=
>  	unsigned long long zone_skip;=0A=
>  	enum fio_zone_mode zone_mode;=0A=
> +	unsigned int zone_append;=0A=
>  	unsigned long long lockmem;=0A=
>  	enum fio_memtype mem_type;=0A=
>  	unsigned int mem_align;=0A=
> @@ -631,6 +632,7 @@ struct thread_options_pack {=0A=
>  	uint32_t allow_mounted_write;=0A=
>  =0A=
>  	uint32_t zone_mode;=0A=
> +	uint32_t zone_append;=0A=
>  } __attribute__((packed));=0A=
>  =0A=
>  extern void convert_thread_options_to_cpu(struct thread_options *o, stru=
ct thread_options_pack *top);=0A=
> diff --git a/zbd.c b/zbd.c=0A=
> index 8cf8f81..ffdb766 100644=0A=
> --- a/zbd.c=0A=
> +++ b/zbd.c=0A=
> @@ -455,6 +455,7 @@ static int parse_zone_info(struct thread_data *td, st=
ruct fio_file *f)=0A=
>  		for (i =3D 0; i < nrz; i++, j++, z++, p++) {=0A=
>  			mutex_init_pshared_with_type(&p->mutex,=0A=
>  						     PTHREAD_MUTEX_RECURSIVE);=0A=
> +			cond_init_pshared(&p->reset_cond);=0A=
=0A=
It would be nice if the commit message explained the changes in this patch =
and=0A=
explain the role of this condition variable. It is not clear to me at all.=
=0A=
=0A=
>  			p->start =3D z->start;=0A=
>  			switch (z->cond) {=0A=
>  			case ZBD_ZONE_COND_NOT_WP:=0A=
> @@ -469,6 +470,7 @@ static int parse_zone_info(struct thread_data *td, st=
ruct fio_file *f)=0A=
>  			}=0A=
>  			p->type =3D z->type;=0A=
>  			p->cond =3D z->cond;=0A=
> +			p->pending_ios =3D 0;=0A=
=0A=
Same here. This is not explained so one has to figure it out from the code =
only.=0A=
Not easy to do as what I think is needed may not be what *you* thought in t=
he=0A=
first place.=0A=
=0A=
>  			if (j > 0 && p->start !=3D p[-1].start + zone_size) {=0A=
>  				log_info("%s: invalid zone data\n",=0A=
>  					 f->file_name);=0A=
> @@ -1196,20 +1198,24 @@ zbd_find_zone(struct thread_data *td, struct io_u=
 *io_u,=0A=
>  =0A=
>  /**=0A=
>   * zbd_queue_io - update the write pointer of a sequential zone=0A=
> + * @td: fio thread data.=0A=
>   * @io_u: I/O unit=0A=
>   * @success: Whether or not the I/O unit has been queued successfully=0A=
>   * @q: queueing status (busy, completed or queued).=0A=
>   *=0A=
>   * For write and trim operations, update the write pointer of the I/O un=
it=0A=
>   * target zone.=0A=
> + * For zone append operation, release the zone mutex=0A=
>   */=0A=
> -static void zbd_queue_io(struct io_u *io_u, int q, bool success)=0A=
> +static void zbd_queue_io(struct thread_data *td, struct io_u *io_u, int =
q,=0A=
> +			 bool success)=0A=
>  {=0A=
>  	const struct fio_file *f =3D io_u->file;=0A=
>  	struct zoned_block_device_info *zbd_info =3D f->zbd_info;=0A=
>  	struct fio_zone_info *z;=0A=
>  	uint32_t zone_idx;=0A=
>  	uint64_t zone_end;=0A=
> +	int ret;=0A=
>  =0A=
>  	if (!zbd_info)=0A=
>  		return;=0A=
> @@ -1241,6 +1247,8 @@ static void zbd_queue_io(struct io_u *io_u, int q, =
bool success)=0A=
>  			zbd_info->sectors_with_data +=3D zone_end - z->wp;=0A=
>  		pthread_mutex_unlock(&zbd_info->mutex);=0A=
>  		z->wp =3D zone_end;=0A=
> +		if (td->o.zone_append)=0A=
> +			z->pending_ios++;=0A=
=0A=
The name is not very good. Shouldn't this be queued_ios ? And since fio=0A=
differentiate queued and in-flight, but this counter does not and is for zo=
ne=0A=
append commands only, it may be even better to call this something like=0A=
in_flight_za_ios or something like that to clarify the use and avoid confus=
ion.=0A=
=0A=
>  		break;=0A=
>  	case DDIR_TRIM:=0A=
>  		assert(z->wp =3D=3D z->start);=0A=
> @@ -1250,18 +1258,22 @@ static void zbd_queue_io(struct io_u *io_u, int q=
, bool success)=0A=
>  	}=0A=
>  =0A=
>  unlock:=0A=
> -	if (!success || q !=3D FIO_Q_QUEUED) {=0A=
> +	if (!success || q !=3D FIO_Q_QUEUED || td->o.zone_append) {=0A=
>  		/* BUSY or COMPLETED: unlock the zone */=0A=
> -		pthread_mutex_unlock(&z->mutex);=0A=
> -		io_u->zbd_put_io =3D NULL;=0A=
> +		ret =3D pthread_mutex_unlock(&z->mutex);=0A=
> +		assert(ret =3D=3D 0);=0A=
> +		if (!success || q !=3D FIO_Q_QUEUED)=0A=
> +			io_u->zbd_put_io =3D NULL;=0A=
>  	}=0A=
>  }=0A=
>  =0A=
>  /**=0A=
>   * zbd_put_io - Unlock an I/O unit target zone lock=0A=
> + * For zone append operation we don't hold zone lock=0A=
> + * @td: fio thread data.=0A=
>   * @io_u: I/O unit=0A=
>   */=0A=
> -static void zbd_put_io(const struct io_u *io_u)=0A=
> +static void zbd_put_io(struct thread_data *td, const struct io_u *io_u)=
=0A=
>  {=0A=
>  	const struct fio_file *f =3D io_u->file;=0A=
>  	struct zoned_block_device_info *zbd_info =3D f->zbd_info;=0A=
> @@ -1283,6 +1295,19 @@ static void zbd_put_io(const struct io_u *io_u)=0A=
>  	       "%s: terminate I/O (%lld, %llu) for zone %u\n",=0A=
>  	       f->file_name, io_u->offset, io_u->buflen, zone_idx);=0A=
>  =0A=
> +	if (td->o.zone_append) {=0A=
> +		pthread_mutex_lock(&z->mutex);=0A=
> +		if (z->pending_ios > 0) {=0A=
> +			z->pending_ios--;=0A=
> +			/*=0A=
> +			 * Other threads may be waiting for pending I/O's to=0A=
> +			 * complete for this zone. Notify them.=0A=
> +			 */=0A=
=0A=
Please move this comment inside the if, or even better, at the beginning of=
 this=0A=
code block. And also explain why the zone lock needs to be taken here for  =
zone=0A=
append only.=0A=
> +			if (!z->pending_ios)=0A=
> +				pthread_cond_broadcast(&z->reset_cond);=0A=
> +		}=0A=
> +	}=0A=
> +=0A=
>  	ret =3D pthread_mutex_unlock(&z->mutex);=0A=
>  	assert(ret =3D=3D 0);=0A=
>  	zbd_check_swd(f);=0A=
> @@ -1524,16 +1549,69 @@ enum io_u_action zbd_adjust_block(struct thread_d=
ata *td, struct io_u *io_u)=0A=
>  			 * asynchronously and since we will submit the zone=0A=
>  			 * reset synchronously, wait until previously submitted=0A=
>  			 * write requests have completed before issuing a=0A=
> -			 * zone reset.=0A=
> +			 * zone reset. For append request release the zone lock=0A=
> +			 * as other threads will acquire it at the time of=0A=
> +			 * zbd_put_io.=0A=
>  			 */=0A=
> +reset:=0A=
> +			if (td->o.zone_append)=0A=
> +				pthread_mutex_unlock(&zb->mutex);=0A=
>  			io_u_quiesce(td);=0A=
> +			if (td->o.zone_append)=0A=
> +				pthread_mutex_lock(&zb->mutex);=0A=
> +=0A=
>  			zb->reset_zone =3D 0;=0A=
> +			if (td->o.zone_append) {=0A=
> +				/*=0A=
> +				 * While processing the current thread queued=0A=
> +				 * requests the other thread may have already=0A=
> +				 * done zone reset so need to check zone full=0A=
> +				 * condition again.=0A=
> +				 */=0A=
> +				if (!zbd_zone_full(f, zb, min_bs))=0A=
> +					goto proceed;=0A=
> +				/*=0A=
> +				 * Wait for the pending requests to be completed=0A=
> +				 * else we are ok to reset this zone.=0A=
> +				 */=0A=
> +				if (zb->pending_ios) {=0A=
> +					pthread_cond_wait(&zb->reset_cond, &zb->mutex);=0A=
> +					goto proceed;=0A=
=0A=
If you are OK to reset  the zone after the cond wait, why the jump to proce=
ed ?=0A=
That will skip the reset...=0A=
=0A=
> +				}=0A=
> +			}=0A=
> +=0A=
>  			if (zbd_reset_zone(td, f, zb) < 0)=0A=
>  				goto eof;=0A=
> +=0A=
> +			/* Notify other threads waiting for zone mutex */=0A=
> +			if (td->o.zone_append)=0A=
> +				pthread_cond_broadcast(&zb->reset_cond);=0A=
=0A=
Why ? isn't this cond variable used to signal pending_ios going to 0 ?=0A=
=0A=
> +		}=0A=
> +proceed:=0A=
> +		/*=0A=
> +		 * Check for zone full condition again. For zone append request=0A=
> +		 * the zone may already be reset, written and full while we=0A=
> +		 * were waiting for our turn.=0A=
> +		 */=0A=
> +		if (zbd_zone_full(f, zb, min_bs)) {=0A=
> +			goto reset;=0A=
>  		}=0A=
=0A=
No need for the curly braces. But the main problem here is that a job is no=
t=0A=
guaranteeds to ever be able to issue a zone append. A job may end up loopin=
g=0A=
indefinitely between here and reset label.=0A=
=0A=
This does not look necessary at all to me. The zone is locked and it was al=
ready=0A=
determined that reset is not needed, or, the zone was already reset a few l=
ine=0A=
above after waiting for all pending ios, all of that with the zone locked. =
So=0A=
how can it become full again at this point ?=0A=
=0A=
> +=0A=
>  		/* Make writes occur at the write pointer */=0A=
>  		assert(!zbd_zone_full(f, zb, min_bs));=0A=
>  		io_u->offset =3D zb->wp;=0A=
> +=0A=
> +		/*=0A=
> +		 * Support zone append for both regular and zoned block=0A=
> +		 * device.=0A=
> +		 */=0A=
> +		if (td->o.zone_append) {=0A=
> +			if (f->zbd_info->model =3D=3D ZBD_NONE)=0A=
> +				io_u->zone_start_offset =3D zb->wp;=0A=
> +			else=0A=
> +				io_u->zone_start_offset =3D zb->start;=0A=
> +		}=0A=
=0A=
This hunk is not needed. zone start offset is:=0A=
=0A=
io_u->offset & ~(zone_size - 1)=0A=
=0A=
with zone_size being either td->o.zone_size or f->zbd_info->zone_size. So y=
ou=0A=
can completely drop this zone_start_offset field.=0A=
=0A=
> +=0A=
>  		if (!is_valid_offset(f, io_u->offset)) {=0A=
>  			dprint(FD_ZBD, "Dropped request with offset %llu\n",=0A=
>  			       io_u->offset);=0A=
> diff --git a/zbd.h b/zbd.h=0A=
> index e942a7f..eac42f7 100644=0A=
> --- a/zbd.h=0A=
> +++ b/zbd.h=0A=
> @@ -23,8 +23,10 @@ enum io_u_action {=0A=
>   * struct fio_zone_info - information about a single ZBD zone=0A=
>   * @start: zone start location (bytes)=0A=
>   * @wp: zone write pointer location (bytes)=0A=
> + * @pending_ios: Number of IO's pending in this zone=0A=
=0A=
Misleading. This is the nukmber of zone append IOs. Only zone append. You a=
re=0A=
not counting reads or writes withe this.=0A=
=0A=
>   * @verify_block: number of blocks that have been verified for this zone=
=0A=
>   * @mutex: protects the modifiable members in this structure=0A=
> + * @reset_cond: zone reset check condition. only relevant for zone_appen=
d.=0A=
=0A=
You are using it to signal pending_ios going to 0 too.=0A=
=0A=
>   * @type: zone type (BLK_ZONE_TYPE_*)=0A=
>   * @cond: zone state (BLK_ZONE_COND_*)=0A=
>   * @open: whether or not this zone is currently open. Only relevant if=
=0A=
> @@ -33,8 +35,10 @@ enum io_u_action {=0A=
>   */=0A=
>  struct fio_zone_info {=0A=
>  	pthread_mutex_t		mutex;=0A=
> +	pthread_cond_t		reset_cond;=0A=
>  	uint64_t		start;=0A=
>  	uint64_t		wp;=0A=
> +	uint32_t		pending_ios;=0A=
>  	uint32_t		verify_block;=0A=
>  	enum zbd_zone_type	type:2;=0A=
>  	enum zbd_zone_cond	cond:4;=0A=
> @@ -96,18 +100,19 @@ static inline void zbd_close_file(struct fio_file *f=
)=0A=
>  		zbd_free_zone_info(f);=0A=
>  }=0A=
>  =0A=
> -static inline void zbd_queue_io_u(struct io_u *io_u, enum fio_q_status s=
tatus)=0A=
> +static inline void zbd_queue_io_u(struct thread_data *td, struct io_u *i=
o_u,=0A=
> +				  enum fio_q_status status)=0A=
>  {=0A=
>  	if (io_u->zbd_queue_io) {=0A=
> -		io_u->zbd_queue_io(io_u, status, io_u->error =3D=3D 0);=0A=
> +		io_u->zbd_queue_io(td, io_u, status, io_u->error =3D=3D 0);=0A=
>  		io_u->zbd_queue_io =3D NULL;=0A=
>  	}=0A=
>  }=0A=
>  =0A=
> -static inline void zbd_put_io_u(struct io_u *io_u)=0A=
> +static inline void zbd_put_io_u(struct thread_data *td, struct io_u *io_=
u)=0A=
>  {=0A=
>  	if (io_u->zbd_put_io) {=0A=
> -		io_u->zbd_put_io(io_u);=0A=
> +		io_u->zbd_put_io(td, io_u);=0A=
>  		io_u->zbd_queue_io =3D NULL;=0A=
>  		io_u->zbd_put_io =3D NULL;=0A=
>  	}=0A=
> =0A=
=0A=
So a few fixes are needed. However, my biggest concerns is the change to zo=
ne=0A=
locking just for zone append... I kind of like the idea to not hold the zon=
e=0A=
lock for the entire duration of IOs, and the condition variable with IO cou=
nter=0A=
seem to be a reasonnable way to do that. Have you tried extending this lock=
ing=0A=
change to all IOs (read and write) ? A prep patch could do that and zone ap=
pend=0A=
support can come on top. I am however worried that all of this may not be t=
hat=0A=
easy due to the various inspection loops for choosing a zone to read or wri=
te,=0A=
finding an open zone or finding a zone to close & open. This needs checking=
, or=0A=
at least explainations in the commit message that none of it is affexcted b=
y=0A=
your change.=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=

