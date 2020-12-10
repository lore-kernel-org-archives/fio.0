Return-Path: <krish.reddy@samsung.com>
Date: Thu, 10 Dec 2020 19:44:06 +0530
From: Krishna Kanth Reddy <krish.reddy@samsung.com>
Subject: Re: [PATCH 8/9] Support copy operation for zoned block devices.
Message-ID: <20201210141406.GA7356@test-zns>
MIME-Version: 1.0
In-Reply-To: <CH2PR04MB652259B2F0ACC87F5491111CE7F40@CH2PR04MB6522.namprd04.prod.outlook.com>
Content-Type: multipart/mixed;
	boundary="----tGND2j7cu8UREVbnBg8E5yJEtkW7v82-PRAT7H2EQYurTGQt=_7d8a9_"
References: <20201201114034.8307-1-krish.reddy@samsung.com>
	<CGME20201201114110epcas5p34032161c14f467576734346712d0c3db@epcas5p3.samsung.com>
	<20201201114034.8307-9-krish.reddy@samsung.com>
	<CH2PR04MB652259B2F0ACC87F5491111CE7F40@CH2PR04MB6522.namprd04.prod.outlook.com>
To: Damien Le Moal <Damien.LeMoal@wdc.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>, Ankit Kumar <ankit.kumar@samsung.com>
List-ID: <fio@vger.kernel.org>

------tGND2j7cu8UREVbnBg8E5yJEtkW7v82-PRAT7H2EQYurTGQt=_7d8a9_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On Tue, Dec 01, 2020 at 12:11:48PM +0000, Damien Le Moal wrote:
>On 2020/12/01 20:44, Krishna Kanth Reddy wrote:
>> From: Ankit Kumar <ankit.kumar@samsung.com>
>>
>> Added a check so that source and destination zones don't overlap.
>> Source and destination offsets are aligned to zone start.
>> The source range zone data is copied sequentially to the destination
>> zones.
>> Added a function to reset the destination zones. Source zones won't
>> be reset.
>
>I do not see how this can work correctly without relying on the zone locking
>mechanism. Other jobs may be writing to the same zones too. That will either
>result in the copy failing or the writes failing due to the zone wp unexpectedly
>changing.
>
Sorry for the delay response, as I was hoping for comments for the other patches in this patchset too.

Yes, you are right. There are no locks in the current implementation.
Our initial focus is to introduce a new copy workload and get the infrastructure ready for FIO.

We will modify the existing patch to add the zone locking mechanism, so that it can be used in multi-threaded scenario.
Kindly provide your valuable feedback to the other patches in this patchset too.

