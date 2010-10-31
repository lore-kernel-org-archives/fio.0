Return-Path: <fio-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([64.244.102.30]:56070 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751962Ab0JaBxV (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 30 Oct 2010 21:53:21 -0400
Message-ID: <4CCCCC11.7010203@fusionio.com>
Date: Sat, 30 Oct 2010 21:53:21 -0400
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
Subject: Re: fio: first direct IO errored
References: <4CCC1540.6090405@xmerlin.org>
In-Reply-To: <4CCC1540.6090405@xmerlin.org>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Christian Zoffoli <czoffoli@xmerlin.org>
Cc: fio@vger.kernel.org

On 2010-10-30 08:53, Christian Zoffoli wrote:
> Hi to all,
> I'm testing a storage (14x300GB) with different RAID levels, volume
> stripe sizes and different blocksizes and numjobs in fio ...but I've
> found a problem testing it with disks in RAID6 configuration.
> 
> here is the command line I've used
> 
> -----
> fio --filename=/dev/dm-0  --direct=1 --group_reporting  --rw=read
> --bs=1k --numjobs=1 --runtime=60  --name="read-bs512-job1"
> -----
> 
> and here is the error:
> 
> -----
> read-bs512-job1: (g=0): rw=read, bs=1K-1K/1K-1K, ioengine=sync, iodepth=1
> Starting 1 process
> fio: first direct IO errored. File system may not support direct IO, or
> iomem_align= is bad.
> fio: pid=4898, err=22/file:engines/sync.c:62, func=xfer, error=Invalid
> argument

So you get -1/EINVAL on the issued IO. For O_DIRECT, this will typically
happen for one (or more) of these reasons:

- The file system doesn't support O_DIRECT, as fio suggests. Since it
  works for your other test, we can safely discount that reason.

- The block size is not a multiple of the block size of the device. I'm
  guessing this is your problem. You are using 1K block sizes, if your
  dm device has a larger block size, then this will not work.

It's not likely to be iomem_align, it's more likely to be due to bs=1k
just being too small for your setup. To be sure, please provide a:

$ grep . /sys/block/dm-0/queue/*

for dm-0.

-- 
Jens Axboe

