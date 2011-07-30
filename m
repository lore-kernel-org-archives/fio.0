Return-Path: <fio-owner@vger.kernel.org>
Received: from [95.166.99.235] ([95.166.99.235]:42755 "EHLO kernel.dk"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751160Ab1G3KzC (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 30 Jul 2011 06:55:02 -0400
Message-ID: <4E33E304.8030606@kernel.dk>
Date: Sat, 30 Jul 2011 12:55:00 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [PATCH] Use pthread_self instead of thr_self on BSD
References: <4E33D245.6060301@cran.org.uk>
In-Reply-To: <4E33D245.6060301@cran.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Bruce Cran <bruce@cran.org.uk>
Cc: fio@vger.kernel.org

On 2011-07-30 11:43, Bruce Cran wrote:
> The attached patch uses pthread_self to get the thread ID instead of the 
> non-POSIX thr_self This fixes a compiler warning on FreeBSD.

Does pthread_self() return a thread ID in the PID name space, so to
speak?

-- 
Jens Axboe

