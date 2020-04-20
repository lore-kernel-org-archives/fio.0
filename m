Return-Path: <prvs=372e0bcef=Damien.LeMoal@wdc.com>
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH v2] zbd: Fix I/O direction adjustment step for random
 read/write
Date: Mon, 20 Apr 2020 02:41:06 +0000
Message-ID: 
 <BY5PR04MB6900C9B099AAC18008A45597E7D40@BY5PR04MB6900.namprd04.prod.outlook.com>
References: <20200416113036.28296-1-shinichiro.kawasaki@wdc.com>
 <8acaca2e-d5dc-e091-6579-ebb5e6a55c3b@kernel.dk>
 <20200417173050.GA26921@avx2>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>, Jens Axboe <axboe@kernel.dk>
Cc: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 2020/04/18 2:31, Alexey Dobriyan wrote:=0A=
> On Fri, Apr 17, 2020 at 08:32:05AM -0600, Jens Axboe wrote:=0A=
>> I'm not a huge fan of this zbd sprinkling everywhere, but that's not the=
=0A=
>> fault of your fix. But I would really prefer if zbd got disentangled=0A=
>> from the core/hot paths completely, maybe by adding a io engine fn for=
=0A=
>> whatever it needs to do.=0A=
> =0A=
> I think it should be done at generator level. zonemode=3Dstrided/zbd is=
=0A=
> really a specialized random generator. Such generator would issue first=
=0A=
> write in ZBD mode and read/write in normal mode.=0A=
> =0A=
> zbd_adjust_block() is strange. For example "norandommap" in ZBD mode=0A=
> doesn't guarantee full LBA space coverage even with 1 thread but it=0A=
> would guarantee it with 1 thread and generator which shuffles zone=0A=
> numbers once and issues writes with any QD.=0A=
=0A=
I do not understand your point here: norandommap does *not* guarantee full =
block=0A=
space coverage at all, no matter the zonemode=3Dxxx or no zonemode. For gua=
ranteed=0A=
full block space coverage, norandommap should not be specified so that fio =
keeps=0A=
the history of past accesses, no ?=0A=
=0A=
> =0A=
> But the combinatorial explosion given the number of options scaries me.=
=0A=
> And then things will become even more entertaining once QD > 1 zone appen=
ds=0A=
> start to show up!=0A=
=0A=
Indeed, zone append will be hard to support if we also want to have --verif=
y=0A=
working, which is I think mandatory. But we need the kernel interface first=
. Not=0A=
there yet.=0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=

