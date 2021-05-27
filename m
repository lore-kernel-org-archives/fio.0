Return-Path: <fio-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:2030 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236233AbhE0KzP (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 27 May 2021 06:55:15 -0400
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH v2 1/2] zbd: add missing client/server support for option
 max_open_zones
Date: Thu, 27 May 2021 10:53:40 +0000
Message-ID: <DM6PR04MB70814630FAE6A04C6CBFB30DE7239@DM6PR04MB7081.namprd04.prod.outlook.com>
References: <20210524144109.12127-1-Niklas.Cassel@wdc.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
List-Id: fio@vger.kernel.org
To: Niklas Cassel <Niklas.Cassel@wdc.com>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 2021/05/24 23:41, Niklas Cassel wrote:=0A=
> From: Niklas Cassel <niklas.cassel@wdc.com>=0A=
> =0A=
> Ensure that we convert the max_open_zones option for client/server.=0A=
> =0A=
> Use __cpu_to_le32()/__le32_to_cpu() rather than=0A=
> cpu_to_le32()/le32_to_cpu(), since max_open_zones is defined=0A=
> as int rather than unsigned int in thread_options.h.=0A=
> =0A=
> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>=0A=
> ---=0A=
> Changes since V1:=0A=
> - New patch.=0A=
> =0A=
>  cconv.c          | 2 ++=0A=
>  server.h         | 2 +-=0A=
>  thread_options.h | 1 +=0A=
>  3 files changed, 4 insertions(+), 1 deletion(-)=0A=
> =0A=
> diff --git a/cconv.c b/cconv.c=0A=
> index aa06e3ea..d4dfb81b 100644=0A=
> --- a/cconv.c=0A=
> +++ b/cconv.c=0A=
> @@ -231,6 +231,7 @@ void convert_thread_options_to_cpu(struct thread_opti=
ons *o,=0A=
>  	o->zone_capacity =3D le64_to_cpu(top->zone_capacity);=0A=
>  	o->zone_skip =3D le64_to_cpu(top->zone_skip);=0A=
>  	o->zone_mode =3D le32_to_cpu(top->zone_mode);=0A=
> +	o->max_open_zones =3D __le32_to_cpu(top->max_open_zones);=0A=
>  	o->lockmem =3D le64_to_cpu(top->lockmem);=0A=
>  	o->offset_increment_percent =3D le32_to_cpu(top->offset_increment_perce=
nt);=0A=
>  	o->offset_increment =3D le64_to_cpu(top->offset_increment);=0A=
> @@ -573,6 +574,7 @@ void convert_thread_options_to_net(struct thread_opti=
ons_pack *top,=0A=
>  	top->zone_capacity =3D __cpu_to_le64(o->zone_capacity);=0A=
>  	top->zone_skip =3D __cpu_to_le64(o->zone_skip);=0A=
>  	top->zone_mode =3D __cpu_to_le32(o->zone_mode);=0A=
> +	top->max_open_zones =3D __cpu_to_le32(o->max_open_zones);=0A=
>  	top->lockmem =3D __cpu_to_le64(o->lockmem);=0A=
>  	top->ddir_seq_add =3D __cpu_to_le64(o->ddir_seq_add);=0A=
>  	top->file_size_low =3D __cpu_to_le64(o->file_size_low);=0A=
> diff --git a/server.h b/server.h=0A=
> index b45b319b..8cf3a60b 100644=0A=
> --- a/server.h=0A=
> +++ b/server.h=0A=
> @@ -48,7 +48,7 @@ struct fio_net_cmd_reply {=0A=
>  };=0A=
>  =0A=
>  enum {=0A=
> -	FIO_SERVER_VER			=3D 89,=0A=
> +	FIO_SERVER_VER			=3D 90,=0A=
>  =0A=
>  	FIO_SERVER_MAX_FRAGMENT_PDU	=3D 1024,=0A=
>  	FIO_SERVER_MAX_CMD_MB		=3D 2048,=0A=
> diff --git a/thread_options.h b/thread_options.h=0A=
> index 5ecc72d7..4d48e462 100644=0A=
> --- a/thread_options.h=0A=
> +++ b/thread_options.h=0A=
> @@ -656,6 +656,7 @@ struct thread_options_pack {=0A=
>  	uint32_t allow_mounted_write;=0A=
>  =0A=
>  	uint32_t zone_mode;=0A=
> +	int32_t max_open_zones;=0A=
>  } __attribute__((packed));=0A=
>  =0A=
>  extern void convert_thread_options_to_cpu(struct thread_options *o, stru=
ct thread_options_pack *top);=0A=
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

