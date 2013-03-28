Return-Path: <greg.freemyer@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20130328212151.GG19488@kernel.dk>
References: <CAGpXXZ+CSFx7tnWjgUibNEgth_9kM4qTP_ptW+kTFeDCfoC08w@mail.gmail.com>
 <CAKCZDgkX1JPo6_+cUzAU3bCo_ceawyd64Ki08BVZS7y4Uoooqg@mail.gmail.com> <20130328212151.GG19488@kernel.dk>
From: Greg Freemyer <greg.freemyer@gmail.com>
Date: Thu, 28 Mar 2013 19:35:46 -0400
Message-ID: <CAGpXXZKk_3HEFufkQV0U66Mp=Xm7dFcMWKPbSSJA1nC6C+DWrQ@mail.gmail.com>
Subject: Re: FIO 2.0.14 - getting a compile error on opensuse
Content-Type: text/plain; charset=ISO-8859-1
To: Jens Axboe <axboe@kernel.dk>
Cc: Aaron Carroll <aaronc@cse.unsw.edu.au>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

Jens,

It didn't apply?  There was one missing line in Makefile and hunk
offsets in configure.

Did you diff to fio-2.0.14?

I got my copy via: wget http://brick.kernel.dk/snaps/fio-2.0.14.tar.bz2

My workspace is at
https://build.opensuse.org/package/show?package=fio&project=home%3Agregfreemyer%3Abranches%3Abenchmark

I fixed the patch and you can see it in the workspace.  I assume I did
what you wanted it, but it fails the same basic way:

===
[    6s] gcc -o gettime.o -std=gnu99 -Wwrite-strings -Wall
-fomit-frame-pointer -fmessage-length=0 -O2 -Wall -D_FORTIFY_SOURCE=2
-fstack-protector -funwind-tables -fasynchronous-unwind-tables
-DBITS_PER_LONG=32 -DFIO_VERSION='"fio-2.0.14"' -D_LARGEFILE_SOURCE
-D_FILE_OFFSET_BITS=64 -D_FORTIFY_SOURCE=2 -DFIO_INC_DEBUG -c
gettime.c
[    6s] In file included from os/os.h:28:0,
[    6s]                  from fio.h:24,
[    6s]                  from gettime.c:10:
[    6s] os/os-linux.h: In function 'fio_cpuset_init':
[    6s] os/os-linux.h:67:2: warning: implicit declaration of function
'CPU_ZERO' [-Wimplicit-function-declaration]
[    6s] In file included from os/os.h:60:0,
[    6s]                  from fio.h:24,
[    6s]                  from gettime.c:10:
[    6s] os/../lib/strsep.h: At top level:
[    6s] os/../lib/strsep.h:4:7: error: expected identifier or '('
before '__extension__'
[    6s] os/../lib/strsep.h:4:7: error: expected identifier or '('
before ')' token
[    6s] In file included from fio.h:32:0,
[    6s]                  from gettime.c:10:
[    6s] helpers.h:11:36: error: unknown type name 'off64_t'
[    6s] helpers.h:11:52: error: unknown type name 'off64_t'
[    6s] make: *** [gettime.o] Error 1
===




This is the patch I actually used:

============
--- fio-2.0.14-orig/configure   2013-02-21 13:12:32.000000000 -0500
+++ fio-2.0.14/configure        2013-03-28 19:19:13.503041144 -0400
@@ -39,7 +39,7 @@ fatal() {

 # Default CFLAGS
 CFLAGS="-D_GNU_SOURCE"
-EXTFLAGS="-include config-host.h"
+BUILD_CFLAGS="-include config-host.h"

 # Print a helpful header at the top of config.log
 echo "# FIO configure log $(date)" >> config.log
@@ -222,7 +222,7 @@ CYGWIN*)
   output_sym "CONFIG_SCHED_IDLE"
   output_sym "CONFIG_TCP_NODELAY"
   echo "CC=$CC" >> $config_host_mak
-  echo "EXTFLAGS=$CFLAGS -include config-host.h -D_GNU_SOURCE" >>
$config_host_mak
+  echo "BUILD_CFLAGS=$CFLAGS -include config-host.h -D_GNU_SOURCE" >>
$config_host_mak
   exit 0
   ;;
 Android)
@@ -1020,4 +1020,4 @@ fi

 echo "LIBS+=$LIBS" >> $config_host_mak
 echo "CC=$cc" >> $config_host_mak
-echo "EXTFLAGS=$EXTFLAGS $CFLAGS" >> $config_host_mak
+echo "BUILD_CFLAGS=$BUILD_CFLAGS $CFLAGS" >> $config_host_mak
diff -rupN fio-2.0.14-orig/Makefile fio-2.0.14/Makefile
--- fio-2.0.14-orig/Makefile    2013-02-21 13:12:32.000000000 -0500
+++ fio-2.0.14/Makefile 2013-03-28 19:19:38.442051864 -0400
@@ -1,11 +1,3 @@
-DEBUGFLAGS = -D_FORTIFY_SOURCE=2 -DFIO_INC_DEBUG
-CPPFLAGS= -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64 $(DEBUGFLAGS)
-OPTFLAGS= -O3 -g -ffast-math $(EXTFLAGS)
-CFLAGS = -std=gnu99 -Wwrite-strings -Wall $(OPTFLAGS)
-LIBS   = -lm $(EXTLIBS)
-PROGS  = fio
-SCRIPTS = fio_generate_plots
-UNAME  := $(shell uname)

 ifneq ($(wildcard config-host.mak),)
 all:
