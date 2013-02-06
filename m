Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:47477 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751707Ab3BFNLd (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 6 Feb 2013 08:11:33 -0500
Date: Wed, 6 Feb 2013 14:10:31 +0100
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: Simulating Real Random I/O with FIO
Message-ID: <20130206131031.GT15092@kernel.dk>
References: <843E15216120C047928F6879B0E2D9240F6E5583@SACEXCMBX02-PRD.hq.netapp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <843E15216120C047928F6879B0E2D9240F6E5583@SACEXCMBX02-PRD.hq.netapp.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Neto, Antonio Jose Rodrigues" <Antonio.Jose.Rodrigues.Neto@netapp.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On Mon, Feb 04 2013, Neto, Antonio Jose Rodrigues wrote:
> Hi All,
> 
> This is neto from Brazil
> 
> How are you?
> 
> I am doing a performance POC and I need to simulate 100% true random workload. I am using Fibre Channel and Windows 2008R2.
> 
> I have 8 LUNs (125GB each) and my configuration file is:
> 
> [workload]
> bs=8k
> ioengine=windowsaio
> iodepth=3
> numjobs=35
> direct=1
> runtime=120
> size=1024g
> filename=\\.\PhysicalDrive1
> filename=\\.\PhysicalDrive2
> filename=\\.\PhysicalDrive3
> filename=\\.\PhysicalDrive4
> filename=\\.\PhysicalDrive5
> filename=\\.\PhysicalDrive6
> filename=\\.\PhysicalDrive7
> filename=\\.\PhysicalDrive8
> zonesize=1024m
> zoneskip=3g
> rw=randrw
> rwmixread=80
> rwmixwrite=20
> thread
> unified_rw_reporting=1
> group_reporting=1
> randrepeat=0
> norandommap
> 
> Questions:
> 
> 1) I am assuming the working set is the size parameter that is 1TB. Is
> that correct?

Correct

> 2) What is the correlaction of the zonesize and zoneskip with the
> randomness? Adding those will help with the randomness of the workload
> or not? 

Your setting of zonesize=1g, skip=3g, will do random read/write within a
1gb zone (so from 0-1G initially), then move to the next zone (3G-4G),
etc. For a rotating drive, this will mean shorter seeks, since while it
is doing one zone, it will only seek within that zone.

> 3) If I use zonesize=1024m and zoneskip=3g I have like 100K IOPS
> (coming from cache not disks) and if I use zonesize=10g and
> zoneskip=26g I have more realistic numbers. Could someone explain
> which is the a good example to use zonesize and zoneskip?

Depends on what you want, really. With zonesize=10g, you are now seeking
in a 10x wider area than you were before.

> 4) Is it possible with fio to specify per disk randomness area: For
> example: disk1 - start blocks 456 till blocks 3456, disk2 - start
> blocks 4567 to 103456

You'd have to use different jobs. You above example uses 8 disks and
accesses them from all 35 jobs. You could split it a bit, so that you
have 8 sections, each accessing one disk. You could have 4 jobs in each
section, giving you a total of 32 jobs. Then you can set offset/size for
each job separately.

-- 
Jens Axboe

