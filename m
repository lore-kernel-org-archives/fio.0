Return-Path: <fio-owner@vger.kernel.org>
Received: from tone.orchestra.cse.unsw.EDU.AU ([129.94.242.59]:48530 "EHLO
	tone.orchestra.cse.unsw.EDU.AU" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751950Ab3COGqg (ORCPT
	<rfc822;fio@vger.kernel.org>); Fri, 15 Mar 2013 02:46:36 -0400
Received: From
	[10.13.1.8] ([203.143.161.65] == vampire.ertos.nicta.com.au) (auth-user aaronc) (cse-authentic-sender aaronc)
	(for <fio@vger.kernel.org>) By tone With Smtp ;
	Fri, 15 Mar 2013 17:46:33 +1100 
From: Aaron Carroll <aaronc@cse.unsw.edu.au>
Date: Fri, 15 Mar 2013 17:45:38 +1100
Message-ID: <5142C392.5050302@cse.unsw.edu.au>
MIME-Version: 1.0
Subject: Build error in Android/x86
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

I'm trying to build FIO with an Android/x86 cross compiler:

  make CROSS_COMPILE=~/dev/android-toolchains-r8c/x86-4.6/bin/i686-linux-android-

but get the following error:

   arch/arch-x86-common.h:9:2: error: inconsistent operand constraints in an 'asm'

which is complaining about this function:

   static inline void do_cpuid(unsigned int *eax, unsigned int *ebx,
                   unsigned int *ecx, unsigned int *edx)
   {
       asm volatile("cpuid"
           : "=a" (*eax), "=b" (*ebx), "=c" (*ecx), "=d" (*edx)
           : "0" (*eax), "2" (*ecx)
           : "memory");
   }

Unfortunately I don't do x86 ASM.  I'm wondering if this is a genuine error, or 
if something has broken in the cross compile.



Cheers,
     -- Aaron

