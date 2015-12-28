Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:37781 "EHLO
	mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752566AbbL1WY6 (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 28 Dec 2015 17:24:58 -0500
Received: by mail-wm0-f46.google.com with SMTP id f206so22555201wmf.0
        for <fio@vger.kernel.org>; Mon, 28 Dec 2015 14:24:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <VI1PR05MB1343197BD54DC24EA6A2AF65B1FB0@VI1PR05MB1343.eurprd05.prod.outlook.com>
References: <VI1PR05MB1343197BD54DC24EA6A2AF65B1FB0@VI1PR05MB1343.eurprd05.prod.outlook.com>
From: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Date: Tue, 29 Dec 2015 01:24:38 +0300
Message-ID: <CANvN+e=Vdo=zO5jcJQU8FLiiKBRZTun=9XTRixv8VNnoJm7K=w@mail.gmail.com>
Subject: Re: fio-f1480f9: AIX 6.1 build KO against gcc function overlap
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Thierry BERTAUD <tbertaud@conforama.fr>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On Tue, Dec 29, 2015 at 12:45 AM, Thierry BERTAUD <tbertaud@conforama.fr> wrote:
> Hello Fio Team,
>
> The 'send_file' function is defiined twice, so gcc doesn't like the same function with different signature.
> How can i fix this issue and build fio since send_file is used by a system library?
>
> Output from make:
> ---------------
> client.c:1488:12: error: conflicting types for 'send_file'
> static int send_file(struct fio_client *client, struct cmd_sendfile *pdu,

Seems to be AIX sys/socket.h specific, you can just rename the above
to fio_send_file, I believe.

>             ^
> In file included from client.c:11:0:
> /usr/include/sys/socket.h:760:9: note: previous declaration of 'send_file' was here
> ssize_t send_file(int *, struct sf_parms *, uint_t);
> -------------
>
>
> Version:
> AIX:
> # oslevel -s
> 6100-08-01-1245
> #
>
> GCC:
> # gcc --version
> gcc (GCC) 4.8.3
> Copyright (C) 2013 Free Software Foundation, Inc.
> This is free software; see the source for copying conditions.  There is NO
> warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
>
> #
>
>
> Build output:
> # ./configure --disable-lex
> Operating system              AIX
> CPU                           ppc
> Big endian                    yes
> Compiler                      gcc
> Cross compile                 no
>
> Static build                  no
> Wordsize                      32
> zlib                          yes
> Linux AIO support             no
> POSIX AIO support             yes
> POSIX AIO support needs -lrt  no
> POSIX AIO fsync               yes
> Solaris AIO support           no
> __sync_fetch_and_add          no
> libverbs                      no
> rdmacm                        yes
> Linux fallocate               no
> POSIX fadvise                 yes
> POSIX fallocate               yes
> sched_setaffinity(3 arg)      no
> sched_setaffinity(2 arg)      no
> clock_gettime                 yes
> CLOCK_MONOTONIC               yes
> CLOCK_MONOTONIC_RAW           no
> CLOCK_MONOTONIC_PRECISE       no
> gettimeofday                  yes
> fdatasync                     yes
> sync_file_range               no
> EXT4 move extent              no
> Linux splice(2)               no
> GUASI                         no
> Fusion-io atomic engine       no
> libnuma                       no
> strsep                        yes
> strcasestr                    no
> strlcat                       no
> getopt_long_only()            no
> inet_aton                     yes
> socklen_t                     yes
> __thread                      yes
> RUSAGE_THREAD                 yes
> SCHED_IDLE                    no
> TCP_NODELAY                   yes
> Net engine window_size        yes
> TCP_MAXSEG                    yes
> RLIMIT_MEMLOCK                no
> pwritev/preadv                yes
> IPv6 helpers                  yes
> Rados Block Device engine     no
> setvbuf                       yes
> Gluster API engine            no
> s390_z196_facilities          no
> HDFS engine                   no
> MTD                           no
> lex/yacc for arithmetic       no
> getmntent                     yes
> getmntinfo                    no
> Static Assert                 yes
> bool                          yes
> #
> # gmake CC=gcc
> FIO_VERSION = fio-2.3
>     CC crc/crc64.o
>     CC crc/md5.o
>     CC crc/fnv.o
>     CC crc/sha256.o
>     CC crc/test.o
>     CC crc/xxhash.o
>     CC crc/crc32c-intel.o
>     CC crc/murmur3.o
>     CC crc/crc32.o
>     CC crc/crc32c.o
>     CC crc/sha1.o
>     CC crc/crc7.o
>     CC crc/sha512.o
>     CC crc/crc16.o
>     CC lib/gauss.o
>     CC lib/prio_tree.o
>     CC lib/axmap.o
>     CC lib/flist_sort.o
>     CC lib/hweight.o
>     CC lib/zipf.o
>     CC lib/getrusage.o
>     CC lib/output_buffer.o
>     CC lib/memalign.o
>     CC lib/lfsr.o
>     CC lib/bloom.o
>     CC lib/strntol.o
>     CC lib/num2str.o
>     CC lib/mountcheck.o
>     CC lib/pattern.o
> lib/pattern.c: In function 'parse_number':
> lib/pattern.c:77:3: warning: implicit declaration of function 'strcasestr' [-Wimplicit-function-declaration]
>    _end = strcasestr(beg, "0x");
>    ^
> lib/pattern.c:77:8: warning: assignment makes pointer from integer without a cast [enabled by default]
>    _end = strcasestr(beg, "0x");

It looks like AIX defines the strcasetr outside the <string.h>, so you
might want to add AIX-specific include.

Regards,
Andrey

>         ^
>     CC lib/ieee754.o
>     CC lib/rbtree.o
>     CC lib/rand.o
>     CC gettime.o
>     CC ioengines.o
>     CC init.o
>     CC stat.o
>     CC log.o
>     CC time.o
>     CC filesetup.o
>     CC eta.o
>     CC verify.o
>     CC memory.o
>     CC io_u.o
>     CC parse.o
>     CC mutex.o
>     CC options.o
>     CC smalloc.o
>     CC filehash.o
>     CC profile.o
>     CC debug.o
>     CC engines/cpu.o
>     CC engines/mmap.o
>     CC engines/sync.o
>     CC engines/null.o
>     CC engines/net.o
>     CC server.o
>     CC client.o
> client.c:1488:12: error: conflicting types for 'send_file'
> static int send_file(struct fio_client *client, struct cmd_sendfile *pdu,
>             ^
> In file included from client.c:11:0:
> /usr/include/sys/socket.h:760:9: note: previous declaration of 'send_file' was here
> ssize_t send_file(int *, struct sf_parms *, uint_t);
>          ^
> Makefile:289: recipe for target 'client.o' failed
> gmake: *** [client.o] Error 1
> #
>
> Regards,
> Thierry
>   --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
