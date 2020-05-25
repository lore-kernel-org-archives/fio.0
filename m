Return-Path: <prvs=407291984=Damien.LeMoal@wdc.com>
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH 1/4] libzbc: cleanup init code
Date: Mon, 25 May 2020 23:21:03 +0000
Message-ID: 
 <CY4PR04MB3751F63928B2492A464A2277E7B30@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <20200525213256.7476-1-dmitry.fomichev@wdc.com>
 <20200525213256.7476-2-dmitry.fomichev@wdc.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Dmitry Fomichev <Dmitry.Fomichev@wdc.com>, Jens Axboe <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 2020/05/26 6:33, Dmitry Fomichev wrote:=0A=
> Make sure every allocated data structure gets freed in case of=0A=
> unsuccessful libzbc ioengine initialization.=0A=
> =0A=
> Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>=0A=
> ---=0A=
>  engines/libzbc.c | 15 +++++++++------=0A=
>  1 file changed, 9 insertions(+), 6 deletions(-)=0A=
> =0A=
> diff --git a/engines/libzbc.c b/engines/libzbc.c=0A=
> index 8c682de6..2f6b4583 100644=0A=
> --- a/engines/libzbc.c=0A=
> +++ b/engines/libzbc.c=0A=
> @@ -92,15 +92,12 @@ static int libzbc_open_dev(struct thread_data *td, st=
ruct fio_file *f,=0A=
>  	if (ret) {=0A=
>  		log_err("%s: zbc_open() failed, err=3D%d\n",=0A=
>  			f->file_name, ret);=0A=
> -		return ret;=0A=
> +		goto err;=0A=
>  	}=0A=
>  =0A=
>  	ret =3D libzbc_get_dev_info(ld, f);=0A=
> -	if (ret) {=0A=
> -		zbc_close(ld->zdev);=0A=
> -		free(ld);=0A=
> -		return ret;=0A=
> -	}=0A=
> +	if (ret)=0A=
> +		goto err_close;=0A=
>  =0A=
>  	td->io_ops_data =3D ld;=0A=
>  out:=0A=
> @@ -108,6 +105,12 @@ out:=0A=
>  		*p_ld =3D ld;=0A=
>  =0A=
>  	return 0;=0A=
> +=0A=
> +err_close:=0A=
> +	zbc_close(ld->zdev);=0A=
> +err:=0A=
> +	free(ld);=0A=
> +	return ret;=0A=
>  }=0A=
>  =0A=
>  static int libzbc_close_dev(struct thread_data *td)=0A=
> =0A=
=0A=
Looks good to me.=0A=
=0A=
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=

