Return-Path: <fio-owner@vger.kernel.org>
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:18145 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727414AbeHXUGK (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 24 Aug 2018 16:06:10 -0400
From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH 04/11] Introduce the io_u.post_submit callback function pointer
Date: Fri, 24 Aug 2018 09:30:39 -0700
Message-Id: <20180824163046.12304-5-bart.vanassche@wdc.com>
In-Reply-To: <20180824163046.12304-1-bart.vanassche@wdc.com>
References: <20180824163046.12304-1-bart.vanassche@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>, Bart Van Assche <bart.vanassche@wdc.com>

This patch does not change any functionality. The code introduced by
this patch will be used by the zoned block device code.

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
---
 io_u.c      | 10 ++++++++++
 io_u.h      |  6 ++++++
 ioengines.c |  4 ++++
 3 files changed, 20 insertions(+)

diff --git a/io_u.c b/io_u.c
index e050d9f7c775..29a360a95424 100644
--- a/io_u.c
+++ b/io_u.c
@@ -761,6 +761,11 @@ void put_file_log(struct thread_data *td, struct fio_file *f)
 
 void put_io_u(struct thread_data *td, struct io_u *io_u)
 {
+	if (io_u->post_submit) {
+		io_u->post_submit(io_u, io_u->error == 0);
+		io_u->post_submit = NULL;
+	}
+
 	if (td->parent)
 		td = td->parent;
 
@@ -1304,6 +1309,11 @@ static long set_io_u_file(struct thread_data *td, struct io_u *io_u)
 		if (!fill_io_u(td, io_u))
 			break;
 
+		if (io_u->post_submit) {
+			io_u->post_submit(io_u, false);
+			io_u->post_submit = NULL;
+		}
+
 		put_file_log(td, f);
 		td_io_close_file(td, f);
 		io_u->file = NULL;
diff --git a/io_u.h b/io_u.h
index 2e0fd3fe789b..97270c94d171 100644
--- a/io_u.h
+++ b/io_u.h
@@ -92,6 +92,12 @@ struct io_u {
 		struct workqueue_work work;
 	};
 
+	/*
+	 * Post-submit callback. Used by the ZBD code. @success == true means
+	 * that the I/O operation has been queued or completed successfully.
+	 */
+	void (*post_submit)(const struct io_u *, bool success);
+
 	/*
 	 * Callback for io completion
 	 */
diff --git a/ioengines.c b/ioengines.c
index 433da604ae4a..1821916112cc 100644
--- a/ioengines.c
+++ b/ioengines.c
@@ -319,6 +319,10 @@ enum fio_q_status td_io_queue(struct thread_data *td, struct io_u *io_u)
 	}
 
 	ret = td->io_ops->queue(td, io_u);
+	if (ret != FIO_Q_BUSY && io_u->post_submit) {
+		io_u->post_submit(io_u, io_u->error == 0);
+		io_u->post_submit = NULL;
+	}
 
 	unlock_file(td, io_u->file);
 
-- 
2.18.0


