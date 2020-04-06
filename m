Return-Path: <prvs=35814f3ae=Damien.LeMoal@wdc.com>
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH] zbd: fixup ->zone_size_log2 if zone size is not power of
 2
Date: Mon, 6 Apr 2020 22:24:30 +0000
Message-ID: 
 <BY5PR04MB69004E1B2BAC82C650136730E7C20@BY5PR04MB6900.namprd04.prod.outlook.com>
References: <20200406195610.GA3255@avx2>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 2020/04/07 4:56, Alexey Dobriyan wrote:=0A=
> Code like this doesn't work if log2 is 0xffffffff.=0A=
> =0A=
> 	if (f->zbd_info->zone_size_log2 > 0)=0A=
>                 zone_idx =3D offset >> f->zbd_info->zone_size_log2;=0A=
>         else=0A=
>                 zone_idx =3D offset / f->zbd_info->zone_size;=0A=
> =0A=
> Other than that everything else works!=0A=
> =0A=
> Signed-off-by: Alexey Dobriyan (SK hynix) <adobriyan@gmail.com>=0A=
=0A=
Looks good.=0A=
=0A=
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
=0A=
> ---=0A=
> =0A=
>  zbd.c |    4 ++--=0A=
>  1 file changed, 2 insertions(+), 2 deletions(-)=0A=
> =0A=
> --- a/zbd.c=0A=
> +++ b/zbd.c=0A=
> @@ -393,7 +393,7 @@ static int init_zone_info(struct thread_data *td, str=
uct fio_file *f)=0A=
>  	f->zbd_info =3D zbd_info;=0A=
>  	f->zbd_info->zone_size =3D zone_size;=0A=
>  	f->zbd_info->zone_size_log2 =3D is_power_of_2(zone_size) ?=0A=
> -		ilog2(zone_size) : -1;=0A=
> +		ilog2(zone_size) : 0;=0A=
>  	f->zbd_info->nr_zones =3D nr_zones;=0A=
>  	pthread_mutexattr_destroy(&attr);=0A=
>  	return 0;=0A=
> @@ -510,7 +510,7 @@ static int parse_zone_info(struct thread_data *td, st=
ruct fio_file *f)=0A=
>  	f->zbd_info =3D zbd_info;=0A=
>  	f->zbd_info->zone_size =3D zone_size;=0A=
>  	f->zbd_info->zone_size_log2 =3D is_power_of_2(zone_size) ?=0A=
> -		ilog2(zone_size) : -1;=0A=
> +		ilog2(zone_size) : 0;=0A=
>  	f->zbd_info->nr_zones =3D nr_zones;=0A=
>  	zbd_info =3D NULL;=0A=
>  	ret =3D 0;=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=

