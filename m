Return-Path: <fio-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:56035
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755878Ab3A3VtJ (ORCPT
	<rfc822;fio@vger.kernel.org>); Wed, 30 Jan 2013 16:49:09 -0500
Date: Wed, 30 Jan 2013 22:48:23 +0100
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] Fix bugs in [v]snprintf usage.
Message-ID: <20130130214823.GT8800@kernel.dk>
References: <6eham0rdc3.fsf@just-testing.permabit.com>
 <6ea9rsrc7u.fsf@just-testing.permabit.com>
 <20130129091712.GD30188@kernel.dk>
 <6e622fr967.fsf@just-testing.permabit.com>
 <20130129211501.GK8800@kernel.dk>
 <6e1ud3r699.fsf@just-testing.permabit.com>
 <20130130115851.GX8800@kernel.dk>
 <6esj5ipdn1.fsf_-_@just-testing.permabit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6esj5ipdn1.fsf_-_@just-testing.permabit.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Ken Raeburn <raeburn@permabit.com>
Cc: fio@vger.kernel.org

On Wed, Jan 30 2013, Ken Raeburn wrote:
> 
> When calling snprintf, supply the full buffer size instead of
> (usually) one byte less.
> 
> When using the returned length from vsnprintf for logging, don't write
> more than the actual buffer size (minus one for the trailing \0), in
> case the formatted string was truncated.

Thanks Ken, applied.

-- 
Jens Axboe

