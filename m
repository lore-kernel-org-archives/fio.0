Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:58525 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755160Ab1KVIgE (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 22 Nov 2011 03:36:04 -0500
Message-ID: <4ECB5EF2.3070804@kernel.dk>
Date: Tue, 22 Nov 2011 09:36:02 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [PATCH] Fix initialization of lastrate when using ratemin
References: <36E51B62-69B0-4FCB-8D86-1603D3C21CF9@joshcarter.com>
In-Reply-To: <36E51B62-69B0-4FCB-8D86-1603D3C21CF9@joshcarter.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Josh Carter <public@joshcarter.com>
Cc: fio@vger.kernel.org

On 2011-11-18 22:37, Josh Carter wrote:
> fio was copying td->bw_sample_time (single timeval) into td->lastrate
> (array of two timevals) using the latter's size. Thus is would get one
> timeval worth of good data plus who-knows-what for the second timeval.
> I'm pretty sure the intent of this code was to copy bw_sample_time
> into both members of lastrate.

Thanks, applied!

-- 
Jens Axboe

