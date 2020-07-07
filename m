Return-Path: <prvs=450fc09ef=shinichiro.kawasaki@wdc.com>
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: Re: [PATCH 0/8] zbd: Fix initial zone write pointer of regular block
 devices
Date: Tue, 7 Jul 2020 01:00:18 +0000
Message-ID: <20200707010018.kh3nnkldg23toq6i@shindev.dhcp.fujisawa.hgst.com>
References: <20200626094331.418309-1-shinichiro.kawasaki@wdc.com>
 <CY4PR04MB3751C96E54170346CE125BBBE76F0@CY4PR04MB3751.namprd04.prod.outlook.com>
In-Reply-To: 
 <CY4PR04MB3751C96E54170346CE125BBBE76F0@CY4PR04MB3751.namprd04.prod.outlook.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E559B68E85359044B23B2AD5C9D281D2@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Damien Le Moal <Damien.LeMoal@wdc.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

On Jun 30, 2020 / 04:53, Damien Le Moal wrote:
> On 2020/06/26 18:43, Shin'ichiro Kawasaki wrote:
> > With zonemode=3Dzbd and regular block devices, fio initializes zone sta=
tus as
> > empty. However, write pointers are set not at zone start but at zone en=
d. This
> > inconsistency between write pointer position and zone status caused dif=
ferent
> > behavior of regular block devices from zoned block devices. This patch =
series
> > fixes the inconsistency and the behavior gap.
> >=20
> > The 1st patch fixes the zone status initialization code by setting writ=
e
> > pointers at zone start. Following patches fixes t/zbd test script to ha=
ndle
> > regular block devices and zoned block devices in same manner.
> >=20
> > Shin'ichiro Kawasaki (8):
> >   zbd: Fix initial zone write pointer of regular block devices
> >   t/zbd: Fix pass condition of test case #3
> >   t/zbd: Add write_and_run_one_fio_job() helper function
> >   t/zbd: Combine write and read fio commands for test case #6
> >   t/zbd: Combine write and read fio commands for test case #15
> >   t/zbd: Combine write and read fio commands for test case #16
> >   t/zbd: Remove write before random read/write from test case #17
> >   t/zbd: Enable regular block devices for test case #47
> >=20
> >  t/zbd/test-zbd-support | 78 +++++++++++++++++++++++-------------------
> >  zbd.c                  |  2 +-
> >  2 files changed, 44 insertions(+), 36 deletions(-)
> >=20
>=20
> Jens,
>=20
> I reviewed this series internally with Shin'ichiro before he posted.
> So:
>=20
> Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>

Hi Jens, could you consider to merge this series to the upstream?
It will make zonemode=3Dzbd implementation less confusing.

--=20
Best Regards,
Shin'ichiro Kawasaki=

