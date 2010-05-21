Return-Path: <fio-owner@vger.kernel.org>
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:51487 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753519Ab0EUFOc (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 21 May 2010 01:14:32 -0400
Date: Fri, 21 May 2010 07:14:30 +0200
From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: fio netbsd support
Message-ID: <20100521051430.GZ25951@kernel.dk>
References: <20100520092057.GK25951@kernel.dk> <20100521014950.37C6371473@kuma.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100521014950.37C6371473@kuma.localdomain>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: YAMAMOTO Takashi <yamamoto@valinux.co.jp>
Cc: fio@vger.kernel.org

On Fri, May 21 2010, YAMAMOTO Takashi wrote:
> hi,
> 
> > On Thu, May 20 2010, YAMAMOTO Takashi wrote:
> >> > On Wed, May 12 2010, YAMAMOTO Takashi wrote:
> >> >> hi,
> >> >> 
> >> >> the attached patch is for preliminary support for netbsd.
> >> > 
> >> > Thanks, looks good. Applied. The rb bit is a bit icky, but we can fix
> >> > that up later.
> >> > 
> >> > -- 
> >> > Jens Axboe
> >> 
> >> thanks.
> >> 
> >> it seems that the following small change is necessary to catch up with
> >> the recent changes.
> > 
> > Indeed, thanks. I should have noticed that. I have committed it.
> 
> and it seems that you forgot to add os-netbsd.h.

Seems so indeed, should be there now :-)

-- 
Jens Axboe

