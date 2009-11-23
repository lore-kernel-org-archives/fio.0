Return-Path: <fio-owner@vger.kernel.org>
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:59040 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757294AbZKWM7H (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 23 Nov 2009 07:59:07 -0500
Date: Mon, 23 Nov 2009 13:59:12 +0100
From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Fio on solaris
Message-ID: <20091123125912.GZ8742@kernel.dk>
References: <58349.194.113.141.20.1258623572.squirrel@webmail.s-itc.de> <20091119201417.GJ8742@kernel.dk> <20091123120318.GW8742@kernel.dk> <25005.194.113.141.20.1258978389.squirrel@webmail.s-itc.de> <20091123121420.GX8742@kernel.dk> <13958.194.113.141.20.1258980688.squirrel@webmail.s-itc.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <13958.194.113.141.20.1258980688.squirrel@webmail.s-itc.de>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Tom <4711@gnurz.de>
Cc: fio@vger.kernel.org

On Mon, Nov 23 2009, Tom wrote:
> sorry to say that, but it won't run:
> 
> > gmake -f Makefile.solaris
> gcc -Wall -O2 -g -D_GNU_SOURCE -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64
> -DFIO_INC_DEBUG -o fio gettime.o fio.o ioengines.o init.o stat.o log.o
> time.o filesetup.o eta.o verify.o memory.o io_u.o parse.o mutex.o
> options.o rbtree.o fifo.o smalloc.o filehash.o lib/strsep.o crc/crc7.o
> crc/crc16.o crc/crc32.o crc/crc32c.o crc/crc32c-intel.o crc/crc64.o
> crc/sha1.o crc/sha256.o crc/sha512.o crc/md5.o engines/cpu.o
> engines/mmap.o engines/posixaio.o engines/sync.o engines/null.o
> engines/net.o engines/solarisaio.o  -lpthread -lm -ldl -laio -lrt -lnsl
> -lsocket
> Undefined                       first referenced
>  symbol                             in file
> posix_fallocate                     filesetup.o
> posix_memalign                      fio.o
> ld: fatal: Symbol referencing errors. No output written to fio
> collect2: ld returned 1 exit status
> gmake: *** [fio] Error 1
> 
> 
> What I have here:
> > uname -a
> SunOS servername 5.10 Generic_141415-07 i86pc i386 i86pc

So apparently that version doesn't have posix_fallocate or
posix_memalign, that's a bit odd. What I tested on:

$ uname -a
SunOS unknown 5.11 snv_117 sun4v sparc sun4v

It builds and links fine for me. If you have the time, can you double
check if it's hiding on your system in some other lib that isn't linked
in? I take it you don't get any compile warnings on missing
declarations, it's just the linker error?

-- 
Jens Axboe

