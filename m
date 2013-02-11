Return-Path: <fio-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:59268
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758302Ab3BKR1E (ORCPT
	<rfc822;fio@vger.kernel.org>); Mon, 11 Feb 2013 12:27:04 -0500
Date: Mon, 11 Feb 2013 18:25:50 +0100
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: problem FIO compiling for Android
Message-ID: <20130211172550.GU21269@kernel.dk>
References: <CACTzACVkfEmHrCTJExxOpPqD7tZLMbmW7n3pJza-g87sZaaK1g@mail.gmail.com>
 <CACTzACUwtE+aoHy72dAvgcx8zby5DYwYZzhoJfOyTCj5ABCGgg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACTzACUwtE+aoHy72dAvgcx8zby5DYwYZzhoJfOyTCj5ABCGgg@mail.gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: David N <android.wm.edu@gmail.com>
Cc: fio@vger.kernel.org, aaronc@cse.unsw.edu.au

On Mon, Feb 11 2013, David N wrote:
> Hello Everyone,
> 
> I've been trying to compile FIO for Android but keep getting error
> bellow. Can anybody give me any guidance please?
> 
> I very much appreciate!
> 
> David
> 
> 
> david@david-HP-ubuntu:~/development/android/external/fio-2.0.13$ make
> UNAME=Android CROSS_COMPILE=$CCOMPILER
>     CC init.o
> init.c: In function ‘free_shm’:
> init.c:224:18: error: storage size of ‘sbuf’ isn’t known
> init.c:233:3: warning: implicit declaration of function ‘shmdt’
> [-Wimplicit-function-declaration]
> init.c:234:3: warning: implicit declaration of function ‘shmctl’
> [-Wimplicit-function-declaration]
> init.c:224:18: warning: unused variable ‘sbuf’ [-Wunused-variable]
> init.c: In function ‘setup_thread_area’:
> init.c:263:3: warning: implicit declaration of function ‘shmget’
> [-Wimplicit-function-declaration]
> init.c:277:2: warning: implicit declaration of function ‘shmat’
> [-Wimplicit-function-declaration]
> init.c:277:10: warning: assignment makes pointer from integer without
> a cast [enabled by default]
> make: *** [init.o] Error 1

Lets CC in Aaron, who added the port.

-- 
Jens Axboe

