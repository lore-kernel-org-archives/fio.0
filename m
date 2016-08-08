Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Subject: [PATCH 6/6] Check if sysfs ioscheduler entry is "none"
Date: Tue,  9 Aug 2016 02:27:31 +0900
Message-Id: <1470677251-8292-6-git-send-email-kusumi.tomohiro@gmail.com>
In-Reply-To: <1470677251-8292-1-git-send-email-kusumi.tomohiro@gmail.com>
References: <1470677251-8292-1-git-send-email-kusumi.tomohiro@gmail.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
List-ID: <fio@vger.kernel.org>

Block devices without elevator (bio-based-dm/loop/etc) have "none"
for sysfs ioscheduler tunable, and write to this entry never fail
from the way elv_iosched_store() is implemented.

This commit checks if the entry is "none" type so as not to show
an irrelevant error message which assumes the entry has a list of
available I/O schedulers.

 # cat /sys/block/dm-0/queue/scheduler
 none
 # echo deadline > /sys/block/dm-0/queue/scheduler ; echo $?
 0
 # cat /sys/block/dm-0/queue/scheduler
 none
 # echo aaa > /sys/block/dm-0/queue/scheduler ; echo $?
 0
 # cat /sys/block/dm-0/queue/scheduler
 none

Signed-off-by: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
---
 backend.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/backend.c b/backend.c
index 5872711..6bf5d67 100644
--- a/backend.c
+++ b/backend.c
@@ -1331,6 +1331,14 @@ static int switch_ioscheduler(struct thread_data *td)
 	 */
 	tmp[strlen(tmp) - 1] = '\0';
 
+	/*
+	 * Write to "none" entry doesn't fail, so check the result here.
+	 */
+	if (!strcmp(tmp, "none")) {
+		log_err("fio: io scheduler is not tunable\n");
+		fclose(f);
+		return 0;
+	}
 
 	sprintf(tmp2, "[%s]", td->o.ioscheduler);
 	if (!strstr(tmp, tmp2)) {
-- 
2.5.5


