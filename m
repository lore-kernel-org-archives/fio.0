Return-Path: <fio-owner@vger.kernel.org>
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:50637 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751983AbaD3J0H (ORCPT
	<rfc822;fio@vger.kernel.org>); Wed, 30 Apr 2014 05:26:07 -0400
From: Daniel Gollub <d.gollub@telekom.de>
Subject: [PATCH] Rename time.h for third-party include of fio.h
Date: Wed, 30 Apr 2014 11:25:04 +0200
Message-Id: <1398849904-6013-2-git-send-email-d.gollub@telekom.de>
In-Reply-To: <1398849904-6013-1-git-send-email-d.gollub@telekom.de>
References: <1398849904-6013-1-git-send-email-d.gollub@telekom.de>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: Daniel Gollub <d.gollub@telekom.de>, Daniel Gollub <daniel.gollub@t-online.de>

External project might build external ioengines and need to
include there for fio.h. If a project set the include path
to the fio root source directory and the third-party source
holds an "time.h" as well things get complicated.

Signed-off-by: Daniel Gollub <d.gollub@telekom.de>
Cc: Daniel Gollub <daniel.gollub@t-online.de>
---
 fio.h      |    2 +-
 fio_time.h |   19 +++++++++++++++++++
 mutex.c    |    2 +-
 time.h     |   19 -------------------
 4 files changed, 21 insertions(+), 21 deletions(-)
 create mode 100644 fio_time.h
 delete mode 100644 time.h

diff --git a/fio.h b/fio.h
index 9eecba3..ed034cb 100644
--- a/fio.h
+++ b/fio.h
@@ -30,7 +30,7 @@
 #include "helpers.h"
 #include "options.h"
 #include "profile.h"
-#include "time.h"
+#include "fio_time.h"
 #include "gettime.h"
 #include "lib/getopt.h"
 #include "lib/rand.h"
diff --git a/fio_time.h b/fio_time.h
new file mode 100644
index 0000000..c550a55
--- /dev/null
+++ b/fio_time.h
@@ -0,0 +1,19 @@
+#ifndef FIO_TIME_H
+#define FIO_TIME_H
+
+extern uint64_t utime_since(struct timeval *, struct timeval *);
+extern uint64_t utime_since_now(struct timeval *);
+extern uint64_t mtime_since(struct timeval *, struct timeval *);
+extern uint64_t mtime_since_now(struct timeval *);
+extern uint64_t time_since_now(struct timeval *);
+extern uint64_t mtime_since_genesis(void);
+extern uint64_t utime_since_genesis(void);
+extern void usec_spin(unsigned int);
+extern void usec_sleep(struct thread_data *, unsigned long);
+extern void fill_start_time(struct timeval *);
+extern void set_genesis_time(void);
+extern int ramp_time_over(struct thread_data *);
+extern int in_ramp_time(struct thread_data *);
+extern void fio_time_init(void);
+
+#endif
diff --git a/mutex.c b/mutex.c
index 466e20e..9d10c2c 100644
--- a/mutex.c
+++ b/mutex.c
@@ -15,7 +15,7 @@
 #include "arch/arch.h"
 #include "os/os.h"
 #include "helpers.h"
-#include "time.h"
+#include "fio_time.h"
 #include "gettime.h"
 
 void fio_mutex_remove(struct fio_mutex *mutex)
diff --git a/time.h b/time.h
deleted file mode 100644
index c550a55..0000000
--- a/time.h
+++ /dev/null
@@ -1,19 +0,0 @@
-#ifndef FIO_TIME_H
-#define FIO_TIME_H
-
-extern uint64_t utime_since(struct timeval *, struct timeval *);
-extern uint64_t utime_since_now(struct timeval *);
-extern uint64_t mtime_since(struct timeval *, struct timeval *);
-extern uint64_t mtime_since_now(struct timeval *);
-extern uint64_t time_since_now(struct timeval *);
-extern uint64_t mtime_since_genesis(void);
-extern uint64_t utime_since_genesis(void);
-extern void usec_spin(unsigned int);
-extern void usec_sleep(struct thread_data *, unsigned long);
-extern void fill_start_time(struct timeval *);
-extern void set_genesis_time(void);
-extern int ramp_time_over(struct thread_data *);
-extern int in_ramp_time(struct thread_data *);
-extern void fio_time_init(void);
-
-#endif
-- 
1.7.10.4

