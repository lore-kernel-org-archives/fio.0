Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:38426 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756620Ab1KPNbH (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 16 Nov 2011 08:31:07 -0500
Message-ID: <4EC3BB19.9010800@kernel.dk>
Date: Wed, 16 Nov 2011 14:31:05 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [PATCH] Fix parsing of ioengine strings
References: <CAAUT-yOwd16b1fCT+EZWyiKQFi7R6eHC0cSi3b8z6FNz6=Wptw@mail.gmail.com>
In-Reply-To: <CAAUT-yOwd16b1fCT+EZWyiKQFi7R6eHC0cSi3b8z6FNz6=Wptw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Steven Lang <tirea@google.com>
Cc: fio@vger.kernel.org

On 2011-11-15 02:41, Steven Lang wrote:
> This cleans up parsing of FIO_OPT_STR_STORE options which have defined
> values (IE ioengine).  I made a few assumptions here...
> 
> 1. If FIO_OPT_STR_STORE was used, that means a copy of the string is
> desired, so it is always copied if the offset is non-zero.
> 2. If the values were the only allowed values, then FIO_OPT_STR would
> have been used; therefore it is not an error to give a value not in
> the list.
> 3. If an option callback is defined, then any values are ignored and
> the callback is called to parse the string.  (Don't think this
> currently applies, anywhere, but there is precendent in other options
> skipping normal parsing if a callback is used.)
> 4. If no offsets are defined, and no callback is given, the behavior
> is undefined - though this patch handles it cleanly and still calls
> value callbacks; though I believe fio will still complain about a bad
> options structure.
> 
> This fixes two cases (Restores it to previous behavior without
> breaking new functionality).
> 1. External ioengines (The patch to a .so is never in the list of
> possible values, so was never matching)
> 2. IO engines compiled in but not in the list in options.c
> 
> This patch should be applied to the 1.5x stable branch as well, though
> it doesn't apply cleanly due to one line difference from my last
> options patch.

Applied (to both branches), thanks.

-- 
Jens Axboe

