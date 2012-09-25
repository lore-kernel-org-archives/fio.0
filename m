Return-Path: <rjevskiy@gmail.com>
Sender: Dmitry Monakhov <rjevskiy@gmail.com>
From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH] backend: fix data direction flow check
Date: Tue, 25 Sep 2012 14:00:24 +0400
Message-Id: <1348567224-22570-1-git-send-email-dmonakhov@openvz.org>
To: fio@vger.kernel.org
Cc: axboe@kernel.dk, Dmitry Monakhov <dmonakhov@openvz.org>
List-ID: <fio@vger.kernel.org>

This patch fix regression caused SIGSEGV in case of writeonly 
or readonly mode.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 backend.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/backend.c b/backend.c
index 88623be..c31d22a 100644
--- a/backend.c
+++ b/backend.c
@@ -812,7 +812,7 @@ static int init_io_u(struct thread_data *td)
 	td->orig_buffer_size = (unsigned long long) max_bs
 					* (unsigned long long) max_units;
 
-	if ((td->io_ops->flags & FIO_NOIO) || !td_rw(td))
+	if ((td->io_ops->flags & FIO_NOIO) || !(td_read(td) || td_write(td)))
 		data_xfer = 0;
 
 	if (td->o.mem_type == MEM_SHMHUGE || td->o.mem_type == MEM_MMAPHUGE) {
-- 
1.7.7.6


