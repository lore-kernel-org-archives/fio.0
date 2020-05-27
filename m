Return-Path: <prvs=4091ec2cb=Damien.LeMoal@wdc.com>
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH] zbd: Fix max_open_zones checks
Date: Wed, 27 May 2020 03:50:06 +0000
Message-ID: 
 <CY4PR04MB3751A9C8F6D26E8E6D9794DFE7B10@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <20200527012013.87661-1-shinichiro.kawasaki@wdc.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
List-ID: <fio@vger.kernel.org>

On 2020/05/27 10:20, Shin'ichiro Kawasaki wrote:=0A=
> Commit 219c662d3b12 ("zbd: introduce per job maximum open zones limit")=
=0A=
> introduced job_max_open_zones option which limits the number of open=0A=
> zones per job. It has similar role as max_open_zones option which limits=
=0A=
> the number of open zones for all jobs. It was intended that these two=0A=
> options both work, but the commit replaced some checks for max_open_zones=
=0A=
> simply with checks for job_max_open_zones. Because of this, when=0A=
> max_open_zones is set and job_max_open_zones is not set, fio fails to=0A=
> limit the number of open zones. This resulted in test case #29 failure=0A=
> of t/zbd/test-zbd-support script for regular null_blk devices.=0A=
> =0A=
> To fix the failure, modify the checks to target both job_max_open_zones=
=0A=
> and max_open_zones.=0A=
> =0A=
> Fixes: 219c662d3b12 ("zbd: introduce per job maximum open zones limit")=
=0A=
> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>=0A=
> ---=0A=
>  zbd.c | 6 +++---=0A=
>  1 file changed, 3 insertions(+), 3 deletions(-)=0A=
> =0A=
> diff --git a/zbd.c b/zbd.c=0A=
> index 72352db0..2a725c1f 100644=0A=
> --- a/zbd.c=0A=
> +++ b/zbd.c=0A=
> @@ -997,7 +997,7 @@ static struct fio_zone_info *zbd_convert_to_open_zone=
(struct thread_data *td,=0A=
>  =0A=
>  	assert(is_valid_offset(f, io_u->offset));=0A=
>  =0A=
> -	if (td->o.job_max_open_zones) {=0A=
> +	if (td->o.max_open_zones || td->o.job_max_open_zones) {=0A=
>  		/*=0A=
>  		 * This statement accesses f->zbd_info->open_zones[] on purpose=0A=
>  		 * without locking.=0A=
> @@ -1026,7 +1026,7 @@ static struct fio_zone_info *zbd_convert_to_open_zo=
ne(struct thread_data *td,=0A=
>  =0A=
>  		zone_lock(td, f, z);=0A=
>  		pthread_mutex_lock(&f->zbd_info->mutex);=0A=
> -		if (td->o.job_max_open_zones =3D=3D 0)=0A=
> +		if (td->o.max_open_zones =3D=3D 0 && td->o.job_max_open_zones =3D=3D 0=
)=0A=
>  			goto examine_zone;=0A=
>  		if (f->zbd_info->num_open_zones =3D=3D 0) {=0A=
>  			pthread_mutex_unlock(&f->zbd_info->mutex);=0A=
> @@ -1082,7 +1082,7 @@ examine_zone:=0A=
>  	}=0A=
>  	dprint(FD_ZBD, "%s(%s): closing zone %d\n", __func__, f->file_name,=0A=
>  	       zone_idx);=0A=
> -	if (td->o.job_max_open_zones)=0A=
> +	if (td->o.max_open_zones || td->o.job_max_open_zones)=0A=
>  		zbd_close_zone(td, f, open_zone_idx);=0A=
>  	pthread_mutex_unlock(&f->zbd_info->mutex);=0A=
>  =0A=
> =0A=
=0A=
Looks good.=0A=
=0A=
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=

