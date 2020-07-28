Return-Path: <prvs=471db6e92=Damien.LeMoal@wdc.com>
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH 0/3] v3 Patchset : Zone Append command support
Date: Tue, 28 Jul 2020 23:23:36 +0000
Message-ID: 
 <CY4PR04MB3751DB16A53AACB265DDDF91E7730@CY4PR04MB3751.namprd04.prod.outlook.com>
References: 
 <CGME20200728124000epcas5p4fa4a9eed2e1f8d3e20f36ede60a63708@epcas5p4.samsung.com>
 <20200728123655.30780-1-krish.reddy@samsung.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Krishna Kanth Reddy <krish.reddy@samsung.com>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 2020/07/28 21:40, Krishna Kanth Reddy wrote:=0A=
> This is a v3 Patchset for the Zone Append command support=0A=
> The v1 Pull Request is https://github.com/axboe/fio/pull/1021=0A=
> The v2 Pull Request is https://github.com/axboe/fio/pull/1026=0A=
> =0A=
> Review comments for the v2 Patchset have been taken care of in the v3 Pat=
chset.=0A=
> Corresponding Linux Kernel Patchset for the Zone Append command support :=
=0A=
> https://lore.kernel.org/linux-block/1595605762-17010-1-git-send-email-jos=
hi.k@samsung.com/=0A=
> =0A=
> 1. Added a new FIO option zone_append.=0A=
> 	When zone_append option is enabled, for Zone mode ZBD,=0A=
> 	the existing write path will send Zone Append command with offset as sta=
rt of the Zone.=0A=
> 2. libaio: support for Zone Append command in libaio IO engine=0A=
> 3. t/zbd: Add support to verify Zone Append command with libaio IO engine=
 tests=0A=
> =0A=
> This is a RFC and the Linux Kernel io_uring interface is being discussed =
in the LKML.=0A=
> io_uring engine's Zone Append command support will be submitted for revie=
w after the kernel interface is finalized.=0A=
> =0A=
> Feedback / Comments will help in improving this further.=0A=
=0A=
Krishna,=0A=
=0A=
The kernel side interface for zone append to raw block devices is not yet s=
orted=0A=
out. That interface needs to be fixed first and we can then think of fio=0A=
patching. Without a clear idea of what the kernel interface and its semanti=
c=0A=
will be, I do not think that commenting on your current code will be useful=
.=0A=
=0A=
> =0A=
> Ankit Kumar (2):=0A=
>   Add Zone Append command support=0A=
>   libaio: support for Zone Append command=0A=
> =0A=
> Krishna Kanth Reddy (1):=0A=
>   t/zbd: Add support to verify Zone Append command with libaio tests=0A=
> =0A=
>  HOWTO                  |  7 +++++++=0A=
>  engines/libaio.c       | 32 ++++++++++++++++++++++++++++----=0A=
>  fio.1                  |  7 +++++++=0A=
>  ioengines.c            |  6 ++++++=0A=
>  ioengines.h            |  3 ++-=0A=
>  options.c              | 10 ++++++++++=0A=
>  t/zbd/test-zbd-support | 29 +++++++++++++++++++++++++++++=0A=
>  thread_options.h       |  2 ++=0A=
>  8 files changed, 91 insertions(+), 5 deletions(-)=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=

