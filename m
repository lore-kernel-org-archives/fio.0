Return-Path: <adobriyan@gmail.com>
Return-Path: <adobriyan@gmail.com>
Date: Fri, 27 Mar 2020 22:06:12 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH] fio: add NVMe engine
Message-ID: <20200327190612.GA7570@avx2>
References: <20200326204406.GA29597@avx2>
 <CO2PR04MB2343805A950787DBA0BA18E9E7CC0@CO2PR04MB2343.namprd04.prod.outlook.com>
 <20200327061439.GA2745@avx2>
 <BY5PR04MB6689C6836C345348D8BFFC46FFCC0@BY5PR04MB6689.namprd04.prod.outlook.com>
 <BY5PR04MB66894E274A6785CADDD23200FFCC0@BY5PR04MB6689.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <BY5PR04MB66894E274A6785CADDD23200FFCC0@BY5PR04MB6689.namprd04.prod.outlook.com>
To: Keith Busch <Keith.Busch@wdc.com>
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On Fri, Mar 27, 2020 at 02:26:41PM +0000, Keith Busch wrote:
> On 3/27/20 8:25 AM, Keith Busch wrote:
> > If you're really going to do it, though, I would recommend not using
> > NVME_IOCTL_SUBMIT_IO, and instead always use the more flexible
> > NVME_IOCTL_SUBMIT_IO.
> 
> 
> Err, that second ioctl should have said "NVME_IOCTL_IO_CMD".

Why? NVME_IOCTL_SUBMIT_IO is so much simpler.
Except trim, when there is no choice.

