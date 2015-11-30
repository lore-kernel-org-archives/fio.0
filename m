Return-Path: <m.eaton82@gmail.com>
MIME-Version: 1.0
In-Reply-To: <56568A13.7020703@kernel.dk>
References: <CAF+0mvmGOrVdpaobMa-ChSz2qPJqhE1s+qUbJpdHPpEo+UKcww@mail.gmail.com>
	<56533A11.4050706@kernel.dk>
	<56533BE5.3010606@kernel.dk>
	<CAF+0mv=KWZ-_VGEFLhDzh70E2ztr7esdjOpQR-wdLJ-eQ-mRng@mail.gmail.com>
	<5653D5EA.1060201@kernel.dk>
	<CAF+0mvnKfMNX-Pb1mYrQYubDqJJj84C0NQKVzMAGOoR84Qt8zg@mail.gmail.com>
	<5655F003.1000208@kernel.dk>
	<CAF+0mvmBhA7zWkoOuTiw_F=4qo+4QwSHKQwTVNtL1=hTnTsgNg@mail.gmail.com>
	<56568A13.7020703@kernel.dk>
Date: Mon, 30 Nov 2015 13:17:25 -0800
Message-ID: <CAF+0mvkM4AQzkJ=gt+_rQLKjKPFKr4xJjRb5NkdAqLbBsyakug@mail.gmail.com>
Subject: Re: Bug with --buffer_compress_percentage
From: Matthew Eaton <m.eaton82@gmail.com>
Content-Type: text/plain; charset=UTF-8
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

> I think I found and fixed the main issue why the rebuild issue would happen,
> init.c didn't get the right dependencies. Hopefully a make clean won't be
> needed going forward.
>
> I still think that is your issue, I don't see any problems with the buffer
> filling. So do let me know when you test on Monday, thanks.
>
> --
> Jens Axboe
>

I tested again trying a make clean as well as a fresh clone from git
but I could still reproduce.  This system is Ubuntu 14.04, so for
kicks I moved to a completely different system and installed Fedora 23
and fio from git, but had the same problem!

This is my configure output.  Could I be missing something?

Operating system              Linux
CPU                           x86_64
Big endian                    no
Compiler                      gcc
Cross compile                 no

Static build                  no
Wordsize                      64
zlib                          yes
Linux AIO support             yes
POSIX AIO support             yes
POSIX AIO support needs -lrt  yes
POSIX AIO fsync               yes
Solaris AIO support           no
__sync_fetch_and_add          yes
libverbs                      yes
rdmacm                        yes
Linux fallocate               yes
POSIX fadvise                 yes
POSIX fallocate               yes
sched_setaffinity(3 arg)      yes
sched_setaffinity(2 arg)      no
clock_gettime                 yes
CLOCK_MONOTONIC               yes
CLOCK_MONOTONIC_RAW           yes
CLOCK_MONOTONIC_PRECISE       no
gettimeofday                  yes
fdatasync                     yes
sync_file_range               yes
EXT4 move extent              yes
Linux splice(2)               yes
GUASI                         no
Fusion-io atomic engine       no
libnuma                       no
strsep                        yes
strcasestr                    yes
strlcat                       no
getopt_long_only()            yes
inet_aton                     yes
socklen_t                     yes
__thread                      yes
RUSAGE_THREAD                 yes
SCHED_IDLE                    yes
TCP_NODELAY                   yes
Net engine window_size        yes
TCP_MAXSEG                    yes
RLIMIT_MEMLOCK                yes
pwritev/preadv                yes
IPv6 helpers                  yes
Rados Block Device engine     no
setvbuf                       yes
Gluster API engine            no
s390_z196_facilities          no
HDFS engine                   no
MTD                           yes
lex/yacc for arithmetic       no
getmntent                     yes
getmntinfo                    no
Static Assert                 yes

