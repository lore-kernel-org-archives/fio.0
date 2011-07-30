Return-Path: <fio-owner@vger.kernel.org>
Received: from [95.166.99.235] ([95.166.99.235]:51938 "EHLO kernel.dk"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751391Ab1G3M5T (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 30 Jul 2011 08:57:19 -0400
Message-ID: <4E33FFAC.90707@kernel.dk>
Date: Sat, 30 Jul 2011 14:57:16 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [PATCH] Use pthread_self instead of thr_self on BSD
References: <4E33D245.6060301@cran.org.uk> <4E33E304.8030606@kernel.dk> <4E33E84F.2060705@cran.org.uk> <4E33E9C8.1060209@kernel.dk> <4E33FABB.2050809@cran.org.uk>
In-Reply-To: <4E33FABB.2050809@cran.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Bruce Cran <bruce@cran.org.uk>
Cc: fio@vger.kernel.org

On 2011-07-30 14:36, Bruce Cran wrote:
> On 30/07/2011 12:23, Jens Axboe wrote:
>> I suspected as much, most OS' will return a unique ID but not 
>> something you can otherwise use. How about the below?
> 
> That should work.

Great, pushing that out, too.

-- 
Jens Axboe

