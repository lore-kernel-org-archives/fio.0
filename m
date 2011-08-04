Return-Path: <fio-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:43580 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751216Ab1HDHut (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 4 Aug 2011 03:50:49 -0400
Message-ID: <4E3A4F55.3050003@fusionio.com>
Date: Thu, 4 Aug 2011 09:50:45 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
Subject: Re: Measuring IOPS
References: <201107291737.40463.Martin@lichtvoll.de> <201108032131.36188.Martin@lichtvoll.de> <x494o1yfdov.fsf@segfault.boston.devel.redhat.com> (sfid-20110803_222903_776209_B9762BAA) <201108032233.52591.Martin@lichtvoll.de>
In-Reply-To: <201108032233.52591.Martin@lichtvoll.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: Jeff Moyer <jmoyer@redhat.com>, fio@vger.kernel.org

On 2011-08-03 22:33, Martin Steigerwald wrote:
> Am Mittwoch, 3. August 2011 schrieb Jeff Moyer:
>> Martin Steigerwald <Martin@lichtvoll.de> writes:
>>> - ioengine=libaio
>>> - direct=1
>>> - and then due to direct I/O alignment requirement: bsrange=2k-16k
>>>
>>> So I now also fully understand that ioengine=sync just refers to the
>>> synchronous nature of the system calls used, not on whether the I/Os
>>> are issued synchronously via sync=1 or by circumventing the page
>>> cache via direct=1
>>>
>>> Attached are results that bring down IOPS on read drastically! I
>>> first let sequentiell.job write out the complete 2 gb with random
>>> data and then ran the iops.job.
>>
>> If you want to measure the maximum iops, then you should consider
>> driving iodepths > 1.  Assuming you are testing a sata ssd, try using a
>> depth of 64 (twice the NCQ depth).
> 
> Yes, I thought about that too, but then also read about the 
> "recommendation" to use an iodepth of one in a post here:
> 
> http://www.spinics.net/lists/fio/msg00502.html
> 
> What will be used in regular workloads - say Linux desktop on an SSD here? 
> I would bet that Linux uses what it can get? What about server workloads 
> like mail processing on SAS disks or fileserver on SATA disks and such 
> like?
> 
> 
> Twice of
> 
> merkaba:~> hdparm -I /dev/sda | grep -i queue
>         Queue depth: 32
>            *    Native Command Queueing (NCQ)
> 
> ?
> 
> Why twice?

Twice is a good rule of thumb, since it allows both the drive some
freedom for scheduling to reduce rotational latencies, but it also
allows the OS to work on a larger range of requests. This is beneficial
mostly for merging of sequential requests, but also for scheduling
purposes.

So at least depth + a_few, 2*depth is a good default.

-- 
Jens Axboe

