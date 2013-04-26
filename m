Return-Path: <fio-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:30839 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755745Ab3DZRoB convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Fri, 26 Apr 2013 13:44:01 -0400
From: "Akers, Jason B" <jason.b.akers@intel.com>
Subject: syscall problem on Android x86
Date: Fri, 26 Apr 2013 17:43:58 +0000
Message-ID: <372C7AE269BA5E4D92B1082F530ED4B85069CD30@ORSMSX110.amr.corp.intel.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Fio hangs when run on the Android x86 emulator.

Tracking through, I found that the last call made is shmget() (in init.c - setup_thread_area()).
I believe that the hang is related to the fio syscall implementation for x86.

os-android.h defines shmget as: syscall(__NR_shmget, __key, __size, __shmflg);

In arch-x86.h __NR_shmget is defined to 29. This was added on April 11th (a415b2cc).

Looking deeper, I see that syscall 29 is actually mapped to pause(). (see SYSCALLS.TXT in bionic/libc) I confirmed that sys_pause() was being called by using a kernel breakpoint. This explains why fio hangs.

Now the question is: What to do about it?
For some reason shmget is only exposed for Android ARM targets even though it is part of the kernel (system.map) for x86.

I see two options:
1. add shmget to SYSCALLS.TXT for x86 and recompile. Remove the hardcoded __NR_shmget from arch-x86.h and put a #error instead to warn others that a kernel patch is necessary for Android x86. 

2. use a "blessed" shared memory allocation method for Android targets (like ashmem / mmap??) Not sure how difficult it would be to make this work with the existing FIO architecture.

Any other ideas / thoughts / feedback / suggestions are appreciated.

Thanks,
Jason Akers


