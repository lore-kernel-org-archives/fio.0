Return-Path: <jkbs@redhat.com>
Return-Path: <jkbs@redhat.com>
From: Jakub Sitnicki <jkbs@redhat.com>
Subject: [PATCH] Change misleading error message for invalid size= value
Date: Tue, 13 Dec 2016 17:27:24 +0100
Message-Id: <1481646444-2288-1-git-send-email-jkbs@redhat.com>
To: fio@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

The error message refers to the IO size, yet another parameter, but we
actually compare the size parameter value against the block size.

Change the message to reflect the code, and make it easier for the user
to see what values are we comparing.

Signed-off-by: Jakub Sitnicki <jkbs@redhat.com>
---
 init.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/init.c b/init.c
index 382fa1f..36feb51 100644
--- a/init.c
+++ b/init.c
@@ -822,7 +822,8 @@ static int fixup_options(struct thread_data *td)
 	 * If size is set but less than the min block size, complain
 	 */
 	if (o->size && o->size < td_min_bs(td)) {
-		log_err("fio: size too small, must be larger than the IO size: %llu\n", (unsigned long long) o->size);
+		log_err("fio: size too small, must not be less than minimum block size: %llu < %u\n",
+			(unsigned long long) o->size, td_min_bs(td));
 		ret = 1;
 	}
 
-- 
2.7.4


