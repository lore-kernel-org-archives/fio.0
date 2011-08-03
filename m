Return-Path: <fio-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6151 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755719Ab1HCUWN (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 3 Aug 2011 16:22:13 -0400
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: Measuring IOPS
References: <201107291737.40463.Martin@lichtvoll.de>
	<201108032131.36188.Martin@lichtvoll.de>
Date: Wed, 03 Aug 2011 16:22:08 -0400
In-Reply-To: <201108032131.36188.Martin@lichtvoll.de> (Martin Steigerwald's
	message of "Wed, 3 Aug 2011 21:31:35 +0200")
Message-ID: <x494o1yfdov.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: fio@vger.kernel.org

Martin Steigerwald <Martin@lichtvoll.de> writes:

> - ioengine=libaio
> - direct=1
> - and then due to direct I/O alignment requirement: bsrange=2k-16k
>
> So I now also fully understand that ioengine=sync just refers to the 
> synchronous nature of the system calls used, not on whether the I/Os are 
> issued synchronously via sync=1 or by circumventing the page cache via 
> direct=1
>
> Attached are results that bring down IOPS on read drastically! I first let 
> sequentiell.job write out the complete 2 gb with random data and then ran 
> the iops.job.

If you want to measure the maximum iops, then you should consider
driving iodepths > 1.  Assuming you are testing a sata ssd, try using a
depth of 64 (twice the NCQ depth).

Cheers,
Jeff
