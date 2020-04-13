Return-Path: <prvs=365e504d7=Damien.LeMoal@wdc.com>
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH 1/3] t/zbd: Fix a bug in max_open_zones()
Date: Mon, 13 Apr 2020 09:08:48 +0000
Message-ID: 
 <BY5PR04MB6900A413D4DD7EE7C18239ECE7DD0@BY5PR04MB6900.namprd04.prod.outlook.com>
References: <20200413083300.256784-1-shinichiro.kawasaki@wdc.com>
 <20200413083300.256784-2-shinichiro.kawasaki@wdc.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

On 2020/04/13 17:33, Shin'ichiro Kawasaki wrote:=0A=
> When sg_inq command is executed to check if it can provide maximum open=
=0A=
> zones, the command's standard output was not discarded and caused=0A=
> unexpected script behavior. Fix it discarding the standard output.=0A=
> =0A=
> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>=0A=
> ---=0A=
>  t/zbd/functions | 3 ++-=0A=
>  1 file changed, 2 insertions(+), 1 deletion(-)=0A=
> =0A=
> diff --git a/t/zbd/functions b/t/zbd/functions=0A=
> index 35087b15..5bffad6e 100644=0A=
> --- a/t/zbd/functions=0A=
> +++ b/t/zbd/functions=0A=
> @@ -43,7 +43,8 @@ max_open_zones() {=0A=
>      local dev=3D$1=0A=
>  =0A=
>      if [ -n "${sg_inq}" ] && [ ! -n "${use_libzbc}" ]; then=0A=
> -	if ! ${sg_inq} -e --page=3D0xB6 --len=3D20 --hex "$dev" 2> /dev/null; t=
hen=0A=
> +	if ! ${sg_inq} -e --page=3D0xB6 --len=3D20 --hex "$dev" \=0A=
> +		 > /dev/null 2>&1; then=0A=
>  	    # Non scsi device such as null_blk can not return max open zones.=
=0A=
>  	    # Use default value.=0A=
>  	    echo 128=0A=
> =0A=
=0A=
Looks good.=0A=
=0A=
Reviewed-by: Damien Le Moal <damien.lemoaal@wdc.com>=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=

