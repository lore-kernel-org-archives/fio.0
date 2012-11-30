Return-Path: <fio-owner@vger.kernel.org>
Received: from nihrelayxway4.hub.nih.gov ([128.231.90.98]:41826 "EHLO
	nihrelayxway4.hub.nih.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755714Ab2K3Sui (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 30 Nov 2012 13:50:38 -0500
Received: from [130.14.8.205] (ncbipc8205.be-md.ncbi.nlm.nih.gov
 [130.14.8.205])	by mail2.ncbi.nlm.nih.gov (Postfix) with ESMTP id 01E5F28C002
	for <fio@vger.kernel.org>; Fri, 30 Nov 2012 13:50:36 -0500 (EST)
Message-ID: <50B8FFFC.7000602@benslade.com>
Date: Fri, 30 Nov 2012 13:50:36 -0500
From: buysell08 <buysell08@benslade.com>
MIME-Version: 1.0
Subject: Getting 'stat64 already defined' type errors when trying to "make"
 fio on RedHat/Centos 6.3 (linux kernel 2.6.18-308)
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

I'm getting 'stat64 already defined' type errors when trying to "make" fio on RedHat/Centos 6.3 (linux kernel 2.6.18-308).

I couldn't find anything in the www.spinics.net/lists/fio mailing list archives about it.  Has anybody else seen a problem like this?

> make
DEP .depend
CC gettime.o
: Assembler messages:
:354: Error: symbol `fstatat64' is already defined
:388: Error: symbol `fstat64' is already defined
:418: Error: symbol `lstat64' is already defined
:448: Error: symbol `stat64' is already defined
:1704: Error: symbol `pread64' is already defined
make: *** [gettime.o] Error 1


Here's backgound version info from gcc:

> gcc -v
Reading specs from /usr/lib64/gcc-4.4.2/gcc/x86_64-unknown-linux-gnu/4.4.2/specs
Target: x86_64-unknown-linux-gnu
Configured with: ./configure --prefix=/usr/local/gcc/4.4.2 --enable-threads --enable-shared --enable-languages=c,c++ --disable-multilib --with-mpfr=/usr/local/gcc/4.4.2
--libdir=/usr/lib64/gcc-4.4.2 --with-include=/usr/local/gcc/4.4.2/include --with-gxx-include-dir=/usr/local/gcc/4.4.2/include/g++-v3
Thread model: posix
gcc version 4.4.2 (GCC)

> uname -r
2.6.18-308.8.1.el5

Thanks in advance
Ben
