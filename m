Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:42912 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755327Ab3JKQ31 (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 11 Oct 2013 12:29:27 -0400
Message-ID: <52582728.6080307@kernel.dk>
Date: Fri, 11 Oct 2013 10:28:24 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: segmentation fault on power system
References: <OFC504DD8C.6281DAA5-ON65257C00.00230F83-65257C00.0023BABE@in.ibm.com>
In-Reply-To: <OFC504DD8C.6281DAA5-ON65257C00.00230F83-65257C00.0023BABE@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Saritha Vinod <sarithavn@in.ibm.com>, fio@vger.kernel.org

On 10/10/2013 12:30 AM, Saritha Vinod wrote:
> 
> Hi Jens,
> 
>>> Yes. If we set unlimit core dump, fio will generate a core with
>>> backtrace like this one:
>>>
>>> #0  mfspr (envp=<value optimized out>) at arch/arch-ppc.h:55
>>> 55              asm volatile("mfspr %0,%1": "=r" (val) : "K" (reg));
>>> Missing separate debuginfos, use: debuginfo-install
> glibc-2.12-1.107.el6.ppc64 libaio-0.3.107-10.el6.ppc64
>>> (gdb) bt
>>> #0  mfspr (envp=<value optimized out>) at arch/arch-ppc.h:55
>>> #1  get_cpu_clock (envp=<value optimized out>) at arch/arch-ppc.h:71
>>> #2  atb_child (envp=<value optimized out>) at arch/arch-ppc.h:88
>>> #3  atb_clocktest (envp=<value optimized out>) at arch/arch-ppc.h:98
>>> #4  arch_init (envp=<value optimized out>) at arch/arch-ppc.h:116
>>> #5  initialize_fio (envp=<value optimized out>) at libfio.c:248
>>> #6  0x0000000010067294 in main (argc=<value optimized out>, argv=<value
> optimized out>,
>>>     envp=<value optimized out>) at fio.c:33
>>>
>>>
>>> Apologize for late to reply.
> 
>> Alright, I'll have PPC default to the normal clock until we can improve
>> and detect this properly.
> 
> Is there a new rpm for fio available with this fix?
> With fio version fio-2.1.2, I am still getting the core dump.

Use latest git of fio and it should work.

-- 
Jens Axboe

