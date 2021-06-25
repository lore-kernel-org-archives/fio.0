Return-Path: <prvs=80344d991=Damien.LeMoal@wdc.com>
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH 2/3] zbd: allow an unlimited global max open zones limit
Date: Fri, 25 Jun 2021 07:09:39 +0000
Message-ID: 
 <DM6PR04MB70814D900A0439E14FCE0B40E7069@DM6PR04MB7081.namprd04.prod.outlook.com>
References: <20210624172256.37177-1-Niklas.Cassel@wdc.com>
 <20210624172256.37177-3-Niklas.Cassel@wdc.com>
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
> This commit also removed the following check from zbd_open_zone():=0A=
> =0A=
> if (!td->o.max_open_zones)=0A=
>         return true;=0A=
> =0A=
> Before the commit in question, if td->o.max_open_zones =3D=3D 0, zbd_open=
_zone()=0A=
> would not track the zone as open in the zbd_info->open_zones array.=0A=
> =0A=
> After the commit in question, zbd_open_zone() would always track the zone=
=0A=
> as open in the zbd_info->open_zones array, regardless if a --max_open_zon=
es=0A=
> limit was set or not.=0A=
> =0A=
> Change the initialization of zbd_info->max_open_zones to yet again allow=
=0A=
> unlimited max open zones. If zbd_info->max_open_zones is unlimited,=0A=
> we do not track the open zones in the zbd_info->open zone array.=0A=
> =0A=
> Not tracking open zones reduces fio overhead for testing the performance =
of=0A=
> zoned block devices that do not have a limit on the maximum number of ope=
n=0A=
> zones.=0A=
> =0A=
> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>=0A=
> Cc: Alexey Dobriyan <adobriyan@gmail.com>=0A=
> ---=0A=
>  zbd.c | 28 ++++++++++++++++++++++++----=0A=
>  zbd.h |  3 ++-=0A=
>  2 files changed, 26 insertions(+), 5 deletions(-)=0A=
> =0A=
> diff --git a/zbd.c b/zbd.c=0A=
> index f09b0ee6..f19e3d47 100644=0A=
> --- a/zbd.c=0A=
> +++ b/zbd.c=0A=
> @@ -636,8 +636,12 @@ static int zbd_set_max_open_zones(struct thread_data=
 *td, struct fio_file *f)=0A=
>  =0A=
>  out:=0A=
>  	/* Ensure that the limit is not larger than FIO's internal limit */=0A=
> -	zbd->max_open_zones =3D min_not_zero(zbd->max_open_zones,=0A=
> -					   (uint32_t) ZBD_MAX_OPEN_ZONES);=0A=
> +	if (zbd->max_open_zones > ZBD_MAX_OPEN_ZONES) {=0A=
> +		td_verror(td, EINVAL, "'max_open_zones' value is too large");=0A=
> +		log_err("'max_open_zones' value is larger than %u\n", ZBD_MAX_OPEN_ZON=
ES);=0A=
> +		return -EINVAL;=0A=
> +	}=0A=
> +=0A=
>  	dprint(FD_ZBD, "%s: using max open zones limit: %"PRIu32"\n",=0A=
>  	       f->file_name, zbd->max_open_zones);=0A=
>  =0A=
> @@ -827,8 +831,14 @@ int zbd_setup_files(struct thread_data *td)=0A=
>  			log_err("Different 'max_open_zones' values\n");=0A=
>  			return 1;=0A=
>  		}=0A=
> -		if (zbd->max_open_zones > ZBD_MAX_OPEN_ZONES) {=0A=
> -			log_err("'max_open_zones' value is limited by %u\n", ZBD_MAX_OPEN_ZON=
ES);=0A=
> +=0A=
> +		/*=0A=
> +		 * The per job max open zones limit cannot be used without a=0A=
> +		 * global max open zones limit. (As the tracking of open zones=0A=
> +		 * is disabled when there is no global max open zones limit.)=0A=
> +		 */=0A=
> +		if (td->o.job_max_open_zones && !zbd->max_open_zones) {=0A=
> +			log_err("'job_max_open_zones' cannot be used without a global open zo=
nes limit\n");=0A=
>  			return 1;=0A=
>  		}=0A=
>  =0A=
> @@ -1093,6 +1103,8 @@ static bool is_zone_open(const struct thread_data *=
td, const struct fio_file *f,=0A=
>  	struct zoned_block_device_info *zbdi =3D f->zbd_info;=0A=
>  	int i;=0A=
>  =0A=
> +	/* This function should never be called when zbdi->max_open_zones =3D=
=3D 0 */=0A=
> +	assert(zbdi->max_open_zones);=0A=
>  	assert(td->o.job_max_open_zones =3D=3D 0 || td->num_open_zones <=3D td-=
>o.job_max_open_zones);=0A=
>  	assert(td->o.job_max_open_zones <=3D zbdi->max_open_zones);=0A=
>  	assert(zbdi->num_open_zones <=3D zbdi->max_open_zones);=0A=
> @@ -1128,6 +1140,14 @@ static bool zbd_open_zone(struct thread_data *td, =
const struct fio_file *f,=0A=
>  	if (td->o.verify !=3D VERIFY_NONE && zbd_zone_full(f, z, min_bs))=0A=
>  		return false;=0A=
>  =0A=
> +	/*=0A=
> +	 * zbdi->max_open_zones =3D=3D 0 means that there is no limit on the ma=
ximum=0A=
> +	 * number of open zones. In this case, do no track open zones in=0A=
> +	 * zbdi->open_zones array.=0A=
> +	 */=0A=
> +	if (!zbdi->max_open_zones)=0A=
> +		return true;=0A=
> +=0A=
>  	pthread_mutex_lock(&zbdi->mutex);=0A=
>  	if (is_zone_open(td, f, zone_idx)) {=0A=
>  		/*=0A=
> diff --git a/zbd.h b/zbd.h=0A=
> index 64534393..39dc45e3 100644=0A=
> --- a/zbd.h=0A=
> +++ b/zbd.h=0A=
> @@ -50,7 +50,8 @@ struct fio_zone_info {=0A=
>   * zoned_block_device_info - zoned block device characteristics=0A=
>   * @model: Device model.=0A=
>   * @max_open_zones: global limit on the number of simultaneously opened=
=0A=
> - *	sequential write zones.=0A=
> + *	sequential write zones. A zero value means unlimited open zones,=0A=
> + *	and that open zones will not be tracked in the open_zones array.=0A=
>   * @mutex: Protects the modifiable members in this structure (refcount a=
nd=0A=
>   *		num_open_zones).=0A=
>   * @zone_size: size of a single zone in bytes.=0A=
> =0A=
=0A=
Looks good.=0A=
=0A=
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=

