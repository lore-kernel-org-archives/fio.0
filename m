Return-Path: <fio-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:34056
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932131Ab3BLI6z (ORCPT
	<rfc822;fio@vger.kernel.org>); Tue, 12 Feb 2013 03:58:55 -0500
Date: Tue, 12 Feb 2013 09:57:40 +0100
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: problem FIO compiling for Android
Message-ID: <20130212085740.GA21269@kernel.dk>
References: <CACTzACVkfEmHrCTJExxOpPqD7tZLMbmW7n3pJza-g87sZaaK1g@mail.gmail.com>
 <CACTzACUwtE+aoHy72dAvgcx8zby5DYwYZzhoJfOyTCj5ABCGgg@mail.gmail.com>
 <20130211172550.GU21269@kernel.dk>
 <5119A093.2030409@cse.unsw.edu.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5119A093.2030409@cse.unsw.edu.au>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Aaron Carroll <aaronc@cse.unsw.edu.au>
Cc: David N <android.wm.edu@gmail.com>, fio@vger.kernel.org

On Tue, Feb 12 2013, Aaron Carroll wrote:
> On 12/02/13 4:25 AM, Jens Axboe wrote:
> > On Mon, Feb 11 2013, David N wrote:
> >> Hello Everyone,
> >>
> >> I've been trying to compile FIO for Android but keep getting error
> >> bellow. Can anybody give me any guidance please?
> >>
> >> I very much appreciate!
> >>
> >> David
> >>
> >>
> >> david@david-HP-ubuntu:~/development/android/external/fio-2.0.13$ make
> >> UNAME=Android CROSS_COMPILE=$CCOMPILER
> >>     CC init.o
> >> init.c: In function ‘free_shm’:
> >> init.c:224:18: error: storage size of ‘sbuf’ isn’t known
> >> init.c:233:3: warning: implicit declaration of function ‘shmdt’
> >> [-Wimplicit-function-declaration]
> >> init.c:234:3: warning: implicit declaration of function ‘shmctl’
> >> [-Wimplicit-function-declaration]
> >> init.c:224:18: warning: unused variable ‘sbuf’ [-Wunused-variable]
> >> init.c: In function ‘setup_thread_area’:
> >> init.c:263:3: warning: implicit declaration of function ‘shmget’
> >> [-Wimplicit-function-declaration]
> >> init.c:277:2: warning: implicit declaration of function ‘shmat’
> >> [-Wimplicit-function-declaration]
> >> init.c:277:10: warning: assignment makes pointer from integer without
> >> a cast [enabled by default]
> >> make: *** [init.o] Error 1
> > 
> > Lets CC in Aaron, who added the port.
> 
> The switch to configure broke Android.  I got a very minimal build
> working with the attached patch and:
> 
>   make
> cross_prefix=~/dev/android-toolchain-r8c/bin/arm-linux-androideabi-
> UNAME=Android

I thought it might have broken it, Android is pretty much the only
platform I cannot build/test on myself.

Will apply your patch.

-- 
Jens Axboe

