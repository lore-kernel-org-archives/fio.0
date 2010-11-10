Return-Path: <fio-owner@vger.kernel.org>
Received: from vserver01.sebastiankayser.de ([85.88.7.146]:36417 "EHLO
	vserver01.sebastiankayser.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753015Ab0KJIav (ORCPT
	<rfc822;fio@vger.kernel.org>); Wed, 10 Nov 2010 03:30:51 -0500
Date: Wed, 10 Nov 2010 09:22:23 +0100
From: Sebastian Kayser <sebastian@skayser.de>
Subject: Re: IOPS higher than expected on randwrite, direct=1 tests
Message-ID: <20101110082223.GB14261@sebastiankayser.de>
References: <20101109182801.GP15588@sebastiankayser.de> <AANLkTikCz7-myG8JCkG+W44AKbg8DSqFcYUHLLOr_3wu@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <AANLkTikCz7-myG8JCkG+W44AKbg8DSqFcYUHLLOr_3wu@mail.gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi John,

* John Cagle <jcagle@gmail.com> wrote:
> Is your iSCSI target also in a virtual machine?  If so, maybe the
> hypervisor (vmware? kvm?) is caching the 10GB volume that is being
> used by the iSCSI target?

thanks for answering. No hypervisor involved on the iSCSI target, it's
an oldish Infortrend storage [1] for which I am trying to determine the
performance profile. Anything else along the stack that might skew the
test results?

Just to make sure my understanding is correct:
- direct=1 should mitigate (disable?) OS caching effects
- sync=1, iodepth=1 should make sure that an I/O has really made it to
  disk before the next on is issued, i.e. should de-facto disable
  I/O coalescing or device caching

Are these sane/valid assumptions?

Sebastian

[1] http://www.infortrend.com/main/2_product/es_a16e-g2130-4.asp
