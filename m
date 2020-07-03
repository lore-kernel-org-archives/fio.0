Return-Path: <krish.reddy@samsung.com>
Date: Fri, 3 Jul 2020 22:20:42 +0530
From: Krishna Kanth Reddy <krish.reddy@samsung.com>
Subject: Re: [PATCH 1/4] Add Zone Append command support for NVMe Zoned
 Namespaces (ZNS)
Message-ID: <20200703165042.GA2391@test-zns>
MIME-Version: 1.0
In-Reply-To: <CY4PR04MB375191A36EF1B39B8257DC28E7930@CY4PR04MB3751.namprd04.prod.outlook.com>
Content-Type: multipart/mixed;
	boundary="----nai8lIH9ngBNHun9R6qswQcIIemhXBCkNXu5CagZqSM5j8ea=_c89d4_"
References: <1593106733-19596-1-git-send-email-krish.reddy@samsung.com>
	<CGME20200625174124epcas5p18e4fbc502c9cf1fef7e84ba5cefba945@epcas5p1.samsung.com>
	<1593106733-19596-2-git-send-email-krish.reddy@samsung.com>
	<CY4PR04MB375191A36EF1B39B8257DC28E7930@CY4PR04MB3751.namprd04.prod.outlook.com>
To: Damien Le Moal <Damien.LeMoal@wdc.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>, Ankit Kumar <ankit.kumar@samsung.com>
List-ID: <fio@vger.kernel.org>

