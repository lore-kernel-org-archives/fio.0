Return-Path: <bruce@cran.org.uk>
Message-ID: <4E33E84F.2060705@cran.org.uk>
Date: Sat, 30 Jul 2011 12:17:35 +0100
From: Bruce Cran <bruce@cran.org.uk>
MIME-Version: 1.0
Subject: Re: [PATCH] Use pthread_self instead of thr_self on BSD
References: <4E33D245.6060301@cran.org.uk> <4E33E304.8030606@kernel.dk>
In-Reply-To: <4E33E304.8030606@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 30/07/2011 11:55, Jens Axboe wrote:
> On 2011-07-30 11:43, Bruce Cran wrote:
>> The attached patch uses pthread_self to get the thread ID instead of the
>> non-POSIX thr_self This fixes a compiler warning on FreeBSD.
> Does pthread_self() return a thread ID in the PID name space, so to
> speak?
>

Hmm no, it doesn't seem to. In that case <sys/thr.h> should probably be 
included to get the definition of thr_self().

-- 
Bruce Cran

