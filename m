Return-Path: <fio-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:54008 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754760AbZIOPeU (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 15 Sep 2009 11:34:20 -0400
Received: by fg-out-1718.google.com with SMTP id 22so902066fge.1
        for <fio@vger.kernel.org>; Tue, 15 Sep 2009 08:34:22 -0700 (PDT)
Message-ID: <4AAFB3FB.5080404@nowhere.dk>
Date: Tue, 15 Sep 2009 17:34:19 +0200
From: Allan Willems Joergensen <allan@nowhere.dk>
MIME-Version: 1.0
Subject: Compile error on IA64
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi,

I'm trying to compile fio on a Linux/IA64 machine; it fails.

# make
     CC gettime.o
     CC fio.o
     CC ioengines.o
     CC init.o
     CC stat.o
     CC log.o
     CC time.o
     CC filesetup.o
     CC eta.o
     CC verify.o
verify.c: In function `verify_async_init':
verify.c:896: warning: implicit declaration of function `write_barrier'
     CC memory.o
     CC io_u.o
     CC parse.o
     CC mutex.o
     CC options.o
     CC rbtree.o
     CC diskutil.o
     CC fifo.o
     CC blktrace.o
     CC smalloc.o
     CC filehash.o
     CC crc/crc7.o
     CC crc/crc16.o
     CC crc/crc32.o
     CC crc/crc32c.o
     CC crc/crc32c-intel.o
     CC crc/crc64.o
     CC crc/sha1.o
     CC crc/sha256.o
     CC crc/sha512.o
     CC crc/md5.o
     CC engines/cpu.o
     CC engines/libaio.o
     CC engines/mmap.o
     CC engines/posixaio.o
     CC engines/sg.o
     CC engines/splice.o
     CC engines/sync.o
     CC engines/null.o
     CC engines/net.o
     CC engines/syslet-rw.o
     CC engines/guasi.o
     DEP depend
     CC fio
verify.o(.text+0x52): In function `verify_async_exit':
/usr/local/src/fio/verify.c:907: undefined reference to `write_barrier'
verify.o(.text+0x7a2): In function `verify_async_init':
/usr/local/src/fio/verify.c:896: undefined reference to `write_barrier'
collect2: ld returned 1 exit status
make: *** [fio] Error 1

# uname -a
Linux xxxxxxxx 2.6.5-7.315-default #1 SMP Wed Nov 26 13:03:18 UTC 2008 
ia64 ia64 ia64 GNU/Linux

# cat /etc/SuSE-release
SUSE LINUX Enterprise Server 9 (ia64)
VERSION = 9
PATCHLEVEL = 3

Any ideas? Am I missing something (devel package, library) or is it a 
platform issue?

tia,

-- 
Med venlig hilsen / Best regards
Allan Willems Joergensen

"The weak die, the strong survive" - Toq

