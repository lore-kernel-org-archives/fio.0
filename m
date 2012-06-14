Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:41612 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754256Ab2FNHy6 (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 14 Jun 2012 03:54:58 -0400
Message-ID: <4FD998CE.3030705@kernel.dk>
Date: Thu, 14 Jun 2012 09:54:54 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: FIO r/w to 2 disks
References: <4E57E183169EA04186759995F13BDC621A18A7C7@FMSMSX103.amr.corp.intel.com>
In-Reply-To: <4E57E183169EA04186759995F13BDC621A18A7C7@FMSMSX103.amr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Strickland, Carl" <carl.strickland@intel.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 2012-06-08 21:52, Strickland, Carl wrote:
> Hi All,
> 
> I'm performing a series of time-based storage tests and need FIO to read and
> write to separate disks, in the ratio specified (e.g. 80/20).
> 
> I've performed initial tests with two FIO instances (one read, one write), but
> found that in one scenario I get a ratio of ~50/50 and in another I get
> ~60/40. However, in order to compare the results of these tests, their ratios
> must be approximately equal.
> 
> Is it possible to achieve this with a single FIO instance? Do you have any
> recommendations for achieving a specific ratio with two FIO instances?

It's not clear from your email exactly what kind of job(s) you ran. Have
you tried a single job with rwmix set? rwmixread=80 and rw=randrw should
give you the requested ratio, 80% reads and 20% writes.

-- 
Jens Axboe

