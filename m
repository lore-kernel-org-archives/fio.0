Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:56508 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753614Ab2IWScW (ORCPT <rfc822;fio@vger.kernel.org>);
	Sun, 23 Sep 2012 14:32:22 -0400
Message-ID: <505F55B3.5030008@kernel.dk>
Date: Sun, 23 Sep 2012 20:32:19 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [PATCH] backend: Add configurable non fatal error list
References: <1348400769-12760-1-git-send-email-dmonakhov@openvz.org>
In-Reply-To: <1348400769-12760-1-git-send-email-dmonakhov@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: fio@vger.kernel.org

On 2012-09-23 13:46, Dmitry Monakhov wrote:
> Sometimes it is reasonable to perform test nearly system limits where
> errors are possible and expected, in that case one may provide non
> fatal error list which will be ignored during execution.
> This patch add two options:
>     ignore_error: List of non fatal error
>     error_dump:   Whenever ignored list should be dumped to log.

This looks pretty good. I particularly like that you allow for both
numeric and error "name". It might be a good idea to make that non case
sensitive, though. Minor detail.

I have applied it, thanks!

-- 
Jens Axboe

