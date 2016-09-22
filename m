Return-Path: <jeff.furlong@hgst.com>
From: Jeff Furlong <jeff.furlong@hgst.com>
Subject: RE: fio SGL support
Date: Thu, 22 Sep 2016 00:05:28 +0000
Message-ID: <BN3PR0401MB14576D1DAF30A35B29BF1583F7C90@BN3PR0401MB1457.namprd04.prod.outlook.com>
References: <BN3PR0401MB1457EB6AB90FEEAEA28DF05EF7F70@BN3PR0401MB1457.namprd04.prod.outlook.com>
 <178c9518-4267-37bd-1c28-80dcb29dedb8@kernel.dk>
 <BN3PR0401MB1457260592FBE961CE812BADF7F60@BN3PR0401MB1457.namprd04.prod.outlook.com>
 <68a183b3-caff-f061-b174-06b7429f9068@kernel.dk>
In-Reply-To: <68a183b3-caff-f061-b174-06b7429f9068@kernel.dk>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
To: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

The motivation for the application (fio) to allocate physical pages is real=
ly about performance.  If the IO size is more extreme, say 1MB, then descri=
ptors of 512B each vs 1MB each means potentially many DMAs.  All of those D=
MAs can really change performance.  =


The iomem_align seems workable.  My understanding now is that in the case o=
f:

bssplit=3D512B/3.5KB/4KB/8KB
iomem_align=3D8k

then all bs buffers are 8KB aligned, and there is a best effort (up to kern=
el) to have the 8KB buffer have two physically contiguous pages (assuming 4=
KB physical page size on host).  In the case above, the 512B/3.5KB/4KB bs o=
nly use (DMA) one page of the 8KB iomem_align.

In the case of the extreme 1MB IO size, we can use bssplit and iomem_align =
to cause 512B DMAs.  However, we have probably low probability that we coul=
d cause a 1MB DMA.  I'm guessing the odds of the kernel allocating a 1MB re=
gion of physically contiguous pages (4KB each) are small, especially for io=
depth times.  But, I think that's more of the extreme usage.

Thanks for the help.

Regards,
Jeff

-----Original Message-----
From: fio-owner@vger.kernel.org [mailto:fio-owner@vger.kernel.org] On Behal=
f Of Jens Axboe
Sent: Wednesday, September 21, 2016 4:26 PM
To: Jeff Furlong <jeff.furlong@hgst.com>; fio@vger.kernel.org
Subject: Re: fio SGL support

On 09/21/2016 05:14 PM, Jeff Furlong wrote:
> I believe kernel 4.8 offers an NVMe over fabrics driver that supports =

> SGL descriptors.

This is just NVMe being a bit different from everyone else, basically all s=
torage drivers use SG lists. This is completely detached from any applicati=
on level interface, it's just an artifact of how physical memory is mapped =
for DMA and that information is passed to the driver.

> In the case of a 16KB IO that is described as 512B, 3.5KB, 4KB, and =

> 8KB, there would be separate data transfers to the device under test =

> (such as NVMe over fabrics device).  In the case of a 16KB IO =

> allocated as contiguous pages, one large data transfer could be =

> sufficient.  Is it possible to force one way or the other with fio =

> (assuming the driver has support)?  We could simply use bssplit as =

> 512B/3.5KB/4KB/8KB, but then the 8KB might actually be on =

> noncontiguous pages, in which case it could really end up as =

> 512B/3.5KB/4KB/4KB/4KB.

I'm still confused, honestly I don't see the point of this at all. Fio make=
s no attempt to allocate (nor can it) physical pages, so we can't control h=
ow this memory ends up being laid out. The best we can do is align buffers =
to the same offset as their length, assuming we then get pages mapped that =
are physical contiguous. This will reduce the required number of SG element=
s on the driver side. 'iomem_align' will align the IO buffers to the given =
alignment. If you do:

bssplit=3D512B/3.5KB/4KB/8KB
iomem_align=3D8k

then ANY IO buffer will be aligned to 8k, and 8k in length, even if we only=
 do shorter transfers to it.

I hope that explains it.

--
Jens Axboe

--
To unsubscribe from this list: send the line "unsubscribe fio" in the body =
of a message to majordomo@vger.kernel.org More majordomo info at  http://vg=
er.kernel.org/majordomo-info.html
Western Digital Corporation (and its subsidiaries) E-mail Confidentiality N=
otice & Disclaimer:

This e-mail and any files transmitted with it may contain confidential or l=
egally privileged information of WDC and/or its affiliates, and are intende=
d solely for the use of the individual or entity to which they are addresse=
d. If you are not the intended recipient, any disclosure, copying, distribu=
tion or any action taken or omitted to be taken in reliance on it, is prohi=
bited. If you have received this e-mail in error, please notify the sender =
immediately and delete the e-mail in its entirety from your system.


