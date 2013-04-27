Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:48398 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839Ab3D0C1S (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 26 Apr 2013 22:27:18 -0400
Date: Fri, 26 Apr 2013 20:27:13 -0600
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: syscall problem on Android x86
Message-ID: <20130427022713.GM9563@kernel.dk>
References: <372C7AE269BA5E4D92B1082F530ED4B85069CD30@ORSMSX110.amr.corp.intel.com>
 <CAKCZDgmFea+X0euVng1Fg3kEBrmmxc0SbjCk3W=n+HGa0NVJJQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKCZDgmFea+X0euVng1Fg3kEBrmmxc0SbjCk3W=n+HGa0NVJJQ@mail.gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Aaron Carroll <xaaronc@gmail.com>
Cc: "Akers, Jason B" <jason.b.akers@intel.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

On Sat, Apr 27 2013, Aaron Carroll wrote:
> On 27 April 2013 03:43, Akers, Jason B <jason.b.akers@intel.com> wrote:
> > Fio hangs when run on the Android x86 emulator.
> >
> > Tracking through, I found that the last call made is shmget() (in init.c - setup_thread_area()).
> > I believe that the hang is related to the fio syscall implementation for x86.
> >
> > os-android.h defines shmget as: syscall(__NR_shmget, __key, __size, __shmflg);
> >
> > In arch-x86.h __NR_shmget is defined to 29. This was added on April 11th (a415b2cc).
> >
> > Looking deeper, I see that syscall 29 is actually mapped to pause(). (see SYSCALLS.TXT in bionic/libc) I confirmed that sys_pause() was being called by using a kernel breakpoint. This explains why fio hangs.
> 
> You are right, I added the 64bit syscall number.
> 
> > Now the question is: What to do about it?
> 
>  * Either junk the __NR_shm* definitions, or move them to x86-64 for
> future 64bit Android compatibility
>  * The shm* functions need different definitions for x86-32, because
> there are no shm* syscalls. They appear to be multiplexed over an IPC
> syscall.

Hmm good point, I had (wrongly) assumed that the abi was in sync for 32
and 64-bit x86, but that is not the case. For x86, you have to do
ipc(SHMGET, ...) etc to get at it.

I'll move the definitions to x86-64 where they belong.

> As Jens said this has nothing to do with Android per se, only that its
> libc does not implement shm*() so we have to do it ourselves.

Yep. Jason, it should be fairly easy to wire up ipc(). Or you can do the
android variant, I'm fine with either.

-- 
Jens Axboe

