Return-Path: <prvs=361d12291=Damien.LeMoal@wdc.com>
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH] zbd: fix sequential verify with max_open_zones=1
Date: Thu, 9 Apr 2020 22:41:01 +0000
Message-ID: 
 <BY5PR04MB6900D077D39EEAF4AE35809FE7C10@BY5PR04MB6900.namprd04.prod.outlook.com>
References: <20200408221652.GA2592@avx2>
 <BY5PR04MB6900B4F8DFDDBB498EDA8768E7C10@BY5PR04MB6900.namprd04.prod.outlook.com>
 <20200409171401.GA3220@avx2>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 2020/04/10 2:14, Alexey Dobriyan wrote:=0A=
> On Thu, Apr 09, 2020 at 01:58:13AM +0000, Damien Le Moal wrote:=0A=
>> On 2020/04/09 7:16, Alexey Dobriyan wrote:=0A=
>>> Sequential write with max_open_zones=3D1 has interesting (read: buggy)=
=0A=
>>> interaction with verify=3D.=0A=
> =0A=
>>> +				if (f->zbd_info->open_zones[i] =3D=3D nz) {=0A=
>>> +					zbd_close_zone(td, f, i);=0A=
>>> +				}=0A=
>>=0A=
>> nit: you do not need the {} brackets for the if here.=0A=
> =0A=
> I started to use {} everywhere, it is less thinking that way.=0A=
=0A=
Sure, but that is not the coding style normally used in fio and many other =
open=0A=
source C projects. I will let Jens decide here.=0A=
=0A=
> =0A=
>> With the nits above fixed, this looks OK to me.=0A=
>>=0A=
>> It would be good to add a test case for this to t/zbd/test-zbd-support. =
Can you=0A=
>> send something please ?=0A=
> =0A=
> I'll try. This needs a test with blktrace parsing and eveything.=0A=
=0A=
That sounds like an overkill. Can't we use the debug output (debug=3Dzbd) f=
or=0A=
checking ? If that does not work, let's not add a test that complicates the=
 test=0A=
setup.=0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=

