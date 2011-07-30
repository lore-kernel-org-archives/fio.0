Return-Path: <fio-owner@vger.kernel.org>
Received: from [95.166.99.235] ([95.166.99.235]:45476 "EHLO kernel.dk"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752715Ab1G3HTH (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 30 Jul 2011 03:19:07 -0400
Message-ID: <4E33B066.5030805@kernel.dk>
Date: Sat, 30 Jul 2011 09:19:02 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [PATCH] stats: Fix computation of standard deviation
References: <1311978223-15603-1-git-send-email-yjhong@google.com>
In-Reply-To: <1311978223-15603-1-git-send-email-yjhong@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Yu-ju Hong <yjhong@google.com>
Cc: fio@vger.kernel.org, Nauman Rafique <nauman@google.com>, Eric Gouriou <egouriou@google.com>

On 2011-07-30 00:23, Yu-ju Hong wrote:
> Fix the computation of standard deviation for a group
> of jobs. Please see the below link for the
> approximation formula used.
> <http://en.wikipedia.org/wiki/Algorithms_for_calculating_variance
> 
> The formula was originally presented here:
> <ftp://reports.stanford.edu/pub/cstr/reports/cs/tr/79/773/
> CS-TR-79-773.pdf>

This is great! I completely forgot about that hack. It's one of those
things you make a note of to fix up, then forget all about it. Applied.

-- 
Jens Axboe

