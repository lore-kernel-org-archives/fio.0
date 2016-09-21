Return-Path: <axboe@kernel.dk>
Subject: Re: fio SGL support
References: <BN3PR0401MB1457EB6AB90FEEAEA28DF05EF7F70@BN3PR0401MB1457.namprd04.prod.outlook.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <178c9518-4267-37bd-1c28-80dcb29dedb8@kernel.dk>
Date: Tue, 20 Sep 2016 22:03:25 -0600
MIME-Version: 1.0
In-Reply-To: <BN3PR0401MB1457EB6AB90FEEAEA28DF05EF7F70@BN3PR0401MB1457.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
To: Jeff Furlong <jeff.furlong@hgst.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 09/20/2016 12:03 PM, Jeff Furlong wrote:
> Hi All,
> Is it possible to add Scatter Gather List (SGL) support to fio?
> Suppose we have a 16KB write to our device.  I believe fio will
> allocate memory in 4KB pages (depending upon machine architecture).
> For SGL use, it would be valuable to define the SGL descriptors, such
> that we could control the 16KB write as (example): 512B, 3.5KB, 4KB,
> 8KB.  Similarly for reads, we may define the SGL descriptors for how
> to place the IO in memory.

Fio will allocate buffers in multiples of the maximum blocksize
specified in the job. If you ask for bs=16k or similar, then fio will
allocate a virtually contig block of memory that is 16k in length and
properly aligned, if needed.

> If fio SGL support is possible, then the descriptors would be passed
> down to the kernel and driver level, where SGL supported drivers would
> be required.  However, the latest Linux kernels are offering support.

What interface is this?

> If fio SGL support is possible, adding an option such as sglsplit
> (similar to bssplit) may be an easy way to specify the descriptors.

I'm a little puzzled by this. Since fio doesn't deal with physical
addresses, any IO that fio performs can be described by a virtual
address and a total length. That may map to different physical pages in
the case of O_DIRECT, and subsequently an SG list will be needed on the
driver side to describe those pages in a single command.

So you probably have to be a bit more specific here.

-- 
Jens Axboe


