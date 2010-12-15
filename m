Return-Path: <fio-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([64.244.102.31]:32809 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752193Ab0LOP3a (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 15 Dec 2010 10:29:30 -0500
Message-ID: <4D08DED3.6000202@fusionio.com>
Date: Wed, 15 Dec 2010 16:29:23 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
Subject: Re: [patch] Use C99 standard integer types
References: <20101215150924.00003add@unknown>
In-Reply-To: <20101215150924.00003add@unknown>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Bruce Cran <bruce@cran.org.uk>
Cc: fio@vger.kernel.org

On 2010-12-15 16:09, Bruce Cran wrote:
> Since most compilers now have a copy of the C99 inttypes.h header
> available, [u]intX_t types should be preferred over compiler-specific
> types such as __u32 etc. Using the standard types allows clang to build
> fio.
> 
> I've attached a patch which updates blktrace_api.h, blktrace.c and
> os/binject.h .

Really blktrace_api.h should just go away, since it's an OS interface
and should be exposed as such. We've traditionally always used __uxx
types in those interfaces. You should not be picking that up on FreeBSD
:-)

> The patch also updates Makefile.FreeBSD to use the -pthread flag
> since it's preferred over -lpthread .

Thanks, I can make that change. In the future, it would be nice if you
would separate different changes into different patches. Any time you
need to write 'the patch also...' it's a hint that it should be split!

-- 
Jens Axboe

