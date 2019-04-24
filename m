Return-Path: <prvs=01006628f=Damien.LeMoal@wdc.com>
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH] zbd random read conventional zones
Date: Wed, 24 Apr 2019 22:34:00 +0000
Message-ID: 
 <BYAPR04MB581639529431FCCC22ABD018E73C0@BYAPR04MB5816.namprd04.prod.outlook.com>
References: <20190424214741.21554-1-phillip.a.chen@seagate.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: "phillip.a.chen@seagate.com" <phillip.a.chen@seagate.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>, "axboe@kernel.dk" <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

Phillip,=0A=
=0A=
On 2019/04/24 14:48, phillip.a.chen@seagate.com wrote:=0A=
> From: Phillip Chen <phillip.a.chen@seagate.com>=0A=
> =0A=
> Signed-off-by: Phillip Chen <phillip.a.chen@seagate.com>=0A=
> Initialize conventional zone write pointers to full so=0A=
> zbd_find_zone will accept conventional zones when searching=0A=
> around a randomly chosen empty zone.=0A=
=0A=
A patch format is generally:=0A=
=0A=
component: title (what is the patch)=0A=
=0A=
description=0A=
=0A=
Signed-of-by: ...=0A=
=0A=
So in your case, the patch should probably be something like:=0A=
=0A=
zbd: Fix zone selection=0A=
=0A=
Initialize conventional zone write pointers to full so=0A=
zbd_find_zone() will accept conventional zones under random reads/write wor=
kloads.=0A=
=0A=
Signed-off-by: Phillip Chen <phillip.a.chen@seagate.com>=0A=
=0A=
> =0A=
> ---=0A=
>  zbd.c | 2 --=0A=
>  1 file changed, 2 deletions(-)=0A=
> =0A=
> diff --git a/zbd.c b/zbd.c=0A=
> index 2da742b7..616c3e0e 100644=0A=
> --- a/zbd.c=0A=
> +++ b/zbd.c=0A=
> @@ -418,8 +418,6 @@ static int parse_zone_info(struct thread_data *td, st=
ruct fio_file *f)=0A=
>  			p->start =3D z->start << 9;=0A=
>  			switch (z->cond) {=0A=
>  			case BLK_ZONE_COND_NOT_WP:=0A=
> -				p->wp =3D p->start;=0A=
> -				break;=0A=
>  			case BLK_ZONE_COND_FULL:=0A=
>  				p->wp =3D p->start + zone_size;=0A=
>  				break;=0A=
> =0A=
=0A=
Other than that, the code seems fine, so:=0A=
=0A=
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=

