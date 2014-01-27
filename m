Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:40942 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753679AbaA0XbV (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 27 Jan 2014 18:31:21 -0500
Date: Mon, 27 Jan 2014 16:31:16 -0700
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: A bug in combining fsrange and verify
Message-ID: <20140127233116.GO2782@kernel.dk>
References: <CAOpYm_W685AkEuFnNZX-m0Jfq+B+crzQv5oEF_Hbvq3XbABhaQ@mail.gmail.com>
 <20140127192215.GF2782@kernel.dk>
 <CAOpYm_WNfhkyFRofHg6aUfm_nxL7oX8gCc++wNFMproqP1rVeA@mail.gmail.com>
 <20140127224603.GM2782@kernel.dk>
 <20140127230339.GN2782@kernel.dk>
 <CANEJEGspxdmAAhRCS7hiQeeFAOmSg9+ZwnZ_wcROji-9zE9tAg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANEJEGspxdmAAhRCS7hiQeeFAOmSg9+ZwnZ_wcROji-9zE9tAg@mail.gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Grant Grundler <grundler@chromium.org>
Cc: Wallence Lu <wallencelu@gmail.com>, FIO_list <fio@vger.kernel.org>

On Mon, Jan 27 2014, Grant Grundler wrote:
> On Mon, Jan 27, 2014 at 3:03 PM, Jens Axboe <axboe@kernel.dk> wrote:
> > On Mon, Jan 27 2014, Jens Axboe wrote:
> >> On Mon, Jan 27 2014, Wallence Lu wrote:
> >> > Recreated with fio 2.0.11-35-g8428, the version was checked out from
> >> > https://github.com/axboe/fio.
> >>
> >> 2.1.4 is the latest, but I don't think that would change anything for
> >> you.
> >>
> >> > I read a little bit of the source code, it seems to me the randwrite
> >> > option gets the LBA without specifying the IO size. With that said,
> >> > for a bsrange option, it is likely one random IO can step onto another
> >> > IO if they happen to be adjacent. For example, request A has LBA
> >> > of 1024 and size 8K, request B has LBA 1016 and size 16K. Without
> >> > checking the request size, request B can overwrite content of request
> >> > A.
> >> >
> >> > Is that the right interpretation? Do I miss something? Thanks.
> >>
> >> Fio is supposed to handle that, the job file should work. I'll take a
> >> look at it.
> >
> > Works for me with the 2.1.4 release. It's actually broken in current
> > -git, due to the numberio patches..
> 
> You mean all of the "verify_only" support patches or specifically this patch:
> 
> commit da0a7bd224bb9331f27bb4b20394dd5c8fa3acb0
> Author: Juan Casse <jcasse@chromium.org>
> Date:   Tue Sep 17 14:06:12 2013 -0700
> 
>     Adds check for numberio during verify phase.
> 
> I can take a look at this tomorrow... let me see if I have the job
> file in another email.

It looks like it's actually catching the issue, when I take a closer
look. I'm afraid there might be overlapping ranges for bsrange=. You can
use the job file that was posted earlier in this thread. I reproduced
with that one, just changing the min bs to be 4k instead (to avoid btrfs
slowness...).

-- 
Jens Axboe

