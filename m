Return-Path: <prvs=443f8aa95=Damien.LeMoal@wdc.com>
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH 0/8] zbd: Fix initial zone write pointer of regular block
 devices
Date: Tue, 30 Jun 2020 04:53:59 +0000
Message-ID: 
 <CY4PR04MB3751C96E54170346CE125BBBE76F0@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <20200626094331.418309-1-shinichiro.kawasaki@wdc.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

On 2020/06/26 18:43, Shin'ichiro Kawasaki wrote:=0A=
> With zonemode=3Dzbd and regular block devices, fio initializes zone statu=
s as=0A=
> empty. However, write pointers are set not at zone start but at zone end.=
 This=0A=
> inconsistency between write pointer position and zone status caused diffe=
rent=0A=
> behavior of regular block devices from zoned block devices. This patch se=
ries=0A=
> fixes the inconsistency and the behavior gap.=0A=
> =0A=
> The 1st patch fixes the zone status initialization code by setting write=
=0A=
> pointers at zone start. Following patches fixes t/zbd test script to hand=
le=0A=
> regular block devices and zoned block devices in same manner.=0A=
> =0A=
> Shin'ichiro Kawasaki (8):=0A=
>   zbd: Fix initial zone write pointer of regular block devices=0A=
>   t/zbd: Fix pass condition of test case #3=0A=
>   t/zbd: Add write_and_run_one_fio_job() helper function=0A=
>   t/zbd: Combine write and read fio commands for test case #6=0A=
>   t/zbd: Combine write and read fio commands for test case #15=0A=
>   t/zbd: Combine write and read fio commands for test case #16=0A=
>   t/zbd: Remove write before random read/write from test case #17=0A=
>   t/zbd: Enable regular block devices for test case #47=0A=
> =0A=
>  t/zbd/test-zbd-support | 78 +++++++++++++++++++++++-------------------=
=0A=
>  zbd.c                  |  2 +-=0A=
>  2 files changed, 44 insertions(+), 36 deletions(-)=0A=
> =0A=
=0A=
Jens,=0A=
=0A=
I reviewed this series internally with Shin'ichiro before he posted.=0A=
So:=0A=
=0A=
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=

