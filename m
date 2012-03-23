Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:39053 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759253Ab2CWSXC (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 23 Mar 2012 14:23:02 -0400
Message-ID: <4F6CBF82.4010808@kernel.dk>
Date: Fri, 23 Mar 2012 19:22:58 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: fio terse output issue
References: <CAKa9NmutL+L4GyYreo5_9wvCG8vASLJs=M1b+xThcL5xdYcK0w@mail.gmail.com> <4F6C2010.1070409@kernel.dk> <CAAUT-yMabveTyN=yuL8bUWGZpJGqw9EwHigAgqb1V8q-gLAALg@mail.gmail.com>
In-Reply-To: <CAAUT-yMabveTyN=yuL8bUWGZpJGqw9EwHigAgqb1V8q-gLAALg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Steven Lang <tirea@google.com>
Cc: fio@vger.kernel.org

On 2012-03-23 17:07, Steven Lang wrote:
> Wouldn't it be better to just move the final log_info("\n"); to the
> end of the function?  With that patch, it would print the normal line,
> then a new line with just ";description" on it.

Yes good point, when I looked at the v2 output, I realized this too.
I'll fix that up. Thanks.

-- 
Jens Axboe

