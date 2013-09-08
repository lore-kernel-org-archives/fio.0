Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:59550 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097Ab3IHBcH (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 7 Sep 2013 21:32:07 -0400
Date: Sat, 7 Sep 2013 19:32:03 -0600
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] Adds verify_only option.
Message-ID: <20130908013203.GJ31170@kernel.dk>
References: <1378437152-11128-1-git-send-email-jcasse@chromium.org>
 <5229EACA.7090009@kernel.dk>
 <CAPet_21-oPZ2bEQw_Uwq2GdM4T5HNUcN2eqTPifqRpCSEE-_cA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPet_21-oPZ2bEQw_Uwq2GdM4T5HNUcN2eqTPifqRpCSEE-_cA@mail.gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Juan Casse <jcasse@google.com>
Cc: Juan Casse <jcasse@chromium.org>, Grant Grundler <grundler@chromium.org>, "fio@vger.kernel.org" <fio@vger.kernel.org>

On Fri, Sep 06 2013, Juan Casse wrote:
> On Fri, Sep 6, 2013 at 7:46 AM, Jens Axboe <axboe@kernel.dk> wrote:
> ...
> > Please take a look at how this is done for the experimental_verify. The
> > writes are skipped much sooner and generically, there's no need to
> > enforce any sort of specific IO engine or verify type.
> 
> From your reply I understood that you want to skip do_io() all
> together and call a function that will somehow replicate the workload
> and compute the numberio for each block. Is that what you meant?

Yes, you want the logic to be in the realm of do_verify(). See the
experimental verify. It basically rewinds the various random/lfsr dials
and replays, skips writes, etc.

> My patch uses do_io() to initialize the vhdr_meta data structures. I
> can try to replicate that in do_verify() instead, but that seems more
> fragile.

Honestly, at this point, not sure what change you are trying to
accomplish there... But if you send your suggested change, I'll take a
look and comment.

If not, please step back a bit and explain to me exactly which logic you
are looking for. I think that will help both of us and will get us to a
better place on the implementation and changes.

-- 
Jens Axboe

