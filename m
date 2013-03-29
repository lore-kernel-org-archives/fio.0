Return-Path: <greg.freemyer@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20130329145452.GM19488@kernel.dk>
References: <CAGpXXZ+CSFx7tnWjgUibNEgth_9kM4qTP_ptW+kTFeDCfoC08w@mail.gmail.com>
 <CAKCZDgkX1JPo6_+cUzAU3bCo_ceawyd64Ki08BVZS7y4Uoooqg@mail.gmail.com>
 <20130328212151.GG19488@kernel.dk> <CAGpXXZKk_3HEFufkQV0U66Mp=Xm7dFcMWKPbSSJA1nC6C+DWrQ@mail.gmail.com>
 <20130329134001.GH19488@kernel.dk> <CAGpXXZJSKdAqOd3QG5bWmSyrCkK88hSa3ZDaeZgfAF-=8WSVjQ@mail.gmail.com>
 <20130329145452.GM19488@kernel.dk>
From: Greg Freemyer <greg.freemyer@gmail.com>
Date: Fri, 29 Mar 2013 11:31:43 -0400
Message-ID: <CAGpXXZJ9VXt0dkh8W3S4fLYLbzgCN_HjFV3t9c-e13phsNu1Zw@mail.gmail.com>
Subject: Re: FIO 2.0.14 - getting a compile error on opensuse
Content-Type: text/plain; charset=ISO-8859-1
To: Jens Axboe <axboe@kernel.dk>
Cc: Aaron Carroll <aaronc@cse.unsw.edu.au>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

>> On Fri, Mar 29, 2013 at 9:40 AM, Jens Axboe <axboe@kernel.dk> wrote:
>> > On Thu, Mar 28 2013, Greg Freemyer wrote:
>> >> Jens,
>> >>
>> >> It didn't apply?  There was one missing line in Makefile and hunk
>> >> offsets in configure.
>> >>
>> >> Did you diff to fio-2.0.14?
>> >>
>> >> I got my copy via: wget http://brick.kernel.dk/snaps/fio-2.0.14.tar.bz2
>> >
>> > No, I always diff against the git tree.
>> >
>>
>> Here's the portion of the build log starting with the make invocation:
>>  (I notice that it is complaining about config-host.mak missing.  That
>> is probably the source of the problem, but I'll let you comment on
>> that.)
>
> OK, so it's OPTFLAGS reuse. The below should conform more to regular
> builds, can you test that?
>
> diff --git a/Makefile b/Makefile
> index ea96a89..27e82c6 100644
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
> +OPTFLAGS= -O3 -g -ffast-math
> +CFLAGS = -std=gnu99 -Wwrite-strings -Wall $(OPTFLAGS) $(EXTFLAGS) $(BUILD_CFLAGS)
> +LIBS   += -lm $(EXTLIBS)
> +PROGS  = fio
> +SCRIPTS = fio_generate_plots
> +
>  SOURCE := gettime.c fio.c ioengines.c init.c stat.c log.c time.c filesetup.c \
>                 eta.c verify.c memory.c io_u.c parse.c mutex.c options.c \
>                 rbtree.c smalloc.c filehash.c profile.c debug.c lib/rand.c \
> diff --git a/configure b/configure
> index 836d7ad..a3c51fb 100755
> --- a/configure
> +++ b/configure
> @@ -38,8 +38,8 @@ fatal() {
>  }
>
>  # Default CFLAGS
> -CFLAGS="-D_GNU_SOURCE"
> -EXTFLAGS="-include config-host.h"
> +CFLAGS="-D_GNU_SOURCE -include config-host.h"
> +BUILD_CFLAGS=""
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

That did the trick.

Thanks

