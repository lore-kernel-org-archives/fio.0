Return-Path: <fio-owner@vger.kernel.org>
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:34269 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752076Ab3JJGbO (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 10 Oct 2013 02:31:14 -0400
Received: from /spool/local
	by e28smtp02.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <fio@vger.kernel.org> from <sarithavn@in.ibm.com>;
	Thu, 10 Oct 2013 12:01:11 +0530
Received: from d28relay05.in.ibm.com (d28relay05.in.ibm.com [9.184.220.62])
	by d28dlp02.in.ibm.com (Postfix) with ESMTP id AA56D3940058
	for <fio@vger.kernel.org>; Thu, 10 Oct 2013 12:00:50 +0530 (IST)
Received: from d28av06.in.ibm.com (d28av06.in.ibm.com [9.184.220.48])
	by d28relay05.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id r9A6V6hJ47513824
	for <fio@vger.kernel.org>; Thu, 10 Oct 2013 12:01:06 +0530
Received: from d28av06.in.ibm.com (localhost [127.0.0.1])
	by d28av06.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id r9A6V8Mn027147
	for <fio@vger.kernel.org>; Thu, 10 Oct 2013 12:01:08 +0530
Received: from d23ml178.in.ibm.com (d23ml178.in.ibm.com [9.182.8.68])
	by d28av06.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVin) with ESMTP id r9A6V8tO027140
	for <fio@vger.kernel.org>; Thu, 10 Oct 2013 12:01:08 +0530
Subject: Re: segmentation fault on power system
Message-ID: <OFC504DD8C.6281DAA5-ON65257C00.00230F83-65257C00.0023BABE@in.ibm.com>
From: Saritha Vinod <sarithavn@in.ibm.com>
Date: Thu, 10 Oct 2013 12:00:15 +0530
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org


Hi Jens,

>> Yes. If we set unlimit core dump, fio will generate a core with
>> backtrace like this one:
>>
>> #0  mfspr (envp=<value optimized out>) at arch/arch-ppc.h:55
>> 55              asm volatile("mfspr %0,%1": "=r" (val) : "K" (reg));
>> Missing separate debuginfos, use: debuginfo-install
glibc-2.12-1.107.el6.ppc64 libaio-0.3.107-10.el6.ppc64
>> (gdb) bt
>> #0  mfspr (envp=<value optimized out>) at arch/arch-ppc.h:55
>> #1  get_cpu_clock (envp=<value optimized out>) at arch/arch-ppc.h:71
>> #2  atb_child (envp=<value optimized out>) at arch/arch-ppc.h:88
>> #3  atb_clocktest (envp=<value optimized out>) at arch/arch-ppc.h:98
>> #4  arch_init (envp=<value optimized out>) at arch/arch-ppc.h:116
>> #5  initialize_fio (envp=<value optimized out>) at libfio.c:248
>> #6  0x0000000010067294 in main (argc=<value optimized out>, argv=<value
optimized out>,
>>     envp=<value optimized out>) at fio.c:33
>>
>>
>> Apologize for late to reply.

> Alright, I'll have PPC default to the normal clock until we can improve
> and detect this properly.

Is there a new rpm for fio available with this fix?
With fio version fio-2.1.2, I am still getting the core dump.

Thanks,
Saritha