>>
>> Signed-off-by: Krishna Kanth Reddy <krish.reddy@samsung.com>
>> ---
>>  file.h      |  4 +++
>>  filesetup.c | 18 +++++++++++
>>  init.c      |  5 +++
>>  io_u.c      |  2 +-
>>  zbd.c       | 88 ++++++++++++++++++++++++++++++++++++++++++++++++-----
>>  5 files changed, 109 insertions(+), 8 deletions(-)
>>
>> diff --git a/file.h b/file.h
>> index f5a794e4..23012753 100644
>> --- a/file.h
>> +++ b/file.h
>> @@ -110,6 +110,10 @@ struct fio_file {
>>  	uint32_t min_zone;	/* inclusive */
>>  	uint32_t max_zone;	/* exclusive */
>>
>> +	/* zonemode=zbd copy destination working area */
>> +	uint32_t min_dest_zone;	/* inclusive */
>> +	uint32_t max_dest_zone;	/* exclusive */
>> +
>>  	/*
>>  	 * Track last end and last start of IO for a given data direction
>>  	 */
>> diff --git a/filesetup.c b/filesetup.c
>> index 68a21fac..54752511 100644
>> --- a/filesetup.c
>> +++ b/filesetup.c
>> @@ -1231,6 +1231,24 @@ int setup_files(struct thread_data *td)
>>
>>  		if (td_copy(td))
>>  			f->file_dest_offset = get_dest_offset(td, f);
>> +
>> +		if (td_copy(td) && (td->o.zone_mode == ZONE_MODE_ZBD)) {
>> +			if (f->file_offset > f->file_dest_offset) {
>> +				if (f->file_offset - f->file_dest_offset < f->io_size) {
>> +					log_err("%s: For copy operation on ZBD device "
>> +						 "source and destination area shouldn't overlap\n",
>> +						 o->name);
>> +					goto err_out;
>> +				}
>> +			} else {
>> +				if (f->file_dest_offset - f->file_offset < f->io_size) {
>> +					log_err("%s: For copy operation on ZBD device "
>> +						 "source and destination area shouldn't overlap\n",
>> +						 o->name);
>> +					goto err_out;
>> +				}
>> +			}
>> +		}
>>  	}
>>
>>  	if (td->o.block_error_hist) {
>> diff --git a/init.c b/init.c
>> index e5835b7b..b5db65af 100644
>> --- a/init.c
>> +++ b/init.c
>> @@ -671,6 +671,11 @@ static int fixup_options(struct thread_data *td)
>>  	if (o->zone_mode == ZONE_MODE_STRIDED && !o->zone_range)
>>  		o->zone_range = o->zone_size;
>>
>> +	if (o->zone_mode == ZONE_MODE_ZBD && td_copy(td) && td_random(td)) {
>> +		log_err("fio: --zonemode=zbd supports copy operation only in sequential mode.\n");
>> +		ret |= 1;
>> +	}
>> +
>>  	/*
>>  	 * Reads and copies can do overwrites, we always need to pre-create the file
>>  	 */
>> diff --git a/io_u.c b/io_u.c
>> index 83c7960a..2de91f2a 100644
>> --- a/io_u.c
>> +++ b/io_u.c
>> @@ -1003,7 +1003,7 @@ static int fill_io_u(struct thread_data *td, struct io_u *io_u)
>>  		offset = io_u->offset;
>>  	}
>>
>> -	if (td->o.zone_mode == ZONE_MODE_ZBD) {
>> +	if ((td->o.zone_mode == ZONE_MODE_ZBD) && !(td_copy(td))) {
>>  		ret = zbd_adjust_block(td, io_u);
>>  		if (ret == io_u_eof)
>>  			return 1;
>> diff --git a/zbd.c b/zbd.c
>> index 58fed98e..8201665b 100644
>> --- a/zbd.c
>> +++ b/zbd.c
>> @@ -246,11 +246,11 @@ static bool zbd_is_seq_job(struct fio_file *f)
>>   */
>>  static bool zbd_verify_sizes(void)
>>  {
>> -	const struct fio_zone_info *z;
>> +	const struct fio_zone_info *z, *zd;
>>  	struct thread_data *td;
>>  	struct fio_file *f;
>>  	uint64_t new_offset, new_end;
>> -	uint32_t zone_idx;
>> +	uint32_t zone_idx, zone_didx;
>>  	int i, j;
>>
>>  	for_each_td(td, i) {
>> @@ -259,6 +259,9 @@ static bool zbd_verify_sizes(void)
>>  				continue;
>>  			if (f->file_offset >= f->real_file_size)
>>  				continue;
>> +			if ((td->o.td_ddir == TD_DDIR_COPY) &&
>> +			    (f->file_dest_offset >= f->real_file_size))
>> +				continue;
>>  			if (!zbd_is_seq_job(f))
>>  				continue;
>>
>> @@ -301,6 +304,15 @@ static bool zbd_verify_sizes(void)
>>  				f->io_size -= (new_offset - f->file_offset);
>>  				f->file_offset = new_offset;
>>  			}
>> +			if (td->o.td_ddir == TD_DDIR_COPY) {
>> +				zone_didx = zbd_zone_idx(f, f->file_dest_offset);
>> +				zd = &f->zbd_info->zone_info[zone_didx];
>> +				if (f->file_dest_offset != zd->start) {
>> +					new_offset = zbd_zone_end(zd);
>> +					f->file_dest_offset = new_offset;
>> +				}
>> +			}
>> +
>>  			zone_idx = zbd_zone_idx(f, f->file_offset + f->io_size);
>>  			z = &f->zbd_info->zone_info[zone_idx];
>>  			new_end = z->start;
>> @@ -320,6 +332,12 @@ static bool zbd_verify_sizes(void)
>>  			f->min_zone = zbd_zone_idx(f, f->file_offset);
>>  			f->max_zone = zbd_zone_idx(f, f->file_offset + f->io_size);
>>  			assert(f->min_zone < f->max_zone);
>> +
>> +			if (td->o.td_ddir == TD_DDIR_COPY) {
>> +				f->min_dest_zone = zbd_zone_idx(f, f->file_dest_offset);
>> +				f->max_dest_zone = zbd_zone_idx(f, f->file_dest_offset + f->io_size);
>> +				assert(f->min_dest_zone < f->max_dest_zone);
>> +			}
>>  		}
>>  	}
>>
>> @@ -823,6 +841,42 @@ static int zbd_reset_zones(struct thread_data *td, struct fio_file *f,
>>  	return res;
>>  }
>>
>> +/*
>> + * Reset a range of zones.
>> + * @td: fio thread data.
>> + * @f: fio file for which to reset zones
>> + */
>> +static void zbd_reset_dest_zones(struct thread_data *td, struct fio_file *f)
>> +{
>> +	struct fio_zone_info *z, *zb, *ze;
>> +	int ret = 0;
>> +	uint64_t offset, length;
>> +
>> +	zb = &f->zbd_info->zone_info[f->min_dest_zone];
>> +	ze = &f->zbd_info->zone_info[f->max_dest_zone];
>> +
>> +	for (z = zb; z < ze; z++) {
>> +		offset = z->start;
>> +		length = (z+1)->start - offset;
>> +
>> +		dprint(FD_ZBD, "%s: resetting wp of zone %u.\n", f->file_name,
>> +		       zbd_zone_nr(f->zbd_info, z));
>> +		switch (f->zbd_info->model) {
>> +		case ZBD_HOST_AWARE:
>> +		case ZBD_HOST_MANAGED:
>> +			ret = zbd_reset_wp(td, f, offset, length);
>> +			break;
>> +		default:
>> +			break;
>> +		}
>> +
>> +		if (ret < 0)
>> +			continue;
>> +
>> +		td->ts.nr_zone_resets++;
>> +	}
>> +}
>> +
>>  /*
>>   * Reset zbd_info.write_cnt, the counter that counts down towards the next
>>   * zone reset.
>> @@ -924,9 +978,14 @@ void zbd_file_reset(struct thread_data *td, struct fio_file *f)
>>  {
>>  	struct fio_zone_info *zb, *ze;
>>
>> -	if (!f->zbd_info || !td_write(td))
>> +	if (!f->zbd_info || !(td_write(td) || td_copy(td)))
>>  		return;
>>
>> +	if (td_copy(td)) {
>> +		zbd_reset_dest_zones(td, f);
>> +		return;
>> +	}
>> +
>>  	zb = &f->zbd_info->zone_info[f->min_zone];
>>  	ze = &f->zbd_info->zone_info[f->max_zone];
>>  	zbd_init_swd(f);
>> @@ -1410,8 +1469,8 @@ void setup_zbd_zone_mode(struct thread_data *td, struct io_u *io_u)
>>  {
>>  	struct fio_file *f = io_u->file;
>>  	enum fio_ddir ddir = io_u->ddir;
>> -	struct fio_zone_info *z;
>> -	uint32_t zone_idx;
>> +	struct fio_zone_info *z, *zd;
>> +	uint32_t zone_idx, zone_didx;
>>
>>  	assert(td->o.zone_mode == ZONE_MODE_ZBD);
>>  	assert(td->o.zone_size);
>> @@ -1419,13 +1478,18 @@ void setup_zbd_zone_mode(struct thread_data *td, struct io_u *io_u)
>>  	zone_idx = zbd_zone_idx(f, f->last_pos[ddir]);
>>  	z = &f->zbd_info->zone_info[zone_idx];
>>
>> +	if (ddir == DDIR_COPY) {
>> +		zone_didx = zbd_zone_idx(f, f->last_pos_dest[ddir]);
>> +		zd = &f->zbd_info->zone_info[zone_didx];
>> +	}
>> +
>>  	/*
>>  	 * When the zone capacity is smaller than the zone size and the I/O is
>> -	 * sequential write, skip to zone end if the latest position is at the
>> +	 * sequential write or copy, skip to zone end if the latest position is at the
>>  	 * zone capacity limit.
>>  	 */
>>  	if (z->capacity < f->zbd_info->zone_size && !td_random(td) &&
>> -	    ddir == DDIR_WRITE &&
>> +	    (ddir == DDIR_WRITE || ddir == DDIR_COPY) &&
>>  	    f->last_pos[ddir] >= zbd_zone_capacity_end(z)) {
>>  		dprint(FD_ZBD,
>>  		       "%s: Jump from zone capacity limit to zone end:"
>> @@ -1436,6 +1500,8 @@ void setup_zbd_zone_mode(struct thread_data *td, struct io_u *io_u)
>>  		       (unsigned long long) z->capacity);
>>  		td->io_skip_bytes += zbd_zone_end(z) - f->last_pos[ddir];
>>  		f->last_pos[ddir] = zbd_zone_end(z);
>> +		if (ddir == DDIR_COPY)
>> +			f->last_pos_dest[ddir] = zbd_zone_end(zd);
>>  	}
>>
>>  	/*
>> @@ -1461,13 +1527,21 @@ void setup_zbd_zone_mode(struct thread_data *td, struct io_u *io_u)
>>  		td->zone_bytes = 0;
>>  		f->file_offset += td->o.zone_size + td->o.zone_skip;
>>
>> +		if (ddir == DDIR_COPY)
>> +			f->file_dest_offset += td->o.zone_size + td->o.zone_skip;
>>  		/*
>>  		 * Wrap from the beginning, if we exceed the file size
>>  		 */
>>  		if (f->file_offset >= f->real_file_size)
>>  			f->file_offset = get_start_offset(td, f);
>>
>> +		if ((ddir == DDIR_COPY) && f->file_dest_offset >= f->real_file_size)
>> +			f->file_dest_offset = get_dest_offset(td, f);
>> +
>>  		f->last_pos[ddir] = f->file_offset;
>> +		if (ddir == DDIR_COPY)
>> +			f->last_pos_dest[io_u->ddir] = f->file_dest_offset;
>> +
>>  		td->io_skip_bytes += td->o.zone_skip;
>>  	}
>>  }
>>
>
>
>-- 
>Damien Le Moal
>Western Digital Research
>

------tGND2j7cu8UREVbnBg8E5yJEtkW7v82-PRAT7H2EQYurTGQt=_7d8a9_
Content-Type: text/plain; charset="utf-8"


------tGND2j7cu8UREVbnBg8E5yJEtkW7v82-PRAT7H2EQYurTGQt=_7d8a9_--

