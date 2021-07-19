Return-Path: <prvs=827efda90=Damien.LeMoal@wdc.com>
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH 00/11] Improve libaio IO priority support
Date: Mon, 19 Jul 2021 03:24:27 +0000
Message-ID: 
 <DM6PR04MB7081F4A4644DCE721C6B0575E7E19@DM6PR04MB7081.namprd04.prod.outlook.com>
References: <20210706001743.10818-1-damien.lemoal@wdc.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: "fio@vger.kernel.org" <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc: Bart Van Assche <bvanassche@acm.org>
List-ID: <fio@vger.kernel.org>

On 2021/07/06 9:17, Damien Le Moal wrote:=0A=
> This series improves libaio engine support for IO priority, adding=0A=
> options to allow for mixed priority workloads to be specified more=0A=
> easily and to match the kernel supported IO priority features.=0A=
> =0A=
> The first 3 patches are small cleanup and fixes in the manpage and=0A=
> fiograph tool.=0A=
> =0A=
> Patch 4 and 5 introduce some helper functions to simplify the code in=0A=
> the followup patches.=0A=
> =0A=
> Patch 6 changes the cmdprio_percentage option to allow specifying=0A=
> different percentages for reads and writes.=0A=
> =0A=
> Patch 7 and 8 introduce the aioprioclass, aioprio and aioprio_bssplit.=0A=
> These together allow a script to specify different IO priorities for=0A=
> reads and writes of different sizes with different percentages.=0A=
> =0A=
> Patch 9 relaxes restrictions on the cmdprio_percentage option to allow=0A=
> jobs to execute AIOs using a default priority as set with ioprio_set()=0A=
> (as the kernel supports this).=0A=
> =0A=
> Patch 10 introduces the log_prio option to log each IO priority value,=0A=
> allowing users to do per-priority level performance analysis with=0A=
> complex workloads using many jobs.=0A=
> =0A=
> Finally, patch 11 adds a couple of example scripts to illustrate the use=
=0A=
> of the new options introduced.=0A=
> =0A=
> Comments are as always most welcome.=0A=
=0A=
Hi Jens,=0A=
=0A=
Any comment on this series ? We have been using this for a while now intern=
ally=0A=
and in the field to test ATA NCQ priority with good results. I am also plan=
ning=0A=
to re-use this to add support for the Command Duration Limits feature (ATA =
&=0A=
SCSI) using a new priority class (kernel patching cooking, but this will ne=
ed=0A=
some more time as the specifications must stabilize first.=0A=
=0A=
One thing that can be considered missing with this series is a full set of=
=0A=
per-priority level statistics (IOPS, BW, etc). But that is a major change a=
nd so=0A=
this is not talked here.=0A=
=0A=
> =0A=
> Damien Le Moal (11):=0A=
>   manpage: fix formatting=0A=
>   manpage: fix definition of prio and prioclass options=0A=
>   tools: fiograph: do not overwrite input script file=0A=
>   os: introduce ioprio_value() helper=0A=
>   options: make parsing functions available to ioengines=0A=
>   libaio,io_uring: improve cmdprio_percentage option=0A=
>   libaio: introduce aioprio and aioprioclass options=0A=
>   libaio: introduce aioprio_bssplit=0A=
>   libaio: relax cdmprio_percentage constraints=0A=
>   fio: Introduce the log_prio option=0A=
>   examples: add libaio priority use examples=0A=
> =0A=
>  HOWTO                            |  57 +++++++--=0A=
>  backend.c                        |   1 +=0A=
>  cconv.c                          |   2 +=0A=
>  client.c                         |   2 +=0A=
>  engines/filecreate.c             |   2 +-=0A=
>  engines/filedelete.c             |   2 +-=0A=
>  engines/filestat.c               |   2 +-=0A=
>  engines/io_uring.c               |  33 +++--=0A=
>  engines/libaio.c                 | 210 ++++++++++++++++++++++++++++---=
=0A=
>  eta.c                            |   2 +-=0A=
>  examples/aio-prio-bssplit.fio    |  17 +++=0A=
>  examples/aio-prio-bssplit.png    | Bin 0 -> 48709 bytes=0A=
>  examples/aio-prio-percentage.fio |  17 +++=0A=
>  examples/aio-prio-percentage.png | Bin 0 -> 48752 bytes=0A=
>  fio.1                            |  76 ++++++++---=0A=
>  fio.h                            |   5 +=0A=
>  init.c                           |   4 +=0A=
>  io_u.c                           |  14 ++-=0A=
>  io_u.h                           |  10 +-=0A=
>  iolog.c                          |  45 +++++--=0A=
>  iolog.h                          |  16 ++-=0A=
>  options.c                        |  50 ++++----=0A=
>  os/os-android.h                  |  24 ++--=0A=
>  os/os-dragonfly.h                |   1 +=0A=
>  os/os-linux.h                    |  24 ++--=0A=
>  os/os.h                          |   4 +=0A=
>  server.h                         |   3 +-=0A=
>  stat.c                           |  75 +++++------=0A=
>  stat.h                           |   9 +-=0A=
>  thread_options.h                 |  20 +++=0A=
>  tools/fiograph/fiograph.conf     |   4 +-=0A=
>  tools/fiograph/fiograph.py       |   4 +-=0A=
>  32 files changed, 574 insertions(+), 161 deletions(-)=0A=
>  create mode 100644 examples/aio-prio-bssplit.fio=0A=
>  create mode 100644 examples/aio-prio-bssplit.png=0A=
>  create mode 100644 examples/aio-prio-percentage.fio=0A=
>  create mode 100644 examples/aio-prio-percentage.png=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=

