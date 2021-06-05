Return-Path: <fio-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:39568 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229873AbhFEAvz (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 4 Jun 2021 20:51:55 -0400
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH 4/4] zbd: change some f->zbd_info conditionals to asserts
Date: Sat, 5 Jun 2021 00:50:06 +0000
Message-ID: <DM6PR04MB7081E3F0E718E3FD94C5FEA9E73A9@DM6PR04MB7081.namprd04.prod.outlook.com>
References: <20210604121843.6047-1-Niklas.Cassel@wdc.com>
 <20210604121843.6047-5-Niklas.Cassel@wdc.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
List-Id: fio@vger.kernel.org
To: Niklas Cassel <Niklas.Cassel@wdc.com>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 2021/06/04 21:18, Niklas Cassel wrote:=0A=
> From: Niklas Cassel <niklas.cassel@wdc.com>=0A=
> =0A=
> Unfortunately, generic fio code calls some zbd_* functions unconditionall=
y.=0A=
> These functions will be called regardless if zonemode =3D=3D ZONE_MODE_NO=
NE,=0A=
> ZONE_MODE_STRIDED or ZONE_MODE_ZBD, and cannot be optimized.=0A=
> =0A=
> However, some functions are only called when zonemode =3D=3D ZONE_MODE_ZB=
D.=0A=
> Since f->zbd_info will always be non-NULL for a job with zonemode=3Dzbd,=
=0A=
> these functions can be optimized to not check if f->zbd_info is set.=0A=
> =0A=
> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>=0A=
> ---=0A=
>  zbd.c | 15 ++++++---------=0A=
>  1 file changed, 6 insertions(+), 9 deletions(-)=0A=
> =0A=
> diff --git a/zbd.c b/zbd.c=0A=
> index 7012cb93..0a48653c 100644=0A=
> --- a/zbd.c=0A=
> +++ b/zbd.c=0A=
> @@ -808,8 +808,7 @@ int zbd_setup_files(struct thread_data *td)=0A=
>  		struct fio_zone_info *z;=0A=
>  		int zi;=0A=
>  =0A=
> -		if (!zbd)=0A=
> -			continue;=0A=
> +		assert(zbd);=0A=
>  =0A=
>  		f->min_zone =3D zbd_zone_idx(f, f->file_offset);=0A=
>  		f->max_zone =3D zbd_zone_idx(f, f->file_offset + f->io_size);=0A=
> @@ -1470,8 +1469,7 @@ static void zbd_queue_io(struct thread_data *td, st=
ruct io_u *io_u, int q,=0A=
>  	uint32_t zone_idx;=0A=
>  	uint64_t zone_end;=0A=
>  =0A=
> -	if (!zbd_info)=0A=
> -		return;=0A=
> +	assert(zbd_info);=0A=
>  =0A=
>  	zone_idx =3D zbd_zone_idx(f, io_u->offset);=0A=
>  	assert(zone_idx < zbd_info->nr_zones);=0A=
> @@ -1531,8 +1529,7 @@ static void zbd_put_io(struct thread_data *td, cons=
t struct io_u *io_u)=0A=
>  	struct fio_zone_info *z;=0A=
>  	uint32_t zone_idx;=0A=
>  =0A=
> -	if (!zbd_info)=0A=
> -		return;=0A=
> +	assert(zbd_info);=0A=
>  =0A=
>  	zone_idx =3D zbd_zone_idx(f, io_u->offset);=0A=
>  	assert(zone_idx < zbd_info->nr_zones);=0A=
> @@ -1588,6 +1585,7 @@ void setup_zbd_zone_mode(struct thread_data *td, st=
ruct io_u *io_u)=0A=
>  =0A=
>  	assert(td->o.zone_mode =3D=3D ZONE_MODE_ZBD);=0A=
>  	assert(td->o.zone_size);=0A=
> +	assert(f->zbd_info);=0A=
>  =0A=
>  	zone_idx =3D zbd_zone_idx(f, f->last_pos[ddir]);=0A=
>  	z =3D get_zone(f, zone_idx);=0A=
> @@ -1662,6 +1660,7 @@ enum fio_ddir zbd_adjust_ddir(struct thread_data *t=
d, struct io_u *io_u,=0A=
>  	 * devices with all empty zones. Overwrite the first I/O direction as=
=0A=
>  	 * write to make sure data to read exists.=0A=
>  	 */=0A=
> +	assert(io_u->file->zbd_info);=0A=
>  	if (ddir !=3D DDIR_READ || !td_rw(td))=0A=
>  		return ddir;=0A=
>  =0A=
> @@ -1691,9 +1690,7 @@ enum io_u_action zbd_adjust_block(struct thread_dat=
a *td, struct io_u *io_u)=0A=
>  	uint64_t new_len;=0A=
>  	int64_t range;=0A=
>  =0A=
> -	if (!f->zbd_info)=0A=
> -		return io_u_accept;=0A=
> -=0A=
> +	assert(f->zbd_info);=0A=
>  	assert(min_bs);=0A=
>  	assert(is_valid_offset(f, io_u->offset));=0A=
>  	assert(io_u->buflen);=0A=
> =0A=
=0A=
Looks good.=0A=
=0A=
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=

