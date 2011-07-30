Return-Path: <bruce@cran.org.uk>
Message-ID: <4E33FABB.2050809@cran.org.uk>
Date: Sat, 30 Jul 2011 13:36:11 +0100
From: Bruce Cran <bruce@cran.org.uk>
MIME-Version: 1.0
Subject: Re: [PATCH] Use pthread_self instead of thr_self on BSD
References: <4E33D245.6060301@cran.org.uk> <4E33E304.8030606@kernel.dk> <4E33E84F.2060705@cran.org.uk> <4E33E9C8.1060209@kernel.dk>
In-Reply-To: <4E33E9C8.1060209@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 30/07/2011 12:23, Jens Axboe wrote:
> I suspected as much, most OS' will return a unique ID but not 
> something you can otherwise use. How about the below?

That should work.

-- 
Bruce Cran

