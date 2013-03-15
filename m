Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:48637 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754310Ab3COQLH (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 15 Mar 2013 12:11:07 -0400
Date: Fri, 15 Mar 2013 17:10:29 +0100
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: Build error in Android/x86
Message-ID: <20130315161029.GV31875@kernel.dk>
References: <5142C392.5050302@cse.unsw.edu.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5142C392.5050302@cse.unsw.edu.au>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Aaron Carroll <aaronc@cse.unsw.edu.au>
Cc: fio@vger.kernel.org

On Fri, Mar 15 2013, Aaron Carroll wrote:
> I'm trying to build FIO with an Android/x86 cross compiler:
> 
>  make CROSS_COMPILE=~/dev/android-toolchains-r8c/x86-4.6/bin/i686-linux-android-
> 
> but get the following error:
> 
>   arch/arch-x86-common.h:9:2: error: inconsistent operand constraints in an 'asm'
> 
> which is complaining about this function:
> 
>   static inline void do_cpuid(unsigned int *eax, unsigned int *ebx,
>                   unsigned int *ecx, unsigned int *edx)
>   {
>       asm volatile("cpuid"
>           : "=a" (*eax), "=b" (*ebx), "=c" (*ecx), "=d" (*edx)
>           : "0" (*eax), "2" (*ecx)
>           : "memory");
>   }
> 
> Unfortunately I don't do x86 ASM.  I'm wondering if this is a genuine error,
> or if something has broken in the cross compile.

Hmm, I wonder why it complains about that, looks legit to me... Maybe
it's the ecx being both input and output it doesn't like?

-- 
Jens Axboe

