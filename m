Return-Path: <fio-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:46842
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753002Ab3A2JRy (ORCPT
	<rfc822;fio@vger.kernel.org>); Tue, 29 Jan 2013 04:17:54 -0500
Date: Tue, 29 Jan 2013 10:17:12 +0100
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] Fix crash with absurdly but not impossibly deeply nested
 device stacks.
Message-ID: <20130129091712.GD30188@kernel.dk>
References: <6eham0rdc3.fsf@just-testing.permabit.com>
 <6ea9rsrc7u.fsf@just-testing.permabit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6ea9rsrc7u.fsf@just-testing.permabit.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Ken Raeburn <raeburn@permabit.com>
Cc: fio@vger.kernel.org

On Mon, Jan 28 2013, Ken Raeburn wrote:
> diskutil.c: Check for overflow in disk_util.path.
> diskutil.h: Expand disk_util.path to PATH_MAX.

Good stuff, thanks. Though I think that we should just return NULL on
failing to setup the path.

And:

> +	l = snprintf(du->path, sizeof(du->path), "%s/stat", path);
> +	if (l < 0 || l >= sizeof(du->path)) {

cosmetically, that should never be > sizeof(du->path), but it doesn't
hurt.

-- 
Jens Axboe

