Return-Path: <fio-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([64.244.102.31]:52056 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757577Ab1COUzu (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 15 Mar 2011 16:55:50 -0400
Message-ID: <4D7FD24F.1020307@fusionio.com>
Date: Tue, 15 Mar 2011 21:55:43 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
Subject: Re: memory caching
References: <C9A519EC.108B4%hussein@cscs.ch>,<4D7FCBDE.2080206@fusionio.com> <8512BC127909424EB483ED236E6AC3C003D6E6@MBX20.d.ethz.ch>
In-Reply-To: <8512BC127909424EB483ED236E6AC3C003D6E6@MBX20.d.ethz.ch>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "N. Harake" <hussein@cscs.ch>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 2011-03-15 21:46, N. Harake wrote:
> 
> Thanks for your reply, indeed my interest to get the max iops but on a
> filesystem not a raw device, I understand the penalty but that would
> be more realstic for production systems. I will try these changes and
> keep you updated .

It's always a good idea to do the raw block device test first, that'll
at least give you an idea of the best possible result. On a file system,
you'll get the best results with O_DIRECT if the file has been
pre-allocated first. Otherwise you end up punting to buffered IO for
filling new blocks.

So that would mean adding --overwrite=1. And get rid of the O_SYNC. If
your workload will utilize lots of processes or threads, use what you
already have with a high numjobs. But an libaio with fewer threads and
higher depth will get you better performance.

-- 
Jens Axboe

