Return-Path: <fio-owner@vger.kernel.org>
Received: from [95.166.99.235] ([95.166.99.235]:54006 "EHLO kernel.dk"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753306AbZJaHG5 (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 31 Oct 2009 03:06:57 -0400
Date: Sat, 31 Oct 2009 07:58:45 +0100
From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Every 13 hours sees a spike in fio CPU consumption, and a drop  in   IOPS/throughput
Message-ID: <20091031065845.GV10727@kernel.dk>
References: <f3177b9e0910300820x37a19313te12f1ca48a085c3b@mail.gmail.com> <f3177b9e0910300949r62e057adqd966bca61174e035@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f3177b9e0910300949r62e057adqd966bca61174e035@mail.gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Chris Worley <worleys@gmail.com>
Cc: fio@vger.kernel.org

On Fri, Oct 30 2009, Chris Worley wrote:
> On Fri, Oct 30, 2009 at 9:20 AM, Chris Worley <worleys@gmail.com> wrote:
> > I'm running fio benchmarks for 120 hours:
> >
> > fio --rw=randrw --bs=4k --rwmixread=60 --numjobs=64 --iodepth=64
> > --sync=0 --direct=1 --randrepeat=0 --ioengine=libaio
> > --filename=/dev/sde --filename=/dev/sdf --name=test --loops=10000
> > --size=322122547200 --runtime=432000 --group_reporting
> >
> > The fio threads are generally reporting 100K IOPS and each of the 64
> > fio threads uses less than 10% CPU.
> >
> > But, every 13 hours (nearly to the minute), for ~200 seconds, the FIO
> > threads start consuming large amounts of CPU, and the IOPS drop to
> > ~40K:
> 
> Josh is brilliant:
> 
> (322122547200[bytes per test]*64[threads])/(4096[block
> size]*100000[IOPS]*3600[seconds per hour])=13 hours
> 
> ...it's restarting the next loop and recalculating the random maps
> every 13 hours

Awesome! It should just give it or re-clean the random map, that is
likely where the bug is. Looking forward to a tested patch :-)

-- 
Jens Axboe

