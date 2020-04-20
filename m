Return-Path: <adobriyan@gmail.com>
Return-Path: <adobriyan@gmail.com>
Date: Mon, 20 Apr 2020 21:10:09 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH v2] zbd: Fix I/O direction adjustment step for random
 read/write
Message-ID: <20200420181009.GA10636@avx2>
References: <20200416113036.28296-1-shinichiro.kawasaki@wdc.com>
 <8acaca2e-d5dc-e091-6579-ebb5e6a55c3b@kernel.dk>
 <20200417173050.GA26921@avx2>
 <BY5PR04MB6900C9B099AAC18008A45597E7D40@BY5PR04MB6900.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <BY5PR04MB6900C9B099AAC18008A45597E7D40@BY5PR04MB6900.namprd04.prod.outlook.com>
To: Damien Le Moal <Damien.LeMoal@wdc.com>
Cc: Jens Axboe <axboe@kernel.dk>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On Mon, Apr 20, 2020 at 02:41:06AM +0000, Damien Le Moal wrote:
> On 2020/04/18 2:31, Alexey Dobriyan wrote:
> > On Fri, Apr 17, 2020 at 08:32:05AM -0600, Jens Axboe wrote:
> >> I'm not a huge fan of this zbd sprinkling everywhere, but that's not the
> >> fault of your fix. But I would really prefer if zbd got disentangled
> >> from the core/hot paths completely, maybe by adding a io engine fn for
> >> whatever it needs to do.
> > 
> > I think it should be done at generator level. zonemode=strided/zbd is
> > really a specialized random generator. Such generator would issue first
> > write in ZBD mode and read/write in normal mode.
> > 
> > zbd_adjust_block() is strange. For example "norandommap" in ZBD mode
> > doesn't guarantee full LBA space coverage even with 1 thread but it
> > would guarantee it with 1 thread and generator which shuffles zone
> > numbers once and issues writes with any QD.
> 
> I do not understand your point here: norandommap does *not* guarantee full block
> space coverage at all, no matter the zonemode=xxx or no zonemode. For guaranteed
> full block space coverage, norandommap should not be specified so that fio keeps
> the history of past accesses, no ?

I always forget which one is which.

Right now adjusting in zbd_adjust_block() doesn't guarantee full LBA
space coverage in cases where deleting "zonemode=" would have done it,
even with 1 thread:

[global]
filename=/dev/loop0	# 1GB
direct=1
zonemode=zbd
zonesize=1M
randseed=1
thread
bs=256K
rw=randwrite
ioengine=libaio
iodepth=1
[j]
max_open_zones=1
size=27M

	t 1     ZR 1
	t 1     ZR 2
	t 1     ZR 3
	t 1     ZR 4
	t 1     ZR 5
	t 1     ZR 6
	t 1     ZR 7
	t 1     ZR 8
	t 1     ZR 9
	t 1     ZR 10
	t 1     ZR 11
	t 1     ZR 12
	t 1     ZR 13
	t 1     ZR 14
	t 1     ZR 15
	t 1     ZR 16
	t 1     ZR 17
	t 1     ZR 18
	t 1     ZR 19
	t 1     ZR 20
	t 1     ZR 21
	t 1     ZR 22
	t 1     ZR 22	<===
	t 1     ZR 23
	t 1     ZR 24
	t 1     ZR 25
	t 1     ZR 26

Non-randomness is separate bug -- "z++" in zbd_convert_to_open_zone().

