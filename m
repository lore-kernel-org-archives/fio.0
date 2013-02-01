Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:37804 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752Ab3BAABn (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 31 Jan 2013 19:01:43 -0500
Date: Fri, 1 Feb 2013 01:00:55 +0100
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: use of rwmixread option
Message-ID: <20130201000055.GG25524@kernel.dk>
References: <A7A1D348E34E024BBC74480FB93A2EAB010719@DAGN05A-E6.exg6.exghost.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A7A1D348E34E024BBC74480FB93A2EAB010719@DAGN05A-E6.exg6.exghost.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Carl Zwanzig <cpz@coraid.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On Thu, Jan 31 2013, Carl Zwanzig wrote:
> Hi,
> 
> Am I correct that rwmixread/rwmixwrite are completely ignored unless
> readwrite=rw or =randrw? Experiments suggest yes but I can't find
> where this is handled in the code. (The HowTo file is silent on this.)

That is correct, see io_u.c:get_rw_ddir(). The mix is only used if the
data direciton is read-write. For pure read, always reads, for pure
writes, always writes.

> *Is there a description somewhere on how options are processed?
> Tracking the option definition in options.c to its use has eluded me.

So the options.c bits only ensure that the options are set. That is
td->o.rwmix[]. The options ensure that mixread + mixwrite == 100%. The
actual handling is in the function mentioned above, plus it interacts
with an IO issue counter. Essentially the mix is IOPS based, with
randomness for direction chosen.

-- 
Jens Axboe

