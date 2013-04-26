Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:44996 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756519Ab3DZUEc (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 26 Apr 2013 16:04:32 -0400
Date: Fri, 26 Apr 2013 14:04:29 -0600
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: syscall problem on Android x86
Message-ID: <20130426200429.GE9563@kernel.dk>
References: <372C7AE269BA5E4D92B1082F530ED4B85069CD30@ORSMSX110.amr.corp.intel.com>
 <20130426181732.GZ9563@kernel.dk>
 <372C7AE269BA5E4D92B1082F530ED4B85069CFEB@ORSMSX110.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <372C7AE269BA5E4D92B1082F530ED4B85069CFEB@ORSMSX110.amr.corp.intel.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Akers, Jason B" <jason.b.akers@intel.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On Fri, Apr 26 2013, Akers, Jason B wrote:
> Hi Jens,
> 
> Sorry for the confusion. I'm building for x86 Android, not arm.
> 
> The issue is that Android x86 does not define __NR_shmget. And the
> fact that it's hardcoded to 29 in arch-x86.h is causing problems. On
> x86 Android syscall 29 is actually the sys_pause() function.
> Therefore, fio compiles but it just pauses when shmget() is called.

Ah I see, so android x86  You could hack around it a little bit. In
arch-x86.h, something ala:

#ifndef __NR_shmget
#if defined(__ANDROID__)
#define __NR_shmget		 a
#define __NR_shmat		 b
#define __NR_shmctl		 c
#define __NR_shmdt		 d
#else
#define __NR_shmget		 29
#define __NR_shmat		 30
#define __NR_shmctl		 31
#define __NR_shmdt		 67
#endif
#endif

with a/b/c/d being the right values for the android abi.

-- 
Jens Axboe

