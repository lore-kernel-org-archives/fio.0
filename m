Return-Path: <prvs=5016bbd9f=Dmitry.Fomichev@wdc.com>
From: Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
Subject: RE: [PATCH] zbd: don't read past the WP on a read only workload with
 verify
Date: Thu, 27 Aug 2020 18:09:56 +0000
Message-ID: 
 <MN2PR04MB595192579EC087B4C9EAECE1E1550@MN2PR04MB5951.namprd04.prod.outlook.com>
References: <20200813150148.14655-1-niklas.cassel@wdc.com>
In-Reply-To: <20200813150148.14655-1-niklas.cassel@wdc.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>, Niklas Cassel <Niklas.Cassel@wdc.com>, Aravind Ramesh <Aravind.Ramesh@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
List-ID: <fio@vger.kernel.org>

+ Jens... and ping for this patch, I believe it has two reviews by now.

> -----Original Message-----
> From: fio-owner@vger.kernel.org <fio-owner@vger.kernel.org> On Behalf
> Of Niklas Cassel
> Sent: Thursday, August 13, 2020 11:02 AM
> To: fio@vger.kernel.org
> Cc: Damien Le Moal <Damien.LeMoal@wdc.com>; Shinichiro Kawasaki
> <shinichiro.kawasaki@wdc.com>; Aravind Ramesh
> <Aravind.Ramesh@wdc.com>; Niklas Cassel <Niklas.Cassel@wdc.com>
> Subject: [PATCH] zbd: don't read past the WP on a read only workload with
> verify
>=20
> From: Aravind Ramesh <aravind.ramesh@wdc.com>
>=20
> When running a read only workload with verify option enabled,
> fio continues to read beyond the write pointer, and thus
> reads a deallocated block, which contains data of a predefined
> pattern, thus causing the verify to fail.
>=20
> Thus, we cannot simply jump to accept for a read only workload
> with verify option enabled, we must let the regular flow of
> execution to continue, so that the check if offset > wp is
> performed, so that we will return the address to a new zone,
> rather than an address that is past the wp.
>=20
> Reading past the wp is not a recent bug, it is possible to
> reproduce this bug even before zone capacity was introduced.
>=20
> However, with the introduction of zone capacity, filling a
> zone now only writes up to zone capacity of a zone, making
> it much easier to reproduce this bug.
>=20
> Signed-off-by: Aravind Ramesh <aravind.ramesh@wdc.com>
> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
> ---
> Patch made by Aravind, I simply rewrote the commit message.
>=20
>  zbd.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
>=20
> diff --git a/zbd.c b/zbd.c
> index e4a480b7..92936fe8 100644
> --- a/zbd.c
> +++ b/zbd.c
> @@ -1467,9 +1467,8 @@ enum io_u_action zbd_adjust_block(struct
> thread_data *td, struct io_u *io_u)
>=20
>  	switch (io_u->ddir) {
>  	case DDIR_READ:
> -		if (td->runstate =3D=3D TD_VERIFYING) {
> -			if (td_write(td))
> -				zb =3D zbd_replay_write_order(td, io_u, zb);
> +		if (td->runstate =3D=3D TD_VERIFYING && td_write(td)) {
> +			zb =3D zbd_replay_write_order(td, io_u, zb);
>  			goto accept;
>  		}
>  		/*
> --
> 2.26.2


