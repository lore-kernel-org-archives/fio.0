Return-Path: <yamamoto@valinux.co.jp>
Subject: Re: fio netbsd support
In-Reply-To: Your message of "Wed, 12 May 2010 15:06:08 +0200"
	<20100512130608.GC25951@kernel.dk>
References: <20100512130608.GC25951@kernel.dk>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Message-Id: <20100520091826.3CE7C710AF@kuma.localdomain>
Date: Thu, 20 May 2010 18:18:26 +0900 (JST)
From: yamamoto@valinux.co.jp (YAMAMOTO Takashi)
To: jens.axboe@oracle.com
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

> On Wed, May 12 2010, YAMAMOTO Takashi wrote:
>> hi,
>> 
>> the attached patch is for preliminary support for netbsd.
> 
> Thanks, looks good. Applied. The rb bit is a bit icky, but we can fix
> that up later.
> 
> -- 
> Jens Axboe

thanks.

it seems that the following small change is necessary to catch up with
the recent changes.

YAMAMOTO Takashi


Signed-off-by: YAMAMOTO Takashi <yamamoto@valinux.co.jp>

diff --git a/Makefile.NetBSD b/Makefile.NetBSD
index 2fb089e..c223ab2 100644
--- a/Makefile.NetBSD
+++ b/Makefile.NetBSD
@@ -8,6 +8,9 @@ OBJS = gettime.o fio.o ioengines.o init.o stat.o log.o time.o filesetup.o \
 	eta.o verify.o memory.o io_u.o parse.o mutex.o options.o \
 	rbtree.o smalloc.o filehash.o helpers.o profile.o debug.o
 
+OBJS += lib/rand.o
+OBJS += lib/flist_sort.o
+
 OBJS += crc/crc7.o
 OBJS += crc/crc16.o
 OBJS += crc/crc32.o

