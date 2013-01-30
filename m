Return-Path: <fio-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:53698
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753126Ab3A3L7f (ORCPT
	<rfc822;fio@vger.kernel.org>); Wed, 30 Jan 2013 06:59:35 -0500
Date: Wed, 30 Jan 2013 12:58:51 +0100
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] Fix crash with absurdly but not impossibly deeply nested
 device stacks.
Message-ID: <20130130115851.GX8800@kernel.dk>
References: <6eham0rdc3.fsf@just-testing.permabit.com>
 <6ea9rsrc7u.fsf@just-testing.permabit.com>
 <20130129091712.GD30188@kernel.dk>
 <6e622fr967.fsf@just-testing.permabit.com>
 <20130129211501.GK8800@kernel.dk>
 <6e1ud3r699.fsf@just-testing.permabit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6e1ud3r699.fsf@just-testing.permabit.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Ken Raeburn <raeburn@permabit.com>
Cc: fio@vger.kernel.org

On Tue, Jan 29 2013, Ken Raeburn wrote:
> 
> Sure, I'll work up some patches for the [v]snprintf calls and the
> missing smalloc failure check...

I patched up the smalloc already, but the *snprintf() stuff would be
excellent to have fixed up.

-- 
Jens Axboe

