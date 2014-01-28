Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:60349 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755162AbaA1R0M (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 28 Jan 2014 12:26:12 -0500
Date: Tue, 28 Jan 2014 10:26:09 -0700
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: A bug in combining fsrange and verify
Message-ID: <20140128172609.GL20264@kernel.dk>
References: <CAOpYm_W685AkEuFnNZX-m0Jfq+B+crzQv5oEF_Hbvq3XbABhaQ@mail.gmail.com>
 <20140127192215.GF2782@kernel.dk>
 <CAOpYm_WNfhkyFRofHg6aUfm_nxL7oX8gCc++wNFMproqP1rVeA@mail.gmail.com>
 <20140127224603.GM2782@kernel.dk>
 <20140127230339.GN2782@kernel.dk>
 <CANEJEGspxdmAAhRCS7hiQeeFAOmSg9+ZwnZ_wcROji-9zE9tAg@mail.gmail.com>
 <20140127233116.GO2782@kernel.dk>
 <CANEJEGsfPUTzV4iwkYCDY1xwagW8uW+nimBzLOLDt2uzZHPGYg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANEJEGsfPUTzV4iwkYCDY1xwagW8uW+nimBzLOLDt2uzZHPGYg@mail.gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Grant Grundler <grundler@chromium.org>
Cc: Wallence Lu <wallencelu@gmail.com>, FIO_list <fio@vger.kernel.org>

On Mon, Jan 27 2014, Grant Grundler wrote:
> On Mon, Jan 27, 2014 at 3:31 PM, Jens Axboe <axboe@kernel.dk> wrote:
> ...
> >> > Works for me with the 2.1.4 release. It's actually broken in current
> >> > -git, due to the numberio patches..
> >>
> >> You mean all of the "verify_only" support patches or specifically this patch:
> >>
> >> commit da0a7bd224bb9331f27bb4b20394dd5c8fa3acb0
> >> Author: Juan Casse <jcasse@chromium.org>
> >> Date:   Tue Sep 17 14:06:12 2013 -0700
> >>
> >>     Adds check for numberio during verify phase.
> >>
> >> I can take a look at this tomorrow... let me see if I have the job
> >> file in another email.
> >
> > It looks like it's actually catching the issue, when I take a closer
> > look.
> 
> OH. Got it. :)  Good. Had me worried for a moment.

But another bug has been uncovered. If you run this:

[global]
filename=fio.ver
loops=10
verify=crc32

[random-rw]
size=31457280
rw=randrw

fio will complain about unmatched seeds in later iterations...


> BTW, it looks like there is also a bug in "random_pattern_fill"
> support. When specifying verify_pattern the problem went away.  See
> this bug:
>     https://code.google.com/p/chromium/issues/detail?id=337651
> 
> my workaround is here:
>     https://chromium-review.googlesource.com/#/c/183813/
> 
> (should probably start a new thread for that)

Please do :-)

> 
> > I'm afraid there might be overlapping ranges for bsrange=.
> 
> I can reproduce with fio-2.1.2 + verify_only patches (output below).
> It's always a 512 byte long corruption which in fact would suggest
> "off-by-one" overlapping ranges.

Note that the print is actually wrong. It's verifying in extents of 512,
but does verify the whole thing. But yes, there's a bug there, but the
length print is not correct.


-- 
Jens Axboe

