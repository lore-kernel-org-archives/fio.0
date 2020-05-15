Return-Path: <prvs=39755164c=Damien.LeMoal@wdc.com>
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH v2 0/7] Assorted bug fixes and improvements
Date: Fri, 15 May 2020 04:43:16 +0000
Message-ID: 
 <BY5PR04MB69006C6CD35B078945FEBBF6E7BD0@BY5PR04MB6900.namprd04.prod.outlook.com>
References: <20200508075645.543890-1-damien.lemoal@wdc.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: "fio@vger.kernel.org" <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

On 2020/05/08 16:56, Damien Le Moal wrote:=0A=
> The first 3 patches of this series fix bugs with write_iolog option=0A=
> initialization (crash on initialization failure) and with zonemode=3Dzbd=
=0A=
> (one possible deadlock for read workloads and an assert trigerring with=
=0A=
> verify option enabled).=0A=
> =0A=
> The following 4 patches are cleanups and improvements of zbd_xxx()=0A=
> functions to reduce unnecessary overhead when zonemode=3Dzbd is not used.=
=0A=
> =0A=
> Comments are welcome !=0A=
> =0A=
> * Changes from v1:=0A=
>   - Dropped the patches introducing file and thread zbd function=0A=
>     pointers. Further reducing the overhead on fio core due to the=0A=
>     presence of zbd_xxx() functions will require major code surgery.=0A=
>     Until then, the new patches 4, 5 and 6 provide smaller improvements.=
=0A=
>   - Added patch 7 to improve tests execution time.=0A=
> =0A=
> Damien Le Moal (7):=0A=
>   iolog: Fix write_iolog_close()=0A=
>   zbd: Fix potential deadlock on read operations=0A=
>   zbd: Fix read with verify=0A=
>   zbd: Optimize zbd_file_reset()=0A=
>   zbd: Rename zbd_init()=0A=
>   io_u: Optimize set_rw_ddir()=0A=
>   t/zbd: Use max-jobs=3D16 option=0A=
> =0A=
>  filesetup.c            |  4 ++--=0A=
>  io_u.c                 |  3 ++-=0A=
>  iolog.c                |  3 +++=0A=
>  t/zbd/test-zbd-support |  4 ++--=0A=
>  zbd.c                  | 22 +++++++++-------------=0A=
>  zbd.h                  |  8 +++++++-=0A=
>  6 files changed, 25 insertions(+), 19 deletions(-)=0A=
> =0A=
=0A=
Jens,=0A=
=0A=
Any comment on this series ?=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=

