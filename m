Return-Path: <adobriyan@gmail.com>
Return-Path: <adobriyan@gmail.com>
Date: Fri, 27 Mar 2020 22:01:32 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH] fio: add NVMe engine
Message-ID: <20200327190132.GA6316@avx2>
References: <20200326204406.GA29597@avx2>
 <CO2PR04MB2343805A950787DBA0BA18E9E7CC0@CO2PR04MB2343.namprd04.prod.outlook.com>
 <20200327061439.GA2745@avx2>
 <BY5PR04MB6689C6836C345348D8BFFC46FFCC0@BY5PR04MB6689.namprd04.prod.outlook.com>
 <51339d62-debc-5024-11fd-773574f3be6c@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <51339d62-debc-5024-11fd-773574f3be6c@kernel.dk>
To: Jens Axboe <axboe@kernel.dk>
Cc: Keith Busch <Keith.Busch@wdc.com>, Damien Le Moal <Damien.LeMoal@wdc.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On Fri, Mar 27, 2020 at 08:47:08AM -0600, Jens Axboe wrote:
> On 3/27/20 8:25 AM, Keith Busch wrote:
> > On 3/27/20 12:14 AM, Alexey Dobriyan wrote:
> >> On Fri, Mar 27, 2020 at 12:56:00AM +0000, Damien Le Moal wrote:
> >>>
> >>> On 2020/03/27 5:44, Alexey Dobriyan wrote:
> >>>> Add simple iodepth=1 NVMe engine:
> >>>>
> >>>> 	ioengine=nvme
> >>>>
> >>>> It works via standard Linux NVMe ioctls.
> >>> Keith is working on splitting up nvmecli into the cli part and libnvme which
> >>> uses the kernel ioctl iinterface for NVMe command passthrough. So I think it may
> >>> be better to implement ioengine=libnvme using Keith libnvme library. That will
> >>> remove the need to define all the NVMe command stuff here.
> >> Sure. It is just standalone file you can send to colleagues and forget.
> >> Similar to how header-only C++ libraries work.
> >>
> >>>> It will be used for testing upcoming ZNS stuff.
> > 
> > 
> > 
> > I'm not completely against fio providing an nvme ioengine, and libnvme
> > could easily fit in, but I don't think that faithfully represents how
> > these devices are actually used. The passthrough interface is not really
> > our fast path, and being a synchronous interface is a bit limiting in
> > testing device capabilities.
> 
> I guess my main question is what purpose it fills. Since it's not
> a performant interface, it's not a benchmarking thing.
> Hence it's for testing the feature? If so, would it be better to have in
> nvme-cli or a standalone tool?

This engine can easily create QD=NR_CPUS, it is not much but it is something.

Another thing, I've wasted a week (and counting!) struggling with userspace
nvme drivers, they are such a pain. Anything from broken hardware,
to code like this:

	spin_lock()		// sic, before copy_from_user
	copy_from_user(...)	// sic, no checking


It is much easier to implement new commands via passthrough ioctls and
have load/stress testing generator.

