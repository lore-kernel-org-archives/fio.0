Return-Path: <fio-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:51973
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754892Ab3C2NkG (ORCPT
	<rfc822;fio@vger.kernel.org>); Fri, 29 Mar 2013 09:40:06 -0400
Date: Fri, 29 Mar 2013 07:40:01 -0600
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: FIO 2.0.14 - getting a compile error on opensuse
Message-ID: <20130329134001.GH19488@kernel.dk>
References: <CAGpXXZ+CSFx7tnWjgUibNEgth_9kM4qTP_ptW+kTFeDCfoC08w@mail.gmail.com>
 <CAKCZDgkX1JPo6_+cUzAU3bCo_ceawyd64Ki08BVZS7y4Uoooqg@mail.gmail.com>
 <20130328212151.GG19488@kernel.dk>
 <CAGpXXZKk_3HEFufkQV0U66Mp=Xm7dFcMWKPbSSJA1nC6C+DWrQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGpXXZKk_3HEFufkQV0U66Mp=Xm7dFcMWKPbSSJA1nC6C+DWrQ@mail.gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Greg Freemyer <greg.freemyer@gmail.com>
Cc: Aaron Carroll <aaronc@cse.unsw.edu.au>, fio@vger.kernel.org

On Thu, Mar 28 2013, Greg Freemyer wrote:
> Jens,
> 
> It didn't apply?  There was one missing line in Makefile and hunk
> offsets in configure.
> 
> Did you diff to fio-2.0.14?
> 
> I got my copy via: wget http://brick.kernel.dk/snaps/fio-2.0.14.tar.bz2

No, I always diff against the git tree.

> My workspace is at
> https://build.opensuse.org/package/show?package=fio&project=home%3Agregfreemyer%3Abranches%3Abenchmark
> 
> I fixed the patch and you can see it in the workspace.  I assume I did
> what you wanted it, but it fails the same basic way:
> 
> ===
> [    6s] gcc -o gettime.o -std=gnu99 -Wwrite-strings -Wall
> -fomit-frame-pointer -fmessage-length=0 -O2 -Wall -D_FORTIFY_SOURCE=2
> -fstack-protector -funwind-tables -fasynchronous-unwind-tables
> -DBITS_PER_LONG=32 -DFIO_VERSION='"fio-2.0.14"' -D_LARGEFILE_SOURCE
> -D_FILE_OFFSET_BITS=64 -D_FORTIFY_SOURCE=2 -DFIO_INC_DEBUG -c
> gettime.c
> [    6s] In file included from os/os.h:28:0,
> [    6s]                  from fio.h:24,
> [    6s]                  from gettime.c:10:
> [    6s] os/os-linux.h: In function 'fio_cpuset_init':
> [    6s] os/os-linux.h:67:2: warning: implicit declaration of function
> 'CPU_ZERO' [-Wimplicit-function-declaration]
> [    6s] In file included from os/os.h:60:0,
> [    6s]                  from fio.h:24,
> [    6s]                  from gettime.c:10:
> [    6s] os/../lib/strsep.h: At top level:
> [    6s] os/../lib/strsep.h:4:7: error: expected identifier or '('
> before '__extension__'
> [    6s] os/../lib/strsep.h:4:7: error: expected identifier or '('
> before ')' token
> [    6s] In file included from fio.h:32:0,
> [    6s]                  from gettime.c:10:
> [    6s] helpers.h:11:36: error: unknown type name 'off64_t'
> [    6s] helpers.h:11:52: error: unknown type name 'off64_t'
> [    6s] make: *** [gettime.o] Error 1
> ===

So the same issue. I have no idea what is happening in your build
environment. How are you invoking make? There must be some arguments,
since it's doing a verbose build.

-- 
Jens Axboe

