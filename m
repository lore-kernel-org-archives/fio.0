Return-Path: <fio-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:37416
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751957Ab3CZVQB (ORCPT
	<rfc822;fio@vger.kernel.org>); Tue, 26 Mar 2013 17:16:01 -0400
Date: Tue, 26 Mar 2013 15:15:58 -0600
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: FIO 2.0.14 - getting a compile error on opensuse
Message-ID: <20130326211558.GE19488@kernel.dk>
References: <CAGpXXZ+CSFx7tnWjgUibNEgth_9kM4qTP_ptW+kTFeDCfoC08w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGpXXZ+CSFx7tnWjgUibNEgth_9kM4qTP_ptW+kTFeDCfoC08w@mail.gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Greg Freemyer <greg.freemyer@gmail.com>
Cc: fio@vger.kernel.org

On Mon, Mar 25 2013, Greg Freemyer wrote:
> All,
> 
> fio v2.0.13 compiled fine on opensuse.
> 
> fio v2.0.14 is failing on opensuse (multiple releases including 12.3
> and factory).  I assume because of the new configure logic.
> 
> A full build log is at:
> https://build.opensuse.org/package/live_build_log?arch=x86_64&package=fio&project=home%3Agregfreemyer%3Abranches%3Abenchmark&repository=openSUSE_Factory
> 
> But this is the basic error which happens on the first gcc call.
> 
> [   48s] gcc -o gettime.o -std=gnu99 -Wwrite-strings -Wall
> -fomit-frame-pointer -fmessage-length=0 -grecord-gcc-switches -O2
> -Wall -D_FORTIFY_SOURCE=2 -fstack-protector -funwind-tables
> -fasynchronous-unwind-tables -DBITS_PER_LONG=32
> -DFIO_VERSION='"fio-2.0.14"' -D_LARGEFILE_SOURCE
> -D_FILE_OFFSET_BITS=64 -D_FORTIFY_SOURCE=2 -DFIO_INC_DEBUG -c
> gettime.c
> [   48s] In file included from os/os.h:28:0,
> [   48s]                  from fio.h:24,
> [   48s]                  from gettime.c:10:
> [   48s] os/os-linux.h: In function 'fio_cpuset_init':
> [   48s] os/os-linux.h:67:2: warning: implicit declaration of function
> 'CPU_ZERO' [-Wimplicit-function-declaration]
> [   48s] In file included from os/os.h:60:0,
> [   48s]                  from fio.h:24,
> [   48s]                  from gettime.c:10:
> [   48s] os/../lib/strsep.h: At top level:
> [   48s] os/../lib/strsep.h:4:7: error: expected identifier or '('
> before '__extension__'
> [   48s] os/../lib/strsep.h:4:7: error: expected identifier or '('
> before ')' token
> [   48s] In file included from fio.h:32:0,
> [   48s]                  from gettime.c:10:
> [   48s] helpers.h:11:36: error: unknown type name 'off64_t'
> [   48s] helpers.h:11:52: error: unknown type name 'off64_t'
> [   48s] make: *** [gettime.o] Error 1
> [   48s] error: Bad exit status from /var/tmp/rpm-tmp.QKC5od (%build)

Odd. Could you send me the config.log output? I don't have an opensuse
install, unfortunately. If you have one that is reachable from the
outside, send me a private reply and perhaps I could investigate myself.

-- 
Jens Axboe

