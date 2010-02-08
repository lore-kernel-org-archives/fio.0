Return-Path: <fio-owner@vger.kernel.org>
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:37195 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751106Ab0BHWKf (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 8 Feb 2010 17:10:35 -0500
Date: Mon, 8 Feb 2010 23:10:33 +0100
From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: libaio ioengine cause initiator crash
Message-ID: <20100208221033.GW1025@kernel.dk>
References: <600237.15205.qm@web80807.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <600237.15205.qm@web80807.mail.mud.yahoo.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: charles zhuang <cjiazhuang@yahoo.com>
Cc: fio@vger.kernel.org

On Mon, Feb 08 2010, charles zhuang wrote:
> Hi,
> I am using fio libaio ioengine to benchmark on stgt iser target stack (http://stgt.sourceforge.net/). I found out that using bs size at 2k and under (2k, 1k, 512) keeps causing the iser initiator crash at different places. The initiator kernel stack dump at various places, with some of them has aio_* call involved. Most of the oops message looks like:
> Oops: 0000 [1] SMP
> last sysfs file: /block/sdb/stat
> ...
> 
> The easiest way I can produce this problem is after the initiator log in to iser stack, run following command from initiator (where /dev/sdb is the exported disk from target):
> > fio --rw=read --bs=2k --numjobs=32 --iodepth=64 --sync=0 --direct=1 --randrepeat=0 --group_reporting --ioengine=libaio --filename=/dev/sdb --name=test --loops=100 --size=524288000 --runtime=30 --softrandommap=1
> 
> If I change "--bw=2k" to "--bs=4k" and over, it runs fine.
> 
> Initially I am only looking at the iser target (stgt) side. But now I suspect it's something to do with the initiator page coherency size, which I believe is 4k. 
> 
> Jens and other,  can you provide some insights for this? Thanks for any help.

It's crashing in the kernel, so it should be reported as a kernel issue.
If you include the full oops in a reply, I can take a look.

If stgt is restricted to page size transfers, then it should set the
hardware block size to that (which would then cause fio with 2k bs and
O_DIRECT to error out, instead of crash).

-- 
Jens Axboe

