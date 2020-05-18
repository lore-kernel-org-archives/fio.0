Return-Path: <prvs=40052faa3=Damien.LeMoal@wdc.com>
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH] Allow sequential read to start anywhere in a zone (option
 offset), and have a span smaller than a zone (option size).
Date: Mon, 18 May 2020 00:15:53 +0000
Message-ID: 
 <BY5PR04MB69004B760F239479906D3367E7B80@BY5PR04MB6900.namprd04.prod.outlook.com>
References: <20200515162213.1035-1-plabat@micron.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: "plabat@micron.com" <plabat@micron.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 2020/05/16 1:22, plabat@micron.com wrote:=0A=
> From: Pierre Labat <plabat@micron.com>=0A=
> =0A=
> Allow sequential read to start anywhere in a zone (option=0A=
> offset), and have a span smaller than a zone (option size).>=0A=
> A use case is a Key Value Store reading a set of keys or values=0A=
> starting somewhere in a zone.=0A=
> =0A=
> Signed-off-by: Pierre Labat <plabat@micron.com>=0A=
=0A=
This looks OK to me.=0A=
=0A=
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
=0A=
> ---=0A=
>  zbd.c | 6 ++++--=0A=
>  1 file changed, 4 insertions(+), 2 deletions(-)=0A=
> =0A=
> diff --git a/zbd.c b/zbd.c=0A=
> index 8dc3c39..f1f7c5c 100644=0A=
> --- a/zbd.c=0A=
> +++ b/zbd.c=0A=
> @@ -262,7 +262,8 @@ static bool zbd_verify_sizes(void)=0A=
>  =0A=
>  			zone_idx =3D zbd_zone_idx(f, f->file_offset);=0A=
>  			z =3D &f->zbd_info->zone_info[zone_idx];=0A=
> -			if (f->file_offset !=3D z->start) {=0A=
> +			if ((f->file_offset !=3D z->start) &&=0A=
> +			    (td->o.td_ddir !=3D TD_DDIR_READ)) {=0A=
>  				new_offset =3D (z+1)->start;=0A=
>  				if (new_offset >=3D f->file_offset + f->io_size) {=0A=
>  					log_info("%s: io_size must be at least one zone\n",=0A=
> @@ -278,7 +279,8 @@ static bool zbd_verify_sizes(void)=0A=
>  			zone_idx =3D zbd_zone_idx(f, f->file_offset + f->io_size);=0A=
>  			z =3D &f->zbd_info->zone_info[zone_idx];=0A=
>  			new_end =3D z->start;=0A=
> -			if (f->file_offset + f->io_size !=3D new_end) {=0A=
> +			if ((td->o.td_ddir !=3D TD_DDIR_READ) &&=0A=
> +			    (f->file_offset + f->io_size !=3D new_end)) {=0A=
>  				if (new_end <=3D f->file_offset) {=0A=
>  					log_info("%s: io_size must be at least one zone\n",=0A=
>  						 f->file_name);=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=

