Return-Path: <prvs=4391c0654=Damien.LeMoal@wdc.com>
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH 3/4] iouring: support for Zone Append command
Date: Fri, 26 Jun 2020 05:43:27 +0000
Message-ID: 
 <CY4PR04MB375159898F07C71C4870DE63E7930@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <1593106733-19596-1-git-send-email-krish.reddy@samsung.com>
 <CGME20200625174131epcas5p36cf7cd413dcb698f117474df71e5648b@epcas5p3.samsung.com>
 <1593106733-19596-4-git-send-email-krish.reddy@samsung.com>
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
>  engines/io_uring.c | 23 ++++++++++++++++++++++-=0A=
>  1 file changed, 22 insertions(+), 1 deletion(-)=0A=
> =0A=
> diff --git a/engines/io_uring.c b/engines/io_uring.c=0A=
> index cd0810f..cb7c5ba 100644=0A=
> --- a/engines/io_uring.c=0A=
> +++ b/engines/io_uring.c=0A=
> @@ -251,7 +251,13 @@ static int fio_ioring_prep(struct thread_data *td, s=
truct io_u *io_u)=0A=
>  			sqe->ioprio =3D td->o.ioprio_class << 13;=0A=
>  		if (ld->ioprio_set)=0A=
>  			sqe->ioprio |=3D td->o.ioprio;=0A=
> -		sqe->off =3D io_u->offset;=0A=
> +		if (td->o.zone_append && io_u->ddir =3D=3D DDIR_WRITE)=0A=
> +			sqe->rw_flags |=3D RWF_ZONE_APPEND;=0A=
> +		if ((td->o.zone_mode =3D=3D ZONE_MODE_ZBD)=0A=
> +		     && td->o.zone_append && io_u->ddir =3D=3D DDIR_WRITE) {=0A=
> +			sqe->off =3D io_u->zone_start_offset;=0A=
> +		} else=0A=
> +			sqe->off =3D io_u->offset;=0A=
=0A=
Why test twice "td->o.zone_append && io_u->ddir =3D=3D DDIR_WRITE" ? this c=
an be=0A=
rewritten to not have to test this 2 times:=0A=
=0A=
		if (td->o.zone_append && io_u->ddir =3D=3D DDIR_WRITE) {=0A=
			sqe->rw_flags |=3D RWF_ZONE_APPEND;=0A=
			if (td->o.zone_mode =3D=3D ZONE_MODE_ZBD)=0A=
				sqe->off =3D io_u->zone_start_offset;=0A=
			else=0A=
				sqe->off =3D io_u->offset;=0A=
		}=0A=
=0A=
And fix the start offset as already commented, using io_u->offset and=0A=
td->o.zone_size.=0A=
=0A=
>  	} else if (ddir_sync(io_u->ddir)) {=0A=
>  		if (io_u->ddir =3D=3D DDIR_SYNC_FILE_RANGE) {=0A=
>  			sqe->off =3D f->first_write;=0A=
> @@ -324,6 +330,21 @@ static int fio_ioring_getevents(struct thread_data *=
td, unsigned int min,=0A=
>  	ld->cq_ring_off =3D *ring->head;=0A=
>  	do {=0A=
>  		r =3D fio_ioring_cqring_reap(td, events, max);=0A=
> +		if (td->o.zone_mode =3D=3D ZONE_MODE_ZBD) {=0A=
> +			struct io_uring_cqe *cqe;=0A=
> +			struct io_u *io_u;=0A=
> +			unsigned index;=0A=
=0A=
need blank line.=0A=
=0A=
> +			for (unsigned event =3D 0; event < r; event++) {=0A=
> +				index =3D (event + ld->cq_ring_off) & ld->cq_ring_mask;=0A=
> +=0A=
> +				cqe =3D &ld->cq_ring.cqes[index];=0A=
> +				io_u =3D (struct io_u *) (uintptr_t) cqe->user_data;=0A=
> +=0A=
> +				if (td->o.zone_append && td->o.do_verify=0A=
> +				    && td->o.verify && (io_u->ddir =3D=3D DDIR_WRITE))=0A=
> +					io_u->ipo->offset =3D io_u->zone_start_offset + (cqe->flags << 9);=
=0A=
=0A=
cqe->flags needs to be cast to 64bit or the shift could give the wrong resu=
lt.=0A=
=0A=
Same comments as for libaio regarding structure.=0A=
=0A=
> +			}=0A=
> +		}=0A=
>  		if (r) {=0A=
>  			events +=3D r;=0A=
>  			if (actual_min !=3D 0)=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=

