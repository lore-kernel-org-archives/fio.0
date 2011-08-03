Return-Path: <fio-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:39053 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753621Ab1HCUdy (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 3 Aug 2011 16:33:54 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: Measuring IOPS
Date: Wed, 3 Aug 2011 22:33:52 +0200
References: <201107291737.40463.Martin@lichtvoll.de> <201108032131.36188.Martin@lichtvoll.de> <x494o1yfdov.fsf@segfault.boston.devel.redhat.com> (sfid-20110803_222903_776209_B9762BAA)
In-Reply-To: <x494o1yfdov.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108032233.52591.Martin@lichtvoll.de>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jeff Moyer <jmoyer@redhat.com>
Cc: fio@vger.kernel.org

Am Mittwoch, 3. August 2011 schrieb Jeff Moyer:
> Martin Steigerwald <Martin@lichtvoll.de> writes:
> > - ioengine=libaio
> > - direct=1
> > - and then due to direct I/O alignment requirement: bsrange=2k-16k
> > 
> > So I now also fully understand that ioengine=sync just refers to the
> > synchronous nature of the system calls used, not on whether the I/Os
> > are issued synchronously via sync=1 or by circumventing the page
> > cache via direct=1
> > 
> > Attached are results that bring down IOPS on read drastically! I
> > first let sequentiell.job write out the complete 2 gb with random
> > data and then ran the iops.job.
> 
> If you want to measure the maximum iops, then you should consider
> driving iodepths > 1.  Assuming you are testing a sata ssd, try using a
> depth of 64 (twice the NCQ depth).

Yes, I thought about that too, but then also read about the 
"recommendation" to use an iodepth of one in a post here:

http://www.spinics.net/lists/fio/msg00502.html

What will be used in regular workloads - say Linux desktop on an SSD here? 
I would bet that Linux uses what it can get? What about server workloads 
like mail processing on SAS disks or fileserver on SATA disks and such 
like?


Twice of

merkaba:~> hdparm -I /dev/sda | grep -i queue
        Queue depth: 32
           *    Native Command Queueing (NCQ)

?

Why twice?

Thanks,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
