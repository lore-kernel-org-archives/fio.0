Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:40161 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934064Ab3HIPDw (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 9 Aug 2013 11:03:52 -0400
Message-ID: <520504A3.7070505@kernel.dk>
Date: Fri, 09 Aug 2013 09:02:59 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: segmentation fault on power system
References: <20130723101359.GC2152@localhost.localdomain> <51EE5997.6070804@enovance.com> <51EE9E1C.3040708@kernel.dk> <20130724021019.GA2615@localhost.localdomain> <20130724062101.GB2615@localhost.localdomain> <51F13781.8000502@kernel.dk> <20130809083905.GA9877@localhost.localdomain>
In-Reply-To: <20130809083905.GA9877@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Han Pingtian <hanpt@linux.vnet.ibm.com>
Cc: Erwan Velu <erwan@enovance.com>, fio@vger.kernel.org

On 08/09/2013 02:39 AM, Han Pingtian wrote:
> On Thu, Jul 25, 2013 at 08:34:41AM -0600, Jens Axboe wrote:
>> On 07/24/2013 12:21 AM, Han Pingtian wrote:
>>> I think I have found what's wrong. After 'make distclean' then 'make',
>>> the problem of segfault has gone. There were some object files 
>>> compiled on another machine. The recompilation fixed it. But looks like
>>> the ATBU call dosen't work on power7 system.
>>
>> So the recompilation fixed the segfault, but not the illegal instruction
>> due to ATBU?
> 
> Yes. If we set unlimit core dump, fio will generate a core with 
> backtrace like this one:
> 
> #0  mfspr (envp=<value optimized out>) at arch/arch-ppc.h:55
> 55              asm volatile("mfspr %0,%1": "=r" (val) : "K" (reg));
> Missing separate debuginfos, use: debuginfo-install glibc-2.12-1.107.el6.ppc64 libaio-0.3.107-10.el6.ppc64
> (gdb) bt
> #0  mfspr (envp=<value optimized out>) at arch/arch-ppc.h:55
> #1  get_cpu_clock (envp=<value optimized out>) at arch/arch-ppc.h:71
> #2  atb_child (envp=<value optimized out>) at arch/arch-ppc.h:88
> #3  atb_clocktest (envp=<value optimized out>) at arch/arch-ppc.h:98
> #4  arch_init (envp=<value optimized out>) at arch/arch-ppc.h:116
> #5  initialize_fio (envp=<value optimized out>) at libfio.c:248
> #6  0x0000000010067294 in main (argc=<value optimized out>, argv=<value optimized out>,
>     envp=<value optimized out>) at fio.c:33
> 
> 
> Apologize for late to reply.

Alright, I'll have PPC default to the normal clock until we can improve
and detect this properly.

-- 
Jens Axboe

