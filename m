Return-Path: <fio-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:36769 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756245Ab2BGIlq (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 7 Feb 2012 03:41:46 -0500
Message-ID: <4F30E38B.3070309@fusionio.com>
Date: Tue, 7 Feb 2012 09:40:43 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
Subject: Re: [PATCH] Optimize pattern verify
References: <CAAUT-yNW0UEPqSFRwvEM68xx1+X6dnbmmHAvX8hcZJgHLTT5Qg@mail.gmail.com>
In-Reply-To: <CAAUT-yNW0UEPqSFRwvEM68xx1+X6dnbmmHAvX8hcZJgHLTT5Qg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Steven Lang <tirea@google.com>
Cc: fio@vger.kernel.org

On 02/07/2012 03:50 AM, Steven Lang wrote:
> Similar to the patch last week, this optimizes the pattern verify
> operation to use optimized library calls like memcmp(), and only fall
> back to byte-by-byte if there is a miscompare to locate it.
> 
> This uses the same premise that the pattern is repeated as many times
> as possible to do large compares in a single call.  For single byte
> pattern, the setup fills the pattern space, and verify assumes it is
> full.
> 
> Tested by running a script which created an 8k file with 4k bs and,
> one byte at a time, tried corrupting the pattern and running a read
> pass and verified it still found miscompares across the whole range of
> the pattern.  This was done with a pattern length of 1 and 3 bytes.
> 
> In performance tests, this was about 8 times more efficient on
> verifies than without this patch.

Great, applied! Thanks.

-- 
Jens Axboe

