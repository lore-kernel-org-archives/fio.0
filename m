Return-Path: <prvs=80344d991=Damien.LeMoal@wdc.com>
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH 3/3] zbd: ensure that global max open zones limit is
 respected
Date: Fri, 25 Jun 2021 07:11:59 +0000
Message-ID: 
 <DM6PR04MB7081922929DE06E951BC9756E7069@DM6PR04MB7081.namprd04.prod.outlook.com>
References: <20210624172256.37177-1-Niklas.Cassel@wdc.com>
 <20210624172256.37177-4-Niklas.Cassel@wdc.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Niklas Cassel <Niklas.Cassel@wdc.com>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, "adobriyan@gmail.com" <adobriyan@gmail.com>
List-ID: <fio@vger.kernel.org>

On 2021/06/25 2:23, Niklas Cassel wrote:=0A=
> From: Niklas Cassel <niklas.cassel@wdc.com>=0A=
> =0A=
> Commit 219c662d3b12 ("zbd: introduce per job maximum open zones limit")=
=0A=
> Introduced a global max open zones limit stored in zbd_info->max_open_zon=
es.=0A=
> =0A=
> This commit also changed checks against td->o.max_open_zones in zbd_open_=
zone()=0A=
> with checks against zbd_info->max_open_zones.=0A=
> =0A=
> It is obvious that zbd_info->max_open_zones was intended to replace=0A=
> td->o.max_open_zones in all code that is executed after zbd_setup_files()=
.=0A=
> =0A=
> The commit itself was needed since zbd_info is shared over different jobs=
,=0A=
> so it is important that the global limit of max open zones is the same,=
=0A=
> for different jobs targeting the same device.=0A=
> =0A=
> The problem with this commit is that in zbd_convert_to_open_zone(),=0A=
> instead of replacing td->o.max_open_zones with zbd_info->max_open_zones,=
=0A=
> it incorrectly just removed the references to td->o.max_open_zones.=0A=
> =0A=
> This caused commit 00ca8df5468e ("zbd: Fix max_open_zones checks")=0A=
> (written by another author) to incorrectly re-add the removed=0A=
> td->o.max_open_zones checks in zbd_convert_to_open_zone().=0A=
> The proper fix here should have been to add checks against=0A=
> zbd_info->max_open_zones instead of td->o.max_open_zones,=0A=
> just like the original author did for zbd_open_zone().=0A=
> =0A=
> Replace all td->o.max_open_zones uses past zbd_setup_files() with=0A=
> zbd_info->max_open_zones, and force set td->o.max_open_zones to=0A=
> zbd_info->max_open_zones in zbd_setup_files(), so that even if checks are=
=0A=
> introduced against the wrong limit, fio will still respect the global lim=
it.=0A=
> =0A=
> Fixes: 00ca8df5468e ("zbd: Fix max_open_zones checks")=0A=
> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>=0A=
> Cc: Alexey Dobriyan <adobriyan@gmail.com>=0A=
> Cc: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>=0A=
> ---=0A=
>  zbd.c | 16 ++++++++++++----=0A=
>  1 file changed, 12 insertions(+), 4 deletions(-)=0A=
> =0A=
> diff --git a/zbd.c b/zbd.c=0A=
> index f19e3d47..04c68dea 100644=0A=
> --- a/zbd.c=0A=
> +++ b/zbd.c=0A=
> @@ -842,6 +842,14 @@ int zbd_setup_files(struct thread_data *td)=0A=
>  			return 1;=0A=
>  		}=0A=
>  =0A=
> +		/*=0A=
> +		 * zbd->max_open_zones is the global limit shared for all jobs=0A=
> +		 * that target the same zoned block device. Force sync the per=0A=
> +		 * thread global limit with the actual global limit. (The real=0A=
> +		 * per thread/job limit is stored in td->o.job_max_open_zones).=0A=
> +		 */=0A=
> +		td->o.max_open_zones =3D zbd->max_open_zones;=0A=
> +=0A=
>  		for (zi =3D f->min_zone; zi < f->max_zone; zi++) {=0A=
>  			z =3D &zbd->zone_info[zi];=0A=
>  			if (z->cond !=3D ZBD_ZONE_COND_IMP_OPEN &&=0A=
> @@ -1205,7 +1213,7 @@ static struct fio_zone_info *zbd_convert_to_open_zo=
ne(struct thread_data *td,=0A=
>  =0A=
>  	assert(is_valid_offset(f, io_u->offset));=0A=
>  =0A=
> -	if (td->o.max_open_zones || td->o.job_max_open_zones) {=0A=
> +	if (zbdi->max_open_zones || td->o.job_max_open_zones) {=0A=
>  		/*=0A=
>  		 * This statement accesses zbdi->open_zones[] on purpose=0A=
>  		 * without locking.=0A=
> @@ -1236,7 +1244,7 @@ static struct fio_zone_info *zbd_convert_to_open_zo=
ne(struct thread_data *td,=0A=
>  		pthread_mutex_lock(&zbdi->mutex);=0A=
>  		if (z->has_wp) {=0A=
>  			if (z->cond !=3D ZBD_ZONE_COND_OFFLINE &&=0A=
> -			    td->o.max_open_zones =3D=3D 0 && td->o.job_max_open_zones =3D=3D =
0)=0A=
> +			    zbdi->max_open_zones =3D=3D 0 && td->o.job_max_open_zones =3D=3D =
0)=0A=
>  				goto examine_zone;=0A=
>  			if (zbdi->num_open_zones =3D=3D 0) {=0A=
>  				dprint(FD_ZBD, "%s(%s): no zones are open\n",=0A=
> @@ -1297,8 +1305,8 @@ open_other_zone:=0A=
>  	/* Check if number of open zones reaches one of limits. */=0A=
>  	wait_zone_close =3D=0A=
>  		zbdi->num_open_zones =3D=3D f->max_zone - f->min_zone ||=0A=
> -		(td->o.max_open_zones &&=0A=
> -		 zbdi->num_open_zones =3D=3D td->o.max_open_zones) ||=0A=
> +		(zbdi->max_open_zones &&=0A=
> +		 zbdi->num_open_zones =3D=3D zbdi->max_open_zones) ||=0A=
>  		(td->o.job_max_open_zones &&=0A=
>  		 td->num_open_zones =3D=3D td->o.job_max_open_zones);=0A=
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

