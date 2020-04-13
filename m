Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.18]:42026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727818AbgDMFhY (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 13 Apr 2020 01:37:24 -0400
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5CBBC008675
        for <fio@vger.kernel.org>; Sun, 12 Apr 2020 22:37:23 -0700 (PDT)
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH] zbd: fix zonemode=zbd with NDEBUG
Date: Mon, 13 Apr 2020 05:37:21 +0000
Message-ID: <BY5PR04MB690087E9B85FB25AE53AD544E7DD0@BY5PR04MB6900.namprd04.prod.outlook.com>
References: <20200410190621.GA26148@avx2>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Alexey Dobriyan <adobriyan@gmail.com>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 2020/04/11 4:06, Alexey Dobriyan wrote:=0A=
> assert() with NDEBUG doesn't evaluate argument.=0A=
> =0A=
> Signed-off-by: Alexey Dobriyan (SK hynix) <adobriyan@gmail.com>=0A=
> ---=0A=
> =0A=
>  zbd.c |    4 +++-=0A=
>  1 file changed, 3 insertions(+), 1 deletion(-)=0A=
> =0A=
> --- a/zbd.c=0A=
> +++ b/zbd.c=0A=
> @@ -1220,6 +1220,7 @@ static void zbd_put_io(const struct io_u *io_u)=0A=
>  	struct zoned_block_device_info *zbd_info =3D f->zbd_info;=0A=
>  	struct fio_zone_info *z;=0A=
>  	uint32_t zone_idx;=0A=
> +	int ret;=0A=
>  =0A=
>  	if (!zbd_info)=0A=
>  		return;=0A=
> @@ -1235,7 +1236,8 @@ static void zbd_put_io(const struct io_u *io_u)=0A=
>  	       "%s: terminate I/O (%lld, %llu) for zone %u\n",=0A=
>  	       f->file_name, io_u->offset, io_u->buflen, zone_idx);=0A=
>  =0A=
> -	assert(pthread_mutex_unlock(&z->mutex) =3D=3D 0);=0A=
> +	ret =3D pthread_mutex_unlock(&z->mutex);=0A=
> +	assert(ret =3D=3D 0);=0A=
>  	zbd_check_swd(f);=0A=
>  }=0A=
>  =0A=
> =0A=
=0A=
Looks good. And that may actually be the reason for the fio hang reported o=
n=0A=
github issues. Will ping the issue submitter to try this.=0A=
=0A=
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=

