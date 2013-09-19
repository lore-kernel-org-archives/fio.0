Return-Path: <jcasse@chromium.org>
From: Juan Casse <jcasse@chromium.org>
Subject: [PATCH] Fixes bug: stale LAST_POS(f) is not being reset.
Date: Thu, 19 Sep 2013 14:07:56 -0700
Message-Id: <1379624876-27770-1-git-send-email-jcasse@chromium.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Grant Grundler <grundler@chromium.org>, fio@vger.kernel.org, Juan Casse <jcasse@chromium.org>
List-ID: <fio@vger.kernel.org>

Problem:
When running fio with ioengine=sync, LAST_POS(f) state is not
reset after the file is closed. This causes workloads with
readwrite=randread and loops > 1 to fail verification if the
state of LAST_POS(f) at the beginning of the next loop is the
same as the io_u->offset. If that is the case, lseek in not
invoked, but the file position is at 0 and not at io_u->offset.

Proposed Solution:
Other ioengines, such as binject and fusion-aw, set f->engine_data
to 0 when closing the file. The sync ioengin uses f->engine_data to
store the LAST_POS(f) state. The proposed solution is to set
f->engine_data = 0 when closing a file in generic_close_file().

Signed-off-by: Juan Casse <jcasse@chromium.org>
Reviewed-by: Grant Grundler <grundler@chromium.org>
---
 filesetup.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/filesetup.c b/filesetup.c
index 7d3a061..33b47c9 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -444,6 +444,7 @@ int generic_close_file(struct thread_data fio_unused *td, struct fio_file *f)
 		f->shadow_fd = -1;
 	}
 
+	f->engine_data = 0;
 	return ret;
 }
 
-- 
1.7.12.4


