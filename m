Return-Path: <gwendal@google.com>
Return-Path: <gwendal@google.com>
From: Gwendal Grignou <gwendal@chromium.org>
Subject: [PATCH] verify: Fix latency log for verify commands.
Date: Sun,  8 Feb 2015 19:53:20 -0800
Message-Id: <1423454000-7730-1-git-send-email-gwendal@chromium.org>
To: axboe@kernel.dk
Cc: fio@vger.kernel.org, Gwendal Grignou <gwendal@chromium.org>
List-ID: <fio@vger.kernel.org>

When commands when requeued for the verify operation,
their start time was not reset, resulting in bogus latency graphs.

Signed-off-by: Gwendal Grignou <gwendal@chromium.org>
---
 backend.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/backend.c b/backend.c
index 7ec8d2a..0f6e425 100644
--- a/backend.c
+++ b/backend.c
@@ -565,6 +565,8 @@ static void do_verify(struct thread_data *td, uint64_t verify_bytes)
 			io_u->end_io = verify_io_u;
 
 		ddir = io_u->ddir;
+		if (!td->o.disable_slat)
+			fio_gettime(&io_u->start_time, NULL);
 
 		ret = td_io_queue(td, io_u);
 		switch (ret) {
-- 
2.2.0.rc0.207.ga3a616c


