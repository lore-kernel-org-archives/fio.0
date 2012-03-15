Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:41486 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797Ab2CONn7 (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 15 Mar 2012 09:43:59 -0400
Message-ID: <4F61F1F8.7080209@kernel.dk>
Date: Thu, 15 Mar 2012 14:43:20 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [PATCH] rdma engine graceful teardown
References: <CAG5pYQf466pFdb8dGwpQxqx64Tre+JgV-qh-emY+BT0dh3m8uA@mail.gmail.com>
In-Reply-To: <CAG5pYQf466pFdb8dGwpQxqx64Tre+JgV-qh-emY+BT0dh3m8uA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Yufei Ren <renyufei83@gmail.com>
Cc: fio@vger.kernel.org

On 03/13/2012 09:57 PM, Yufei Ren wrote:
> For rdma ioengine's one side operation, RDMA_WRITE or RDMA_READ,
> server side gets a message from client side that the task is finished.
> In previous version, the server simply exit() in td_io_commit() which
> causes segmentation fault in thread mode or process hanging in process
> mode. This patch achieves graceful tear down by setting up `td->done`
> as UDP engine did.

It's a bit of a hack, but if it improves the situation, I'm fine with
it. Applied, thanks.

-- 
Jens Axboe

