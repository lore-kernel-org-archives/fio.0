Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:52176 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753531Ab3C1VVz (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 28 Mar 2013 17:21:55 -0400
Date: Thu, 28 Mar 2013 15:21:51 -0600
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: FIO 2.0.14 - getting a compile error on opensuse
Message-ID: <20130328212151.GG19488@kernel.dk>
References: <CAGpXXZ+CSFx7tnWjgUibNEgth_9kM4qTP_ptW+kTFeDCfoC08w@mail.gmail.com>
 <CAKCZDgkX1JPo6_+cUzAU3bCo_ceawyd64Ki08BVZS7y4Uoooqg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKCZDgkX1JPo6_+cUzAU3bCo_ceawyd64Ki08BVZS7y4Uoooqg@mail.gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Aaron Carroll <aaronc@cse.unsw.edu.au>
Cc: Greg Freemyer <greg.freemyer@gmail.com>, fio@vger.kernel.org

On Wed, Mar 27 2013, Aaron Carroll wrote:
> On 26 March 2013 05:44, Greg Freemyer <greg.freemyer@gmail.com> wrote:
> > But this is the basic error which happens on the first gcc call.
> >
> > [   48s] gcc -o gettime.o -std=gnu99 -Wwrite-strings -Wall
> > -fomit-frame-pointer -fmessage-length=0 -grecord-gcc-switches -O2
> > -Wall -D_FORTIFY_SOURCE=2 -fstack-protector -funwind-tables
> > -fasynchronous-unwind-tables -DBITS_PER_LONG=32
> > -DFIO_VERSION='"fio-2.0.14"' -D_LARGEFILE_SOURCE
> > -D_FILE_OFFSET_BITS=64 -D_FORTIFY_SOURCE=2 -DFIO_INC_DEBUG -c
> > gettime.c
> 
> Something has happened to the CFLAGS -- you're missing -D_GNU_SOURCE
> which is needed for the definition of CPU_ZERO.
> 
> I can get the same behaviour with:
>    make EXTFLAGS=
> but then I got confused looking at the Makefile. I don't understand
> how that ever works, since EXTFLAGS is used before it's defined.

This should (hopefully) improve the situation. Greg, can you test with
this?

diff --git a/Makefile b/Makefile
index ea96a89..cae07c3 100644
--- a/Makefile
+++ b/Makefile
@@ -1,11 +1,3 @@
-DEBUGFLAGS = -D_FORTIFY_SOURCE=2 -DFIO_INC_DEBUG
-CPPFLAGS= -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64 $(DEBUGFLAGS)
-OPTFLAGS= -O3 -g -ffast-math $(EXTFLAGS)
-CFLAGS	= -std=gnu99 -Wwrite-strings -Wall $(OPTFLAGS)
-LIBS	= -lm $(EXTLIBS)
-PROGS	= fio
-SCRIPTS = fio_generate_plots
-
 ifneq ($(wildcard config-host.mak),)
 all:
 include config-host.mak
@@ -20,6 +12,14 @@ all:
 include config-host.mak
 endif
 
+DEBUGFLAGS = -D_FORTIFY_SOURCE=2 -DFIO_INC_DEBUG
+CPPFLAGS= -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64 $(DEBUGFLAGS)
+OPTFLAGS= -O3 -g -ffast-math $(EXTFLAGS) $(BUILD_CFLAGS)
+CFLAGS	= -std=gnu99 -Wwrite-strings -Wall $(OPTFLAGS)
+LIBS	= -lm $(EXTLIBS)
+PROGS	= fio
+SCRIPTS = fio_generate_plots
+
 SOURCE := gettime.c fio.c ioengines.c init.c stat.c log.c time.c filesetup.c \
 		eta.c verify.c memory.c io_u.c parse.c mutex.c options.c \
 		rbtree.c smalloc.c filehash.c profile.c debug.c lib/rand.c \
diff --git a/configure b/configure
index 836d7ad..13cf8d5 100755
--- a/configure
+++ b/configure
@@ -39,7 +39,7 @@ fatal() {
 
 # Default CFLAGS
 CFLAGS="-D_GNU_SOURCE"
-EXTFLAGS="-include config-host.h"
+BUILD_CFLAGS="-include config-host.h"
 
 # Print a helpful header at the top of config.log
 echo "# FIO configure log $(date)" >> config.log
@@ -230,7 +230,7 @@ CYGWIN*)
   output_sym "CONFIG_SCHED_IDLE"
   output_sym "CONFIG_TCP_NODELAY"
   echo "CC=$CC" >> $config_host_mak
-  echo "EXTFLAGS=$CFLAGS -include config-host.h -D_GNU_SOURCE" >> $config_host_mak
+  echo "BUILD_CFLAGS=$CFLAGS -include config-host.h -D_GNU_SOURCE" >> $config_host_mak
   exit 0
   ;;
 esac
@@ -1088,4 +1088,4 @@ fi
 
 echo "LIBS+=$LIBS" >> $config_host_mak
 echo "CC=$cc" >> $config_host_mak
-echo "EXTFLAGS=$EXTFLAGS $CFLAGS" >> $config_host_mak
+echo "BUILD_CFLAGS=$BUILD_CFLAGS $CFLAGS" >> $config_host_mak

-- 
Jens Axboe

