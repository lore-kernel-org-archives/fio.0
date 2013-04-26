Return-Path: <fio-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:35267
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756698Ab3DZUme (ORCPT
	<rfc822;fio@vger.kernel.org>); Fri, 26 Apr 2013 16:42:34 -0400
Date: Fri, 26 Apr 2013 14:42:32 -0600
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: syscall problem on Android x86
Message-ID: <20130426204232.GG9563@kernel.dk>
References: <372C7AE269BA5E4D92B1082F530ED4B85069CD30@ORSMSX110.amr.corp.intel.com>
 <20130426181732.GZ9563@kernel.dk>
 <372C7AE269BA5E4D92B1082F530ED4B85069CFEB@ORSMSX110.amr.corp.intel.com>
 <20130426200429.GE9563@kernel.dk>
 <372C7AE269BA5E4D92B1082F530ED4B85069D109@ORSMSX110.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <372C7AE269BA5E4D92B1082F530ED4B85069D109@ORSMSX110.amr.corp.intel.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Akers, Jason B" <jason.b.akers@intel.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On Fri, Apr 26 2013, Akers, Jason B wrote:
> Unfortunately android x86 doesn't have a syscall number for the shm*
> functions. They are not exposed by x86 bionic libc. So there's nothing
> to fill in for a/b/c/d.
> 
> The only way I see to get syscall numbers is to patch x86 android libc
> and recompile. This should work for me today but, since the syscall
> numbers are not standardized, it will not work for anyone with an
> unmodified libc.
> 
> So I propose something like:
> 
> #ifndef __NR_shmget
> #if defined(__ANDROID__)
> #error "__NR_shmget not defined. See bionic libc SYSCALLS.TXT for more information."
> #else
> #define __NR_shmget		 29
> #define __NR_shmat		 30
> #define __NR_shmctl		 31
> #define __NR_shmdt		 67
> #endif
> #endif
> 
> This will "break the build" for unmodified x86 android platforms, but
> I think that's better than compiling and not working.

The syscall has nothing to do with the libc installed. The libc headers
might not DEFINE the numbers. As long as the syscall is wired up in the
given kernel (which I'm assuming it is, but I really know nothing about
android), then that is enough.

> The other (probably better long-term) option is to use ashmem for
> allocating shared memory on android.

I'll gladly take patches :-)

Please stop top-posting, btw, it goes against the normal net etiquette
on this forum (and most others in the open source world).

-- 
Jens Axboe

