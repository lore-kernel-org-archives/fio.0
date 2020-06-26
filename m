Return-Path: <prvs=4391c0654=Damien.LeMoal@wdc.com>
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH 2/4] libaio: support for Zone Append command
Date: Fri, 26 Jun 2020 05:38:53 +0000
Message-ID: 
 <CY4PR04MB3751B98A411CC5C6B29CA442E7930@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <1593106733-19596-1-git-send-email-krish.reddy@samsung.com>
 <CGME20200625174129epcas5p304bf58bb381b4b0c39e0ff91b50a23a9@epcas5p3.samsung.com>
 <1593106733-19596-3-git-send-email-krish.reddy@samsung.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Krishna Kanth Reddy <krish.reddy@samsung.com>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Ankit Kumar <ankit.kumar@samsung.com>
List-ID: <fio@vger.kernel.org>

On 2020/06/26 2:41, Krishna Kanth Reddy wrote:=0A=
> From: Ankit Kumar <ankit.kumar@samsung.com>=0A=
> =0A=
> The zone append command uses the write path with offset as=0A=
> start of the zone. Upon successful completion, multiple of=0A=
> sectors relative to the zone's start offset, where the data=0A=
> has been placed is returned.=0A=
> =0A=
> Signed-off-by: Krishna Kanth Reddy <krish.reddy@samsung.com>=0A=
> ---=0A=
>  engines/libaio.c | 20 +++++++++++++++++++-=0A=
>  1 file changed, 19 insertions(+), 1 deletion(-)=0A=
> =0A=
> diff --git a/engines/libaio.c b/engines/libaio.c=0A=
> index 398fdf9..4ffe831 100644=0A=
> --- a/engines/libaio.c=0A=
> +++ b/engines/libaio.c=0A=
> @@ -123,7 +123,13 @@ static int fio_libaio_prep(struct thread_data *td, s=
truct io_u *io_u)=0A=
>  		if (o->nowait)=0A=
>  			iocb->aio_rw_flags |=3D RWF_NOWAIT;=0A=
>  	} else if (io_u->ddir =3D=3D DDIR_WRITE) {=0A=
> -		io_prep_pwrite(iocb, f->fd, io_u->xfer_buf, io_u->xfer_buflen, io_u->o=
ffset);=0A=
> +		if ((td->o.zone_mode =3D=3D ZONE_MODE_ZBD) && td->o.zone_append) {=0A=
> +			io_prep_pwrite(iocb, f->fd, io_u->xfer_buf, io_u->xfer_buflen, io_u->=
zone_start_offset);=0A=
> +		}=0A=
=0A=
No need for the added braces. And see my comment in the previous patch abou=
t=0A=
zone_start_offset. You can calculate it from io_u->offset.=0A=
=0A=
> +		else=0A=
> +			io_prep_pwrite(iocb, f->fd, io_u->xfer_buf, io_u->xfer_buflen, io_u->=
offset);=0A=
> +		if (td->o.zone_append)=0A=
> +			iocb->aio_rw_flags |=3D RWF_ZONE_APPEND;=0A=
>  		if (o->nowait)=0A=
>  			iocb->aio_rw_flags |=3D RWF_NOWAIT;=0A=
>  	} else if (ddir_sync(io_u->ddir))=0A=
> @@ -228,6 +234,18 @@ static int fio_libaio_getevents(struct thread_data *=
td, unsigned int min,=0A=
>  		} else {=0A=
>  			r =3D io_getevents(ld->aio_ctx, actual_min,=0A=
>  				max, ld->aio_events + events, lt);=0A=
> +			if (td->o.zone_mode =3D=3D ZONE_MODE_ZBD) {=0A=
> +				struct io_event *ev;=0A=
> +				struct io_u *io_u;=0A=
=0A=
Add a blank line after declarations please.=0A=
=0A=
> +				for (unsigned event =3D 0; event < r; event++) {=0A=
=0A=
Better declare event above instead of here. I know C allows it, but this lo=
oks=0A=
like C++ to me :)=0A=
=0A=
> +					ev =3D ld->aio_events + event;=0A=
> +					io_u =3D container_of(ev->obj, struct io_u, iocb);=0A=
> +					if (td->o.zone_append=0A=
> +					    && td->o.do_verify && td->o.verify=0A=
> +					    && (io_u->ddir =3D=3D DDIR_WRITE))=0A=
=0A=
So this is done only if verify is on ? Then why do the loop at all if verif=
y is=0A=
off ? Move the "td->o.zone_append && td->o.do_verify && td->o.verify" condi=
tion=0A=
outside the loop.=0A=
=0A=
> +						io_u->ipo->offset =3D io_u->zone_start_offset + (ev->res2 << 9);=
=0A=
=0A=
same here about start offset.=0A=
=0A=
> +				}=0A=
> +			}=0A=
>  		}=0A=
>  		if (r > 0)=0A=
>  			events +=3D r;=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=

