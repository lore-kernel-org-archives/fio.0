Return-Path: <prvs=365e504d7=Damien.LeMoal@wdc.com>
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH 2/3] t/zbd: Fix a bug in reset_zone() for all zones reset
Date: Mon, 13 Apr 2020 09:09:09 +0000
Message-ID: 
 <BY5PR04MB6900CE16B32C411E80CE2609E7DD0@BY5PR04MB6900.namprd04.prod.outlook.com>
References: <20200413083300.256784-1-shinichiro.kawasaki@wdc.com>
 <20200413083300.256784-3-shinichiro.kawasaki@wdc.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

On 2020/04/13 17:33, Shin'ichiro Kawasaki wrote:=0A=
> The bash function reset_zone() is expected to reset all zones when -1 is=
=0A=
> provided as its second argument. However, it fails to reset all zones=0A=
> using blkzone command because of wrong and unnecessary options provided=
=0A=
> to blkzone. Remove the option to fix it.=0A=
> =0A=
> This failure was found with running test-zbd-support with -r option.=0A=
> =0A=
> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>=0A=
> ---=0A=
>  t/zbd/functions | 3 +--=0A=
>  1 file changed, 1 insertion(+), 2 deletions(-)=0A=
> =0A=
> diff --git a/t/zbd/functions b/t/zbd/functions=0A=
> index 5bffad6e..1bd22ec4 100644=0A=
> --- a/t/zbd/functions=0A=
> +++ b/t/zbd/functions=0A=
> @@ -97,8 +97,7 @@ reset_zone() {=0A=
>  =0A=
>      if [ -n "${blkzone}" ] && [ ! -n "${use_libzbc}" ]; then=0A=
>  	if [ "$offset" -lt 0 ]; then=0A=
> -	    sectors=3D$(<"/sys/class/block/${dev#/dev/}/size")=0A=
> -	    ${blkzone} reset -o "${offset}" -l "$sectors" "$dev"=0A=
> +	    ${blkzone} reset "$dev"=0A=
>  	else=0A=
>  	    ${blkzone} reset -o "${offset}" -c 1 "$dev"=0A=
>  	fi=0A=
> =0A=
=0A=
Looks good.=0A=
=0A=
Reviewed-by: Damien Le Moal <damien.lemoaal@wdc.com>=0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=

