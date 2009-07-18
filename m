Return-Path: <fio-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:38816 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752062AbZGROj4 (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 18 Jul 2009 10:39:56 -0400
Date: Sat, 18 Jul 2009 16:39:55 +0200
From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: fio mmap writes much slower than default writes
Message-ID: <20090718143955.GJ4148@kernel.dk>
References: <1247751607.2689.63.camel@localhost.localdomain> <20090718061819.GF4148@kernel.dk> <1247925507.2712.11.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1247925507.2712.11.camel@localhost.localdomain>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Richard Kennedy <richard@rsk.demon.co.uk>
Cc: fio <fio@vger.kernel.org>

On Sat, Jul 18 2009, Richard Kennedy wrote:
> Disk stats (read/write):
>   dm-0: ios=3571/9894, merge=0/0, ticks=25884/31650, in_queue=511733, util=96.46%, aggrios=0/0, aggrmerge=0/0, aggrticks=0/0, aggrin_queue=0, aggrutil=0.00%

If you look at the disk stats, it also shows a considerable amount of
reads. So I'm guessing that you need pre_read=1 to get the same sort of
results.

-- 
Jens Axboe

