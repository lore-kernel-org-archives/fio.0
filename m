Return-Path: <fio-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([64.244.102.30]:35636 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753636Ab1BHM6q (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 8 Feb 2011 07:58:46 -0500
Message-ID: <4D513E42.2030508@fusionio.com>
Date: Tue, 8 Feb 2011 13:59:46 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
Subject: Re: FIO is CPU bound on small block sizes
References: <AANLkTimVOrLR+MJDhg5Q=vfLvNKbfP4H6i3iJNjxPgpe@mail.gmail.com>
In-Reply-To: <AANLkTimVOrLR+MJDhg5Q=vfLvNKbfP4H6i3iJNjxPgpe@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Bike & Snow <bikeandsnow@googlemail.com>
Cc: fio@vger.kernel.org

On 2011-02-08 11:30, Bike & Snow wrote:
> Hello
> 
> I am trying to measure IOPs on a RAID system using FIO.
> 
> I've been using FIO for a while and I'm pretty familiar with it.
> 
> However, I have found for small blocksizes, the benchmark is CPU bound
> as it only works on a single CPU core.
> 
> Here's what I mean. All these are sequential read results.
> 
> Iometer results:
> 512B	181,317
> 1K		166,232
> 2K		133,753
> 4K		109,498
> 8K		 78,276
> 16K		 51,638
> 
> FIO results:
> 512B	 97,494
> 1K		100,034
> 2K		 98,615
> 4K		 93,859
> 8K		 83,064
> 16K		 69,623
> 
> I can see when observing the output from "top" that the "fio" thread
> is at 99% for the smaller block sizes.
> So it appears to be CPU bound for small block sizes - 512B to 4K.
> From 8K onwards FIO is actually faster than Iometer.
> 
> Software:
> Linux 2.6.36.3
> FIO 1.50
> Iometer 1.1.0
> 
> Hardware:
> Intel Xeon X3450 @ 2.67GHz
> Hardware RAID6 array
> 
> FIO command used:
> fio -name iops -rw=read -bs=512 -runtime=180 -iodepth 4 -filename
> /dev/storage/iometer -ioengine libaio -direct=1
> 
> As you can see I'm testing the block device directly without using a
> file system.
> 
> I have tried different iodepth values but it makes no difference.
> 
> Any ideas on how I can measure the IOPs of the RAID device when using
> small block sizes?

Are you sure you are comparing the same IO pattern? One way to reduce
the fio overhead is to reduce the time keepnig that it does, in case
that isn't of interest here. Add --gtod_reduce=1 for that. Submit and
complete more in one batch, add --iodepth_batch_submit=2
--iodepth_batch_complete=2 for that for instance.

-- 
Jens Axboe

