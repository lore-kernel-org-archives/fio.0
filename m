Return-Path: <prvs=3488f2eda=Keith.Busch@wdc.com>
From: Keith Busch <Keith.Busch@wdc.com>
Subject: Re: [PATCH] fio: add NVMe engine
Date: Fri, 27 Mar 2020 14:26:41 +0000
Message-ID: 
 <BY5PR04MB66894E274A6785CADDD23200FFCC0@BY5PR04MB6689.namprd04.prod.outlook.com>
References: <20200326204406.GA29597@avx2>
 <CO2PR04MB2343805A950787DBA0BA18E9E7CC0@CO2PR04MB2343.namprd04.prod.outlook.com>
 <20200327061439.GA2745@avx2>
 <BY5PR04MB6689C6836C345348D8BFFC46FFCC0@BY5PR04MB6689.namprd04.prod.outlook.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>, Damien Le Moal <Damien.LeMoal@wdc.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 3/27/20 8:25 AM, Keith Busch wrote:=0A=
> If you're really going to do it, though, I would recommend not using=0A=
> NVME_IOCTL_SUBMIT_IO, and instead always use the more flexible=0A=
> NVME_IOCTL_SUBMIT_IO.=0A=
=0A=
=0A=
Err, that second ioctl should have said "NVME_IOCTL_IO_CMD".=0A=
=0A=

