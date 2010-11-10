Return-Path: <fio-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([64.244.102.30]:54545 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755816Ab0KJOJM (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 10 Nov 2010 09:09:12 -0500
Message-ID: <4CDAA783.9050902@fusionio.com>
Date: Wed, 10 Nov 2010 15:09:07 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
Subject: Re: IOPS higher than expected on randwrite, direct=1 tests
References: <20101109182801.GP15588@sebastiankayser.de> <AANLkTikCz7-myG8JCkG+W44AKbg8DSqFcYUHLLOr_3wu@mail.gmail.com> <20101110082223.GB14261@sebastiankayser.de>
In-Reply-To: <20101110082223.GB14261@sebastiankayser.de>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sebastian Kayser <sebastian@skayser.de>
Cc: fio@vger.kernel.org

On 2010-11-10 09:22, Sebastian Kayser wrote:
> Hi John,
> 
> * John Cagle <jcagle@gmail.com> wrote:
>> Is your iSCSI target also in a virtual machine?  If so, maybe the
>> hypervisor (vmware? kvm?) is caching the 10GB volume that is being
>> used by the iSCSI target?
> 
> thanks for answering. No hypervisor involved on the iSCSI target, it's
> an oldish Infortrend storage [1] for which I am trying to determine the
> performance profile. Anything else along the stack that might skew the
> test results?
> 
> Just to make sure my understanding is correct:
> - direct=1 should mitigate (disable?) OS caching effects
> - sync=1, iodepth=1 should make sure that an I/O has really made it to
>   disk before the next on is issued, i.e. should de-facto disable
>   I/O coalescing or device caching
> 
> Are these sane/valid assumptions?

Yes, your assumptions are valid. I think the issue here is that you give
randwrite, but don't also specify that you want overwrites. So what
happens is that the file will be truncated and then randomly written,
allowing the file system to place randomly chosen file block together.
If you remove the test file and re-run with overwrite=1 added, then see
if those results are more in line with what you expect.

-- 
Jens Axboe

