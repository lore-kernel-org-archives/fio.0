Return-Path: <prvs=760bdaabf=Damien.LeMoal@wdc.com>
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH 4/4] engines/libzbc: add support for the
 get_max_open_zones io op
Date: Thu, 13 May 2021 00:24:58 +0000
Message-ID: 
 <DM6PR04MB70813D27353599F6524CA41AE7519@DM6PR04MB7081.namprd04.prod.outlook.com>
References: <20210512223615.17239-1-Niklas.Cassel@wdc.com>
 <20210512223615.17239-5-Niklas.Cassel@wdc.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Niklas Cassel <Niklas.Cassel@wdc.com>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 2021/05/13 7:37, Niklas Cassel wrote:=0A=
> From: Niklas Cassel <niklas.cassel@wdc.com>=0A=
> =0A=
> Add support for the new .get_max_open_zones io operation.=0A=
> =0A=
> zbc.c will only ever call this callback for host-managed devices.=0A=
> =0A=
> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>=0A=
> ---=0A=
>  engines/libzbc.c | 21 +++++++++++++++++++++=0A=
>  1 file changed, 21 insertions(+)=0A=
> =0A=
> diff --git a/engines/libzbc.c b/engines/libzbc.c=0A=
> index 2aacf7bb..3dde93db 100644=0A=
> --- a/engines/libzbc.c=0A=
> +++ b/engines/libzbc.c=0A=
> @@ -19,6 +19,7 @@ struct libzbc_data {=0A=
>  	struct zbc_device	*zdev;=0A=
>  	enum zbc_dev_model	model;=0A=
>  	uint64_t		nr_sectors;=0A=
> +	uint32_t		max_open_seq_req;=0A=
>  };=0A=
>  =0A=
>  static int libzbc_get_dev_info(struct libzbc_data *ld, struct fio_file *=
f)=0A=
> @@ -32,6 +33,7 @@ static int libzbc_get_dev_info(struct libzbc_data *ld, =
struct fio_file *f)=0A=
>  	zbc_get_device_info(ld->zdev, zinfo);=0A=
>  	ld->model =3D zinfo->zbd_model;=0A=
>  	ld->nr_sectors =3D zinfo->zbd_sectors;=0A=
> +	ld->max_open_seq_req =3D zinfo->zbd_max_nr_open_seq_req;=0A=
>  =0A=
>  	dprint(FD_ZBD, "%s: vendor_id:%s, type: %s, model: %s\n",=0A=
>  	       f->file_name, zinfo->zbd_vendor_id,=0A=
> @@ -335,6 +337,24 @@ err:=0A=
>  	return -ret;=0A=
>  }=0A=
>  =0A=
> +static int libzbc_get_max_open_zones(struct thread_data *td, struct fio_=
file *f,=0A=
> +				     unsigned int *max_open_zones)=0A=
> +{=0A=
> +	struct libzbc_data *ld;=0A=
> +	int ret;=0A=
> +=0A=
> +	ret =3D libzbc_open_dev(td, f, &ld);=0A=
> +	if (ret)=0A=
> +		return ret;=0A=
> +=0A=
> +	if (ld->max_open_seq_req =3D=3D ZBC_NO_LIMIT)=0A=
> +		*max_open_zones =3D 0;=0A=
> +	else=0A=
> +		*max_open_zones =3D ld->max_open_seq_req;=0A=
> +=0A=
> +	return 0;=0A=
> +}=0A=
> +=0A=
>  ssize_t libzbc_rw(struct thread_data *td, struct io_u *io_u)=0A=
>  {=0A=
>  	struct libzbc_data *ld =3D td->io_ops_data;=0A=
> @@ -414,6 +434,7 @@ FIO_STATIC struct ioengine_ops ioengine =3D {=0A=
>  	.get_zoned_model	=3D libzbc_get_zoned_model,=0A=
>  	.report_zones		=3D libzbc_report_zones,=0A=
>  	.reset_wp		=3D libzbc_reset_wp,=0A=
> +	.get_max_open_zones	=3D libzbc_get_max_open_zones,=0A=
>  	.queue			=3D libzbc_queue,=0A=
>  	.flags			=3D FIO_SYNCIO | FIO_NOEXTEND | FIO_RAWIO,=0A=
>  };=0A=
> =0A=
=0A=
Looks good.=0A=
=0A=
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=

