Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:44885 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753002Ab3A2JT7 (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 29 Jan 2013 04:19:59 -0500
Date: Tue, 29 Jan 2013 10:19:16 +0100
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] Fix crash with absurdly but not impossibly deeply nested
 device stacks.
Message-ID: <20130129091916.GE30188@kernel.dk>
References: <6eham0rdc3.fsf@just-testing.permabit.com>
 <6ea9rsrc7u.fsf@just-testing.permabit.com>
 <20130129091712.GD30188@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130129091712.GD30188@kernel.dk>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Ken Raeburn <raeburn@permabit.com>
Cc: fio@vger.kernel.org

On Tue, Jan 29 2013, Jens Axboe wrote:
> On Mon, Jan 28 2013, Ken Raeburn wrote:
> > diskutil.c: Check for overflow in disk_util.path.
> > diskutil.h: Expand disk_util.path to PATH_MAX.
> 
> Good stuff, thanks. Though I think that we should just return NULL on
> failing to setup the path.
> 
> And:
> 
> > +	l = snprintf(du->path, sizeof(du->path), "%s/stat", path);
> > +	if (l < 0 || l >= sizeof(du->path)) {
> 
> cosmetically, that should never be > sizeof(du->path), but it doesn't
> hurt.

Committed this:

http://git.kernel.dk/?p=fio.git;a=commit;h=4b919f7740f4875d73c0619a08d269d5c679e19f

-- 
Jens Axboe

