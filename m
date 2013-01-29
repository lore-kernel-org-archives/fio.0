Return-Path: <fio-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:50462
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750809Ab3A2VPr (ORCPT
	<rfc822;fio@vger.kernel.org>); Tue, 29 Jan 2013 16:15:47 -0500
Date: Tue, 29 Jan 2013 22:15:01 +0100
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] Fix crash with absurdly but not impossibly deeply nested
 device stacks.
Message-ID: <20130129211501.GK8800@kernel.dk>
References: <6eham0rdc3.fsf@just-testing.permabit.com>
 <6ea9rsrc7u.fsf@just-testing.permabit.com>
 <20130129091712.GD30188@kernel.dk>
 <6e622fr967.fsf@just-testing.permabit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6e622fr967.fsf@just-testing.permabit.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Ken Raeburn <raeburn@permabit.com>
Cc: fio@vger.kernel.org

On Tue, Jan 29 2013, Ken Raeburn wrote:
> Jens Axboe <axboe@kernel.dk> writes:
> 
> > On Mon, Jan 28 2013, Ken Raeburn wrote:
> >> diskutil.c: Check for overflow in disk_util.path.
> >> diskutil.h: Expand disk_util.path to PATH_MAX.
> >
> > Good stuff, thanks. Though I think that we should just return NULL on
> > failing to setup the path.
> 
> That seems fine, too. The preferred error handling in that area of the
> code wasn't clear to me. Especially since smalloc failure (which doesn't
> appear to be impossible) leads to a null pointer dereference.

Those should be fixed up, smalloc() failure can happen. Fio definitely
isn't malloc() fail proof, usually it happily ignores that. But that
smalloc() isn't caught in diskutil.c is an oversight.

> > And:
> >
> >> +	l = snprintf(du->path, sizeof(du->path), "%s/stat", path);
> >> +	if (l < 0 || l >= sizeof(du->path)) {
> >
> > cosmetically, that should never be > sizeof(du->path), but it doesn't
> > hurt.
> 
> According to the GNU libc man page, in truncation cases, snprintf
> returns the number of characters that would have been written, excluding
> the trailing \0, if the buffer were long enough.  So if we're appending
> "/stat" to something just under the buffer size, the return value could
> be larger.

Good point!

> So, actually, I think the vsnprintf usage in log.c is wrong in assuming
> the return value is no more than the buffer size...

Indeed they are. Can't believe I never realized how horrible an API the
*snprintf() functions are.

> Also, skimming the other uses, I think some of the other calls don't
> really need to subtract one from sizeof(buffer), since the passed length
> is the maximum number of bytes written, always including a trailing \0.

Care to send in a patch or patches?

-- 
Jens Axboe

