Return-Path: <prvs=534d22b8c=Damien.LeMoal@wdc.com>
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH 0/3] v1 Patchset : Zone Explicit Open support
Date: Tue, 29 Sep 2020 16:32:09 +0000
Message-ID: 
 <MWHPR04MB37581FE01B73A6A0ECB9DEBAE7320@MWHPR04MB3758.namprd04.prod.outlook.com>
References: 
 <CGME20200929130315epcas5p4e6a11cc77fb06a64c31e57740d2e0e31@epcas5p4.samsung.com>
 <20200929125950.20343-1-krish.reddy@samsung.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Krishna Kanth Reddy <krish.reddy@samsung.com>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 2020/09/29 22:03, Krishna Kanth Reddy wrote:=0A=
> 1. Added a new FIO option zone_open.=0A=
> 	When it is enabled, Zones will be opened explicitly before sending I/Os.=
=0A=
> 2. Add support for open_zones in libzbc I/O engine=0A=
> 3. t/zbd: Add support to verify Zone Explicit Open=0A=
> =0A=
> This is a RFC.=0A=
> Feedback / Comments will help in improving this further.=0A=
=0A=
My main question is why ? There is no performance benefit on the drive side=
 from=0A=
doing explicit zone open. On the contrary, performance may go down due to t=
he=0A=
added command overhead. So why do this ? What is your goal ?=0A=
=0A=
Using the max_open_zones=3DN option, fio writes will be limited to a set of=
 N=0A=
zones, implicitly open, until the zones are full (not open anymore) and new=
=0A=
zones chosen (becoming implicitly open with writes). Adding explicit zone o=
pen=0A=
will not give you anything more with this option used. And if you do not us=
e it,=0A=
performance with random writes will significantly go down.=0A=
=0A=
So please try to give convincing reasons for this.=0A=
=0A=
> =0A=
> Ankit Kumar (2):=0A=
>   Add support for Explicit open zones=0A=
>   Add support for open_zones in libzbc I/O engine.=0A=
> =0A=
> Krishna Kanth Reddy (1):=0A=
>   t/zbd: Add support to verify Zone Explicit Open=0A=
> =0A=
>  HOWTO                       | 13 ++++++++=0A=
>  engines/libzbc.c            | 42 +++++++++++++++++++++++++=0A=
>  engines/skeleton_external.c | 12 ++++++++=0A=
>  fio.1                       | 11 +++++++=0A=
>  ioengines.h                 |  2 ++=0A=
>  options.c                   | 20 ++++++++++++=0A=
>  oslib/blkzoned.h            |  7 +++++=0A=
>  oslib/linux-blkzoned.c      | 26 ++++++++++++++++=0A=
>  t/zbd/test-zbd-support      | 27 ++++++++++++++++=0A=
>  thread_options.h            |  7 +++++=0A=
>  zbd.c                       | 61 +++++++++++++++++++++++++++++++++++++=
=0A=
>  11 files changed, 228 insertions(+)=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=

