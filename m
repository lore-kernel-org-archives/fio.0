Return-Path: <fio-owner@vger.kernel.org>
Received: from mx12.netapp.com ([216.240.18.77]:29283 "EHLO mx12.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753491Ab3A3D7n convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Tue, 29 Jan 2013 22:59:43 -0500
Received: from vmwexceht05-prd.hq.netapp.com (vmwexceht05-prd.hq.netapp.com [10.106.77.35])
	by smtp1.corp.netapp.com (8.13.1/8.13.1/NTAP-1.6) with ESMTP id r0U3xhX6012549
	for <fio@vger.kernel.org>; Tue, 29 Jan 2013 19:59:43 -0800 (PST)
From: "Neto, Antonio Jose Rodrigues" 
	<Antonio.Jose.Rodrigues.Neto@netapp.com>
Subject: Re: Compiling fio on Windows
Date: Wed, 30 Jan 2013 03:59:42 +0000
Message-ID: <843E15216120C047928F6879B0E2D9240F6D49A3@SACEXCMBX02-PRD.hq.netapp.com>
In-Reply-To: <843E15216120C047928F6879B0E2D9240F6D40FE@SACEXCMBX02-PRD.hq.netapp.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <CFA9F9CF7CB68E44B2675E24DE86B17D@tahoe.netapp.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Neto, Antonio Jose Rodrigues" <Antonio.Jose.Rodrigues.Neto@netapp.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>


On 1/29/13 6:29 PM, "Neto, Antonio Jose Rodrigues"
<Antonio.Jose.Rodrigues.Neto@netapp.com> wrote:

>Hi All,
>
>This is neto from Brazil
>
>How are you?
>
>How do I compile fio on Windows? I've installed Cygwin (with MinGW
>packages) but I've got an error after to compile.
>
>Just create a simple C code "hello World" and it compiles.
>
>Trying with Cygwin (I installed x86_64-w64-mingw32-gcc.exe packages)
>
>$ make
>Makefile:21: config-host.mak: No such file or directory
>FIO_VERSION = fio-2.0.13
>Running configure for you...
>Forcing known good options on Windows
>    DEP .depend
>    CC gettime.o
>    CC fio.o
>    CC ioengines.o
>    CC init.o
>    CC stat.o
>    CC log.o
>    CC time.o
>    CC filesetup.o
>    CC eta.o
>    CC verify.o
>    CC memory.o
>    CC io_u.o
>    CC parse.o
>    CC mutex.o
>    CC options.o
>    CC rbtree.o
>    CC smalloc.o
>    CC filehash.o
>    CC profile.o
>    CC debug.o
>    CC lib/rand.o
>    CC lib/num2str.o
>    CC lib/ieee754.o
>    CC crc/crc64.o
>    CC crc/md5.o
>    CC crc/sha256.o
>    CC crc/crc32c-intel.o
>    CC crc/crc32.o
>    CC crc/crc32c.o
>    CC crc/sha1.o
>    CC crc/crc7.o
>    CC crc/sha512.o
>    CC crc/crc16.o
>    CC engines/cpu.o
>    CC engines/sync.o
>    CC engines/null.o
>    CC engines/net.o
>    CC memalign.o
>    CC server.o
>    CC client.o
>    CC iolog.o
>    CC backend.o
>    CC libfio.o
>    CC flow.o
>    CC json.o
>    CC lib/zipf.o
>    CC lib/axmap.o
>    CC lib/lfsr.o
>    CC gettime-thread.o
>    CC helpers.o
>    CC lib/flist_sort.o
>    CC lib/hweight.o
>    CC lib/getrusage.o
>    CC engines/windowsaio.o
>    CC lib/strsep.o
>    CC lib/getopt_long.o
>    CC lib/inet_aton.o
>    CC os/windows/posix.o
>    CC fio
>
>When I try to execute fio, I've got an error:
>
>"The application was unable to start correctly (0xc000007b). Click OK to
>close the application" that means bad image.
>
>Does anyone have a step by step installation how to compile to help me?
>
>Thank you very much
>
>neto

Hi All,

This is neto from Brazil

How are you?

Doing some researches, I found!

Basically we need to install Cygwin plus MinGW64 (I just downloaded from
here: 
http://sourceforge.net/projects/mingw-w64/files/Toolchains%20targetting%20W
in64/Personal%20Builds/rubenvb/release/x86_64-w64-mingw32-gcc-4.5.4-release
-win64_rubenvb.7z/download

I will generate a step by step and I will send to everybody.

Thank you very much

All the best

neto

