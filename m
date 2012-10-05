Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:51333 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754950Ab2JEJjM (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 5 Oct 2012 05:39:12 -0400
Message-ID: <506EAAB5.6060002@kernel.dk>
Date: Fri, 05 Oct 2012 11:39:01 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: FIO 2.0.9 Windows - Job IOPS limitation
References: <CAOAYhmASWTiFvV7QR2jvJt1QBkfOxA6+B+vXWUBbQq+m7p=x-w@mail.gmail.com>
In-Reply-To: <CAOAYhmASWTiFvV7QR2jvJt1QBkfOxA6+B+vXWUBbQq+m7p=x-w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Keith Orsak <orsak.keith@gmail.com>
Cc: fio@vger.kernel.org

On 2012-10-05 00:32, Keith Orsak wrote:
> OS: Windows 2008 R2 Enterprise Edition
> CPU: Intel X5660 2.8GHz (6-core)
> Memory: 24GB
> Device Under Test: 350GB SLC PCIe 2.0 x8
> 
> I seem to be running into a Job IOPS limitation in Windows.  When I
> run a deep queue (iodepth=66 for example) the IOPS seem to be pegged
> out around 200K.  If I split the iodepth between two jobs I can get
> around 250K IOPS with the device I am testing which is what I would
> expect to see.  Here is the command that I am currently using:
> 
>  fio --filename=\\.\PHYSICALDRIVE1 --ioengine=windowsaio --direct=1
> --rw=randrw --bs=4K --rwmixread=70 --iodepth=66 --randrepeat=0
> --norandommap --name=test --runtime=1000000 --time_based
> --group_reporting
> 
> When I ran two jobs I simply added the numjobs=2 attribute in and
> reduced iodepth to 33.
> 
> This is probably more of an enhancement request than an actual issue
> but having to split the queue between two jobs makes it difficult to
> get datapoints on even numbered queues beyond a certain point.

Depending on how expensive the issue path is on Windows, it's not
unusual to require more than 1 thread/process to drive that number of
IOPS. In other words, this isn't necessarily a problem or limitation of
fio. I'd need to see some profiles to make an educated guess on that.
But it's a universal problem, not something limited to Windows or fio.

You might be able to squeeze some more IOPS out of a single process by
reducing the tracking that fio does. If you set --gtod_reduce=1 then fio
wont do as much time keeping. On the down side, you don't get good
latency statistics. You can also increase the completion batch count to
reduce the number of times you have to reap events, by playing with the
--iodepth_batch_completion setting.

-- 
Jens Axboe

