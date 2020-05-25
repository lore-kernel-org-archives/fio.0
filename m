Return-Path: <prvs=407291984=Damien.LeMoal@wdc.com>
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH 2/4] libzbc: fix whitespace errors
Date: Mon, 25 May 2020 23:22:28 +0000
Message-ID: 
 <CY4PR04MB37517A6347291F0528486631E7B30@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <20200525213256.7476-1-dmitry.fomichev@wdc.com>
 <20200525213256.7476-3-dmitry.fomichev@wdc.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Dmitry Fomichev <Dmitry.Fomichev@wdc.com>, Jens Axboe <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 2020/05/26 6:33, Dmitry Fomichev wrote:=0A=
> Make checkpatch happy... no functional change.=0A=
> =0A=
> Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>=0A=
> ---=0A=
>  engines/libzbc.c | 18 ++++++++----------=0A=
>  1 file changed, 8 insertions(+), 10 deletions(-)=0A=
> =0A=
> diff --git a/engines/libzbc.c b/engines/libzbc.c=0A=
> index 2f6b4583..9e568334 100644=0A=
> --- a/engines/libzbc.c=0A=
> +++ b/engines/libzbc.c=0A=
> @@ -47,7 +47,7 @@ static int libzbc_open_dev(struct thread_data *td, stru=
ct fio_file *f,=0A=
>  			   struct libzbc_data **p_ld)=0A=
>  {=0A=
>  	struct libzbc_data *ld =3D td->io_ops_data;=0A=
> -        int ret, flags =3D OS_O_DIRECT;=0A=
> +	int ret, flags =3D OS_O_DIRECT;=0A=
>  =0A=
>  	if (ld) {=0A=
>  		/* Already open */=0A=
> @@ -61,7 +61,7 @@ static int libzbc_open_dev(struct thread_data *td, stru=
ct fio_file *f,=0A=
>  		return -EINVAL;=0A=
>  	}=0A=
>  =0A=
> -        if (td_write(td)) {=0A=
> +	if (td_write(td)) {=0A=
>  		if (!read_only)=0A=
>  			flags |=3D O_RDWR;=0A=
>  	} else if (td_read(td)) {=0A=
> @@ -71,17 +71,15 @@ static int libzbc_open_dev(struct thread_data *td, st=
ruct fio_file *f,=0A=
>  			flags |=3D O_RDONLY;=0A=
>  	} else if (td_trim(td)) {=0A=
>  		td_verror(td, EINVAL, "libzbc does not support trim");=0A=
> -                log_err("%s: libzbc does not support trim\n",=0A=
> -                        f->file_name);=0A=
> -                return -EINVAL;=0A=
> +		log_err("%s: libzbc does not support trim\n", f->file_name);=0A=
> +		return -EINVAL;=0A=
>  	}=0A=
>  =0A=
> -        if (td->o.oatomic) {=0A=
> +	if (td->o.oatomic) {=0A=
>  		td_verror(td, EINVAL, "libzbc does not support O_ATOMIC");=0A=
> -                log_err("%s: libzbc does not support O_ATOMIC\n",=0A=
> -                        f->file_name);=0A=
> -                return -EINVAL;=0A=
> -        }=0A=
> +		log_err("%s: libzbc does not support O_ATOMIC\n", f->file_name);=0A=
> +		return -EINVAL;=0A=
> +	}=0A=
>  =0A=
>  	ld =3D calloc(1, sizeof(*ld));=0A=
>  	if (!ld)=0A=
> =0A=
=0A=
Jens,=0A=
=0A=
Not sure if you take white-space patches. But if you do:=0A=
=0A=
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=

