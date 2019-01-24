Return-Path: <vincentfu@gmail.com>
Return-Path: <vincentfu@gmail.com>
From: vincentfu@gmail.com
Subject: [PATCH] rate-submit: call ioengine post_init when starting workers
Date: Thu, 24 Jan 2019 14:26:42 -0500
Message-Id: <20190124192642.18727-1-vincentfu@gmail.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Vincent Fu <vincent.fu@wdc.com>
List-ID: <fio@vger.kernel.org>

From: Vincent Fu <vincent.fu@wdc.com>

ioengines with post_init steps were not fully fully initialized by
offload worker threads because the post_init function was never called.

Without this patch all libaio operations submitted in offload mode fail
because the ioengine was not fully initialized.

Fixes: 2041bd343da1 ("engines/libaio: add preliminary support for pre-mapped IO buffers")
---
 rate-submit.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/rate-submit.c b/rate-submit.c
index b07a2072..cf00d9bc 100644
--- a/rate-submit.c
+++ b/rate-submit.c
@@ -165,6 +165,9 @@ static int io_workqueue_init_worker_fn(struct submit_worker *sw)
 	if (td_io_init(td))
 		goto err_io_init;
 
+	if (td->io_ops->post_init && td->io_ops->post_init(td))
+		goto err_io_init;
+
 	set_epoch_time(td, td->o.log_unix_epoch);
 	fio_getrusage(&td->ru_start);
 	clear_io_state(td, 1);
-- 
2.17.1


