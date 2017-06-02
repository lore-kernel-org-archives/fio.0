Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 1/2] use true/false for bool type
Date: Fri,  2 Jun 2017 22:21:26 +0300
Message-Id: <20170602192127.6930-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 init.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/init.c b/init.c
index d224bd6..2b7768a 100644
--- a/init.c
+++ b/init.c
@@ -909,9 +909,9 @@ void td_fill_verify_state_seed(struct thread_data *td)
 	bool use64;
 
 	if (td->o.random_generator == FIO_RAND_GEN_TAUSWORTHE64)
-		use64 = 1;
+		use64 = true;
 	else
-		use64 = 0;
+		use64 = false;
 
 	init_rand_seed(&td->verify_state, td->rand_seeds[FIO_RAND_VER_OFF],
 		use64);
@@ -967,9 +967,9 @@ void td_fill_rand_seeds(struct thread_data *td)
 	}
 
 	if (td->o.random_generator == FIO_RAND_GEN_TAUSWORTHE64)
-		use64 = 1;
+		use64 = true;
 	else
-		use64 = 0;
+		use64 = false;
 
 	td_fill_rand_seeds_internal(td, use64);
 
-- 
2.9.4


