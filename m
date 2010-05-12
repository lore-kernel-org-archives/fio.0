Return-Path: <fio-owner@vger.kernel.org>
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:60224 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750732Ab0ELNGL (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 12 May 2010 09:06:11 -0400
Date: Wed, 12 May 2010 15:06:08 +0200
From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: fio netbsd support
Message-ID: <20100512130608.GC25951@kernel.dk>
References: <20100512082913.AA9657191C@kuma.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100512082913.AA9657191C@kuma.localdomain>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: YAMAMOTO Takashi <yamamoto@valinux.co.jp>
Cc: fio@vger.kernel.org

On Wed, May 12 2010, YAMAMOTO Takashi wrote:
> hi,
> 
> the attached patch is for preliminary support for netbsd.

Thanks, looks good. Applied. The rb bit is a bit icky, but we can fix
that up later.

-- 
Jens Axboe

