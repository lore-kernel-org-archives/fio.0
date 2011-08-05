Return-Path: <fio-owner@vger.kernel.org>
Received: from [95.166.99.235] ([95.166.99.235]:32792 "EHLO kernel.dk"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752166Ab1HEH2Z (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 5 Aug 2011 03:28:25 -0400
Message-ID: <4E3B9B9A.9010302@kernel.dk>
Date: Fri, 05 Aug 2011 09:28:26 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Measuring IOPS
References: <201107291737.40463.Martin@lichtvoll.de> <201108041134.33127.Martin@lichtvoll.de> <4E3A6E34.8080300@kernel.dk> (sfid-20110804_120722_728257_3A80A489) <201108041223.55605.Martin@lichtvoll.de>
In-Reply-To: <201108041223.55605.Martin@lichtvoll.de>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: Jeff Moyer <jmoyer@redhat.com>, fio@vger.kernel.org

On 2011-08-04 12:23, Martin Steigerwald wrote:
>> Not quite measuring RAM (or copy) performance, at some point fio will
>> be blocked by the OS and prevented from dirtying more memory. At that
>> point it'll either just wait, or participate in flushing out dirty
>> data. For any buffered write workload, it'll quickly de-generate into
>> that.
> 
> Which depends on the size of the job, cause I for bet 1 GB/s with 250000 
> IOPS I need some PCI express based SSD solution - a SATA-300 SSD like the 
> Intel SSD 320 in use here can´t reach this (see attached file). It seems 

Right, you'll need something state-of-the-art to reach those numbers,
and nothing on a SATA/SAS bus will be able to do that. Latencies and
transport overhead are just too large.

> with 8 GB of RAM I need more than one GB to write in order to get 
> meaningful results (related to raw SSD performance). With Ext4 delayed 
> allocation a subsequent rm might even cause the file to not be written at 
> all.

Depending on the kernel, some percentage of total memory dirty will kick
off background writing. Some higher percentage will kick off direct
reclaim. So yes, the usual rule of thumb for buffered write performance
is that the job size should be at least twice that of RAM to yield
usable results.

> For the application side of thing it can make perfect sense to measure 
> buffered writes. But one should go with a large enough data set in order to 
> get meaningful results. At least when the application uses a large dataset 
> too ;).

Indeed.

-- 
Jens Axboe

