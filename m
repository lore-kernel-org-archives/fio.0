Return-Path: <fio-owner@vger.kernel.org>
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:48524 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752583Ab0ETJU6 (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 20 May 2010 05:20:58 -0400
Date: Thu, 20 May 2010 11:20:58 +0200
From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: fio netbsd support
Message-ID: <20100520092057.GK25951@kernel.dk>
References: <20100512130608.GC25951@kernel.dk> <20100520091826.3CE7C710AF@kuma.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100520091826.3CE7C710AF@kuma.localdomain>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: YAMAMOTO Takashi <yamamoto@valinux.co.jp>
Cc: fio@vger.kernel.org

On Thu, May 20 2010, YAMAMOTO Takashi wrote:
> > On Wed, May 12 2010, YAMAMOTO Takashi wrote:
> >> hi,
> >> 
> >> the attached patch is for preliminary support for netbsd.
> > 
> > Thanks, looks good. Applied. The rb bit is a bit icky, but we can fix
> > that up later.
> > 
> > -- 
> > Jens Axboe
> 
> thanks.
> 
> it seems that the following small change is necessary to catch up with
> the recent changes.

Indeed, thanks. I should have noticed that. I have committed it.

-- 
Jens Axboe

