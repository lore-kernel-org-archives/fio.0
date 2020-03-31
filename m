Return-Path: <prvs=352e60adf=Damien.LeMoal@wdc.com>
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH v2] fio: fix interaction between offset/size limited
 threads and "max_open_zones"
Date: Tue, 31 Mar 2020 08:07:32 +0000
Message-ID: 
 <CO2PR04MB23436F306B2F4AD63E7423F8E7C80@CO2PR04MB2343.namprd04.prod.outlook.com>
References: <20200320180623.GA19960@avx2>
 <CO2PR04MB234395285948F0249B2485F0E7F10@CO2PR04MB2343.namprd04.prod.outlook.com>
 <20200325175248.GA18527@avx2>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 2020/03/26 2:52, Alexey Dobriyan wrote:=0A=
> If thread bumps into "max_open_zones" limit, it tries to close/reopen som=
e=0A=
> other zone before issuing IO. This scan is done over full list of block d=
evice's=0A=
> opened zones. It means that a zone which doesn't belong to thread's worki=
ng=0A=
> area can be altered or IO can be retargeted at such zone.=0A=
> =0A=
> If IO is retargeted, then it will be dropped by "is_valid_offset()" check=
.=0A=
> =0A=
> What happens with null block device testing is that one thread monopolise=
s=0A=
> IO and others thread do basically nothing.=0A=
> =0A=
> This config will reliably succeed now:=0A=
> =0A=
> 	[global]=0A=
> 	zonemode=3Dzbd=0A=
> 	zonesize=3D1M=0A=
> 	rw=3Drandwrite=0A=
> 		...=0A=
> 	thread=0A=
> 	numjobs=3D2=0A=
> 	offset_increment=3D128M=0A=
> =0A=
> 	[j]=0A=
> 	max_open_zones=3D2=0A=
> 	size=3D2M=0A=
> =0A=
> Starting 2 threads=0A=
> zbd      7991  /dev/nullb0: zbd model string: host-managed=0A=
> zbd      7991  Device /dev/nullb0 has 1024 zones of size 1024 KB=0A=
> zbd      8009  /dev/nullb0: examining zones 0 .. 2=0A=
> zbd      8010  /dev/nullb0: examining zones 128 .. 130=0A=
> zbd      8009  /dev/nullb0: opening zone 0=0A=
> zbd      8010  /dev/nullb0: opening zone 128=0A=
> zbd      8009  /dev/nullb0: queued I/O (0, 4096) for zone 0=0A=
> zbd      8009  zbd_convert_to_open_zone(/dev/nullb0): starting from zone =
128 (offset 1552384, buflen 4096)=0A=
> =0A=
> 	retargeted for other thread's zone	(zone 0 =3D> zone 128)=0A=
> =0A=
> zbd      8010  /dev/nullb0: queued I/O (134217728, 4096) for zone 128=0A=
> zbd      8009  zbd_convert_to_open_zone(/dev/nullb0): returning zone 128=
=0A=
> zbd      8009  Dropped request with offset 134221824=0A=
> =0A=
> 	and dropped=0A=
> =0A=
> Signed-off-by: Alexey Dobriyan (SK hynix) <adobriyan@gmail.com>=0A=
=0A=
I tested your patch. I confirm that it works and results in much better IO=
=0A=
patterns with multiple jobs (less zone contention).=0A=
I just have a few more comments below.=0A=
=0A=
> ---=0A=
> =0A=
>  zbd.c |   35 ++++++++++++++++++++++++++++++-----=0A=
>  1 file changed, 30 insertions(+), 5 deletions(-)=0A=
> =0A=
> --- a/zbd.c=0A=
> +++ b/zbd.c=0A=
> @@ -969,9 +969,8 @@ static struct fio_zone_info *zbd_convert_to_open_zone=
(struct thread_data *td,=0A=
>  		 * This statement accesses f->zbd_info->open_zones[] on purpose=0A=
>  		 * without locking.=0A=
>  		 */=0A=
> -		zone_idx =3D f->zbd_info->open_zones[(io_u->offset -=0A=
> -						    f->file_offset) *=0A=
> -				f->zbd_info->num_open_zones / f->io_size];=0A=
> +		uint32_t tmp =3D io_u->offset * f->zbd_info->num_open_zones / f->real_=
file_size;=0A=
=0A=
You are using tmp here and then tmp and below. Instead of repeating the=0A=
declaration locally, move it to the function whole scope and call it tmp_id=
x=0A=
(tmp is a little too generic in my opinion).=0A=
=0A=
Also please try to avoid lines longer than 80 chars (split the calculation =
above=0A=
on two lines).=0A=
=0A=
> +		zone_idx =3D f->zbd_info->open_zones[tmp];=0A=
>  	} else {=0A=
>  		zone_idx =3D zbd_zone_idx(f, io_u->offset);=0A=
>  	}=0A=
> @@ -985,6 +984,8 @@ static struct fio_zone_info *zbd_convert_to_open_zone=
(struct thread_data *td,=0A=
>  	 * has been obtained. Hence the loop.=0A=
>  	 */=0A=
>  	for (;;) {=0A=
> +		uint32_t tmp;=0A=
> +=0A=
=0A=
Remove this.=0A=
=0A=
>  		z =3D &f->zbd_info->zone_info[zone_idx];=0A=
>  =0A=
>  		zone_lock(td, z);=0A=
> @@ -998,9 +999,33 @@ static struct fio_zone_info *zbd_convert_to_open_zon=
e(struct thread_data *td,=0A=
>  			       __func__, f->file_name);=0A=
>  			return NULL;=0A=
>  		}=0A=
> -		open_zone_idx =3D (io_u->offset - f->file_offset) *=0A=
> -			f->zbd_info->num_open_zones / f->io_size;=0A=
> +=0A=
> +		/*=0A=
> +		 * List of opened zones is per-device, shared across all threads.=0A=
> +		 * Start with quasi-random candidate zone.=0A=
> +		 * Ignore zones which don't belong to thread's offset/size area.=0A=
> +		 */=0A=
> +		open_zone_idx =3D io_u->offset * f->zbd_info->num_open_zones / f->real=
_file_size;=0A=
>  		assert(open_zone_idx < f->zbd_info->num_open_zones);=0A=
> +		for (tmp =3D open_zone_idx, i =3D 0; i < f->zbd_info->num_open_zones; =
i++, tmp++) {=0A=
> +			uint32_t tmpz;=0A=
> +=0A=
> +			if (tmp >=3D f->zbd_info->num_open_zones)=0A=
> +				tmp =3D 0;=0A=
> +			tmpz =3D f->zbd_info->open_zones[tmp];=0A=
> +=0A=
> +			if (is_valid_offset(f, f->zbd_info->zone_info[tmpz].start)) {=0A=
> +				open_zone_idx =3D tmp;=0A=
> +				goto found_candidate_zone;=0A=
> +			}=0A=
> +=0A=
> +		}=0A=
> +=0A=
> +		dprint(FD_ZBD, "%s(%s): no candidate zone\n",=0A=
> +			__func__, f->file_name);=0A=
> +		return NULL;=0A=
> +=0A=
> +found_candidate_zone:=0A=
>  		new_zone_idx =3D f->zbd_info->open_zones[open_zone_idx];=0A=
>  		if (new_zone_idx =3D=3D zone_idx)=0A=
>  			break;=0A=
> =0A=
=0A=
With the above nits corrected, please feel free to add:=0A=
=0A=
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
Tested-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
=0A=
Cheers.=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=

