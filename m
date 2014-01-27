Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:40691 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754506AbaA0XDo (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 27 Jan 2014 18:03:44 -0500
Date: Mon, 27 Jan 2014 16:03:39 -0700
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: A bug in combining fsrange and verify
Message-ID: <20140127230339.GN2782@kernel.dk>
References: <CAOpYm_W685AkEuFnNZX-m0Jfq+B+crzQv5oEF_Hbvq3XbABhaQ@mail.gmail.com>
 <20140127192215.GF2782@kernel.dk>
 <CAOpYm_WNfhkyFRofHg6aUfm_nxL7oX8gCc++wNFMproqP1rVeA@mail.gmail.com>
 <20140127224603.GM2782@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140127224603.GM2782@kernel.dk>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Wallence Lu <wallencelu@gmail.com>
Cc: fio@vger.kernel.org, Grant Grundler <grundler@chromium.org>

On Mon, Jan 27 2014, Jens Axboe wrote:
> On Mon, Jan 27 2014, Wallence Lu wrote:
> > Recreated with fio 2.0.11-35-g8428, the version was checked out from
> > https://github.com/axboe/fio.
> 
> 2.1.4 is the latest, but I don't think that would change anything for
> you.
> 
> > I read a little bit of the source code, it seems to me the randwrite
> > option gets the LBA without specifying the IO size. With that said,
> > for a bsrange option, it is likely one random IO can step onto another
> > IO if they happen to be adjacent. For example, request A has LBA
> > of 1024 and size 8K, request B has LBA 1016 and size 16K. Without
> > checking the request size, request B can overwrite content of request
> > A.
> > 
> > Is that the right interpretation? Do I miss something? Thanks.
> 
> Fio is supposed to handle that, the job file should work. I'll take a
> look at it.

Works for me with the 2.1.4 release. It's actually broken in current
-git, due to the numberio patches...

-- 
Jens Axboe

