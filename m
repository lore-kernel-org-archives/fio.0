Return-Path: <fio-owner@vger.kernel.org>
Received: from [95.166.99.235] ([95.166.99.235]:38701 "EHLO kernel.dk"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750859Ab1G3LX4 (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 30 Jul 2011 07:23:56 -0400
Message-ID: <4E33E9C8.1060209@kernel.dk>
Date: Sat, 30 Jul 2011 13:23:52 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [PATCH] Use pthread_self instead of thr_self on BSD
References: <4E33D245.6060301@cran.org.uk> <4E33E304.8030606@kernel.dk> <4E33E84F.2060705@cran.org.uk>
In-Reply-To: <4E33E84F.2060705@cran.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Bruce Cran <bruce@cran.org.uk>
Cc: fio@vger.kernel.org

On 2011-07-30 13:17, Bruce Cran wrote:
> On 30/07/2011 11:55, Jens Axboe wrote:
>> On 2011-07-30 11:43, Bruce Cran wrote:
>>> The attached patch uses pthread_self to get the thread ID instead of the
>>> non-POSIX thr_self This fixes a compiler warning on FreeBSD.
>> Does pthread_self() return a thread ID in the PID name space, so to
>> speak?
>>
> 
> Hmm no, it doesn't seem to. In that case <sys/thr.h> should probably be 
> included to get the definition of thr_self().

I suspected as much, most OS' will return a unique ID but not something
you can otherwise use. How about the below?

diff --git a/os/os-freebsd.h b/os/os-freebsd.h
index fad051f..317d403 100644
--- a/os/os-freebsd.h
+++ b/os/os-freebsd.h
@@ -4,6 +4,7 @@
 #include <errno.h>
 #include <sys/sysctl.h>
 #include <sys/disk.h>
+#include <sys/thr.h>
 
 #include "../file.h"
 
diff --git a/os/os-netbsd.h b/os/os-netbsd.h
index 7f5f484..e03866d 100644
--- a/os/os-netbsd.h
+++ b/os/os-netbsd.h
@@ -3,6 +3,7 @@
 
 #include <errno.h>
 #include <sys/param.h>
+#include <sys/thr.h>
 /* XXX hack to avoid confilcts between rbtree.h and <sys/rb.h> */
 #define	rb_node	_rb_node
 #include <sys/sysctl.h>

-- 
Jens Axboe

