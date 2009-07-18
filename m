Return-Path: <fio-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:53251 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751377AbZGRGSU (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 18 Jul 2009 02:18:20 -0400
Date: Sat, 18 Jul 2009 08:18:20 +0200
From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: fio mmap writes much slower than default writes
Message-ID: <20090718061819.GF4148@kernel.dk>
References: <1247751607.2689.63.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1247751607.2689.63.camel@localhost.localdomain>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Richard Kennedy <richard@rsk.demon.co.uk>
Cc: fio <fio@vger.kernel.org>

On Thu, Jul 16 2009, Richard Kennedy wrote:
> Running tests of fio write with sizes that are less than the write cache
> size I'm seeing a big slow down when using mmap. I'm running the tests
> on linux 2.6.31-rc* x86_64. 
> 
> Typical results with default writes :- 
> 
> fio size=300m rw=write 
>   write: io=300MiB, bw=314MiB/s, iops=80,418, runt= 955msec
> 
> with mmap :- 
> 
> fio size=300m rw=write ioengine=mmap
>  write: io=300MiB, bw=55,732KiB/s, iops=13,933, runt= 5512msec
> 
> 
> Is this expected or is it indicative of a problem somewhere?

What does the full job file look like? Is the file cached, or are the
faults reading in data?

-- 
Jens Axboe

