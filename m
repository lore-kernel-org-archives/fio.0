Return-Path: <prvs=460a6953b=Damien.LeMoal@wdc.com>
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH v2 0/8] zbd: Fix initial zone write pointer of regular
 block devices
Date: Fri, 17 Jul 2020 02:10:51 +0000
Message-ID: 
 <CY4PR04MB3751E88ACB74D5FA35BFF208E77C0@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <20200715041322.114929-1-shinichiro.kawasaki@wdc.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

On 2020/07/15 13:13, Shin'ichiro Kawasaki wrote:=0A=
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
> Changes from v1:=0A=
> * Added reviewed-by tag=0A=
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
Hi Jens,=0A=
=0A=
Could you please consider taking this series ? Shinichiro zone capacity ser=
ies=0A=
depends on it and we have new blktests cases for the kernel that we like to=
 send=0A=
out too but these will depend on fio supporting zone capacity.=0A=
=0A=
Thanks !=0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=

