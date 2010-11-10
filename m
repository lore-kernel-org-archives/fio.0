Return-Path: <fio-owner@vger.kernel.org>
Received: from vserver01.sebastiankayser.de ([85.88.7.146]:34625 "EHLO
	vserver01.sebastiankayser.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757196Ab0KJR1Z (ORCPT
	<rfc822;fio@vger.kernel.org>); Wed, 10 Nov 2010 12:27:25 -0500
Date: Wed, 10 Nov 2010 18:18:56 +0100
From: Sebastian Kayser <sebastian@skayser.de>
Subject: Re: IOPS higher than expected on randwrite, direct=1 tests
Message-ID: <20101110171856.GI28050@sebastiankayser.de>
References: <20101109182801.GP15588@sebastiankayser.de> <AANLkTikCz7-myG8JCkG+W44AKbg8DSqFcYUHLLOr_3wu@mail.gmail.com> <20101110082223.GB14261@sebastiankayser.de> <4CDAA783.9050902@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <4CDAA783.9050902@fusionio.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

* Jens Axboe <jaxboe@fusionio.com> wrote:
> On 2010-11-10 09:22, Sebastian Kayser wrote:
> > Just to make sure my understanding is correct:
> > - direct=1 should mitigate (disable?) OS caching effects
> > - sync=1, iodepth=1 should make sure that an I/O has really made it to
> >   disk before the next on is issued, i.e. should de-facto disable
> >   I/O coalescing or device caching
> > 
> > Are these sane/valid assumptions?
> 
> Yes, your assumptions are valid. I think the issue here is that you give
> randwrite, but don't also specify that you want overwrites. So what
> happens is that the file will be truncated and then randomly written,
> allowing the file system to place randomly chosen file block together.
> If you remove the test file and re-run with overwrite=1 added, then see
> if those results are more in line with what you expect.

Thanks for the additional aspect! So the possible pitfall is that w/o
overwrite=1 the test file could be sparse and the file system then
re-arrange random file addresses to fall onto consecutive device blocks?

(If so, wouldn't that be evil / deliberate data fragmentation?)

Tested it again with overwrite=1, same IOPS figures. Test file size as
measured with du -ks is the same in both cases btw. (which combined with
the limited runtime=120 doesn't seem to indicate sparseness in case of
overwrite=0, right?).

What I will do now is to export the whole 2TB of the disk (instead of
just 10GB) and increase size= to see whether that makes any difference
(hopefully). Other than that, further ideas?

Sebastian
