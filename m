Return-Path: <greg.freemyer@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20130329134001.GH19488@kernel.dk>
References: <CAGpXXZ+CSFx7tnWjgUibNEgth_9kM4qTP_ptW+kTFeDCfoC08w@mail.gmail.com>
 <CAKCZDgkX1JPo6_+cUzAU3bCo_ceawyd64Ki08BVZS7y4Uoooqg@mail.gmail.com>
 <20130328212151.GG19488@kernel.dk> <CAGpXXZKk_3HEFufkQV0U66Mp=Xm7dFcMWKPbSSJA1nC6C+DWrQ@mail.gmail.com>
 <20130329134001.GH19488@kernel.dk>
From: Greg Freemyer <greg.freemyer@gmail.com>
Date: Fri, 29 Mar 2013 10:14:18 -0400
Message-ID: <CAGpXXZJSKdAqOd3QG5bWmSyrCkK88hSa3ZDaeZgfAF-=8WSVjQ@mail.gmail.com>
Subject: Re: FIO 2.0.14 - getting a compile error on opensuse
Content-Type: text/plain; charset=ISO-8859-1
To: Jens Axboe <axboe@kernel.dk>
Cc: Aaron Carroll <aaronc@cse.unsw.edu.au>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

Greg Freemyer
Chief Technology Officer
Intelligent Avatar Corporation

(678) 653-4860
Greg.Freemyer@gmail.com
http://www.linkedin.com/in/gregfreemyer
CNN/TruTV Aired Forensic Imaging Demo -
   http://insession.blogs.cnn.com/2010/03/23/how-computer-evidence-gets-retrieved/


On Fri, Mar 29, 2013 at 9:40 AM, Jens Axboe <axboe@kernel.dk> wrote:
> On Thu, Mar 28 2013, Greg Freemyer wrote:
>> Jens,
>>
>> It didn't apply?  There was one missing line in Makefile and hunk
>> offsets in configure.
>>
>> Did you diff to fio-2.0.14?
>>
>> I got my copy via: wget http://brick.kernel.dk/snaps/fio-2.0.14.tar.bz2
>
> No, I always diff against the git tree.
>

Here's the portion of the build log starting with the make invocation:
 (I notice that it is complaining about config-host.mak missing.  That
is probably the source of the problem, but I'll let you comment on
that.)

==================
/usr/bin/make V=1 'OPTFLAGS=-fmessage-length=0 -O2 -Wall
-D_FORTIFY_SOURCE=2 -fstack-protector -funwind-tables
-fasynchronous-unwind-tables' CC=gcc prefix=/usr libdir=/usr/lib64/fio
mandir=/usr/share/man
[   34s] Makefile:13: config-host.mak: No such file or directory
[   35s] FIO_VERSION = fio-2.0.14
[   35s] Running configure for you...
[   36s] Operating system              Linux
[   36s] CPU                           x86_64
[   36s] Big endian                    no
[   36s] Compiler                      gcc
[   36s]
[   36s] Wordsize                      64
[   36s] Linux AIO support             yes
[   37s] POSIX AIO support             yes
[   37s] POSIX AIO support needs -lrt  yes
[   37s] POSIX AIO fsync               yes
[   37s] Solaris AIO support           no
[   37s] __sync_fetch_and add          yes
[   37s] libverbs                      no
[   37s] rdmacm                        no
[   37s] Linux fallocate               yes
[   38s] POSIX fadvise                 yes
[   38s] POSIX fallocate               yes
[   38s] sched_setaffinity(3 arg)      yes
[   38s] sched_setaffinity(2 arg)      no
[   38s] clock_gettime                 yes
[   39s] CLOCK_MONOTONIC               yes
[   39s] CLOCK_MONOTONIC_PRECISE       no
[   39s] gettimeofday                  yes
[   39s] fdatasync                     yes
[   39s] sync_file_range               yes
[   39s] EXT4 move extent              yes
[   40s] Linux splice(2)               yes
[   40s] GUASI                         no
[   40s] Fusion-io atomic engine       no
[   40s] libnuma                       no
[   40s] strsep                        yes
[   40s] getopt_long_only()            yes
[   40s] inet_aton                     yes
[   41s] socklen_t                     yes
[   41s] __thread                      yes
[   41s] RUSAGE_THREAD                 yes
[   41s] SCHED_IDLE                    yes
[   42s] TCP_NODELAY                   yes
[   42s] gcc -o gettime.o -std=gnu99 -Wwrite-strings -Wall
-fmessage-length=0 -O2 -Wall -D_FORTIFY_SOURCE=2 -fstack-protector
-funwind-tables -fasynchronous-unwind-tables -DBITS_PER_LONG=64
-DFIO_VERSION='"fio-2.0.14"' -D_LARGEFILE_SOURCE
-D_FILE_OFFSET_BITS=64 -D_FORTIFY_SOURCE=2 -DFIO_INC_DEBUG -c
gettime.c
[   42s] In file included from os/os.h:28:0,
[   42s]                  from fio.h:24,
[   42s]                  from gettime.c:10:
[   42s] os/os-linux.h: In function 'fio_cpuset_init':
[   42s] os/os-linux.h:67:2: warning: implicit declaration of function
'CPU_ZERO' [-Wimplicit-function-declaration]
[   42s] In file included from os/os.h:60:0,
[   42s]                  from fio.h:24,
[   42s]                  from gettime.c:10:
[   42s] os/../lib/strsep.h: At top level:
[   42s] os/../lib/strsep.h:4:7: error: expected identifier or '('
before '__extension__'
[   42s] os/../lib/strsep.h:4:7: error: expected identifier or '('
before ')' token
[   42s] In file included from fio.h:32:0,
[   42s]                  from gettime.c:10:
[   42s] helpers.h:11:36: error: unknown type name 'off64_t'
[   42s] helpers.h:11:52: error: unknown type name 'off64_t'
[   42s] make: *** [gettime.o] Error 1
[   42s] error: Bad exit status from /var/tmp/rpm-tmp.4n6SDR (%build)
[   42s]

===========

Greg

