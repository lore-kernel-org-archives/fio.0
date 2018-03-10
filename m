Return-Path: <prvs=60033e2b9=bart.vanassche@wdc.com>
From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH] helper_thread: Initialize all helper_data members before using it
Date: Fri,  9 Mar 2018 16:46:22 -0800
Message-Id: <20180310004622.5795-1-bart.vanassche@wdc.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org, Bart Van Assche <bart.vanassche@wdc.com>
List-ID: <fio@vger.kernel.org>

This patch avoids that Valgrind reports the following:

==10492== Thread 2:
==10492== Conditional jump or move depends on uninitialised value(s)
==10492==    at 0x480295: helper_thread_main (helper_thread.c:89)
==10492==    by 0x57B961A: start_thread (pthread_create.c:465)
==10492==    by 0x5CEC98E: clone (clone.S:95)

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
---
 helper_thread.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/helper_thread.c b/helper_thread.c
index 64e5a3c9d792..b05f8212a621 100644
--- a/helper_thread.c
+++ b/helper_thread.c
@@ -156,7 +156,7 @@ int helper_thread_create(struct fio_mutex *startup_mutex, struct sk_out *sk_out)
 	struct helper_data *hd;
 	int ret;
 
-	hd = smalloc(sizeof(*hd));
+	hd = scalloc(1, sizeof(*hd));
 
 	setup_disk_util();
 	steadystate_setup();
-- 
2.16.2


