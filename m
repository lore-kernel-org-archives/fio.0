Return-Path: <fio-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:47602 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752072Ab1HAHf5 (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 1 Aug 2011 03:35:57 -0400
Message-ID: <4E365754.7030603@fusionio.com>
Date: Mon, 1 Aug 2011 09:35:48 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
Subject: Re: rdma ioengine
References: <1312163269.12654.YahooMailNeo@web15806.mail.cnb.yahoo.com>
In-Reply-To: <1312163269.12654.YahooMailNeo@web15806.mail.cnb.yahoo.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: ren yufei <renyufei83@yahoo.com.cn>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 2011-08-01 03:47, ren yufei wrote:
> Hi Jens,
> 
> I have hacked an rdma ioengine based on OFED for fio which could test both rdma memory semantic (rdma_write/rdma_read) and channel semantic (send/recv). Would you like to merge this engine into fio?
> 
> notes
> 1) RDMA engine works in IB, iWarp and RoCE.
> 2) RDMA engine is disable by default. To enable it, execute the following before compile:
> $ export EXTFLAGS="-DFIO_HAVE_RDMA"
> $ export EXTLIBS="-libverbs -lrdmacm"

Exciting! I'd love to apply this, but somewhere along the way the patch
has been white space damaged. Can you resend this patch gzip'ed or
something like that, to ensure that it doesn't get modified along the
way? Bonus points if you re-indent, fio uses real tabs and not 4 spaces.
Not a huge problem, I'll just lindent it as-is if need be.

It'd be great to have a small job file included as well for testing, and
an example of a result using that job file.

-- 
Jens Axboe

