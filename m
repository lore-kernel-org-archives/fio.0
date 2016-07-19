Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Subject: [PATCH 3/7] Make I/O priority option generic for non-Linux environment [1/2]
Date: Wed, 20 Jul 2016 01:33:43 +0900
Message-Id: <1468946027-22580-3-git-send-email-kusumi.tomohiro@gmail.com>
In-Reply-To: <1468946027-22580-1-git-send-email-kusumi.tomohiro@gmail.com>
References: <1468946027-22580-1-git-send-email-kusumi.tomohiro@gmail.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
List-ID: <fio@vger.kernel.org>

There is a kernel that supports I/O priority with a syscall similar
to Linux (e.g. DragonFlyBSD's ioprio_set(2) which apparently seems
to have been inspired by ioprio_set(2) in Linux kernel), however
min/max value of the priority may differ, so use OS specific macros
instead of hardcoded values that are designed to work on Linux.

This commit adds IOPRIO_MIN|MAX_PRIO and IOPRIO_MIN|MAX_PRIO_CLASS
to Linux (incl Android), but no functional changes.

Signed-off-by: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
---
 options.c       | 8 ++++----
 os/os-android.h | 6 ++++++
 os/os-linux.h   | 6 ++++++
 3 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/options.c b/options.c
index 5199823..d2a029d 100644
--- a/options.c
+++ b/options.c
@@ -3012,8 +3012,8 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.type	= FIO_OPT_INT,
 		.off1	= td_var_offset(ioprio),
 		.help	= "Set job IO priority value",
-		.minval	= 0,
-		.maxval	= 7,
+		.minval	= IOPRIO_MIN_PRIO,
+		.maxval	= IOPRIO_MAX_PRIO,
 		.interval = 1,
 		.category = FIO_OPT_C_GENERAL,
 		.group	= FIO_OPT_G_CRED,
@@ -3024,8 +3024,8 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.type	= FIO_OPT_INT,
 		.off1	= td_var_offset(ioprio_class),
 		.help	= "Set job IO priority class",
-		.minval	= 0,
-		.maxval	= 3,
+		.minval	= IOPRIO_MIN_PRIO_CLASS,
+		.maxval	= IOPRIO_MAX_PRIO_CLASS,
 		.interval = 1,
 		.category = FIO_OPT_C_GENERAL,
 		.group	= FIO_OPT_G_CRED,
diff --git a/os/os-android.h b/os/os-android.h
index 1699539..9e3a3d2 100644
--- a/os/os-android.h
+++ b/os/os-android.h
@@ -140,6 +140,12 @@ enum {
 #define IOPRIO_BITS		16
 #define IOPRIO_CLASS_SHIFT	13
 
+#define IOPRIO_MIN_PRIO		0	/* highest priority */
+#define IOPRIO_MAX_PRIO		7	/* lowest priority */
+
+#define IOPRIO_MIN_PRIO_CLASS	0
+#define IOPRIO_MAX_PRIO_CLASS	3
+
 static inline int ioprio_set(int which, int who, int ioprio_class, int ioprio)
 {
 	/*
diff --git a/os/os-linux.h b/os/os-linux.h
index b36d33c..a410497 100644
--- a/os/os-linux.h
+++ b/os/os-linux.h
@@ -96,6 +96,12 @@ enum {
 #define IOPRIO_BITS		16
 #define IOPRIO_CLASS_SHIFT	13
 
+#define IOPRIO_MIN_PRIO		0	/* highest priority */
+#define IOPRIO_MAX_PRIO		7	/* lowest priority */
+
+#define IOPRIO_MIN_PRIO_CLASS	0
+#define IOPRIO_MAX_PRIO_CLASS	3
+
 static inline int ioprio_set(int which, int who, int ioprio_class, int ioprio)
 {
 	/*
-- 
2.5.5


