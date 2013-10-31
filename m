Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:47733 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751189Ab3JaQzU (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 31 Oct 2013 12:55:20 -0400
Date: Thu, 31 Oct 2013 10:55:18 -0600
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: Bug in x86_64 do_cpuid()
Message-ID: <20131031165518.GI29372@kernel.dk>
References: <52711104.3020604@cran.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52711104.3020604@cran.org.uk>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Bruce Cran <bruce@cran.org.uk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On Wed, Oct 30 2013, Bruce Cran wrote:
> It seems there's a bug in the x86_64 version of do_cpuid() that causes fio
> to segfault when built with clang at lower optimization levels:
> 
> static inline void do_cpuid(unsigned int *eax, unsigned int *ebx,
>                 unsigned int *ecx, unsigned int *edx)
> {
>     asm volatile("cpuid"
>         : "=a" (*eax), "=b" (*ebx), "=r" (*ecx), "=d" (*edx)
>         : "0" (*eax), "2" (*ecx)
>         : "memory");
> }
> 
> via Tijl Coosemans:
> 
> Should be: "=c" (*ecx)
> 
> But you can also use the '+' modifier and remove the input operands:
> 
> : "+a" (*eax), "=b" (*ebx), "+c" (*ecx), "=d" (*edx)
> :
> : "memory"

+a/+c doesn't work, but =c will do the trick.

-- 
Jens Axboe

