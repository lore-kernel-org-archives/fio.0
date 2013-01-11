Return-Path: <fio-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:40740
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753739Ab3AKJKN (ORCPT
	<rfc822;fio@vger.kernel.org>); Fri, 11 Jan 2013 04:10:13 -0500
Date: Fri, 11 Jan 2013 10:10:10 +0100
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: fio is being killed by the oom-killer after fio verify runs for
 some time ~13 hours
Message-ID: <20130111091010.GA32674@kernel.dk>
References: <CABYizFKetDGfE_fOARgbehmJo_uDTqy32bMTQTDVyny-Nk5riQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABYizFKetDGfE_fOARgbehmJo_uDTqy32bMTQTDVyny-Nk5riQ@mail.gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: brian arb <brianjamesarb@gmail.com>
Cc: fio@vger.kernel.org

On Thu, Jan 10 2013, brian arb wrote:
> Seems fio is being killed by the oom-killer after fio verify runs for
> some time ~13 hours. What parameters can I tweak or how can I run my
> test differently so the test will be completed with out interruption?

You are probably running into OOM issues since each completed write will
log some meta data to help verify that later. The easiest fix for you
would be to verify continously, setting a backlog of how old data can
get before being verified. See verify_backlog and verify_async for that.

You should also upgrade your fio. Fio uses a random map for tracking
what has been written. It's static memory, so it wont cause your OOM
during runtime, but it will gobble up some memory when you start. If you
upgrade to 2.0.13 and use random_distribution=lfsr, then that memory
consumption will go away.

There's room for a bit of improvement on fio for verification. Since IO
buffer contents and offsets etc are fully randomized with specific
seeding, it is possible to verify what has been written without storing
this meta data. Basically verify can just re-create the contents for
verification, instead of storing a checksum of it. That will cost some
CPU, but it will get you more predictable (and much lower) memory
consumption numbers. I will look into that. But as a starter, the above
suggestions should help you out.

-- 
Jens Axboe

