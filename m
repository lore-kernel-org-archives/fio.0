Return-Path: <fio-owner@vger.kernel.org>
Received: from muon.bluestop.org ([74.50.51.35]:17054 "EHLO muon.cran.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754845AbcAVSQT (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 22 Jan 2016 13:16:19 -0500
Subject: Re: Windows Make Broken
References: <BN3PR0401MB14571048CD0CFE7699E18400F7C30@BN3PR0401MB1457.namprd04.prod.outlook.com>
 <56A1536A.6060308@cran.org.uk> <56A1AD7C.3060802@kernel.dk>
From: Bruce Cran <bruce@cran.org.uk>
Message-ID: <56A271EF.6040401@cran.org.uk>
Date: Fri, 22 Jan 2016 11:16:15 -0700
MIME-Version: 1.0
In-Reply-To: <56A1AD7C.3060802@kernel.dk>
Content-Type: multipart/mixed;
 boundary="------------000407060000000707030707"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, Jeff Furlong <jeff.furlong@hgst.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

This is a multi-part message in MIME format.
--------------000407060000000707030707
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit

On 1/21/16 9:18 PM, Jens Axboe wrote:
> On 01/21/2016 02:53 PM, Bruce Cran wrote:
>> Yeah, there's also a problem with strcasestr.c. I'm working on fixing
>> both problems just now.
>
> We'll just spin a 2.6 once that's fixed.

I've attached a patch that should fix it.  The removal of strcasestr.o 
is because I was getting a error saying strcasestr had already been defined.

-- 
Bruce

--------------000407060000000707030707
Content-Type: text/plain; charset=UTF-8; x-mac-type="0"; x-mac-creator="0";
 name="0001-Fix-Windows-build-define-MSG_DONTWAIT-and-avoid-dupl.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-Fix-Windows-build-define-MSG_DONTWAIT-and-avoid-dupl.pa";
 filename*1="tch"

From 6ab23ee572ee4ad9562318d9168293df177a5c59 Mon Sep 17 00:00:00 2001
From: Bruce Cran <bruce.cran@gmail.com>
Date: Fri, 22 Jan 2016 10:54:47 -0700
Subject: [PATCH] Fix Windows build: define MSG_DONTWAIT and avoid duplicate
 strcasestr definition

---
 Makefile        | 2 +-
 os/os-windows.h | 7 ++++++-
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index b6ebf2f..febc8f8 100644
--- a/Makefile
+++ b/Makefile
@@ -200,7 +200,7 @@ T_IEEE_PROGS = t/ieee754
 
 T_ZIPF_OBS = t/genzipf.o
 T_ZIPF_OBJS += t/log.o lib/ieee754.o lib/rand.o lib/pattern.o lib/zipf.o \
-		lib/strntol.o lib/gauss.o t/genzipf.o oslib/strcasestr.o
+		lib/strntol.o lib/gauss.o t/genzipf.o
 T_ZIPF_PROGS = t/fio-genzipf
 
 T_AXMAP_OBJS = t/axmap.o
diff --git a/os/os-windows.h b/os/os-windows.h
index 159c086..7305dd0 100644
--- a/os/os-windows.h
+++ b/os/os-windows.h
@@ -20,6 +20,11 @@
 
 #include "windows/posix.h"
 
+/* Cygwin doesn't define rand_r if C99 or newer is being used */
+#if defined(WIN32) && !defined(rand_r)
+int rand_r(unsigned *);
+#endif
+
 #ifndef PTHREAD_STACK_MIN
 #define PTHREAD_STACK_MIN 65535
 #endif
@@ -69,7 +74,7 @@ typedef DWORD_PTR os_cpu_mask_t;
 #define O_NONBLOCK		FIONBIO
 
 /* Winsock doesn't support MSG_WAIT */
-#define OS_MSG_DONTWAIT	0
+#define MSG_DONTWAIT 0
 
 #define POLLOUT	1
 #define POLLIN	2
-- 
2.5.2.windows.2


--------------000407060000000707030707--
