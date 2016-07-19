Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Subject: [PATCH 4/7] Make I/O priority option generic for non-Linux environment [2/2]
Date: Wed, 20 Jul 2016 01:33:44 +0900
Message-Id: <1468946027-22580-4-git-send-email-kusumi.tomohiro@gmail.com>
In-Reply-To: <1468946027-22580-1-git-send-email-kusumi.tomohiro@gmail.com>
References: <1468946027-22580-1-git-send-email-kusumi.tomohiro@gmail.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
List-ID: <fio@vger.kernel.org>

There is a kernel that supports I/O priority with a syscall similar
to Linux (e.g. DragonFlyBSD's ioprio_set(2) which apparently seems
to have been inspired by ioprio_set(2) in Linux kernel), however
the idea of class within the syscall may not exist depending on the
I/O scheduler and its design, so "prioclass" option should be an
optional one for "prio" option.

This commit adds FIO_HAVE_IOPRIO_CLASS to separate "prioclass" from
"prio" on compile-time for those that do support priority itself,
but not priority classes.

If the platform supports I/O priority, it defines FIO_HAVE_IOPRIO
like it did before. If the platform supports I/O priority classes,
it defines FIO_HAVE_IOPRIO_CLASS in addition to above.
If FIO_HAVE_IOPRIO_CLASS is enabled, FIO_HAVE_IOPRIO must also be
enabled since FIO_HAVE_IOPRIO defines io_prioset(). This is also
checked on compile-time.

Linux (incl Android) has both of these macros enabled, so there is
no functional changes made by this commit.

Signed-off-by: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
---
 options.c       | 20 +++++++++++++-------
 os/os-android.h |  1 +
 os/os-linux.h   |  1 +
 3 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/options.c b/options.c
index d2a029d..4723e41 100644
--- a/options.c
+++ b/options.c
@@ -3018,6 +3018,18 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.category = FIO_OPT_C_GENERAL,
 		.group	= FIO_OPT_G_CRED,
 	},
+#else
+	{
+		.name	= "prio",
+		.lname	= "I/O nice priority",
+		.type	= FIO_OPT_UNSUPPORTED,
+		.help	= "Your platform does not support IO priorities",
+	},
+#endif
+#ifdef FIO_HAVE_IOPRIO_CLASS
+#ifndef FIO_HAVE_IOPRIO
+#error "FIO_HAVE_IOPRIO_CLASS requires FIO_HAVE_IOPRIO"
+#endif
 	{
 		.name	= "prioclass",
 		.lname	= "I/O nice priority class",
@@ -3032,16 +3044,10 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 	},
 #else
 	{
-		.name	= "prio",
-		.lname	= "I/O nice priority",
-		.type	= FIO_OPT_UNSUPPORTED,
-		.help	= "Your platform does not support IO priorities",
-	},
-	{
 		.name	= "prioclass",
 		.lname	= "I/O nice priority class",
 		.type	= FIO_OPT_UNSUPPORTED,
-		.help	= "Your platform does not support IO priorities",
+		.help	= "Your platform does not support IO priority classes",
 	},
 #endif
 	{
diff --git a/os/os-android.h b/os/os-android.h
index 9e3a3d2..70d0570 100644
--- a/os/os-android.h
+++ b/os/os-android.h
@@ -22,6 +22,7 @@
 #define FIO_HAVE_DISK_UTIL
 #define FIO_HAVE_IOSCHED_SWITCH
 #define FIO_HAVE_IOPRIO
+#define FIO_HAVE_IOPRIO_CLASS
 #define FIO_HAVE_ODIRECT
 #define FIO_HAVE_HUGETLB
 #define FIO_HAVE_BLKTRACE
diff --git a/os/os-linux.h b/os/os-linux.h
index a410497..937aade 100644
--- a/os/os-linux.h
+++ b/os/os-linux.h
@@ -25,6 +25,7 @@
 #define FIO_HAVE_DISK_UTIL
 #define FIO_HAVE_SGIO
 #define FIO_HAVE_IOPRIO
+#define FIO_HAVE_IOPRIO_CLASS
 #define FIO_HAVE_IOSCHED_SWITCH
 #define FIO_HAVE_ODIRECT
 #define FIO_HAVE_HUGETLB
-- 
2.5.5


