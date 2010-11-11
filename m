Return-Path: <fio-owner@vger.kernel.org>
Received: from vserver01.sebastiankayser.de ([85.88.7.146]:43254 "EHLO
	vserver01.sebastiankayser.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754572Ab0KKRwH (ORCPT
	<rfc822;fio@vger.kernel.org>); Thu, 11 Nov 2010 12:52:07 -0500
Date: Thu, 11 Nov 2010 18:43:29 +0100
From: Sebastian Kayser <sebastian@skayser.de>
Subject: Re: IOPS higher than expected on randwrite, direct=1 tests
Message-ID: <20101111174329.GQ28050@sebastiankayser.de>
References: <20101109182801.GP15588@sebastiankayser.de> <AANLkTikCz7-myG8JCkG+W44AKbg8DSqFcYUHLLOr_3wu@mail.gmail.com> <20101110082223.GB14261@sebastiankayser.de> <4CDAA783.9050902@fusionio.com> <20101110171856.GI28050@sebastiankayser.de> <4CDAF701.8000301@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <4CDAF701.8000301@fusionio.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

* Jens Axboe <jaxboe@fusionio.com> wrote:
> On 2010-11-10 18:18, Sebastian Kayser wrote:
> > Thanks for the additional aspect! So the possible pitfall is that w/o
> > overwrite=1 the test file could be sparse and the file system then
> > re-arrange random file addresses to fall onto consecutive device blocks?
> > 
> > (If so, wouldn't that be evil / deliberate data fragmentation?)
> 
> Depends on whether you care about the write performance or the read-back
> performance :-)

Point taken. :) Out of curiousity, do file systems actually do this?
Sounds like write-once-read-seldom or an assumption of: random data
that's being written during the same time will likely be read back
simultaneously at another point in time.

Sebastian
