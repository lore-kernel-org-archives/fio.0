Return-Path: <fio-owner@vger.kernel.org>
Received: from vserver01.sebastiankayser.de ([85.88.7.146]:41703 "EHLO
	vserver01.sebastiankayser.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753723Ab0KKQa5 (ORCPT
	<rfc822;fio@vger.kernel.org>); Thu, 11 Nov 2010 11:30:57 -0500
Date: Thu, 11 Nov 2010 17:22:22 +0100
From: Sebastian Kayser <sebastian@skayser.de>
Subject: Re: IOPS higher than expected on randwrite, direct=1 tests
Message-ID: <20101111162222.GO28050@sebastiankayser.de>
References: <20101109182801.GP15588@sebastiankayser.de> <AANLkTikCz7-myG8JCkG+W44AKbg8DSqFcYUHLLOr_3wu@mail.gmail.com> <20101110082223.GB14261@sebastiankayser.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20101110082223.GB14261@sebastiankayser.de>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

* Sebastian Kayser <sebastian@skayser.de> wrote:
> Just to make sure my understanding is correct:
> - direct=1 should mitigate (disable?) OS caching effects
> - sync=1, iodepth=1 should make sure that an I/O has really made it to
>   disk before the next on is issued, i.e. should de-facto disable
>   I/O coalescing or device caching
> 
> Are these sane/valid assumptions?

Shawn Lewis sent me an email off-list and suggested that the disk itself
will still do write-caching (despite O_SYNC) unless this has been
explicitly disabled. I dug into the storage configuration and found an
option which sounded promising ("Drive Delayed Write", not to be confused
with the RAID controller write cache which was disabled from the start).
Disabled the delayed writes and the IOPS went down from ~240 to

* ~100 for a filesystem test (size=100g out of 2TB)
* ~110 for a raw device test

Still a bit more than I would expect [1], but definitely closer. I am not
sure whether this can be brought down any further, i.e. whether there's
another caching effect hidden somwhere or if these figures now actually
reflect the "raw" harddisk performance.

Either way, I am surprised how much gain in IOPS a simple hard drive cache
delivers ... and I am also very grateful for all the suggestions so far!
Thanks guys!

Sebastian

[1] http://www.spinics.net/lists/fio/msg00558.html
