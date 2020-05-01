Return-Path: <prvs=383ebf04e=Damien.LeMoal@wdc.com>
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH 1/7] zbd: bump ZBD_MAX_OPEN_ZONES
Date: Fri, 1 May 2020 01:19:10 +0000
Message-ID: 
 <BY5PR04MB690069FD2724EB40CA9AC828E7AB0@BY5PR04MB6900.namprd04.prod.outlook.com>
References: <20200430124050.20146-1-adobriyan@gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 2020/04/30 21:41, Alexey Dobriyan wrote:=0A=
> 128 opened zones is not enough for everyone!=0A=
> =0A=
> Signed-off-by: Alexey Dobriyan (SK hynix) <adobriyan@gmail.com>=0A=
> ---=0A=
>  zbd_types.h | 2 +-=0A=
>  1 file changed, 1 insertion(+), 1 deletion(-)=0A=
> =0A=
> diff --git a/zbd_types.h b/zbd_types.h=0A=
> index 2f2f1324..d63c0d0a 100644=0A=
> --- a/zbd_types.h=0A=
> +++ b/zbd_types.h=0A=
> @@ -8,7 +8,7 @@=0A=
>  =0A=
>  #include <inttypes.h>=0A=
>  =0A=
> -#define ZBD_MAX_OPEN_ZONES	128=0A=
> +#define ZBD_MAX_OPEN_ZONES	4096=0A=
>  =0A=
>  /*=0A=
>   * Zoned block device models.=0A=
> =0A=
=0A=
Makes sense. ZNS will will need this.=0A=
=0A=
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
=0A=
Note: You did not send a cover letter for the series. Please add it for the=
 next=0A=
round.=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=

