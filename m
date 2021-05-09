Return-Path: <prvs=756180964=Damien.LeMoal@wdc.com>
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH] oslib/linux-blkzoned: make sure that we always support
 zone capacity
Date: Sun, 9 May 2021 22:49:49 +0000
Message-ID: 
 <DM6PR04MB708140DC053C5D12E2C8AF3AE7559@DM6PR04MB7081.namprd04.prod.outlook.com>
References: <20210506131827.68407-1-Niklas.Cassel@wdc.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Niklas Cassel <Niklas.Cassel@wdc.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
Cc: Matias Bjorling <Matias.Bjorling@wdc.com>
List-ID: <fio@vger.kernel.org>

On 2021/05/06 22:18, Niklas Cassel wrote:=0A=
> From: Niklas Cassel <niklas.cassel@wdc.com>=0A=
> =0A=
> A common problem is that users upgrade their kernel to support NVMe ZNS=
=0A=
> devices, however, they still use the kernel uapi headers provided by thei=
r=0A=
> distro.=0A=
> =0A=
> This means that even if the kernel will populate the zone capacity fields=
=0A=
> for each zone in the zone report returned by the ioctl, fio will not know=
=0A=
> how to interpret that data.=0A=
> =0A=
> This leads to fio writing past the zone capacity, which will lead to=0A=
> I/O errors.=0A=
> =0A=
> It is not trivial for a user to realize that the kernel uapi headers=0A=
> provided by their distro is the reason for these I/O errors.=0A=
> =0A=
> In order to make it easier for these users, provide a copy of the current=
=0A=
> zoned block device kernel uapi structs.=0A=
> =0A=
> If the kernel uapi headers installed on the system are too old to support=
=0A=
> zone capacity, use the locally defined structs instead.=0A=
> If the installed headers are new enough to support zone capacity, use the=
=0A=
> installed headers.=0A=
> =0A=
> This way, fio will always be able to handle zone capacity (if the kernel=
=0A=
> supports it). At the same time, we will not redefine any structs from the=
=0A=
> installed headers if they are newer than our locally defined structs.=0A=
> =0A=
> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>=0A=
> ---=0A=
>  oslib/linux-blkzoned.c | 33 +++++++++++++++++++++++++++++++--=0A=
>  1 file changed, 31 insertions(+), 2 deletions(-)=0A=
> =0A=
> diff --git a/oslib/linux-blkzoned.c b/oslib/linux-blkzoned.c=0A=
> index f37c67fc..81e4e7f0 100644=0A=
> --- a/oslib/linux-blkzoned.c=0A=
> +++ b/oslib/linux-blkzoned.c=0A=
> @@ -23,6 +23,37 @@=0A=
>  =0A=
>  #include <linux/blkzoned.h>=0A=
>  =0A=
> +/*=0A=
> + * If the uapi headers installed on the system lacks zone capacity suppo=
rt,=0A=
> + * use our local versions. If the installed headers are recent enough to=
=0A=
> + * support zone capacity, do not redefine any structs.=0A=
> + */=0A=
> +#ifndef CONFIG_HAVE_REP_CAPACITY=0A=
> +#define BLK_ZONE_REP_CAPACITY	(1 << 0)=0A=
> +=0A=
> +struct blk_zone_v2 {=0A=
> +	__u64	start;          /* Zone start sector */=0A=
> +	__u64	len;            /* Zone length in number of sectors */=0A=
> +	__u64	wp;             /* Zone write pointer position */=0A=
> +	__u8	type;           /* Zone type */=0A=
> +	__u8	cond;           /* Zone condition */=0A=
> +	__u8	non_seq;        /* Non-sequential write resources active */=0A=
> +	__u8	reset;          /* Reset write pointer recommended */=0A=
> +	__u8	resv[4];=0A=
> +	__u64	capacity;       /* Zone capacity in number of sectors */=0A=
> +	__u8	reserved[24];=0A=
> +};=0A=
> +#define blk_zone blk_zone_v2=0A=
> +=0A=
> +struct blk_zone_report_v2 {=0A=
> +	__u64	sector;=0A=
> +	__u32	nr_zones;=0A=
> +	__u32	flags;=0A=
> +struct blk_zone zones[0];=0A=
> +};=0A=
> +#define blk_zone_report blk_zone_report_v2=0A=
> +#endif /* CONFIG_HAVE_REP_CAPACITY */=0A=
> +=0A=
>  /*=0A=
>   * Read up to 255 characters from the first line of a file. Strip the tr=
ailing=0A=
>   * newline.=0A=
> @@ -116,10 +147,8 @@ out:=0A=
>  static uint64_t zone_capacity(struct blk_zone_report *hdr,=0A=
>  			      struct blk_zone *blkz)=0A=
>  {=0A=
> -#ifdef CONFIG_HAVE_REP_CAPACITY=0A=
>  	if (hdr->flags & BLK_ZONE_REP_CAPACITY)=0A=
>  		return blkz->capacity << 9;=0A=
> -#endif=0A=
>  	return blkz->len << 9;=0A=
>  }=0A=
>  =0A=
> =0A=
=0A=
Looks good to me.=0A=
=0A=
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=

