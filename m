Return-Path: <prvs=873e2b3c7=Damien.LeMoal@wdc.com>
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH V2] oslib: Fix blkzoned_get_max_open_zones()
Date: Fri, 3 Sep 2021 01:32:45 +0000
Message-ID: 
 <DM6PR04MB70818EFB406180C87CF32A93E7CF9@DM6PR04MB7081.namprd04.prod.outlook.com>
References: <20210901064153.312953-1-damien.lemoal@wdc.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: "fio@vger.kernel.org" <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

On 2021/09/01 15:42, Damien Le Moal wrote:=0A=
> When the kernel does not have the sysfs atttribute file=0A=
> queue/max_open_zones, blkzoned_get_max_open_zones() returns success=0A=
> without initializing the max_open_zones value to 0 to indicate to the=0A=
> caller (zbd_get_max_open_zones() in zbd.c) that the device limit is=0A=
> unknown. If the max_open_zones variable in zbd_get_max_open_zones() is=0A=
> not already 0 (depending on the memory status), the missing=0A=
> initialization in blkzoned_get_max_open_zones() can cause errors or=0A=
> misbehavior as an incorrect, random, limit may be used.=0A=
> =0A=
> Fix this by always initializing max_open_zones to 0 when the=0A=
> max_open_zones sysfs attribute file does not exist.=0A=
=0A=
Hi Jens,=0A=
=0A=
We are getting problem reports from the field due to this bug. Could you ap=
ply=0A=
this patch please ?=0A=
=0A=
Thanks !=0A=
=0A=
> =0A=
> Reported-by: Bao-Hua Li <baohua.li@wdc.com>=0A=
> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
> ---=0A=
> =0A=
> Changes from v1:=0A=
> * Added missing reported-by tag=0A=
> =0A=
>  oslib/linux-blkzoned.c | 4 +++-=0A=
>  1 file changed, 3 insertions(+), 1 deletion(-)=0A=
> =0A=
> diff --git a/oslib/linux-blkzoned.c b/oslib/linux-blkzoned.c=0A=
> index 4e441d29..185bd501 100644=0A=
> --- a/oslib/linux-blkzoned.c=0A=
> +++ b/oslib/linux-blkzoned.c=0A=
> @@ -169,8 +169,10 @@ int blkzoned_get_max_open_zones(struct thread_data *=
td, struct fio_file *f,=0A=
>  		return -EIO;=0A=
>  =0A=
>  	max_open_str =3D blkzoned_get_sysfs_attr(f->file_name, "queue/max_open_=
zones");=0A=
> -	if (!max_open_str)=0A=
> +	if (!max_open_str) {=0A=
> +		*max_open_zones =3D 0;=0A=
>  		return 0;=0A=
> +	}=0A=
>  =0A=
>  	dprint(FD_ZBD, "%s: max open zones supported by device: %s\n",=0A=
>  	       f->file_name, max_open_str);=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=

