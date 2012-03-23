Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:52183 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864Ab2CWHDf (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 23 Mar 2012 03:03:35 -0400
Message-ID: <4F6C2010.1070409@kernel.dk>
Date: Fri, 23 Mar 2012 08:02:40 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: fio terse output issue
References: <CAKa9NmutL+L4GyYreo5_9wvCG8vASLJs=M1b+xThcL5xdYcK0w@mail.gmail.com>
In-Reply-To: <CAKa9NmutL+L4GyYreo5_9wvCG8vASLJs=M1b+xThcL5xdYcK0w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Vikram Seth <seth.vik@gmail.com>
Cc: fio@vger.kernel.org

On 03/23/2012 01:47 AM, Vikram Seth wrote:
> Hi Jens,
> 
> I have seen that using 2.05 version of fio the terse output formatting
> has an issue when there is a text description given in the test file.
> There is no newline separating the description and the next job stats.
> I have pasted the text at the end of this mail with description as
> "Standard Performance test".
> 
> I tried following patch and it seemed to work. Do you think it is fine
> and if you can fix the issue ?

I think it looks fine, I will apply it. Thanks!

-- 
Jens Axboe

