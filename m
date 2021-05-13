Return-Path: <prvs=760bdaabf=Damien.LeMoal@wdc.com>
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH 1/4] zbd: only put an upper limit on max open zones once
Date: Thu, 13 May 2021 00:08:41 +0000
Message-ID: 
 <DM6PR04MB70819B9F373BE36C0C3DBDCDE7519@DM6PR04MB7081.namprd04.prod.outlook.com>
References: <20210512223615.17239-1-Niklas.Cassel@wdc.com>
 <20210512223615.17239-2-Niklas.Cassel@wdc.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Niklas Cassel <Niklas.Cassel@wdc.com>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 2021/05/13 7:36, Niklas Cassel wrote:=0A=
> From: Niklas Cassel <niklas.cassel@wdc.com>=0A=
> =0A=
> There is an upper limit that is checked for each td, and for each file,=
=0A=
> even though a file has a pointer to a zoned_block_device_info that has=0A=
> already been created. Multiple files, from the same or from another td=0A=
> can point to the same zoned_block_device_info.=0A=
> All zoned_block_device_info:s have already been created earlier in the=0A=
> call chain.=0A=
> =0A=
> Simplify this by only checking the upper limit on max open zones when a=
=0A=
> zoned_block_device_info is created.=0A=
> =0A=
> This way, max_open_zones is handled from a single location, instead of=0A=
> potentially being reassigned from a completely different location.=0A=
> =0A=
> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>=0A=
> ---=0A=
>  zbd.c | 5 ++---=0A=
>  1 file changed, 2 insertions(+), 3 deletions(-)=0A=
> =0A=
> diff --git a/zbd.c b/zbd.c=0A=
> index eed796b3..8ed8f195 100644=0A=
> --- a/zbd.c=0A=
> +++ b/zbd.c=0A=
> @@ -588,7 +588,8 @@ static int zbd_create_zone_info(struct thread_data *t=
d, struct fio_file *f)=0A=
>  =0A=
>  	if (ret =3D=3D 0) {=0A=
>  		f->zbd_info->model =3D zbd_model;=0A=
> -		f->zbd_info->max_open_zones =3D td->o.max_open_zones;=0A=
> +		f->zbd_info->max_open_zones =3D=0A=
> +			td->o.max_open_zones ?: ZBD_MAX_OPEN_ZONES;=0A=
=0A=
		f->zbd_info->max_open_zones =3D=0A=
			min_not_zero(td->o.max_open_zones, ZBD_MAX_OPEN_ZONES);=0A=
=0A=
is more readable (easier to understand), no ?=0A=
=0A=
>  	}=0A=
>  	return ret;=0A=
>  }=0A=
> @@ -726,8 +727,6 @@ int zbd_setup_files(struct thread_data *td)=0A=
>  		if (zbd_is_seq_job(f))=0A=
>  			assert(f->min_zone < f->max_zone);=0A=
>  =0A=
> -		zbd->max_open_zones =3D zbd->max_open_zones ?: ZBD_MAX_OPEN_ZONES;=0A=
> -=0A=
>  		if (td->o.max_open_zones > 0 &&=0A=
>  		    zbd->max_open_zones !=3D td->o.max_open_zones) {=0A=
>  			log_err("Different 'max_open_zones' values\n");=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=

