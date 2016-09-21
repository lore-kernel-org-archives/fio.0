Return-Path: <fio-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:26933 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756259AbcIUXPC (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 21 Sep 2016 19:15:02 -0400
From: Jeff Furlong <jeff.furlong@hgst.com>
Subject: RE: fio SGL support
Date: Wed, 21 Sep 2016 23:14:59 +0000
Message-ID: <BN3PR0401MB1457260592FBE961CE812BADF7F60@BN3PR0401MB1457.namprd04.prod.outlook.com>
References: <BN3PR0401MB1457EB6AB90FEEAEA28DF05EF7F70@BN3PR0401MB1457.namprd04.prod.outlook.com>
 <178c9518-4267-37bd-1c28-80dcb29dedb8@kernel.dk>
In-Reply-To: <178c9518-4267-37bd-1c28-80dcb29dedb8@kernel.dk>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>

I believe kernel 4.8 offers an NVMe over fabrics driver that supports SGL d=
escriptors.

In the case of a 16KB IO that is described as 512B, 3.5KB, 4KB, and 8KB, th=
ere would be separate data transfers to the device under test (such as NVMe=
 over fabrics device).  In the case of a 16KB IO allocated as contiguous pa=
ges, one large data transfer could be sufficient.  Is it possible to force =
one way or the other with fio (assuming the driver has support)?  We could =
simply use bssplit as 512B/3.5KB/4KB/8KB, but then the 8KB might actually b=
e on noncontiguous pages, in which case it could really end up as  512B/3.5=
KB/4KB/4KB/4KB.

Thanks.

Regards,
Jeff

-----Original Message-----
From: Jens Axboe [mailto:axboe@kernel.dk]=20
Sent: Tuesday, September 20, 2016 9:03 PM
To: Jeff Furlong <jeff.furlong@hgst.com>; fio@vger.kernel.org
Subject: Re: fio SGL support

On 09/20/2016 12:03 PM, Jeff Furlong wrote:
> Hi All,
> Is it possible to add Scatter Gather List (SGL) support to fio?
> Suppose we have a 16KB write to our device.  I believe fio will=20
> allocate memory in 4KB pages (depending upon machine architecture).
> For SGL use, it would be valuable to define the SGL descriptors, such=20
> that we could control the 16KB write as (example): 512B, 3.5KB, 4KB,=20
> 8KB.  Similarly for reads, we may define the SGL descriptors for how=20
> to place the IO in memory.

Fio will allocate buffers in multiples of the maximum blocksize specified i=
n the job. If you ask for bs=3D16k or similar, then fio will allocate a vir=
tually contig block of memory that is 16k in length and properly aligned, i=
f needed.

> If fio SGL support is possible, then the descriptors would be passed=20
> down to the kernel and driver level, where SGL supported drivers would=20
> be required.  However, the latest Linux kernels are offering support.

What interface is this?

> If fio SGL support is possible, adding an option such as sglsplit=20
> (similar to bssplit) may be an easy way to specify the descriptors.

I'm a little puzzled by this. Since fio doesn't deal with physical addresse=
s, any IO that fio performs can be described by a virtual address and a tot=
al length. That may map to different physical pages in the case of O_DIRECT=
, and subsequently an SG list will be needed on the driver side to describe=
 those pages in a single command.

So you probably have to be a bit more specific here.

--
Jens Axboe

