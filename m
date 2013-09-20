Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:34221 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509Ab3ITPUo (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 20 Sep 2013 11:20:44 -0400
Message-ID: <523C67B7.50909@kernel.dk>
Date: Fri, 20 Sep 2013 09:20:23 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [PATCH] Fixes bug: stale LAST_POS(f) is not being reset.
References: <1379624876-27770-1-git-send-email-jcasse@chromium.org>
In-Reply-To: <1379624876-27770-1-git-send-email-jcasse@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Juan Casse <jcasse@chromium.org>
Cc: Grant Grundler <grundler@chromium.org>, fio@vger.kernel.org

On 09/19/2013 03:07 PM, Juan Casse wrote:
> Problem:
> When running fio with ioengine=sync, LAST_POS(f) state is not
> reset after the file is closed. This causes workloads with
> readwrite=randread and loops > 1 to fail verification if the
> state of LAST_POS(f) at the beginning of the next loop is the
> same as the io_u->offset. If that is the case, lseek in not
> invoked, but the file position is at 0 and not at io_u->offset.
> 
> Proposed Solution:
> Other ioengines, such as binject and fusion-aw, set f->engine_data
> to 0 when closing the file. The sync ioengin uses f->engine_data to
> store the LAST_POS(f) state. The proposed solution is to set
> f->engine_data = 0 when closing a file in generic_close_file().

Thanks, good catch and fix. Applied.

-- 
Jens Axboe

