Return-Path: <bruce@cran.org.uk>
Message-ID: <554BD8A5.6040104@cran.org.uk>
Date: Thu, 07 May 2015 15:27:01 -0600
From: Bruce Cran <bruce@cran.org.uk>
MIME-Version: 1.0
Subject: Re: [PATCH] Add Windows ctime_r implementation and empty ioctl.h
 header
References: <554ADC87.2070605@cran.org.uk> <554B99DD.2000902@kernel.dk> <554BD378.70209@cran.org.uk> <554BD3CE.6090609@kernel.dk>
In-Reply-To: <554BD3CE.6090609@kernel.dk>
Content-Type: multipart/mixed;
 boundary="------------090001050600000004060609"
To: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

This is a multi-part message in MIME format.
--------------090001050600000004060609
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit

On 5/7/2015 3:06 PM, Jens Axboe wrote:
>
> Thanks, added

And another patch, since my tree wasn't quite up-to-date: this time to 
add <limits.h> to eta.c and define _POSIX_HOST_NAME_MAX.

-- 
Bruce

--------------090001050600000004060609
Content-Type: text/plain; charset=windows-1252;
 name="0001-Fix-Windows-build-add-limits.h-to-eta.c-and-define-_.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-Fix-Windows-build-add-limits.h-to-eta.c-and-define-_.pa";
 filename*1="tch"

From eeb938efb2d79cd53fee8cd60f6d07033e37cbf1 Mon Sep 17 00:00:00 2001
From: Bruce Cran <bruce.cran@gmail.com>
Date: Thu, 7 May 2015 15:24:45 -0600
Subject: [PATCH] Fix Windows build: add limits.h to eta.c and define
 _POSIX_HOST_NAME_MAX

---
 eta.c              | 1 +
 os/windows/posix.h | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/eta.c b/eta.c
index e458457..a5a8f53 100644
--- a/eta.c
+++ b/eta.c
@@ -4,6 +4,7 @@
 #include <unistd.h>
 #include <fcntl.h>
 #include <string.h>
+#include <limits.h>
 
 #include "fio.h"
 #include "lib/pow2.h"
diff --git a/os/windows/posix.h b/os/windows/posix.h
index 85640a2..3b4865f 100644
--- a/os/windows/posix.h
+++ b/os/windows/posix.h
@@ -4,6 +4,8 @@
 typedef off_t off64_t;
 typedef int clockid_t;
 
+#define _POSIX_HOST_NAME_MAX 255
+
 extern int clock_gettime(clockid_t clock_id, struct timespec *tp);
 extern int inet_aton(const char *, struct in_addr *);
 extern int win_to_posix_error(DWORD winerr);
-- 
1.9.5.msysgit.1


--------------090001050600000004060609--

