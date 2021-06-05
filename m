Return-Path: <prvs=78323391c=Damien.LeMoal@wdc.com>
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH 2/4] zbd: allow zonemode=zbd with regular files by
 emulating zones
Date: Sat, 5 Jun 2021 00:40:25 +0000
Message-ID: 
 <DM6PR04MB7081322F7983F1235B28B12AE73A9@DM6PR04MB7081.namprd04.prod.outlook.com>
References: <20210604121843.6047-1-Niklas.Cassel@wdc.com>
 <20210604121843.6047-3-Niklas.Cassel@wdc.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Niklas Cassel <Niklas.Cassel@wdc.com>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 2021/06/04 21:18, Niklas Cassel wrote:=0A=
> From: Niklas Cassel <niklas.cassel@wdc.com>=0A=
> =0A=
> Currently when using zonemode=3Dzbd and running against a regular file,=
=0A=
> fio will fail with:=0A=
> fio: file hash not empty on exit=0A=
> =0A=
> Treat regular files just like how we treat regular (non-zoned) block=0A=
> devices: return ZBD_NONE and let zbd.c emulate zones inside the regular=
=0A=
> file/block device.=0A=
> =0A=
> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>=0A=
> ---=0A=
>  zbd.c       | 14 +++++++++++++-=0A=
>  zbd_types.h |  2 +-=0A=
>  2 files changed, 14 insertions(+), 2 deletions(-)=0A=
> =0A=
> diff --git a/zbd.c b/zbd.c=0A=
> index 60325d28..fb20f6cc 100644=0A=
> --- a/zbd.c=0A=
> +++ b/zbd.c=0A=
> @@ -37,6 +37,18 @@ int zbd_get_zoned_model(struct thread_data *td, struct=
 fio_file *f,=0A=
>  		return -EINVAL;=0A=
>  	}=0A=
>  =0A=
> +	/* If regular file, always emulate zones inside the file. */=0A=
> +	if (f->filetype =3D=3D FIO_TYPE_FILE) {=0A=
> +		if (!f->real_file_size) {=0A=
> +			log_err("%s: file size cannot be zero\n",=0A=
> +				f->file_name);=0A=
> +			return -EINVAL;=0A=
> +		}=0A=
=0A=
This check is not strong enough. The file size must be at least equal to th=
e=0A=
zone size. I think this check should go into init_zone_info(). In that func=
tion,=0A=
the number of zones is calculated as:=0A=
=0A=
        nr_zones =3D (f->real_file_size + zone_size - 1) / zone_size;=0A=
=0A=
And followed with:=0A=
=0A=
        zbd_info =3D scalloc(1, sizeof(*zbd_info) +=0A=
                           (nr_zones + 1) * sizeof(zbd_info->zone_info[0]))=
;=0A=
        if (!zbd_info)=0A=
                return -ENOMEM;=0A=
=0A=
So even if nr_zones is 0 (i.e. f->real_file_size < zone_size), there will b=
e no=0A=
errors. We need to check that nr_zones > 0, or that f->real_file_size >=3D=
=0A=
zone_size, whichever.=0A=
=0A=
> +=0A=
> +		*model =3D ZBD_NONE;=0A=
> +		return 0;=0A=
> +	}=0A=
> +=0A=
>  	if (td->io_ops && td->io_ops->get_zoned_model)=0A=
>  		ret =3D td->io_ops->get_zoned_model(td, f, model);=0A=
>  	else=0A=
> @@ -414,7 +426,7 @@ static int init_zone_info(struct thread_data *td, str=
uct fio_file *f)=0A=
>  	int i;=0A=
>  =0A=
>  	if (zone_size =3D=3D 0) {=0A=
> -		log_err("%s: Specifying the zone size is mandatory for regular block d=
evices with --zonemode=3Dzbd\n\n",=0A=
> +		log_err("%s: Specifying the zone size is mandatory for regular file/bl=
ock device with --zonemode=3Dzbd\n\n",=0A=
>  			f->file_name);=0A=
>  		return 1;=0A=
>  	}=0A=
> diff --git a/zbd_types.h b/zbd_types.h=0A=
> index 5ed41aa0..d0f4c44e 100644=0A=
> --- a/zbd_types.h=0A=
> +++ b/zbd_types.h=0A=
> @@ -15,7 +15,7 @@=0A=
>   */=0A=
>  enum zbd_zoned_model {=0A=
>  	ZBD_IGNORE,		/* Ignore file */=0A=
> -	ZBD_NONE,		/* Regular block device */=0A=
> +	ZBD_NONE,		/* No zone support. Emulate zones. */=0A=
>  	ZBD_HOST_AWARE,		/* Host-aware zoned block device */=0A=
>  	ZBD_HOST_MANAGED,	/* Host-managed zoned block device */=0A=
>  };=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=

