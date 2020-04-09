Return-Path: <prvs=361d12291=Damien.LeMoal@wdc.com>
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH] zbd: fix sequential verify with max_open_zones=1
Date: Thu, 9 Apr 2020 01:58:13 +0000
Message-ID: 
 <BY5PR04MB6900B4F8DFDDBB498EDA8768E7C10@BY5PR04MB6900.namprd04.prod.outlook.com>
References: <20200408221652.GA2592@avx2>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 2020/04/09 7:16, Alexey Dobriyan wrote:=0A=
> Sequential write with max_open_zones=3D1 has interesting (read: buggy)=0A=
> interaction with verify=3D.=0A=
> =0A=
> If verify is off, then job runs correctly and IO is sequential,=0A=
> and restarted from offset 0 and remains sequential.=0A=
> =0A=
> If verify is on, then 1 full run is done and verified correctly.=0A=
> At this point there is exactly 1 open zone which is the last zone.=0A=
> =0A=
> Now IO restarts from offset 0 and pick_random_zone() picks opened zone=0A=
> #0 which is the last zone because offset is 0. All IO is redirected=0A=
> to the last zone, which is rewritten once triggering verify again.=0A=
> =0A=
> IO pattern becomes: 1 full sequential rewrite followed by constant=0A=
> sequential rewrites of the last zone.=0A=
> =0A=
> =0A=
> 	[global]=0A=
> 	filename=3D/dev/loop0=0A=
> 	direct=3D1=0A=
> 	zonemode=3Dzbd=0A=
> 	zonesize=3D1M=0A=
> 	bs=3D512K=0A=
> 	rw=3Dwrite=0A=
> 	verify=3Dxxhash=0A=
> 	[j]=0A=
> 	max_open_zones=3D1=0A=
> 	io_size=3D3G=0A=
> =0A=
> Fix is to close everything knowing that "full reset" comes from verify.=
=0A=
> =0A=
> max_open_zones=3D2 restarts from half of the device, etc.=0A=
> =0A=
> Signed-off-by: Alexey Dobriyan (SK hynix) <adobriyan@gmail.com>=0A=
> ---=0A=
> =0A=
>  zbd.c |   53 ++++++++++++++++++++++++++++++++++-------------------=0A=
>  1 file changed, 34 insertions(+), 19 deletions(-)=0A=
> =0A=
> --- a/zbd.c=0A=
> +++ b/zbd.c=0A=
> @@ -710,6 +710,22 @@ static int zbd_reset_zone(struct thread_data *td, st=
ruct fio_file *f,=0A=
>  	return zbd_reset_range(td, f, z->start, (z+1)->start - z->start);=0A=
>  }=0A=
>  =0A=
> +/* The caller must hold f->zbd_info->mutex */=0A=
> +static void zbd_close_zone(struct thread_data *td, const struct fio_file=
 *f,=0A=
> +			   unsigned int open_zone_idx)=0A=
> +{=0A=
> +	uint32_t zone_idx;=0A=
> +=0A=
> +	assert(open_zone_idx < f->zbd_info->num_open_zones);=0A=
> +	zone_idx =3D f->zbd_info->open_zones[open_zone_idx];=0A=
> +	memmove(f->zbd_info->open_zones + open_zone_idx,=0A=
> +		f->zbd_info->open_zones + open_zone_idx + 1,=0A=
> +		(ZBD_MAX_OPEN_ZONES - (open_zone_idx + 1)) *=0A=
> +		sizeof(f->zbd_info->open_zones[0]));=0A=
> +	f->zbd_info->num_open_zones--;=0A=
> +	f->zbd_info->zone_info[zone_idx].open =3D 0;=0A=
> +}=0A=
> +=0A=
>  /*=0A=
>   * Reset a range of zones. Returns 0 upon success and 1 upon failure.=0A=
>   * @td: fio thread data.=0A=
> @@ -733,12 +749,27 @@ static int zbd_reset_zones(struct thread_data *td, =
struct fio_file *f,=0A=
>  	dprint(FD_ZBD, "%s: examining zones %u .. %u\n", f->file_name,=0A=
>  		zbd_zone_nr(f->zbd_info, zb), zbd_zone_nr(f->zbd_info, ze));=0A=
>  	for (z =3D zb; z < ze; z++) {=0A=
> +		uint32_t nz =3D z - f->zbd_info->zone_info;=0A=
> +=0A=
>  		if (!zbd_zone_swr(z))=0A=
>  			continue;=0A=
>  		zone_lock(td, z);=0A=
> -		reset_wp =3D all_zones ? z->wp !=3D z->start :=0A=
> -				(td->o.td_ddir & TD_DDIR_WRITE) &&=0A=
> -				z->wp % min_bs !=3D 0;=0A=
> +		if (all_zones) {=0A=
> +			unsigned int i;=0A=
> +=0A=
> +			pthread_mutex_lock(&f->zbd_info->mutex);=0A=
> +			for (i =3D 0; i < f->zbd_info->num_open_zones; i++) {=0A=
> +				if (f->zbd_info->open_zones[i] =3D=3D nz) {=0A=
> +					zbd_close_zone(td, f, i);=0A=
> +				}=0A=
=0A=
nit: you do not need the {} brackets for the if here.=0A=
=0A=
> +			}=0A=
> +			pthread_mutex_unlock(&f->zbd_info->mutex);=0A=
> +=0A=
> +			reset_wp =3D z->wp !=3D z->start;=0A=
> +		} else {=0A=
> +			reset_wp =3D (td->o.td_ddir & TD_DDIR_WRITE) &&=0A=
> +					z->wp % min_bs !=3D 0;=0A=
> +		}=0A=
>  		if (reset_wp) {=0A=
>  			dprint(FD_ZBD, "%s: resetting zone %u\n",=0A=
>  			       f->file_name,=0A=
> @@ -928,22 +959,6 @@ out:=0A=
>  	return res;=0A=
>  }=0A=
>  =0A=
> -/* The caller must hold f->zbd_info->mutex */=0A=
> -static void zbd_close_zone(struct thread_data *td, const struct fio_file=
 *f,=0A=
> -			   unsigned int open_zone_idx)=0A=
> -{=0A=
> -	uint32_t zone_idx;=0A=
> -=0A=
> -	assert(open_zone_idx < f->zbd_info->num_open_zones);=0A=
> -	zone_idx =3D f->zbd_info->open_zones[open_zone_idx];=0A=
> -	memmove(f->zbd_info->open_zones + open_zone_idx,=0A=
> -		f->zbd_info->open_zones + open_zone_idx + 1,=0A=
> -		(ZBD_MAX_OPEN_ZONES - (open_zone_idx + 1)) *=0A=
> -		sizeof(f->zbd_info->open_zones[0]));=0A=
> -	f->zbd_info->num_open_zones--;=0A=
> -	f->zbd_info->zone_info[zone_idx].open =3D 0;=0A=
> -}=0A=
> -=0A=
>  /* Anything goes as long as it is not a constant. */=0A=
>  static uint32_t pick_random_zone_idx(const struct fio_file *f,=0A=
>  				     const struct io_u *io_u)=0A=
> =0A=
=0A=
With the nits above fixed, this looks OK to me.=0A=
=0A=
It would be good to add a test case for this to t/zbd/test-zbd-support. Can=
 you=0A=
send something please ?=0A=
=0A=
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=

