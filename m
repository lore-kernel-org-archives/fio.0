Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:40484 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753704Ab2IWScr (ORCPT <rfc822;fio@vger.kernel.org>);
	Sun, 23 Sep 2012 14:32:47 -0400
Message-ID: <505F55C8.1080607@kernel.dk>
Date: Sun, 23 Sep 2012 20:32:40 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [PATCH] engine: fix error handling for e4defrag/falloc
References: <1348422593-4712-1-git-send-email-dmonakhov@openvz.org>
In-Reply-To: <1348422593-4712-1-git-send-email-dmonakhov@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: fio@vger.kernel.org

On 2012-09-23 19:49, Dmitry Monakhov wrote:
> At the time I've wrote this code i don't quite understand difference
> between td->error and io_u->error. It is appeared that engine should
> not have to explicitly assign td->error. Just initialize io_u->error and
> backed will do proper handling.

That is correct, applied.

-- 
Jens Axboe

