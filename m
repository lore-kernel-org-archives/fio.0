Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:53186 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758522Ab2BITzX (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 9 Feb 2012 14:55:23 -0500
Message-ID: <4F3424A7.5050301@kernel.dk>
Date: Thu, 09 Feb 2012 20:55:19 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: latest fio source code check using cppcheck
References: <0FEAAA2D70C89D49A62173478A6C4A5D02CFADCE@XYUS-EX22.xyus.xyratex.com>
In-Reply-To: <0FEAAA2D70C89D49A62173478A6C4A5D02CFADCE@XYUS-EX22.xyus.xyratex.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Roger Sibert <Roger_Sibert@us.xyratex.com>
Cc: fio@vger.kernel.org

On 2012-02-09 16:19, Roger Sibert wrote:
> I was going through my own source code attempting to clean up the code
> and spotted the new drop of fio.  On occasion I write something in C
> which gets passed along so I do try to maintain proper coding, I
> recently took to checking my code with cppcheck to make sure it would
> atleast pass static coding checks.
> 
> cppcheck is opensource and available at sourceforge, I am using the
> latest version not the one that comes in most linux distros. 
> 
> CAVEAT EMPTOR - static code checks can generate some false hits
> 
> From the root directory of the latest git of the source 
> 
> cppcheck --enable=all -f .
> or if you want more detail in the error reports
> cppcheck --enable=all -f -v .
> 
> That will force a check of all ifdefs (yes fio has a bunch) and return
> all possible errors and style based issues.
> 
> To keep it brief a quick cut and paste instead of the entire return.

Thanks, a few useful ones in there. I've applied a joint fix for them.

> Checking crc/crc32c-intel.c: __ia64__...
> [arch/arch-ia64.h:34]: (style) Statements following return, break,
> continue, goto or throw will never be executed

Not sure what this is trying to say.

> Checking mutex.c: MADV_FREE;__FreeBSD__...
> [mutex.c:26]: (style) Variable 'mflag' is assigned a value that is never
> used

Not a bug, but can be cleaned up. Done.

> Checking mutex.c: MADV_FREE;__sun__...
> [os/os-solaris.h:114]: (style) The scope of the variable 'ret' can be
> reduced
> [os/os-solaris.h:126]: (style) The scope of the variable 'ret' can be
> reduced
> [os/os-solaris.h:114]: (style) Variable 'ret' is assigned a value that
> is never used
> [os/os-solaris.h:126]: (style) Variable 'ret' is assigned a value that
> is never used

Killed 'ret', not needed.

> Checking mutex.c: __CYGWIN__...
> [os/os-windows.h:151]: (style) The scope of the variable 'winpid' can be
> reduced

Pointless.

> [os/os-windows.h:125]: (error) Common realloc mistake: 'ids' nulled but
> not freed upon failure

Don't immediately see anything wrong here.

> [lib/getopt_long.c:41]: (style) The function 'getopt_long_only' is never
> used
> [lib/num2str.c:8]: (style) The function 'num2str' is never used

Both are used.

> Checking parse.c...
> [parse.c:183]: (error) Memory leak: c

Bug fixed.

> [parse.c:224]: (warning) scanf without field width limits can crash with
> huge input data
> [parse.c:324]: (warning) scanf without field width limits can crash with
> huge input data
> [parse.c:327]: (warning) scanf without field width limits can crash with
> huge input data

Single value, not bothering with these.

> [lib/getopt_long.c:41]: (style) The function 'getopt_long_only' is never
> used
> [lib/num2str.c:8]: (style) The function 'num2str' is never used

Duplicate, they are used.

-- 
Jens Axboe

