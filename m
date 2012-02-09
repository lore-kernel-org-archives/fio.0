Return-Path: <fio-owner@vger.kernel.org>
Received: from xyratex197.xyratex.com ([194.131.166.197]:45290 "EHLO
	XY01EX21.xy01.xyratex.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757957Ab2BIPeD convert rfc822-to-8bit
	(ORCPT <rfc822;fio@vger.kernel.org>); Thu, 9 Feb 2012 10:34:03 -0500
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: latest fio source code check using cppcheck
Date: Thu, 9 Feb 2012 07:19:14 -0800
Message-ID: <0FEAAA2D70C89D49A62173478A6C4A5D02CFADCE@XYUS-EX22.xyus.xyratex.com>
From: "Roger Sibert" <Roger_Sibert@us.xyratex.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

I was going through my own source code attempting to clean up the code
and spotted the new drop of fio.  On occasion I write something in C
which gets passed along so I do try to maintain proper coding, I
recently took to checking my code with cppcheck to make sure it would
atleast pass static coding checks.

cppcheck is opensource and available at sourceforge, I am using the
latest version not the one that comes in most linux distros. 

CAVEAT EMPTOR - static code checks can generate some false hits

From the root directory of the latest git of the source 

cppcheck --enable=all -f .
or if you want more detail in the error reports
cppcheck --enable=all -f -v .

That will force a check of all ifdefs (yes fio has a bunch) and return
all possible errors and style based issues.

To keep it brief a quick cut and paste instead of the entire return.

Checking crc/crc32c-intel.c: __ia64__...
[arch/arch-ia64.h:34]: (style) Statements following return, break,
continue, goto or throw will never be executed

Checking mutex.c: MADV_FREE;__FreeBSD__...
[mutex.c:26]: (style) Variable 'mflag' is assigned a value that is never
used

Checking mutex.c: MADV_FREE;__sun__...
[os/os-solaris.h:114]: (style) The scope of the variable 'ret' can be
reduced
[os/os-solaris.h:126]: (style) The scope of the variable 'ret' can be
reduced
[os/os-solaris.h:114]: (style) Variable 'ret' is assigned a value that
is never used
[os/os-solaris.h:126]: (style) Variable 'ret' is assigned a value that
is never used

Checking mutex.c: __CYGWIN__...
[os/os-windows.h:151]: (style) The scope of the variable 'winpid' can be
reduced
[os/os-windows.h:125]: (error) Common realloc mistake: 'ids' nulled but
not freed upon failure

[lib/getopt_long.c:41]: (style) The function 'getopt_long_only' is never
used
[lib/num2str.c:8]: (style) The function 'num2str' is never used

Checking parse.c...
[parse.c:183]: (error) Memory leak: c
[parse.c:224]: (warning) scanf without field width limits can crash with
huge input data
[parse.c:324]: (warning) scanf without field width limits can crash with
huge input data
[parse.c:327]: (warning) scanf without field width limits can crash with
huge input data

[lib/getopt_long.c:41]: (style) The function 'getopt_long_only' is never
used
[lib/num2str.c:8]: (style) The function 'num2str' is never used
(information) Cppcheck cannot find all the include files (use
--check-config for details)

The result of the --check-config
Checking t/ieee754.c...
[t/ieee754.c:2]: (information) Include file: "../ieee754.h" not found

For completeness.

Linux virtually-putzu 2.6.32-31-generic #61-Ubuntu SMP Fri Apr 8
18:25:51 UTC 2011 x86_64 GNU/Linux

Thanks,
Roger
