Return-Path: <fio-owner@vger.kernel.org>
Received: from smtp.eu.citrix.com ([62.200.22.115]:57947 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753325Ab2IZJNd (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 26 Sep 2012 05:13:33 -0400
From: Roger Pau Monne <roger.pau@citrix.com>
Subject: [PATCH] netbsd: fix gettid
Date: Wed, 26 Sep 2012 10:13:23 +0100
Message-ID: <1348650803-92011-1-git-send-email-roger.pau@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: Roger Pau Monne <roger.pau@citrix.com>

Signed-off-by: Roger Pau Monne <roger.pau@citrix.com>
---
 os/os-netbsd.h |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/os/os-netbsd.h b/os/os-netbsd.h
index aef578e..de687ba 100644
--- a/os/os-netbsd.h
+++ b/os/os-netbsd.h
@@ -4,8 +4,8 @@
 #define	FIO_OS	os_netbsd
 
 #include <errno.h>
+#include <lwp.h>
 #include <sys/param.h>
-#include <sys/thr.h>
 #include <sys/endian.h>
 /* XXX hack to avoid confilcts between rbtree.h and <sys/rb.h> */
 #define	rb_node	_rb_node
@@ -63,10 +63,7 @@ static inline unsigned long long os_phys_mem(void)
 
 static inline int gettid(void)
 {
-	long lwpid;
-
-	thr_self(&lwpid);
-	return (int) lwpid;
+	return (int) _lwp_self();
 }
 
 #ifdef MADV_FREE
-- 
1.7.7.5 (Apple Git-26)