------nai8lIH9ngBNHun9R6qswQcIIemhXBCkNXu5CagZqSM5j8ea=_c89d4_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On Fri, Jun 26, 2020 at 05:50:10AM +0000, Damien Le Moal wrote:
>On 2020/06/26 2:41, Krishna Kanth Reddy wrote:
>> From: Ankit Kumar <ankit.kumar@samsung.com>
>>
>> defined in NVM Express TP4053. Added a new FIO option zone_append.
>> When zone_append option is enabled, the existing write path will
>> send Zone Append command with offset as start of the Zone.
>>
>> Signed-off-by: Krishna Kanth Reddy <krish.reddy@samsung.com>
>> ---
>>  HOWTO            |  7 +++++
>>  fio.1            |  7 +++++
>>  io_u.c           |  4 +--
>>  io_u.h           | 10 +++++--
>>  ioengines.c      |  4 +--
>>  options.c        | 10 +++++++
>>  thread_options.h |  2 ++
>>  zbd.c            | 90 ++++++++++++++++++++++++++++++++++++++++++++++++++++----
>>  zbd.h            | 13 +++++---
>>  9 files changed, 131 insertions(+), 16 deletions(-)
>>
>> diff --git a/HOWTO b/HOWTO
>> index 8cf8d65..62b5ac8 100644
>> --- a/HOWTO
>> +++ b/HOWTO
>> @@ -1010,6 +1010,13 @@ Target file/device
>>  	:option:`zonesize` bytes of data have been transferred. This parameter
>>  	must be zero for :option:`zonemode` =zbd.
>>
>> +.. option:: zone_append=bool
>> +
>> +	For :option:`zonemode` =zbd and for :option:`rw` =write or :option:
>> +	`rw` =randwrite, if zone_append is enabled, the the io_u points to the
>> +	starting offset of a zone. On successful completion the multiple of
>> +	sectors relative to the zone's starting offset is returned.
>> +
>>  .. option:: read_beyond_wp=bool
>>
>>  	This parameter applies to :option:`zonemode` =zbd only.
>> diff --git a/fio.1 b/fio.1
>> index f134e0b..09add8f 100644
>> --- a/fio.1
>> +++ b/fio.1
>> @@ -782,6 +782,13 @@ sequential workloads and ignored for random workloads. For read workloads,
>>  see also \fBread_beyond_wp\fR.
>>
>>  .TP
>> +.BI zone_append
>> +For \fBzonemode\fR =zbd and for \fBrw\fR=write or \fBrw\fR=randwrite, if
>> +zone_append is enabled, the io_u points to the starting offset of a zone. On
>> +successful completion the multiple of sectors relative to the zone's starting
>> +offset is returned.
>> +
>> +.TP
>>  .BI read_beyond_wp \fR=\fPbool
>>  This parameter applies to \fBzonemode=zbd\fR only.
>>
>> diff --git a/io_u.c b/io_u.c
>> index 7f50906..b891a9b 100644
>> --- a/io_u.c
>> +++ b/io_u.c
>> @@ -778,7 +778,7 @@ void put_io_u(struct thread_data *td, struct io_u *io_u)
>>  {
>>  	const bool needs_lock = td_async_processing(td);
>>
>> -	zbd_put_io_u(io_u);
>> +	zbd_put_io_u(td, io_u);
>>
>>  	if (td->parent)
>>  		td = td->parent;
>> @@ -1342,7 +1342,7 @@ static long set_io_u_file(struct thread_data *td, struct io_u *io_u)
>>  		if (!fill_io_u(td, io_u))
>>  			break;
>>
>> -		zbd_put_io_u(io_u);
>> +		zbd_put_io_u(td, io_u);
>>
>>  		put_file_log(td, f);
>>  		td_io_close_file(td, f);
>> diff --git a/io_u.h b/io_u.h
>> index 87c2920..f5b24fd 100644
>> --- a/io_u.h
>> +++ b/io_u.h
>> @@ -94,19 +94,25 @@ struct io_u {
>>  	};
>>
>>  	/*
>> +	 * for zone append this is the start offset of the zone.
>> +	 */
>> +	unsigned long long zone_start_offset;
>> +
>> +	/*
>>  	 * ZBD mode zbd_queue_io callback: called after engine->queue operation
>>  	 * to advance a zone write pointer and eventually unlock the I/O zone.
>>  	 * @q indicates the I/O queue status (busy, queued or completed).
>>  	 * @success == true means that the I/O operation has been queued or
>>  	 * completed successfully.
>>  	 */
>> -	void (*zbd_queue_io)(struct io_u *, int q, bool success);
>> +	void (*zbd_queue_io)(struct thread_data *, struct io_u *, int q,
>> +			     bool success);
>>
>>  	/*
>>  	 * ZBD mode zbd_put_io callback: called in after completion of an I/O
>>  	 * or commit of an async I/O to unlock the I/O target zone.
>>  	 */
>> -	void (*zbd_put_io)(const struct io_u *);
>> +	void (*zbd_put_io)(struct thread_data *, const struct io_u *);
>>
>>  	/*
>>  	 * Callback for io completion
>> diff --git a/ioengines.c b/ioengines.c
>> index 2c7a0df..81ac846 100644
>> --- a/ioengines.c
>> +++ b/ioengines.c
>> @@ -328,7 +328,7 @@ enum fio_q_status td_io_queue(struct thread_data *td, struct io_u *io_u)
>>  	}
>>
>>  	ret = td->io_ops->queue(td, io_u);
>> -	zbd_queue_io_u(io_u, ret);
>> +	zbd_queue_io_u(td, io_u, ret);
>>
>>  	unlock_file(td, io_u->file);
>>
>> @@ -370,7 +370,7 @@ enum fio_q_status td_io_queue(struct thread_data *td, struct io_u *io_u)
>>  	if (!td->io_ops->commit) {
>>  		io_u_mark_submit(td, 1);
>>  		io_u_mark_complete(td, 1);
>> -		zbd_put_io_u(io_u);
>> +		zbd_put_io_u(td, io_u);
>>  	}
>>
>>  	if (ret == FIO_Q_COMPLETED) {
>> diff --git a/options.c b/options.c
>> index 85a0f49..d54da81 100644
>> --- a/options.c
>> +++ b/options.c
>> @@ -3317,6 +3317,16 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
>>  		},
>>  	},
>>  	{
>> +		.name	= "zone_append",
>> +		.lname	= "zone_append",
>> +		.type	= FIO_OPT_BOOL,
>> +		.off1	= offsetof(struct thread_options, zone_append),
>> +		.help	= "Use Zone Append for Zone block device",
>> +		.def	= "0",
>> +		.category = FIO_OPT_C_IO,
>> +		.group	= FIO_OPT_G_ZONE,
>> +	},
>> +	{
>>  		.name	= "zonesize",
>>  		.lname	= "Zone size",
>>  		.type	= FIO_OPT_STR_VAL,
>> diff --git a/thread_options.h b/thread_options.h
>> index 968ea0a..45c5ef8 100644
>> --- a/thread_options.h
>> +++ b/thread_options.h
>> @@ -195,6 +195,7 @@ struct thread_options {
>>  	unsigned long long zone_size;
>>  	unsigned long long zone_skip;
>>  	enum fio_zone_mode zone_mode;
>> +	unsigned int zone_append;
>>  	unsigned long long lockmem;
>>  	enum fio_memtype mem_type;
>>  	unsigned int mem_align;
>> @@ -631,6 +632,7 @@ struct thread_options_pack {
>>  	uint32_t allow_mounted_write;
>>
>>  	uint32_t zone_mode;
>> +	uint32_t zone_append;
>>  } __attribute__((packed));
>>
>>  extern void convert_thread_options_to_cpu(struct thread_options *o, struct thread_options_pack *top);
>> diff --git a/zbd.c b/zbd.c
>> index 8cf8f81..ffdb766 100644
>> --- a/zbd.c
>> +++ b/zbd.c
>> @@ -455,6 +455,7 @@ static int parse_zone_info(struct thread_data *td, struct fio_file *f)
>>  		for (i = 0; i < nrz; i++, j++, z++, p++) {
>>  			mutex_init_pshared_with_type(&p->mutex,
>>  						     PTHREAD_MUTEX_RECURSIVE);
>> +			cond_init_pshared(&p->reset_cond);
>>  			p->start = z->start;
>>  			switch (z->cond) {
>>  			case ZBD_ZONE_COND_NOT_WP:
>> @@ -469,6 +470,7 @@ static int parse_zone_info(struct thread_data *td, struct fio_file *f)
>>  			}
>>  			p->type = z->type;
>>  			p->cond = z->cond;
>> +			p->pending_ios = 0;
>>  			if (j > 0 && p->start != p[-1].start + zone_size) {
>>  				log_info("%s: invalid zone data\n",
>>  					 f->file_name);
>> @@ -1196,20 +1198,24 @@ zbd_find_zone(struct thread_data *td, struct io_u *io_u,
>>
>>  /**
>>   * zbd_queue_io - update the write pointer of a sequential zone
>> + * @td: fio thread data.
>>   * @io_u: I/O unit
>>   * @success: Whether or not the I/O unit has been queued successfully
>>   * @q: queueing status (busy, completed or queued).
>>   *
>>   * For write and trim operations, update the write pointer of the I/O unit
>>   * target zone.
>> + * For zone append operation, release the zone mutex
>>   */
>> -static void zbd_queue_io(struct io_u *io_u, int q, bool success)
>> +static void zbd_queue_io(struct thread_data *td, struct io_u *io_u, int q,
>> +			 bool success)
>>  {
>>  	const struct fio_file *f = io_u->file;
>>  	struct zoned_block_device_info *zbd_info = f->zbd_info;
>>  	struct fio_zone_info *z;
>>  	uint32_t zone_idx;
>>  	uint64_t zone_end;
>> +	int ret;
>>
>>  	if (!zbd_info)
>>  		return;
>> @@ -1241,6 +1247,8 @@ static void zbd_queue_io(struct io_u *io_u, int q, bool success)
>>  			zbd_info->sectors_with_data += zone_end - z->wp;
>>  		pthread_mutex_unlock(&zbd_info->mutex);
>>  		z->wp = zone_end;
>> +		if (td->o.zone_append)
>> +			z->pending_ios++;
>>  		break;
>>  	case DDIR_TRIM:
>>  		assert(z->wp == z->start);
>> @@ -1250,18 +1258,22 @@ static void zbd_queue_io(struct io_u *io_u, int q, bool success)
>>  	}
>>
>>  unlock:
>> -	if (!success || q != FIO_Q_QUEUED) {
>> +	if (!success || q != FIO_Q_QUEUED || td->o.zone_append) {
>>  		/* BUSY or COMPLETED: unlock the zone */
>> -		pthread_mutex_unlock(&z->mutex);
>> -		io_u->zbd_put_io = NULL;
>> +		ret = pthread_mutex_unlock(&z->mutex);
>> +		assert(ret == 0);
>> +		if (!success || q != FIO_Q_QUEUED)
>> +			io_u->zbd_put_io = NULL;
>>  	}
>>  }
>>
>>  /**
>>   * zbd_put_io - Unlock an I/O unit target zone lock
>> + * For zone append operation we don't hold zone lock
>> + * @td: fio thread data.
>>   * @io_u: I/O unit
>>   */
>> -static void zbd_put_io(const struct io_u *io_u)
>> +static void zbd_put_io(struct thread_data *td, const struct io_u *io_u)
>>  {
>>  	const struct fio_file *f = io_u->file;
>>  	struct zoned_block_device_info *zbd_info = f->zbd_info;
>> @@ -1283,6 +1295,19 @@ static void zbd_put_io(const struct io_u *io_u)
>>  	       "%s: terminate I/O (%lld, %llu) for zone %u\n",
>>  	       f->file_name, io_u->offset, io_u->buflen, zone_idx);
>>
>> +	if (td->o.zone_append) {
>> +		pthread_mutex_lock(&z->mutex);
>> +		if (z->pending_ios > 0) {
>> +			z->pending_ios--;
>> +			/*
>> +			 * Other threads may be waiting for pending I/O's to
>> +			 * complete for this zone. Notify them.
>> +			 */
>> +			if (!z->pending_ios)
>> +				pthread_cond_broadcast(&z->reset_cond);
>> +		}
>> +	}
>> +
>>  	ret = pthread_mutex_unlock(&z->mutex);
>>  	assert(ret == 0);
>>  	zbd_check_swd(f);
>> @@ -1524,16 +1549,69 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
>>  			 * asynchronously and since we will submit the zone
>>  			 * reset synchronously, wait until previously submitted
>>  			 * write requests have completed before issuing a
>> -			 * zone reset.
>> +			 * zone reset. For append request release the zone lock
>> +			 * as other threads will acquire it at the time of
>> +			 * zbd_put_io.
>>  			 */
>> +reset:
>> +			if (td->o.zone_append)
>> +				pthread_mutex_unlock(&zb->mutex);
>>  			io_u_quiesce(td);
>> +			if (td->o.zone_append)
>> +				pthread_mutex_lock(&zb->mutex);
>> +
>>  			zb->reset_zone = 0;
>> +			if (td->o.zone_append) {
>> +				/*
>> +				 * While processing the current thread queued
>> +				 * requests the other thread may have already
>> +				 * done zone reset so need to check zone full
>> +				 * condition again.
>> +				 */
>> +				if (!zbd_zone_full(f, zb, min_bs))
>> +					goto proceed;
>> +				/*
>> +				 * Wait for the pending requests to be completed
>> +				 * else we are ok to reset this zone.
>> +				 */
>> +				if (zb->pending_ios) {
>> +					pthread_cond_wait(&zb->reset_cond, &zb->mutex);
>> +					goto proceed;
>> +				}
>> +			}
>> +
>>  			if (zbd_reset_zone(td, f, zb) < 0)
>>  				goto eof;
>> +
>> +			/* Notify other threads waiting for zone mutex */
>> +			if (td->o.zone_append)
>> +				pthread_cond_broadcast(&zb->reset_cond);
>> +		}
>> +proceed:
>> +		/*
>> +		 * Check for zone full condition again. For zone append request
>> +		 * the zone may already be reset, written and full while we
>> +		 * were waiting for our turn.
>> +		 */
>> +		if (zbd_zone_full(f, zb, min_bs)) {
>> +			goto reset;
>>  		}
>> +
>>  		/* Make writes occur at the write pointer */
>>  		assert(!zbd_zone_full(f, zb, min_bs));
>>  		io_u->offset = zb->wp;
>> +
>> +		/*
>> +		 * Support zone append for both regular and zoned block
>> +		 * device.
>> +		 */
>> +		if (td->o.zone_append) {
>> +			if (f->zbd_info->model == ZBD_NONE)
>> +				io_u->zone_start_offset = zb->wp;
>> +			else
>> +				io_u->zone_start_offset = zb->start;
>> +		}
>> +
>>  		if (!is_valid_offset(f, io_u->offset)) {
>>  			dprint(FD_ZBD, "Dropped request with offset %llu\n",
>>  			       io_u->offset);
>> diff --git a/zbd.h b/zbd.h
>> index e942a7f..eac42f7 100644
>> --- a/zbd.h
>> +++ b/zbd.h
>> @@ -23,8 +23,10 @@ enum io_u_action {
>>   * struct fio_zone_info - information about a single ZBD zone
>>   * @start: zone start location (bytes)
>>   * @wp: zone write pointer location (bytes)
>> + * @pending_ios: Number of IO's pending in this zone
>>   * @verify_block: number of blocks that have been verified for this zone
>>   * @mutex: protects the modifiable members in this structure
>> + * @reset_cond: zone reset check condition. only relevant for zone_append.
>>   * @type: zone type (BLK_ZONE_TYPE_*)
>>   * @cond: zone state (BLK_ZONE_COND_*)
>>   * @open: whether or not this zone is currently open. Only relevant if
>> @@ -33,8 +35,10 @@ enum io_u_action {
>>   */
>>  struct fio_zone_info {
>>  	pthread_mutex_t		mutex;
>> +	pthread_cond_t		reset_cond;
>>  	uint64_t		start;
>>  	uint64_t		wp;
>> +	uint32_t		pending_ios;
>>  	uint32_t		verify_block;
>>  	enum zbd_zone_type	type:2;
>>  	enum zbd_zone_cond	cond:4;
>> @@ -96,18 +100,19 @@ static inline void zbd_close_file(struct fio_file *f)
>>  		zbd_free_zone_info(f);
>>  }
>>
>> -static inline void zbd_queue_io_u(struct io_u *io_u, enum fio_q_status status)
>> +static inline void zbd_queue_io_u(struct thread_data *td, struct io_u *io_u,
>> +				  enum fio_q_status status)
>>  {
>>  	if (io_u->zbd_queue_io) {
>> -		io_u->zbd_queue_io(io_u, status, io_u->error == 0);
>> +		io_u->zbd_queue_io(td, io_u, status, io_u->error == 0);
>>  		io_u->zbd_queue_io = NULL;
>>  	}
>>  }
>>
>> -static inline void zbd_put_io_u(struct io_u *io_u)
>> +static inline void zbd_put_io_u(struct thread_data *td, struct io_u *io_u)
>>  {
>>  	if (io_u->zbd_put_io) {
>> -		io_u->zbd_put_io(io_u);
>> +		io_u->zbd_put_io(td, io_u);
>>  		io_u->zbd_queue_io = NULL;
>>  		io_u->zbd_put_io = NULL;
>>  	}
>>
>
>Another thing: IO engines such as libzbc will not support any of this, nor will
>engines such as psync or SG and many many other. SO it may be good to define a
>new io engine flag such as FIO_ZONE_APPEND that can be set in struct
>ioengine_ops flags field in the engine declaration to indicate that the engine
>supports zone append. That can be checked on initialization instead of no check
>at all and seeing lots of weird things happening with engines that do not
>support zone append.
>
We can add a new IO engine flag to indicate that the engine supports
Zone Append.
As part of this initial version, we plan to introduce Zone Append as an
extension of Write. This will remove all the zbd.c and zbd.h related
code changes (pending_ios, reset_cond).
I wonder, since we don't have any zbd related code changes and the
zone_start_offset being removed, for the other IO engines, even if we
enable zone_append, it will still do a regular write. So, do we still
need this new IO engine flag ?
>
>-- 
>Damien Le Moal
>Western Digital Research
>

------nai8lIH9ngBNHun9R6qswQcIIemhXBCkNXu5CagZqSM5j8ea=_c89d4_
Content-Type: text/plain; charset="utf-8"


------nai8lIH9ngBNHun9R6qswQcIIemhXBCkNXu5CagZqSM5j8ea=_c89d4_--

