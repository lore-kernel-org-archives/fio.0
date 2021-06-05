Return-Path: <prvs=78323391c=Damien.LeMoal@wdc.com>
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH 1/4] zbd: disallow pipes for zonemode=zbd
Date: Sat, 5 Jun 2021 00:33:06 +0000
Message-ID: 
 <DM6PR04MB7081E34316874888287C6871E73A9@DM6PR04MB7081.namprd04.prod.outlook.com>
References: <20210604121843.6047-1-Niklas.Cassel@wdc.com>
 <20210604121843.6047-2-Niklas.Cassel@wdc.com>
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
> zoned block device support in fio cannot handle pipes,=0A=
> so simply reject them and give a clear error message.=0A=
> =0A=
> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>=0A=
> ---=0A=
>  zbd.c | 5 +++++=0A=
>  1 file changed, 5 insertions(+)=0A=
> =0A=
> diff --git a/zbd.c b/zbd.c=0A=
> index 5d9e331a..60325d28 100644=0A=
> --- a/zbd.c=0A=
> +++ b/zbd.c=0A=
> @@ -32,6 +32,11 @@ int zbd_get_zoned_model(struct thread_data *td, struct=
 fio_file *f,=0A=
>  {=0A=
>  	int ret;=0A=
>  =0A=
> +	if (f->filetype =3D=3D FIO_TYPE_PIPE) {=0A=
> +		log_err("zonemode=3Dzbd does not support pipes\n");=0A=
> +		return -EINVAL;=0A=
> +	}=0A=
> +=0A=
>  	if (td->io_ops && td->io_ops->get_zoned_model)=0A=
>  		ret =3D td->io_ops->get_zoned_model(td, f, model);=0A=
>  	else=0A=
> =0A=
=0A=
Looks good.=0A=
=0A=
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=

