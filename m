Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:58648 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951Ab3IPTQK (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 16 Sep 2013 15:16:10 -0400
Message-ID: <523758EC.8070502@kernel.dk>
Date: Mon, 16 Sep 2013 13:15:56 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [PATCH] Add condition to stop issuing io in do_io().
References: <1379348530-2920-1-git-send-email-jcasse@chromium.org>
In-Reply-To: <1379348530-2920-1-git-send-email-jcasse@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Juan Casse <jcasse@chromium.org>
Cc: Grant Grundler <grundler@chromium.org>, fio@vger.kernel.org

On 09/16/2013 10:22 AM, Juan Casse wrote:
> Problem:
> When specifying iodepth > 1 while doing random async io
> without a random map (and using the default random generator), the
> main while loop in do_io() will issue extra io in the amount of io
> allowed to accumulate in the queue. For example, a job with size=24k
> and bs=8k will perform 4 io instead of the expected 3.
> 
> Reason:
> The above behavior occurs because the while loop in do_io()
> will continue until the amount of "completed io" >= size, but io
> in the queue are not accounted for because they have not been
> completed by io_u_queued_complete().
> 
> Exceptions:
> The above behavior does not manifest itself when:
> 	using random_generator=lfsr bacause lfsr knows when to stop
> 	generating, and get_io_u() inside the while loop returns NULL,
> 	breaking out of the loop.
> 	using random map because random map ensures that all blocks
> 	are hit, and after they are all hit, no more are generated.
> 
> Proposed Solution:
> Stop while loop based on bytes issued instead of bytes completed.

Looks good, applied.

-- 
Jens Axboe

