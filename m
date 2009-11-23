Return-Path: <4711@gnurz.de>
Message-ID: <44735.194.113.141.20.1258982494.squirrel@webmail.s-itc.de>
In-Reply-To: <20091123125912.GZ8742@kernel.dk>
References: <58349.194.113.141.20.1258623572.squirrel@webmail.s-itc.de>
    <20091119201417.GJ8742@kernel.dk> <20091123120318.GW8742@kernel.dk>
    <25005.194.113.141.20.1258978389.squirrel@webmail.s-itc.de>
    <20091123121420.GX8742@kernel.dk>
    <13958.194.113.141.20.1258980688.squirrel@webmail.s-itc.de>
    <20091123125912.GZ8742@kernel.dk>
Date: Mon, 23 Nov 2009 14:21:34 +0100 (CET)
Subject: Re: Fio on solaris
From: "Tom" <4711@gnurz.de>
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Tom <4711@gnurz.de>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

I search both on my server and found nothing, so I ask grandma google and
I found this:

Don't use the POSIX_MEMALIGN function on solaris.

on
http://www.ruby-forum.com/topic/165346

in a Website which is not our theme, but interessting.

I try to find it with grep:

# grep memalign /usr/include/stdlib.h
extern void *memalign(size_t, size_t);
extern void *memalign();

# grep fallocate /usr/include/stdlib.h
# grep fallocate /usr/include/*


Tom

> On Mon, Nov 23 2009, Tom wrote:
>> sorry to say that, but it won't run:
>>
>> > gmake -f Makefile.solaris
>> gcc -Wall -O2 -g -D_GNU_SOURCE -D_LARGEFILE_SOURCE
>> -D_FILE_OFFSET_BITS=64
>> -DFIO_INC_DEBUG -o fio gettime.o fio.o ioengines.o init.o stat.o log.o
>> time.o filesetup.o eta.o verify.o memory.o io_u.o parse.o mutex.o
>> options.o rbtree.o fifo.o smalloc.o filehash.o lib/strsep.o crc/crc7.o
>> crc/crc16.o crc/crc32.o crc/crc32c.o crc/crc32c-intel.o crc/crc64.o
>> crc/sha1.o crc/sha256.o crc/sha512.o crc/md5.o engines/cpu.o
>> engines/mmap.o engines/posixaio.o engines/sync.o engines/null.o
>> engines/net.o engines/solarisaio.o  -lpthread -lm -ldl -laio -lrt -lnsl
>> -lsocket
>> Undefined                       first referenced
>>  symbol                             in file
>> posix_fallocate                     filesetup.o
>> posix_memalign                      fio.o
>> ld: fatal: Symbol referencing errors. No output written to fio
>> collect2: ld returned 1 exit status
>> gmake: *** [fio] Error 1
>>
>>
>> What I have here:
>> > uname -a
>> SunOS servername 5.10 Generic_141415-07 i86pc i386 i86pc
>
> So apparently that version doesn't have posix_fallocate or
> posix_memalign, that's a bit odd. What I tested on:
>
> $ uname -a
> SunOS unknown 5.11 snv_117 sun4v sparc sun4v
>
> It builds and links fine for me. If you have the time, can you double
> check if it's hiding on your system in some other lib that isn't linked
> in? I take it you don't get any compile warnings on missing
> declarations, it's just the linker error?
>
> --
> Jens Axboe
>
>





