Return-Path: <adobriyan@gmail.com>
Return-Path: <adobriyan@gmail.com>
Date: Fri, 27 Mar 2020 09:14:39 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH] fio: add NVMe engine
Message-ID: <20200327061439.GA2745@avx2>
References: <20200326204406.GA29597@avx2>
 <CO2PR04MB2343805A950787DBA0BA18E9E7CC0@CO2PR04MB2343.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CO2PR04MB2343805A950787DBA0BA18E9E7CC0@CO2PR04MB2343.namprd04.prod.outlook.com>
To: Damien Le Moal <Damien.LeMoal@wdc.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>, Keith Busch <Keith.Busch@wdc.com>
List-ID: <fio@vger.kernel.org>

On Fri, Mar 27, 2020 at 12:56:00AM +0000, Damien Le Moal wrote:
> Alexey,
> 
> Adding Keith to this thread.
> 
> On 2020/03/27 5:44, Alexey Dobriyan wrote:
> > Add simple iodepth=1 NVMe engine:
> > 
> > 	ioengine=nvme
> > 
> > It works via standard Linux NVMe ioctls.
> 
> Keith is working on splitting up nvmecli into the cli part and libnvme which
> uses the kernel ioctl iinterface for NVMe command passthrough. So I think it may
> be better to implement ioengine=libnvme using Keith libnvme library. That will
> remove the need to define all the NVMe command stuff here.

Sure. It is just standalone file you can send to colleagues and forget.
Similar to how header-only C++ libraries work.

> > It will be used for testing upcoming ZNS stuff.
> 
> libnvme will have this support too. But you will also need the ioengine to be
> able to plug into the zonemode=zbd to avoid a lot of nightmares on how to avoid
> unailigned write errors with various workloads.

I'm not sure what do you mean.

IO generation is already aware about zonemode=zbd, so it is a matter of
making DDIR_APPEND first class citizen and making sure all engines which
support it fixup ->offset after completion so that verification knows
where did the data go.

> I have a series almost ready to
> go out (in testing right now) to do just that for a new libzbc IO engine. This
> IO engine is for passthrough to SMR drives, for the exact same use case, namely,
> testing drives on kernels that do not have zoned block device support (e.g. a
> lot of customers in the field use old-ish enterprise distros with 3.x kernels
> where zoned block devices are not supported).

> > Currently Linux doesn't recognize NVMe ZNS devices as zoned block
> > devices so zone ioctls (BLKRESETZONE et al) can't be used.
> 
> Patches for that are ready to go out as soon as the ZNS TP is approved :)

OK. I stumbled across this mess in blktrace while researching Append :^)

	BLK_TC_END      = 1 << 15,      /* only 16-bits, reminder */

> > Passthrough ioctls should allow Zone Append and whatever commands
> > new specs bring.
> 
> Yes, but we will need a new rw= control for that one though as implementing
> verify for it will not be trivial (data location on the device and write issuing
> offset relation is lost with zone append).
> 
> > 
> > Support read, write, fsync, fdatasync.
> > Don't support sync_file_range obviously.
> > Don't support trim for now, until I figure all qemu options and
> > the story behind broken qemu trim support.
> 
> Using Keith's libnvme can probably simplify support for all of this.

