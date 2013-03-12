Return-Path: <fio-owner@vger.kernel.org>
Received: from note.orchestra.cse.unsw.EDU.AU ([129.94.242.24]:42032 "EHLO
	note.orchestra.cse.unsw.EDU.AU" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751557Ab3CLEuM (ORCPT
	<rfc822;fio@vger.kernel.org>); Tue, 12 Mar 2013 00:50:12 -0400
Received: From
	[10.13.1.8] ([203.143.161.65] == vampire.ertos.nicta.com.au) (auth-user aaronc) (cse-authentic-sender aaronc)
	(for <fio@vger.kernel.org>) By note With Smtp ;
	Tue, 12 Mar 2013 15:50:08 +1100 
From: Aaron Carroll <aaronc@cse.unsw.edu.au>
Date: Tue, 12 Mar 2013 15:49:41 +1100
Message-ID: <513EB3E5.7020209@cse.unsw.edu.au>
MIME-Version: 1.0
Subject: [PATCH] Android: add ioprio support
Content-Type: multipart/mixed;
 boundary="------------070904000204030804020007"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

This is a multi-part message in MIME format.
--------------070904000204030804020007
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Also fix a build warning due to unused variable in some configs.

--------------070904000204030804020007
Content-Type: text/x-patch;
 name="Android-add-ioprio-support.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="Android-add-ioprio-support.patch"

From af503d22666a97623b8f85e07d6fefd9c232f1ee Mon Sep 17 00:00:00 2001
From: Aaron Carroll <aaronc@cse.unsw.edu.au>
Date: Tue, 12 Mar 2013 15:46:10 +1100
Subject: [PATCH 2/2] Android: add ioprio support

Also fix build warning due to unused variable in some configs.
---
 engines/net.c   |    6 ++++++
 os/os-android.h |   22 ++++++++++++++++++++++
 2 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/engines/net.c b/engines/net.c
index 624ff15..abb8412 100644
--- a/engines/net.c
+++ b/engines/net.c
@@ -490,6 +490,9 @@ static int fio_netio_connect(struct thread_data *td, struct fio_file *f)
 			return 1;
 		}
 	}
+#else
+	/* avoid warnings */
+	(void)optval;
 #endif
 
 	if (o->proto == FIO_TYPE_UDP)
@@ -553,6 +556,9 @@ static int fio_netio_accept(struct thread_data *td, struct fio_file *f)
 			return 1;
 		}
 	}
+#else
+	/* avoid warnings */
+	(void)optval;
 #endif
 
 	reset_all_stats(td);
diff --git a/os/os-android.h b/os/os-android.h
index cedfdaf..e8c64f3 100644
--- a/os/os-android.h
+++ b/os/os-android.h
@@ -19,6 +19,7 @@
 
 #define FIO_HAVE_DISK_UTIL
 #define FIO_HAVE_IOSCHED_SWITCH
+#define FIO_HAVE_IOPRIO
 #define FIO_HAVE_ODIRECT
 #define FIO_HAVE_HUGETLB
 #define FIO_HAVE_BLKTRACE
@@ -74,6 +75,27 @@ static inline int shmdt (const void *__shmaddr)
 
 #define SPLICE_DEF_SIZE	(64*1024)
 
+static inline int ioprio_set(int which, int who, int ioprio)
+{
+	return syscall(__NR_ioprio_set, which, who, ioprio);
+}
+
+enum {
+	IOPRIO_CLASS_NONE,
+	IOPRIO_CLASS_RT,
+	IOPRIO_CLASS_BE,
+	IOPRIO_CLASS_IDLE,
+};
+
+enum {
+	IOPRIO_WHO_PROCESS = 1,
+	IOPRIO_WHO_PGRP,
+	IOPRIO_WHO_USER,
+};
+
+#define IOPRIO_BITS		16
+#define IOPRIO_CLASS_SHIFT	13
+
 #ifndef BLKGETSIZE64
 #define BLKGETSIZE64	_IOR(0x12,114,size_t)
 #endif
-- 
1.7.0.4


--------------070904000204030804020007--
--:
To unsubscribe from this list: send the line "unsubscribe fio" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html


