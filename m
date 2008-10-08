Return-Path: <fio-owner@vger.kernel.org>
Received: from pasmtpa.tele.dk ([80.160.77.114]:44736 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754462AbYJHRXk (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 8 Oct 2008 13:23:40 -0400
Date: Wed, 8 Oct 2008 19:23:09 +0200
From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: BUG: option runtime not working during a particular failure mode.
Message-ID: <20081008172308.GR19428@kernel.dk>
References: <7a2ad2470810061504x2b973b80v3caa136d6d883dd8@mail.gmail.com> <20081007093014.GT19428@kernel.dk> <7a2ad2470810070928v6e016700rce84c79026489b11@mail.gmail.com> <20081008110106.GN19428@kernel.dk> <20081008111754.GO19428@kernel.dk> <7a2ad2470810080924o35582b24ge3f4e0b2fc48088d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7a2ad2470810080924o35582b24ge3f4e0b2fc48088d@mail.gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Shawn Lewis <shawnlewis@google.com>
Cc: fio <fio@vger.kernel.org>

On Wed, Oct 08 2008, Shawn Lewis wrote:
> It is fio 1.17.2. I thought we synced up about a month ago but it
> looks like there are much newer versions available. Sorry about that.

Ah ok, then the later version will surely be an improvement in that
respect.

> Anyway this patch looks good as a final protection.

Yes I think so too, I'll go ahead and commit it.

-- 
Jens Axboe

