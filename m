Return-Path: <axboe@kernel.dk>
Subject: Re: fio SGL support
References: <BN3PR0401MB1457EB6AB90FEEAEA28DF05EF7F70@BN3PR0401MB1457.namprd04.prod.outlook.com>
 <178c9518-4267-37bd-1c28-80dcb29dedb8@kernel.dk>
 <BN3PR0401MB1457260592FBE961CE812BADF7F60@BN3PR0401MB1457.namprd04.prod.outlook.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <68a183b3-caff-f061-b174-06b7429f9068@kernel.dk>
Date: Wed, 21 Sep 2016 17:26:19 -0600
MIME-Version: 1.0
In-Reply-To: <BN3PR0401MB1457260592FBE961CE812BADF7F60@BN3PR0401MB1457.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
To: Jeff Furlong <jeff.furlong@hgst.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 09/21/2016 05:14 PM, Jeff Furlong wrote:
> I believe kernel 4.8 offers an NVMe over fabrics driver that supports
> SGL descriptors.

This is just NVMe being a bit different from everyone else, basically
all storage drivers use SG lists. This is completely detached from any
application level interface, it's just an artifact of how physical
memory is mapped for DMA and that information is passed to the driver.

> In the case of a 16KB IO that is described as 512B, 3.5KB, 4KB, and
> 8KB, there would be separate data transfers to the device under test
> (such as NVMe over fabrics device).  In the case of a 16KB IO
> allocated as contiguous pages, one large data transfer could be
> sufficient.  Is it possible to force one way or the other with fio
> (assuming the driver has support)?  We could simply use bssplit as
> 512B/3.5KB/4KB/8KB, but then the 8KB might actually be on
> noncontiguous pages, in which case it could really end up as
> 512B/3.5KB/4KB/4KB/4KB.

I'm still confused, honestly I don't see the point of this at all. Fio
makes no attempt to allocate (nor can it) physical pages, so we can't
control how this memory ends up being laid out. The best we can do is
align buffers to the same offset as their length, assuming we then get
pages mapped that are physical contiguous. This will reduce the required
number of SG elements on the driver side. 'iomem_align' will align the
IO buffers to the given alignment. If you do:

bssplit=512B/3.5KB/4KB/8KB
iomem_align=8k

then ANY IO buffer will be aligned to 8k, and 8k in length, even if we
only do shorter transfers to it.

I hope that explains it.

-- 
Jens Axboe


