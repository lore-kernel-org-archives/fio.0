Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Subject: [PATCH 2/4] Make switch_ioscheduler() return 0 if FIO_HAVE_IOSCHED_SWITCH is undefined
Date: Sat, 30 Jul 2016 00:05:58 +0900
Message-Id: <1469804760-17333-2-git-send-email-kusumi.tomohiro@gmail.com>
In-Reply-To: <1469804760-17333-1-git-send-email-kusumi.tomohiro@gmail.com>
References: <1469804760-17333-1-git-send-email-kusumi.tomohiro@gmail.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
List-ID: <fio@vger.kernel.org>

Defining FIO_HAVE_IOSCHED_SWITCH currently equals saying it's Linux,
as switch_ioscheduler() only works on Linux kernel with "scheduler"
sysfs entry (though read/write to sysfs obviously compiles on others).

This commit makes the function return 0 if FIO_HAVE_IOSCHED_SWITCH
is undefined (i.e. if not Linux). This is essentially the same as
{diskutil,cgroup,blktrace}.c being compiled only on Linux.

Signed-off-by: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
---
 backend.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/backend.c b/backend.c
index ad2d7da..2f290d2 100644
--- a/backend.c
+++ b/backend.c
@@ -1261,6 +1261,7 @@ static int init_io_u(struct thread_data *td)
 
 static int switch_ioscheduler(struct thread_data *td)
 {
+#ifdef FIO_HAVE_IOSCHED_SWITCH
 	char tmp[256], tmp2[128];
 	FILE *f;
 	int ret;
@@ -1319,6 +1320,9 @@ static int switch_ioscheduler(struct thread_data *td)
 
 	fclose(f);
 	return 0;
+#else
+	return 0;
+#endif
 }
 
 static bool keep_running(struct thread_data *td)
-- 
1.7.1


