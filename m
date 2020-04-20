Return-Path: <prvs=372e0bcef=Damien.LeMoal@wdc.com>
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH v2] zbd: Fix I/O direction adjustment step for random
 read/write
Date: Mon, 20 Apr 2020 02:33:37 +0000
Message-ID: 
 <BY5PR04MB6900A20781B7EFE381D8533AE7D40@BY5PR04MB6900.namprd04.prod.outlook.com>
References: <20200416113036.28296-1-shinichiro.kawasaki@wdc.com>
 <8acaca2e-d5dc-e091-6579-ebb5e6a55c3b@kernel.dk>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
List-ID: <fio@vger.kernel.org>

Jens,=0A=
=0A=
On 2020/04/17 23:32, Jens Axboe wrote:=0A=
> On 4/16/20 5:30 AM, Shin'ichiro Kawasaki wrote:=0A=
>> Commit fb0259fb ("zbd: Ensure first I/O is write for random read/write t=
o=0A=
>> sequential zones") introduced a step to change direction of io_u from=0A=
>> read to write when that is the first I/O of the random read/write=0A=
>> workload to zoned block devices. However, such direction adjustment=0A=
>> results in inconsistent I/O length when read block size and write block=
=0A=
>> size are different.=0A=
>>=0A=
>> To avoid the inconsistency between I/O direction and I/O length,=0A=
>> adjust the I/O direction before the I/O length is set. Move the step=0A=
>> from zbd_adjust_block() to set_rw_ddir(). To minimize changes in=0A=
>> set_rw_ddir(), introduce zbd_adjust_ddir() helper function.=0A=
> =0A=
> I'm not a huge fan of this zbd sprinkling everywhere, but that's not the=
=0A=
> fault of your fix. But I would really prefer if zbd got disentangled=0A=
> from the core/hot paths completely, maybe by adding a io engine fn for=0A=
> whatever it needs to do. At least that reduces the hot path overhead to=
=0A=
> check a pointer and calling that function instead of having various=0A=
> checks here and there.=0A=
=0A=
Understood. We will work on that.=0A=
=0A=
> =0A=
> Really not great to have a somewhat esoteric feature like zbd support=0A=
> add _any_ overhead to the hot path at all.=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=

