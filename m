Return-Path: <prvs=3488f2eda=Keith.Busch@wdc.com>
From: Keith Busch <Keith.Busch@wdc.com>
Subject: Re: [PATCH] fio: add NVMe engine
Date: Fri, 27 Mar 2020 14:25:17 +0000
Message-ID: 
 <BY5PR04MB6689C6836C345348D8BFFC46FFCC0@BY5PR04MB6689.namprd04.prod.outlook.com>
References: <20200326204406.GA29597@avx2>
 <CO2PR04MB2343805A950787DBA0BA18E9E7CC0@CO2PR04MB2343.namprd04.prod.outlook.com>
 <20200327061439.GA2745@avx2>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>, Damien Le Moal <Damien.LeMoal@wdc.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 3/27/20 12:14 AM, Alexey Dobriyan wrote:=0A=
> On Fri, Mar 27, 2020 at 12:56:00AM +0000, Damien Le Moal wrote:=0A=
>>=0A=
>> On 2020/03/27 5:44, Alexey Dobriyan wrote:=0A=
>>> Add simple iodepth=3D1 NVMe engine:=0A=
>>>=0A=
>>> 	ioengine=3Dnvme=0A=
>>>=0A=
>>> It works via standard Linux NVMe ioctls.=0A=
>> Keith is working on splitting up nvmecli into the cli part and libnvme w=
hich=0A=
>> uses the kernel ioctl iinterface for NVMe command passthrough. So I thin=
k it may=0A=
>> be better to implement ioengine=3Dlibnvme using Keith libnvme library. T=
hat will=0A=
>> remove the need to define all the NVMe command stuff here.=0A=
> Sure. It is just standalone file you can send to colleagues and forget.=
=0A=
> Similar to how header-only C++ libraries work.=0A=
>=0A=
>>> It will be used for testing upcoming ZNS stuff.=0A=
=0A=
=0A=
=0A=
I'm not completely against fio providing an nvme ioengine, and libnvme=0A=
could easily fit in, but I don't think that faithfully represents how=0A=
these devices are actually used. The passthrough interface is not really=0A=
our fast path, and being a synchronous interface is a bit limiting in=0A=
testing device capabilities.=0A=
=0A=
=0A=
If you need to test ZNS features, it would be more worthwhile to wire=0A=
that up through an existing proper syscall rather than going through the=0A=
driver's ioctl interface. Just my $.02.=0A=
=0A=
=0A=
If you're really going to do it, though, I would recommend not using=0A=
NVME_IOCTL_SUBMIT_IO, and instead always use the more flexible=0A=
NVME_IOCTL_SUBMIT_IO.=0A=
=0A=

