Return-Path: <rjevskiy@gmail.com>
Sender: Dmitry Monakhov <rjevskiy@gmail.com>
From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH] core: Actually EIO is a fatal error
Date: Fri, 21 Sep 2012 15:04:16 +0400
Message-Id: <1348225456-21811-1-git-send-email-dmonakhov@openvz.org>
To: fio@vger.kernel.org
Cc: axboe@kernel.dk, Dmitry Monakhov <dmonakhov@openvz.org>
List-ID: <fio@vger.kernel.org>

As soon as i understand this is just a mistype.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fio.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fio.h b/fio.h
index b2bbe93..f6f9792 100644
--- a/fio.h
+++ b/fio.h
@@ -559,7 +559,7 @@ static inline void fio_ro_check(struct thread_data *td, struct io_u *io_u)
 
 #define REAL_MAX_JOBS		2048
 
-#define td_non_fatal_error(e)	((e) == EIO || (e) == EILSEQ)
+#define td_non_fatal_error(e)	(!((e) == EIO || (e) == EILSEQ))
 
 static inline enum error_type td_error_type(enum fio_ddir ddir, int err)
 {
-- 
1.7.7.6


