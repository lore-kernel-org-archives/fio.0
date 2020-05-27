Return-Path: <adobriyan@gmail.com>
Return-Path: <adobriyan@gmail.com>
Date: Wed, 27 May 2020 11:34:20 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH] zbd: Fix max_open_zones checks
Message-ID: <20200527083420.GA3077@localhost.localdomain>
References: <20200527012013.87661-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200527012013.87661-1-shinichiro.kawasaki@wdc.com>
To: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Damien Le Moal <Damien.LeMoal@wdc.com>
List-ID: <fio@vger.kernel.org>

On Wed, May 27, 2020 at 10:20:13AM +0900, Shin'ichiro Kawasaki wrote:
> Commit 219c662d3b12 ("zbd: introduce per job maximum open zones limit")
> introduced job_max_open_zones option which limits the number of open
> zones per job. It has similar role as max_open_zones option which limits
> the number of open zones for all jobs. It was intended that these two
> options both work, but the commit replaced some checks for max_open_zones
> simply with checks for job_max_open_zones. Because of this, when
> max_open_zones is set and job_max_open_zones is not set, fio fails to
> limit the number of open zones. This resulted in test case #29 failure
> of t/zbd/test-zbd-support script for regular null_blk devices.

Isn't this test broken for the rationale behind "job_max_open_zones="?

 opts+=("--zonemode=zbd"...
 opts+=("--ioengine=psync" "--rw=randwrite" "--direct=1")
 opts+=("--max_open_zones=4" "--group_reporting=1")
 check_written $((jobs * zone_size)) || return $?

Strict equality check but one thread can open all 4 zones and make
others quit.

> To fix the failure, modify the checks to target both job_max_open_zones
> and max_open_zones.

> --- a/zbd.c
> +++ b/zbd.c
> @@ -997,7 +997,7 @@ static struct fio_zone_info *zbd_convert_to_open_zone(struct thread_data *td,
>  
>  	assert(is_valid_offset(f, io_u->offset));
>  
> -	if (td->o.job_max_open_zones) {
> +	if (td->o.max_open_zones || td->o.job_max_open_zones) {
>  		/*
>  		 * This statement accesses f->zbd_info->open_zones[] on purpose
>  		 * without locking.
> @@ -1026,7 +1026,7 @@ static struct fio_zone_info *zbd_convert_to_open_zone(struct thread_data *td,
>  
>  		zone_lock(td, f, z);
>  		pthread_mutex_lock(&f->zbd_info->mutex);
> -		if (td->o.job_max_open_zones == 0)
> +		if (td->o.max_open_zones == 0 && td->o.job_max_open_zones == 0)
>  			goto examine_zone;
>  		if (f->zbd_info->num_open_zones == 0) {
>  			pthread_mutex_unlock(&f->zbd_info->mutex);
> @@ -1082,7 +1082,7 @@ examine_zone:
>  	}
>  	dprint(FD_ZBD, "%s(%s): closing zone %d\n", __func__, f->file_name,
>  	       zone_idx);
> -	if (td->o.job_max_open_zones)
> +	if (td->o.max_open_zones || td->o.job_max_open_zones)
>  		zbd_close_zone(td, f, open_zone_idx);
>  	pthread_mutex_unlock(&f->zbd_info->mutex);
>  

