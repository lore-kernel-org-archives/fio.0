Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:59826 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425Ab3EQKWv (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 17 May 2013 06:22:51 -0400
Date: Fri, 17 May 2013 12:22:44 +0200
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: latency measurements when adding thinktime
Message-ID: <20130517102244.GV697@kernel.dk>
References: <OF959B9513.E7C6D2A9-ON80257B6D.00837463-80257B6E.0000140D@uk.ibm.com>
 <20130517074751.GS697@kernel.dk>
 <OFDD7AB964.9096D732-ON80257B6E.00324017-80257B6E.0033AE26@uk.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OFDD7AB964.9096D732-ON80257B6E.00324017-80257B6E.0033AE26@uk.ibm.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Edoardo Comar <ECOMAR@uk.ibm.com>
Cc: fio@vger.kernel.org

On Fri, May 17 2013, Edoardo Comar wrote:
> Hi Jens,
> 
> thanks a lot, I tried your suggestion straight away: 
> The cpu line in the output shows that the job has not been idle at all.
> but even with thinktime_spin, the latency stays high at at 150ms.
> 
> Note also that if I increase thinktime & thinktime_spin by another 10000 
> us
> to a total of 20000, then the reported latency goes up another 150ms to a 
> total of 300ms.
> Could this be a bug?

It certainly could. Let me take a look here and see if I can reproduce
it.

-- 
Jens Axboe

