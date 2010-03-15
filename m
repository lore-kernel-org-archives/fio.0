Return-Path: <fio-owner@vger.kernel.org>
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:39394 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936780Ab0COVWU (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 15 Mar 2010 17:22:20 -0400
Date: Mon, 15 Mar 2010 22:22:19 +0100
From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Does fio write only 0x00s?
Message-ID: <20100315212219.GQ5768@kernel.dk>
References: <4B9E9D92.80701@arvin.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B9E9D92.80701@arvin.dk>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Troels Arvin <troels@arvin.dk>
Cc: fio@vger.kernel.org

On Mon, Mar 15 2010, Troels Arvin wrote:
> Hello,
>
> I'm benchmarking a new FC-attached storage system which we are bringing  
> into production, in order to see if it yields acceptable performance -  
> and to have a baseline for potential performance trouble in the future.
>
> One of the tools I'm using is fio, which is certainly great. Especially  
> the fact that it includes data regarding latencies, and that it makes it  
> easy to have a mix of reads and writes.
>
> Now, compared to an another FC-attached storage system, and compared to  
> a local RAID10, the new system yields fio numbers which are extremely  
> much better.
> This made me have a quick and superficial look into the files which fio  
> works with. I seems that the files contain only 0-bytes.
>
> Does fio only write bytes with a single value?
> If so: I would be afraid that some kind of  
> compression/de-duplication/thin provisioning feature in the storage  
> system invalidates the fio results I'm seeing. Is this a valid fear?

By default, fio will at init time randomly fill the buffer of the
allocated IO units. If you are using the sync io engine, then only one
buffer will be allocated and that will be repeatedly written. So yes,
that'll compress very nicely. You can enable refill_buffers=1 and
that'll cause fio to randomly fill it everytime it's submitted instead.
That should effectively disable compression at the storage end.

But you should not be seeing zeroes only. Are you perhaps sparsely
filling a file with random writes, and you are observing the holes?

-- 
Jens Axboe

