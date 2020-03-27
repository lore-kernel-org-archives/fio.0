Return-Path: <prvs=3488f2eda=Keith.Busch@wdc.com>
From: Keith Busch <Keith.Busch@wdc.com>
Subject: Re: [PATCH] fio: add NVMe engine
Date: Fri, 27 Mar 2020 21:58:09 +0000
Message-ID: 
 <BY5PR04MB6689C30A00737A603DA12DEDFFCC0@BY5PR04MB6689.namprd04.prod.outlook.com>
References: <20200326204406.GA29597@avx2>
 <CO2PR04MB2343805A950787DBA0BA18E9E7CC0@CO2PR04MB2343.namprd04.prod.outlook.com>
 <20200327061439.GA2745@avx2>
 <BY5PR04MB6689C6836C345348D8BFFC46FFCC0@BY5PR04MB6689.namprd04.prod.outlook.com>
 <51339d62-debc-5024-11fd-773574f3be6c@kernel.dk> <20200327190132.GA6316@avx2>
 <3d0d59af-5126-74ef-27c1-ffd97d7bec95@kernel.dk>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>, Alexey Dobriyan <adobriyan@gmail.com>
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 3/27/20 3:25 PM, Jens Axboe wrote:=0A=
> On 3/27/20 1:01 PM, Alexey Dobriyan wrote:=0A=
>> On Fri, Mar 27, 2020 at 08:47:08AM -0600, Jens Axboe wrote:=0A=
>>> On 3/27/20 8:25 AM, Keith Busch wrote=0A=
>>>> I'm not completely against fio providing an nvme ioengine, and libnvme=
=0A=
>>>> could easily fit in, but I don't think that faithfully represents how=
=0A=
>>>> these devices are actually used. The passthrough interface is not real=
ly=0A=
>>>> our fast path, and being a synchronous interface is a bit limiting in=
=0A=
>>>> testing device capabilities.=0A=
>>> I guess my main question is what purpose it fills. Since it's not=0A=
>>> a performant interface, it's not a benchmarking thing.=0A=
>>> Hence it's for testing the feature? If so, would it be better to have i=
n=0A=
>>> nvme-cli or a standalone tool?=0A=
>> This engine can easily create QD=3DNR_CPUS, it is not much but it is som=
ething.=0A=
> Sure, just like any other sync engine can also be somewhat parallel if=0A=
> you just run multiple threads/processes on it. I just don't want people=
=0A=
> to get the idea that it's something that's useful for benchmarking. And=
=0A=
> if it isn't, then what is the point?=0A=
>=0A=
> As I said, I'm not vehemently opposed to the idea of adding the engine,=
=0A=
> because it is just a simple wrapper around the submit ioctl. But it'd be=
=0A=
> nice to have some clear purpose behind it, justifying the inclusion.=0A=
=0A=
=0A=
I think this is the nvme equivalent to the 'sg' ioengine using the =0A=
SG_IO ioctl. I don't think SG_IO is a good benchmarking interface=0A=
either, but if it's useful for something I'm not considering, then I=0A=
guess 'nvme' should have a similar justification.=0A=
=0A=

