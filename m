Return-Path: <fio-owner@vger.kernel.org>
Received: from [95.166.99.235] ([95.166.99.235]:52634 "EHLO kernel.dk"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754819Ab1HBTst (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 2 Aug 2011 15:48:49 -0400
Message-ID: <4E38549F.5080601@kernel.dk>
Date: Tue, 02 Aug 2011 21:48:47 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Measuring IOPS (solved, I think)
References: <201107291737.40463.Martin@lichtvoll.de> <201107291814.34500.Martin@lichtvoll.de> (sfid-20110729_182258_773952_019EDFF6) (sfid-20110729_182258_773952_019EDFF6) <201108021632.00600.Martin@lichtvoll.de>
In-Reply-To: <201108021632.00600.Martin@lichtvoll.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: fio@vger.kernel.org


That's a long email! The stonewall should be put in the job section that
has to wait for previous jobs. So, ala:

[job1]
something

[job2]
stonewall       # will wait for job1 to finish
something

[job3]
something       # will run in parallel with job2

[job4]
stonewall       # will run when job2+3 are finished
something

If that's not the case, something is broken. A quick test here seems to
show that it works.

-- 
Jens Axboe

