Return-Path: <fio-owner@vger.kernel.org>
Received: from [95.166.99.235] ([95.166.99.235]:44759 "EHLO kernel.dk"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753872Ab1HCKe7 (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 3 Aug 2011 06:34:59 -0400
Message-ID: <4E392453.9080905@kernel.dk>
Date: Wed, 03 Aug 2011 12:34:59 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Measuring IOPS (solved, I think)
References: <201107291737.40463.Martin@lichtvoll.de> <201108022328.52415.Martin@lichtvoll.de> <4E38F5F1.6010502@kernel.dk> (sfid-20110803_105124_014639_B1B8D621) <201108031103.05502.Martin@lichtvoll.de>
In-Reply-To: <201108031103.05502.Martin@lichtvoll.de>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: fio@vger.kernel.org

On 2011-08-03 11:03, Martin Steigerwald wrote:
>> Perhaps the name isn't that great? I'll gladly put in an alias for that
>> option, "wait_for_previous" or "barrier" or something like that. Fence?
> 
> wait_before? But then "wait_for_previous" might be the clearest 
> description. "wait_before" would make sense with an "wait_after" that 
> waits after the job for its completion. But two options for basically the 
> same thing might complicate matters even more.

Yes, I'm not going to add another option where only the placement of it
would make a difference. I'll add wait_for_previous.

> So "wait_for_previous" or maybe "finish_previous_first" or just 
> "finish_previous" would be fine with me.
> 
> But then this doesn´t imply that fio does a cache flush. But that could be 
> documented in the manpage with an additional hint on this option. I will 
> think about it and possibly provide a patch.

Not really impacted by that, those are controlled on a job by job basis
anyway.

-- 
Jens Axboe