@@ -21,6 +13,15 @@ all:
 include config-host.mak
 endif

+DEBUGFLAGS = -D_FORTIFY_SOURCE=2 -DFIO_INC_DEBUG
+CPPFLAGS= -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64 $(DEBUGFLAGS)
+OPTFLAGS= -O3 -g -ffast-math $(EXTFLAGS) $(BUILD_CFLAGS)
+CFLAGS = -std=gnu99 -Wwrite-strings -Wall $(OPTFLAGS)
+LIBS   = -lm $(EXTLIBS)
+PROGS  = fio
+SCRIPTS = fio_generate_plots
+UNAME  := $(shell uname)
+
 SOURCE := gettime.c fio.c ioengines.c init.c stat.c log.c time.c filesetup.c \
                eta.c verify.c memory.c io_u.c parse.c mutex.c options.c \
                rbtree.c smalloc.c filehash.c profile.c debug.c lib/rand.c \
===========

Greg

On Thu, Mar 28, 2013 at 5:21 PM, Jens Axboe <axboe@kernel.dk> wrote:
> On Wed, Mar 27 2013, Aaron Carroll wrote:
>> On 26 March 2013 05:44, Greg Freemyer <greg.freemyer@gmail.com> wrote:
>> > But this is the basic error which happens on the first gcc call.
>> >
>> > [   48s] gcc -o gettime.o -std=gnu99 -Wwrite-strings -Wall
>> > -fomit-frame-pointer -fmessage-length=0 -grecord-gcc-switches -O2
>> > -Wall -D_FORTIFY_SOURCE=2 -fstack-protector -funwind-tables
>> > -fasynchronous-unwind-tables -DBITS_PER_LONG=32
>> > -DFIO_VERSION='"fio-2.0.14"' -D_LARGEFILE_SOURCE
>> > -D_FILE_OFFSET_BITS=64 -D_FORTIFY_SOURCE=2 -DFIO_INC_DEBUG -c
>> > gettime.c
>>
>> Something has happened to the CFLAGS -- you're missing -D_GNU_SOURCE
>> which is needed for the definition of CPU_ZERO.
>>
>> I can get the same behaviour with:
>>    make EXTFLAGS=
>> but then I got confused looking at the Makefile. I don't understand
>> how that ever works, since EXTFLAGS is used before it's defined.
>
> This should (hopefully) improve the situation. Greg, can you test with
> this?
>
> diff --git a/Makefile b/Makefile
> index ea96a89..cae07c3 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -1,11 +1,3 @@
> -DEBUGFLAGS = -D_FORTIFY_SOURCE=2 -DFIO_INC_DEBUG
> -CPPFLAGS= -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64 $(DEBUGFLAGS)
> -OPTFLAGS= -O3 -g -ffast-math $(EXTFLAGS)
> -CFLAGS = -std=gnu99 -Wwrite-strings -Wall $(OPTFLAGS)
> -LIBS   = -lm $(EXTLIBS)
> -PROGS  = fio
> -SCRIPTS = fio_generate_plots
> -
>  ifneq ($(wildcard config-host.mak),)
>  all:
>  include config-host.mak
> @@ -20,6 +12,14 @@ all:
>  include config-host.mak
>  endif
>
> +DEBUGFLAGS = -D_FORTIFY_SOURCE=2 -DFIO_INC_DEBUG
> +CPPFLAGS= -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64 $(DEBUGFLAGS)
> +OPTFLAGS= -O3 -g -ffast-math $(EXTFLAGS) $(BUILD_CFLAGS)
> +CFLAGS = -std=gnu99 -Wwrite-strings -Wall $(OPTFLAGS)
> +LIBS   = -lm $(EXTLIBS)
> +PROGS  = fio
> +SCRIPTS = fio_generate_plots
> +
>  SOURCE := gettime.c fio.c ioengines.c init.c stat.c log.c time.c filesetup.c \
>                 eta.c verify.c memory.c io_u.c parse.c mutex.c options.c \
>                 rbtree.c smalloc.c filehash.c profile.c debug.c lib/rand.c \
> diff --git a/configure b/configure
> index 836d7ad..13cf8d5 100755
> --- a/configure
> +++ b/configure
> @@ -39,7 +39,7 @@ fatal() {
>
>  # Default CFLAGS
>  CFLAGS="-D_GNU_SOURCE"
> -EXTFLAGS="-include config-host.h"
> +BUILD_CFLAGS="-include config-host.h"
>
>  # Print a helpful header at the top of config.log
>  echo "# FIO configure log $(date)" >> config.log
> @@ -230,7 +230,7 @@ CYGWIN*)
>    output_sym "CONFIG_SCHED_IDLE"
>    output_sym "CONFIG_TCP_NODELAY"
>    echo "CC=$CC" >> $config_host_mak
> -  echo "EXTFLAGS=$CFLAGS -include config-host.h -D_GNU_SOURCE" >> $config_host_mak
> +  echo "BUILD_CFLAGS=$CFLAGS -include config-host.h -D_GNU_SOURCE" >> $config_host_mak
>    exit 0
>    ;;
>  esac
> @@ -1088,4 +1088,4 @@ fi
>
>  echo "LIBS+=$LIBS" >> $config_host_mak
>  echo "CC=$cc" >> $config_host_mak
> -echo "EXTFLAGS=$EXTFLAGS $CFLAGS" >> $config_host_mak
> +echo "BUILD_CFLAGS=$BUILD_CFLAGS $CFLAGS" >> $config_host_mak
>
> --
> Jens Axboe
>

