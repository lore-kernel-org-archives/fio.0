Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vc0-f170.google.com ([209.85.220.170]:38857 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752769Ab3D0B7o (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 26 Apr 2013 21:59:44 -0400
Received: by mail-vc0-f170.google.com with SMTP id hv10so4373195vcb.29
        for <fio@vger.kernel.org>; Fri, 26 Apr 2013 18:59:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <372C7AE269BA5E4D92B1082F530ED4B85069CD30@ORSMSX110.amr.corp.intel.com>
References: <372C7AE269BA5E4D92B1082F530ED4B85069CD30@ORSMSX110.amr.corp.intel.com>
Date: Sat, 27 Apr 2013 11:59:43 +1000
Message-ID: <CAKCZDgmFea+X0euVng1Fg3kEBrmmxc0SbjCk3W=n+HGa0NVJJQ@mail.gmail.com>
Subject: Re: syscall problem on Android x86
From: Aaron Carroll <xaaronc@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Akers, Jason B" <jason.b.akers@intel.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 27 April 2013 03:43, Akers, Jason B <jason.b.akers@intel.com> wrote:
> Fio hangs when run on the Android x86 emulator.
>
> Tracking through, I found that the last call made is shmget() (in init.c - setup_thread_area()).
> I believe that the hang is related to the fio syscall implementation for x86.
>
> os-android.h defines shmget as: syscall(__NR_shmget, __key, __size, __shmflg);
>
> In arch-x86.h __NR_shmget is defined to 29. This was added on April 11th (a415b2cc).
>
> Looking deeper, I see that syscall 29 is actually mapped to pause(). (see SYSCALLS.TXT in bionic/libc) I confirmed that sys_pause() was being called by using a kernel breakpoint. This explains why fio hangs.

You are right, I added the 64bit syscall number.

> Now the question is: What to do about it?

 * Either junk the __NR_shm* definitions, or move them to x86-64 for
future 64bit Android compatibility
 * The shm* functions need different definitions for x86-32, because
there are no shm* syscalls. They appear to be multiplexed over an IPC
syscall.

As Jens said this has nothing to do with Android per se, only that its
libc does not implement shm*() so we have to do it ourselves.


  -- Aaron
